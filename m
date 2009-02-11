Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZBKIS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZBKIS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZBKISS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:18:18 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47681 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZBKISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:18:17 -0500
Date: Wed, 11 Feb 2009 01:18:16 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 10/14] OMAP clock: support "dry run" rate and parent
 changes
In-Reply-To: <20090208155342.GA23963@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902110031260.12013@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192753.29333.56931.stgit@localhost.localdomain> <20090208155342.GA23963@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sun, 8 Feb 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:27:56PM -0700, Paul Walmsley wrote:
> > For upcoming notifier support, modify the rate recalculation code to
> > take parent rate and rate storage parameters.  The goal here is to
> > allow the clock code to determine what the clock's rate would be after
> > a parent change or a rate change, without actually changing the
> > hardware registers.  This is used by the upcoming notifier patches to
> > pass a clock's current and planned rates to the notifier callbacks.
> 
> In addition to my previous comments, there's more reason to reject this
> patch - it's rather buggy.
> 
> > Also add a new clock flag, RECALC_ON_ENABLE, which causes the clock
> > framework code to recalculate the current clock's rate and propagate
> > down the tree after a clk_enable() or clk_disable().  This is used by
> > the OMAP3 DPLLs, which change rates when they enable or disable, unlike
> > most clocks.
> 
> ... the reasoning for this change being?

For most clocks in the clock tree, there's no need to recalculate the 
clock rate and the downstream clock rates when the clock is enabled 
or disabled.  clk->rate is not adjusted; the rate is simply considered to 
be 0 if the clock is disabled.

There is one type of OMAP clock, though, that this may not hold true for: 
DPLLs.  Currently, the "disabled" state for DPLLs can mean one of two 
general modes: stop (in which the DPLL output rate is zero), or bypass (in 
which the DPLL output rate is the bypass clock rate).  RECALC_ON_ENABLE is 
intended to fix the latter case.  

As we've discussed before, this may be better implemented as a reparent 
operation; but there is a twist: DPLLs can autoidle (if programmed to do 
so).  In this case the DPLL is considered to be enabled, but is actually 
emitting a bypass rate or is stopped.  The OMAP hardware automatically 
restarts the DPLL when a downstream clock is enabled, with no notification 
to the operating system.  So some type of RECALC_ON_ENABLE logic may need 
to stay.

> > diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
> > index ae2b304..f3cf6f8 100644
> > --- a/arch/arm/mach-omap1/clock.c
> > +++ b/arch/arm/mach-omap1/clock.c
> >  
> > -static void omap1_sossi_recalc(struct clk *clk)
> > +static void omap1_sossi_recalc(struct clk *clk, unsigned long parent_rate,
> > +			       u8 rate_storage)
> >  {
> > +	unsigned long new_rate;
> >  	u32 div = omap_readl(MOD_CONF_CTRL_1);
> >  
> >  	div = (div >> 17) & 0x7;
> >  	div++;
> > -	clk->rate = clk->parent->rate / div;
> > +	new_rate = clk->parent->rate / div;
> 
> This continues to use clk->parent->rate rather than the value passed in.

Indeed, this should be fixed.

> > @@ -215,21 +238,32 @@ static int calc_dsor_exp(struct clk *clk, unsigned long rate)
> >  	return dsor_exp;
> >  }
> >  
> > -static void omap1_ckctl_recalc(struct clk * clk)
> > +static void omap1_ckctl_recalc(struct clk *clk, unsigned long parent_rate,
> > +			       u8 rate_storage)
> >  {
> >  	int dsor;
> > +	unsigned long new_rate;
> >  
> >  	/* Calculate divisor encoded as 2-bit exponent */
> >  	dsor = 1 << (3 & (omap_readw(ARM_CKCTL) >> clk->rate_offset));
> >  
> > -	if (unlikely(clk->rate == clk->parent->rate / dsor))
> > +	new_rate = parent_rate / dsor;
> > +
> > +	if (unlikely(clk->rate == new_rate))
> >  		return; /* No change, quick exit */
> > -	clk->rate = clk->parent->rate / dsor;
> > +
> > +	if (rate_storage == CURRENT_RATE)
> > +		clk->rate = new_rate;
> > +	else if (rate_storage == TEMP_RATE)
> > +		clk->temp_rate = new_rate;
> 
> The above will result in 'temp_rate' not being set if there is no change
> in actual clock rate

Indeed, this also needs to be fixed.

> This can all be avoided by moving the assignment of clk->rate out of the
> recalc functions and into the caller.  That also eliminates this
> rate_storage argument as well, _and_ removes any possibility of broken
> "caching" code surviving since it forces you to always return the rate
> you intend from the function.
> 
> See the bottom of this mail for the first step to implement this.
> 
> > @@ -242,9 +276,15 @@ static void omap1_ckctl_recalc_dsp_domain(struct clk * clk)
> >  	dsor = 1 << (3 & (__raw_readw(DSP_CKCTL) >> clk->rate_offset));
> >  	omap1_clk_disable(&api_ck.clk);
> >  
> > -	if (unlikely(clk->rate == clk->parent->rate / dsor))
> > +	new_rate = parent_rate / dsor;
> > +
> > +	if (unlikely(clk->rate == new_rate))
> >  		return; /* No change, quick exit */
> 
> More buggy caching.

Yep.

> > diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
> > index 57cd85b..cd9fa0d 100644
> > --- a/arch/arm/mach-omap2/clock24xx.c
> > +++ b/arch/arm/mach-omap2/clock24xx.c
> > @@ -89,6 +91,30 @@ static u32 omap2xxx_clk_get_core_rate(struct clk *clk)
> >  	return core_clk;
> >  }
> >  
> > +static unsigned long omap2xxx_clk_find_oppset_by_mpurate(unsigned long mpu_speed,
> > +							 struct prcm_config **prcm)
> > +{
> > +	unsigned long found_speed = 0;
> > +	struct prcm_config *p;
> > +
> > +	p = *prcm;
> > +
> > +	for (p = rate_table; p->mpu_speed; p++) {
> > +		if (!(p->flags & cpu_mask))
> > +			continue;
> > +
> > +		if (p->xtal_speed != sys_ck.rate)
> > +			continue;
> > +
> > +		if (p->mpu_speed <= mpu_speed) {
> > +			found_speed = p->mpu_speed;
> > +			break;
> > +		}
> > +	}
> > +
> > +	return found_speed;
> > +}
> > +
> 
> This looks like a change of functionality in this patch.

The goal of this part of the change was to eliminate some duplicate code.  
This rate_table walk had previously existed in several other places in the 
code with minor variations; the intention here was to combine those into a 
common function.

> Here's the implementation of the recalc method returning the new rate.
> As you can see, it moves the business of where we store it completely
> out of the recalc implementation code, which would make the implementation
> of the 'temp_rate' solution a whole lot smaller.

I'm happy with this change - it looks good to me,


- Paul
