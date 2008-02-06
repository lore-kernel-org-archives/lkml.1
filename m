Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYBFQ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYBFQ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYBFQ0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:26:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:6533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYBFQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=pkp89D37Ew0jblrruml+3usNirvg8jbyAl58s2IFutCBygJtccdhugXqn6uczKDJ9PXoIigzJ2tM9Oc8j05EYZ15jLngE2pp7J9ezJYZWlgUoUOYur+kBmRbHCh825iuAUoOoR+JaY+wVyI9EBBIkfVkr/hTNXUVQnfKHQ8sUCA=
Date: Wed, 6 Feb 2008 17:26:53 +0100
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Russell King <linux@arm.linux.org.uk>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
Message-Id: <20080206172653.17abd2e0.Kristoffer.ericson@gmail.com>
In-Reply-To: <47A9A944.7090401@tiscali.nl>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
	<47A9A944.7090401@tiscali.nl>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 13:34:12 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Richard I've cleaned up the driver by checking with checkpatch.pl as Russell suggested. I would appreciate it if you could
> > look through the patch again and give comments since the patch looks somewhat different.
> > 
> > I can add patch for Kconfig/Makefile later on but suspect there will be some changes required before that.
> > 
> > Oh and to answer your question regarding MAX/MIN values of the backlight, 0 = max and 255 = min. So we simply turn it around
> > by returning 255 - value. Same thing when we need to set value.
> > 
> > Best wishes
> > Kristoffer Ericson
> > 
> > diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
> > new file mode 100644
> > index 0000000..4967b86
> > --- /dev/null
> > +++ b/drivers/video/backlight/jornada720_bllcd.c
> > @@ -0,0 +1,284 @@
> > +/*
> > + * drivers/video/backlight/jornada720_bllcd.c
> > + *
> > + * Backlight and LCD Driver for HP Jornada 720
> > + * Copyright (C) 2007 Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2
> > + * or any later version as published by the Free Software Foundation.
> > + *
> > + */
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/backlight.h>
> > +#include <linux/lcd.h>
> > +#include <linux/delay.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/fb.h>
> > +#include <linux/device.h>
> > +#include <asm/hardware.h>
> > +#include <asm/arch/jornada720.h>
> > +#include <video/s1d13xxxfb.h>
> > +
> > +MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
> > +MODULE_DESCRIPTION("HP Jornada 710/720/728 Backlight/LCD Driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +#define JORNADA_LCD_MAX_CONTRAST	0xff
> > +#define JORNADA_LCD_DEFAULT_CONTRAST	0x80
> > +#define JORNADA_BL_MAX_BRIGHTNESS	0xff
> > +#define JORNADA_BL_DEFAULT_BRIGHTNESS	0x19
> > +
> > +struct jornada_bllcd_device {
> > +	struct backlight_device *jorn_backlight_device;
> > +	struct lcd_device *jorn_lcd_device;
> > +};
> > +
> > +/*
> > + * BACKLIGHT HANDLING ROUTINES
> > + */
> > +static int jornada_bl_get_brightness(struct backlight_device *dev)
> > +{
> > +	int ret;
> > +
> > +	/* check if backlight is on */
> > +	if (!(PPSR & PPC_LDD1))
> > +		return 255;
> return JORNADA_BL_MAX_BRIGHTNESS;
> 

Agreed.

> > +
> > +	jornada_ssp_start();
> > +	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
> > +		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
> > +		ret = 256;
> ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
> > +	} else
> > +		ret = jornada_ssp_inout(TXDUMMY);
> > +
> > +	jornada_ssp_end();
> > +
> > +	/* 0 is max brightness */
> > +	return (255 - ret);
> return (JORNADA_BL_MAX_BRIGHTNESS - ret);

Agreed.

> > +}
> > +
> > +static int jornada_bl_update_status(struct backlight_device *dev)
> > +{
> > +	int ret = 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	if (dev->props.power != FB_BLANK_UNBLANK ||
> > +		dev->props.fb_blank != FB_BLANK_UNBLANK) {
> > +		ret = jornada_ssp_inout(BRIGHTNESSOFF);
> > +		if (ret == -ETIMEDOUT)
> > +			printk(KERN_ERR "jornada720_bl:
> > +				BrightnessOff timeout\n");
> > +		else {

else isn't needed here. It should simply tell "didn't work, turning off backlight".

> > +		/* backlight off */
> > +			PPSR &= ~PPC_LDD1;
> > +			PPDR |= PPC_LDD1;
> > +		}
> > +	} else {/* backlight on */
> > +			PPSR |= PPC_LDD1;
> 
> missing curly bracket

No, bad formatting essentially. Should make it clear that PPSR |= PPC_LDD1 is related to the lines below

> 
> > +
> > +	if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
> > +		/* send brightness value (0 is max, 255 lowest) */
> > +		if (jornada_ssp_byte(255 - dev->props.brightness) != -ETIMEDOUT)
> > +			ret = (255 - dev->props.brightness);
> 
> similarly JORNADA_BL_MAX_BRIGHTNESS in the three lines above
> 

Agreed. And formatting is wrong for those if (... show be moved a tab further.

> > +	} else
> > +		printk(KERN_ERR "jornada720_bl: SetBrightness timeout\n");
> > +	}
> > +
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +/* LCD HANDLING FUNCTIONS
> > +   ====================== */
> > +static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
> > +{
> > +	int ret = 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	ret = jornada_ssp_inout(SETCONTRAST);
> > +
> > +	if (ret == -ETIMEDOUT)
> > +		printk(KERN_INFO "jornada_lcd: failure to set contrast\n");
> > +	 else
> > +		ret = jornada_ssp_byte(contrast);
> > +
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +static int jornada_lcd_set_power(struct lcd_device  *pdev, int power)
> > +{
> > +	if (power != FB_BLANK_UNBLANK) {
> > +		/* turn off LCD */
> > +		PPSR &= ~PPC_LDD2;
> > +		PPDR |= PPC_LDD2;
> > +	} else
> > +	/* turn on LCD */
> > +	PPSR |= PPC_LDD2;
> 
> wrong indent

Yeah, formatting again.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_lcd_get_power(struct lcd_device *pdev)
> > +{
> > +	if (PPSR & PPC_LDD2)
> > +		return FB_BLANK_UNBLANK;
> > +	else
> > +		return FB_BLANK_POWERDOWN;
> > +}
> > +
> > +static int jornada_lcd_get_contrast(struct lcd_device *pdev)
> > +{
> > +	int ret;
> > +
> > +	/* Don't set contrast on off powerd LCD */
> > +	if (jornada_lcd_get_power(pdev) != FB_BLANK_UNBLANK)
> > +		return 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	ret = jornada_ssp_inout(GETCONTRAST);
> > +	if (ret != -ETIMEDOUT)
> > +		ret = jornada_ssp_inout(TXDUMMY);
> > +	else {
> > +		printk(KERN_INFO "jornada_lcd: getcontrast failed!\n");
> > +		ret = 256;
> 
> JORNADA_BL_MAX_BRIGHTNESS + 1
> 

Agreed

> > +	}
> > +
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +static struct backlight_ops jornada_bl_ops = {
> > +	.get_brightness = jornada_bl_get_brightness,
> > +	.update_status = jornada_bl_update_status,
> > +};
> > +
> > +static struct lcd_ops jornada_lcd_ops = {
> > +	.get_contrast = jornada_lcd_get_contrast,
> > +	.set_contrast = jornada_lcd_set_contrast,
> > +	.get_power = jornada_lcd_get_power,
> > +	.set_power = jornada_lcd_set_power,
> > +};
> > +
> > +static int jornada_bl_probe(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd;
> > +
> > +	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
> > +	if (bllcd == NULL)
> > +		return -ENOMEM;
> > +
> > +	/* bl driver - name must match fb driver name */
> > +	bllcd->jorn_backlight_device = backlight_device_register(S1D_DEVICENAME,
> > +				&pdev->dev, NULL, &jornada_bl_ops);
> > +
> > +	if (IS_ERR(bllcd->jorn_backlight_device)) {
> > +		kfree(bllcd);
> > +		return PTR_ERR(bllcd->jorn_backlight_device);
> > +	}
> > +
> > +	/* lcd driver */
> > +	bllcd->jorn_lcd_device = lcd_device_register(S1D_DEVICENAME,
> > +				&pdev->dev, NULL, &jornada_lcd_ops);
> > +	if (IS_ERR(bllcd->jorn_lcd_device)) {
> > +		kfree(bllcd);
> > +		return PTR_ERR(bllcd->jorn_lcd_device);
> > +	}
> > +
> > +	jornada_lcd_set_contrast(bllcd->jorn_lcd_device,
> > +			JORNADA_LCD_DEFAULT_CONTRAST);
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device,
> > +			FB_BLANK_UNBLANK);
> > +
> > +	msleep(100);
> > +
> > +	bllcd->jorn_backlight_device->props.power
> > +		= FB_BLANK_UNBLANK;
> > +	bllcd->jorn_backlight_device->props.brightness
> > +		= JORNADA_BL_DEFAULT_BRIGHTNESS;
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	platform_set_drvdata(pdev, bllcd);
> > +	printk(KERN_INFO "HP Jornada 7xx Backlight/LCD driver activated\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_remove(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> > +	bllcd->jorn_backlight_device->props.brightness = 0;
> > +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> > +
> > +	backlight_device_unregister(bllcd->jorn_backlight_device);
> > +	lcd_device_unregister(bllcd->jorn_lcd_device);
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> > +	bllcd->jorn_backlight_device->props.brightness = 0;
> > +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_POWERDOWN);
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_resume(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power
> > +		= FB_BLANK_UNBLANK;
> > +	bllcd->jorn_backlight_device->props.brightness
> > +		= JORNADA_BL_DEFAULT_BRIGHTNESS;
> > +	bllcd->jorn_backlight_device->props.max_brightness
> > +		= JORNADA_BL_MAX_BRIGHTNESS;
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_UNBLANK);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver jornada_bl_driver = {
> > +	.probe	= jornada_bl_probe,
> > +	.remove	= jornada_bl_remove,
> > +#ifdef CONFIG_PM
> > +	.suspend = jornada_bl_suspend,
> > +	.resume = jornada_bl_resume,
> > +#endif
> > +	.driver = {
> > +	    .name = "jornada_bl",
> > +	},
> > +};
> > +
> > +static int __init jornada_bl_init(void)
> > +{
> > +	return platform_driver_register(&jornada_bl_driver);
> > +}
> > +
> > +static void __exit jornada_bl_exit(void)
> > +{
> > +	platform_driver_unregister(&jornada_bl_driver);
> > +}
> > +
> > +module_init(jornada_bl_init);
> > +module_exit(jornada_bl_exit);
> 

Thanks, that formatting bug wouldn't have been easy to see.
