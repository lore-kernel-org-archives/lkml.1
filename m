Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476Ab0ASVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0ASVAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032Ab0ASVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:00:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:42302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab0ASVAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:00:23 -0500
Message-ID: <4B561D37.9040007@kernel.org>
Date: Tue, 19 Jan 2010 12:59:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, irq: don't block IRQ0_VECTOR..IRQ15_VECTOR's on
 all cpu's
References: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 12:20 PM, Suresh Siddha wrote:
> Currently IRQ0..IRQ15 are assigned to IRQ0_VECTOR..IRQ15_VECTOR's on
> all the cpu's.
> 
> If these IRQ's are handled by legacy pic controller, then the kernel
> handles them only on cpu 0. So there is no need to block this vector
> space on all cpu's.
> 
> Similarly if these IRQ's are handled by IO-APIC, then the irq affinity
> will determine on which cpu's we need allocate the vector resource for that
> particular IRQ. This can be done dynamically and here also there is no need
> to block 16 vectors for IRQ0..IRQ15 on all cpu's.
> 
> Fix this by initially assigning IRQ0..IRQ15 to IRQ0_VECTOR..IRQ15_VECTOR's only
> on cpu 0. If the legacy controllers like pic handles these irq's, then
> this configuration will be fixed. If more modern controllers like IO-APIC
> handle these IRQ's, then we start with this configuration and as IRQ's
> migrate, vectors (/and cpu's) associated with these IRQ's change dynamically.
> 
> This will freeup the block of 16 vectors on other cpu's which don't handle
> IRQ0..IRQ15, which can now be used for other IRQ's that the particular cpu
> handle.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/irq.h     |    1 +
>  arch/x86/kernel/apic/io_apic.c |   33 ++++++++++-----------------------
>  arch/x86/kernel/irqinit.c      |   35 +++++++++++++++++------------------
>  arch/x86/kernel/vmiclock_32.c  |    2 ++
>  4 files changed, 30 insertions(+), 41 deletions(-)
> 
> Index: tip/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/io_apic.c
> +++ tip/arch/x86/kernel/apic/io_apic.c
> @@ -94,8 +94,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCE
>  /* # of MP IRQ source entries */
>  int mp_irq_entries;
>  
> -/* Number of legacy interrupts */
> -static int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
>  /* GSI interrupts */
>  static int nr_irqs_gsi = NR_IRQS_LEGACY;
>  
> @@ -140,27 +138,10 @@ static struct irq_pin_list *get_one_free
>  
>  /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
>  #ifdef CONFIG_SPARSE_IRQ
> -static struct irq_cfg irq_cfgx[] = {
> +static struct irq_cfg irq_cfgx[NR_LEGACY_IRQS];
>  #else
> -static struct irq_cfg irq_cfgx[NR_IRQS] = {
> +static struct irq_cfg irq_cfgx[NR_IRQS];
>  #endif
> -	[0]  = { .vector = IRQ0_VECTOR,  },
> -	[1]  = { .vector = IRQ1_VECTOR,  },
> -	[2]  = { .vector = IRQ2_VECTOR,  },
> -	[3]  = { .vector = IRQ3_VECTOR,  },
> -	[4]  = { .vector = IRQ4_VECTOR,  },
> -	[5]  = { .vector = IRQ5_VECTOR,  },
> -	[6]  = { .vector = IRQ6_VECTOR,  },
> -	[7]  = { .vector = IRQ7_VECTOR,  },
> -	[8]  = { .vector = IRQ8_VECTOR,  },
> -	[9]  = { .vector = IRQ9_VECTOR,  },
> -	[10] = { .vector = IRQ10_VECTOR, },
> -	[11] = { .vector = IRQ11_VECTOR, },
> -	[12] = { .vector = IRQ12_VECTOR, },
> -	[13] = { .vector = IRQ13_VECTOR, },
> -	[14] = { .vector = IRQ14_VECTOR, },
> -	[15] = { .vector = IRQ15_VECTOR, },
> -};
>  
>  void __init io_apic_disable_legacy(void)
>  {
> @@ -185,8 +166,14 @@ int __init arch_early_irq_init(void)
>  		desc->chip_data = &cfg[i];
>  		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
>  		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
> -		if (i < nr_legacy_irqs)
> -			cpumask_setall(cfg[i].domain);
> +		/*
> +		 * For legacy IRQ's, start with assigning irq0 to irq15 to
> +		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
> +		 */
> +		if (i < nr_legacy_irqs) {
> +			cfg[i].vector = IRQ0_VECTOR + i;
> +			cpumask_set_cpu(0, cfg[i].domain);
> +		}

when PIC is used, if the user is setting /proc/irq/[0-15]/smp_affinity to cpu other than 0,
we need to prevent that happen.

YH
