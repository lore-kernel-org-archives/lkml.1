Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbXEJJHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbXEJJHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXEJJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:07:00 -0400
Received: from colin.muc.de ([193.149.48.1]:4033 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbXEJJG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:06:59 -0400
Date: 10 May 2007 11:06:56 +0200
Date: Thu, 10 May 2007 11:06:56 +0200
From: Andi Kleen <ak@muc.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070510090656.GA57297@muc.de>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020916.508519573@polymtl.ca>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:56:00PM -0400, Mathieu Desnoyers wrote:
> @@ -0,0 +1,99 @@
> +/* marker.c
> + *
> + * Erratum 49 fix for Intel PIII and higher.

Errata are CPU specific so they can't be higher. You mean it's a P3
erratum only?

In general you need some more description why the int3 handler is needed.

> + *
> + * Permits marker activation by XMC with correct serialization.

This doesn't follow the Intel recommended algorithm for cross modifying
code (7.1.3 in the IA32 manual) which requires the other CPUs to spin
during the modification.

If you used that would you really need the INT3 handler?

> +static DEFINE_MUTEX(mark_mutex);
> +static long target_eip = 0;
> +
> +static void mark_synchronize_core(void *info)
> +{
> +	sync_core();	/* use cpuid to stop speculative execution */
> +}
> +
> +/* We simply skip the 2 bytes load immediate here, leaving the register in an
> + * undefined state. We don't care about the content (0 or !0), because we are
> + * changing the value 0->1 or 1->0. This small window of undefined value
> + * doesn't matter.
> + */
> +static int mark_notifier(struct notifier_block *nb,
> +	unsigned long val, void *data)
> +{
> +	enum die_val die_val = (enum die_val) val;
> +	struct die_args *args = (struct die_args *)data;
> +
> +	if (!args->regs || user_mode_vm(args->regs))

I don't think regs should be ever NULL

> +		return NOTIFY_DONE;
> +
> +	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
> +		args->regs->eip += 1; /* Skip the next byte of load immediate */

In what instruction results that then? This is definitely underdocumented.

> +int marker_optimized_set_enable(void *address, char enable)
> +{
> +	char saved_byte;
> +	int ret;
> +	char *dest = address;
> +
> +	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
> +		return 0;

Wouldn't you need that inside the mutex too to avoid races?


> +
> +	mutex_lock(&mark_mutex);
> +	target_eip = (long)address + BREAKPOINT_INS_LEN;
> +	/* register_die_notifier has memory barriers */
> +	register_die_notifier(&mark_notify);
> +	saved_byte = *dest;
> +	*dest = BREAKPOINT_INSTRUCTION;
> +	wmb();

wmb is a nop

> +	/* Execute serializing instruction on each CPU.
> +	 * Acts as a memory barrier. */
> +	ret = on_each_cpu(mark_synchronize_core, NULL, 1, 1);
> +	BUG_ON(ret != 0);
> +
> +	dest[1] = enable;
> +	wmb();
> +	*dest = saved_byte;
> +		/* Wait for all int3 handlers to end
> +		   (interrupts are disabled in int3).
> +		   This CPU is clearly not in a int3 handler
> +		   (not preemptible).

So what happens when the kernel is preemptible? 

> +		   synchronize_sched has memory barriers */
> +	synchronize_sched();
> +	unregister_die_notifier(&mark_notify);
> +	/* unregister_die_notifier has memory barriers */
> +	target_eip = 0;
> +	mutex_unlock(&mark_mutex);
> +	flush_icache_range(address, size);

That's a nop on x86

> +
> +#ifdef CONFIG_MARKERS
> +
> +#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
> +
> +/* Optimized version of the markers */
> +#define trace_mark_optimized(flags, name, format, args...) \
> +	do { \
> +		static const char __mstrtab_name_##name[] \
> +		__attribute__((section("__markers_strings"))) \
> +		= #name; \
> +		static const char __mstrtab_format_##name[] \
> +		__attribute__((section("__markers_strings"))) \
> +		= format; \
> +		static const char __mstrtab_args_##name[] \
> +		__attribute__((section("__markers_strings"))) \
> +		= #args; \

For what do you need special string sections?  

If it's something to be read by external programs the interface
would need to be clearly defined and commented.
If not just use normal variables.

> +		static struct __mark_marker_data __mark_data_##name \
> +		__attribute__((section("__markers_data"))) = \
> +		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
> +		__mstrtab_args_##name, \
> +		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
> +		char condition; \
> +		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \

The volatile is not needed because the output is used.

> +					".long %1, 0f;\n\t" \
> +					".previous;\n\t" \
> +					".align 2\n\t" \
> +					"0:\n\t" \
> +					"movb $0,%0;\n\t" \

This should be a generic facility in a separate include file / separate 
macros etc so that it can be used by other code too.

> +				: "=r" (condition) \
> +				: "m" (__mark_data_##name)); \
> +		__mark_check_format(format, ## args); \
> +		if (likely(!condition)) { \
> +		} else { \
> +			preempt_disable(); \

Why the preempt disable here and why can't it be in the hook?

> +			(*__mark_data_##name.call)(&__mark_data_##name, \
> +						format, ## args); \
> +			preempt_enable(); \
> +		} \
> +	} while (0)
> +
> +/* Marker macro selecting the generic or optimized version of marker, depending
> + * on the flags specified. */
> +#define _trace_mark(flags, format, args...) \
> +do { \
> +	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
> +		trace_mark_optimized(flags, format, ## args); \
> +	else \
> +		trace_mark_generic(flags, format, ## args); \

Is there ever a good reason not to use optimized markers? 

> + * bytes. */
> +#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
> +#define MARK_OPTIMIZED_ENABLE_TYPE char

unsigned char is usually safer to avoid sign extension

-Andi
