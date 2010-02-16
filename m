Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0BPQ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:28:50 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38111 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab0BPQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:28:49 -0500
Date: Tue, 16 Feb 2010 17:28:41 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20100216162841.GD28375@enneenne.com>
Mail-Followup-To: Grazvydas Ignotas <notasas@gmail.com>,
	linux-kernel@vger.kernel.org,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	David Woodhouse <dwmw2@infradead.org>
References: <1266011843-31828-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266011843-31828-1-git-send-email-notasas@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 4/4] power_supply: bq27x00: add BQ27500 support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 11:57:23PM +0200, Grazvydas Ignotas wrote:
> BQ27500 is newer fuel gauge chip from TI with slightly changed
> register layout and some different register semantics. Add new i2c
> ID for it and handle differences where needed. Also rename bq27200
> functions to bq27x00, as they are no longer bq27200 specific.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  drivers/power/Kconfig           |    4 +-
>  drivers/power/bq27x00_battery.c |   77 +++++++++++++++++++++++++--------------
>  2 files changed, 51 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index d4b3d67..bf14672 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -98,10 +98,10 @@ config BATTERY_WM97XX
>  	  Say Y to enable support for battery measured by WM97xx aux port.
>  
>  config BATTERY_BQ27x00
> -	tristate "BQ27200 battery driver"
> +	tristate "BQ27x00 battery driver"
>  	depends on I2C
>  	help
> -	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
> +	  Say Y here to enable support for batteries with BQ27x00 (I2C) chips.
>  
>  config BATTERY_DA9030
>  	tristate "DA9030 battery driver"
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 3da9e0a..1526d02 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -26,14 +26,17 @@
>  #include <linux/i2c.h>
>  #include <asm/unaligned.h>
>  
> -#define DRIVER_VERSION			"1.0.0"
> +#define DRIVER_VERSION			"1.1.0"
>  
>  #define BQ27x00_REG_TEMP		0x06
>  #define BQ27x00_REG_VOLT		0x08
> -#define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
>  #define BQ27x00_REG_AI			0x14
>  #define BQ27x00_REG_FLAGS		0x0A
>  
> +#define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
> +
> +#define BQ27500_REG_SOC			0x2c
> +
>  /* If the system has several batteries we need a different name for each
>   * of them...
>   */
> @@ -46,11 +49,14 @@ struct bq27x00_access_methods {
>  		struct bq27x00_device_info *di);
>  };
>  
> +enum bq27x00_chip { BQ27000, BQ27500 };
> +
>  struct bq27x00_device_info {
>  	struct device 		*dev;
>  	int			id;
>  	struct bq27x00_access_methods	*bus;
>  	struct power_supply	bat;
> +	enum bq27x00_chip	chip;
>  
>  	struct i2c_client	*client;
>  };
> @@ -88,7 +94,10 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
>  		return ret;
>  	}
>  
> -	return ((temp >> 2) - 273) * 10;
> +	if (di->chip == BQ27500)
> +		return temp - 2731;
> +	else
> +		return ((temp >> 2) - 273) * 10;

For further releases with more than two chips I suppose you should use
a switch here...

>  
>  /*
> @@ -125,15 +134,22 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
>  		dev_err(di->dev, "error reading current\n");
>  		return 0;
>  	}
> -	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
> -	if (ret < 0) {
> -		dev_err(di->dev, "error reading flags\n");
> -		return 0;
> -	}
> -	if ((flags & (1 << 7)) != 0) {
> -		dev_dbg(di->dev, "negative current!\n");
> -		return -curr;
> +
> +	if (di->chip == BQ27500) {
> +		/* bq27500 returns signed value */
> +		curr = (int)(s16)curr;
> +	} else {
> +		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
> +		if (ret < 0) {
> +			dev_err(di->dev, "error reading flags\n");
> +			return 0;
> +		}
> +		if ((flags & (1 << 7)) != 0) {
> +			dev_dbg(di->dev, "negative current!\n");
> +			return -curr;
> +		}

Ditto.

>  	}
> +
>  	return curr;
>  }
>  
> @@ -146,7 +162,10 @@ static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
>  	int ret;
>  	int rsoc = 0;
>  
> -	ret = bq27x00_read(BQ27x00_REG_RSOC, &rsoc, 1, di);
> +	if (di->chip == BQ27500)
> +		ret = bq27x00_read(BQ27500_REG_SOC, &rsoc, 0, di);
> +	else
> +		ret = bq27x00_read(BQ27000_REG_RSOC, &rsoc, 1, di);
>  	if (ret) {
>  		dev_err(di->dev, "error reading relative State-of-Charge\n");
>  		return ret;

Ditto.

> @@ -197,10 +216,10 @@ static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
>  }
>  
>  /*
> - * BQ27200 specific code
> + * i2c specific code
>   */
>  
> -static int bq27200_read(u8 reg, int *rt_value, int b_single,
> +static int bq27x00_read_i2c(u8 reg, int *rt_value, int b_single,
>  			struct bq27x00_device_info *di)
>  {
>  	struct i2c_client *client = di->client;
> @@ -239,7 +258,7 @@ static int bq27200_read(u8 reg, int *rt_value, int b_single,
>  	return err;
>  }
>  
> -static int bq27200_battery_probe(struct i2c_client *client,
> +static int bq27x00_battery_probe(struct i2c_client *client,
>  				 const struct i2c_device_id *id)
>  {
>  	char *name;
> @@ -258,7 +277,7 @@ static int bq27200_battery_probe(struct i2c_client *client,
>  	if (retval < 0)
>  		return retval;
>  
> -	name = kasprintf(GFP_KERNEL, "bq27200-%d", num);
> +	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
>  	if (!name) {
>  		dev_err(&client->dev, "failed to allocate device name\n");
>  		retval = -ENOMEM;
> @@ -272,6 +291,7 @@ static int bq27200_battery_probe(struct i2c_client *client,
>  		goto batt_failed_2;
>  	}
>  	di->id = num;
> +	di->chip = id->driver_data;
>  
>  	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
>  	if (!bus) {
> @@ -284,7 +304,7 @@ static int bq27200_battery_probe(struct i2c_client *client,
>  	i2c_set_clientdata(client, di);
>  	di->dev = &client->dev;
>  	di->bat.name = name;
> -	bus->read = &bq27200_read;
> +	bus->read = &bq27x00_read_i2c;
>  	di->bus = bus;
>  	di->client = client;
>  
> @@ -314,7 +334,7 @@ batt_failed_1:
>  	return retval;
>  }
>  
> -static int bq27200_battery_remove(struct i2c_client *client)
> +static int bq27x00_battery_remove(struct i2c_client *client)
>  {
>  	struct bq27x00_device_info *di = i2c_get_clientdata(client);
>  
> @@ -335,27 +355,28 @@ static int bq27200_battery_remove(struct i2c_client *client)
>   * Module stuff
>   */
>  
> -static const struct i2c_device_id bq27200_id[] = {
> -	{ "bq27200", 0 },
> +static const struct i2c_device_id bq27x00_id[] = {
> +	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
> +	{ "bq27500", BQ27500 },
>  	{},
>  };
>  
> -static struct i2c_driver bq27200_battery_driver = {
> +static struct i2c_driver bq27x00_battery_driver = {
>  	.driver = {
> -		.name = "bq27200-battery",
> +		.name = "bq27x00-battery",
>  	},
> -	.probe = bq27200_battery_probe,
> -	.remove = bq27200_battery_remove,
> -	.id_table = bq27200_id,
> +	.probe = bq27x00_battery_probe,
> +	.remove = bq27x00_battery_remove,
> +	.id_table = bq27x00_id,
>  };
>  
>  static int __init bq27x00_battery_init(void)
>  {
>  	int ret;
>  
> -	ret = i2c_add_driver(&bq27200_battery_driver);
> +	ret = i2c_add_driver(&bq27x00_battery_driver);
>  	if (ret)
> -		printk(KERN_ERR "Unable to register BQ27200 driver\n");
> +		printk(KERN_ERR "Unable to register BQ27x00 driver\n");
>  
>  	return ret;
>  }
> @@ -363,7 +384,7 @@ module_init(bq27x00_battery_init);
>  
>  static void __exit bq27x00_battery_exit(void)
>  {
> -	i2c_del_driver(&bq27200_battery_driver);
> +	i2c_del_driver(&bq27x00_battery_driver);
>  }
>  module_exit(bq27x00_battery_exit);

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
