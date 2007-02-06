Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbXBFUZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbXBFUZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXBFUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:25:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:38366 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbXBFUZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:25:52 -0500
Subject: Re: [PATCH] (2.6.20-rt3) PowerPC: convert spinlocks into raw
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dwalker@mvista.com
In-Reply-To: <200702062026.40875.sshtylyov@ru.mvista.com>
References: <200702062026.40875.sshtylyov@ru.mvista.com>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 07:24:24 +1100
Message-Id: <1170793464.2620.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 20:26 +0300, Sergei Shtylyov wrote:
> Convert the spinlocks in the PowerPC interrupt related code into the raw ones,
> also convert the PURR and PMC related spinlocks...

Care to explain the difference ? This is related to the -rt stuff ?

Cheers,
Ben.

> Signed-off-by: Mark A. Greer <mgreer@mvista.com>
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> Index: linux-2.6/arch/powerpc/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/irq.c
> +++ linux-2.6/arch/powerpc/kernel/irq.c
> @@ -392,7 +392,7 @@ EXPORT_SYMBOL(do_softirq);
>  #ifdef CONFIG_PPC_MERGE
>  
>  static LIST_HEAD(irq_hosts);
> -static spinlock_t irq_big_lock = SPIN_LOCK_UNLOCKED;
> +static DEFINE_RAW_SPINLOCK(irq_big_lock);
>  static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
>  static unsigned int irq_radix_writer;
>  struct irq_map_entry irq_map[NR_IRQS];
> Index: linux-2.6/arch/powerpc/kernel/pmc.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/pmc.c
> +++ linux-2.6/arch/powerpc/kernel/pmc.c
> @@ -52,7 +52,7 @@ static void dummy_perf(struct pt_regs *r
>  }
>  #endif
>  
> -static DEFINE_SPINLOCK(pmc_owner_lock);
> +static DEFINE_RAW_SPINLOCK(pmc_owner_lock);
>  static void *pmc_owner_caller; /* mostly for debugging */
>  perf_irq_t perf_irq = dummy_perf;
>  
> Index: linux-2.6/arch/powerpc/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/time.c
> +++ linux-2.6/arch/powerpc/kernel/time.c
> @@ -223,7 +223,7 @@ struct cpu_purr_data {
>  	int	initialized;			/* thread is running */
>  	u64	tb;			/* last TB value read */
>  	u64	purr;			/* last PURR value read */
> -	spinlock_t lock;
> +	raw_spinlock_t lock;
>  };
>  
>  static DEFINE_PER_CPU(struct cpu_purr_data, cpu_purr_data);
> Index: linux-2.6/arch/powerpc/sysdev/i8259.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/sysdev/i8259.c
> +++ linux-2.6/arch/powerpc/sysdev/i8259.c
> @@ -23,7 +23,7 @@ static unsigned char cached_8259[2] = { 
>  #define cached_A1 (cached_8259[0])
>  #define cached_21 (cached_8259[1])
>  
> -static DEFINE_SPINLOCK(i8259_lock);
> +static DEFINE_RAW_SPINLOCK(i8259_lock);
>  
>  static struct device_node *i8259_node;
>  static struct irq_host *i8259_host;
> Index: linux-2.6/arch/powerpc/sysdev/ipic.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/sysdev/ipic.c
> +++ linux-2.6/arch/powerpc/sysdev/ipic.c
> @@ -30,7 +30,7 @@
>  #include "ipic.h"
>  
>  static struct ipic * primary_ipic;
> -static DEFINE_SPINLOCK(ipic_lock);
> +static DEFINE_RAW_SPINLOCK(ipic_lock);
>  
>  static struct ipic_info ipic_info[] = {
>  	[9] = {
> Index: linux-2.6/arch/powerpc/sysdev/mpic.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
> +++ linux-2.6/arch/powerpc/sysdev/mpic.c
> @@ -44,7 +44,7 @@
>  
>  static struct mpic *mpics;
>  static struct mpic *mpic_primary;
> -static DEFINE_SPINLOCK(mpic_lock);
> +static DEFINE_RAW_SPINLOCK(mpic_lock);
>  
>  #ifdef CONFIG_PPC32	/* XXX for now */
>  #ifdef CONFIG_IRQ_ALL_CPUS
> Index: linux-2.6/include/asm-powerpc/mpic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/mpic.h
> +++ linux-2.6/include/asm-powerpc/mpic.h
> @@ -279,7 +279,7 @@ struct mpic
>  #ifdef CONFIG_MPIC_BROKEN_U3
>  	/* The fixup table */
>  	struct mpic_irq_fixup	*fixups;
> -	spinlock_t		fixup_lock;
> +	raw_spinlock_t		fixup_lock;
>  #endif
>  
>  	/* Register access method */
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

