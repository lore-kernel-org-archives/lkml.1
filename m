Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZANRsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZANRsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZANRr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:47:56 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:35698 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZANRrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:47:55 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <496E2546.8090002@gmail.com>
Date: Wed, 14 Jan 2009 17:47:50 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Mark Brown <broonie@sirena.org.uk>, Mike Rapoport <mike@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] mfd: DA9030 USB charge pump mode selection support
References: <4943FA3E.9090507@cam.ac.uk> <49461CFB.9080108@compulab.co.il> <20081215104730.GA31145@sirena.org.uk> <49465315.2070708@cam.ac.uk>
In-Reply-To: <49465315.2070708@cam.ac.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

Anyone had a chance to have a look at this?
I have a board config waiting on this or something with the same
functionality getting merged.

Thanks,

Jonathan
> From: Jonathan Cameron <jic23@cam.ac.uk>
>
> Add support for changing the mode of the da9030 usb charge pump
>
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>
> --
>
> This version simply adds the functionality to the da903x mfd driver
> core. If anyone can suggest a way round simply maintaining a
> global pointer to the device it would be good.
>
> To be able to call this from a board config file the driver must be
> built in rather than a module but enforcing that is down to the
> board Kconfig entry.
>
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 0b5bd85..600e884 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -472,6 +472,32 @@ failed:
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
>  static int __devinit da903x_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {
> @@ -487,6 +513,7 @@ static int __devinit da903x_probe(struct i2c_client *client,
>  	chip->client = client;
>  	chip->dev = &client->dev;
>  	chip->ops = &da903x_ops[id->driver_data];
> +	da9030_mfd_dev = &client->dev;
>  
>  	mutex_init(&chip->lock);
>  	INIT_WORK(&chip->irq_work, da903x_irq_work);
> @@ -547,6 +574,7 @@ static struct i2c_driver da903x_driver = {
>  
>  static int __init da903x_init(void)
>  {
> +	da9030_mfd_dev = NULL;
>  	return i2c_add_driver(&da903x_driver);
>  }
>  module_init(da903x_init);
> diff --git a/include/linux/mfd/da903x.h b/include/linux/mfd/da903x.h
> index cad314c..0f12331 100644
> --- a/include/linux/mfd/da903x.h
> +++ b/include/linux/mfd/da903x.h
> @@ -189,6 +190,13 @@ extern int da903x_unregister_notifier(struct device *dev,
>  
>  extern int da903x_query_status(struct device *dev, unsigned int status);
>  
> +#define DA9030_USBPUMP_AUTO 1
> +#define DA9030_USBPUMP_CHARGE_PUMP 2
> +#define DA9030_USBPUMP_CURRENT_SOURCE 3
> +
> +#define DA9030_USBPUMP_REG 0x19
> +
> +int da9030_set_usb_charge_pump_mode(int mode);
>  
>  /* NOTE: the two functions below are not intended for use outside
>   * of the DA9034 sub-device drivers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

