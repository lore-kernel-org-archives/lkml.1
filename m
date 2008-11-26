Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYKZHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYKZHs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKZHsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:48:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYKZHsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:48:47 -0500
Date: Wed, 26 Nov 2008 08:48:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling v2
Message-ID: <20081126074826.GI26036@elte.hu>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492B77C5.2050502@kernel.org>
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

> impact: new feature sparseirq

> v2: use pointer array instead of hash

ok, this looks pretty good!

A few details:

> +#ifdef CONFIG_SPARSE_IRQ
> +#define set_ioapic_affinity_irq set_ioapic_affinity_irq_desc
> +#else
> +static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
> +{
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +
> +	set_ioapic_affinity_irq_desc(desc, mask);
> +}
> +#endif

i think this distinction can now go away?.

>  #ifdef CONFIG_INTR_REMAP
> +#ifdef CONFIG_SPARSE_IRQ
> +static void ack_x2apic_level_desc(struct irq_desc **descp)
> +{
> +	ack_x2APIC_irq();
> +}
> +
> +static void ack_x2apic_edge_desc(struct irq_desc **descp)
> +{
> +	ack_x2APIC_irq();
> +}
> +
> +#define ack_x2apic_level ack_x2apic_level_desc
> +#define ack_x2apic_edge ack_x2apic_edge_desc
> +#else

is this needed now?

> +#ifdef CONFIG_SMP
> +	move_native_irq_desc(descp);
> +#endif

please hide this #ifdef in a header.

> +# ifdef CONFIG_SMP
> +			move_masked_irq_desc(descp);
> +# endif

ditto.

> +#ifdef CONFIG_SPARSE_IRQ
> +#define ack_apic_edge ack_apic_edge_desc
> +#define ack_apic_level ack_apic_level_desc
> +#else
> +static void ack_apic_edge(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	ack_apic_edge_desc(&desc);
> +}
> +static void ack_apic_level(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	ack_apic_level_desc(&desc);
> +}
> +#endif

distinction needed?

>  
> +#ifdef CONFIG_SPARSE_IRQ
> +#define mask_lapic_irq mask_lapic_irq_desc
> +#define unmask_lapic_irq unmask_lapic_irq_desc
> +#define ack_lapic_irq ack_lapic_irq_desc
> +#else
> +static void mask_lapic_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	mask_lapic_irq_desc(&desc);
> +}
> +static void unmask_lapic_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	unmask_lapic_irq_desc(&desc);
> +}
> +static void ack_lapic_irq(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	ack_lapic_irq_desc(&desc);
> +}
> +#endif

same.

> +#ifdef CONFIG_SPARSE_IRQ
> +	for (new = irq_want; new < NR_IRQS; new++)
> +#else
> +	for (new = irq_want; new > 0; new--)
> +#endif

this assymetry seems unnecessary too now i think.

> +#ifdef CONFIG_SPARSE_IRQ
> +	irq_want = nr_irqs;
> +#else
> +	irq_want = NR_IRQS - 1;
> +#endif

ditto. I think we dont want 'nr_irqs' anymore - just remain with 
NR_IRQS, right?

> +#ifdef CONFIG_SPARSE_IRQ
> +#define set_msi_irq_affinity set_msi_irq_affinity_desc
> +#else
> +static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
>  
> +	set_msi_irq_affinity_desc(desc, mask);
> +}
> +#endif

This ifdef seems unnecessary too.

Plus in a few more places.

Please look at _every_ #ifdef or #if in your patch in a .c file and 
ask the question: can we somehow in some way eliminate it and convert 
it to some nice inline somewhere or eliminate it via some other trick?

	Ingo
