Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0BXViK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:38:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37258 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab0BXViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:38:04 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-arch@vger.kernel.org
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>
	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>
	<m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>
	<4B7CAADD.2060000@kernel.org> <m1mxz6v4pm.fsf@fess.ebiederm.org>
	<4B83781B.20307@kernel.org> <4B837930.2050907@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 24 Feb 2010 13:36:49 -0800
Message-ID: <m1ljei5n9q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH -v2 2/2] genericirq: change ack/mask in irq_chip to take irq_desc instead of irq
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> will have
> void            (*ack)(struct irq_desc *desc);
> void            (*mask)(struct irq_desc *desc);
> void            (*mask_ack)(struct irq_desc *desc);
> void            (*unmask)(struct irq_desc *desc);
> void            (*eoi)(struct irq_desc *desc);
>
> so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

Overall this looks pretty decent.  This look pretty complete.
How many platforms did you manage to compile test this on?

I have found a couple of issues (see below).

A few times you change a bit more than is necessary which is a bit
spooky in a patch this far ranging.

Reading through this patch to review it took an uncomfortably long
time.


> -v2: change all member of irq_chip to use desc only.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

> Index: linux-2.6/arch/alpha/kernel/sys_rx164.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/sys_rx164.c
> +++ linux-2.6/arch/alpha/kernel/sys_rx164.c
>  static void
> -rx164_end_irq(unsigned int irq)
> +rx164_end_irq(struct irq_desc *desc)
>  {
> -	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
> -		rx164_enable_irq(irq);
> +	if (!(desc_.status & (IRQ_DISABLED|IRQ_INPROGRESS)))
> +		rx164_enable_irq(desc);
>  }

You have mispelled desc-> here.

> Index: linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-s3c2410/bast-irq.c
> +++ linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
> @@ -75,31 +75,31 @@ static unsigned char bast_pc104_irqmasks
>  
>  static void
> -bast_pc104_maskack(unsigned int irqno)
> +bast_pc104_maskack(struct irq_desc *desc)
>  {
> -	struct irq_desc *desc = irq_desc + IRQ_ISA;
> -
> -	bast_pc104_mask(irqno);
> -	desc->chip->ack(IRQ_ISA);
> +	bast_pc104_mask(desc);
> +	desc->chip->ack(desc);
>  }

This is not a trivial 1 to 1 conversion.  IRQ_ISA != irqno.
I don't know if the original code is broken here or
just very peculiar.

>  static struct irq_chip s3c_irq_cam = {
> Index: linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/plat-s3c64xx/irq-eint.c
> +++ linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c

> -static void s3c_irq_eint_maskack(unsigned int irq)
> +static void s3c_irq_eint_maskack(struct irq_desc *desc)
>  {
> +	unsigned int irq = desc->irq;
>  	/* compiler should in-line these */
> -	s3c_irq_eint_mask(irq);
> -	s3c_irq_eint_ack(irq);
> +	s3c_irq_eint_mask(irq, desc);
> +	s3c_irq_eint_ack(irq, desc);
>  }

It appears this function has the wrong conversion.

> Index: linux-2.6/arch/blackfin/mach-common/ints-priority.c
> ===================================================================
> --- linux-2.6.orig/arch/blackfin/mach-common/ints-priority.c
> +++ linux-2.6/arch/blackfin/mach-common/ints-priority.c
> @@ -925,7 +938,7 @@ static void bfin_demux_gpio_irq(unsigned
>  static struct irq_chip bfin_gpio_irqchip = {
>  	.name = "GPIO",
>  	.ack = bfin_gpio_ack_irq,
> -	.mask = bfin_gpio_mask_irq,
> +	.mask = bfin_gpio_mask_irq_desc,

You have not introduced bfin_gpio_mask_irq_desc ...

>  	.mask_ack = bfin_gpio_mask_ack_irq,
>  	.unmask = bfin_gpio_unmask_irq,
>  	.disable = bfin_gpio_mask_irq,

> Index: linux-2.6/arch/ia64/kernel/iosapic.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/iosapic.c
> +++ linux-2.6/arch/ia64/kernel/iosapic.c
> @@ -267,6 +267,10 @@ static void
>  nop (unsigned int irq)
>  {
>  	/* do nothing... */
> +static void
> +nop_desc(struct irq_desc *desc)
> +{
> +	/* do nothing... */
>  }

Two things here.  
- nop has no closing brace.
- You should just be able to convert nop here, and not
  need to introduce nop_desc.

>  #define iosapic_shutdown_level_irq	mask_irq
>  #define iosapic_enable_level_irq	unmask_irq
>  #define iosapic_disable_level_irq	mask_irq
> -#define iosapic_ack_level_irq		nop
> +#define iosapic_ack_level_irq		nop_desc

Making this change unnecessary.

>  #define iosapic_enable_edge_irq		unmask_irq
>  #define iosapic_disable_edge_irq	nop
> -#define iosapic_end_edge_irq		nop
> +#define iosapic_end_edge_irq		nop_desc

and this change unnecessary.

>  
>  static struct irq_chip irq_type_iosapic_edge = {
>  	.name =		"IO-SAPIC-edge",

> Index: linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
> ===================================================================
> --- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc-simr.c
> +++ linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
> @@ -40,6 +42,7 @@ static void intc_irq_unmask(unsigned int
>  
>  static int intc_irq_set_type(unsigned int irq, unsigned int type)
>  {
> +	unsigned int irq = desc->irq;

This function does not take a desc argument.

>  	if (irq >= MCFINT_VECBASE) {
>  		if (irq < MCFINT_VECBASE + 64)
>  			__raw_writeb(5, MCFINTC0_ICR0 + irq - MCFINT_VECBASE);

> Index: linux-2.6/arch/mips/alchemy/common/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/alchemy/common/irq.c
> +++ linux-2.6/arch/mips/alchemy/common/irq.c
> @@ -288,17 +288,19 @@ void restore_au1xxx_intctl(void)
>  #endif /* CONFIG_PM */
>  
>  
> -static void au1x_ic0_unmask(unsigned int irq_nr)
> +static void au1x_ic0_unmask(struct irq_desc *desc)
>  {
> -	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
> +	unsigned int irq = desc->irq;
> +	unsigned int bit = irq_ - AU1000_INTC0_INT_BASE;

You misspelled irq there.

>  	au_writel(1 << bit, IC0_MASKSET);
>  	au_writel(1 << bit, IC0_WAKESET);
>  	au_sync();
>  }
>  

> Index: linux-2.6/arch/mips/bcm63xx/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/bcm63xx/irq.c
> +++ linux-2.6/arch/mips/bcm63xx/irq.c
> @@ -75,8 +75,9 @@ asmlinkage void plat_irq_dispatch(void)
>   * internal IRQs operations: only mask/unmask on PERF irq mask
>   * register.
>   */
> -static inline void bcm63xx_internal_irq_mask(unsigned int irq)
> +static inline void bcm63xx_internal_irq_mask(struct irq_desc *desc)
>  {
> +	unsigned int irq = desc->irq;
>  	u32 mask;
>  
>  	irq -= IRQ_INTERNAL_BASE;
> @@ -84,9 +85,15 @@ static inline void bcm63xx_internal_irq_
>  	mask &= ~(1 << irq);
>  	bcm_perf_writel(mask, PERF_IRQMASK_REG);
>  }
> +static void
> +bcm63xx_internal_irq_mask_desc(struct irq_desc *desc)
> +{
> +	bcm63xx_internal_irq_mask(desc);
> +}

You have converted bcm63xx_internal_irq_mask making bcm63xx_internal_irq_mask_desc
unnecessary.

> @@ -213,8 +225,8 @@ static struct irq_chip bcm63xx_internal_
>  	.startup	= bcm63xx_internal_irq_startup,
>  	.shutdown	= bcm63xx_internal_irq_mask,
>  
> -	.mask		= bcm63xx_internal_irq_mask,
> -	.mask_ack	= bcm63xx_internal_irq_mask,
> +	.mask		= bcm63xx_internal_irq_mask_desc,
> +	.mask_ack	= bcm63xx_internal_irq_mask_desc,
>  	.unmask		= bcm63xx_internal_irq_unmask,
>  };

These changes are also unnecessary.

> Index: linux-2.6/arch/mips/sni/pcimt.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/sni/pcimt.c
> +++ linux-2.6/arch/mips/sni/pcimt.c

> -static void end_pcimt_irq(unsigned int irq)
> -{
> -	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
> -		enable_pcimt_irq(irq);
> +static void end_pcimt_irq(struct irq_desc *desc)
> +
> +	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
> +		enable_pcimt_irq(desc);
>  }

You have deleted the starting brace of the function....

> Index: linux-2.6/arch/powerpc/platforms/cell/axon_msi.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/cell/axon_msi.c
> +++ linux-2.6/arch/powerpc/platforms/cell/axon_msi.c
> @@ -308,10 +308,15 @@ static void axon_msi_teardown_msi_irqs(s
>  	}
>  }
>  
> +static void axon_unmask_msi_irq(struct irq_desc *desc)
> +{
> +	unmask_msi_irq(desc);
> +}
> +
>  static struct irq_chip msic_irq_chip = {
>  	.mask		= mask_msi_irq,
>  	.unmask		= unmask_msi_irq,
> -	.shutdown	= unmask_msi_irq,
> +	.shutdown	= axon_unmask_msi_irq,
>  	.name		= "AXON-MSI",
>  };

This pair of changes is unnecessary.


> Index: linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/sysdev/mpic_u3msi.c
> +++ linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
> @@ -23,20 +23,25 @@
>  /* A bit ugly, can we get this from the pci_dev somehow? */
>  static struct mpic *msi_mpic;
>  
> -static void mpic_u3msi_mask_irq(unsigned int irq)
> +static void mpic_u3msi_mask_irq(struct irq_desc *desc)
>  {
> -	mask_msi_irq(irq);
> -	mpic_mask_irq(irq);
> +	mask_msi_irq(desc);
> +	mpic_mask_irq(desc);
>  }
>  
> -static void mpic_u3msi_unmask_irq(unsigned int irq)
> +static void mpic_u3msi_shutdown_irq(struct irq_desc *desc)
>  {
> -	mpic_unmask_irq(irq);
> -	unmask_msi_irq(irq);
> +	mpic_u3msi_mask_irq(desc);
> +}
> +
> +static void mpic_u3msi_unmask_irq(struct irq_desc *desc)
> +{
> +	mpic_unmask_irq(desc);
> +	unmask_msi_irq(desc);
>  }
>  
>  static struct irq_chip mpic_u3msi_chip = {
> -	.shutdown	= mpic_u3msi_mask_irq,
> +	.shutdown	= mpic_u3msi_shutdown_irq,
>  	.mask		= mpic_u3msi_mask_irq,
>  	.unmask		= mpic_u3msi_unmask_irq,
>  	.eoi		= mpic_end_irq,

This change to add a new mpic_u3msi_shutdow_irq appears harmless, but
it is confusing and unnecessary.


> Index: linux-2.6/arch/sparc/kernel/pci_msi.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/pci_msi.c
> +++ linux-2.6/arch/sparc/kernel/pci_msi.c
> @@ -111,12 +111,21 @@ static void free_msi(struct pci_pbm_info
>  	clear_bit(msi_num, pbm->msi_bitmap);
>  }
>  
> +static void sparc64_enable_msi_irq(struct irq_desc *desc)
> +{
> +	unmask_msi_irq(desc);
> +}
> +static void sparc64_diable_msi_irq(struct irq_desc *desc)
> +{
> +	mask_msi_irq(desc);
> +}
> +
>  static struct irq_chip msi_irq = {
>  	.name		= "PCI-MSI",
>  	.mask		= mask_msi_irq,
>  	.unmask		= unmask_msi_irq,
> -	.enable		= unmask_msi_irq,
> -	.disable	= mask_msi_irq,
> +	.enable		= sparc64_enable_msi_irq,
> +	.disable	= sparc64_disable_msi_irq,
>  	/* XXX affinity XXX */
>  };

Ouch! this hunk is unnecessary.

> Index: linux-2.6/drivers/xen/events.c
> ===================================================================
> --- linux-2.6.orig/drivers/xen/events.c
> +++ linux-2.6/drivers/xen/events.c
> @@ -748,35 +748,46 @@ int resend_irq_on_evtchn(unsigned int ir
>  	return 1;
>  }
>  
> -static void enable_dynirq(unsigned int irq)
> +static void enable_dynirq(struct irq_desc *desc)
>  {
> -	int evtchn = evtchn_from_irq(irq);
> +	int evtchn = evtchn_from_irq(desc->irq);
>  
>  	if (VALID_EVTCHN(evtchn))
>  		unmask_evtchn(evtchn);
>  }
>  
> -static void disable_dynirq(unsigned int irq)
> +static void unmask_dynirq(struct irq_desc *desc)
>  {
> -	int evtchn = evtchn_from_irq(irq);
> +	enable_dynirq(desc);
> +}
> +

Introducing disable_dynirq, and  mask_dynirq for xen is unnecessary.

> +static void disable_dynirq(struct irq_desc *desc)
> +{
> +	int evtchn = evtchn_from_irq(desc->irq);
>  
>  	if (VALID_EVTCHN(evtchn))
>  		mask_evtchn(evtchn);
>  }
>  
> -static void ack_dynirq(unsigned int irq)
> +static void mask_dynirq(struct irq_desc *desc)
>  {
> -	int evtchn = evtchn_from_irq(irq);
> +	disable_dynirq(desc);
> +}
> +
> +static void ack_dynirq(struct irq_desc *desc)
> +{
> +	int evtchn = evtchn_from_irq(desc->irq);
>  
> -	move_native_irq(irq);
> +	move_native_irq(desc);
>  
>  	if (VALID_EVTCHN(evtchn))
>  		clear_evtchn(evtchn);
>  }
>  
> -static int retrigger_dynirq(unsigned int irq)
> +static int retrigger_dynirq(struct irq_desc *desc)
>  {
> -	int evtchn = evtchn_from_irq(irq);
> +	int evtchn = evtchn_from_irq(desc->irq);
>  	struct shared_info *sh = HYPERVISOR_shared_info;
>  	int ret = 0;
>  
> @@ -924,10 +935,11 @@ static struct irq_chip xen_dynamic_chip
>  	.name		= "xen-dyn",
>  
>  	.disable	= disable_dynirq,
> -	.mask		= disable_dynirq,
> -	.unmask		= enable_dynirq,
>  
> +	.mask		= mask_dynirq,
> +	.unmask		= unmask_dynirq,
>  	.ack		= ack_dynirq,
> +
>  	.set_affinity	= set_affinity_irq,
>  	.retrigger	= retrigger_dynirq,
>  };


> Index: linux-2.6/include/linux/htirq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/htirq.h
> +++ linux-2.6/include/linux/htirq.h
> @@ -7,16 +7,17 @@ struct ht_irq_msg {
>  };
>  
>  /* Helper functions.. */
> -void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
> -void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
> -void mask_ht_irq(unsigned int irq);
> -void unmask_ht_irq(unsigned int irq);
> +struct irq_desc;
> +void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
> +void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
> +void mask_ht_irq(struct irq_desc *);
> +void unmask_ht_irq(struct irq_desc *);
>  
>  /* The arch hook for getting things started */
>  int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
>  
>  /* For drivers of buggy hardware */
> -typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
> +typedef void (ht_irq_update_t)(struct pci_dev *dev, struct irq_desc *desc,
>  			       struct ht_irq_msg *msg);

The corresponding update to drivers/infiniband/hw/ipath/ipath_iba6110.c
is missing from your patch.

>  int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);

> Index: linux-2.6/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/chip.c
> +++ linux-2.6/kernel/irq/chip.c
> @@ -131,7 +131,7 @@ int set_irq_chip(unsigned int irq, struc
>  	unsigned long flags;
>  
>  	if (!desc) {
> -		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
> +		WARN(1, KERN_ERR "Trying to install chip for IRQ\n");
>  		return -EINVAL;

We still have an irq value here so this change is wrong.

> @@ -657,7 +651,7 @@ __set_irq_handler(unsigned int irq, irq_
>  
>  	if (!desc) {
>  		printk(KERN_ERR
> -		       "Trying to install type control for IRQ%d\n", irq);
> +		       "Trying to install type control for IRQ\n");

Again we still have an irq value here, so we should not remove it from
the printk.

