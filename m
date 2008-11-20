Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYKTXMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYKTXMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYKTXMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:12:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYKTXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:12:24 -0500
Date: Thu, 20 Nov 2008 15:12:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
Message-Id: <20081120151208.f7892050.akpm@linux-foundation.org>
In-Reply-To: <20081119212631.GC3377@sgi.com>
References: <20081023163041.GA14574@sgi.com>
	<20081119212202.GA3377@sgi.com>
	<20081119212350.GB3377@sgi.com>
	<20081119212631.GC3377@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 15:26:31 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> This patch allocates a system interrupt vector for platform specific use
> in implementing timer interrupts.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Refreshing this to use 0xed as the vector.  Have repackaged it to be more
> generic.
> 
>  arch/x86/include/asm/hw_irq.h      |    1 
>  arch/x86/include/asm/irq.h         |    2 +
>  arch/x86/include/asm/irq_vectors.h |    5 +++
>  arch/x86/kernel/entry_64.S         |    4 ++
>  arch/x86/kernel/irqinit_64.c       |   45 +++++++++++++++++++++++++++++++++
>  5 files changed, 57 insertions(+)
> 
> Index: linux/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/entry_64.S	2008-11-19 14:59:15.000000000 -0600
> +++ linux/arch/x86/kernel/entry_64.S	2008-11-19 15:02:16.000000000 -0600
> @@ -865,6 +865,10 @@ ENTRY(apic_timer_interrupt)
>  	apicinterrupt LOCAL_TIMER_VECTOR,smp_apic_timer_interrupt
>  END(apic_timer_interrupt)
>  
> +ENTRY(generic_timer_interrupt)
> +	apicinterrupt GENERIC_TIMER_VECTOR,smp_generic_timer_interrupt
> +END(generic_timer_interrupt)
> +
>  ENTRY(uv_bau_message_intr1)
>  	apicinterrupt 220,uv_bau_message_interrupt
>  END(uv_bau_message_intr1)
> Index: linux/arch/x86/kernel/irqinit_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/irqinit_64.c	2008-11-19 14:59:15.000000000 -0600
> +++ linux/arch/x86/kernel/irqinit_64.c	2008-11-19 15:09:36.000000000 -0600
> @@ -23,6 +23,7 @@
>  #include <asm/desc.h>
>  #include <asm/apic.h>
>  #include <asm/i8259.h>
> +#include <asm/idle.h>
>  
>  /*
>   * Common place to define all x86 IRQ vectors
> @@ -161,6 +162,47 @@ void __init init_ISA_irqs(void)
>  
>  void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
>  
> +
> +/* Function pointer for generic timer interrupt handling */
> +static void (*generic_timer_interrupt_extension)(void);
> +
> +int
> +generic_timer_reg_extension(void (*fn)(void))
> +{
> +	if (generic_timer_interrupt_extension)
> +		return 1;
> +
> +	generic_timer_interrupt_extension = fn;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(generic_timer_reg_extension);

ah-hah, there it is!  These patches are in the wrong order, no?


> +void
> +generic_timer_unreg_extension(void)
> +{
> +	if (generic_timer_interrupt_extension)
> +		generic_timer_interrupt_extension = NULL;
> +}
> +EXPORT_SYMBOL_GPL(generic_timer_unreg_extension);
> +
> +void smp_generic_timer_interrupt(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	ack_APIC_irq();
> +
> +	exit_idle();
> +
> +	irq_enter();
> +
> +	if (generic_timer_interrupt_extension)
> +		generic_timer_interrupt_extension();
> +
> +	irq_exit();
> +
> +	set_irq_regs(old_regs);
> +}

OK, I guess that answers my earlier question.

These function names are awful.  I thought that
"generic_timer_reg_extension" had something to to with hardware
registers in the timer.  I see now that you abbreviated "register" to
"reg".

Please rename these to

register_generic_timer_extension()
unregister_generic_timer_extension()



> >  static void __init smp_intr_init(void)
>  {
>  #ifdef CONFIG_SMP
> @@ -202,6 +244,9 @@ static void __init apic_intr_init(void)
>  	/* self generated IPI for local APIC timer */
>  	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
>  
> +	/* IPI for platform specific timers */
> +	alloc_intr_gate(GENERIC_TIMER_VECTOR, generic_timer_interrupt);
> +
>  	/* IPI vectors for APIC spurious and error interrupts */
>  	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
>  	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
> Index: linux/arch/x86/include/asm/irq_vectors.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/irq_vectors.h	2008-11-19 14:59:15.000000000 -0600
> +++ linux/arch/x86/include/asm/irq_vectors.h	2008-11-19 15:02:16.000000000 -0600
> @@ -92,6 +92,11 @@
>  #define LOCAL_PERFMON_VECTOR	0xee
>  
>  /*
> + * Generic timer vector for platform specific use
> + */
> +#define GENERIC_TIMER_VECTOR	0xed
> +
> +/*
>   * First APIC vector available to drivers: (vectors 0x30-0xee) we
>   * start at 0x31(0x41) to spread out vectors evenly between priority
>   * levels. (0x80 is the syscall vector)
> Index: linux/arch/x86/include/asm/hw_irq.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/hw_irq.h	2008-11-19 14:59:15.000000000 -0600
> +++ linux/arch/x86/include/asm/hw_irq.h	2008-11-19 15:02:16.000000000 -0600
> @@ -29,6 +29,7 @@
>  
>  /* Interrupt handlers registered during init_IRQ */
>  extern void apic_timer_interrupt(void);
> +extern void generic_timer_interrupt(void);
>  extern void error_interrupt(void);
>  extern void spurious_interrupt(void);
>  extern void thermal_interrupt(void);
> Index: linux/arch/x86/include/asm/irq.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/irq.h	2008-11-19 14:59:15.000000000 -0600
> +++ linux/arch/x86/include/asm/irq.h	2008-11-19 15:02:16.000000000 -0600
> @@ -38,6 +38,8 @@ extern void fixup_irqs(cpumask_t map);
>  
>  extern unsigned int do_IRQ(struct pt_regs *regs);
>  extern void init_IRQ(void);
> +extern int generic_timer_reg_extension(void (*fn)(void));
> +extern void generic_timer_unreg_extension(void);
>  extern void native_init_IRQ(void);
>  
>  /* Interrupt vector management */
