Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZAHMG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZAHMG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZAHMGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:06:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZAHMGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:06:49 -0500
Date: Thu, 8 Jan 2009 13:06:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090108120619.GF1539@elte.hu>
References: <496534B1.6080902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496534B1.6080902@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Matt Cc:-ed)

Matt, does this look good to you? The point of this cleanup would be to 
make desc->timer_rand_state depend on hardirq (the presence of irq_desc[]) 
- not sparseirq (which does not make much sense).

	Ingo

* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: clean up
> 
> Ingo suggested to change some ifdef from SPARSE_IRQ to GENERIC_HARDIRQS
> so we could some #ifdef later if all arch support genirq
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/char/random.c        |    2 +-
>  drivers/pci/intr_remapping.c |    2 +-
>  include/linux/irq.h          |    6 ++----
>  include/linux/kernel_stat.h  |    6 +++---
>  kernel/irq/handle.c          |    7 ++++---
>  5 files changed, 11 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/char/random.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/random.c
> +++ linux-2.6/drivers/char/random.c
> @@ -558,7 +558,7 @@ struct timer_rand_state {
>  	unsigned dont_count_entropy:1;
>  };
>  
> -#ifndef CONFIG_SPARSE_IRQ
> +#ifndef CONFIG_GENERIC_HARDIRQS
>  
>  static struct timer_rand_state *irq_timer_state[NR_IRQS];
>  
> Index: linux-2.6/drivers/pci/intr_remapping.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/intr_remapping.c
> +++ linux-2.6/drivers/pci/intr_remapping.c
> @@ -20,7 +20,7 @@ struct irq_2_iommu {
>  	u8  irte_mask;
>  };
>  
> -#ifdef CONFIG_SPARSE_IRQ
> +#ifdef CONFIG_GENERIC_HARDIRQS
>  static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
>  {
>  	struct irq_2_iommu *iommu;
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -160,12 +160,10 @@ struct irq_2_iommu;
>   */
>  struct irq_desc {
>  	unsigned int		irq;
> -#ifdef CONFIG_SPARSE_IRQ
>  	struct timer_rand_state *timer_rand_state;
>  	unsigned int            *kstat_irqs;
> -# ifdef CONFIG_INTR_REMAP
> +#ifdef CONFIG_INTR_REMAP
>  	struct irq_2_iommu      *irq_2_iommu;
> -# endif
>  #endif
>  	irq_flow_handler_t	handle_irq;
>  	struct irq_chip		*chip;
> @@ -202,13 +200,13 @@ extern void arch_free_chip_data(struct i
>  extern struct irq_desc irq_desc[NR_IRQS];
>  #else /* CONFIG_SPARSE_IRQ */
>  extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
> +#endif /* CONFIG_SPARSE_IRQ */
>  
>  #define kstat_irqs_this_cpu(DESC) \
>  	((DESC)->kstat_irqs[smp_processor_id()])
>  #define kstat_incr_irqs_this_cpu(irqno, DESC) \
>  	((DESC)->kstat_irqs[smp_processor_id()]++)
>  
> -#endif /* CONFIG_SPARSE_IRQ */
>  
>  extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
>  
> Index: linux-2.6/include/linux/kernel_stat.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kernel_stat.h
> +++ linux-2.6/include/linux/kernel_stat.h
> @@ -28,7 +28,7 @@ struct cpu_usage_stat {
>  
>  struct kernel_stat {
>  	struct cpu_usage_stat	cpustat;
> -#ifndef CONFIG_SPARSE_IRQ
> +#ifndef CONFIG_GENERIC_HARDIRQS
>         unsigned int irqs[NR_IRQS];
>  #endif
>  };
> @@ -41,7 +41,7 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
>  
>  extern unsigned long long nr_context_switches(void);
>  
> -#ifndef CONFIG_SPARSE_IRQ
> +#ifndef CONFIG_GENERIC_HARDIRQS
>  #define kstat_irqs_this_cpu(irq) \
>  	(kstat_this_cpu.irqs[irq])
>  
> @@ -55,7 +55,7 @@ static inline void kstat_incr_irqs_this_
>  #endif
>  
>  
> -#ifndef CONFIG_SPARSE_IRQ
> +#ifndef CONFIG_GENERIC_HARDIRQS
>  static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
>  {
>         return kstat_cpu(cpu).irqs[irq];
> Index: linux-2.6/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/handle.c
> +++ linux-2.6/kernel/irq/handle.c
> @@ -213,6 +213,7 @@ struct irq_desc irq_desc[NR_IRQS] __cach
>  	}
>  };
>  
> +static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
>  int __init early_irq_init(void)
>  {
>  	struct irq_desc *desc;
> @@ -222,8 +223,10 @@ int __init early_irq_init(void)
>  	desc = irq_desc;
>  	count = ARRAY_SIZE(irq_desc);
>  
> -	for (i = 0; i < count; i++)
> +	for (i = 0; i < count; i++) {
>  		desc[i].irq = i;
> +		desc[i].kstat_irqs = kstat_irqs_all[i];
> +	}
>  
>  	return arch_early_irq_init();
>  }
> @@ -451,12 +454,10 @@ void early_init_irq_lock_class(void)
>  	}
>  }
>  
> -#ifdef CONFIG_SPARSE_IRQ
>  unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	return desc ? desc->kstat_irqs[cpu] : 0;
>  }
> -#endif
>  EXPORT_SYMBOL(kstat_irqs_cpu);
>  
