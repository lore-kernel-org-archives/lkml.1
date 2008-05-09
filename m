Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYEIIJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYEIIJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYEIIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:09:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6585 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbYEIIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:09:06 -0400
Date: Fri, 9 May 2008 10:08:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [i2c] [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Message-ID: <20080509100841.151eabcd@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
	<Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
	<200805071625.20430.david-b@pacbell.net>
	<Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Fri, 9 May 2008 01:43:32 +0100 (BST), Maciej W. Rozycki wrote:
>  Please do not remove other lists cc-ed as there are people interested in 
> this piece of hardware who are neither on i2c nor on rtc-linux (I am on 
> neither of the lists too).

Maybe you shouldn't have included 4 different mailing lists to start
with, especially for a patch which is rather hardware-specific and not
overly important.

> > >  Do you mean our generic I2C code emulates SMBus calls if the hardware
> > > does not support them directly?  Well, it looks to me it indeed does and
> > > you are right, but I have assumed, perhaps mistakenly, (but I generally
> > > trust if a piece of code is there, it is for a reason), that this driver
> > > checks for I2C_FUNC_SMBUS_BYTE_DATA for a purpose.
> > 
> > That purpose being:  it makes those SMBus calls explicitly.
> > (And it makes i2c_transfer calls explicitly too...)
> 
>  Then, given the emulation, the client should be satisfied with either of
> the flags instead of both at a time.  Exactly how I changed it.

You're going in the right direction, but it's not yet correct.

>  But as Atsushi-san pointed out, the block transfer transactions
> implemented by the M41T81 do not quite follow the rules of SMBus block
> transfers, so the call is out of question -- either i2c_transfer() or a
> sequence of byte transactions have to be used.

As I already wrote, what the M41T81 wants is _I2C_ block transactions,
not _SMBus_ block transactions. Both are supported by i2c-core, it's
just a matter of checking the right functionality flag and calling the
right helper function.

> (...)
>  Here is a new version of the patch.  I hope I have addressed all your
> concerns, but I am officially dead at the moment, so please do not disturb
> me until this is no longer the case.
> 
>   Maciej
> 
> patch-2.6.26-rc1-20080505-m41t80-smbus-13
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
> --- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-09 00:32:39.000000000 +0000
> @@ -6,6 +6,8 @@
>   * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
>   *
>   * 2006 (c) mycable GmbH
> + * Copyright (c) 2008  Maciej W. Rozycki
> + * Copyright (c) 2008  Atsushi Nemoto
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -15,6 +17,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/i2c.h>
> @@ -36,6 +39,8 @@
>  #define M41T80_REG_DAY	5
>  #define M41T80_REG_MON	6
>  #define M41T80_REG_YEAR	7
> +#define M41T80_REG_CONTROL	8
> +#define M41T80_REG_WATCHDOG	9
>  #define M41T80_REG_ALARM_MON	0xa
>  #define M41T80_REG_ALARM_DAY	0xb
>  #define M41T80_REG_ALARM_HOUR	0xc
> @@ -58,7 +63,7 @@
>  #define M41T80_FEATURE_HT	(1 << 0)
>  #define M41T80_FEATURE_BL	(1 << 1)
>  
> -#define DRV_VERSION "0.05"
> +#define DRV_VERSION "0.06"
>  
>  static const struct i2c_device_id m41t80_id[] = {
>  	{ "m41t80", 0 },
> @@ -78,31 +83,104 @@ struct m41t80_data {
>  	struct rtc_device *rtc;
>  };
>  
> -static int m41t80_get_datetime(struct i2c_client *client,
> -			       struct rtc_time *tm)
> +
> +static int m41t80_i2c_write(struct i2c_client *client, u8 reg, u8 num, u8 *buf)
> +{
> +	u8 wbuf[num + 1];
> +	struct i2c_msg msgs[] = {
> +		{
> +			.addr	= client->addr,
> +			.flags	= 0,
> +			.len	= num + 1,
> +			.buf	= wbuf,
> +		},
> +	};
> +
> +	wbuf[0] = reg;
> +	memcpy(wbuf + 1, buf, num);
> +	return i2c_transfer(client->adapter, msgs, 1);
> +}

This is reimplementing i2c_smbus_write_i2c_block_data().

> +
> +static int m41t80_i2c_read(struct i2c_client *client, u8 reg, u8 num, u8 *buf)
>  {
> -	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
>  	struct i2c_msg msgs[] = {
>  		{
>  			.addr	= client->addr,
>  			.flags	= 0,
>  			.len	= 1,
> -			.buf	= dt_addr,
> +			.buf	= &reg,
>  		},
>  		{
>  			.addr	= client->addr,
>  			.flags	= I2C_M_RD,
> -			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
> -			.buf	= buf + M41T80_REG_SEC,
> +			.len	= num,
> +			.buf	= buf,
>  		},
>  	};
>  
> -	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
> -		dev_err(&client->dev, "read error\n");
> -		return -EIO;
> -	}
> +	return i2c_transfer(client->adapter, msgs, 2);
> +}

And this is reimplementing i2c_smbus_read_i2c_block_data(). So please
just use these standard helpers, which have the advantage that they can
work on a number of adapters that cannot do full I2C (many SMBus
controllers support I2C block transactions as long as the length
doesn't exceed 32 bytes.)

> +
> +static int m41t80_transfer(struct i2c_client *client, int write,
> +			   u8 reg, u8 num, u8 *buf)
> +{
> +	int i, rc;
> +
> +	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {

And then here you want to check for I2C_FUNC_SMBUS_I2C_BLOCK. Or even
better, check for I2C_FUNC_SMBUS_READ_I2C_BLOCK on read and
I2C_FUNC_SMBUS_WRITE_I2C_BLOCK on write, so you get the best of each
adapter in the unlikely event an adapter would support I2C block reads
but not writes or vice-versa.

> +		if (write)
> +			i = m41t80_i2c_write(client, reg, num, buf);
> +		else
> +			i = m41t80_i2c_read(client, reg, num, buf);
> +	} else {
> +		if (write)
> +			for (i = 0; i < num; i++) {
> +				rc = i2c_smbus_write_byte_data(client, reg + i,
> +							       buf[i]);
> +				if (rc < 0)
> +					return rc;
> +			}
> +		else
> +			for (i = 0; i < num; i++) {
> +				rc = i2c_smbus_read_byte_data(client, reg + i);
> +				if (rc < 0)
> +					return rc;
> +				buf[i] = rc;
> +			}
> +	}
> +	return i;
> +}

> (...)
> @@ -629,14 +610,12 @@ static int wdt_ioctl(struct inode *inode
>  			return -EFAULT;
>  
>  		if (rv & WDIOS_DISABLECARD) {
> -			printk(KERN_INFO
> -			       "rtc-m41t80: disable watchdog\n");
> +			pr_info("rtc-m41t80: disable watchdog\n");
>  			wdt_disable();
>  		}
>  
>  		if (rv & WDIOS_ENABLECARD) {
> -			printk(KERN_INFO
> -			       "rtc-m41t80: enable watchdog\n");
> +			pr_info("rtc-m41t80: enable watchdog\n");
>  			wdt_ping();
>  		}
>  

Mixing code cleanups with functional changes is a Bad Idea (TM).

> @@ -732,19 +711,28 @@ static struct notifier_block wdt_notifie
>  static int m41t80_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
>  {
> -	int rc = 0;
>  	struct rtc_device *rtc = NULL;
>  	struct rtc_time tm;
>  	struct m41t80_data *clientdata = NULL;
> +	int rc = 0;
> +	int reg;
>  
> -	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
> -				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
> +	if ((i2c_get_functionality(client->adapter) &
> +	     (I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE_DATA)) == 0) {
>  		rc = -ENODEV;
>  		goto exit;
>  	}

That's not correct. The driver is making unconditional calls to
i2c_smbus_write_byte_data() and i2c_smbus_read_byte_data() so the
underlying adapter _must_ implement I2C_FUNC_SMBUS_BYTE_DATA. If it
additionally implements I2C_FUNC_I2C (or actually
I2C_FUNC_SMBUS_I2C_BLOCK), see above, then you can optimize some
transactions, but you don't have to check it here, the check should be
done at run-time (as you already do.)

You really shouldn't worry about making the I2C_FUNC_SMBUS_BYTE_DATA
check unconditional. I don't think I've ever seen an i2c bus driver not
supporting it.


>  
> +	/* Trivially check it's there; keep the result for the HT check.  */
> +	reg = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
> +	if (reg < 0) {
> +		rc = -ENXIO;
> +		goto exit;
> +	}
> +
>  	dev_info(&client->dev,
> -		 "chip found, driver version " DRV_VERSION "\n");
> +		 "%s chip found, driver version " DRV_VERSION "\n",
> +		 client->name);

Incorrect change, dev_info() already includes the chip name.

>  
>  	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
>  	if (!clientdata) {
> @@ -765,11 +753,7 @@ static int m41t80_probe(struct i2c_clien
>  	i2c_set_clientdata(client, clientdata);
>  
>  	/* Make sure HT (Halt Update) bit is cleared */
> -	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
> -	if (rc < 0)
> -		goto ht_err;
> -
> -	if (rc & M41T80_ALHOUR_HT) {
> +	if (reg & M41T80_ALHOUR_HT) {
>  		if (clientdata->features & M41T80_FEATURE_HT) {
>  			m41t80_get_datetime(client, &tm);
>  			dev_info(&client->dev, "HT bit was set!\n");
> @@ -780,20 +764,19 @@ static int m41t80_probe(struct i2c_clien
>  				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
>  				 tm.tm_min, tm.tm_sec);
>  		}
> -		if (i2c_smbus_write_byte_data(client,
> -					      M41T80_REG_ALARM_HOUR,
> -					      rc & ~M41T80_ALHOUR_HT) < 0)
> +		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_HOUR,
> +					      reg & ~M41T80_ALHOUR_HT) < 0)
>  			goto ht_err;
>  	}

Again coding style fixes...

>  
>  	/* Make sure ST (stop) bit is cleared */
> -	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
> -	if (rc < 0)
> +	reg = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
> +	if (reg < 0)
>  		goto st_err;
>  
> -	if (rc & M41T80_SEC_ST) {
> +	if (reg & M41T80_SEC_ST) {
>  		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
> -					      rc & ~M41T80_SEC_ST) < 0)
> +					      reg & ~M41T80_SEC_ST) < 0)
>  			goto st_err;
>  	}

And here again...

I'm not the one who will take your patch, I'll leave it to Alessandro
to tell you what he wants, but one thing for sure: it would be much
easier to review and validate your patches if you were not mixing
functional changes and code cleanups.

>  
> @@ -803,6 +786,7 @@ static int m41t80_probe(struct i2c_clien
>  
>  #ifdef CONFIG_RTC_DRV_M41T80_WDT
>  	if (clientdata->features & M41T80_FEATURE_HT) {
> +		save_client = client;
>  		rc = misc_register(&wdt_dev);
>  		if (rc)
>  			goto exit;
> @@ -811,7 +795,6 @@ static int m41t80_probe(struct i2c_clien
>  			misc_deregister(&wdt_dev);
>  			goto exit;
>  		}
> -		save_client = client;
>  	}
>  #endif
>  	return 0;

This one deserves a patch on its own IMHO.

-- 
Jean Delvare
