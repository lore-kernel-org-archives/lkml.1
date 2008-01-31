Return-Path: <linux-kernel-owner+w=401wt.eu-S932661AbYAaQiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbYAaQiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbYAaQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:38:14 -0500
Received: from mx1.suse.de ([195.135.220.2]:38827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbYAaQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:38:13 -0500
Date: Thu, 31 Jan 2008 17:38:12 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] GBPAGES: Do kernel direct mapping at boot using
	GB pages
Message-ID: <20080131163812.GE25989@bingen.suse.de>
References: <20080129606.610336873@suse.de> <20080129050637.BD7441B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311713010.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311713010.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:17:41PM +0100, Thomas Gleixner wrote:
> On Tue, 29 Jan 2008, Andi Kleen wrote:
> >
> > +static unsigned long direct_entry(unsigned long paddr)
> 
> Please use a more sensible function name. This one has no association
> with the functionality at all.

Can you suggest one? I honestly cannot think of a better one.
Its's a "entry" in the "direct" mapping.

> > +	if (direct_gbpages >= 0 && cpu_has_gbpages) {
> > +		printk(KERN_INFO "Using GB pages for direct mapping\n");
> > +		direct_gbpages = 1;
> > +	} else
> > +		direct_gbpages = 0;
> > +}
> 
> Please use simple boolean logic. gbpages are either enabled or disabled.

It's a fairly standard widely used idiom for command line options because 
it allows default and forcing.  e.g. there can be cases when the kernel
disables it, but then it makes sense for the command line option
to override it. There is already one case in the kernel that 
disables it.
 
> >   * prefetches from the CPU leading to inconsistent cache lines.
> > @@ -467,6 +511,8 @@ __clear_kernel_mapping(unsigned long add
> >  			continue;
> >  
> >  		pud = pud_offset(pgd, address);
> > +		if (pud_large(*pud))
> > +			split_gb_page(pud, __pa(address));
> >  		if (pud_none(*pud))
> >  			continue;
> 
> As I said before, this needs to use CPA and not implement another variant.

Ok, I can switch GART over to CPA, but that will make the patch
much more intrusive and a little riskier. Is that ok for you
and will it be still considered .25 candidate? 

-Andi
