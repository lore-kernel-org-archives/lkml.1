Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYKIHui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYKIHui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 02:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYKIHu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 02:50:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:64825 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYKIHu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 02:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GXhYdh5eMm7uGl01Jmt1/Dqo/Px8BpdmtExPMCAgtmX6tDuRYGvABEdtgyFqXvIQsZ
         Vtdxa/3coTeMsdzXd5CsMLjGwbGX+UhEyZ+SBeiIPS9QnzFuzQ0ks6Vj9bp4ATbhwSbP
         TbbK8nyc8xOOjG+ZwJAUIw3eD4ZI5SsoQrdko=
Date: Sun, 9 Nov 2008 10:50:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Message-ID: <20081109075021.GB12238@localhost>
References: <20081027164135.GD19476@elte.hu> <4912B2FE.7030804@kernel.org> <20081106101715.GA4022@elte.hu> <4913B45C.1000009@kernel.org> <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49168BD3.5010204@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sat, Nov 08, 2008 at 11:05:55PM -0800]
| 
| impact: new feature sparseirq
| 
| for sparse_irq, irq_desc, and irq_cfg is not using list_head to chain up
| also not add per_cpu_dyn_array... no user now
| 
| add some kind of hash table as Ingo suggesting.
| remove dyna_array, and enable sparse_irq by default, use kzalloc_node to get it
| use desc->chip_data for x86 to store irq_cfg
| make irq_desc to go with affinity aka irq_desc moving etc
| only call move_irq_desc in irq_complete_move() --- but it seems not trigger that moving.
| 
| Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| 
| ---

Hi Yinghai,

from a glance view (didn't read the whole patch)

...
|  
| -static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
| +static struct irq_cfg *get_one_free_irq_cfg(int cpu)
|  {
| -	return irq_cfg(irq);
| +	struct irq_cfg *cfg;
| +	int node;
| +
| +	if (cpu < 0)
| +		cpu = smp_processor_id();
| +	node = cpu_to_node(cpu);
| +
| +	cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
| +	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
| +
| +	return cfg;
|  }
|  
| -/*
| - * Rough estimation of how many shared IRQs there are, can be changed
| - * anytime.
| - */
| -#define MAX_PLUS_SHARED_IRQS NR_IRQS
| -#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
| +static void free_irq_cfg(struct irq_cfg *cfg)
| +{
| +	kfree(cfg);
| +}
| +
| +void arch_init_chip_data(struct irq_desc *desc, int cpu)
| +{
| +	struct irq_cfg *cfg;
| +
| +	cfg = desc->chip_data;
| +	if (!cfg)
| +		desc->chip_data = get_one_free_irq_cfg(cpu);
| +}
| +
| +static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
| +				 int cpu);
| +
| +void arch_init_copy_chip_data(struct irq_desc *old_desc,
| +				 struct irq_desc *desc, int cpu)
| +{
| +	struct irq_cfg *cfg;
| +	struct irq_cfg *old_cfg;
| +
| +	cfg = get_one_free_irq_cfg(cpu);
| +	desc->chip_data = cfg;
| +
| +	old_cfg = old_desc->chip_data;
| +
| +	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));

If cfg gets NULL here we will be NULL-dereferring
(cause of possible kzalloc_node fails).

| +
| +	init_copy_irq_2_pin(old_cfg, cfg, cpu);
| +}
| +
...

Am I missgin something?

		- Cyrill -
