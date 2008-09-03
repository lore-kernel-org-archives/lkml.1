Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYICJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYICJaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYICJaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:30:12 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:58784 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYICJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:30:10 -0400
Date: Wed, 3 Sep 2008 11:29:30 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: <kernel@avr32linux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add kernel support for oprofile callgraphs on AVR32
Message-ID: <20080903112930.56ebac51@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <4A01BA1129E3AD489AA4409A99D9076775A42A@wm020.weinmann.com>
References: <4A01BA1129E3AD489AA4409A99D9076775A42A@wm020.weinmann.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Sep 2008 09:29:26.0219 (UTC) FILETIME=[8EBC89B0:01C90DA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Voss, Nikolaus" <N.Voss@weinmann.de> wrote:
> From: Nikolaus Voss <n.voss@weinmann.de>
> 
> This patch adds backtracing capability to oprofile profiling in kernel
> and user mode on AVR32. This is done by going through the frames on the stack
> and adding oprofile traces for all return addresses. The code being profiled has
> to be compiled with frame pointers to make this work.
> 
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

Hmm. This appears to be the third backtracer added to avr32, the first
two being dump_stack() and friends in arch/avr32/kernel/process.c, and
save_stack_trace() in arch/avr32/kernel/stacktrace.c.

Would be nice if some of this could be consolidated.

> ---
> diff --git a/arch/avr32/oprofile/Makefile b/arch/avr32/oprofile/Makefile
> index 1fe81c3..e0eb520 100644
> --- a/arch/avr32/oprofile/Makefile
> +++ b/arch/avr32/oprofile/Makefile
> @@ -5,4 +5,4 @@ oprofile-y		:= $(addprefix ../../../drivers/oprofile/,	\
>  				event_buffer.o oprofile_files.o		\
>  				oprofilefs.o oprofile_stats.o		\
>  				timer_int.o)
> -oprofile-y		+= op_model_avr32.o
> +oprofile-y		+= op_model_avr32.o backtrace.o
> diff --git a/arch/avr32/oprofile/backtrace.c b/arch/avr32/oprofile/backtrace.c
> new file mode 100644
> index 0000000..81c89ec
> --- /dev/null
> +++ b/arch/avr32/oprofile/backtrace.c
> @@ -0,0 +1,81 @@
> +/*
> + * AVR32 specific backtracing code for oprofile
> + *
> + * Copyright 2008 Weinmann GmbH
> + * 
> + * Author: Nikolaus Voss <n.voss@weinmann.de>
> + *
> + * Based on i386 oprofile backtrace code by John Levon and David Smith
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/oprofile.h>
> +#include <linux/sched.h>
> +#include <asm/uaccess.h>
> +
> +/* The first two words of each frame on the stack look like this if we have
> + * frame pointers */
> +struct frame_head {
> +	unsigned long lr;
> +	struct frame_head *fp;
> +};
> +
> +/* copied from arch/avr32/kernel/process.c */
> +static inline int valid_stack_ptr(struct thread_info *tinfo, unsigned long p)
> +{
> +	return (p > (unsigned long)tinfo)
> +		&& (p < (unsigned long)tinfo + THREAD_SIZE - 3);
> +}
> +
> +/* copied from arch/x86/oprofile/backtrace.c */
> +static struct frame_head * dump_user_backtrace(struct frame_head *head)

...though this is something the other two implementations don't have:
userspace stack tracing.

> +{
> +	struct frame_head bufhead[2];
> +
> +	/* Also check accessibility of one struct frame_head beyond */
> +	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
> +		return NULL;
> +	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
> +		return NULL;
> +
> +	oprofile_add_trace(bufhead[0].lr);
> +
> +	/* frame pointers should strictly progress back up the stack
> +	 * (towards higher addresses) */
> +	if (head >= bufhead[0].fp)

Could you swap the two operand so that it matches...

> +		return NULL;
> +
> +	return bufhead[0].fp;
> +}
> +
> +void avr32_backtrace(struct pt_regs * const regs, unsigned int depth)
> +{
> +	/* Get first frame pointer */
> +	struct frame_head *head = (struct frame_head *)(regs->r7);
> +	
> +	if (!user_mode(regs)) {
> +#ifdef CONFIG_FRAME_POINTER
> +		/*
> +		 * Traverse the kernel stack from frame to frame up to
> +		 * "depth" steps.
> +		 */
> +		while (depth-- && valid_stack_ptr(task_thread_info(current),
> +						  (unsigned long)head)) {
> +			oprofile_add_trace(head->lr);
> +			if (head->fp <= head)

...this?

> +				break;
> +			head = head->fp;
> +		}
> +#endif
> +	} else {
> +		/* Assume we have frame pointers in user mode process */

What happens if we don't? I assume it will stop when it detects that
the frame pointer isn't monotonically increasing or when it gets a
fault?

> +		while (depth-- && head)
> +			head = dump_user_backtrace(head);
> +	}
> +}
> +
> +
> diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
> index df42325..a3e9b3c 100644
> --- a/arch/avr32/oprofile/op_model_avr32.c
> +++ b/arch/avr32/oprofile/op_model_avr32.c
> @@ -22,6 +22,8 @@
>  #define AVR32_PERFCTR_IRQ_GROUP	0
>  #define AVR32_PERFCTR_IRQ_LINE	1
>  
> +void avr32_backtrace(struct pt_regs * const regs, unsigned int depth);
> +
>  enum { PCCNT, PCNT0, PCNT1, NR_counter };
>  
>  struct avr32_perf_counter {
> @@ -223,6 +225,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  	memcpy(ops, &avr32_perf_counter_ops,
>  			sizeof(struct oprofile_operations));
>  
> +	ops->backtrace = avr32_backtrace;
> +
>  	printk(KERN_INFO "oprofile: using AVR32 performance monitoring.\n");
>  
>  	return 0;

Thanks,

Haavard
