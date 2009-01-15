Return-Path: <linux-kernel-owner+w=401wt.eu-S1761032AbZAOGjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbZAOGjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZAOGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:38:56 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:57013 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZAOGiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:38:55 -0500
Message-ID: <496ED9EF.2050507@compulab.co.il>
Date: Thu, 15 Jan 2009 08:38:39 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       Samuel Ortiz <sameo@openedhand.com>, eric miao <eric.y.miao@gmail.com>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within
 mfd driver.
References: <496E2BE5.1050803@cam.ac.uk>
In-Reply-To: <496E2BE5.1050803@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan,
Below are my two cents :)

Jonathan Cameron wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Add support for changing the mode of the da9030 usb charge pump
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> ---
> 
> Minor changes from previous version to reflect changes in the
> driver being patched. Addtional cc's as per Mark's suggestion.
> 
> This version simply adds the functionality to the da903x mfd driver
> core. If anyone can suggest a way round simply maintaining a
> global pointer to the device it would be good.

I don't think the global pointer here is real problem. It should be *really*
weird design with two da903x.

> To be able to call this from a board config file the driver must be
> built in rather than a module but enforcing that is down to the
> board Kconfig entry.

Most probably the board with da9030 will anyway have it built-in...

> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 99f8dcf..70ec3b0 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -30,6 +30,7 @@
>  #define DA9030_SYS_CTRL_A	0x08
>  #define DA9030_SYS_CTRL_B	0x09
>  #define DA9030_FAULT_LOG	0x0a
> +#define DA9030_USBPUMP_REG	0x19
>  
>  #define DA9034_CHIP_ID		0x00
>  #define DA9034_EVENT_A		0x01
> @@ -484,6 +485,32 @@ failed:
>  	return ret;
>  }
>  
> +/* Single device assumption */
> +struct device *da9030_mfd_dev;
> +
> +int da9030_set_usb_charge_pump_mode(int mode)
> +{
> +	uint8_t val = 0;
> +
> +	if (da9030_mfd_dev == NULL)
> +		return -EINVAL;
> +
> +	switch (mode) {
> +	case DA9030_USBPUMP_AUTO:
> +		val = 0;
> +		break;
> +	case DA9030_USBPUMP_CHARGE_PUMP:
> +		val = 0x40;
> +		break;
> +	case DA9030_USBPUMP_CURRENT_SOURCE:
> +		val = 0x80;
> +		break;
> +	}
> +
> +	return da903x_write(da9030_mfd_dev, DA9030_USBPUMP_REG, val);
> +}
> +EXPORT_SYMBOL_GPL(da9030_set_usb_charge_pump_mode);
> +

Maybe we want to have 'da9030_set_usb_charge_pump_mode' as well?

>  static int __devinit da903x_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {
> @@ -499,6 +526,7 @@ static int __devinit da903x_probe(struct i2c_client *client,
>  	chip->client = client;
>  	chip->dev = &client->dev;
>  	chip->ops = &da903x_ops[id->driver_data];
> +	da9030_mfd_dev = &client->dev;
>  
>  	mutex_init(&chip->lock);
>  	INIT_WORK(&chip->irq_work, da903x_irq_work);
> @@ -559,6 +587,7 @@ static struct i2c_driver da903x_driver = {
>  
>  static int __init da903x_init(void)
>  {
> +	da9030_mfd_dev = NULL;
>  	return i2c_add_driver(&da903x_driver);
>  }
>  module_init(da903x_init);
> diff --git a/include/linux/mfd/da903x.h b/include/linux/mfd/da903x.h
> index 115dbe9..5e15305 100644
> --- a/include/linux/mfd/da903x.h
> +++ b/include/linux/mfd/da903x.h
> @@ -227,6 +227,11 @@ extern int da903x_unregister_notifier(struct device *dev,
>  
>  extern int da903x_query_status(struct device *dev, unsigned int status);
>  
> +#define DA9030_USBPUMP_AUTO		1
> +#define DA9030_USBPUMP_CHARGE_PUMP	2
> +#define DA9030_USBPUMP_CURRENT_SOURCE	3
> +
> +int da9030_set_usb_charge_pump_mode(int mode);
>  
>  /* NOTE: the functions below are not intended for use outside
>   * of the DA903x sub-device drivers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

