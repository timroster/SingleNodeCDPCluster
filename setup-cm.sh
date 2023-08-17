echo "-- Start CM, it takes about 2 minutes to be ready"
systemctl start cloudera-scm-server

while [ `curl -s -X GET -u "admin:admin"  http://localhost:7180/api/version` -z ] ;
    do
    echo "waiting 10s for CM to come up..";
    sleep 10;
done

echo "-- Now CM is started and the next step is to automate using the CM API"

wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python ./get-pip.py
pip install --upgrade cm_client
#pip install --upgrade pip cm_client
echo "-- Kicking off install from ${start_dir}"
cd ${start_dir}
sed -i "s/YourHostname/`hostname -f`/g" $TEMPLATE
#sed -i "s/YourCDSWDomain/cdsw.$PUBLIC_IP.nip.io/g" $TEMPLATE
sed -i "s/YourPrivateIP/`hostname -I | tr -d '[:space:]'`/g" $TEMPLATE
#sed -i "s#YourDockerDevice#$DOCKERDEVICE#g" $TEMPLATE

sed -i "s/YourHostname/`hostname -f`/g" scripts/create_cluster.py

python scripts/create_cluster.py $TEMPLATE


