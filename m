Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXE3UeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXE3UeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbXE3UeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:34:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555AbXE3UeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:34:07 -0400
Date: Wed, 30 May 2007 13:33:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] Conditional Calls - i386 Optimization
Message-Id: <20070530133328.03352d4b.akpm@linux-foundation.org>
In-Reply-To: <20070530140228.349272966@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140228.349272966@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:00:30 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> i386 optimization of the cond_calls which uses a movb with code patching to
> set/unset the value used to populate the register used for the branch test.
> 
> +/*
> + * Conditional function calls. i386 architecture optimizations.
> + *
> + * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +
> +#ifdef CONFIG_COND_CALL
> +
> +#define CF_DEFAULT (CF_OPTIMIZED | CF_LOCKDEP | CF_PRINTK)
> +
> +/* Optimized version of the cond_call. Passing the flags as a pointer to
> + * the inline assembly to trick it into putting the flags value as third
> + * parameter in the structure. */
> +#define cond_call_optimized(flags, name, func) \
> +	({ \
> +		static const char __cstrtab_name_##name[] \
> +		__attribute__((section("__cond_call_strings"))) = #name; \
> +		char condition; \
> +		asm (	".section __cond_call, \"a\", @progbits;\n\t" \
> +					".long %1, 0f, %2;\n\t" \
> +					".previous;\n\t" \
> +					".align 2\n\t" \
> +					"0:\n\t" \
> +					"movb %3,%0;\n\t" \
> +				: "=r" (condition) \
> +				: "m" (*__cstrtab_name_##name), \
> +				  "m" (*(char*)flags), \
> +				  "i" ((flags) & CF_STATIC_ENABLE)); \
> +		(likely(!condition)) ? \
> +			(__typeof__(func))0 : \
> +			(func); \
> +	})

People often tab the \ characters across to the right, make them line up
nicely.  It does look better.

> +/* cond_call macro selecting the generic or optimized version of cond_call,
> + * depending on the flags specified. */
> +#define _cond_call(flags, name, func) \
> +({ \
> +	(((flags) & CF_LOCKDEP) && ((flags) & CF_OPTIMIZED)) ? \
> +		cond_call_optimized(flags, name, func) : \
> +		cond_call_generic(flags, name, func); \
> +})

So it is a macro instead of a static inline because we need to emit an
entry into __cond_call_strings once per callsite, yes?

> +/* Architecture dependant cond_call information, used internally for cond_call
> + * activation. */
> +
> +/* Offset of the immediate value from the start of the movb instruction, in
> + * bytes. */
> +#define COND_CALL_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
> +#define COND_CALL_OPTIMIZED_ENABLE_TYPE unsigned char
> +/* Dereference enable as lvalue from a pointer to its instruction */
> +#define COND_CALL_OPTIMIZED_ENABLE(a) \
> +	*(COND_CALL_OPTIMIZED_ENABLE_TYPE*) \
> +		((char*)a+COND_CALL_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)

I suspect this is underparenthesised.

> +extern int cond_call_optimized_set_enable(void *address, char enable);
> +
> +#endif
> +#endif //_ASM_I386_CONDCALL_H
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/arch/i386/kernel/condcall.c	2007-05-17 01:52:38.000000000 -0400
> @@ -0,0 +1,140 @@
> +/* condcall.c
> + *
> + * - Erratum 49 fix for Intel PIII.
> + * - Still present on newer processors : Intel Core 2 Duo Processor for Intel
> + *   Centrino Duo Processor Technology Specification Update, AH33.
> + *   Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
> + *   Instruction Execution Results.
> + *
> + * Permits cond_call activation by XMC with correct serialization.
> + *
> + * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
> + * location that has preemption enabled because it involves no temporary or
> + * reused data structure.
> + *
> + * Quoting Richard J Moore, source of the information motivating this
> + * implementation which differs from the one proposed by Intel which is not
> + * suitable for kernel context (does not support NMI and would require disabling
> + * interrupts on every CPU for a long period) :
> + *
> + * "There is another issue to consider when looking into using probes other
> + * then int3:
> + *
> + * Intel erratum 54 - Unsynchronized Cross-modifying code - refers to the
> + * practice of modifying code on one processor where another has prefetched
> + * the unmodified version of the code. Intel states that unpredictable general
> + * protection faults may result if a synchronizing instruction (iret, int,
> + * int3, cpuid, etc ) is not executed on the second processor before it
> + * executes the pre-fetched out-of-date copy of the instruction.
> + *
> + * When we became aware of this I had a long discussion with Intel's
> + * microarchitecture guys. It turns out that the reason for this erratum
> + * (which incidentally Intel does not intend to fix) is because the trace
> + * cache - the stream of micorops resulting from instruction interpretation -
> + * cannot guaranteed to be valid. Reading between the lines I assume this
> + * issue arises because of optimization done in the trace cache, where it is
> + * no longer possible to identify the original instruction boundaries. If the
> + * CPU discoverers that the trace cache has been invalidated because of
> + * unsynchronized cross-modification then instruction execution will be
> + * aborted with a GPF. Further discussion with Intel revealed that replacing
> + * the first opcode byte with an int3 would not be subject to this erratum.
> + *
> + * So, is cmpxchg reliable? One has to guarantee more than mere atomicity."
> + *
> + * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + */
> +
> +#include <linux/notifier.h>
> +#include <linux/mutex.h>
> +#include <linux/preempt.h>
> +#include <linux/smp.h>
> +#include <linux/notifier.h>
> +#include <linux/module.h>
> +#include <linux/condcall.h>
> +#include <linux/kdebug.h>
> +
> +#include <asm/cacheflush.h>
> +
> +#define BREAKPOINT_INSTRUCTION  0xcc
> +#define BREAKPOINT_INS_LEN 1
> +
> +static DEFINE_MUTEX(cond_call_mutex);
> +static long target_eip = 0;

s/= 0//

> +static void cond_call_synchronize_core(void *info)
> +{
> +	sync_core();	/* use cpuid to stop speculative execution */
> +}
> +
> +/* The eip value points right after the breakpoint instruction,

What breakpoint insn?  How did it get there?

>  in the second
> + * byte of the movb. Incrementing it of 1 byte makes the code resume right after
> + * the movb instruction, effectively skipping this instruction.
> + *
> + * We simply skip the 2 bytes load immediate here, leaving the register in an
> + * undefined state. We don't care about the content (0 or !0), because we are
> + * changing the value 0->1 or 1->0. This small window of undefined value
> + * doesn't matter.
> + */
> +static int cond_call_notifier(struct notifier_block *nb,
> +	unsigned long val, void *data)
> +{
> +	enum die_val die_val = (enum die_val) val;
> +	struct die_args *args = (struct die_args *)data;

Unneeded cast of void*

> +	if (!args->regs || user_mode_vm(args->regs))
> +		return NOTIFY_DONE;
> +
> +	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
> +		args->regs->eip += 1; /* Skip the next byte of load immediate */
> +		return NOTIFY_STOP;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block cond_call_notify = {
> +	.notifier_call = cond_call_notifier,
> +	.priority = 0x7fffffff,	/* we need to be notified first */
> +};
> +
> +int cond_call_optimized_set_enable(void *address, char enable)
> +{
> +	char saved_byte;
> +	int ret;
> +	char *dest = address;
> +
> +	mutex_lock(&cond_call_mutex);
> +
> +	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
> +		goto end;
> +
> +	target_eip = (long)address + BREAKPOINT_INS_LEN;
> +	/* register_die_notifier has memory barriers */
> +	register_die_notifier(&cond_call_notify);
> +	saved_byte = *dest;
> +	*dest = BREAKPOINT_INSTRUCTION;
> +	wmb();
> +	/* Execute serializing instruction on each CPU.
> +	 * Acts as a memory barrier. */
> +	ret = on_each_cpu(cond_call_synchronize_core, NULL, 1, 1);
> +	BUG_ON(ret != 0);
> +
> +	dest[1] = enable;
> +	wmb();
> +	*dest = saved_byte;
> +		/* Wait for all int3 handlers to end
> +		   (interrupts are disabled in int3).
> +		   This CPU is clearly not in a int3 handler,
> +		   because int3 handler is not preemptible and
> +		   there cannot be any more int3 handler called
> +		   for this site, because we placed the original
> +		   instruction back.
> +		   synchronize_sched has memory barriers */
> +	synchronize_sched();
> +	unregister_die_notifier(&cond_call_notify);
> +	/* unregister_die_notifier has memory barriers */
> +	target_eip = 0;
> +end:
> +	mutex_unlock(&cond_call_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(cond_call_optimized_set_enable);

I'm not really able to review this material very usefully without having
seen an overall description of what it all does and how it all works.

What happens here when the text section is marked read-only, and when
CONFIG_DEBUG_PAGEALLOC is in use?

