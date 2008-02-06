Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYBFR1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYBFR1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYBFR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:26:53 -0500
Received: from tim.rpsys.net ([194.106.48.114]:35715 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYBFR0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:26:52 -0500
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
	Jornada 7xx handhelds
From: Richard Purdie <rpurdie@rpsys.net>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
In-Reply-To: <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
	 <47A9A944.7090401@tiscali.nl> <47A9AA4F.80508@tiscali.nl>
	 <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 17:25:54 +0000
Message-Id: <1202318754.8393.24.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 17:33 +0100, Kristoffer Ericson wrote:
> Oki, here is attempt #2 (btw, new mail or just keep thread?)

Apart from the issues Russell mentioned,

--- /dev/null
+++ b/drivers/video/backlight/jornada720_bllcd.c
@@ -0,0 +1,286 @@
+/*
+ * drivers/video/backlight/jornada720_bllcd.c
+ *

We already know which file this is...

> +/*
> + * BACKLIGHT HANDLING ROUTINES
> + */
> +static int jornada_bl_get_brightness(struct backlight_device *dev)
> +{
> +	int ret;
> +
> +	/* check if backlight is on */
> +	if (!(PPSR & PPC_LDD1))
> +		return JORNADA_BL_MAX_BRIGHTNESS;
> +
> +	jornada_ssp_start();
> +	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
> +		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
> +		ret = JORNADA_BL_MAX_BRIGHTNESS + 1;

You've informed the backlight class your brightness runs from 0 to
JORNADA_BL_MAX_BRIGHTNESS by setting max_brightness. Returning
JORNADA_BL_MAX_BRIGHTNESS + 1 is invalid and confusing. -1 would
probably be a better choice.

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

and again...

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
> +	}
> +
> +	/* lcd driver */
> +	bllcd->jorn_lcd_device = lcd_device_register(S1D_DEVICENAME,
> +				&pdev->dev, NULL, &jornada_lcd_ops);
> +	if (IS_ERR(bllcd->jorn_lcd_device)) {
> +		kfree(bllcd);
> +		return PTR_ERR(bllcd->jorn_lcd_device);
> +	}

Please go over these error paths carefully, there are several problems
there...

> +	jornada_lcd_set_contrast(bllcd->jorn_lcd_device,
> +			JORNADA_LCD_DEFAULT_CONTRAST);
> +	jornada_lcd_set_power(bllcd->jorn_lcd_device,
> +			FB_BLANK_UNBLANK);
> +
> +	msleep(100);

Why is this msleep needed? If it is needed, how does the driver manage
to suspend/resume?

Richard


