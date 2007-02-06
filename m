Return-Path: <linux-kernel-owner+w=401wt.eu-S965362AbXBFT1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362AbXBFT1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965344AbXBFT1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:27:07 -0500
Received: from tim.rpsys.net ([194.106.48.114]:49800 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965383AbXBFT1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:27:06 -0500
Subject: Re: [PATCH] backlight control for Frontpath ProGear HX1050+
From: Richard Purdie <rpurdie@rpsys.net>
To: Marcin Juszkiewicz <openembedded@hrw.one.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702061430.42581.openembedded@hrw.one.pl>
References: <200702061430.42581.openembedded@hrw.one.pl>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 19:26:58 +0000
Message-Id: <1170790019.5826.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 14:30 +0100, Marcin Juszkiewicz wrote:
> From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
> 
> Add control of LCD backlight for Frontpath ProGear HX1050+.
> Patch is based on http://downloads.sf.net/progear/progear-lcd-0.2.tar.gz
> driver by M Schacht.
> 
> Signed-Off-By: Marcin Juszkiewicz <openembedded@hrw.one.pl>

This is very similar to corgi_bl which I have some changes I was
considering to make it a bit more efficient/clean. The same changes
could apply to this driver:

> +static int progearbl_intensity;
> +static struct backlight_properties progearbl_data;

Not sure you need the above line?

> +static struct backlight_device *progear_backlight_device;

You shouldn't need this structure pointer (see below)

> +static int progearbl_get_intensity(struct backlight_device *bd)
> +{
> +       return progearbl_intensity;
> +}

Can you read PMU_LPCR and return it (minus HW_LEVEL_MIN) here? corgi_bl
only stores this as it can't read back from the hardware. Either
approach is probably ok (although if the register can be updated by
other means, it should be read).

> +static int progearbl_set_intensity(struct backlight_device *bd)
> +{
> +       progearbl_send_intensity(progear_backlight_device);
> +       return 0;
> +}

You can use progearbl_send_intensity(bd); here or maybe lose the
function all together?

> +static struct backlight_properties progearbl_data = {
> +       .owner = THIS_MODULE,
> +       .get_brightness = progearbl_get_intensity,
> +       .update_status = progearbl_set_intensity,

progearbl_send_intensity?

> +       pci_read_config_byte(sb_dev, SB_MPS1, &temp);
> +       pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
> +
> +       progear_backlight_device = backlight_device_register("progear-bl",
> +			   &pdev->dev, NULL, &progearbl_data);
> +       if (IS_ERR(progear_backlight_device))
> +               return PTR_ERR(progear_backlight_device);

platform_set_drvdata(pdev, progear_backlight_device);

> +       progearbl_data.power = FB_BLANK_UNBLANK;
> +       progearbl_data.brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
> +       progearbl_data.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
> +       progearbl_send_intensity(progear_backlight_device);
> +
> +       return 0;
> +}
> +
> +static int progearbl_remove(struct platform_device *dev)
> +{
> +       backlight_device_unregister(progear_backlight_device);

struct backlight_device *bd = platform_get_drvdata(pdev);
backlight_device_unregister(bd);

> +       return 0;
> +}

All pretty minor though and if you change the above, it can have an

Acked-by: Richard Purdie <rpurdie@rpsys.net>

-- 
Richard


