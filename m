Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289Ab0CMAaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:30:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55245 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935274Ab0CMA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:29:51 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct irq_chip.
References: <1268387091.10129.5973.camel@zakaz.uk.xensource.com>
	<1268387116-30522-1-git-send-email-ian.campbell@citrix.com>
	<4B9A954A.40205@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Mar 2010 16:29:38 -0800
In-Reply-To: <4B9A954A.40205@kernel.org> (Yinghai Lu's message of "Fri\, 12 Mar 2010 11\:26\:02 -0800")
Message-ID: <m1ocit5aj1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yinghai@kernel.org, linuxppc-dev@ozlabs.org, x86@kernel.org, paulus@samba.org, benh@kernel.crashing.org, jeremy@goop.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, ian.campbell@citrix.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 03/12/2010 01:45 AM, Ian Campbell wrote:
>> Move arch_init_copy_chip_data and arch_free_chip_data into function
>> pointers in struct irq_chip since they operate on irq_desc->chip_data.
>> 
>> arch_init_chip_data cannot be moved into struct irq_chip at this time
>> because irq_desc->chip is not known at the time the irq_desc is
>> setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
>> PowerPC, the only other user, whose usage better matches the new name)
>> and on x86 convert arch_init_chip_data to x86_init_chip_data and
>> call this whenever a new struct irq_desc is allocated.
>> 
>> I've retained the chip_data behaviour for uv_irq although it isn't
>> clear to me if these interrupt types support migration or how closely
>> related to the APIC modes they really are. If it weren't for this the
>> x86_{init,copy,free}_chip_data functions could be static to
>> io_apic.c.
>> 
>> I've tested by booting on a 64 bit system, but it's not clear to me
>> what actions I need to take to actually exercise some of these code
>> paths.
>> 
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Acked-by: Michael Ellerman <michael@ellerman.id.au> [PowerPC rename portion]
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: x86@kernel.org
>> Cc: linuxppc-dev@ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/powerpc/kernel/irq.c      |    2 +-
>>  arch/x86/include/asm/hw_irq.h  |   11 +++++++-
>>  arch/x86/kernel/apic/io_apic.c |   58 +++++++++++++++++++++++++++++++++++++---
>>  arch/x86/kernel/uv_irq.c       |    5 +++
>>  include/linux/interrupt.h      |    2 +-
>>  include/linux/irq.h            |   12 +++++---
>>  kernel/irq/handle.c            |    2 +-
>>  kernel/irq/numa_migrate.c      |   12 +++++++-
>>  kernel/softirq.c               |    3 +-
>>  9 files changed, 91 insertions(+), 16 deletions(-)
>> 
>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
>> index 64f6f20..002d87f 100644
>> --- a/arch/powerpc/kernel/irq.c
>> +++ b/arch/powerpc/kernel/irq.c
>> @@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
>>  	return 0;
>>  }
>>  
>> -int arch_init_chip_data(struct irq_desc *desc, int node)
>> +int arch_init_irq_desc(struct irq_desc *desc, int node)
>>  {
>>  	desc->status |= IRQ_NOREQUEST;
>>  	return 0;
>> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
>> index a929c9e..1bc7063 100644
>> --- a/arch/x86/include/asm/hw_irq.h
>> +++ b/arch/x86/include/asm/hw_irq.h
>> @@ -20,9 +20,9 @@
>>  #include <linux/percpu.h>
>>  #include <linux/profile.h>
>>  #include <linux/smp.h>
>> +#include <linux/irq.h>
>>  
>>  #include <asm/atomic.h>
>> -#include <asm/irq.h>
>>  #include <asm/sections.h>
>>  
>>  /* Interrupt handlers registered during init_IRQ */
>> @@ -61,6 +61,15 @@ extern void init_VISWS_APIC_irqs(void);
>>  extern void setup_IO_APIC(void);
>>  extern void disable_IO_APIC(void);
>>  
>> +extern int x86_init_chip_data(struct irq_desc *desc, int node);
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +extern void x86_copy_chip_data(struct irq_desc *old_desc,
>> +				  struct irq_desc *desc, int node);
>> +extern void x86_free_chip_data(struct irq_desc *old_desc,
>> +				  struct irq_desc *desc);
>> +#endif
>> +
>>  struct io_apic_irq_attr {
>>  	int ioapic;
>>  	int ioapic_pin;
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index e4e0ddc..12e5cf4 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -211,7 +211,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int node)
>>  	return cfg;
>>  }
>>  
>> -int arch_init_chip_data(struct irq_desc *desc, int node)
>> +int x86_init_chip_data(struct irq_desc *desc, int node)
>>  {
>>  	struct irq_cfg *cfg;
>>  
>> @@ -287,8 +287,8 @@ static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
>>  	old_cfg->irq_2_pin = NULL;
>>  }
>>  
>> -void arch_init_copy_chip_data(struct irq_desc *old_desc,
>> -				 struct irq_desc *desc, int node)
>> +void x86_copy_chip_data(struct irq_desc *old_desc,
>> +			   struct irq_desc *desc, int node)
>>  {
>>  	struct irq_cfg *cfg;
>>  	struct irq_cfg *old_cfg;
>> @@ -312,7 +312,7 @@ static void free_irq_cfg(struct irq_cfg *old_cfg)
>>  	kfree(old_cfg);
>>  }
>>  
>> -void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
>> +void x86_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
>>  {
>>  	struct irq_cfg *old_cfg, *cfg;
>>  
>> @@ -336,6 +336,11 @@ struct irq_cfg *irq_cfg(unsigned int irq)
>>  	return irq < nr_irqs ? irq_cfgx + irq : NULL;
>>  }
>>  
>> +int x86_init_chip_data(struct irq_desc *desc, int node)
>> +{
>> +	return 0;
>> +}
>> +
>
> you could put one dummy x86_copy_chip_data and x86_free_chip_data here too.
>
>>  #endif
>>  
>>  struct io_apic {
>> @@ -1520,6 +1525,7 @@ static void __init setup_IO_APIC_irqs(void)
>>  			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
>>  			continue;
>>  		}
>> +		x86_init_chip_data(desc, node);
>>  		cfg = desc->chip_data;
>>  		add_pin_to_irq_node(cfg, node, apic_id, pin);
>>  		/*
>> @@ -1570,6 +1576,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
>>  		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
>>  		return;
>>  	}
>> +	x86_init_chip_data(desc, node);
>>  
>>  	cfg = desc->chip_data;
>>  	add_pin_to_irq_node(cfg, node, apic_id, pin);
>> @@ -2739,6 +2746,11 @@ static struct irq_chip ioapic_chip __read_mostly = {
>>  	.set_affinity	= set_ioapic_affinity_irq,
>>  #endif
>>  	.retrigger	= ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  static struct irq_chip ir_ioapic_chip __read_mostly = {
>> @@ -2754,6 +2766,11 @@ static struct irq_chip ir_ioapic_chip __read_mostly = {
>>  #endif
>>  #endif
>>  	.retrigger	= ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  static inline void init_IO_APIC_traps(void)
>> @@ -3261,6 +3278,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
>>  			printk(KERN_INFO "can not get irq_desc for %d\n", new);
>>  			continue;
>>  		}
>> +		x86_init_chip_data(desc_new, node);
>>  		cfg_new = desc_new->chip_data;
>>  
>>  		if (cfg_new->vector != 0)
>> @@ -3466,6 +3484,11 @@ static struct irq_chip msi_chip = {
>>  	.set_affinity	= set_msi_irq_affinity,
>>  #endif
>>  	.retrigger	= ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  static struct irq_chip msi_ir_chip = {
>> @@ -3479,6 +3502,11 @@ static struct irq_chip msi_ir_chip = {
>>  #endif
>>  #endif
>>  	.retrigger	= ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  /*
>> @@ -3638,6 +3666,11 @@ static struct irq_chip dmar_msi_type = {
>>  	.set_affinity = dmar_msi_set_affinity,
>>  #endif
>>  	.retrigger = ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  int arch_setup_dmar_msi(unsigned int irq)
>> @@ -3695,6 +3728,11 @@ static struct irq_chip ir_hpet_msi_type = {
>>  #endif
>>  #endif
>>  	.retrigger = ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  static struct irq_chip hpet_msi_type = {
>> @@ -3706,6 +3744,11 @@ static struct irq_chip hpet_msi_type = {
>>  	.set_affinity = hpet_msi_set_affinity,
>>  #endif
>>  	.retrigger = ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
>> @@ -3792,6 +3835,11 @@ static struct irq_chip ht_irq_chip = {
>>  	.set_affinity	= set_ht_irq_affinity,
>>  #endif
>>  	.retrigger	= ioapic_retrigger_irq,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
>> @@ -3919,6 +3967,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
>>  		printk(KERN_INFO "can not get irq_desc %d\n", irq);
>>  		return 0;
>>  	}
>> +	x86_init_chip_data(desc, node);
>>  
>>  	pin = irq_attr->ioapic_pin;
>>  	trigger = irq_attr->trigger;
>> @@ -4313,6 +4362,7 @@ void __init pre_init_apic_IRQ0(void)
>>  	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
>>  #endif
>>  	desc = irq_to_desc_alloc_node(0, 0);
>> +	x86_init_chip_data(desc, 0);
>>  
>>  	setup_local_APIC();
>>  
>> diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
>> index ece73d8..df2c6d6 100644
>> --- a/arch/x86/kernel/uv_irq.c
>> +++ b/arch/x86/kernel/uv_irq.c
>> @@ -55,6 +55,11 @@ struct irq_chip uv_irq_chip = {
>>  	.eoi		= uv_ack_apic,
>>  	.end		= uv_noop,
>>  	.set_affinity	= uv_set_irq_affinity,
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	.copy_chip_data = x86_copy_chip_data,
>> +	.free_chip_data = x86_free_chip_data,
>> +#endif
>>  };
>>  
>>  /*
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 75f3f00..cc4cd22 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -611,6 +611,6 @@ struct irq_desc;
>>  extern int early_irq_init(void);
>>  extern int arch_probe_nr_irqs(void);
>>  extern int arch_early_irq_init(void);
>> -extern int arch_init_chip_data(struct irq_desc *desc, int node);
>> +extern int arch_init_irq_desc(struct irq_desc *desc, int node);
>>  
>>  #endif
>> diff --git a/include/linux/irq.h b/include/linux/irq.h
>> index 707ab12..558bd2d 100644
>> --- a/include/linux/irq.h
>> +++ b/include/linux/irq.h
>> @@ -131,6 +131,14 @@ struct irq_chip {
>>  	void		(*bus_lock)(unsigned int irq);
>>  	void		(*bus_sync_unlock)(unsigned int irq);
>>  
>> +	/* for move_irq_desc */
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	void 		(*copy_chip_data)(struct irq_desc *old_desc,
>> +					  struct irq_desc *desc, int node);
>> +	void		(*free_chip_data)(struct irq_desc *old_desc,
>> +					  struct irq_desc *desc);
>> +#endif
>> +
>>  	/* Currently used only by UML, might disappear one day.*/
>>  #ifdef CONFIG_IRQ_RELEASE_METHOD
>>  	void		(*release)(unsigned int irq, void *dev_id);
>> @@ -208,10 +216,6 @@ struct irq_desc {
>>  	const char		*name;
>>  } ____cacheline_internodealigned_in_smp;
>>  
>> -extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
>> -					struct irq_desc *desc, int node);
>> -extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
>> -
>>  #ifndef CONFIG_SPARSE_IRQ
>>  extern struct irq_desc irq_desc[NR_IRQS];
>>  #endif
>> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
>> index 76d5a67..168e2f8 100644
>> --- a/kernel/irq/handle.c
>> +++ b/kernel/irq/handle.c
>> @@ -120,7 +120,6 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
>>  		BUG_ON(1);
>>  	}
>>  	init_desc_masks(desc);
>> -	arch_init_chip_data(desc, node);
>>  }
>>  
>>  /*
>> @@ -228,6 +227,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
>>  		BUG_ON(1);
>>  	}
>>  	init_one_irq_desc(irq, desc, node);
>> +	arch_init_irq_desc(desc, node);
>
> you move out init_chip_data for x86 out of irq_to_desc_alloc_node
> current init_chip_data in irq_to_desc_alloc_node is protected by sparse_irq_lock.
>
>
> wonder if you could let arch_init_irq_desc for x86 to call x86_init_chip_data?
>
> or let add another irq_to_desc_alloc_node_f to take extra func call.
>
> like 
> typedef int (*init_chip_data_f)(struct irq_desc *desc, int node);
> struct irq_desc * __ref irq_to_desc_alloc_node_f(unsigned int irq, int node, init_chip_data_f *f);
>
> struct irq_desc * __ref irq_to_desc_alloc_node_f(unsigned int irq, int node)
> {
>  irq_to_desc_alloc_node(irq, node, NULL);
> }
>
> then for x86
>
> int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_f *f)
> {
> 	if (!f)
> 		return x86_init_chip_data(desc, node);
>  	f(desc, node);
> }
>
> after that xen could use
> irq_to_desc_alloc_node_f(irq, node, xen_init_chip_data);
>
> as need...
>
> at last we don't need to call x86_init_chip_data everywhere.

Either that or we could have an arch specific wrapper say
"x86_irq_to_desc_alloc_node" that simply wraps irq_to_desc_alloc_node,
with the little extras we need.  This assumes that none of the
initialization has to happen inside of the lock an arch specific
wrapper makes sense.

Let's evaluate this set of patches on it's merits.  What this patchset
allows is a Xen implementation whose irq functions are fully decoupled
from the rest of x86 that supports SPARSE_IRQ.    That is a huge
maintenance improvement that far outweighs the worst damage this
patch can do to maintenance.

So trying to evaluate races.  The worse case for this particular piece
of code appears to be create_irq_nr.  As this is the only place where
we are setting up irqs and possibly repurposing the structure.  Today
we figure out if an irq has been assigned by looking at irq_cfg->vector,
and if it is non-zero the irq has been assigned.

The logic in x86_init_chip_data is correct we only assign desc->chip_data
if the generic layers are above it.  However we need a lock to ensure that
two paths don't race in that comparison and that assignment.  There is
no lock in x86_init_chip_data.  Which unfortunately means as it stands
this patchset is buggy.

Eric

