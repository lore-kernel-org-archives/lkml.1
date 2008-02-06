Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYBFQpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYBFQpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYBFQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:45:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39496 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYBFQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:45:08 -0500
Date: Wed, 6 Feb 2008 16:44:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP Jornada 7xx handhelds
Message-ID: <20080206164435.GC32245@flint.arm.linux.org.uk>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com> <47A9A944.7090401@tiscali.nl> <47A9AA4F.80508@tiscali.nl> <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 05:33:41PM +0100, Kristoffer Ericson wrote:
> Oki, here is attempt #2 (btw, new mail or just keep thread?)

Probably better to keep the thread.  More comments 8)

> +struct jornada_bllcd_device {
> +	struct backlight_device *jorn_backlight_device;
> +	struct lcd_device *jorn_lcd_device;

We're inside a jornada file.  Do these "jorn_" prefixes add anything
useful that the reader doesn't already know?

> +static int jornada_bl_update_status(struct backlight_device *dev)
> +{
> +	int ret = 0;
> +
> +	jornada_ssp_start();
> +
> +	if (dev->props.power != FB_BLANK_UNBLANK ||
> +		dev->props.fb_blank != FB_BLANK_UNBLANK) {
> +		ret = jornada_ssp_inout(BRIGHTNESSOFF);
> +		if (ret == -ETIMEDOUT)
> +			printk(KERN_ERR "jornada720_bl:	\
> +				BrightnessOff timeout\n");
> +			/* backlight off */
> +			PPSR &= ~PPC_LDD1;
> +			PPDR |= PPC_LDD1;

Look at the above 5 lines.  What are your expectations if ret != -ETIMEDOUT?
If C were python you'd have one behaviour due to the indent...

> +
> +	} else	{	/* backlight on */

Too many spaces.

> +			PPSR |= PPC_LDD1;
> +			if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
> +			    /* send brightness value (0 is max, 255 lowest) */
> +				if (jornada_ssp_byte(JORNADA_BL_MAX_BRIGHTNESS -
> +					 dev->props.brightness) != -ETIMEDOUT)
> +				ret = (JORNADA_BL_MAX_BRIGHTNESS -
> +					dev->props.brightness);
> +			} else
> +				printk(KERN_ERR "jornada720_bl:	\
> +					SetBrightness timeout\n");
> +		}

If this corresponds with the "} else {" line, it should have one tab.  Plus
the above indented code section should probably have one less indentation.

> +	jornada_ssp_end();
> +
> +	return ret;
> +}
> +
> +/*
> + * LCD HANDLING FUNCTIONS
> + */
> +static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
> +{
> +	int ret = 0;
> +
> +	jornada_ssp_start();
> +
> +	ret = jornada_ssp_inout(SETCONTRAST);
> +
> +	if (ret == -ETIMEDOUT)
> +		printk(KERN_ERR "jornada_lcd: failure to set contrast\n");
> +	 else

Space before 'else' not required.

> +		ret = jornada_ssp_byte(contrast);
> +
> +	jornada_ssp_end();
> +
> +	return ret;
> +}
> +
> +static int jornada_lcd_set_power(struct lcd_device  *pdev, int power)
> +{
> +	if (power != FB_BLANK_UNBLANK) {
> +		/* turn off LCD */
> +		PPSR &= ~PPC_LDD2;
> +		PPDR |= PPC_LDD2;
> +	} else {
> +		/* turn on LCD */
> +		PPSR |= PPC_LDD2;
> +		}

Wrongly placed }

> +
> +	return 0;
> +}
> +
> +static int jornada_lcd_get_power(struct lcd_device *pdev)
> +{
> +	if (PPSR & PPC_LDD2)
> +		return FB_BLANK_UNBLANK;
> +	else
> +		return FB_BLANK_POWERDOWN;
> +}
> +
> +static int jornada_lcd_get_contrast(struct lcd_device *pdev)
> +{
> +	int ret;
> +
> +	/* Don't set contrast on off powerd LCD */
> +	if (jornada_lcd_get_power(pdev) != FB_BLANK_UNBLANK)
> +		return 0;
> +
> +	jornada_ssp_start();
> +
> +	ret = jornada_ssp_inout(GETCONTRAST);
> +	if (ret != -ETIMEDOUT)
> +		ret = jornada_ssp_inout(TXDUMMY);
> +	else {
> +		printk(KERN_ERR "jornada_lcd: getcontrast failed!\n");
> +		ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
> +	}
> +
> +	jornada_ssp_end();
> +
> +	return ret;
> +}
> +
> +static struct backlight_ops jornada_bl_ops = {
> +	.get_brightness = jornada_bl_get_brightness,
> +	.update_status = jornada_bl_update_status,
> +};
> +
> +static struct lcd_ops jornada_lcd_ops = {
> +	.get_contrast = jornada_lcd_get_contrast,
> +	.set_contrast = jornada_lcd_set_contrast,
> +	.get_power = jornada_lcd_get_power,
> +	.set_power = jornada_lcd_set_power,
> +};
> +
> +static int jornada_bl_probe(struct platform_device *pdev)
> +{
> +	struct jornada_bllcd_device *bllcd;
> +
> +	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
> +	if (bllcd == NULL)
> +		return -ENOMEM;
> +
> +	/* bl driver - name must match fb driver name */
> +	bllcd->jorn_backlight_device = backlight_device_register(S1D_DEVICENAME,
> +		&pdev->dev, NULL, &jornada_bl_ops);
> +
> +	if (IS_ERR(bllcd->jorn_backlight_device)) {
> +		kfree(bllcd);
> +		return PTR_ERR(bllcd->jorn_backlight_device);

Access after free.  Bad bad bad.

> +	}
> +
> +	/* lcd driver */
> +	bllcd->jorn_lcd_device = lcd_device_register(S1D_DEVICENAME,
> +				&pdev->dev, NULL, &jornada_lcd_ops);
> +	if (IS_ERR(bllcd->jorn_lcd_device)) {
> +		kfree(bllcd);
> +		return PTR_ERR(bllcd->jorn_lcd_device);

Access after free.  Bad bad bad.

> +	}
> +
> +	jornada_lcd_set_contrast(bllcd->jorn_lcd_device,
> +			JORNADA_LCD_DEFAULT_CONTRAST);
> +	jornada_lcd_set_power(bllcd->jorn_lcd_device,
> +			FB_BLANK_UNBLANK);
> +
> +	msleep(100);
> +
> +	bllcd->jorn_backlight_device->props.power
> +		= FB_BLANK_UNBLANK;
> +	bllcd->jorn_backlight_device->props.brightness
> +		= JORNADA_BL_DEFAULT_BRIGHTNESS;

If you get rid of the "jorn_" prefix, can these be on one line?

> +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> +
> +	platform_set_drvdata(pdev, bllcd);
> +	printk(KERN_INFO "HP Jornada 7xx Backlight/LCD driver activated\n");
> +
> +	return 0;
> +}
> +
> +static int jornada_bl_remove(struct platform_device *pdev)
> +{
> +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> +
> +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> +	bllcd->jorn_backlight_device->props.brightness = 0;
> +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> +
> +	backlight_device_unregister(bllcd->jorn_backlight_device);
> +	lcd_device_unregister(bllcd->jorn_lcd_device);

Leaves bllcd allocated - memory leak.

> +
> +	return 0;
> +}
> +
> +static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> +
> +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> +	bllcd->jorn_backlight_device->props.brightness = 0;
> +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> +
> +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_POWERDOWN);
> +
> +	return 0;
> +}
> +
> +static int jornada_bl_resume(struct platform_device *pdev)
> +{
> +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> +
> +	bllcd->jorn_backlight_device->props.power
> +		= FB_BLANK_UNBLANK;
> +	bllcd->jorn_backlight_device->props.brightness
> +		= JORNADA_BL_DEFAULT_BRIGHTNESS;
> +	bllcd->jorn_backlight_device->props.max_brightness
> +		= JORNADA_BL_MAX_BRIGHTNESS;
> +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> +
> +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_UNBLANK);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver jornada_bl_driver = {
> +	.probe	= jornada_bl_probe,
> +	.remove	= jornada_bl_remove,
> +#ifdef CONFIG_PM
> +	.suspend = jornada_bl_suspend,
> +	.resume = jornada_bl_resume,
> +#endif
> +	.driver = {
> +	    .name = "jornada_bllcd",

a tab, not 4 spaces.

