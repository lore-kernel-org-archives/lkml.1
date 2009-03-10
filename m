Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZCJOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZCJOKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZCJOKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:10:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZCJOKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:10:08 -0400
Date: Tue, 10 Mar 2009 15:09:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090310140950.GD3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305043801.GC17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305043801.GC17747@in.ibm.com>
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


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:

> +/*
> + * Handle debug exception notifications.
> + */
> +
> +int __kprobes hw_breakpoint_handler(struct die_args *args)
> +{
> +	struct cpu_hw_breakpoint *chbi;
> +	int i;
> +	struct hw_breakpoint *bp;
> +	struct thread_hw_breakpoint *thbi = NULL;
> +
> +	/* The DR6 value is stored in args->err */
> +#define DR6	(args->err)

that's ugly - what's wrong with an old-fashioned "int db6 = 
args->err" type of approach?

> +
> +	if (DR6 & DR_STEP)
> +		return NOTIFY_DONE;
> +
> +	chbi = &per_cpu(cpu_bp, get_cpu());
> +
> +	/* Disable all breakpoints so that the callbacks can run without
> +	 * triggering recursive debug exceptions.
> +	 */
> +	set_debugreg(0UL, 7);
> +
> +	/* Assert that local interrupts are disabled
> +	 * Reset the DRn bits in the virtualized register value.
> +	 * The ptrace trigger routine will add in whatever is needed.
> +	 */
> +	current->thread.vdr6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
> +
> +	/* Are we a victim of lazy debug-register switching? */
> +	if (!chbi->bp_task)
> +		;
> +	else if (chbi->bp_task != current) {
> +
> +		/* No user breakpoints are valid.  Perform the belated
> +		 * debug-register switch.
> +		 */
> +		switch_to_none_hw_breakpoint();
> +	} else {
> +		thbi = chbi->bp_task->thread.hw_breakpoint_info;
> +	}
> +
> +	/* Handle all the breakpoints that were triggered */
> +	for (i = 0; i < HB_NUM; ++i) {
> +		if (likely(!(DR6 & (DR_TRAP0 << i))))
> +			continue;
> +
> +		/* Find the corresponding hw_breakpoint structure and
> +		 * invoke its triggered callback.
> +		 */
> +		if (i < chbi->cur_kbpdata->num_kbps)
> +			bp = chbi->cur_kbpdata->bps[i];
> +		else if (thbi)
> +			bp = thbi->bps[i];
> +		else		/* False alarm due to lazy DR switching */
> +			continue;
> +		if (bp) {
> +			switch (bp->info.type) {
> +			case HW_BREAKPOINT_WRITE:
> +			case HW_BREAKPOINT_RW:
> +				if (bp->triggered)
> +					(bp->triggered)(bp, args->regs);
> +				/* Re-enable the breakpoints */
> +				set_debugreg(thbi ? thbi->tkdr7 :
> +						chbi->cur_kbpdata->mkdr7, 7);
> +				put_cpu_no_resched();
> +
> +				return NOTIFY_STOP;
> +			/*
> +			 * Presently we allow instruction breakpoints only in
> +			 * user-space when requested through ptrace.
> +			 */
> +			case HW_BREAKPOINT_EXECUTE:
> +				if (arch_check_va_in_userspace(bp->info.address,
> +								current)) {
> +					(bp->triggered)(bp, args->regs);
> +	/* We'll return NOTIFY_DONE, do_debug will take care of the rest */
> +					return NOTIFY_DONE;
> +				}
> +			}

the linebreaks here became so ugly because the whole loop body 
should be moved inside a helper function.

> +++ linux-2.6-tip.hbkpt/arch/x86/include/asm/hw_breakpoint.h
> @@ -0,0 +1,132 @@
> +#ifndef	_I386_HW_BREAKPOINT_H
> +#define	_I386_HW_BREAKPOINT_H
> +
> +#ifdef	__KERNEL__
> +#define	__ARCH_HW_BREAKPOINT_H
> +
> +struct arch_hw_breakpoint {
> +	char		*name; /* Contains name of the symbol to set bkpt */
> +	unsigned long	address;
> +	u8		len;
> +	u8		type;
> +} __attribute__((packed));

hm, why packed and why u8 ? We dont expose this to user-space, 
do we? (if yes then 'unsigned long' is wrong and __KERNEL__ is 
wrong as well)

> +#include <linux/kdebug.h>
> +#include <asm-generic/hw_breakpoint.h>
> +
> +/* HW breakpoint accessor routines */
> +static inline const void *hw_breakpoint_get_kaddress(struct hw_breakpoint *bp)
> +{
> +	return (const void *) bp->info.address;
> +}
> +
> +static inline const void __user *hw_breakpoint_get_uaddress
> +						(struct hw_breakpoint *bp)
> +{
> +	return (const void __user *) bp->info.address;
> +}
> +
> +static inline unsigned hw_breakpoint_get_len(struct hw_breakpoint *bp)
> +{
> +	return bp->info.len;
> +}
> +
> +static inline unsigned hw_breakpoint_get_type(struct hw_breakpoint *bp)
> +{
> +	return bp->info.type;
> +}

why this redirection, why dont just use the structure as-is? If 
there's any arch weirdness then that arch should have 
arch-special accessors - not the generic code.

> +
> +/* Kernel symbol lookup routine for installing Data HW Breakpoint Address */
> +static inline unsigned long hw_breakpoint_lookup_name(const char *name)
> +{
> +	return kallsyms_lookup_name(name);
> +}

A wrapper around kallsyms_lookup_name() is quite pointless - 
pleae us kallsyms_lookup_name() drectly.

> +/* Per-thread HW breakpoint and debug register info */
> +struct thread_hw_breakpoint {
> +
> +	/* utrace support */
> +	struct list_head	node;		/* Entry in thread list */
> +	struct list_head	thread_bps;	/* Thread's breakpoints */
> +	struct hw_breakpoint	*bps[HB_NUM];	/* Highest-priority bps */
> +	unsigned long		tdr[HB_NUM];	/*  and their addresses */

Please rename it to something like ->hw_breakpoint[] and 
->address[] - 'bps' and 'tdr' look quite meaningless.

> +	int			num_installed;	/* Number of installed bps */
> +	unsigned		gennum;		/* update-generation number */

i suspect the gennum we can get rid of if we get rid of the 
notion of priorities, right?

	Ingo
