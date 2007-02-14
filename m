Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXBNArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXBNArK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932115AbXBNArJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:47:09 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:49260 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbXBNArI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:47:08 -0500
Date: Wed, 14 Feb 2007 00:46:49 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: vince@arm.linux.org.uk, linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: SM501 framebuffer driver
Message-ID: <20070214004649.GF19392@home.fluff.org>
References: <20070213193449.GA7701@fluff.org.uk> <Pine.LNX.4.64.0702132053110.898@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702132053110.898@pentafluge.infradead.org>
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 09:01:25PM +0000, James Simmons wrote:
> 
> > Framebuffer support for the Silicon Motion SM501
> > multi-function chip.
> > 
> > This driver provides a pair of framebuffer interfaces
> > for the CRT and LCD panel interfaces, and some basic
> > acceleration for the cursor.
> > 
> > The patch has been updated slightly from the previous
> > version to including being able to pass an initial
> > video mode through via the platform data.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > Signed-off-by: Vincent Sanders <vince@arm.linux.org.uk>
> 
> > + *
> > + * Converts a period in picoseconds to Hz.
> > + *
> > + * Note, we try to keep this in Hz to minimise rounding with
> > + * the limited PLL settings on the SM501.
> > +*/
> > +
> > +static unsigned long sm501fb_ps_to_hz(unsigned long psvalue)
> > +{
> > +	unsigned long long numerator=1000000000000ULL;
> > +
> > +	/* 10^12 / picosecond period gives frequency in Hz */
> > +	do_div(numerator, psvalue);
> > +	return (unsigned long)numerator;
> > +}
> > +
> > +/* sm501fb_hz_to_ps is identical to the oposite transform */
> > +
> > +#define sm501fb_hz_to_ps(x) sm501fb_ps_to_hz(x)
> 
> You really need it down to the Hz? 

My feeling is that we lose enough with the rather fixed
nature of the frequency selection that we should keep the
calculations as accurate as possible. It isn't a big loss
to have 64bit calcs as we don't change mode that often.
 
> > +/* sm501fb_validate_pan
> > + *
> > + * check panning on a var
> > +*/
> > +
> > +static inline int sm501fb_validate_pan(struct fb_var_screeninfo *var)
> > +{
> > +	if (var->xoffset < 0 || var->yoffset < 0)
> > +		return 0;
> > +
> > +	if (var->xoffset > (var->xres_virtual - var->xres) ||
> > +	    var->yoffset > (var->yres_virtual - var->yres))
> > +		return 0;
> > +
> > +	return 1;
> > +}
> 
> Not needed. fb_pan_display in fbmem.c does this check for you :-)

Ok, will look at removing
 
> > +/* framebuffer ops */
> > +
> > +static struct fb_ops sm501fb_ops_crt = {
> > +	.owner		= THIS_MODULE,
> > +	.fb_check_var	= sm501fb_check_var_crt,
> > +	.fb_set_par	= sm501fb_set_par_crt,
> > +	.fb_blank	= sm501fb_blank_crt,
> > +	.fb_setcolreg	= sm501fb_setcolreg,
> > +	.fb_pan_display	= sm501fb_pan_crt,
> > +	.fb_cursor	= sm501fb_cursor,
> > +	.fb_fillrect	= cfb_fillrect,
> > +	.fb_copyarea	= cfb_copyarea,
> > +	.fb_imageblit	= cfb_imageblit,
> > +};
> > +
> > +static struct fb_ops sm501fb_ops_pnl = {
> > +	.owner		= THIS_MODULE,
> > +	.fb_check_var	= sm501fb_check_var_pnl,
> > +	.fb_set_par	= sm501fb_set_par_pnl,
> > +	.fb_pan_display	= sm501fb_pan_pnl,
> > +	.fb_blank	= sm501fb_blank_pnl,
> > +	.fb_setcolreg	= sm501fb_setcolreg,
> > +	.fb_cursor	= sm501fb_cursor,
> > +	.fb_fillrect	= cfb_fillrect,
> > +	.fb_copyarea	= cfb_copyarea,
> > +	.fb_imageblit	= cfb_imageblit,
> > +};
> 
> Many cards require a fb_sync function after/before they do a drawing 
> operation. I notice you don't have one. Is sm501fb_sync_regs equivalent to 
> that?

That, iirc, is only needed for acceleration functions that
may change the fb data before any of the non-accelerated
ops happen. Basically, it is for the card to hold off any
non-accelerated drawing until the acceleration unit has
finished.
 
> Other than that the driver looks great. Thank you.

I really hope we can get this merged this kernel release.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
