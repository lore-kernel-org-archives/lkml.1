Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYEGAi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYEGAi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYEGAir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:38:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbYEGAiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:38:46 -0400
Date: Tue, 6 May 2008 17:32:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       mhoffman@lightlink.com
Subject: Re: [resend] [PATCH v2] ibmaem: New driver for power/energy meters
 in IBM System X hardware
Message-Id: <20080506173248.23f1e591.akpm@linux-foundation.org>
In-Reply-To: <20080506223812.GF16404@tree.beaverton.ibm.com>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
	<20080505230440.GE16404@tree.beaverton.ibm.com>
	<20080506140433.0fa6e68e.akpm@linux-foundation.org>
	<20080506223812.GF16404@tree.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 15:38:13 -0700 "Darrick J. Wong" <djwong@us.ibm.com> wrote:

> [resend due to truncation]
> Refactor the registration function to shrink the macros.  Let me know if
> more aggressive de-macroing is desirable.
> ---
> New driver for power meters in IBM System X hardware, with a few
> cleanups suggested by Anthony Liguori.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> index 0000000..2fefaf5
> --- /dev/null
> +++ b/Documentation/hwmon/ibmaem
> @@ -0,0 +1,37 @@
> +Kernel driver ibmaem
> +======================
> +
> +Supported systems:
> +  * Any recent IBM System X server with Active Energy Manager support.
> +    This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
> +    x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
> +    driver ("ipmi-si") needs to be loaded for this driver to do anything.
> +    Prefix: 'ibmaem'
> +    Datasheet: Not available
> +
> +Author: Darrick J. Wong
> +
> +Description
> +-----------
> +
> +This driver implements sensor reading support for the energy and power
> +meters available on various IBM System X hardware through the BMC.  All
> +sensor banks will be exported as platform devices; this driver can talk
> +to both v1 and v2 interfaces.  This driver is completely separate from the
> +older ibmpex driver.
> +
> +The v1 AEM interface has a simple set of features to monitor energy use.
> +There is a register that displays an estimate of raw energy consumption
> +since the last BMC reset, and a power sensor that returns average power
> +use over a configurable interval.
> +
> +The v2 AEM interface is a bit more sophisticated, being able to present
> +a wider range of energy and power use registers, the power cap as
> +set by the AEM software, and temperature sensors.
> +
> +Special Features
> +----------------
> +
> +The "power_cap" value displays the current system power cap, as set by
> +the Active Energy Manager software.  Setting the power cap from the host
> +is not currently supported.
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 4dc76bc..00ff533 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -330,6 +330,20 @@ config SENSORS_CORETEMP
>  	  sensor inside your CPU. Supported all are all known variants
>  	  of Intel Core family.
>  
> +config SENSORS_IBMAEM
> +	tristate "IBM Active Energy Manager temperature/power sensors and control"
> +	select IPMI_SI
> +	depends on IPMI_HANDLER

hm.  IMPI_SI depends on IPMI_HANDLER, so this looks OK.  But this stuff
explodes in our facs so often...

> +	help
> +	  If you say yes here you get support for the temperature and
> +	  power sensors and capping hardware in various IBM System X
> +	  servers that support Active Energy Manager.  This includes
> +	  the x3350, x3550, x3650, x3655, x3755, x3850 M2, x3950 M2,
> +	  and certain HS2x/LS2x/QS2x blades.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ibmaem.
> +
>
> ...
>
> +static DEFINE_IDR(aem1_idr);
> +static DEFINE_SPINLOCK(aem1_idr_lock);
> +static DEFINE_IDR(aem2_idr);
> +static DEFINE_SPINLOCK(aem2_idr_lock);
> +
> +struct aem_ipmi_data;
> +struct aem1_data;
> +struct aem2_data;
> +
> +static void aem_register_bmc(int iface, struct device *dev);
> +static void aem_bmc_gone(int iface);
> +static void aem_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
> +static void aem_init_aem1(struct aem_ipmi_data *probe);
> +static void aem1_delete(struct aem1_data *data);
> +static void aem_init_aem2(struct aem_ipmi_data *probe);
> +static void aem2_delete(struct aem2_data *data);
> +static void aem1_remove_sensors(struct aem1_data *data);
> +static int aem1_find_sensors(struct aem1_data *data);
> +static void aem2_remove_sensors(struct aem2_data *data);
> +static int aem2_find_sensors(struct aem2_data *data);

If these were moved below the struct definitions, we wouldn't need the
forward declarations of the structs.

> +static struct device_driver aem_driver = {
> +	.name = DRVNAME,
> +	.bus = &platform_bus_type,
> +};
> +
> +struct aem_ipmi_data {
> +	struct completion	read_complete;
> +	struct ipmi_addr	address;
> +	ipmi_user_t		user;
> +	int			interface;
> +
> +	struct kernel_ipmi_msg	tx_message;
> +	long			tx_msgid;
> +
> +	void			*rx_msg_data;
> +	unsigned short		rx_msg_len;
> +	unsigned char		rx_result;
> +	int			rx_recv_type;
> +
> +	struct device		*bmc_device;
> +};
> +
> +struct aem_fw_data {
> +	struct device		*hwmon_dev;
> +	struct platform_device	*pdev;
> +	struct mutex		lock;
> +	char			valid;
> +	unsigned long		last_updated;	/* In jiffies */
> +	u8			ver_major;
> +	u8			ver_minor;
> +	u8			module_handle;
> +	int			id;
> +	struct aem_ipmi_data	ipmi;
> +};
> +
> +struct aem_ro_sensor_template {
> +	char *label;
> +	ssize_t (*show)(struct device *dev,
> +			struct device_attribute *devattr,
> +			char *buf);
> +	int index;
> +};
> +
> +struct aem_rw_sensor_template {
> +	char *label;
> +	ssize_t (*show)(struct device *dev,
> +			struct device_attribute *devattr,
> +			char *buf);
> +	ssize_t (*set)(struct device *dev,
> +		       struct device_attribute *devattr,
> +		       const char *buf, size_t count);
> +	int index;
> +};
> +
> +struct aem1_data {
> +	struct aem_fw_data	fw;
> +	struct list_head	list;
> +
> +	/*
> +	 * Available sensors:
> +	 * Energy meter
> +	 * Power meter
> +	 */
> +	struct sensor_device_attribute	sensors[AEM1_NUM_SENSORS];
> +
> +	/* energy use */
> +	u64			energy[AEM1_NUM_ENERGY_REGS];
> +
> +	int			power_period[AEM1_NUM_ENERGY_REGS];
> +};

It'd be nice to document the units in which these physical quantities are
recorded.  BTUs/fortnight?

> +struct aem2_data {
> +	struct aem_fw_data	fw;
> +	struct list_head	list;
> +
> +	/*
> +	 * Available sensors:
> +	 * Two energy meters
> +	 * Two power meters
> +	 * Two temperature sensors
> +	 * Six powercap registers
> +	 */
> +	struct sensor_device_attribute	sensors[AEM2_NUM_SENSORS];
> +
> +	/* energy use */
> +	u64			energy[AEM2_NUM_ENERGY_REGS];
> +
> +	/* power caps */
> +	u16			pcap[AEM2_NUM_PCAP_REGS];
> +
> +	/* exhaust temperature */
> +	u8			temp[AEM2_NUM_TEMP_REGS];
> +
> +	/* power sampling interval */
> +	int			power_period[AEM2_NUM_ENERGY_REGS];
> +};

ditto.

> +/* Data structures returned by the AEM firmware */
> +struct aem_iana_id {
> +	u8			bytes[3];
> +};
> +static struct aem_iana_id system_x_id = {
> +	.bytes = {0x4D, 0x4F, 0x00}
> +};
> +
> +/* These are used to find AEM1 instances */
> +struct aem_find_firmware_req {
> +	struct aem_iana_id	id;
> +	u8			rsvd;
> +	u16			index;
> +	u16			module_type_id;
> +} __attribute__ ((packed));

We have a __packed helper in compiler-gcc.h

> +struct aem_find_firmware_resp {
> +	struct aem_iana_id	id;
> +	u8			num_instances;
> +} __attribute__ ((packed));
> +
> +/* These are used to find AEM2 instances */
> +struct aem_find_instance_req {
> +	struct aem_iana_id	id;
> +	u8			instance_number;
> +	u16			module_type_id;
> +} __attribute__ ((packed));
> +
>
> ...
>
> +/* Probe a BMC for AEM firmware instances */
> +static void aem_register_bmc(int iface, struct device *dev)
> +{
> +	struct aem_ipmi_data probe;

184 bytes of stack.  OK, but worth keeping an eye on.

> +	if (aem_init_ipmi_data(&probe, iface, dev))
> +		return;
> +
> +	aem_init_aem1(&probe);
> +	aem_init_aem2(&probe);
> +
> +	ipmi_destroy_user(probe.user);
> +}
> +
>
> ...
>
> +/* Dispatch IPMI messages to callers */
> +static void aem_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
> +{
> +	unsigned short rx_len;
> +	struct aem_ipmi_data *data = (struct aem_ipmi_data *)user_msg_data;

unneeded and undesirable cast of void*.

> +	if (msg->msgid != data->tx_msgid) {
> +		dev_err(data->bmc_device, "Mismatch between received msgid "
> +			"(%02x) and transmitted msgid (%02x)!\n",
> +			(int)msg->msgid,
> +			(int)data->tx_msgid);
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
> +		rx_len = msg->msg.data_len - 1;
> +		if (data->rx_msg_len < rx_len)
> +			rx_len = data->rx_msg_len;
> +		data->rx_msg_len = rx_len;
> +		memcpy(data->rx_msg_data, msg->msg.data + 1, data->rx_msg_len);
> +	} else
> +		data->rx_msg_len = 0;
> +
> +	ipmi_free_recv_msg(msg);
> +	complete(&data->read_complete);
> +}
> +
>
> ...
>
> +/* Obtain an id */
> +#define AEM_IDR_GET(type) \
> +static int type##_idr_get(int *id) \
> +{ \
> +	int i, err; \
> +\
> +again: \
> +	if (unlikely(idr_pre_get(&type##_idr, GFP_KERNEL) == 0)) \
> +		return -ENOMEM; \
> +\
> +	spin_lock(&type##_idr_lock); \
> +	err = idr_get_new(&type##_idr, NULL, &i); \
> +	spin_unlock(&type##_idr_lock); \
> +\
> +	if (unlikely(err == -EAGAIN)) \
> +		goto again; \
> +	else if (unlikely(err)) \
> +		return err; \
> +\
> +	*id = i & MAX_ID_MASK; \
> +	return 0; \
> +}
> +
> +/* Release an object ID */
> +#define AEM_IDR_PUT(type) \
> +static void type##_idr_put(int id) \
> +{ \
> +	spin_lock(&type##_idr_lock); \
> +	idr_remove(&type##_idr, id); \
> +	spin_unlock(&type##_idr_lock); \
> +}

ick.

>
> ...
>
> +/* Find and initialize all AEM1 instances */
> +static void aem_init_aem1(struct aem_ipmi_data *probe)
> +{
> +	int num, i, err;
> +
> +	num = aem_find_aem1_count(probe);
> +	for (i = 0; i < num; i++) {
> +		err = aem_init_aem1_inst(probe, i);
> +		if (err) {
> +			dev_err(probe->bmc_device,
> +				"Error %d initializing AEM1 0x%X\n",
> +				err, i);
> +			return;

Should the error really be dropped on the floor?

> +		}
> +	}
> +}
> +
>
> ...
>
> +/* Find and initialize one AEM2 instance */
> +static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
> +			      struct aem_find_instance_resp *fi_resp)
> +{
> +	struct aem2_data *data;
> +	int i;
> +	int res = -ENOMEM;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return res;
> +	mutex_init(&data->fw.lock);
> +
> +	/* Copy instance data */
> +	data->fw.ver_major = fi_resp->major;
> +	data->fw.ver_minor = fi_resp->minor;
> +	data->fw.module_handle = fi_resp->module_handle;
> +	for (i = 0; i < AEM2_NUM_ENERGY_REGS; i++)
> +		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
> +
> +	/* Create sub-device for this fw instance */
> +	if (aem2_idr_get(&data->fw.id))
> +		goto id_err;
> +
> +	data->fw.pdev = platform_device_alloc(DRVNAME "2", data->fw.id);

platform_device_alloc() can fail.

> +	data->fw.pdev->dev.driver = &aem_driver;

which will result in an oops here.


> +	if (IS_ERR(data->fw.pdev))

platform_device_alloc() returns NULL on failure, not ERR_PTR.

> +		goto dev_err;
> +
> +	res = platform_device_add(data->fw.pdev);
> +	if (res)
> +		goto ipmi_err;
> +
> +	dev_set_drvdata(&data->fw.pdev->dev, &data->fw);
> +
> +	/* Set up IPMI interface */
> +	if (aem_init_ipmi_data(&data->fw.ipmi, probe->interface,
> +			       probe->bmc_device))
> +		goto ipmi_err;
> +
> +	/* Register with hwmon */
> +	data->fw.hwmon_dev = hwmon_device_register(&data->fw.pdev->dev);
> +
> +	if (IS_ERR(data->fw.hwmon_dev)) {
> +		dev_err(&data->fw.pdev->dev, "Unable to register hwmon "
> +			"device for IPMI interface %d\n",
> +			probe->interface);
> +		goto hwmon_reg_err;
> +	}
> +
> +	/* Find sensors */
> +	if (aem2_find_sensors(data))
> +		goto sensor_err;
> +
> +	/* Add to our list of AEM2 devices */
> +	list_add_tail(&data->list, &driver_data.aem2_devices);
> +	dev_info(data->fw.ipmi.bmc_device, "Found AEM v%d.%d at 0x%X\n",
> +		 data->fw.ver_major, data->fw.ver_minor,
> +		 data->fw.module_handle);
> +	return 0;
> +
> +sensor_err:
> +	hwmon_device_unregister(data->fw.hwmon_dev);
> +hwmon_reg_err:
> +	ipmi_destroy_user(data->fw.ipmi.user);
> +ipmi_err:
> +	dev_set_drvdata(&data->fw.pdev->dev, NULL);
> +	platform_device_unregister(data->fw.pdev);
> +dev_err:
> +	aem2_idr_put(data->fw.id);
> +id_err:
> +	kfree(data);
> +
> +	return res;
> +}
> +
> +/* Find and initialize all AEM2 instances */
> +static void aem_init_aem2(struct aem_ipmi_data *probe)
> +{
> +	struct aem_find_instance_resp fi_resp;
> +	int err;
> +	int i = 0;
> +
> +	while (!aem_find_aem2(probe, &fi_resp, i)) {
> +		if (fi_resp.major != 2) {
> +			dev_err(probe->bmc_device, "Unknown AEM v%d; please "
> +				"report this to the maintainer.\n",
> +				fi_resp.major);
> +			i++;
> +			continue;
> +		}
> +		err = aem_init_aem2_inst(probe, &fi_resp);
> +		if (err) {
> +			dev_err(probe->bmc_device,
> +				"Error %d initializing AEM2 0x%X\n",
> +				err, fi_resp.module_handle);
> +			return;
> +		}
> +		i++;
> +	}
> +}
> +
> +/* Delete an AEM2 instance */
> +AEM_DELETE(aem2)
> +
> +/* Sensor support functions */
> +
> +/* Read a sensor value */
> +static int aem_read_sensor(struct aem_fw_data *fwdata, u8 elt, u8 reg,
> +			   void *data, size_t size)
> +{
> +	int rs_size;
> +	struct aem_read_sensor_req	rs_req;
> +	struct aem_read_sensor_resp	*rs_resp;
> +	struct aem_ipmi_data *ipmi = &fwdata->ipmi;
> +
> +	/* AEM registers are 1, 2, 4 or 8 bytes */
> +	switch (size) {
> +	case 1:
> +	case 2:
> +	case 4:
> +	case 8:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	rs_req.id = system_x_id;
> +	rs_req.module_handle = fwdata->module_handle;
> +	rs_req.element = elt;
> +	rs_req.subcommand = AEM_READ_REGISTER;
> +	rs_req.reg = reg;
> +	rs_req.rx_buf_size = size;
> +
> +	ipmi->tx_message.cmd = AEM_ELEMENT_CMD;
> +	ipmi->tx_message.data = (char *)&rs_req;
> +	ipmi->tx_message.data_len = sizeof(rs_req);
> +
> +	rs_size = sizeof(*rs_resp) + size;
> +	rs_resp = kzalloc(rs_size, GFP_KERNEL);
> +	if (!rs_resp)
> +		return -ENOMEM;
> +
> +	ipmi->rx_msg_data = rs_resp;
> +	ipmi->rx_msg_len = rs_size;
> +
> +	aem_send_message(ipmi);
> +
> +	wait_for_completion(&ipmi->read_complete);
> +
> +	if (ipmi->rx_result || ipmi->rx_msg_len != rs_size ||
> +	    memcmp(&rs_resp->id, &system_x_id, sizeof(system_x_id))) {
> +		kfree(rs_resp);
> +		return -ENOENT;
> +	}
> +
> +	switch (size) {
> +	case 1: {
> +		u8 *x = data;
> +		*x = rs_resp->bytes[0];
> +		break;
> +	}
> +	case 2: {
> +		u16 *x = data;
> +		*x = be16_to_cpup((u16 *)rs_resp->bytes);
> +		break;
> +	}
> +	case 4: {
> +		u32 *x = data;
> +		*x = be32_to_cpup((u32 *)rs_resp->bytes);
> +		break;
> +	}
> +	case 8: {
> +		u64 *x = data;
> +		*x = be64_to_cpup((u64 *)rs_resp->bytes);
> +		break;
> +	}
> +	}
> +
> +	return 0;
> +}
> +
> +/* Update AEM1 energy sensors */
> +static void update_aem1_energy_sensors(struct aem1_data *data)
> +{
> +	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT, 0, &data->energy, 8);
> +}
> +
> +/* Update all AEM1 sensors */
> +static void update_aem1_sensors(struct aem1_data *data)
> +{
> +	mutex_lock(&data->fw.lock);
> +	if (time_before(jiffies, data->fw.last_updated + REFRESH_INTERVAL) &&
> +	    data->fw.valid)
> +		goto out;
> +
> +	update_aem1_energy_sensors(data);
> +out:
> +	mutex_unlock(&data->fw.lock);
> +}
> +
> +/* Update AEM2 energy sensors */
> +static void update_aem2_energy_sensors(struct aem2_data *data)
> +{
> +	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT,	0, &data->energy[0], 8);
> +	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT,	1, &data->energy[1], 8);
> +}
> +
> +/* Update all AEM2 sensors */
> +static void update_aem2_sensors(struct aem2_data *data)
> +{
> +	int i;
> +
> +	mutex_lock(&data->fw.lock);
> +	if (time_before(jiffies, data->fw.last_updated + REFRESH_INTERVAL) &&
> +	    data->fw.valid)
> +		goto out;
> +
> +	update_aem2_energy_sensors(data);
> +	aem_read_sensor(&data->fw, AEM_EXHAUST_ELEMENT,	0, &data->temp[0], 1);
> +	aem_read_sensor(&data->fw, AEM_EXHAUST_ELEMENT,	1, &data->temp[1], 1);
> +
> +	for (i = POWER_CAP; i <= POWER_AUX; i++)
> +		aem_read_sensor(&data->fw, AEM_POWER_CAP_ELEMENT, i,
> +				&data->pcap[i], 2);
> +out:
> +	mutex_unlock(&data->fw.lock);
> +}
> +
> +/* sysfs support functions */
> +
> +#define AEM_SHOW_POWER(type) \
> +static ssize_t type##_show_power(struct device *dev, \
> +				 struct device_attribute *devattr, \
> +				 char *buf) \
> +{ \
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
> +	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
> +	struct type##_data * a = container_of(fwdata, \
> +						 struct type##_data, fw); \
> +	u64 before, after; \
> +	signed long leftover; \
> +\
> +	mutex_lock(&fwdata->lock); \
> +	update_##type##_energy_sensors(a); \
> +	before = a->energy[attr->index]; \
> +\
> +	leftover = schedule_timeout_interruptible( \
> +			msecs_to_jiffies(a->power_period[attr->index]) \
> +		   ); \
> +	if (leftover) { \
> +		mutex_unlock(&fwdata->lock); \
> +		return 0; \
> +	} \
> +\
> +	update_##type##_energy_sensors(a); \
> +	after = a->energy[attr->index]; \
> +	mutex_unlock(&fwdata->lock); \
> +\
> +	return sprintf(buf, "%llu\n", (after - before) * 1000000 / \
> +		       a->power_period[attr->index]); \
> +}
> +
> +/* Display energy use */
> +#define AEM_SHOW_ENERGY(type) \
> +static ssize_t type##_show_energy(struct device *dev, \
> +				  struct device_attribute *devattr, \
> +				  char *buf) \
> +{ \
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
> +	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
> +	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
> +	update_##type##_sensors(a); \
> +\
> +	return sprintf(buf, "%llu\n", a->energy[attr->index] * 1000); \
> +}
> +
> +/* Display power interval registers */
> +#define AEM_SHOW_POWER_PERIOD(type) \
> +static ssize_t type##_show_power_period(struct device *dev, \
> +					struct device_attribute *devattr, \
> +					char *buf) \
> +{ \
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
> +	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
> +	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
> +	update_##type##_sensors(a); \
> +\
> +	return sprintf(buf, "%d\n", a->power_period[attr->index]); \
> +}
> +
> +/* Set power interval registers */
> +#define AEM_SET_POWER_PERIOD(type) \
> +static ssize_t type##_set_power_period(struct device *dev, \
> +				       struct device_attribute *devattr, \
> +				       const char *buf, size_t count) \
> +{ \
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
> +	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
> +	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
> +	int temp = simple_strtol(buf, NULL, 10); \
> +\
> +	if (temp < AEM_MIN_POWER_INTERVAL) \
> +		return -EINVAL; \
> +\
> +	mutex_lock(&a->fw.lock); \
> +	a->power_period[attr->index] = temp; \
> +	mutex_unlock(&a->fw.lock); \
> +\
> +	return count; \
> +}
> +
> +/* Remove sensors attached to an AEM device */
> +#define AEM_REMOVE_SENSORS(type, num_sensors) \
> +static void type##_remove_sensors(struct type##_data *data) \
> +{ \
> +	int i; \
> +\
> +	for (i = 0; i < num_sensors; i++) { \
> +		if (!data->sensors[i].dev_attr.attr.name) \
> +			continue; \
> +		device_remove_file(&data->fw.pdev->dev, \
> +				   &data->sensors[i].dev_attr); \
> +	} \
> +\
> +	device_remove_file(&data->fw.pdev->dev, \
> +			   &sensor_dev_attr_name.dev_attr); \
> +}

ho hum.


