Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYA2JPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYA2JPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbYA2JOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:14:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53259 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbYA2JOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:14:34 -0500
Date: Tue, 29 Jan 2008 01:14:32 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH 2/2] ibmpex: Add energy consumption meters
Message-ID: <20080129091431.GJ2549@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the ibmpex driver to report system energy consumption data.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmpex.c |  135 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 127 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 9c9cdb0..8cc4262 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -35,9 +35,24 @@
 #define PEX_RESET_HIGH_LOW	4
 #define PEX_GET_SENSOR_DATA	6
 
+#define IBMPEX_TYPE_1		1
 #define PEX_NET_FUNCTION	0x3A
 #define PEX_COMMAND		0x3C
 
+#define IBMPEX_TYPE_2		2
+#define AEM_NET_FUNCTION	0x2E
+#define AEM_RUN_METHOD_COMMAND	0x81
+#define AEM_IANA_NUMBER_0	0x02
+#define AEM_READ_ELEMENT_REG	0x82
+
+#define AEM_ENERGY_REGISTER	0x01
+#define NUM_ENERGY_REGS		1
+
+static inline u64 extract_value64(const char *data, int offset)
+{
+	return be64_to_cpup((u64 *)&data[offset]);
+}
+
 static inline u16 extract_value(const char *data, int offset)
 {
 	return be16_to_cpup((u16 *)&data[offset]);
@@ -104,6 +119,9 @@ struct ibmpex_bmc_data {
 
 	unsigned char		num_sensors;
 	struct ibmpex_sensor_data	*sensors;
+
+	u64			energy[NUM_ENERGY_REGS];
+	struct sensor_device_attribute	energy_attr[NUM_ENERGY_REGS];
 };
 
 struct ibmpex_driver_data {
@@ -124,10 +142,23 @@ static struct ibmpex_driver_data driver_data = {
 	},
 };
 
-static int ibmpex_send_message(struct ibmpex_bmc_data *data)
+static int ibmpex_send_message(struct ibmpex_bmc_data *data, int type)
 {
 	int err;
 
+	switch (type) {
+	case IBMPEX_TYPE_1:
+		data->tx_message.netfn = PEX_NET_FUNCTION;
+		data->tx_message.cmd = PEX_COMMAND;
+		break;
+	case IBMPEX_TYPE_2:
+		data->tx_message.netfn = AEM_NET_FUNCTION;
+		data->tx_message.cmd = AEM_RUN_METHOD_COMMAND;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	err = ipmi_validate_addr(&data->address, sizeof(data->address));
 	if (err)
 		goto out;
@@ -151,7 +182,7 @@ static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
 {
 	data->tx_msg_data[0] = PEX_GET_VERSION;
 	data->tx_message.data_len = 1;
-	ibmpex_send_message(data);
+	ibmpex_send_message(data, IBMPEX_TYPE_1);
 
 	wait_for_completion(&data->read_complete);
 
@@ -177,7 +208,7 @@ static int ibmpex_query_sensor_count(struct ibmpex_bmc_data *data)
 {
 	data->tx_msg_data[0] = PEX_GET_SENSOR_COUNT;
 	data->tx_message.data_len = 1;
-	ibmpex_send_message(data);
+	ibmpex_send_message(data, IBMPEX_TYPE_1);
 
 	wait_for_completion(&data->read_complete);
 
@@ -192,7 +223,7 @@ static int ibmpex_query_sensor_name(struct ibmpex_bmc_data *data, int sensor)
 	data->tx_msg_data[0] = PEX_GET_SENSOR_NAME;
 	data->tx_msg_data[1] = sensor;
 	data->tx_message.data_len = 2;
-	ibmpex_send_message(data);
+	ibmpex_send_message(data, IBMPEX_TYPE_1);
 
 	wait_for_completion(&data->read_complete);
 
@@ -207,7 +238,7 @@ static int ibmpex_query_sensor_data(struct ibmpex_bmc_data *data, int sensor)
 	data->tx_msg_data[0] = PEX_GET_SENSOR_DATA;
 	data->tx_msg_data[1] = sensor;
 	data->tx_message.data_len = 2;
-	ibmpex_send_message(data);
+	ibmpex_send_message(data, IBMPEX_TYPE_1);
 
 	wait_for_completion(&data->read_complete);
 
@@ -220,11 +251,36 @@ static int ibmpex_query_sensor_data(struct ibmpex_bmc_data *data, int sensor)
 	return 0;
 }
 
+static int ibmpex_query_energy_data(struct ibmpex_bmc_data *data, int sensor)
+{
+	data->tx_msg_data[0] = AEM_IANA_NUMBER_0;
+	data->tx_msg_data[1] = 0x00;
+	data->tx_msg_data[2] = 0x00;
+	data->tx_msg_data[3] = 0x00;
+	data->tx_msg_data[4] = AEM_ENERGY_REGISTER;
+	data->tx_msg_data[5] = AEM_READ_ELEMENT_REG;
+	data->tx_msg_data[6] = sensor;
+	data->tx_msg_data[7] = 0x08;
+	data->tx_message.data_len = 8;
+
+	ibmpex_send_message(data, IBMPEX_TYPE_2);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len != 11) {
+		dev_err(data->bmc_device, "Error reading sensor %d.\n",
+			sensor);
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
 static int ibmpex_reset_high_low_data(struct ibmpex_bmc_data *data)
 {
 	data->tx_msg_data[0] = PEX_RESET_HIGH_LOW;
 	data->tx_message.data_len = 1;
-	ibmpex_send_message(data);
+	ibmpex_send_message(data, IBMPEX_TYPE_1);
 
 	wait_for_completion(&data->read_complete);
 
@@ -240,6 +296,13 @@ static void ibmpex_update_device(struct ibmpex_bmc_data *data)
 	    data->valid)
 		goto out;
 
+	for (i = 0; i < NUM_ENERGY_REGS; i++) {
+		err = ibmpex_query_energy_data(data, i);
+		if (err)
+			continue;
+		data->energy[i] = extract_value64(data->rx_msg_data, 3);
+	}
+
 	for (i = 0; i < data->num_sensors; i++) {
 		if (!data->sensors[i].in_use)
 			continue;
@@ -279,6 +342,17 @@ static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
 }
 static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
 
+static ssize_t ibmpex_show_energy(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct ibmpex_bmc_data *data = dev_get_drvdata(dev);
+	ibmpex_update_device(data);
+
+	return sprintf(buf, "%llu000\n", data->energy[attr->index]);
+}
+
 static ssize_t ibmpex_show_sensor(struct device *dev,
 				  struct device_attribute *devattr,
 				  char *buf)
@@ -338,6 +412,33 @@ static int power_sensor_multiplier(const char *sensor_id, int len)
 	return 100000;
 }
 
+static int create_energy_sensor(struct ibmpex_bmc_data *data, int sensor)
+{
+	int err;
+	char *n;
+
+	n = kmalloc(32, GFP_KERNEL);
+	if (!n)
+		return -ENOMEM;
+
+	sprintf(n, "energy%d_input", sensor);
+
+	data->energy_attr[sensor].dev_attr.attr.name = n;
+	data->energy_attr[sensor].dev_attr.attr.mode = S_IRUGO;
+	data->energy_attr[sensor].dev_attr.show = ibmpex_show_energy;
+	data->energy_attr[sensor].index = sensor;
+
+	err = device_create_file(data->bmc_device,
+				 &data->energy_attr[sensor].dev_attr);
+	if (err) {
+		data->energy_attr[sensor].dev_attr.attr.name = NULL;
+		kfree(n);
+		return err;
+	}
+
+	return 0;
+}
+
 static int create_sensor(struct ibmpex_bmc_data *data, int type,
 			 int counter, int sensor, int func)
 {
@@ -420,6 +521,12 @@ static int ibmpex_find_sensors(struct ibmpex_bmc_data *data)
 		}
 	}
 
+	for (i = 0; i < NUM_ENERGY_REGS; i++) {
+		err = create_energy_sensor(data, i);
+		if (err)
+			goto exit_remove;
+	}
+
 	err = device_create_file(data->bmc_device,
 			&sensor_dev_attr_reset_high_low.dev_attr);
 	if (err)
@@ -436,6 +543,13 @@ exit_remove:
 	device_remove_file(data->bmc_device,
 			   &sensor_dev_attr_reset_high_low.dev_attr);
 	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
+	for (i = 0; i < NUM_ENERGY_REGS; i++) {
+		if (!data->energy_attr[i].dev_attr.attr.name)
+			continue;
+		device_remove_file(data->bmc_device,
+			&data->energy_attr[i].dev_attr);
+		kfree(data->energy_attr[i].dev_attr.attr.name);
+	}
 	for (i = 0; i < data->num_sensors; i++)
 		for (j = 0; j < PEX_NUM_SENSOR_FUNCS; j++) {
 			if (!data->sensors[i].attr[j].dev_attr.attr.name)
@@ -480,8 +594,6 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	/* Initialize message */
 	data->tx_msgid = 0;
 	init_completion(&data->read_complete);
-	data->tx_message.netfn = PEX_NET_FUNCTION;
-	data->tx_message.cmd = PEX_COMMAND;
 	data->tx_message.data = data->tx_msg_data;
 
 	/* Does this BMC support PowerExecutive? */
@@ -527,6 +639,13 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 	device_remove_file(data->bmc_device,
 			   &sensor_dev_attr_reset_high_low.dev_attr);
 	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
+	for (i = 0; i < NUM_ENERGY_REGS; i++) {
+		if (!data->energy_attr[i].dev_attr.attr.name)
+			continue;
+		device_remove_file(data->bmc_device,
+			&data->energy_attr[i].dev_attr);
+		kfree(data->energy_attr[i].dev_attr.attr.name);
+	}
 	for (i = 0; i < data->num_sensors; i++)
 		for (j = 0; j < PEX_NUM_SENSOR_FUNCS; j++) {
 			if (!data->sensors[i].attr[j].dev_attr.attr.name)
