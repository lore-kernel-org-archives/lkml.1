Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYKEXjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYKEXjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYKEXi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:38:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:34283 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYKEXi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:38:58 -0500
Cc: linux-kernel Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Message-Id: <B48FBC1A-5974-4E68-B34A-39C223328EFF@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Fwd: [PATCH v2][for 2.6.28] powerpc/mpic: Add support for MPICs that only support a single CPU destination
Date: Wed, 5 Nov 2008 17:38:48 -0600
References: <1225252899-20752-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Can you pick this up for stable-2.6.27.

- k

Begin forwarded message:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: October 28, 2008 11:01:39 PM CDT
> Cc: linuxppc-dev@ozlabs.org, tglx@linutronix.de, Paul Mackerras <paulus@samba.org 
> >, davem@davemloft.net
> Subject: [PATCH v2][for 2.6.28] powerpc/mpic: Add support for MPICs  
> that only support a single CPU destination
>
> The Freescale implementation of MPIC only allows a single CPU  
> destination
> for non-IPI interrupts.  We add a flag to the mpic_init to distinquish
> these variants of MPIC.  We pull in the irq_choose_cpu from sparc64 to
> select a single CPU as the destination of the interrupt.
>
> This is to deal with the fact that the default smp affinity was
> changed by commit 18404756765c713a0be4eb1082920c04822ce588.
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>
> Changed requested by Ben to use irq_choose_cpu from sparc64 land.
>
> - k
>
> arch/powerpc/include/asm/mpic.h          |    2 +
> arch/powerpc/platforms/85xx/mpc85xx_ds.c |    3 +-
> arch/powerpc/platforms/86xx/pic.c        |    3 +-
> arch/powerpc/sysdev/mpic.c               |   59 +++++++++++++++++++++ 
> +++++++--
> 4 files changed, 61 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/ 
> asm/mpic.h
> index 34d9ac4..c2ccca5 100644
> --- a/arch/powerpc/include/asm/mpic.h
> +++ b/arch/powerpc/include/asm/mpic.h
> @@ -355,6 +355,8 @@ struct mpic
> #define MPIC_NO_BIAS			0x00000400
> /* Ignore NIRQS as reported by FRR */
> #define MPIC_BROKEN_FRR_NIRQS		0x00000800
> +/* Destination only supports a single CPU at a time */
> +#define MPIC_SINGLE_DEST_CPU		0x00001000
>
> /* MPIC HW modification ID */
> #define MPIC_REGSET_MASK		0xf0000000
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/ 
> platforms/85xx/mpc85xx_ds.c
> index 483b65c..613bf8c 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> @@ -78,7 +78,8 @@ void __init mpc85xx_ds_pic_init(void)
>
> 	mpic = mpic_alloc(np, r.start,
> 			  MPIC_PRIMARY | MPIC_WANTS_RESET |
> -			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
> +			  MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
> +			  MPIC_SINGLE_DEST_CPU,
> 			0, 256, " OpenPIC  ");
> 	BUG_ON(mpic == NULL);
> 	of_node_put(np);
> diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/ 
> platforms/86xx/pic.c
> index 8881c5d..668275d 100644
> --- a/arch/powerpc/platforms/86xx/pic.c
> +++ b/arch/powerpc/platforms/86xx/pic.c
> @@ -44,7 +44,8 @@ void __init mpc86xx_init_irq(void)
>
> 	mpic = mpic_alloc(np, res.start,
> 			MPIC_PRIMARY | MPIC_WANTS_RESET |
> -			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
> +			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
> +			MPIC_SINGLE_DEST_CPU,
> 			0, 256, " MPIC     ");
> 	of_node_put(np);
> 	BUG_ON(mpic == NULL);
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 8e3478c..f6299cc 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -563,6 +563,51 @@ static void __init mpic_scan_ht_pics(struct  
> mpic *mpic)
>
> #endif /* CONFIG_MPIC_U3_HT_IRQS */
>
> +#ifdef CONFIG_SMP
> +static int irq_choose_cpu(unsigned int virt_irq)
> +{
> +	cpumask_t mask = irq_desc[virt_irq].affinity;
> +	int cpuid;
> +
> +	if (cpus_equal(mask, CPU_MASK_ALL)) {
> +		static int irq_rover;
> +		static DEFINE_SPINLOCK(irq_rover_lock);
> +		unsigned long flags;
> +
> +		/* Round-robin distribution... */
> +	do_round_robin:
> +		spin_lock_irqsave(&irq_rover_lock, flags);
> +
> +		while (!cpu_online(irq_rover)) {
> +			if (++irq_rover >= NR_CPUS)
> +				irq_rover = 0;
> +		}
> +		cpuid = irq_rover;
> +		do {
> +			if (++irq_rover >= NR_CPUS)
> +				irq_rover = 0;
> +		} while (!cpu_online(irq_rover));
> +
> +		spin_unlock_irqrestore(&irq_rover_lock, flags);
> +	} else {
> +		cpumask_t tmp;
> +
> +		cpus_and(tmp, cpu_online_map, mask);
> +
> +		if (cpus_empty(tmp))
> +			goto do_round_robin;
> +
> +		cpuid = first_cpu(tmp);
> +	}
> +
> +	return cpuid;
> +}
> +#else
> +static int irq_choose_cpu(unsigned int virt_irq)
> +{
> +	return hard_smp_processor_id();
> +}
> +#endif
>
> #define mpic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
>
> @@ -777,12 +822,18 @@ void mpic_set_affinity(unsigned int irq,  
> cpumask_t cpumask)
> 	struct mpic *mpic = mpic_from_irq(irq);
> 	unsigned int src = mpic_irq_to_hw(irq);
>
> -	cpumask_t tmp;
> +	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
> +		int cpuid = irq_choose_cpu(irq);
>
> -	cpus_and(tmp, cpumask, cpu_online_map);
> +		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION), 1 << cpuid);
> +	} else {
> +		cpumask_t tmp;
>
> -	mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
> -		       mpic_physmask(cpus_addr(tmp)[0]));	
> +		cpus_and(tmp, cpumask, cpu_online_map);
> +
> +		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
> +			       mpic_physmask(cpus_addr(tmp)[0]));
> +	}
> }
>
> static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned  
> int type)
> -- 
> 1.5.5.1
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

