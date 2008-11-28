Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYK1Qf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYK1Qf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYK1QfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:35:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYK1QfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:35:18 -0500
Date: Fri, 28 Nov 2008 17:34:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling v3
Message-ID: <20081128163456.GB10487@elte.hu>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492E0540.9010009@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +void __init arch_early_irq_init(void)
>  {
> -	return irq < nr_irqs ? irq_cfgx + irq : NULL;
> +	struct irq_cfg *cfg;
> +	struct irq_desc *desc;
> +	int count;
> +	int i;
> +#ifdef CONFIG_SPARSE_IRQ
> +	int count_desc = NR_IRQS_LEGACY;
> +#else
> +	int count_desc = NR_IRQS;
> +#endif

could this be hidden in a .h file by creating some sort of nr_boot_irqs() 
inline, or a NR_BOOT_IRQS define?

> Index: linux-2.6/drivers/char/random.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/random.c
> +++ linux-2.6/drivers/char/random.c
> @@ -558,6 +558,8 @@ struct timer_rand_state {
>  	unsigned dont_count_entropy:1;
>  };
>  
> +#ifndef CONFIG_SPARSE_IRQ
> +
>  static struct timer_rand_state *irq_timer_state[NR_IRQS];
>  
>  static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
> @@ -576,6 +578,33 @@ static void set_timer_rand_state(unsigne
>  	irq_timer_state[irq] = state;
>  }
>  
> +#else
> +
> +static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
> +{
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +
> +	if (!desc)
> +		return NULL;
> +
> +	return desc->timer_rand_state;
> +}
> +
> +static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
> +{
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +
> +	if (!desc)
> +		return;
> +
> +	desc->timer_rand_state = state;
> +}
> +#endif

i'd suggest to move this into a .h file.

> +++ linux-2.6/fs/proc/stat.c
> @@ -27,6 +27,9 @@ static int show_stat(struct seq_file *p,
>  	u64 sum = 0;
>  	struct timespec boottime;
>  	unsigned int per_irq_sum;
> +#ifdef CONFIG_GENERIC_HARDIRQS
> +	struct irq_desc *desc;
> +#endif

Why is this define needed? If it's about a build warning, you can add 
something like this to defines:

 (void)(param)

to make unused parameters used as well.

> +#ifdef CONFIG_SPARSE_IRQ
> +		seq_printf(p, " %d:%u", j, per_irq_sum);
> +#else
>  		seq_printf(p, " %u", per_irq_sum);
> -	}
> +#endif

doesnt this change the /proc ABI ? A couple of tools would break. I think 
the right approach is to go from 0 to NR_IRQS-1 and print zeroes for NULL 
descs. I.e. a natural extension of the current scheme.

> +++ linux-2.6/fs/proc/interrupts.c
> @@ -8,6 +8,23 @@
>  /*
>   * /proc/interrupts
>   */
> +#ifdef CONFIG_SPARSE_IRQ
> +static void *int_seq_start(struct seq_file *f, loff_t *pos)
> +{
> +	rcu_read_lock();
> +	return seq_list_start(&sparse_irqs_head, *pos);

is this rcu-safe approach still needed?

> ===================================================================
> --- linux-2.6.orig/include/linux/interrupt.h
> +++ linux-2.6/include/linux/interrupt.h
> @@ -18,6 +18,8 @@
>  #include <asm/ptrace.h>
>  #include <asm/system.h>
>  
> +extern int nr_irqs;

isnt this obsolete now?

> Index: linux-2.6/arch/x86/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irq.c
> +++ linux-2.6/arch/x86/kernel/irq.c
> @@ -99,25 +99,37 @@ static int show_other_interrupts(struct
>  int show_interrupts(struct seq_file *p, void *v)
>  {
>  	unsigned long flags, any_count = 0;
> -	int i = *(loff_t *) v, j;
> +	int i, j;
>  	struct irqaction *action;
>  	struct irq_desc *desc;
> +	int head = 0;
>  
> +#ifdef CONFIG_SPARSE_IRQ
> +	desc = list_entry(v, struct irq_desc, list);
> +	i = desc->irq;
> +	if (&desc->list == sparse_irqs_head.next)
> +		head = 1;
> +#else
> +	i = *(loff_t *) v;
>  	if (i > nr_irqs)
>  		return 0;
>  
>  	if (i == nr_irqs)
>  		return show_other_interrupts(p);
> +	if (i == 0)
> +		head = 1;
> +
> +	desc = irq_to_desc(i);
> +#endif

i dont think this has to change? We have an array of pointers, and we 
should extend the current loops by skipping over NULL entries.

	Ingo
