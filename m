Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbXFSNjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbXFSNjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXFSNi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:38:56 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:59577 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751718AbXFSNiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:38:55 -0400
Date: Tue, 19 Jun 2007 15:39:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] I2C: TSL2550 support.
Message-ID: <20070619153940.0e120fb0@hyperion.delvare>
In-Reply-To: <20070619121020.GA8902@enneenne.com>
References: <5d5443650706190428q341a50a1obae68b2565d0ed7@mail.gmail.com>
	<20070619121020.GA8902@enneenne.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,

On Tue, 19 Jun 2007 14:10:20 +0200, Rodolfo Giometti wrote:
> Add support for Taos TSL2550 ambient light sensors.
> (http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>

Did you ever read my review of your driver?
http://lists.lm-sensors.org/pipermail/i2c/2007-February/000824.html

I'm asking because you never replied and I don't see any of my
suggestions implemented in this new version of your driver.

> diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
> index ea085a0..b59c013 100644
> --- a/drivers/i2c/chips/Kconfig
> +++ b/drivers/i2c/chips/Kconfig
> @@ -124,4 +124,14 @@ config SENSORS_MAX6875
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called max6875.
>  
> +config SENSORS_TSL2550
> +	tristate "Taos TSL2550 ambient light sensor"
> +	depends on I2C && EXPERIMENTAL

You can now omit "I2C", it's handled at menu level.

> +	help
> +	  If you say yes here you get support for the Taos TSL2550
> +	  ambient light sensor.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tsl2550.
> +
>  endmenu

> +static struct i2c_driver tsl2550_driver;
> +static int __devinit tsl2550_probe(struct i2c_client *client)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct tsl2550_data *data;
> +	int *opmode, err = 0;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE
> +				     | I2C_FUNC_SMBUS_WRITE_BYTE_DATA)) {
> +		err = -EIO;
> +		goto exit;
> +	}
> +
> +	data = kzalloc(sizeof(struct tsl2550_data), GFP_KERNEL);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +	data->client = client;
> +	i2c_set_clientdata(client, data);
> +	
> +	/* Check platform data */
> +	opmode = client->dev.platform_data;
> +	if (opmode) {
> +		if (*opmode < 0 || *opmode > 1) {
> +			dev_err(&client->dev, "invalid operating_mode (%d)\n",
> +					*opmode);
> +			err = -EINVAL;
> +			goto exit_kfree;
> +		}
> +		data->operating_mode = *opmode;
> +	} else
> +		data->operating_mode = 0;	/* default mode is standard */
> +	dev_info(&client->dev, "%s operating mode\n",
> +			data->operating_mode ? "extended" : "standard");
> +
> +	/*
> +	 * Probe the chip. To do so we try to power up the device and then to
> +	 * read back the 0x03 code
> +	 */
> +	err = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
> +	if (err < 0)
> +		goto exit_kfree;
> +	mdelay(1);
> +	err = i2c_smbus_read_byte(client);
> +	if (err != TSL2550_POWER_UP) {
> +		err = -ENODEV;
> +		goto exit_kfree;
> +	}
> +
> +	mutex_init(&data->update_lock);
> +
> +	/* Initialize the TSL2550 chip */
> +	tsl2550_init_client(client);
> +
> +	/* Register sysfs hooks */
> +	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
> +	if (err)
> +		goto exit_kfree;
> +
> +	dev_info(&client->dev,
> +		"TSL2550 I2C support enabled - ver. %s\n", DRIVER_VERSION);
> +	dev_info(&client->dev,
> +		"Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>\n");
> +
> +	return 0;
> +
> +exit_kfree:
> +	kfree(data);

A call to "i2c_set_clientdata(client, NULL)" at this point would be
welcome.

> +exit:
> +	return err;
> +}
> +
> +static int __devexit tsl2550_remove(struct i2c_client *client)
> +{
> +	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
> +
> +	/* Power doen the device */
> +	tsl2550_set_power_state(client, 0);
> +
> +	kfree(i2c_get_clientdata(client));

Same here.

> +
> +	return 0;
> +}

Thanks,
-- 
Jean Delvare
