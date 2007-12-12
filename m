Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbXLLK0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbXLLK0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbXLLK0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:26:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452AbXLLK03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:26:29 -0500
Date: Wed, 12 Dec 2007 02:25:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI ADS7828 A-D
Message-Id: <20071212022550.d8d3b295.akpm@linux-foundation.org>
In-Reply-To: <4754441F.1030405@linuxrealtime.co.uk>
References: <4754441F.1030405@linuxrealtime.co.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2007 17:59:59 +0000 Steve Hardy <steve@linuxrealtime.co.uk> wrote:

> Hi,
> 
> Here is a patch against 2.6.23.9 which adds support for the 
> Burr-Brown/Texas-Instruments
> ADS7828 12-bit 8-channel A-D converter.
> 
> The chip is used for voltage monitoring on the COTS processor card I am
> currently working with.
> 
> The driver simply outputs the current input voltages (in mv as specified
> in the lm-sensors sysfs interface documentation).  Any scaling required for
> a specific board is handled by user-space.  Hopefully this makes the driver
> generic enough to be generally useful.
> 
> The driver is basically a simple rehash of existing code - I used lm75 as
> the starting point, with some inspiration from other existing drivers.
> 
> ...
>
> diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
> linux-2.6.23.9/drivers/hwmon/Kconfig 
> linux-2.6.23.9-ads7828/drivers/hwmon/Kconfig
> --- linux-2.6.23.9/drivers/hwmon/Kconfig    2007-11-26 
> 17:51:43.000000000 +0000
> +++ linux-2.6.23.9-ads7828/drivers/hwmon/Kconfig    2007-11-28 

Your email client is wordwrapping the text and it replaces tabs with
spaces.  It will need a resend, please.

> @@ -530,6 +530,16 @@ config SENSORS_THMC50
>        This driver can also be built as a module.  If so, the module
>        will be called thmc50.
>  
> +config SENSORS_ADS7828
> +    tristate "Texas Instruments ADS7828"
> +    depends on I2C && EXPERIMENTAL

I wouldn't bother with EXPERIMENTAL personally.  It seems a farily
pointless thing.

> linux-2.6.23.9-ads7828/drivers/hwmon/ads7828.c

Please prepare and test patches against the latest Linus tree, from git or
from ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots

Usually it's OK to develop a new driver against the latest stable release,
but we regularly change interfaces and if we did, this driver won't even
compile.

> +static int ads7828_attach_adapter(struct i2c_adapter *adapter);
> +static int ads7828_detect(struct i2c_adapter *adapter, int address, int 
> kind);
> +static void ads7828_init_client(struct i2c_client *client);
> +static int ads7828_detach_client(struct i2c_client *client);
> +static struct ads7828_data *ads7828_update_device(struct device *dev);
> +static u16 ads7828_read_value(struct i2c_client *client, u8 reg);

I do dislike all these forward declarations, but they're all needed here
give the order of the functions.  Maybe from my Pascal-on-pdp11 days..

> +/* This is the driver that will be inserted */
> +static struct i2c_driver ads7828_driver = {
> +    .driver = {
> +        .name = "ads7828",
> +    },
> +    .id = I2C_DRIVERID_ADS7828,
> +    .attach_adapter = ads7828_attach_adapter,
> +    .detach_client = ads7828_detach_client,
> +};
> +
> +static ssize_t show_in(struct device *dev, struct device_attribute *da,
> +    char *buf)
> +{
> +    struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
> +    struct ads7828_data *data = ads7828_update_device(dev);
> +    /* Print value (in mv as specified in sysctl-interface 
> documentation) */
> +    return sprintf(buf, "%d\n", (data->adc_input[attr->index] *
> +        ads7828_lsb_resol)/1000);
> +}
> +
> +#define in_reg(offset)\
> +static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
> +    NULL, offset);
> +
> +in_reg(0);
> +in_reg(1);
> +in_reg(2);
> +in_reg(3);
> +in_reg(4);
> +in_reg(5);
> +in_reg(6);
> +in_reg(7);
> +
> +static int ads7828_attach_adapter(struct i2c_adapter *adapter)
> +{
> +    if (!(adapter->class & I2C_CLASS_HWMON))
> +        return 0;

Can this happen?

> +    return i2c_probe(adapter, &addr_data, ads7828_detect);
> +}
> +
> +static struct attribute *ads7828_attributes[] = {
> +    &sensor_dev_attr_in0_input.dev_attr.attr,
> +    &sensor_dev_attr_in1_input.dev_attr.attr,
> +    &sensor_dev_attr_in2_input.dev_attr.attr,
> +    &sensor_dev_attr_in3_input.dev_attr.attr,
> +    &sensor_dev_attr_in4_input.dev_attr.attr,
> +    &sensor_dev_attr_in5_input.dev_attr.attr,
> +    &sensor_dev_attr_in6_input.dev_attr.attr,
> +    &sensor_dev_attr_in7_input.dev_attr.attr,
> +    NULL
> +};
> +
> +static const struct attribute_group ads7828_group = {
> +    .attrs = ads7828_attributes,
> +};
> +
> +/* This function is called by i2c_detect */
> +static int ads7828_detect(struct i2c_adapter *adapter, int address, int 
> kind)
> +{
> +    struct i2c_client *new_client;
> +    struct ads7828_data *data;
> +    int err = 0, ch = 0;
> +    const char *name = "";
> +    u8 cmd;
> +    u16 in_data;
> +
> +    /* Check we have a valid client */
> +    if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> +                         I2C_FUNC_SMBUS_WORD_DATA))
> +        goto exit;
> +
> +    /* OK. For now, we presume we have a valid client. We now create the
> +         client structure, even though we cannot fill it completely yet.
> +         But it allows us to access ads7828_read_value. */
> +    data = kmalloc(sizeof(struct ads7828_data), GFP_KERNEL);
> +    if (!data)
> +        err = -ENOMEM;
> +        goto exit;
> +    }
> +    memset(data, 0, sizeof(struct ads7828_data));

Use kzalloc() above, remove the memset.

> +    new_client = &data->client;
> +    i2c_set_clientdata(new_client, data);
> +    new_client->addr = address;
> +    new_client->adapter = adapter;
> +    new_client->driver = &ads7828_driver;
> +    new_client->flags = 0;
> +
> +    /* Perform local initialisation */
> +    ads7828_init_client(new_client);
> +
> +    /* Now, we do the remaining detection. There is no identification
> +    dedicated register so attempt to sanity check using knowledge of 
> the chip
> +    - Read from the 8 channel addresses
> +    - Check the top 4 bits of each result are not set (12 data bits)
> +    */
> +    if (kind < 0) {
> +        for (ch = 0; ch < ADS7828_NCH; ch++) {
> +            /* cmd byte C2,C1,C0 - see datasheet */
> +            cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
> +            cmd |= ads7828_cmd_byte;
> +            in_data = ads7828_read_value(new_client, cmd);
> +            if (in_data & 0xF000) {
> +                printk(KERN_DEBUG
> +                "%s : Doesn't look like an ads7828 device\n",
> +                __FUNCTION__);
> +                goto exit_free;
> +            }
> +        }
> +    }
> +
> +    /* Determine the chip type - only one kind supported! */
> +    if (kind <= 0)
> +        kind = ads7828;
> +
> +    if (kind == ads7828)
> +        name = "ads7828";
> +
> +    /* Fill in the remaining client fields, put it into the global list */
> +    strlcpy(new_client->name, name, I2C_NAME_SIZE);
> +    data->valid = 0;
> +    mutex_init(&data->update_lock);
> +
> +    /* Tell the I2C layer a new client has arrived */
> +    err = i2c_attach_client(new_client);
> +    if (err)
> +        goto exit_free;
> +
> +    /* Register sysfs hooks */
> +    err = sysfs_create_group(&new_client->dev.kobj, &ads7828_group);
> +    if (err)
> +        goto exit_detach;
> +
> +    data->class_dev = hwmon_device_register(&new_client->dev);
> +    if (IS_ERR(data->class_dev)) {
> +        err = PTR_ERR(data->class_dev);
> +        goto exit_remove;
> +    }
> +
> +    return 0;
> +
> +exit_remove:
> +    sysfs_remove_group(&new_client->dev.kobj, &ads7828_group);
> +exit_detach:
> +    i2c_detach_client(new_client);
> +exit_free:
> +    kfree(data);
> +exit:
> +    return err;
> +}
>
> ...
>
> +static struct ads7828_data *ads7828_update_device(struct device *dev)
> +{
> +    struct i2c_client *client = to_i2c_client(dev);
> +    struct ads7828_data *data = i2c_get_clientdata(client);
> +    unsigned int cmd, ch;
> +
> +    mutex_lock(&data->update_lock); /* LOCK */

I don't think that comment adds a lot of value ;)

> +    if (time_after(jiffies, data->last_updated + HZ + HZ / 2)
> +            || !data->valid) {
> +        dev_dbg(&client->dev, "Starting ads7828 update\n");
> +
> +        for (ch = 0; ch < ADS7828_NCH; ch++) {
> +            /* cmd byte C2,C1,C0 - see datasheet */
> +            cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
> +            cmd |= ads7828_cmd_byte;
> +            data->adc_input[ch] = ads7828_read_value(client, cmd);
> +        }
> +        data->last_updated = jiffies;
> +        data->valid = 1;
> +    }
> +
> +    mutex_unlock(&data->update_lock); /* UNLOCK */

But that one's great!

> +    return data;
> +}
> +
> +static int __init sensors_ads7828_init(void)
> +{
> +    return i2c_add_driver(&ads7828_driver);
> +}
> +
> +static void __exit sensors_ads7828_exit(void)
> +{
> +    i2c_del_driver(&ads7828_driver);
> +}
> +
> +MODULE_AUTHOR("Steve Hardy <steve@linuxrealtime.co.uk");
> +MODULE_DESCRIPTION("ADS7828 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(sensors_ads7828_init);
> +module_exit(sensors_ads7828_exit);
> diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
> linux-2.6.23.9/include/linux/i2c-id.h 
> linux-2.6.23.9-ads7828/include/linux/i2c-id.h
> --- linux-2.6.23.9/include/linux/i2c-id.h    2007-11-26 
> 17:51:43.000000000 +0000
> +++ linux-2.6.23.9-ads7828/include/linux/i2c-id.h    2007-11-28 
> 10:02:02.000000000 +0000
> @@ -161,6 +161,7 @@
>  #define I2C_DRIVERID_FSCHER 1046
>  #define I2C_DRIVERID_W83L785TS 1047
>  #define I2C_DRIVERID_OV7670 1048    /* Omnivision 7670 camera */
> +#define I2C_DRIVERID_ADS7828 1049

It all looks reasonable.  I'd have applied it if it weren't for the
mailer-mangling.

