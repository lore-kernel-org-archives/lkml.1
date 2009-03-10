Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZCJPTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZCJPTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCJPTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:19:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZCJPTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:19:03 -0400
Date: Tue, 10 Mar 2009 16:18:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090310151828.GM3850@elte.hu>
References: <20090310140950.GD3850@elte.hu> <Pine.LNX.4.44L0.0903101025120.2962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101025120.2962-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> > 
> > > +/*
> > > + * Handle debug exception notifications.
> > > + */
> > > +
> > > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > > +{
> > > +	struct cpu_hw_breakpoint *chbi;
> > > +	int i;
> > > +	struct hw_breakpoint *bp;
> > > +	struct thread_hw_breakpoint *thbi = NULL;
> > > +
> > > +	/* The DR6 value is stored in args->err */
> > > +#define DR6	(args->err)
> > 
> > that's ugly - what's wrong with an old-fashioned "int db6 = 
> > args->err" type of approach?
> 
> Yes, it is ugly.  It was a holdover from an earlier version, and in 
> fact it's likely to change in the future to become even more ugly.  But 
> for now, you're right -- a simple assignment would be better.
> 
> > > +++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
> > > @@ -0,0 +1,132 @@
> > > +#ifndef	_I386_HW_BREAKPOINT_H
> > > +#define	_I386_HW_BREAKPOINT_H
> > > +
> > > +#ifdef	__KERNEL__
> > > +#define	__ARCH_HW_BREAKPOINT_H
> > > +
> > > +struct arch_hw_breakpoint {
> > > +	char		*name; /* Contains name of the symbol to set bkpt */
> > > +	unsigned long	address;
> > > +	u8		len;
> > > +	u8		type;
> > > +} __attribute__((packed));
> > 
> > hm, why packed and why u8 ? We dont expose this to user-space, 
> > do we? (if yes then 'unsigned long' is wrong and __KERNEL__ is 
> > wrong as well)
> 
> I can't remember why this was made packed; there doesn't seem to be any 
> important reason for it.  The structure is not exposed to userspace.  
> The len and type fields are u8 because they contain values no larger 
> than 255.
> 
> > > +#include <linux/kdebug.h>
> > > +#include <asm-generic/hw_breakpoint.h>
> > > +
> > > +/* HW breakpoint accessor routines */
> > > +static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
> > > +{
> > > +	return (const void *) bp->info.address;
> > > +}
> > > +
> > > +static inline const void __user *hw_breakpoint_get_uaddress
> > > +						(struct hw_breakpoint *bp)
> > > +{
> > > +	return (const void __user *) bp->info.address;
> > > +}
> > > +
> > > +static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
> > > +{
> > > +	return bp->info.len;
> > > +}
> > > +
> > > +static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
> > > +{
> > > +	return bp->info.type;
> > > +}
> > 
> > why this redirection, why dont just use the structure as-is? 
> > If there's any arch weirdness then that arch should have 
> > arch-special accessors - not the generic code.
> 
> These _are_ the arch-specific accessors.  Look at the 
> filename: arch/x86/include/asm/hw_breakpoint.h.

I very well know which file this is, you need to read my reply 
again.

These are very generic-sounding fields and they should not be 
hidden via pointless wrappers by the generic code. Dont let the 
tail wag the dog. If there's architecture weirdness that does 
not fit the generic code, then _that_ architecture should have 
the ugliness - not the generic code. (note that these accessors 
are used by the generic code so the uglification spreads there)

> > > + int num_installed; /* Number of installed bps */ + 
> > > unsigned gennum; /* update-generation number */
> > 
> > i suspect the gennum we can get rid of if we get rid of the 
> > notion of priorities, right?
> 
> No.  gennum has nothing to do with priorities.

Well it's introduced because we have a priority-sorted list of 
breakpoints not an array. A list needs to be maintained and when 
updated it's reloaded. I was thinking about possibly getting rid 
of that list complication and go back to the simpler array. But 
it's hard because the lifetime of a kernel space breakpoint 
spans context-switches so there has to be separation.

	Ingo
