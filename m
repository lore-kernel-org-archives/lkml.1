Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbYCMQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbYCMQr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYCMQrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:47:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28904 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbYCMQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:47:18 -0400
X-Greylist: delayed 3012 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 12:47:17 EDT
Date: Thu, 13 Mar 2008 16:24:54 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] atmel_lcdfb: suspend/resume support
Message-ID: <20080313162454.3859ef1a@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <47D53CFC.8050907@atmel.com>
References: <47D53CFC.8050907@atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 15:24:55.0340 (UTC) FILETIME=[64019EC0:01C8851E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 14:51:56 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> +static int atmel_lcdfb_suspend(struct platform_device *pdev, pm_message_t mesg)
> +{
> +	struct fb_info *info = platform_get_drvdata(pdev);
> +	struct atmel_lcdfb_info *sinfo = info->par;
> +
> +	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);

You're saving CONTRAST_VAL into a field called saved_lcdcon even though
it has nothing to do with LCDCON1 or LCDCON2...

> +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);

...then you're altering CONTRAST_CTR...

> +}
> +
> +static int atmel_lcdfb_resume(struct platform_device *pdev)
> +{

> +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);

...and later restoring the saved value of CONTRAST_VAL into CONTRAST_CTR.

Confused.

> @@ -39,6 +39,7 @@ struct atmel_lcdfb_info {
>  	u8			bl_power;
>  #endif
>  	bool			lcdcon_is_backlight;
> +	u8			saved_lcdcon;

All of the registers involved are 32 bits wide, although the
interesting bits are all in the low byte. Do we really want to save
three bytes in the struct that badly?

Haavard
