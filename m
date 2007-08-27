Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXH0VZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXH0VZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbXH0VPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:15:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40829 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763040AbXH0VO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:58 -0400
Date: Mon, 27 Aug 2007 14:14:47 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] v1 of IBM power meter driver
Message-ID: <20070827211446.GG32667@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Attached is a driver to export sensor readings from power meters that
are found in several IBM x86 systems.  At the moment, the hwmon sysfs
documentation doesn't mention any naming conventions for sensors that
measure Watts, so I am proposing that they be called "powerX_input" in a
fashion similar to temperature/rpm/current sensors.  If that is
agreeable to everyone, I'll post a follow-up patch to amend the
documentation.

The patch should apply against 2.6.23-rc3 and has been tested on the
x3550, x3650, x3655, x3755 and HS20 blades that support it.  As far
as I know, those are the only systems in existence that have this
interface.
---
ibm_pex: Driver to export IBM PowerExecutive power meter sensors.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/Kconfig  |   12 +
 drivers/hwmon/Makefile |    1=20
 drivers/hwmon/ibmpex.c |  615 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 628 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 555f470..41ffa2e 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -275,6 +275,18 @@ config SENSORS_CORETEMP
 	  sensor inside your CPU. Supported all are all known variants
 	  of Intel Core family.
=20
+config SENSORS_IBMPEX
+	tristate "IBM PowerExecutive temperature/power sensors"
+	depends on IPMI_SI
+	help
+	  If you say yes here you get support for the temperature and
+	  power sensors in various IBM System X servers that support
+	  PowerExecutive.  So far this includes the x3550, x3650, x3655,
+	  x3755, and certain HS20 blades.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ibmpex.
+
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	select HWMON_VID
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index a133981..31da6fe 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_SENSORS_FSCPOS)	+=3D fscpos.o
 obj-$(CONFIG_SENSORS_GL518SM)	+=3D gl518sm.o
 obj-$(CONFIG_SENSORS_GL520SM)	+=3D gl520sm.o
 obj-$(CONFIG_SENSORS_HDAPS)	+=3D hdaps.o
+obj-$(CONFIG_SENSORS_IBMPEX)	+=3D ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+=3D it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+=3D k8temp.o
 obj-$(CONFIG_SENSORS_LM63)	+=3D lm63.o
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
new file mode 100644
index 0000000..15ae9ec
--- /dev/null
+++ b/drivers/hwmon/ibmpex.c
@@ -0,0 +1,615 @@
+/*
+ * A hwmon driver for the IBM PowerExecutive temperature/power sensors
+ * Copyright (C) 2007 IBM
+ *
+ * Author: Darrick J. Wong <djwong@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
+ */
+
+#include <linux/ipmi.h>
+#include <linux/module.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mutex.h>
+
+#define REFRESH_INTERVAL	(5 * HZ)
+#define DRVNAME			"ibmpex"
+
+static void ibmpex_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_d=
ata);
+static void ibmpex_register_bmc(int iface, struct device *dev);
+static void ibmpex_bmc_gone(int iface);
+
+struct ibmpex_sensor_data {
+	int			in_use;
+	s16			value;
+	s16			max;
+	s16			min;
+	int			divisor;
+
+	struct sensor_device_attribute	attr_value;
+	struct sensor_device_attribute	attr_max;
+	struct sensor_device_attribute	attr_min;
+};
+
+struct ibmpex_bmc_data {
+	struct list_head	list;
+	struct class_device	*class_dev;
+	struct device		*bmc_device;
+	struct mutex		lock;
+	char			valid;
+	unsigned long		last_updated;	/* In jiffies */
+
+	struct ipmi_addr	address;
+	struct completion	read_complete;
+	ipmi_user_t		user;
+	int			interface;
+
+	struct kernel_ipmi_msg	tx_message;
+	unsigned char		tx_msg_data[IPMI_MAX_MSG_LENGTH];
+	long			tx_msgid;
+
+	unsigned char		rx_msg_data[IPMI_MAX_MSG_LENGTH];
+	unsigned long		rx_msg_len;
+	unsigned char		rx_result;
+	int			rx_recv_type;
+
+	unsigned char		sensor_major;
+	unsigned char		sensor_minor;
+
+	unsigned char		num_sensors;
+	struct ibmpex_sensor_data	*sensors;
+};
+
+struct ibmpex_driver_data {
+	struct list_head	bmc_data;
+	struct ipmi_smi_watcher	bmc_events;
+	struct ipmi_user_hndl	ipmi_hndlrs;
+};
+
+static struct ibmpex_driver_data driver_data =3D {
+	.bmc_data =3D LIST_HEAD_INIT(driver_data.bmc_data),
+	.bmc_events =3D {
+		.owner =3D THIS_MODULE,
+		.new_smi =3D ibmpex_register_bmc,
+		.smi_gone =3D ibmpex_bmc_gone,
+	},
+	.ipmi_hndlrs =3D {
+		.ipmi_recv_hndl =3D ibmpex_msg_handler,
+	},
+};
+
+static int ibmpex_send_message(struct ibmpex_bmc_data *data)
+{
+	int err;
+
+	err =3D ipmi_validate_addr(&data->address, sizeof(data->address));
+	if (err)
+		goto out;
+
+	data->tx_msgid++;
+	err =3D ipmi_request_settime(data->user, &data->address, data->tx_msgid,
+				   &data->tx_message, data, 0, 0, 0);
+	if (err)
+		goto out1;
+
+	return 0;
+out1:
+	printk(KERN_ERR "%s: request_settime=3D%x\n", __FUNCTION__, err);
+	return err;
+out:
+	printk(KERN_ERR "%s: validate_addr=3D%x\n", __FUNCTION__, err);
+	return err;
+}
+
+static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
+{
+	data->tx_msg_data[0] =3D 0x1;
+	data->tx_message.data_len =3D 1;
+	ibmpex_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len !=3D 6)
+		return -ENOENT;
+
+	data->sensor_major =3D data->rx_msg_data[0];
+	data->sensor_minor =3D data->rx_msg_data[1];
+
+	printk(KERN_INFO DRVNAME ": Found BMC with sensor interface "
+	       "v%d.%d %d-%02d-%02d on interface %d\n",
+	       data->sensor_major,
+	       data->sensor_minor,
+	       data->rx_msg_data[3] | ((u16)data->rx_msg_data[2] << 8),
+	       data->rx_msg_data[4],
+	       data->rx_msg_data[5],
+	       data->interface);
+
+	return 0;
+}
+
+static int ibmpex_query_sensor_count(struct ibmpex_bmc_data *data)
+{
+	data->tx_msg_data[0] =3D 0x2;
+	data->tx_message.data_len =3D 1;
+	ibmpex_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len !=3D 1)
+		return -ENOENT;
+
+	return data->rx_msg_data[0];
+}
+
+static int ibmpex_query_sensor_name(struct ibmpex_bmc_data *data, int sens=
or)
+{
+	data->tx_msg_data[0] =3D 0x3;
+	data->tx_msg_data[1] =3D sensor;
+	data->tx_message.data_len =3D 2;
+	ibmpex_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len < 1)
+		return -ENOENT;
+
+	return 0;
+}
+
+static int ibmpex_query_sensor_data(struct ibmpex_bmc_data *data, int sens=
or)
+{
+	data->tx_msg_data[0] =3D 0x6;
+	data->tx_msg_data[1] =3D sensor;
+	data->tx_message.data_len =3D 2;
+	ibmpex_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len < 26) {
+		printk(KERN_ERR "Error reading sensor %d, please check.\n",
+		       sensor);
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
+static void ibmpex_update_device(struct ibmpex_bmc_data *data)
+{
+	int i, err;
+
+	mutex_lock(&data->lock);
+	if (time_before(jiffies, data->last_updated + REFRESH_INTERVAL) &&
+	    data->valid)
+		goto out;
+
+	for (i =3D 0; i < data->num_sensors; i++) {
+		if (!data->sensors[i].in_use)
+			continue;
+		err =3D ibmpex_query_sensor_data(data, i);
+		if (err)
+			continue;
+		data->sensors[i].value =3D ((u16)data->rx_msg_data[16] << 8) |
+					 data->rx_msg_data[17];
+		data->sensors[i].min =3D ((u16)data->rx_msg_data[18] << 8) |
+				       data->rx_msg_data[19];
+		data->sensors[i].max =3D ((u16)data->rx_msg_data[20] << 8) |
+				       data->rx_msg_data[21];
+	}
+
+	data->last_updated =3D jiffies;
+	data->valid =3D 1;
+
+out:
+	mutex_unlock(&data->lock);
+}
+
+static struct ibmpex_bmc_data *get_bmc_data(int iface)
+{
+	struct ibmpex_bmc_data *p, *next;
+
+	list_for_each_entry_safe(p, next, &driver_data.bmc_data, list)
+		if (p->interface =3D=3D iface)
+			return p;
+
+	return NULL;
+}
+
+static ssize_t show_name(struct device *dev, struct device_attribute *deva=
ttr,
+			 char *buf)
+{
+	return sprintf(buf, "%s\n", DRVNAME);
+}
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+
+static ssize_t ibmpex_show_sensor(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
+	int iface =3D attr->index >> 8;
+	int sensor =3D attr->index & 0xFF;
+	struct ibmpex_bmc_data *data =3D get_bmc_data(iface);
+	int divisor =3D data->sensors[sensor].divisor;
+	ibmpex_update_device(data);
+
+	if (divisor =3D=3D 1)
+		return sprintf(buf, "%d\n", data->sensors[sensor].value);
+
+	return sprintf(buf, "%d.%d\n",
+		       data->sensors[sensor].value / divisor,
+		       data->sensors[sensor].value % divisor);
+}
+
+static ssize_t ibmpex_show_max(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
+	int iface =3D attr->index >> 8;
+	int sensor =3D attr->index & 0xFF;
+	struct ibmpex_bmc_data *data =3D get_bmc_data(iface);
+	int divisor =3D data->sensors[sensor].divisor;
+	ibmpex_update_device(data);
+
+	if (divisor =3D=3D 1)
+		return sprintf(buf, "%d\n", data->sensors[sensor].max);
+
+	return sprintf(buf, "%d.%d\n",
+		       data->sensors[sensor].max / divisor,
+		       data->sensors[sensor].max % divisor);
+}
+
+static ssize_t ibmpex_show_min(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(devattr);
+	int iface =3D attr->index >> 8;
+	int sensor =3D attr->index & 0xFF;
+	struct ibmpex_bmc_data *data =3D get_bmc_data(iface);
+	int divisor =3D data->sensors[sensor].divisor;
+	ibmpex_update_device(data);
+
+	if (divisor =3D=3D 1)
+		return sprintf(buf, "%d\n", data->sensors[sensor].min);
+
+	return sprintf(buf, "%d.%d\n",
+		       data->sensors[sensor].min / divisor,
+		       data->sensors[sensor].min % divisor);
+}
+
+static int is_power_sensor(const char *sensor_id, int len)
+{
+	if (len < 3)
+		return 0;
+
+	if (sensor_id[0] =3D=3D 0x70 &&
+	    sensor_id[1] =3D=3D 0x77 &&
+	    sensor_id[2] =3D=3D 0x72)
+		return 1;
+	return 0;
+}
+
+static int is_temp_sensor(const char *sensor_id, int len)
+{
+	if (len < 3)
+		return 0;
+
+	if (sensor_id[0] =3D=3D 0x74 &&
+	    sensor_id[1] =3D=3D 0x65 &&
+	    sensor_id[2] =3D=3D 0x6D)
+		return 1;
+	return 0;
+}
+
+static int power_sensor_divisor(const char *sensor_id, int len)
+{
+	int i;
+
+	for (i =3D 3; i < len - 1; i++)
+		if (sensor_id[i] =3D=3D 0x41 &&
+		    sensor_id[i + 1] =3D=3D 0x43)
+			return 1;
+
+	return 10;
+}
+
+static int ibmpex_find_sensors(struct ibmpex_bmc_data *data)
+{
+	int i, err;
+	char *n, *sensor_type;
+	int sensor_counter;
+	int num_power =3D 0;
+	int num_temp =3D 0;
+
+	err =3D ibmpex_query_sensor_count(data);
+	if (err < 0)
+		return -ENOENT;
+	data->num_sensors =3D err;
+
+	data->sensors =3D kzalloc(data->num_sensors * sizeof(*data->sensors),
+				GFP_KERNEL);
+	if (!data->sensors)
+		return -ENOMEM;
+
+	for (i =3D 0; i < data->num_sensors; i++) {
+		err =3D ibmpex_query_sensor_name(data, i);
+		if (err)
+			continue;
+
+		if (is_power_sensor(data->rx_msg_data, data->rx_msg_len)) {
+			sensor_type =3D "power";
+			num_power++;
+			sensor_counter =3D num_power;
+			data->sensors[i].divisor =3D
+				power_sensor_divisor(data->rx_msg_data,
+						     data->rx_msg_len);
+		} else if (is_temp_sensor(data->rx_msg_data,
+					  data->rx_msg_len)) {
+			sensor_type =3D "temp";
+			num_temp++;
+			sensor_counter =3D num_temp;
+			data->sensors[i].divisor =3D 1;
+		} else
+			continue;
+
+		data->sensors[i].in_use =3D 1;
+
+		/* Create value attribute */
+		n =3D kmalloc(32, GFP_KERNEL);
+		if (!n)
+			goto exit_remove;
+		sprintf(n, "%s%d_input", sensor_type, sensor_counter);
+		data->sensors[i].attr_value.dev_attr.attr.name =3D n;
+		data->sensors[i].attr_value.dev_attr.attr.mode =3D S_IRUGO;
+		data->sensors[i].attr_value.dev_attr.show =3D ibmpex_show_sensor;
+		data->sensors[i].attr_value.index =3D (data->interface << 8) |
+						    (i & 0xFF);
+
+		err =3D device_create_file(data->bmc_device,
+					 &data->sensors[i].attr_value.dev_attr);
+		if (err) {
+			data->sensors[i].attr_value.dev_attr.attr.name =3D NULL;
+			kfree(n);
+			goto exit_remove;
+		}
+
+		/* Create max attribute */
+		n =3D kmalloc(32, GFP_KERNEL);
+		if (!n)
+			goto exit_remove;
+		sprintf(n, "%s%d_max_input", sensor_type, sensor_counter);
+		data->sensors[i].attr_max.dev_attr.attr.name =3D n;
+		data->sensors[i].attr_max.dev_attr.attr.mode =3D S_IRUGO;
+		data->sensors[i].attr_max.dev_attr.show =3D ibmpex_show_max;
+		data->sensors[i].attr_max.index =3D (data->interface << 8) |
+						    (i & 0xFF);
+
+		err =3D device_create_file(data->bmc_device,
+					 &data->sensors[i].attr_max.dev_attr);
+		if (err) {
+			data->sensors[i].attr_max.dev_attr.attr.name =3D NULL;
+			kfree(n);
+			goto exit_remove;
+		}
+
+		/* Create min attribute */
+		n =3D kmalloc(32, GFP_KERNEL);
+		if (!n)
+			goto exit_remove;
+		sprintf(n, "%s%d_min_input", sensor_type, sensor_counter);
+		data->sensors[i].attr_min.dev_attr.attr.name =3D n;
+		data->sensors[i].attr_min.dev_attr.attr.mode =3D S_IRUGO;
+		data->sensors[i].attr_min.dev_attr.show =3D ibmpex_show_min;
+		data->sensors[i].attr_min.index =3D (data->interface << 8) |
+						    (i & 0xFF);
+
+		err =3D device_create_file(data->bmc_device,
+					 &data->sensors[i].attr_min.dev_attr);
+		if (err) {
+			data->sensors[i].attr_min.dev_attr.attr.name =3D NULL;
+			kfree(n);
+			goto exit_remove;
+		}
+	}
+
+	err =3D device_create_file(data->bmc_device,
+			&sensor_dev_attr_name.dev_attr);
+	if (err)
+		goto exit_remove;
+
+	return 0;
+
+exit_remove:
+	for (i =3D 0; i < data->num_sensors; i++) {
+		if (data->sensors[i].attr_value.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_value.dev_attr);
+		kfree(data->sensors[i].attr_value.dev_attr.attr.name);
+		if (data->sensors[i].attr_max.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_max.dev_attr);
+		kfree(data->sensors[i].attr_max.dev_attr.attr.name);
+		if (data->sensors[i].attr_min.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_min.dev_attr);
+		kfree(data->sensors[i].attr_min.dev_attr.attr.name);
+	}
+
+	kfree(data->sensors);
+	return -ENOENT;
+}
+
+static void ibmpex_register_bmc(int iface, struct device *dev)
+{
+	struct ibmpex_bmc_data *data;
+	int err;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
+		       "interface %d.\n", data->interface);
+		return;
+	}
+
+	data->address.addr_type =3D IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	data->address.channel =3D IPMI_BMC_CHANNEL;
+	data->address.data[0] =3D 0;
+	data->interface =3D iface;
+	data->bmc_device =3D dev;
+
+	/* Create IPMI messaging interface user */
+	err =3D ipmi_create_user(data->interface, &driver_data.ipmi_hndlrs,
+			       data, &data->user);
+	if (err < 0) {
+		printk(KERN_ERR DRVNAME ": Error, unable to register user with "
+		       "ipmi interface %d\n",
+		       data->interface);
+		goto out;
+	}
+
+	mutex_init(&data->lock);
+
+	/* Initialize message */
+	data->tx_msgid =3D 0;
+	init_completion(&data->read_complete);
+	data->tx_message.netfn =3D 0x3A;
+	data->tx_message.cmd =3D 0x3C;
+	data->tx_message.data =3D data->tx_msg_data;
+
+	/* Does this BMC support PowerExecutive? */
+	err =3D ibmpex_ver_check(data);
+	if (err)
+		goto out_user;
+
+	/* Register the BMC as a HWMON class device */
+	data->class_dev =3D hwmon_device_register(data->bmc_device);
+
+	if (IS_ERR(data->class_dev)) {
+		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
+		       "class device for interface %d\n",
+		       data->interface);
+		kfree(data);
+		return;
+	}
+
+	/* finally add the new bmc data to the bmc data list */
+	list_add_tail(&data->list, &driver_data.bmc_data);
+
+	/* Now go find all the sensors */
+	err =3D ibmpex_find_sensors(data);
+	if (err) {
+		printk(KERN_ERR "Error %d allocating memory\n", err);
+		goto out_register;
+	}
+=09
+	return;
+
+out_register:
+	hwmon_device_unregister(data->class_dev);
+out_user:
+	ipmi_destroy_user(data->user);
+out:
+	kfree(data);
+}
+
+static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
+{
+	int i;
+
+	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
+	for (i =3D 0; i < data->num_sensors; i++) {
+		if (data->sensors[i].attr_max.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_max.dev_attr);
+		kfree(data->sensors[i].attr_max.dev_attr.attr.name);
+		if (data->sensors[i].attr_min.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_min.dev_attr);
+		kfree(data->sensors[i].attr_min.dev_attr.attr.name);
+		if (data->sensors[i].attr_value.dev_attr.attr.name)
+			device_remove_file(data->bmc_device,
+				&data->sensors[i].attr_value.dev_attr);
+		kfree(data->sensors[i].attr_value.dev_attr.attr.name);
+	}
+	list_del(&data->list);
+	hwmon_device_unregister(data->class_dev);
+	ipmi_destroy_user(data->user);
+	if (data->sensors)
+		kfree(data->sensors);
+	kfree(data);
+}
+
+static void ibmpex_bmc_gone(int iface)
+{
+	struct ibmpex_bmc_data *data =3D get_bmc_data(iface);
+
+	if (!data)
+		return;
+
+	ibmpex_bmc_delete(data);
+}
+
+static void ibmpex_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_d=
ata)
+{
+	struct ibmpex_bmc_data *data =3D (struct ibmpex_bmc_data *)user_msg_data;
+
+	if (msg->msgid !=3D data->tx_msgid) {
+		printk(KERN_ERR "Received msgid (%02x) and transmitted "
+		       "msgid (%02x) mismatch!\n",
+		       (int)msg->msgid,
+		       (int)data->tx_msgid);
+		ipmi_free_recv_msg(msg);
+		return;
+	}
+
+	data->rx_recv_type =3D msg->recv_type;
+	if (msg->msg.data_len > 0)
+		data->rx_result =3D msg->msg.data[0];
+	else
+		data->rx_result =3D IPMI_UNKNOWN_ERR_COMPLETION_CODE;
+
+	if (msg->msg.data_len > 1) {
+		data->rx_msg_len =3D msg->msg.data_len - 1;
+		memcpy(data->rx_msg_data, msg->msg.data + 1, data->rx_msg_len);
+	} else
+		data->rx_msg_len =3D 0;
+
+	ipmi_free_recv_msg(msg);
+	complete(&data->read_complete);
+}
+
+static int __init ibmpex_init(void)
+{
+	return ipmi_smi_watcher_register(&driver_data.bmc_events);
+}
+
+static void __exit ibmpex_exit(void)
+{
+	struct ibmpex_bmc_data *p, *next;
+
+	ipmi_smi_watcher_unregister(&driver_data.bmc_events);
+	list_for_each_entry_safe(p, next, &driver_data.bmc_data, list)
+		ibmpex_bmc_delete(p);
+}
+
+MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("IBM PowerExecutive power/temperature sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(ibmpex_init);
+module_exit(ibmpex_exit);

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG0z7Ga6vRYYgWQuURAtocAJ9NwCZCxKYGjhyLnxOcheUE+cuwpACfUWgy
HiOrRlaXKfjnIUR31+a+gjg=
=rtmo
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
