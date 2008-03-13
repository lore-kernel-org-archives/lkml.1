Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYCMUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYCMUBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYCMUBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:01:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43457 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967AbYCMUBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:01:15 -0400
Date: Thu, 13 Mar 2008 21:00:12 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] atmel_lcdfb: suspend/resume support
Message-ID: <20080313210012.5b9b97c5@siona.local>
In-Reply-To: <200803131219.38154.david-b@pacbell.net>
References: <47D53CFC.8050907@atmel.com>
	<20080313162454.3859ef1a@hskinnemo-gx620.norway.atmel.com>
	<200803131219.38154.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 19:59:31.0929 (UTC) FILETIME=[C0D19490:01C88544]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 11:19:37 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> 
> > > +	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
> > 
> > You're saving CONTRAST_VAL into a field called saved_lcdcon even though
> > it has nothing to do with LCDCON1 or LCDCON2...
> 
> Yeah, why don't registers named LCDCONx have nothing
> to do with LCD CONtrast?  Better to have named the PWM
> registers PWM ... and say they could be used for either
> contrast or backlight control.

While I admit you have a point, I think it's easier to change the name
of that field than changing the hardware documentation at this point ;)

> The saved contrast/backlight counter value CONTRAST_VAL is
> one of two PWM control registers.

I know.

> > > +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
> > 
> > ...then you're altering CONTRAST_CTR...
> 
> That's forces the contrast signal low and disables the
> PWM counter, so it won't "randomly" leave the PWM output
> high when the clock is stopped (leaving at least some
> displays lit during suspend).

I'm not saying it's the wrong thing to do. I just think it's strange
that you alter a different register than the one you saved.

> It's possible that only CTR needed to be saved; all the
> backlight support in this driver still needs work.

Yes, I do think we can assume VAL stays unchanged during suspend.

> > > +}
> > > +
> > > +static int atmel_lcdfb_resume(struct platform_device *pdev)
> > > +{
> > 
> > > +	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
> > 
> > ...and later restoring the saved value of CONTRAST_VAL into CONTRAST_CTR.
> > 
> > Confused.
> 
> Yeah, that looks wrong; the patch below makes more sense.
> Though it *does* behave right for some reason...

Yes, that looks better. Perhaps you used a contrast value that happened
to set the right bits when written to CTR?

I still think the name of the saved_lcdcon field is confusing though.

Haavard
