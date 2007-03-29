Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXC2RAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXC2RAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030472AbXC2RAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:00:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34987 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030459AbXC2RAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:00:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mitch Williams <mitch.a.williams@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
References: <1175186462.21369.4.camel@strongmad>
Date: Thu, 29 Mar 2007 10:59:45 -0600
In-Reply-To: <1175186462.21369.4.camel@strongmad> (Mitch Williams's message of
	"Thu, 29 Mar 2007 09:41:02 -0700")
Message-ID: <m1hcs4j88u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Williams <mitch.a.williams@intel.com> writes:

> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
>
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
>
> This patch performs a read flush after writes to the MSI-X table for
> mask/unmask and rebalancing operations.
>
> This patch has been validated with (unreleased) network hardware which
> uses MSI-X.
>
> Revised with input from Eric Biederman.

Do we still need the flush the set affinity routines?
Shouldn't flush in mask and unmask should now be enough?


>
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
>
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/arch/i386/kernel/io_apic.c
> linux-2.6.21-rc5/arch/i386/kernel/io_apic.c
> --- linux-2.6.21-rc5-clean/arch/i386/kernel/io_apic.c 2007-03-28
> 10:05:22.000000000 -0700
> +++ linux-2.6.21-rc5/arch/i386/kernel/io_apic.c 2007-03-28 10:19:14.000000000
> -0700
> @@ -2584,6 +2584,7 @@ static void set_msi_irq_affinity(unsigne
>  	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
>  
>  	write_msi_msg(irq, &msg);
> +	msix_flush_writes(irq);
>  	irq_desc[irq].affinity = mask;
>  }
>  #endif /* CONFIG_SMP */
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/arch/ia64/kernel/msi_ia64.c
> linux-2.6.21-rc5/arch/ia64/kernel/msi_ia64.c
> --- linux-2.6.21-rc5-clean/arch/ia64/kernel/msi_ia64.c 2007-03-28
> 10:05:22.000000000 -0700
> +++ linux-2.6.21-rc5/arch/ia64/kernel/msi_ia64.c 2007-03-28 09:34:27.000000000
> -0700
> @@ -60,6 +60,7 @@ static void ia64_set_msi_irq_affinity(un
>  	msg.address_lo = addr;
>  
>  	write_msi_msg(irq, &msg);
> +	msix_flush_writes(irq);
>  	irq_desc[irq].affinity = cpu_mask;
>  }
>  #endif /* CONFIG_SMP */
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/arch/ia64/sn/kernel/msi_sn.c
> linux-2.6.21-rc5/arch/ia64/sn/kernel/msi_sn.c
> --- linux-2.6.21-rc5-clean/arch/ia64/sn/kernel/msi_sn.c 2007-03-28
> 10:05:22.000000000 -0700
> +++ linux-2.6.21-rc5/arch/ia64/sn/kernel/msi_sn.c 2007-03-28 09:34:06.000000000
> -0700
> @@ -204,6 +204,7 @@ static void sn_set_msi_irq_affinity(unsi
>  	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
>  
>  	write_msi_msg(irq, &msg);
> +	msix_flush_writes(irq);
>  	irq_desc[irq].affinity = cpu_mask;
>  }
>  #endif /* CONFIG_SMP */
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/arch/x86_64/kernel/io_apic.c
> linux-2.6.21-rc5/arch/x86_64/kernel/io_apic.c
> --- linux-2.6.21-rc5-clean/arch/x86_64/kernel/io_apic.c 2007-03-28
> 10:05:22.000000000 -0700
> +++ linux-2.6.21-rc5/arch/x86_64/kernel/io_apic.c 2007-03-28 10:18:52.000000000
> -0700
> @@ -1956,6 +1956,7 @@ static void set_msi_irq_affinity(unsigne
>  	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
>  
>  	write_msi_msg(irq, &msg);
> +	msix_flush_writes(irq);
>  	irq_desc[irq].affinity = mask;
>  }
>  #endif /* CONFIG_SMP */
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/drivers/pci/msi.c
> linux-2.6.21-rc5/drivers/pci/msi.c
> --- linux-2.6.21-rc5-clean/drivers/pci/msi.c 2007-03-28 10:05:24.000000000 -0700
> +++ linux-2.6.21-rc5/drivers/pci/msi.c	2007-03-28 09:21:34.000000000 -0700
> @@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
>  	}
>  }
>  
> +void msix_flush_writes(unsigned int irq)
> +{
> +	struct msi_desc *entry;
> +
> +	entry = get_irq_msi(irq);
> +	BUG_ON(!entry || !entry->dev);
> +	switch (entry->msi_attrib.type) {
> +	case PCI_CAP_ID_MSI:
> +		/* nothing to do */
> +		break;
> +	case PCI_CAP_ID_MSIX:
> +	{
> +		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> +			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> +		readl(entry->mask_base + offset);
> +		break;
> +	}
> +	default:
> +		BUG();
> +		break;
> +	}
> +}
> +
>  static void msi_set_mask_bit(unsigned int irq, int flag)
>  {
>  	struct msi_desc *entry;
> @@ -186,11 +209,13 @@ void write_msi_msg(unsigned int irq, str
>  void mask_msi_irq(unsigned int irq)
>  {
>  	msi_set_mask_bit(irq, 1);
> +	msix_flush_writes(irq);
>  }
>  
>  void unmask_msi_irq(unsigned int irq)
>  {
>  	msi_set_mask_bit(irq, 0);
> +	msix_flush_writes(irq);
>  }
>  
>  static int msi_free_irq(struct pci_dev* dev, int irq);
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/include/linux/msi.h
> linux-2.6.21-rc5/include/linux/msi.h
> --- linux-2.6.21-rc5-clean/include/linux/msi.h 2007-03-28 10:05:25.000000000
> -0700
> +++ linux-2.6.21-rc5/include/linux/msi.h 2007-03-28 09:21:51.000000000 -0700
> @@ -12,6 +12,7 @@ extern void mask_msi_irq(unsigned int ir
>  extern void unmask_msi_irq(unsigned int irq);
>  extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
>  extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
> +extern void msix_flush_writes(unsigned int irq);
>  
>  struct msi_desc {
>  	struct {
