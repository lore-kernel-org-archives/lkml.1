Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0CDPL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:11:57 -0500
Received: from www.tglx.de ([62.245.132.106]:34768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab0CDPL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:11:56 -0500
Date: Thu, 4 Mar 2010 16:10:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] x86: make irq_chip to use desc_mask instead of
 maskn
In-Reply-To: <1267697339-5491-9-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1003041543260.2014@localhost.localdomain>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-9-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Yinghai Lu wrote:

> core irq_chip ...
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/i8259.h   |    2 +-
>  arch/x86/include/asm/irq.h     |    4 +-
>  arch/x86/kernel/apic/io_apic.c |  314 ++++++++++++++++------------------------
>  arch/x86/kernel/i8259.c        |   45 +++---
>  arch/x86/kernel/irq.c          |   19 ++-
>  5 files changed, 165 insertions(+), 219 deletions(-)
> 
> diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
> index 1655147..0b2ad6f 100644
> --- a/arch/x86/include/asm/i8259.h
> +++ b/arch/x86/include/asm/i8259.h
> @@ -58,7 +58,7 @@ struct legacy_pic {
>  	void (*mask_all)(void);
>  	void (*restore_mask)(void);
>  	void (*init)(int auto_eoi);
> -	int (*irq_pending)(unsigned int irq);
> +	int (*irq_pending)(struct irq_desc *desc);
>  	void (*make_irq)(unsigned int irq);
>  };
>  
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 64c5f6f..078e449 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -31,15 +31,15 @@ static inline int irq_canonicalize(int irq)
>  # endif
>  #endif
>  
> +struct irq_desc;
>  #ifdef CONFIG_HOTPLUG_CPU
>  #include <linux/cpumask.h>
>  extern void fixup_irqs(void);
> -extern void irq_force_complete_move(int);
> +void irq_force_complete_move(struct irq_desc *desc);
>  #endif
>  
>  extern void (*x86_platform_ipi_callback)(void);
>  extern void native_init_IRQ(void);
> -struct irq_desc;
>  extern bool handle_irq(struct irq_desc *desc, struct pt_regs *regs);
>  
>  extern unsigned int do_IRQ(struct pt_regs *regs);
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index ddcf4fa..44fc842 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -176,18 +176,6 @@ int __init arch_early_irq_init(void)
>  }
>  
>  #ifdef CONFIG_SPARSE_IRQ
> -struct irq_cfg *irq_cfg(unsigned int irq)
> -{
> -	struct irq_cfg *cfg = NULL;
> -	struct irq_desc *desc;
> -
> -	desc = irq_to_desc(irq);
> -	if (desc)
> -		cfg = desc->chip_data;
> -
> -	return cfg;
> -}
> -
>  static struct irq_cfg *get_one_free_irq_cfg(int node)
>  {
>  	struct irq_cfg *cfg;
> @@ -326,13 +314,6 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
>  	}
>  }
>  /* end for move_irq_desc */
> -
> -#else
> -struct irq_cfg *irq_cfg(unsigned int irq)
> -{
> -	return irq < nr_irqs ? irq_cfgx + irq : NULL;
> -}
> -
>  #endif
>  
>  struct io_apic {
> @@ -580,7 +561,7 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
>  	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
>  }
>  
> -static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
> +static void mask_IO_APIC_irq(struct irq_desc *desc)
>  {
>  	struct irq_cfg *cfg = desc->chip_data;
>  	unsigned long flags;
> @@ -592,7 +573,7 @@ static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
>  	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
>  }
>  
> -static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
> +static void unmask_IO_APIC_irq(struct irq_desc *desc)
>  {
>  	struct irq_cfg *cfg = desc->chip_data;
>  	unsigned long flags;
> @@ -602,19 +583,6 @@ static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
>  	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
>  }
>  
> -static void mask_IO_APIC_irq(unsigned int irq)
> -{
> -	struct irq_desc *desc = irq_to_desc(irq);
> -
> -	mask_IO_APIC_irq_desc(desc);
> -}
> -static void unmask_IO_APIC_irq(unsigned int irq)
> -{
> -	struct irq_desc *desc = irq_to_desc(irq);
> -
> -	unmask_IO_APIC_irq_desc(desc);
> -}
> -
>  static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
>  {
>  	struct IO_APIC_route_entry entry;
> @@ -1470,7 +1438,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
>  
>  	ioapic_register_intr(irq, desc, trigger);
>  	if (irq < legacy_pic->nr_legacy_irqs)
> -		legacy_pic->chip->mask(irq);
> +		desc_chip_mask(legacy_pic->chip, irq, desc);
>  
>  	ioapic_write_entry(apic_id, pin, entry);
>  }
> @@ -2267,29 +2235,29 @@ static int __init timer_irq_works(void)
>   * an edge even if it isn't on the 8259A...
>   */
>  
> -static unsigned int startup_ioapic_irq(unsigned int irq)
> +static unsigned int startup_ioapic_irq(struct irq_desc *desc)
>  {
>  	int was_pending = 0;
>  	unsigned long flags;
>  	struct irq_cfg *cfg;
>  
>  	raw_spin_lock_irqsave(&ioapic_lock, flags);
> -	if (irq < legacy_pic->nr_legacy_irqs) {
> -		legacy_pic->chip->mask(irq);
> -		if (legacy_pic->irq_pending(irq))
> +	if (desc->irq < legacy_pic->nr_legacy_irqs) {
> +		desc_chip_mask(legacy_pic->chip, -1, desc);
> +		if (legacy_pic->irq_pending(desc))
>  			was_pending = 1;
>  	}
> -	cfg = irq_cfg(irq);
> +	cfg = desc->chip_data;

  get_irq_desc_chip_data(desc); please

>  	__unmask_IO_APIC_irq(cfg);
>  	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
>  
>  	return was_pending;
>  }
>  
> -static int ioapic_retrigger_irq(unsigned int irq)
> +static int ioapic_retrigger_irq(struct irq_desc *desc)
>  {
>  
> -	struct irq_cfg *cfg = irq_cfg(irq);
> +	struct irq_cfg *cfg = desc->chip_data;

  Ditto

>  	unsigned long flags;


> -static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
> -{
> -      struct irq_desc *desc = *descp;

  Who merged that particular piece of horror ?
  
> -static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
> +static void __irq_complete_move(struct irq_desc *desc, unsigned vector)
>  {
> -	struct irq_desc *desc = *descp;
>  	struct irq_cfg *cfg = desc->chip_data;

  That should be fixed as well and probably at some other places.

>   * MSI message composition
>   */
>  #ifdef CONFIG_PCI_MSI
> -static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
> +static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
>  			   struct msi_msg *msg, u8 hpet_id)
>  {
> -	struct irq_desc *desc;
> +	unsigned int irq = desc->irq;

  Please separate out unrelated changes. This has nothing to do with
  the irq chip implementation.
 
>  
>  /*
> @@ -3540,8 +3482,9 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
>  {
>  	int ret;
>  	struct msi_msg msg;
> +	struct irq_desc *desc = irq_to_desc(irq);

  Ditto
>  
> -	ret = msi_compose_msg(dev, irq, &msg, -1);
> +	ret = msi_compose_msg(dev, desc, &msg, -1);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3549,7 +3492,6 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
>  	write_msi_msg(irq, &msg);
>  
>  	if (irq_remapped(irq)) {
> -		struct irq_desc *desc = irq_to_desc(irq);
>  		/*
>  		 * irq migration in process context
>  		 */
> @@ -3631,9 +3573,8 @@ void arch_teardown_msi_irq(unsigned int irq)
>  
>  int arch_setup_dmar_msi(unsigned int irq)
>  {
>  	int ret;
>  	struct msi_msg msg;
> +	struct irq_desc *desc = irq_to_desc(irq);

  Ditto
  
> -	ret = msi_compose_msg(NULL, irq, &msg, -1);
> +	ret = msi_compose_msg(NULL, desc, &msg, -1);
>  	if (ret < 0)
>  		return ret;
> -	dmar_msi_write(irq, &msg);
> +	dmar_msi_write_desc(desc, &msg);
>  	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
>  		"edge");
>  	return 0;
> @@ -3686,9 +3628,8 @@ int arch_setup_dmar_msi(unsigned int irq)
>  #ifdef CONFIG_HPET_TIMER

> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index f71625c..775cd75 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -27,7 +27,7 @@ void (*x86_platform_ipi_callback)(void) = NULL;
>  void ack_bad_irq(unsigned int irq)
>  {
>  	if (printk_ratelimit())
> -		pr_err("unexpected IRQ trap at vector %02x\n", irq);
> +		pr_err("unexpected IRQ trap at irq %02x\n", irq);

  Unrelated
  
Thanks,

	tglx
