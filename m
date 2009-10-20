Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZJTS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZJTS73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZJTS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:59:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZJTS72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:59:28 -0400
Message-ID: <4ADE085E.9050205@kernel.org>
Date: Tue, 20 Oct 2009 11:58:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3] x86/apic: limit irq affinity
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com> <4AD6B364.2050801@kernel.org> <20091015135039.GA24455@sgi.com> <20091020125649.GA25066@sgi.com> <20091020133810.GA26088@sgi.com>
In-Reply-To: <20091020133810.GA26088@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> This patch allows for hard restrictions to irq affinity on x86 systems.
> 
> Affinity is masked to allow only those cpus which the subarchitecture
> deems accessible by the given irq.
> 
> On some UV systems, this domain will be limited to the nodes accessible
> to the irq's node.  Initially other X86 systems will not mask off any cpus
> so non-UV systems will remain unaffected.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Removed allowed cpumask from irq_cfg.  Storing allowed cpumasks in UV
> specific IRQ code.
> 
>  arch/x86/Kconfig                   |    1 
>  arch/x86/include/asm/hw_irq.h      |    3 
>  arch/x86/include/asm/uv/uv_irq.h   |    1 
>  arch/x86/include/asm/uv/uv_mmrs.h  |   25 ++++++
>  arch/x86/kernel/apic/io_apic.c     |  123 ++++++++++++++++++++++++++-------
>  arch/x86/kernel/apic/x2apic_uv_x.c |    4 -
>  arch/x86/kernel/uv_irq.c           |   58 +++++++++++++++
>  7 files changed, 189 insertions(+), 26 deletions(-)
> 
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-10-19 15:22:52.000000000 -0500
> +++ linux/arch/x86/kernel/apic/io_apic.c	2009-10-19 20:57:29.000000000 -0500
> @@ -168,6 +168,17 @@ void __init io_apic_disable_legacy(void)
>  	nr_irqs_gsi = 0;
>  }
>  
> +static int default_irq_allowed_and(struct irq_cfg *cfg, struct cpumask *dstp,
> +						const struct cpumask *srcp)
> +{
> +	cpumask_copy(dstp, srcp);
> +
> +	return 1;
> +}
> +
> +int (*x86_irq_allowed_and)(struct irq_cfg *, struct cpumask *,
> +		const struct cpumask *) = default_irq_allowed_and;
> +
>  int __init arch_early_irq_init(void)
>  {
>  	struct irq_cfg *cfg;
> @@ -183,6 +194,7 @@ int __init arch_early_irq_init(void)
>  	for (i = 0; i < count; i++) {
>  		desc = irq_to_desc(i);
>  		desc->chip_data = &cfg[i];
> +		cfg->node = node;
>  		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
>  		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
>  		if (i < nr_legacy_irqs)
> @@ -231,12 +243,13 @@ int arch_init_chip_data(struct irq_desc 
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

how about desc->node ?

YH
