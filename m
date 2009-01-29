Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZA2HVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZA2HVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZA2HVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:21:25 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:40919 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZA2HVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:21:24 -0500
Date: Thu, 29 Jan 2009 00:21:22 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH A 01/10] OMAP2/3: Add non-CORE DPLL rate set code and M,
 N programming
In-Reply-To: <20090128221056.GJ23301@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0901290006150.32081@utopia.booyaka.com>
References: <20090128020447.7244.80496.stgit@localhost.localdomain> <20090128021243.7244.6362.stgit@localhost.localdomain> <20090128221056.GJ23301@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Wed, 28 Jan 2009, Russell King - ARM Linux wrote:

> Since it's been posted to lists, comments are going to be made...

Yes, that was the point.

> On Tue, Jan 27, 2009 at 07:12:47PM -0700, Paul Walmsley wrote:
> > +	/*
> > +	 * According to the 12-5 CDP code from TI, "Limitation 2.5"
> > +	 * on 3430ES1 prevents us from changing DPLL multipliers or dividers
> > +	 * on DPLL4.
> > +	 */
> > +	if (omap_rev() == OMAP3430_REV_ES1_0 &&
> > +	    !strcmp("dpll4_ck", clk->name)) {
> > +		printk(KERN_ERR "clock: DPLL4 cannot change rate due to "
> > +		       "silicon 'Limitation 2.5' on 3430ES1.\n");
> > +		return -EINVAL;
> > +	}
> 
> Yuck.  That's revolting and extremely fragile.  Don't play these games. 
> You've got plenty of free flag bits in clk->flags which could be used to 
> prevent the DPLL from being changed.  You've also got other ways to 
> prevent it - eg, setting dpll_data to NULL.

dpll_data is used for other DPLL register settings (such as autoidle and 
mode setting), so we should probably leave dpll_data as-is.  Your proposed 
fix in your subsequent message sounds good (viz., adding a separate static 
omap3_dpll4_set_rate() function).

> However, what's worse is that, below...
> 
> > +static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
> > +{

...

> > +	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
> > +				   freqsel);
> 
> The return value from the above test isn't checked, so this function
> will succeed even for dpll4_ck.

Indeed, the return value should be passed along to the caller.  The 
previous check does, however, prevent the DPLL4 registers from being 
written on 3430ES1.

>From your subsequent message, it sounds like you've merged a version of 
this patch with your proposed fixes.  Please let me know if you'd 
like me to send an updated version of this patch anyway.


- Paul
