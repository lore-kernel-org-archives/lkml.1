Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658Ab0AHPWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0AHPWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504Ab0AHPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:22:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0AHPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:22:46 -0500
X-Authority-Analysis: v=1.0 c=1 a=9M3Cre7RvXkA:10 a=7U3hwN5JcxgA:10 a=gAnH3GRIAAAA:8 a=Yt095zgXA02ydpt3vGwA:9 a=CDQ0oooD5QE3pNpqIvoA:7 a=gfwrZuYEuHMhehbPpTiKX4wM0iIA:4 a=rPGc2HzQRbAA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Yi <yi.li@analog.com>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <20100108051847.GB5468@nowhere>
References: <1262925925.27700.15.camel@adam-desktop>
	 <20100108051847.GB5468@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 08 Jan 2010 10:22:43 -0500
Message-ID: <1262964163.28171.3781.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 06:18 +0100, Frederic Weisbecker wrote:
> On Fri, Jan 08, 2010 at 12:45:25PM +0800, Li Yi wrote:
> > "irqsoff" tracer may cause stack overflow on architectures using
> > asm-generic/atomic.h, due to recursive invoking of, e.g.
> > trace_hardirqs_off().
> > 
> > trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() ->
> > atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()
> > 
> > Signed-off-by: Yi Li <yi.li@analog.com>
> 
> 
> 
> Good catch!

Yes, nice catch indeed. Hmm, I wonder if lockdep has any issues here as
well? /me looks, no it uses current->lockdep_recursion++, where trace
hardirqsoff uses atomic_inc_return :-/


> 
> However, may be we should keep the local_irq_save there
> and have __raw_atomic_* versions only for tracing.
> 
> It's better to keep track of most irq disabled sites.
> 
> Why not something like the following (untested):
> 
> 
> diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> index c99c64d..ffc6772 100644
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -17,6 +17,14 @@
>  #error not SMP safe
>  #endif

Comment needed here:

/*
 * The irqsoff tracer uses atomic_inc_return to prevent recursion.
 * Unfortunately, in this file, atomic_inc_return disables interrupts
 * which causes the recursion the irqsoff trace was trying to prevent.
 *
 * The irqsoff tracer will define __ATOMIC_NEED_RAW_IRQ_SAVE before
 * including this file, which will make the atomic_inc_return use
 * the raw versions of interrupts disabling. This will allow other
 * users of the atomic_inc_return to still have the interrupt
 * disabling be traced, but will prevent the recursion by the
 * irqsoff tracer itself.
 */


>  
> +#ifdef __ATOMIC_NEED_RAW_IRQ_SAVE
> +#define __atomic_op_irq_save(f)		raw_local_irq_save(f)
> +#define __atomic_op_irq_restore(f)	raw_local_irq_restore(f)
> +#else
> +#define __atomic_op_irq_save(f)		local_irq_save(f)
> +#define __atomic_op_irq_restore(f)	local_irq_restore(f)
> +#endif
> +
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
>   * resource counting etc..
> @@ -60,11 +68,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  	unsigned long flags;
>  	int temp;
>  
> -	local_irq_save(flags);
> +	__atomic_op_irq_save(flags);
>  	temp = v->counter;
>  	temp += i;
>  	v->counter = temp;
> -	local_irq_restore(flags);
> +	__atomic_op_irq_restore(flags);
>  
>  	return temp;
>  }
> @@ -82,11 +90,11 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  	unsigned long flags;
>  	int temp;
>  
> -	local_irq_save(flags);
> +	__atomic_op_irq_save(flags);
>  	temp = v->counter;
>  	temp -= i;
>  	v->counter = temp;
> -	local_irq_restore(flags);
> +	__atomic_op_irq_restore(flags);
>  
>  	return temp;
>  }
> @@ -139,9 +147,9 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>  	unsigned long flags;
>  
>  	mask = ~mask;
> -	local_irq_save(flags);
> +	__atomic_op_irq_save(flags);
>  	*addr &= mask;
> -	local_irq_restore(flags);
> +	__atomic_op_irq_restore(flags);
>  }
>  
>  #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 2974bc7..6bcb1d1 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -9,6 +9,9 @@
>   *  Copyright (C) 2004-2006 Ingo Molnar
>   *  Copyright (C) 2004 William Lee Irwin III
>   */
> +
> +#define __ATOMIC_NEED_RAW_IRQ_SAVE
> +
>  #include <linux/kallsyms.h>
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
> 

I wonder if we could just use a per_cpu variable and increment that
instead. Since the irqsoff tracer only gets called with interrupts
disabled (and the preemptoff with preemption disabled), a per_cpu
variable should be protected well.

-- Steve



