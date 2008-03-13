Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYCMTTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYCMTTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMTTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:19:41 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43490 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752036AbYCMTTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:19:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vmg/ErkolkvqmZjHwQZk2nf9DOKXPCaUJ1Nb+DjPtPOcMtmPyG06mXyJBzWxy0pDog3cvY0mp2uySVz9aszSH3PjDjn/yMirL27idUIG4EwbVwXULAmLwZT02r/c+NtKE2Em5nf3swDnijyhFcw6ZF8s9YpeEhgrxcNgC4diELg=  ;
X-YMail-OSG: KqoeoZcVM1nQ3pbF6T3gx6dZ_.tbrZ2ZPt29RcYnfTcolLJRfvjuiEY6QWXGtH4Njs_TKxJEeA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_lcdfb: suspend/resume support
Date: Thu, 13 Mar 2008 11:19:37 -0800
User-Agent: KMail/1.9.6
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47D53CFC.8050907@atmel.com> <20080313162454.3859ef1a@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080313162454.3859ef1a@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131219.38154.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Haavard Skinnemoen wrote:

> > +	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
> 
> You're saving CONTRAST_VAL into a field called saved_lcdcon even though
> it has nothing to do with LCDCON1 or LCDCON2...

Yeah, why don't registers named LCDCONx have nothing
to do with LCD CONtrast?  Better to have named the PWM
registers PWM ... and say they could be used for either
contrast or backlight control.

The saved contrast/backlight counter value CONTRAST_VAL is
one of two PWM control registers.


> > +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
> 
> ...then you're altering CONTRAST_CTR...

That's forces the contrast signal low and disables the
PWM counter, so it won't "randomly" leave the PWM output
high when the clock is stopped (leaving at least some
displays lit during suspend).

It's possible that only CTR needed to be saved; all the
backlight support in this driver still needs work.


> > +}
> > +
> > +static int atmel_lcdfb_resume(struct platform_device *pdev)
> > +{
> 
> > +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
> 
> ...and later restoring the saved value of CONTRAST_VAL into CONTRAST_CTR.
> 
> Confused.

Yeah, that looks wrong; the patch below makes more sense.
Though it *does* behave right for some reason...

- Dave


--- sam9.orig/drivers/video/atmel_lcdfb.c	2008-03-13 12:14:08.000000000 -0700
+++ sam9/drivers/video/atmel_lcdfb.c	2008-03-13 10:40:54.000000000 -0700
@@ -926,7 +926,10 @@ static int atmel_lcdfb_resume(struct pla
 	atmel_lcdfb_start_clock(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(1);
-	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_VAL, sinfo->saved_lcdcon);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR,
+			sinfo->saved_lcdcon ? contrast_ctr : 0);
+
 	return 0;
 }
 

