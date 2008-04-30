Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbYD3M4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbYD3M4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbYD3M4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:56:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYD3M4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:56:46 -0400
Date: Wed, 30 Apr 2008 15:03:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Message-ID: <20080430130305.GC20451@one.firstfloor.org>
References: <20080430135440.A359@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430135440.A359@sedona.ch.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not quite sure on the kernel interface. How would a in kernel
subsystem use it for tracing itself for example?

> Index: gits.x86/arch/x86/kernel/bts.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ gits.x86/arch/x86/kernel/bts.c	2008-04-30 11:30:18.%N +0200
> @@ -0,0 +1,505 @@
> +/*
> + * Branch Trace Store (BTS) support
> + *
> + * This provides a low-level interface to the hardware's Branch Trace Store
> + * feature that is used for execution tracing.

Perhaps say it is only supported on modern Intel CPUs.

> + *
> + * It manages:
> + * - per-thread and per-cpu BTS configuration
> + * - buffer memory allocation and overflow handling
> + *
> + * It assumes:
> + * - get_task_struct on all parameter tasks

What is a parameter task?

> + * - current is allowed to trace parameter tasks
> + *
> + *
> + * Copyright (C) 2008 Intel Corporation.
> + * Markus Metzger <markus.t.metzger@intel.com>, 2008
> + */
> +
> +#ifdef CONFIG_X86_BTS

Ifdef around whole file should be in the Makefile instead.
In fact it is already in there so it is obsolet


> +struct bts_configuration {
> +	/* the size of a BTS record in bytes; at most BTS_MAX_RECORD_SIZE */
> +	unsigned char  sizeof_bts;
> +	/* the size of a field in the BTS record in bytes */
> +	unsigned char  sizeof_field;
> +	/* a bitmask to enable/disable various parts of BTS in DEBUGCTL MSR */
> +	unsigned long debugctl_tr;
> +	unsigned long debugctl_btint;
> +	unsigned long debugctl_user_off;
> +	unsigned long debugctl_kernel_off;
> +	unsigned long debugctl_all;
> +};
> +static struct bts_configuration bts_cfg;

Should have a comment describing the locking of the variable. Is there is 
no need for some reason that should be also documented.

> +}
> +EXPORT_SYMBOL(bts_request);

Why again is that all exported?

> +		if (kbuf)
> +			bts_translate_record(kbuf++, raw);
> +
> +		if (ubuf) {
> +			bts_translate_record(&bts, raw);
> +
> +			if (copy_to_user(ubuf++, &bts, sizeof(bts)))

copy_to_user is a macro and using expressions with side effects in
macro arguments is usually a bad idea.

> +static const struct bts_configuration bts_cfg_netburst = {
> +	.sizeof_bts    = sizeof(long) * 3,
> +	.sizeof_field  = sizeof(long),
> +	.debugctl_tr         = (1<<2)|(1<<3),
> +	.debugctl_btint      = (1<<4),
> +	.debugctl_user_off   = (1<<6),
> +	.debugctl_kernel_off = (1<<5)

Define symbols for the magic numbers?

> +		switch (c->x86_model) {
> +		case 0xD:
> +		case 0xE: /* Pentium M */
> +			bts_init(&bts_cfg_pentium_m);
> +			break;
> +		case 0xF: /* Core2 */
> +		case 0x1C: /* Atom */
> +			bts_init(&bts_cfg_core2);
> +			break;
> +		default:
> +			/* sorry, don't know about them */

There should be a printk probably once at kernel boot time.


> +			break;
> +		}
> +		break;
> +	case 0xF:
> +		switch (c->x86_model) {
> +		case 0x0:
> +		case 0x1:
> +		case 0x2: /* Netburst */
> +			bts_init(&bts_cfg_netburst);

Are you sure that's complete? 


> +#ifdef __KERNEL__
> +struct bts_struct {
> +	u64 qualifier;
> +	union {
> +		/* BTS_BRANCH */
> +		struct {
> +			u64 from;
> +			u64 to;
> +		} lbr;
> +		/* BTS_TASK_ARRIVES or
> +		   BTS_TASK_DEPARTS */
> +		u64 jiffies;
> +	} variant;
> +};
> +#else /* !__KERNEL__ */
> +struct bts_struct {
> +	__u64 qualifier;

You could always use the __ typed variant even for the kernel.

> +
> +/*
> + * Request branch tracing for the parameter task or for the current cpu.
> + *
> + * Due to alignement constraints, the actual buffer may be slightly
> + * smaller than the requested or provided buffer.
> + *
> + * Returns 0 on success; -Eerrno otherwise
> + *
> + * task:  the task to request recording for;
> + *        NULL for per-cpu recording on the current cpu
> + * base:  the base pointer for the (non-pageable) buffer;
> + *        NULL if buffer allocation requested
> + * size:  the size of the requested or provided buffer
> + * ovfl:  pointer to a function to be called on buffer overflow;
> + *        NULL if cyclic buffer requested

If you write these comments in kerneldoc format (see 
Documentation/kernel-doc-nano-HOWTO.txt)
it might end up automatically in the extracted documentation.


> + * Not all processors support all variants.
> + * If a variant is not supported, the respective flag is ignored.

Is that really a good way to handle such an error? How does the 
user program find out?

>  }
>  
>  #ifdef CONFIG_X86_PTRACE_BTS

Hmm I suspect since that is not mainline you'll need to just ask
for the previous patches to be dropped, not remove the code explicitely.

-Andi
