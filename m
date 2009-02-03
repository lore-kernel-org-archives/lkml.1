Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZBCIrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZBCIrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZBCIrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:47:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:53474 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBCIrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:47:42 -0500
Date: Tue, 3 Feb 2009 01:47:41 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 01/10] OMAP2/3 clock: combine clkdm, clkdm_name into
 union in struct clk
In-Reply-To: <20090131115523.GF1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902030142590.29513@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024401.27240.68328.stgit@localhost.localdomain> <20090131115523.GF1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Tue, Jan 27, 2009 at 07:44:08PM -0700, Paul Walmsley wrote:
> > diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
> > index 55c5d67..7aa09f5 100644
> > --- a/arch/arm/mach-omap2/clock.c
> > +++ b/arch/arm/mach-omap2/clock.c
> > @@ -77,17 +77,17 @@ void omap2_init_clk_clkdm(struct clk *clk)
> >  {
> >  	struct clockdomain *clkdm;
> >  
> > -	if (!clk->clkdm_name)
> > +	if (!clk->clkdm.name)
> >  		return;
> >  
> > -	clkdm = clkdm_lookup(clk->clkdm_name);
> > +	clkdm = clkdm_lookup(clk->clkdm.name);
> >  	if (clkdm) {
> >  		pr_debug("clock: associated clk %s to clkdm %s\n",
> > -			 clk->name, clk->clkdm_name);
> > -		clk->clkdm = clkdm;
> > +			 clk->name, clk->clkdm.name);
> > +		clk->clkdm.ptr = clkdm;
> >  	} else {
> >  		pr_debug("clock: could not associate clk %s to "
> > -			 "clkdm %s\n", clk->name, clk->clkdm_name);
> > +			 "clkdm %s\n", clk->name, clk->clkdm.name);
> >  	}
> 
> This is unsafe - if the clock domain can not be found, you leave the
> union pointing at the string, and there's no way for this to prevent
> the clock from being registered.
> 
> The result is that:
> 
> > -		if (clk->clkdm)
> > -			omap2_clkdm_clk_disable(clk->clkdm, clk);
> > +		if (clk->clkdm.ptr)
> > +			omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
> 
> and similar places will pass the pointer to the string, potentially
> causing an oops, or worse, data corruption due to scribbing over
> someone elses memory.

Agreed.  Now that omap2_init_clk_clkdm() is called by the 
OMAP arch-specific clk_register(), this should be pretty easy to 
implement.  Will send a patch that applies on top of F 06.


- Paul
