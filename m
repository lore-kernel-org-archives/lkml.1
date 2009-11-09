Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZKIEQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZKIEQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZKIEQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:16:35 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:42983 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZKIEQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=e80+NQqgvXOdGWy0FkuhAB6xzt5leMt/e86Cg6ePt4loJeAX6VIFvYd20ibd9MsjFv
         ZTPwXQCTBIVED4WcXghpI1qesg8yWNkRRh4k4shxVWhrnInav9fIAKHV4Q3Hr7PLnet4
         E1yG/CjEZr234bgoaJ20xt0qy+Pycp9bjkq9A=
Subject: Re: [PATCH -v6 08/13] tracing: add IRQENTRY_EXIT section for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
	 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
	 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
	 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
	 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
	 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
	 <3c82af564d70be05b92687949ed134ce034bf8db.1256569489.git.wuzhangjin@gmail.com>
	 <a11775df0ec9665fab5861f4fa63a3e192b9ffec.1256569489.git.wuzhangjin@gmail.com>
	 <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 09 Nov 2009 12:16:36 +0800
Message-ID: <1257740196.3451.15.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

This one is also MIPS relative, also need your feedback ;)

Thanks & Regards,
	Wu Zhangjin

On Mon, 2009-10-26 at 23:13 +0800, Wu Zhangjin wrote:
> This patch add a new section for MIPS to record the block of the hardirq
> handling for function graph tracer(print_graph_irq) via adding the
> __irq_entry annotation to the the entrypoints of the hardirqs(the block
> with irq_enter()...irq_exit()).
> 
> Thanks goes to Steven & Frederic Weisbecker for their feedbacks.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/include/asm/irq.h    |   29 ++---------------------------
>  arch/mips/kernel/irq.c         |   34 ++++++++++++++++++++++++++++++++++
>  arch/mips/kernel/smp.c         |    3 ++-
>  arch/mips/kernel/smtc.c        |   21 ++++++++++++++-------
>  arch/mips/kernel/vmlinux.lds.S |    1 +
>  arch/mips/sgi-ip22/ip22-int.c  |    3 ++-
>  arch/mips/sgi-ip22/ip22-time.c |    3 ++-
>  7 files changed, 57 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
> index 09b08d0..6cdd8c2 100644
> --- a/arch/mips/include/asm/irq.h
> +++ b/arch/mips/include/asm/irq.h
> @@ -113,36 +113,11 @@ do {									\
>  
>  #endif
>  
> -/*
> - * do_IRQ handles all normal device IRQ's (the special
> - * SMP cross-CPU interrupts have their own specific
> - * handlers).
> - *
> - * Ideally there should be away to get this into kernel/irq/handle.c to
> - * avoid the overhead of a call for just a tiny function ...
> - */
> -#define do_IRQ(irq)							\
> -do {									\
> -	irq_enter();							\
> -	__DO_IRQ_SMTC_HOOK(irq);					\
> -	generic_handle_irq(irq);					\
> -	irq_exit();							\
> -} while (0)
> +extern unsigned int do_IRQ(unsigned int irq);
>  
>  #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
> -/*
> - * To avoid inefficient and in some cases pathological re-checking of
> - * IRQ affinity, we have this variant that skips the affinity check.
> - */
> -
>  
> -#define do_IRQ_no_affinity(irq)						\
> -do {									\
> -	irq_enter();							\
> -	__NO_AFFINITY_IRQ_SMTC_HOOK(irq);				\
> -	generic_handle_irq(irq);					\
> -	irq_exit();							\
> -} while (0)
> +extern unsigned int do_IRQ_no_affinity(unsigned int irq);
>  
>  #endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
>  
> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> index 7b845ba..c10ea8f 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -22,6 +22,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/kallsyms.h>
>  #include <linux/kgdb.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/system.h>
> @@ -150,3 +151,36 @@ void __init init_IRQ(void)
>  		kgdb_early_setup = 1;
>  #endif
>  }
> +
> +/*
> + * do_IRQ handles all normal device IRQ's (the special
> + * SMP cross-CPU interrupts have their own specific
> + * handlers).
> + */
> +unsigned int __irq_entry do_IRQ(unsigned int irq)
> +{
> +	irq_enter();
> +	__DO_IRQ_SMTC_HOOK(irq);
> +	generic_handle_irq(irq);
> +	irq_exit();
> +
> +	return 1;
> +}
> +
> +#ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
> +/*
> + * To avoid inefficient and in some cases pathological re-checking of
> + * IRQ affinity, we have this variant that skips the affinity check.
> + */
> +
> +unsigned int __irq_entry do_IRQ_no_affinity(unsigned int irq)
> +{
> +	irq_enter();
> +	__NO_AFFINITY_IRQ_SMTC_HOOK(irq);
> +	generic_handle_irq(irq);
> +	irq_exit();
> +
> +	return 1;
> +}
> +
> +#endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index e72e684..6cdca19 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -32,6 +32,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/cpu.h>
>  #include <linux/err.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/cpu.h>
> @@ -130,7 +131,7 @@ asmlinkage __cpuinit void start_secondary(void)
>  /*
>   * Call into both interrupt handlers, as we share the IPI for them
>   */
> -void smp_call_function_interrupt(void)
> +void __irq_entry smp_call_function_interrupt(void)
>  {
>  	irq_enter();
>  	generic_smp_call_function_single_interrupt();
> diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
> index 24630fd..75034a8 100644
> --- a/arch/mips/kernel/smtc.c
> +++ b/arch/mips/kernel/smtc.c
> @@ -25,6 +25,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/module.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/cpu.h>
>  #include <asm/processor.h>
> @@ -939,23 +940,29 @@ static void ipi_call_interrupt(void)
>  
>  DECLARE_PER_CPU(struct clock_event_device, mips_clockevent_device);
>  
> -void ipi_decode(struct smtc_ipi *pipi)
> +static void __irq_entry smtc_clock_tick_interrupt(void)
>  {
>  	unsigned int cpu = smp_processor_id();
>  	struct clock_event_device *cd;
> +	int irq = MIPS_CPU_IRQ_BASE + 1;
> +
> +	irq_enter();
> +	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
> +	cd = &per_cpu(mips_clockevent_device, cpu);
> +	cd->event_handler(cd);
> +	irq_exit();
> +}
> +
> +void ipi_decode(struct smtc_ipi *pipi)
> +{
>  	void *arg_copy = pipi->arg;
>  	int type_copy = pipi->type;
> -	int irq = MIPS_CPU_IRQ_BASE + 1;
>  
>  	smtc_ipi_nq(&freeIPIq, pipi);
>  
>  	switch (type_copy) {
>  	case SMTC_CLOCK_TICK:
> -		irq_enter();
> -		kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
> -		cd = &per_cpu(mips_clockevent_device, cpu);
> -		cd->event_handler(cd);
> -		irq_exit();
> +		smtc_clock_tick_interrupt();
>  		break;
>  
>  	case LINUX_SMP_IPI:
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 162b299..f25df73 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -46,6 +46,7 @@ SECTIONS
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> +		IRQENTRY_TEXT
>  		*(.text.*)
>  		*(.fixup)
>  		*(.gnu.warning)
> diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
> index 0ecd5fe..383f11d 100644
> --- a/arch/mips/sgi-ip22/ip22-int.c
> +++ b/arch/mips/sgi-ip22/ip22-int.c
> @@ -13,6 +13,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/interrupt.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/irq_cpu.h>
>  #include <asm/sgi/hpc3.h>
> @@ -150,7 +151,7 @@ static void indy_local1_irqdispatch(void)
>  
>  extern void ip22_be_interrupt(int irq);
>  
> -static void indy_buserror_irq(void)
> +static void __irq_entry indy_buserror_irq(void)
>  {
>  	int irq = SGI_BUSERR_IRQ;
>  
> diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
> index c8f7d23..603fc91 100644
> --- a/arch/mips/sgi-ip22/ip22-time.c
> +++ b/arch/mips/sgi-ip22/ip22-time.c
> @@ -16,6 +16,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/time.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/cpu.h>
>  #include <asm/mipsregs.h>
> @@ -115,7 +116,7 @@ __init void plat_time_init(void)
>  }
>  
>  /* Generic SGI handler for (spurious) 8254 interrupts */
> -void indy_8254timer_irq(void)
> +void __irq_entry indy_8254timer_irq(void)
>  {
>  	int irq = SGI_8254_0_IRQ;
>  	ULONG cnt;


