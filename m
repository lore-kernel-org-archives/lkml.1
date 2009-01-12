Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZALXHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZALXHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZALXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:07:09 -0500
Received: from relay3.sgi.com ([192.48.171.31]:53141 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbZALXHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:07:08 -0500
Message-ID: <496BCD14.3020201@sgi.com>
Date: Mon, 12 Jan 2009 15:07:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org>
In-Reply-To: <496B9FC3.7080306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: save RAM with large NR_CPUS, get smaller nr_irqs
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Built and tested on an 8-core intel system.  Great reduction
in NR_IRQS:

	[    0.000000] NR_IRQS:33024 nr_irqs:320

Thanks Yinghai!

Ingo - shall I push this one as well?  (If not, then you
can add my:

	Acked-by: Mike Travis <travis@sgi.com>

Thanks,
Mike                                                                    

> 
> ---
>  arch/x86/include/asm/irq_vectors.h |    7 ++-----
>  arch/x86/kernel/io_apic.c          |   16 ++++++++++++++++
>  include/linux/interrupt.h          |    1 +
>  kernel/irq/handle.c                |    9 ++-------
>  kernel/softirq.c                   |    5 +++++
>  5 files changed, 26 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
> +++ linux-2.6/arch/x86/include/asm/irq_vectors.h
> @@ -120,14 +120,11 @@
>  # endif
>  #else
>  
> -/* defined as a macro so nr_irqs = max_nr_irqs(nr_cpu_ids) can be used */
> -# define max_nr_irqs(nr_cpus)				\
> -	((8 * nr_cpus) > (32 * MAX_IO_APICS) ?		\
> +# define NR_IRQS					\
> +	((8 * NR_CPUS) > (32 * MAX_IO_APICS) ?		\
>  		(NR_VECTORS + (8 * NR_CPUS)) :		\
>  		(NR_VECTORS + (32 * MAX_IO_APICS)))	\
>  
> -# define NR_IRQS max_nr_irqs(NR_CPUS)
> -
>  #endif
>  
>  #elif defined(CONFIG_X86_VOYAGER)
> Index: linux-2.6/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic.c
> +++ linux-2.6/arch/x86/kernel/io_apic.c
> @@ -3851,6 +3851,22 @@ void __init probe_nr_irqs_gsi(void)
>  		nr_irqs_gsi = nr;
>  }
>  
> +#ifdef CONFIG_SPARSE_IRQ
> +int __init arch_probe_nr_irqs(void)
> +{
> +	int nr;
> +
> +	nr = ((8 * nr_cpu_ids) > (32 * nr_ioapics) ?
> +		(NR_VECTORS + (8 * nr_cpu_ids)) :
> +		(NR_VECTORS + (32 * nr_ioapics)));
> +
> +	if (nr < nr_irqs && nr > nr_irqs_gsi)
> +		nr_irqs = nr;
> +
> +	return 0;
> +}
> +#endif
> +
>  /* --------------------------------------------------------------------------
>                            ACPI-based IOAPIC Configuration
>     -------------------------------------------------------------------------- */
> Index: linux-2.6/include/linux/interrupt.h
> ===================================================================
> --- linux-2.6.orig/include/linux/interrupt.h
> +++ linux-2.6/include/linux/interrupt.h
> @@ -481,6 +481,7 @@ int show_interrupts(struct seq_file *p,
>  struct irq_desc;
>  
>  extern int early_irq_init(void);
> +extern int arch_probe_nr_irqs(void);
>  extern int arch_early_irq_init(void);
>  extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
>  
> Index: linux-2.6/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/handle.c
> +++ linux-2.6/kernel/irq/handle.c
> @@ -59,10 +59,6 @@ EXPORT_SYMBOL_GPL(nr_irqs);
>  
>  #ifdef CONFIG_SPARSE_IRQ
>  
> -#ifndef max_nr_irqs
> -#define max_nr_irqs(nr_cpus)	NR_IRQS
> -#endif
> -
>  static struct irq_desc irq_desc_init = {
>  	.irq	    = -1,
>  	.status	    = IRQ_DISABLED,
> @@ -137,9 +133,8 @@ int __init early_irq_init(void)
>  	int legacy_count;
>  	int i;
>  
> -	/* initialize nr_irqs based on nr_cpu_ids */
> -	nr_irqs = max_nr_irqs(nr_cpu_ids);
> -
> +	 /* initialize nr_irqs based on nr_cpu_ids */
> +	arch_probe_nr_irqs();
>  	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
>  
>  	desc = irq_desc_legacy;
> Index: linux-2.6/kernel/softirq.c
> ===================================================================
> --- linux-2.6.orig/kernel/softirq.c
> +++ linux-2.6/kernel/softirq.c
> @@ -806,6 +806,11 @@ int __init __weak early_irq_init(void)
>  	return 0;
>  }
>  
> +int __init __weak arch_probe_nr_irqs(void)
> +{
> +	return 0;
> +}
> +
>  int __init __weak arch_early_irq_init(void)
>  {
>  	return 0;

