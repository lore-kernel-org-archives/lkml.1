Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbXIKN21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbXIKN21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXIKN2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:28:20 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:13873 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXIKN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:28:19 -0400
Date: Tue, 11 Sep 2007 09:23:35 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH] v3 of IBM power meter driver
Message-ID: <20070911132335.GJ31992@jupiter.solarsys.private>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828232504.GP32667@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick:

* Darrick J. Wong <djwong@us.ibm.com> [2007-08-28 16:25:05 -0700]:
> Dave Hansen complained about the magic numbers, repetitive code, and
> various other minor problems with the driver code, so here's a v3 with
> the magic numbers migrated to the top of the file and #define'd,
> helper macros taking place of the bit shifting/masking activities, and
> the compression of the value/min/max sysfs code into parameterized
> functions.
> --
> ibm_pex: Driver to export IBM PowerExecutive power meter sensors.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

I am not an IPMI expert, so I would appreciate getting an Acked-by from
someone who knows more about that subsystem.

Anyway, some comments are below.  This is nowhere near a complete review yet.

> ---
> 
>  drivers/hwmon/Kconfig  |   12 +
>  drivers/hwmon/Makefile |    1 
>  drivers/hwmon/ibmpex.c |  564 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 577 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 555f470..41ffa2e 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -275,6 +275,18 @@ config SENSORS_CORETEMP
>  	  sensor inside your CPU. Supported all are all known variants
>  	  of Intel Core family.
>  
> +config SENSORS_IBMPEX
> +	tristate "IBM PowerExecutive temperature/power sensors"
> +	depends on IPMI_SI

Open question: can we use "select" here?  As written, it took some hunting to
even get this driver to show up as an option in menuconfig.

> +	help
> +	  If you say yes here you get support for the temperature and
> +	  power sensors in various IBM System X servers that support
> +	  PowerExecutive.  So far this includes the x3550, x3650, x3655,
> +	  x3755, and certain HS20 blades.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ibmpex.
> +
>  config SENSORS_IT87
>  	tristate "ITE IT87xx and compatibles"
>  	select HWMON_VID
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index a133981..31da6fe 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -35,6 +35,7 @@ obj-$(CONFIG_SENSORS_FSCPOS)	+= fscpos.o
>  obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
>  obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
>  obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
> +obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> new file mode 100644
> index 0000000..632f897
> --- /dev/null
> +++ b/drivers/hwmon/ibmpex.c
> @@ -0,0 +1,564 @@
> +/*
> + * A hwmon driver for the IBM PowerExecutive temperature/power sensors
> + * Copyright (C) 2007 IBM
> + *
> + * Author: Darrick J. Wong <djwong@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/ipmi.h>
> +#include <linux/module.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>

#include <linux/jiffies.h>

> +#include <linux/mutex.h>
> +
> +#define REFRESH_INTERVAL	(5 * HZ)
> +#define DRVNAME			"ibmpex"
> +
> +#define PEX_GET_VERSION		1
> +#define PEX_GET_SENSOR_COUNT	2
> +#define PEX_GET_SENSOR_NAME	3
> +#define PEX_GET_SENSOR_DATA	6
> +
> +#define PEX_NET_FUNCTION	0x3A
> +#define PEX_COMMAND		0x3C
> +
> +static inline u16 extract_value(const char *data, int offset)
> +{
> +	u16 val = *(u16*)&data[offset];
> +	return be16_to_cpu(val);

	return be16_to_cpup((u16*)&data[offset]);

> +}
> +
> +#define PEX_INTERFACE(idx)		((idx) >> 16)
> +#define PEX_SENSOR(idx)			(((idx) >> 8) & 0xFF)
> +#define PEX_FUNC(idx)			((idx) & 0xFF)
> +#define PEX_INDEX(iface, num, fn)	(((iface) << 16) | ((num) << 8) | (fn))
> +
> +#define PEX_SENSOR_TYPE_LEN	3
> +static char power_sensor_sig[] = {0x70, 0x77, 0x72};
> +static char temp_sensor_sig[]  = {0x74, 0x65, 0x6D};
> +
> +#define PEX_MULT_LEN		2
> +static char watt_sensor_sig[]  = {0x41, 0x43};
> +

All three above should be "static u8 const"

> +#define PEX_NUM_SENSOR_FUNCS	3
> +static char *sensor_name_templates[] = {
> +	"%s%d_input",
> +	"%s%d_min_input",
> +	"%s%d_max_input"
> +};
> +

static char const * const sensor_name_templates[] = {

> +static void ibmpex_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
> +static void ibmpex_register_bmc(int iface, struct device *dev);
> +static void ibmpex_bmc_gone(int iface);
> +
> +struct ibmpex_sensor_data {
> +	int			in_use;
> +	s16			values[PEX_NUM_SENSOR_FUNCS];
> +	int			multiplier;
> +
> +	struct sensor_device_attribute	attr[PEX_NUM_SENSOR_FUNCS];
> +};
> +
> +struct ibmpex_bmc_data {
> +	struct list_head	list;
> +	struct class_device	*class_dev;

My current stack of patches includes one which requires that this be changed
to 'struct device *hwmon_dev', as 'struct class_device' is going away soon.
You may rebase on my testing tree[1], or else I will just follow up with a
patch to fix this up after I eventually merge yours.

[1] http://lm-sensors.org/kernel?p=kernel/mhoffman/hwmon-2.6.git;a=shortlog;h=testing

> +	struct device		*bmc_device;
> +	struct mutex		lock;
> +	char			valid;
> +	unsigned long		last_updated;	/* In jiffies */
> +
> +	struct ipmi_addr	address;
> +	struct completion	read_complete;
> +	ipmi_user_t		user;
> +	int			interface;
> +
> +	struct kernel_ipmi_msg	tx_message;
> +	unsigned char		tx_msg_data[IPMI_MAX_MSG_LENGTH];
> +	long			tx_msgid;
> +
> +	unsigned char		rx_msg_data[IPMI_MAX_MSG_LENGTH];
> +	unsigned long		rx_msg_len;
> +	unsigned char		rx_result;
> +	int			rx_recv_type;
> +
> +	unsigned char		sensor_major;
> +	unsigned char		sensor_minor;
> +
> +	unsigned char		num_sensors;
> +	struct ibmpex_sensor_data	*sensors;
> +};
> +
> +struct ibmpex_driver_data {
> +	struct list_head	bmc_data;
> +	struct ipmi_smi_watcher	bmc_events;
> +	struct ipmi_user_hndl	ipmi_hndlrs;
> +};
> +
> +static struct ibmpex_driver_data driver_data = {
> +	.bmc_data = LIST_HEAD_INIT(driver_data.bmc_data),
> +	.bmc_events = {
> +		.owner = THIS_MODULE,
> +		.new_smi = ibmpex_register_bmc,
> +		.smi_gone = ibmpex_bmc_gone,
> +	},
> +	.ipmi_hndlrs = {
> +		.ipmi_recv_hndl = ibmpex_msg_handler,
> +	},
> +};
> +
> +static int ibmpex_send_message(struct ibmpex_bmc_data *data)
> +{
> +	int err;
> +
> +	err = ipmi_validate_addr(&data->address, sizeof(data->address));
> +	if (err)
> +		goto out;
> +
> +	data->tx_msgid++;
> +	err = ipmi_request_settime(data->user, &data->address, data->tx_msgid,
> +				   &data->tx_message, data, 0, 0, 0);
> +	if (err)
> +		goto out1;
> +
> +	return 0;
> +out1:
> +	printk(KERN_ERR "%s: request_settime=%x\n", __FUNCTION__, err);
> +	return err;
> +out:
> +	printk(KERN_ERR "%s: validate_addr=%x\n", __FUNCTION__, err);
> +	return err;
> +}
> +
> +static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
> +{
> +	data->tx_msg_data[0] = PEX_GET_VERSION;
> +	data->tx_message.data_len = 1;
> +	ibmpex_send_message(data);
> +
> +	wait_for_completion(&data->read_complete);
> +
> +	if (data->rx_result || data->rx_msg_len != 6)
> +		return -ENOENT;
> +
> +	data->sensor_major = data->rx_msg_data[0];
> +	data->sensor_minor = data->rx_msg_data[1];
> +
> +	printk(KERN_INFO DRVNAME ": Found BMC with sensor interface "
> +	       "v%d.%d %d-%02d-%02d on interface %d\n",
> +	       data->sensor_major,
> +	       data->sensor_minor,
> +	       extract_value(data->rx_msg_data, 2),
> +	       data->rx_msg_data[4],
> +	       data->rx_msg_data[5],
> +	       data->interface);
> +
> +	return 0;
> +}
> +
> +static int ibmpex_query_sensor_count(struct ibmpex_bmc_data *data)
> +{
> +	data->tx_msg_data[0] = PEX_GET_SENSOR_COUNT;
> +	data->tx_message.data_len = 1;
> +	ibmpex_send_message(data);
> +
> +	wait_for_completion(&data->read_complete);
> +
> +	if (data->rx_result || data->rx_msg_len != 1)
> +		return -ENOENT;
> +
> +	return data->rx_msg_data[0];
> +}
> +
> +static int ibmpex_query_sensor_name(struct ibmpex_bmc_data *data, int sensor)
> +{
> +	data->tx_msg_data[0] = PEX_GET_SENSOR_NAME;
> +	data->tx_msg_data[1] = sensor;
> +	data->tx_message.data_len = 2;
> +	ibmpex_send_message(data);
> +
> +	wait_for_completion(&data->read_complete);
> +
> +	if (data->rx_result || data->rx_msg_len < 1)
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
> +static int ibmpex_query_sensor_data(struct ibmpex_bmc_data *data, int sensor)
> +{
> +	data->tx_msg_data[0] = PEX_GET_SENSOR_DATA;
> +	data->tx_msg_data[1] = sensor;
> +	data->tx_message.data_len = 2;
> +	ibmpex_send_message(data);
> +
> +	wait_for_completion(&data->read_complete);
> +
> +	if (data->rx_result || data->rx_msg_len < 26) {
> +		printk(KERN_ERR "Error reading sensor %d, please check.\n",
> +		       sensor);
> +		return -ENOENT;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ibmpex_update_device(struct ibmpex_bmc_data *data)
> +{
> +	int i, err;
> +
> +	mutex_lock(&data->lock);
> +	if (time_before(jiffies, data->last_updated + REFRESH_INTERVAL) &&
> +	    data->valid)
> +		goto out;
> +
> +	for (i = 0; i < data->num_sensors; i++) {
> +		if (!data->sensors[i].in_use)
> +			continue;
> +		err = ibmpex_query_sensor_data(data, i);
> +		if (err)
> +			continue;
> +		data->sensors[i].values[0] =
> +			extract_value(data->rx_msg_data, 16);
> +		data->sensors[i].values[1] =
> +			extract_value(data->rx_msg_data, 18);
> +		data->sensors[i].values[2] =
> +			extract_value(data->rx_msg_data, 20);
> +	}
> +
> +	data->last_updated = jiffies;
> +	data->valid = 1;
> +
> +out:
> +	mutex_unlock(&data->lock);
> +}
> +
> +static struct ibmpex_bmc_data *get_bmc_data(int iface)
> +{
> +	struct ibmpex_bmc_data *p, *next;
> +
> +	list_for_each_entry_safe(p, next, &driver_data.bmc_data, list)
> +		if (p->interface == iface)
> +			return p;
> +
> +	return NULL;
> +}
> +

That function is yucky...

> +static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
> +			 char *buf)
> +{
> +	return sprintf(buf, "%s\n", DRVNAME);
> +}
> +static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
> +
> +static ssize_t ibmpex_show_sensor(struct device *dev,
> +				  struct device_attribute *devattr,
> +				  char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	int iface = PEX_INTERFACE(attr->index);
> +	int sensor = PEX_SENSOR(attr->index);
> +	int func = PEX_FUNC(attr->index);
> +	struct ibmpex_bmc_data *data = get_bmc_data(iface);

... especially given how many times you're going to call it.  Is there any
reason you can't use the driver_data field of struct device *dev for that?

E.g. i2c based hwmon drivers do this at some point during the probe:

	i2c_set_clientdata(new_client, data);

(which becomes)

	dev_set_drvdata(&new_client->dev, data);

If you could do that, then you no longer need 'iface' at all in the function
above... *that* may allow you to use the SENSOR_ATTR_2 mechanism from
hwmon-sysfs.h - much easier to read than the manual number packing for 'sensor'
and 'func'.

> +	int multiplier = data->sensors[sensor].multiplier;
> +	ibmpex_update_device(data);
> +
> +	return sprintf(buf, "%d\n",
> +		       data->sensors[sensor].values[func] * multiplier);
> +}
> +
> +static int is_power_sensor(const char *sensor_id, int len)
> +{
> +	if (len < PEX_SENSOR_TYPE_LEN)
> +		return 0;
> +
> +	if (!memcmp(sensor_id, power_sensor_sig, PEX_SENSOR_TYPE_LEN))
> +		return 1;
> +	return 0;
> +}
> +
> +static int is_temp_sensor(const char *sensor_id, int len)
> +{
> +	if (len < PEX_SENSOR_TYPE_LEN)
> +		return 0;
> +
> +	if (!memcmp(sensor_id, temp_sensor_sig, PEX_SENSOR_TYPE_LEN))
> +		return 1;
> +	return 0;
> +}
> +
> +static int power_sensor_multiplier(const char *sensor_id, int len)
> +{
> +	int i;
> +
> +	for (i = PEX_SENSOR_TYPE_LEN; i < len - 1; i++)
> +		if (!memcmp(&sensor_id[i], watt_sensor_sig, PEX_MULT_LEN))
> +			return 1000;
> +
> +	return 100;
> +}
> +
> +static int create_sensor(struct ibmpex_bmc_data *data, const char *type,
> +			 int counter, int sensor, int func)
> +{
> +	int err;
> +	char *n;
> +
> +	n = kmalloc(32, GFP_KERNEL);
> +	if (!n)
> +		return -ENOMEM;
> +
> +	sprintf(n, sensor_name_templates[func], type, counter);
> +	data->sensors[sensor].attr[func].dev_attr.attr.name = n;
> +	data->sensors[sensor].attr[func].dev_attr.attr.mode = S_IRUGO;
> +	data->sensors[sensor].attr[func].dev_attr.show = ibmpex_show_sensor;
> +	data->sensors[sensor].attr[func].index =
> +		PEX_INDEX(data->interface, sensor, func);
> +
> +	err = device_create_file(data->bmc_device,
> +				 &data->sensors[sensor].attr[func].dev_attr);
> +	if (err) {
> +		data->sensors[sensor].attr[func].dev_attr.attr.name = NULL;
> +		kfree(n);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ibmpex_find_sensors(struct ibmpex_bmc_data *data)
> +{
> +	int i, j, err;
> +	char *sensor_type;
> +	int sensor_counter;
> +	int num_power = 0;
> +	int num_temp = 0;
> +
> +	err = ibmpex_query_sensor_count(data);
> +	if (err < 0)
> +		return -ENOENT;
> +	data->num_sensors = err;
> +

Did you mean 'if (err <= 0)' ?

> +	data->sensors = kzalloc(data->num_sensors * sizeof(*data->sensors),
> +				GFP_KERNEL);
> +	if (!data->sensors)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < data->num_sensors; i++) {
> +		err = ibmpex_query_sensor_name(data, i);
> +		if (err)
> +			continue;
> +
> +		if (is_power_sensor(data->rx_msg_data, data->rx_msg_len)) {
> +			sensor_type = "power";
> +			num_power++;
> +			sensor_counter = num_power;
> +			data->sensors[i].multiplier =
> +				power_sensor_multiplier(data->rx_msg_data,
> +						     data->rx_msg_len);
> +		} else if (is_temp_sensor(data->rx_msg_data,
> +					  data->rx_msg_len)) {
> +			sensor_type = "temp";
> +			num_temp++;
> +			sensor_counter = num_temp;
> +			data->sensors[i].multiplier = 1;
> +		} else
> +			continue;
> +
> +		data->sensors[i].in_use = 1;
> +
> +		/* Create attributes */
> +		for (j = 0; j < PEX_NUM_SENSOR_FUNCS; j++)
> +			if (create_sensor(data, sensor_type, sensor_counter,
> +					  i, j))

Why not 'err = create_sensor(...)' and propagate the actual error here?

> +				goto exit_remove;
> +	}
> +
> +	err = device_create_file(data->bmc_device,
> +			&sensor_dev_attr_name.dev_attr);
> +	if (err)
> +		goto exit_remove;
> +
> +	return 0;
> +
> +exit_remove:
> +	for (i = 0; i < data->num_sensors; i++)
> +		for (j = 0; j < PEX_NUM_SENSOR_FUNCS; j++) {
> +			if (!data->sensors[i].attr[j].dev_attr.attr.name)
> +				continue;
> +			device_remove_file(data->bmc_device,
> +				&data->sensors[i].attr[j].dev_attr);
> +			kfree(data->sensors[i].attr[j].dev_attr.attr.name);
> +		}
> +
> +	kfree(data->sensors);
> +	return -ENOENT;

... and 'return err' here instead.

> +}
> +
> +static void ibmpex_register_bmc(int iface, struct device *dev)
> +{
> +	struct ibmpex_bmc_data *data;
> +	int err;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> +		       "interface %d.\n", data->interface);
> +		return;
> +	}
> +
> +	data->address.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
> +	data->address.channel = IPMI_BMC_CHANNEL;
> +	data->address.data[0] = 0;
> +	data->interface = iface;
> +	data->bmc_device = dev;
> +
> +	/* Create IPMI messaging interface user */
> +	err = ipmi_create_user(data->interface, &driver_data.ipmi_hndlrs,
> +			       data, &data->user);
> +	if (err < 0) {
> +		printk(KERN_ERR DRVNAME ": Error, unable to register user with "
> +		       "ipmi interface %d\n",
> +		       data->interface);
> +		goto out;
> +	}
> +
> +	mutex_init(&data->lock);
> +
> +	/* Initialize message */
> +	data->tx_msgid = 0;
> +	init_completion(&data->read_complete);
> +	data->tx_message.netfn = PEX_NET_FUNCTION;
> +	data->tx_message.cmd = PEX_COMMAND;
> +	data->tx_message.data = data->tx_msg_data;
> +
> +	/* Does this BMC support PowerExecutive? */
> +	err = ibmpex_ver_check(data);
> +	if (err)
> +		goto out_user;
> +
> +	/* Register the BMC as a HWMON class device */
> +	data->class_dev = hwmon_device_register(data->bmc_device);
> +
> +	if (IS_ERR(data->class_dev)) {
> +		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
> +		       "class device for interface %d\n",
> +		       data->interface);
> +		kfree(data);
> +		return;
> +	}
> +
> +	/* finally add the new bmc data to the bmc data list */
> +	list_add_tail(&data->list, &driver_data.bmc_data);
> +
> +	/* Now go find all the sensors */
> +	err = ibmpex_find_sensors(data);
> +	if (err) {
> +		printk(KERN_ERR "Error %d allocating memory\n", err);
> +		goto out_register;
> +	}
> +	
> +	return;
> +
> +out_register:
> +	hwmon_device_unregister(data->class_dev);
> +out_user:
> +	ipmi_destroy_user(data->user);
> +out:
> +	kfree(data);
> +}
> +
> +static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
> +{
> +	int i, j;
> +
> +	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
> +	for (i = 0; i < data->num_sensors; i++)
> +		for (j = 0; j < PEX_NUM_SENSOR_FUNCS; j++) {
> +			if (!data->sensors[i].attr[j].dev_attr.attr.name)
> +				continue;
> +			device_remove_file(data->bmc_device,
> +				&data->sensors[i].attr[j].dev_attr);
> +			kfree(data->sensors[i].attr[j].dev_attr.attr.name);
> +		}
> +
> +	list_del(&data->list);
> +	hwmon_device_unregister(data->class_dev);
> +	ipmi_destroy_user(data->user);
> +	if (data->sensors)
> +		kfree(data->sensors);
> +	kfree(data);
> +}
> +
> +static void ibmpex_bmc_gone(int iface)
> +{
> +	struct ibmpex_bmc_data *data = get_bmc_data(iface);
> +
> +	if (!data)
> +		return;
> +
> +	ibmpex_bmc_delete(data);
> +}
> +
> +static void ibmpex_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
> +{
> +	struct ibmpex_bmc_data *data = (struct ibmpex_bmc_data *)user_msg_data;
> +
> +	if (msg->msgid != data->tx_msgid) {
> +		printk(KERN_ERR "Received msgid (%02x) and transmitted "
> +		       "msgid (%02x) mismatch!\n",
> +		       (int)msg->msgid,
> +		       (int)data->tx_msgid);
> +		ipmi_free_recv_msg(msg);
> +		return;
> +	}
> +
> +	data->rx_recv_type = msg->recv_type;
> +	if (msg->msg.data_len > 0)
> +		data->rx_result = msg->msg.data[0];
> +	else
> +		data->rx_result = IPMI_UNKNOWN_ERR_COMPLETION_CODE;
> +
> +	if (msg->msg.data_len > 1) {
> +		data->rx_msg_len = msg->msg.data_len - 1;
> +		memcpy(data->rx_msg_data, msg->msg.data + 1, data->rx_msg_len);
> +	} else
> +		data->rx_msg_len = 0;
> +
> +	ipmi_free_recv_msg(msg);
> +	complete(&data->read_complete);
> +}
> +
> +static int __init ibmpex_init(void)
> +{
> +	return ipmi_smi_watcher_register(&driver_data.bmc_events);
> +}
> +
> +static void __exit ibmpex_exit(void)
> +{
> +	struct ibmpex_bmc_data *p, *next;
> +
> +	ipmi_smi_watcher_unregister(&driver_data.bmc_events);
> +	list_for_each_entry_safe(p, next, &driver_data.bmc_data, list)
> +		ibmpex_bmc_delete(p);
> +}
> +
> +MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
> +MODULE_DESCRIPTION("IBM PowerExecutive power/temperature sensor driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(ibmpex_init);
> +module_exit(ibmpex_exit);

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

