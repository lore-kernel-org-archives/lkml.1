Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbYAaMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbYAaMGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYAaMGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:06:11 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:61957 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763581AbYAaMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:06:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP1IoUdMQWYq/2dsb2JhbACBWKl/
Date: Thu, 31 Jan 2008 07:06:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 21/23 -v8] Add markers to various events
Message-ID: <20080131120605.GA8493@Krystal>
References: <20080130210357.927754294@goodmis.org> <20080130210528.149582393@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080130210528.149582393@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:01:41 up 88 days, 17:07,  4 users,  load average: 0.65, 0.46,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> This patch adds markers to various events in the kernel.
> (interrupts, task activation and hrtimers)
> 

Hi Steven,

I would propose the following standard for IRQ handler markers:

trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", irq,
  (regs)?(!user_mode(regs)):(1));
...
trace_mark(kernel_irq_exit, MARK_NOARGS);

So we can know the elaspsed time in irq handlers and whether they are
nested on user of kernel code.

The same for traps :

trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", trapnr,
  instruction_pointer(regs));

Where we know the trap number and the instruction pointer that caused
the trap. Here again, we should put a :

trace_mark(kernel_arch_trap_exit, MARK_NOARGS);

At the end of the trap handlers.

It makes automatic analysis _much_ easier than trying to gather each and
every handler instrumentation which would have a different name...

Mathieu

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/apic_32.c  |    2 ++
>  arch/x86/kernel/irq_32.c   |    1 +
>  arch/x86/kernel/irq_64.c   |    2 ++
>  arch/x86/kernel/traps_32.c |    2 ++
>  arch/x86/kernel/traps_64.c |    2 ++
>  arch/x86/mm/fault_32.c     |    3 +++
>  arch/x86/mm/fault_64.c     |    3 +++
>  kernel/hrtimer.c           |    7 +++++++
>  kernel/sched.c             |   11 +++++++++++
>  9 files changed, 33 insertions(+)
> 
> Index: linux-mcount.git/arch/x86/kernel/apic_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/apic_32.c	2008-01-30 15:10:16.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/apic_32.c	2008-01-30 15:54:06.000000000 -0500
> @@ -581,6 +581,8 @@ notrace fastcall void smp_apic_timer_int
>  {
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  
> +	trace_mark(arch_apic_timer, "ip %lx", regs->eip);
> +
>  	/*
>  	 * NOTE! We'd better ACK the irq immediately,
>  	 * because timer handling can be slow.
> Index: linux-mcount.git/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/irq_32.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/irq_32.c	2008-01-30 15:54:06.000000000 -0500
> @@ -85,6 +85,7 @@ fastcall unsigned int do_IRQ(struct pt_r
>  
>  	old_regs = set_irq_regs(regs);
>  	irq_enter();
> +	trace_mark(arch_do_irq, "ip %lx irq %d", regs->eip, irq);
>  #ifdef CONFIG_DEBUG_STACKOVERFLOW
>  	/* Debugging check for stack overflow: is there less than 1KB free? */
>  	{
> Index: linux-mcount.git/arch/x86/kernel/irq_64.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/irq_64.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/irq_64.c	2008-01-30 15:54:06.000000000 -0500
> @@ -149,6 +149,8 @@ asmlinkage unsigned int do_IRQ(struct pt
>  	irq_enter();
>  	irq = __get_cpu_var(vector_irq)[vector];
>  
> +	trace_mark(arch_do_irq, "ip %lx irq %d", regs->rip, irq);
> +
>  #ifdef CONFIG_DEBUG_STACKOVERFLOW
>  	stack_overflow_check(regs);
>  #endif
> Index: linux-mcount.git/arch/x86/kernel/traps_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/traps_32.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/traps_32.c	2008-01-30 15:54:06.000000000 -0500
> @@ -769,6 +769,8 @@ fastcall __kprobes void do_nmi(struct pt
>  
>  	nmi_enter();
>  
> +	trace_mark(arch_do_nmi, "ip %lx flags %lx", regs->eip, regs->eflags);
> +
>  	cpu = smp_processor_id();
>  
>  	++nmi_count(cpu);
> Index: linux-mcount.git/arch/x86/kernel/traps_64.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/kernel/traps_64.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/kernel/traps_64.c	2008-01-30 15:54:06.000000000 -0500
> @@ -782,6 +782,8 @@ asmlinkage __kprobes void default_do_nmi
>  
>  	cpu = smp_processor_id();
>  
> +	trace_mark(arch_do_nmi, "ip %lx flags %lx", regs->rip, regs->eflags);
> +
>  	/* Only the BSP gets external NMIs from the system.  */
>  	if (!cpu)
>  		reason = get_nmi_reason();
> Index: linux-mcount.git/arch/x86/mm/fault_32.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/mm/fault_32.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/mm/fault_32.c	2008-01-30 15:54:06.000000000 -0500
> @@ -311,6 +311,9 @@ fastcall void __kprobes do_page_fault(st
>  	/* get the address */
>          address = read_cr2();
>  
> +	trace_mark(arch_do_page_fault, "ip %lx err %lx addr %lx",
> +		   regs->eip, error_code, address);
> +
>  	tsk = current;
>  
>  	si_code = SEGV_MAPERR;
> Index: linux-mcount.git/arch/x86/mm/fault_64.c
> ===================================================================
> --- linux-mcount.git.orig/arch/x86/mm/fault_64.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/arch/x86/mm/fault_64.c	2008-01-30 15:54:06.000000000 -0500
> @@ -316,6 +316,9 @@ asmlinkage void __kprobes do_page_fault(
>  	/* get the address */
>  	address = read_cr2();
>  
> +	trace_mark(arch_do_page_fault, "ip %lx err %lx addr %lx",
> +		   regs->rip, error_code, address);
> +
>  	info.si_code = SEGV_MAPERR;
>  
>  
> Index: linux-mcount.git/kernel/hrtimer.c
> ===================================================================
> --- linux-mcount.git.orig/kernel/hrtimer.c	2008-01-30 14:35:48.000000000 -0500
> +++ linux-mcount.git/kernel/hrtimer.c	2008-01-30 15:54:06.000000000 -0500
> @@ -709,6 +709,8 @@ static void enqueue_hrtimer(struct hrtim
>  	struct hrtimer *entry;
>  	int leftmost = 1;
>  
> +	trace_mark(kernel_hrtimer_enqueue,
> +		   "expires %p timer %p", &timer->expires, timer);
>  	/*
>  	 * Find the right place in the rbtree:
>  	 */
> @@ -1130,6 +1132,7 @@ void hrtimer_interrupt(struct clock_even
>  
>   retry:
>  	now = ktime_get();
> +	trace_mark(kernel_hrtimer_interrupt, "now %p", &now);
>  
>  	expires_next.tv64 = KTIME_MAX;
>  
> @@ -1168,6 +1171,10 @@ void hrtimer_interrupt(struct clock_even
>  				continue;
>  			}
>  
> +			trace_mark(kernel_hrtimer_interrupt_expire,
> +				   "expires %p timer %p",
> +				   &timer->expires, timer);
> +
>  			__run_hrtimer(timer);
>  		}
>  		spin_unlock(&cpu_base->lock);
> Index: linux-mcount.git/kernel/sched.c
> ===================================================================
> --- linux-mcount.git.orig/kernel/sched.c	2008-01-30 15:46:44.000000000 -0500
> +++ linux-mcount.git/kernel/sched.c	2008-01-30 15:54:06.000000000 -0500
> @@ -90,6 +90,11 @@ unsigned long long __attribute__((weak))
>  #define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
>  #define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
>  
> +#define __PRIO(prio) \
> +	((prio) <= 99 ? 199 - (prio) : (prio) - 120)
> +
> +#define PRIO(p) __PRIO((p)->prio)
> +
>  /*
>   * 'User priority' is the nice value converted to something we
>   * can work with better when scaling various scheduler parameters,
> @@ -1372,6 +1377,9 @@ static void activate_task(struct rq *rq,
>  	if (p->state == TASK_UNINTERRUPTIBLE)
>  		rq->nr_uninterruptible--;
>  
> +	trace_mark(kernel_sched_activate_task,
> +		   "pid %d prio %d nr_running %ld",
> +		   p->pid, PRIO(p), rq->nr_running);
>  	enqueue_task(rq, p, wakeup);
>  	inc_nr_running(p, rq);
>  }
> @@ -1385,6 +1393,9 @@ static void deactivate_task(struct rq *r
>  		rq->nr_uninterruptible++;
>  
>  	dequeue_task(rq, p, sleep);
> +	trace_mark(kernel_sched_deactivate_task,
> +		   "pid %d prio %d nr_running %ld",
> +		   p->pid, PRIO(p), rq->nr_running);
>  	dec_nr_running(p, rq);
>  }
>  
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
