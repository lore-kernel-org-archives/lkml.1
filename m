Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXFZErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXFZErS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXFZErJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:47:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbXFZErI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:47:08 -0400
Date: Mon, 25 Jun 2007 21:46:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ab@mycable.de, mgreer@mvista.com,
       khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [PATCH 1/2] rtc: add rtc-m41t80 driver
Message-Id: <20070625214620.6a48a02a.akpm@linux-foundation.org>
In-Reply-To: <20070621.020934.59464708.anemo@mba.ocn.ne.jp>
References: <20070621.020934.59464708.anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007 02:09:34 +0900 (JST) Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> This is a new-style i2c driver for ST M41T80 series RTC chip, derived
> from works by Alexander Bigga <ab@mycable.de> who wrote the original
> rtc-m41txx.c based on drivers/i2c/chips/m41t00.c driver.
> 
> This driver supports M41T8[0-4] and M41ST8[457].  The old m41t00
> driver supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00
> chip is now supported by rtc-ds1307 driver, this driver does not
> include support for the chip.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Alexander Bigga <ab@mycable.de>
> Acked-by: Mark A. Greer <mgreer@mvista.com>
>
> ...
>
> +static int m41t80_probe(struct i2c_client *client)
> +{
> +	int i, rc = 0;
> +	struct rtc_device *rtc = NULL;
> +	struct rtc_time tm;
> +	struct m41t80_platform_data *pdata = client->dev.platform_data;
> +	const static struct m41t80_chip_info *chip;

It's a bit weird that `chip' has static storage class here.  Was that
deliberate?


> +	struct m41t80_data *clientdata = NULL;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
> +				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		rc = -ENODEV;
> +		goto exit;
> +	}
> +
> +	dev_info(&client->dev,
> +		 "chip found, driver version " DRV_VERSION "\n");
> +
> +	chip = NULL;
> +	for (i = 0; i < ARRAY_SIZE(m41t80_chip_info_tbl); i++) {
> +		if (!strcmp(m41t80_chip_info_tbl[i].name, client->name)) {
> +			chip = &m41t80_chip_info_tbl[i];
> +			break;
> +		}
> +	}
> +	if (!chip) {
> +		dev_err(&client->dev, "%s is not supported\n", client->name);
> +		rc = -ENODEV;
> +		goto exit;
> +	}
> +
> +	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
> +	if (!clientdata) {
> +		rc = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	rtc = rtc_device_register(client->name, &client->dev,
> +				  &m41t80_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc)) {
> +		rc = PTR_ERR(rtc);
> +		rtc = NULL;
> +		goto exit;
> +	}
> +
> +	clientdata->rtc = rtc;
> +	clientdata->chip = chip;
> +	i2c_set_clientdata(client, clientdata);
> +
> +	/* If asked, disable SQW, set SQW frequency & re-enable */
> +	if (pdata && pdata->sqw_freq) {
> +		rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
> +		if (rc < 0)
> +			goto sqw_err;
> +		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
> +					      rc & ~0x40) < 0 ||
> +		    i2c_smbus_write_byte_data(client, M41T80_REG_SQW,
> +					      pdata->sqw_freq) < 0 ||
> +		    i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
> +					      rc | 0x40) < 0)
> +			goto sqw_err;
> +	}
> +
> +	/* Make sure HT (Halt Update) bit is cleared */
> +	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
> +	if (rc < 0)
> +		goto ht_err;
> +
> +	if (rc & M41T80_ALHOUR_HT) {
> +		if (chip->features & M41T80_FEATURE_HT) {
> +			m41t80_get_datetime(client, &tm);
> +			dev_info(&client->dev, "HT bit was set!\n");
> +			dev_info(&client->dev,
> +				 "Power Down at "
> +				 "%04i-%02i-%02i %02i:%02i:%02i\n",
> +				 tm.tm_year + 1900,
> +				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
> +				 tm.tm_min, tm.tm_sec);
> +		}
> +		if (i2c_smbus_write_byte_data(client,
> +					      M41T80_REG_ALARM_HOUR,
> +					      rc & ~M41T80_ALHOUR_HT) < 0)
> +			goto ht_err;
> +	}
> +
> +	/* Make sure ST (stop) bit is cleared */
> +	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
> +	if (rc < 0)
> +		goto st_err;
> +
> +	if (rc & M41T80_SEC_ST) {
> +		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
> +					      rc & ~M41T80_SEC_ST) < 0)
> +			goto st_err;
> +	}
> +
> +	rc = m41t80_sysfs_register(&client->dev);
> +	if (rc)
> +		goto exit;
> +
> +	return 0;
> +
> +st_err:
> +	rc = -EIO;
> +	dev_err(&client->dev, "Can't clear ST bit\n");
> +	goto exit;
> +ht_err:
> +	rc = -EIO;
> +	dev_err(&client->dev, "Can't clear HT bit\n");
> +	goto exit;
> +sqw_err:
> +	rc = -EIO;
> +	dev_err(&client->dev, "Can't set SQW Frequency\n");
> +
> +exit:
> +	if (rtc)
> +		rtc_device_unregister(rtc);
> +	kfree(clientdata);
> +	return rc;
> +}

