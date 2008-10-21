Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYJUPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYJUPgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYJUPgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:36:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8245 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJUPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:35:59 -0400
Date: Tue, 21 Oct 2008 17:35:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: ben-linux@fluff.org, akpm@linux-foundation.org, i2c@lm-sensors.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [i2c] [PATCH v2] Add support for Dallas DS28CM00 Unique ID chip
Message-ID: <20081021173505.2f7673e2@hyperion.delvare>
In-Reply-To: <48FDED5E.5080605@mimc.co.uk>
References: <48FDED5E.5080605@mimc.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 15:55:26 +0100, Mark Jackson wrote:
> This patch adds support for the (I2C based) DS28CM00 ID chip.
> (v2 after running through checkpatch)
> 
> Signed-off-by: M.Jackson <mpfj@mimc.co.uk> 
> ---
>  drivers/i2c/chips/Kconfig    |    7 ++
>  drivers/i2c/chips/Makefile   |    1 +
>  drivers/i2c/chips/ds28cm00.c |  166 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 0 deletions(-)

Nack. No new drivers under drivers/i2c/chips please, it's going away
soon.

> 
> diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
> index a95cb94..98c06e7 100644
> --- a/drivers/i2c/chips/Kconfig
> +++ b/drivers/i2c/chips/Kconfig
> @@ -172,4 +172,11 @@ config MENELAUS
>  	  and other features that are often used in portable devices like
>  	  cell phones and PDAs.
>  
> +config DS28CM00
> +	tristate "DS28CM00 Serial Number chip"
> +	depends on EXPERIMENTAL
> +	help
> +	  If you say yes here you get support for the Dallas DS28CM00
> +	  Serial Number chip.
> +
>  endmenu
> diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
> index 39e3e69..f674d94 100644
> --- a/drivers/i2c/chips/Makefile
> +++ b/drivers/i2c/chips/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
>  obj-$(CONFIG_TPS65010)		+= tps65010.o
>  obj-$(CONFIG_MENELAUS)		+= menelaus.o
>  obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
> +obj-$(CONFIG_DS28CM00)		+= ds28cm00.o
>  
>  ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
>  EXTRA_CFLAGS += -DDEBUG
> diff --git a/drivers/i2c/chips/ds28cm00.c b/drivers/i2c/chips/ds28cm00.c
> new file mode 100644
> index 0000000..6abe065
> --- /dev/null
> +++ b/drivers/i2c/chips/ds28cm00.c
> @@ -0,0 +1,166 @@
> +/*
> +    ds28cm00.c - driver for DS28CM00 Serial ID chip
> +
> +    Copyright (C) 2008 Mark Jackson <mpfj@mimc.co.uk>
> +
> +    Based on i2c/chips/max6875.c
> +
> +    The DS28CM00 contains a 64bit unique number.
> +    The memory map is defined as follows:
> +     * 0x00		= Device Family Code (0x70)
> +     * 0x01 - 0x06	= Serial Number (bits 0 to 47)
> +     * 0x07		= CRC of addresses 0x00 to 0x06
> +     * 0x08		= Control Register (R/W)
> +
> +    This driver makes the Serial Number available for read.
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; version 2 of the License.
> +*/
> +
> +#include <linux/i2c.h>
> +
> +static unsigned short normal_i2c[] = {I2C_CLIENT_END};
> +
> +/* Insmod parameters */
> +I2C_CLIENT_INSMOD_1(ds28cm00);
> +
> +#define DS28CM00_CMD_WRITE	0x50
> +#define DS28CM00_CMD_READ	0x51
> +
> +#define ID_SIZE		9
> +
> +/* Each client has this additional data */
> +struct ds28cm00_data {
> +	struct i2c_client	client;
> +	struct mutex		update_lock;
> +};
> +
> +static int ds28cm00_attach_adapter(struct i2c_adapter *adapter);
> +static int ds28cm00_detect(struct i2c_adapter *adapter, int address, int kind);
> +static int ds28cm00_detach_client(struct i2c_client *client);
> +
> +/* This is the driver that will be inserted */
> +static struct i2c_driver ds28cm00_driver = {
> +	.driver = {
> +		.name	= "ds28cm00",
> +	},
> +	.attach_adapter	= ds28cm00_attach_adapter,
> +	.detach_client	= ds28cm00_detach_client,
> +};

attach_adapter and detach_client are deprecated. Please use probe and
remove instead.

> +
> +static ssize_t ds28cm00_read(struct kobject *kobj,
> +			    struct bin_attribute *bin_attr,
> +			    char *buf, loff_t off, size_t count)
> +{
> +	struct i2c_client *client = kobj_to_i2c_client(kobj);
> +
> +	if (off > ID_SIZE)
> +		return 0;
> +
> +	if (off + count > ID_SIZE)
> +		count = ID_SIZE - off;
> +
> +	if (i2c_smbus_read_i2c_block_data(client, DS28CM00_CMD_READ, count, buf) != count)
> +		return 0;
> +
> +	return count;
> +}
> +
> +static struct bin_attribute id_attr = {
> +	.attr = {
> +		.name = "id",
> +		.mode = S_IRUGO,
> +	},
> +	.size = ID_SIZE,
> +	.read = ds28cm00_read,
> +};
> +
> +static int ds28cm00_attach_adapter(struct i2c_adapter *adapter)
> +{
> +	return i2c_probe(adapter, &addr_data, ds28cm00_detect);
> +}
> +
> +/* This function is called by i2c_probe */
> +static int ds28cm00_detect(struct i2c_adapter *adapter, int address, int kind)
> +{
> +	struct i2c_client *new_client;
> +	struct ds28cm00_data *data;
> +	int err = 0;
> +
> +	printk(KERN_DEBUG "DS28CM00 I2C Serial Number driver\n");
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
> +		printk(KERN_ALERT "DS28CM00 : failed i2c_check_func()\n");
> +		return 0;
> +	}
> +
> +	data = kzalloc(sizeof(struct ds28cm00_data), GFP_KERNEL);
> +	if (!data) {
> +		printk(KERN_ALERT "DS28CM00 : failed kzalloc()\n");
> +		return -ENOMEM;
> +	}
> +
> +	new_client = &data->client;
> +	i2c_set_clientdata(new_client, data);
> +	new_client->addr = address;
> +	new_client->adapter = adapter;
> +	new_client->driver = &ds28cm00_driver;
> +	new_client->flags = 0;
> +	strlcpy(new_client->name, "ds28cm00", I2C_NAME_SIZE);
> +
> +	/* Tell the I2C layer a new client has arrived */
> +	err = i2c_attach_client(new_client);
> +	if (err) {
> +		printk(KERN_ALERT "DS28CM00 : failed i2c_attach_client()\n");
> +		goto exit_kfree;
> +	}
> +
> +	/* Register sysfs hooks */
> +	err = sysfs_create_bin_file(&new_client->dev.kobj, &id_attr);
> +	if (err) {
> +		printk(KERN_ALERT "DS28CM00 : failed sysfs_create_bin_file()\n");
> +		goto exit_detach;
> +	}
> +
> +	return 0;
> +
> +exit_detach:
> +	i2c_detach_client(new_client);
> +exit_kfree:
> +	kfree(data);
> +	return err;
> +}
> +
> +static int ds28cm00_detach_client(struct i2c_client *client)
> +{
> +	int err;
> +
> +	sysfs_remove_bin_file(&client->dev.kobj, &id_attr);
> +
> +	err = i2c_detach_client(client);
> +	if (err)
> +		return err;
> +
> +	kfree(client);
> +
> +	return 0;
> +}
> +
> +static int __init ds28cm00_init(void)
> +{
> +	return i2c_add_driver(&ds28cm00_driver);
> +}
> +
> +static void __exit ds28cm00_exit(void)
> +{
> +	i2c_del_driver(&ds28cm00_driver);
> +}
> +
> +MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
> +MODULE_DESCRIPTION("DS28CM00 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(ds28cm00_init);
> +module_exit(ds28cm00_exit);
> 
> _______________________________________________
> i2c mailing list
> i2c@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/i2c


-- 
Jean Delvare
