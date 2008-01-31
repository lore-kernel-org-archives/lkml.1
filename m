Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbYAaRKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbYAaRKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbYAaRKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:10:20 -0500
Received: from www.tglx.de ([62.245.132.106]:59472 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbYAaRKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:10:17 -0500
Date: Thu, 31 Jan 2008 18:10:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] GBPAGES: Do kernel direct mapping at boot using
 GB pages
In-Reply-To: <20080131163812.GE25989@bingen.suse.de>
Message-ID: <alpine.LFD.1.00.0801311802150.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050637.BD7441B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311713010.9204@apollo.tec.linutronix.de> <20080131163812.GE25989@bingen.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andi Kleen wrote:

> On Thu, Jan 31, 2008 at 05:17:41PM +0100, Thomas Gleixner wrote:
> > On Tue, 29 Jan 2008, Andi Kleen wrote:
> > >
> > > +static unsigned long direct_entry(unsigned long paddr)
> > 
> > Please use a more sensible function name. This one has no association
> > with the functionality at all.
> 
> Can you suggest one? I honestly cannot think of a better one.
> Its's a "entry" in the "direct" mapping.

Doh, yes :) It just did not trigger.

> > > +	if (direct_gbpages >= 0 && cpu_has_gbpages) {
> > > +		printk(KERN_INFO "Using GB pages for direct mapping\n");
> > > +		direct_gbpages = 1;
> > > +	} else
> > > +		direct_gbpages = 0;
> > > +}
> > 
> > Please use simple boolean logic. gbpages are either enabled or disabled.
> 
> It's a fairly standard widely used idiom for command line options because 
> it allows default and forcing.  e.g. there can be cases when the kernel
> disables it, but then it makes sense for the command line option
> to override it. There is already one case in the kernel that 
> disables it.

Right, but please use some constants. I was tripping over the 

       if (direct_gbpages > 0)

somewhere else in the code and it would have been simpler to see
something like:

	if (direct_gbpages == GBPAGES_ENABLED)

> > >   * prefetches from the CPU leading to inconsistent cache lines.
> > > @@ -467,6 +511,8 @@ __clear_kernel_mapping(unsigned long add
> > >  			continue;
> > >  
> > >  		pud = pud_offset(pgd, address);
> > > +		if (pud_large(*pud))
> > > +			split_gb_page(pud, __pa(address));
> > >  		if (pud_none(*pud))
> > >  			continue;
> > 
> > As I said before, this needs to use CPA and not implement another variant.
> 
> Ok, I can switch GART over to CPA, but that will make the patch
> much more intrusive and a little riskier. Is that ok for you
> and will it be still considered .25 candidate? 

We have the code in place already and we need to shake out any
remaining problems anyway. So using the CPA code would be preferred as
it adds another user. Can you give it a try please ?

Thanks,
	tglx
