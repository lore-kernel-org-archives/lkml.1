Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYACR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYACR5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYACR5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:57:23 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:35589 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbYACR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:57:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADKxfEdMROHU/2dsb2JhbACBV6he
Date: Thu, 3 Jan 2008 12:52:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 04/11] i386: notrace annotations
Message-ID: <20080103175210.GD30582@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072227.246140689@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103072227.246140689@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:43:30 up 60 days, 22:48,  5 users,  load average: 0.54, 0.65,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From patch-2.6.21.5-rt20. Annotates functions that should not be profiler
> instrumented, i.e. where mcount should not be called at function entry.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/apic_32.c  |    2 +-
>  arch/x86/kernel/hpet.c     |    2 +-
>  arch/x86/kernel/irq_32.c   |    2 +-
>  arch/x86/kernel/nmi_32.c   |    2 +-
>  arch/x86/kernel/smp_32.c   |    2 +-
>  arch/x86/kernel/time_32.c  |    2 +-
>  arch/x86/kernel/traps_32.c |    4 ++--
>  arch/x86/kernel/tsc_32.c   |    2 +-
>  arch/x86/lib/delay_32.c    |    6 +++---
>  arch/x86/mm/fault_32.c     |    4 ++--
>  arch/x86/mm/init_32.c      |    2 +-
>  11 files changed, 15 insertions(+), 15 deletions(-)
> ---
> 
> Index: linux-compile.git/arch/x86/kernel/apic_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/apic_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/apic_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -577,7 +577,7 @@ static void local_apic_timer_interrupt(v
>   *   interrupt as well. Thus we cannot inline the local irq ... ]
>   */
>  
> -void fastcall smp_apic_timer_interrupt(struct pt_regs *regs)
> +notrace fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
>  {
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  

Why can't this be traced ?

> Index: linux-compile.git/arch/x86/kernel/hpet.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/hpet.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/hpet.c	2008-01-02 22:56:41.000000000 -0500
> @@ -295,7 +295,7 @@ static int hpet_legacy_next_event(unsign
>  /*
>   * Clock source related code
>   */
> -static cycle_t read_hpet(void)
> +static notrace cycle_t read_hpet(void)
>  {
>  	return (cycle_t)hpet_readl(HPET_COUNTER);
>  }

This one is weird on x86 32 : a 32 bits value is casted into a
(cycles_t), which is an unsigned long long. So we think we have a 64
bits counter when in fact we only have 32 bits. How long before the wrap
around ?

> Index: linux-compile.git/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/irq_32.c	2008-01-02 22:56:34.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/irq_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -66,7 +66,7 @@ static union irq_ctx *softirq_ctx[NR_CPU
>   * SMP cross-CPU interrupts have their own specific
>   * handlers).
>   */
> -fastcall unsigned int do_IRQ(struct pt_regs *regs)
> +notrace fastcall unsigned int do_IRQ(struct pt_regs *regs)

Why ?

>  {
>  	struct pt_regs *old_regs;
>  	/* high bit used in ret_from_ code */
> Index: linux-compile.git/arch/x86/kernel/nmi_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/nmi_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/nmi_32.c	2008-01-02 22:57:52.000000000 -0500
> @@ -323,7 +323,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
>  
>  extern void die_nmi(struct pt_regs *, const char *msg);
>  
> -__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
> +notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
>  {

Why ? ... hrm, this is dangerous : you will then have to look at _every_
code path that can be run in an NMI context (printk included) and mark
them "notrace" or make sure your tracer is disabled when they are run.

>  
>  	/*
> Index: linux-compile.git/arch/x86/kernel/smp_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/smp_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/smp_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -638,7 +638,7 @@ static void native_smp_send_stop(void)
>   * all the work is done automatically when
>   * we return from the interrupt.
>   */
> -fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
> +notrace fastcall void smp_reschedule_interrupt(struct pt_regs *regs)

why?

>  {
>  	ack_APIC_irq();
>  	__get_cpu_var(irq_stat).irq_resched_count++;
> Index: linux-compile.git/arch/x86/kernel/time_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/time_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/time_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -122,7 +122,7 @@ static int set_rtc_mmss(unsigned long no
>  
>  int timer_ack;
>  
> -unsigned long profile_pc(struct pt_regs *regs)
> +notrace unsigned long profile_pc(struct pt_regs *regs)
>  {
>  	unsigned long pc = instruction_pointer(regs);
>  
> Index: linux-compile.git/arch/x86/kernel/traps_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/traps_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/traps_32.c	2008-01-02 22:58:19.000000000 -0500
> @@ -723,7 +723,7 @@ void __kprobes die_nmi(struct pt_regs *r
>  	do_exit(SIGSEGV);
>  }
>  
> -static __kprobes void default_do_nmi(struct pt_regs * regs)
> +static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
>  
> @@ -763,7 +763,7 @@ static __kprobes void default_do_nmi(str
>  
>  static int ignore_nmis;
>  
> -fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
> +notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
>  {
>  	int cpu;
>  

Same here.. we must be careful, or use atomic ops instead of interrupt
disabling.

> Index: linux-compile.git/arch/x86/kernel/tsc_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/tsc_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/tsc_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -269,7 +269,7 @@ core_initcall(cpufreq_tsc);
>  
>  static unsigned long current_tsc_khz = 0;
>  
> -static cycle_t read_tsc(void)
> +static notrace cycle_t read_tsc(void)
>  {
>  	cycle_t ret;
>  
> Index: linux-compile.git/arch/x86/lib/delay_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/lib/delay_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/lib/delay_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -24,7 +24,7 @@
>  #endif
>  
>  /* simple loop based delay: */
> -static void delay_loop(unsigned long loops)
> +static notrace void delay_loop(unsigned long loops)
>  {
>  	int d0;
>  
> @@ -39,7 +39,7 @@ static void delay_loop(unsigned long loo
>  }
>  
>  /* TSC based delay: */
> -static void delay_tsc(unsigned long loops)
> +static notrace void delay_tsc(unsigned long loops)
>  {
>  	unsigned long bclock, now;
>  
> @@ -72,7 +72,7 @@ int read_current_timer(unsigned long *ti
>  	return -1;
>  }
>  
> -void __delay(unsigned long loops)
> +notrace void __delay(unsigned long loops)
>  {
>  	delay_fn(loops);
>  }
> Index: linux-compile.git/arch/x86/mm/fault_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/mm/fault_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/mm/fault_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -293,8 +293,8 @@ int show_unhandled_signals = 1;
>   *	bit 3 == 1 means use of reserved bit detected
>   *	bit 4 == 1 means fault was an instruction fetch
>   */
> -fastcall void __kprobes do_page_fault(struct pt_regs *regs,
> -				      unsigned long error_code)
> +notrace fastcall void __kprobes do_page_fault(struct pt_regs *regs,
> +					      unsigned long error_code)

Agreed on this one. It get's called when new modules are loaded for
in-kernel faults. Hard to trace. Will vmalloc_fault, an inline function,
trigger an mcount call ?

>  {
>  	struct task_struct *tsk;
>  	struct mm_struct *mm;
> Index: linux-compile.git/arch/x86/mm/init_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/mm/init_32.c	2008-01-02 22:53:52.000000000 -0500
> +++ linux-compile.git/arch/x86/mm/init_32.c	2008-01-02 22:56:41.000000000 -0500
> @@ -200,7 +200,7 @@ static inline int page_kills_ppro(unsign
>  	return 0;
>  }
>  
> -int page_is_ram(unsigned long pagenr)
> +notrace int page_is_ram(unsigned long pagenr)
>  {
>  	int i;
>  	unsigned long addr, end;
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
