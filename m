Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZCJO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZCJO7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCJO7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:59:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59405 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752747AbZCJO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:59:09 -0400
Date: Tue, 10 Mar 2009 10:59:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090310140950.GD3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101025120.2962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> 
> > +/*
> > + * Handle debug exception notifications.
> > + */
> > +
> > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > +{
> > +	struct cpu_hw_breakpoint *chbi;
> > +	int i;
> > +	struct hw_breakpoint *bp;
> > +	struct thread_hw_breakpoint *thbi = NULL;
> > +
> > +	/* The DR6 value is stored in args->err */
> > +#define DR6	(args->err)
> 
> that's ugly - what's wrong with an old-fashioned "int db6 = 
> args->err" type of approach?

Yes, it is ugly.  It was a holdover from an earlier version, and in 
fact it's likely to change in the future to become even more ugly.  But 
for now, you're right -- a simple assignment would be better.

> > +++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
> > @@ -0,0 +1,132 @@
> > +#ifndef	_I386_HW_BREAKPOINT_H
> > +#define	_I386_HW_BREAKPOINT_H
> > +
> > +#ifdef	__KERNEL__
> > +#define	__ARCH_HW_BREAKPOINT_H
> > +
> > +struct arch_hw_breakpoint {
> > +	char		*name; /* Contains name of the symbol to set bkpt */
> > +	unsigned long	address;
> > +	u8		len;
> > +	u8		type;
> > +} __attribute__((packed));
> 
> hm, why packed and why u8 ? We dont expose this to user-space, 
> do we? (if yes then 'unsigned long' is wrong and __KERNEL__ is 
> wrong as well)

I can't remember why this was made packed; there doesn't seem to be any 
important reason for it.  The structure is not exposed to userspace.  
The len and type fields are u8 because they contain values no larger 
than 255.

> > +#include <linux/kdebug.h>
> > +#include <asm-generic/hw_breakpoint.h>
> > +
> > +/* HW breakpoint accessor routines */
> > +static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
> > +{
> > +	return (const void *) bp->info.address;
> > +}
> > +
> > +static inline const void __user *hw_breakpoint_get_uaddress
> > +						(struct hw_breakpoint *bp)
> > +{
> > +	return (const void __user *) bp->info.address;
> > +}
> > +
> > +static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
> > +{
> > +	return bp->info.len;
> > +}
> > +
> > +static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
> > +{
> > +	return bp->info.type;
> > +}
> 
> why this redirection, why dont just use the structure as-is? If 
> there's any arch weirdness then that arch should have 
> arch-special accessors - not the generic code.

These _are_ the arch-specific accessors.  Look at the filename:
arch/x86/include/asm/hw_breakpoint.h.

> > +	int			num_installed;	/* Number of installed bps */
> > +	unsigned		gennum;		/* update-generation number */
> 
> i suspect the gennum we can get rid of if we get rid of the 
> notion of priorities, right?

No.  gennum has nothing to do with priorities.

Alan Stern

