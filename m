Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZJOFb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZJOFb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZJOFb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:31:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZJOFbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:31:25 -0400
Message-ID: <4AD6B364.2050801@kernel.org>
Date: Wed, 14 Oct 2009 22:30:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] x86/apic: limit irq affinity
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com>
In-Reply-To: <20091015011339.GA17374@sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> This patch allows for hard restrictions to irq affinity via a new cpumask and
> device node value in the irq_cfg structure.
> 
> The mask forces IRQ affinity to remain within the specified cpu domain.
> On some UV systems, this domain will be limited to the nodes accessible
> to the given node.  Currently other X86 systems will have all bits in
> the cpumask set, so non-UV systems will remain unaffected at this time.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Removed UV specific code from generic IO APIC code.
> 
>  arch/x86/Kconfig                   |    1 
>  arch/x86/include/asm/hw_irq.h      |    3 
>  arch/x86/include/asm/uv/uv_irq.h   |    1 
>  arch/x86/include/asm/uv/uv_mmrs.h  |   25 +++++
>  arch/x86/kernel/apic/io_apic.c     |  144 ++++++++++++++++++++++++++-------
>  arch/x86/kernel/apic/x2apic_uv_x.c |    2 
>  arch/x86/kernel/uv_irq.c           |   77 +++++++++++++++++
>  7 files changed, 225 insertions(+), 28 deletions(-)
> 
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-10-14 12:48:50.000000000 -0500
> +++ linux/arch/x86/kernel/apic/io_apic.c	2009-10-14 15:04:23.000000000 -0500
> @@ -168,6 +168,19 @@ void __init io_apic_disable_legacy(void)
>  	nr_irqs_gsi = 0;
>  }
>  
> +void (*set_irq_cfg_allowed)(cpumask_var_t, int) = NULL;
> +/*
> + * Setup IRQ affinity restriction.
> + */
> +static void set_irq_cfg_cpus_allowed(struct irq_cfg *irq_cfg)
> +{
> +	if (set_irq_cfg_allowed)
> +		set_irq_cfg_allowed(irq_cfg->allowed, irq_cfg->node);
> +	else
> +		/* Default to allow anything */
> +		cpumask_setall(irq_cfg->allowed);
> +}
> +
>  int __init arch_early_irq_init(void)
>  {
>  	struct irq_cfg *cfg;
> @@ -183,8 +196,11 @@ int __init arch_early_irq_init(void)
>  	for (i = 0; i < count; i++) {
>  		desc = irq_to_desc(i);
>  		desc->chip_data = &cfg[i];
> +		cfg->node = node;
>  		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
>  		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
> +		zalloc_cpumask_var_node(&cfg[i].allowed, GFP_NOWAIT, node);
> +		set_irq_cfg_cpus_allowed(&cfg[i]);
>  		if (i < nr_legacy_irqs)
>  			cpumask_setall(cfg[i].domain);
>  	}
> @@ -213,12 +229,19 @@ static struct irq_cfg *get_one_free_irq_
>  	if (cfg) {
>  		if (!zalloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
>  			kfree(cfg);
> -			cfg = NULL;
> -		} else if (!zalloc_cpumask_var_node(&cfg->old_domain,
> +			return NULL;
> +		}
> +		if (!zalloc_cpumask_var_node(&cfg->old_domain,
>  							  GFP_ATOMIC, node)) {
>  			free_cpumask_var(cfg->domain);
>  			kfree(cfg);
> -			cfg = NULL;
> +			return NULL;
> +		}
> +		if (!zalloc_cpumask_var_node(&cfg->allowed, GFP_ATOMIC, node)) {
> +			free_cpumask_var(cfg->old_domain);
> +			free_cpumask_var(cfg->domain);
> +			kfree(cfg);
> +			return NULL;
>  		}
>  	}
>  
> @@ -231,12 +254,14 @@ int arch_init_chip_data(struct irq_desc 
>  
>  	cfg = desc->chip_data;
>  	if (!cfg) {
> -		desc->chip_data = get_one_free_irq_cfg(node);
> +		cfg = desc->chip_data = get_one_free_irq_cfg(node);
>  		if (!desc->chip_data) {
>  			printk(KERN_ERR "can not alloc irq_cfg\n");
>  			BUG_ON(1);
>  		}
>  	}
> +	cfg->node = node;
> +	set_irq_cfg_cpus_allowed(cfg);
>  
>  	return 0;
>  }
> @@ -318,6 +343,10 @@ void arch_init_copy_chip_data(struct irq
>  
>  	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
>  
> +	cfg->node = node;
> +
> +	set_irq_cfg_cpus_allowed(cfg);
> +
>  	init_copy_irq_2_pin(old_cfg, cfg, node);
>  }
>  
> @@ -1428,16 +1457,23 @@ static void setup_IO_APIC_irq(int apic_i
>  	struct irq_cfg *cfg;
>  	struct IO_APIC_route_entry entry;
>  	unsigned int dest;
> +	cpumask_var_t tmp_mask;
>  
>  	if (!IO_APIC_IRQ(irq))
>  		return;
>  
>  	cfg = desc->chip_data;
>  
> -	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
> +	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
>  		return;
>  
> -	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
> +	if (!cpumask_and(tmp_mask, apic->target_cpus(), cfg->allowed))
> +		goto error;
> +
> +	if (assign_irq_vector(irq, cfg, tmp_mask))
> +		goto error;
> +
> +	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);

can you check if we can reuse target_cpus for this purpose?

YH
