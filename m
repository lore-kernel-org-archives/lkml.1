Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYGKBcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYGKBcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYGKBcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:32:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38028 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYGKBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:32:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182239.205057000@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 18:22:57 -0700
In-Reply-To: <20080710182239.205057000@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 11:16:57 -0700")
Message-ID: <m1fxqhdxji.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4996]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 23/26] x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> MSI and MSI-X support for interrupt remapping infrastructure.
>
> MSI address register will be programmed with interrupt-remapping table
> entry(IRTE) index and the IRTE will contain information about the vector,
> cpu destination, etc.
>
> For MSI-X, all the IRTE's will be consecutively allocated in the table,
> and the address registers will contain the starting index to the block
> and the data register will contain the subindex with in that block.
>
> This also introduces a new irq_chip for cleaner irq migration (in the process
> context as opposed to the current irq migration in the context of an interrupt.
> interrupt-remapping infrastructure will help us achieve this).
>
> As MSI is edge triggered, irq migration is a simple atomic update(of vector
> and cpu destination) of IRTE and flushing the hardware cache.

A couple of things.  I believe MSI edge triggered irqs can always be migrated
safely outside of irq context.

Flushing the hardware cache sounds like it will flush the irqs towards the cpu.
How do we flush the inflight irqs flushed to the apic.  Does a register read work?

For MSI irqs going directly to the cpu it should, as long as the cpu and local
apic count as the same device from the perspective of pci ordering rules.


> Index: tree-x86/arch/x86/kernel/io_apic_64.c
> ===================================================================
> --- tree-x86.orig/arch/x86/kernel/io_apic_64.c 2008-07-10 09:52:31.000000000
> -0700
> +++ tree-x86/arch/x86/kernel/io_apic_64.c 2008-07-10 09:52:34.000000000 -0700
> @@ -2289,6 +2289,9 @@
>  
>  	dynamic_irq_cleanup(irq);
>  
> +#ifdef CONFIG_INTR_REMAP
> +	free_irte(irq);
> +#endif
>  	spin_lock_irqsave(&vector_lock, flags);
>  	__clear_irq_vector(irq);
>  	spin_unlock_irqrestore(&vector_lock, flags);
> @@ -2307,11 +2310,42 @@
>  
>  	tmp = TARGET_CPUS;
>  	err = assign_irq_vector(irq, tmp);
> -	if (!err) {
> -		cpus_and(tmp, cfg->domain, tmp);
> -		dest = cpu_mask_to_apicid(tmp);
> +	if (err)
> +		return err;
> +
> +	cpus_and(tmp, cfg->domain, tmp);
> +	dest = cpu_mask_to_apicid(tmp);

Can we simplify this a little.  In particular have a function 

struct IOAPIC_ROUTE_entry x86_map_irq(irq, mask);

Where x86_map_irq would ultimately figure out the path to the cpu.
In the simple case it would just call assign_irq_vector();
When irqs are remapped it would perform the additional
map_irq_to_irte_handle();
modify_irte(irq, &irte);

And then have the generic msi code and the ioapic code.
Map from the struct IOAPIC_ROUTE_entry or whatever to the appropriate bits for the hardware
they control.

That should allows us a lot more flexibility going forward with less code then is in your
patches.

> +#ifdef CONFIG_INTR_REMAP
> +	if (irq_remapped(irq)) {
> +		struct irte irte;
> +		int ir_index;
> +		u16 sub_handle;
> +
> +		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
> +		BUG_ON(ir_index == -1);
> +
> +		memset (&irte, 0, sizeof(irte));
> +
> +		irte.present = 1;
> +		irte.dst_mode = INT_DEST_MODE;
> +		irte.trigger_mode = 0; /* edge */
> +		irte.dlvry_mode = INT_DELIVERY_MODE;
> +		irte.vector = cfg->vector;
> +		irte.dest_id = IRTE_DEST(dest);
> +
> +		modify_irte(irq, &irte);
>  
>  		msg->address_hi = MSI_ADDR_BASE_HI;
> +		msg->data = sub_handle;
> +		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
> +				  MSI_ADDR_IR_SHV |
> +				  MSI_ADDR_IR_INDEX1(ir_index) |
> +				  MSI_ADDR_IR_INDEX2(ir_index);
> +	} else
> +#endif
> +	{
> +		msg->address_hi = MSI_ADDR_BASE_HI;
>  		msg->address_lo =
>  			MSI_ADDR_BASE_LO |
>  			((INT_DEST_MODE == 0) ?
> @@ -2361,6 +2395,55 @@
>  	write_msi_msg(irq, &msg);
>  	irq_desc[irq].affinity = mask;
>  }
> +
> +#ifdef CONFIG_INTR_REMAP
> +/*
> + * Migrate the MSI irq to another cpumask. This migration is
> + * done in the process context using interrupt-remapping hardware.
> + */
> +static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
> +{
> +	struct irq_cfg *cfg = irq_cfg + irq;
> +	unsigned int dest;
> +	cpumask_t tmp, cleanup_mask;
> +	struct irte irte;
> +
> +	cpus_and(tmp, mask, cpu_online_map);
> +	if (cpus_empty(tmp))
> +		return;
> +
> +	if (get_irte(irq, &irte))
> +		return;
> +
> +	if (assign_irq_vector(irq, mask))
> +		return;
> +
> +	cpus_and(tmp, cfg->domain, mask);
> +	dest = cpu_mask_to_apicid(tmp);
> +
> +	irte.vector = cfg->vector;
> +	irte.dest_id = IRTE_DEST(dest);
> +
> +	/*
> +	 * atomically update the IRTE with the new destination and vector.
> +	 */
> +	modify_irte(irq, &irte);
> +
> +	/*
> +	 * After this point, all the interrupts will start arriving
> +	 * at the new destination. So, time to cleanup the previous
> +	 * vector allocation.
> +	 */
> +	if (cfg->move_in_progress) {
> +		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
> +		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
> +		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
> +		cfg->move_in_progress = 0;
> +	}
> +
> +	irq_desc[irq].affinity = mask;
> +}
> +#endif
>  #endif /* CONFIG_SMP */
>  
>  /*
> @@ -2378,26 +2461,157 @@
>  	.retrigger	= ioapic_retrigger_irq,
>  };
