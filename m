Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYFCKie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYFCKie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYFCKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:38:23 -0400
Received: from www.tglx.de ([62.245.132.106]:35160 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbYFCKiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:38:20 -0400
Date: Tue, 3 Jun 2008 12:37:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/7] reroute PCI interrupt to legacy boot interrupt
 equivalent
In-Reply-To: <12124107074065-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031213360.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107074065-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> From: Stefan Assmann <sassmann@suse.de>
> 
> Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
> IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
> does during interrupt handling). On chipsets where this INTx generation
> cannot be disabled, we reroute the valid interrupts to their legacy
> equivalent to get rid of spurious interrupts that might otherwise bring
> down (vital) interrupt lines through spurious interrupt detection in
> note_interrupt().
> 
> The patch should eventually simply use another bitfield in the pci_dev
> structure for the rerouting variant. This was in another variant of the patch
> by Daniel Gollub. It is the cleanest and most simple approach.
> 
> This patch benefited from discussions with Alexander Graf, Torsten Duwe,
> Ihno Krumreich, Daniel Gollub, Hannes Reinecke. The conclusions we drew
> and the patch itself are the authors' responsibility alone.
> 
> Signed-off-by: Stefan Assmann <sassmann@suse.de>
> Signed-off-by: Olaf Dabrunz <od@suse.de>
> ---
>  drivers/acpi/pci_irq.c     |   63 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/quirks.c       |   51 ++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h        |    2 +
>  include/linux/pci_ids.h    |    4 +++
>  include/linux/pci_quirks.h |   28 +++++++++++++++++++
>  5 files changed, 147 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/pci_quirks.h
> 
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 89022a7..ebdfbfe 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -384,6 +384,34 @@ acpi_pci_free_irq(struct acpi_prt_entry *entry,
>  	return irq;
>  }
>  
> +#ifdef CONFIG_X86_IO_APIC
> +static int
> +bridge_has_boot_interrupt_variant(struct pci_bus *bus)

one line

> +{
> +	struct pci_bus *bus_it;
> +	int i;
> +
> +	for (bus_it = bus ; bus_it ; bus_it = bus_it->parent) {
> +		if (!bus_it->self)
> +			return 0;
> +
> +		printk(KERN_INFO "vendor=%04x device=%04x\n", bus_it->self->vendor,
> +				bus_it->self->device);
> +		for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
> +			if (quirk_bootirq_reroute_devs[i].vendor == 0)
> +				return 0;
> +
> +			if (quirk_bootirq_reroute_devs[i].vendor == bus_it->self->vendor &&
> +			    quirk_bootirq_reroute_devs[i].device == bus_it->self->device)
> +				return quirk_bootirq_reroute_devs[i].quirk_variant;
> +		}
> +	}
> +	return 0;
> +}
> +
> +extern int reroute_to_boot_interrupts;

declarations need to be in a header file.

> +#endif /* CONFIG_X86_IO_APIC */
> +
>  /*
>   * acpi_pci_irq_lookup
>   * success: return IRQ >= 0
> @@ -413,6 +441,41 @@ acpi_pci_irq_lookup(struct pci_bus *bus,
>  	}
>  
>  	ret = func(entry, triggering, polarity, link);
> +
> +#ifdef CONFIG_X86_IO_APIC
> +	/*
> +	 * Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
> +	 * IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
> +	 * does during interrupt handling). When this INTx generation cannot be
> +	 * disabled, we reroute these interrupts to their legacy equivalent to
> +	 * get rid of spurious interrupts.
> +	 */
> +        if (reroute_to_boot_interrupts) {
> +		switch (bridge_has_boot_interrupt_variant(bus)) {
> +		case 0:
> +			/* no rerouting necessary */
> +			break;
> +
> +		case VARIANT_INTEL_BUS_INT_REMAPPING:
> +			/*
> +			 * Remap according to INTx routing table in 6700PXH
> +			 * specs, intel order number 302628-002, section
> +			 * 2.15.2. Other chipsets (80332, ...) have the same
> +			 * mapping and are handled here as well.
> +			 */

  They generate INTA,B,C,D messages. What makes sure, that those are
  always routed to IRQ 16,17,18,19 ?

  IIRC we have seen those spurious interrupts on IRQ 9 and 12 as well.

> +			printk(KERN_INFO "pci irq %d -> rerouted to legacy "
> +					 "irq %d\n", ret, (ret % 4) + 16);
> +			ret = (ret % 4) + 16;
> +			break;
> +
> +		default:
> +			printk(KERN_INFO "not rerouting irq %d to legacy irq: "
> +					 "unknown mapping\n", ret);
> +			break;
> +		}
> +	}
> +#endif /* CONFIG_X86_IO_APIC */
> +
>  	return ret;
>  }
>  
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6245486..6173be5 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1375,8 +1375,57 @@ int nobootirqquirk_setup(char *str)
>  	return 1;
>  }
>  __setup("nobootirqquirk", nobootirqquirk_setup);
> -#endif /* CONFIG_X86_IO_APIC */
>  
> +/*
> + * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
> + * remap the original interrupt in the linux kernel to the boot interrupt, so
> + * that a PCI device's interrupt handler is installed on the boot interrupt
> + * line instead.
> + */
> +int reroute_to_boot_interrupts;
> +EXPORT_SYMBOL(reroute_to_boot_interrupts);
> +
> +struct quirk_bootirq_reroute_dev
> +	quirk_bootirq_reroute_devs[MAX_QUIRK_BOOTIRQ_REROUTE_DEVS];
> +EXPORT_SYMBOL(quirk_bootirq_reroute_devs);

Please use a consistent name space. This is about ioapic quirks so the
whole stuff should use ioapic_quirk_XXX or something like this.

Also why dont we put this information into the pci_dev structure
instead of having these tables and exports ?

> +static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	if (nobootirqquirk)
> +		return;

Default should be off. 

> +	for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
> +		if (quirk_bootirq_reroute_devs[i].vendor == 0)
> +			break;
> +
> +		if (quirk_bootirq_reroute_devs[i].vendor == dev->vendor &&
> +		    quirk_bootirq_reroute_devs[i].device == dev->device)
> +			return;		/* already on list */
> +	}
> +
> +	quirk_bootirq_reroute_devs[i].vendor = dev->vendor;
> +	quirk_bootirq_reroute_devs[i].device = dev->device;
> +
> +	quirk_bootirq_reroute_devs[i].quirk_variant =
> +					VARIANT_INTEL_BUS_INT_REMAPPING;
> +
> +	reroute_to_boot_interrupts = 1;
> +
> +	printk(KERN_INFO "PCI quirk: reroute interrupts for 0x%04x:0x%04x\n",
> +			dev->vendor, dev->device);
> +	return;
> +}

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d18b1dd..6c46cad 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1070,5 +1070,7 @@ static inline void pci_mmcfg_early_init(void) { }
>  static inline void pci_mmcfg_late_init(void) { }
>  #endif
>  
> +#include <linux/pci_quirks.h>
> +
>  #endif /* __KERNEL__ */
>  #endif /* LINUX_PCI_H */
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 9b940e6..c675399 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2233,6 +2233,10 @@
>  #define PCI_DEVICE_ID_INTEL_PXH_0	0x0329
>  #define PCI_DEVICE_ID_INTEL_PXH_1	0x032A
>  #define PCI_DEVICE_ID_INTEL_PXHV	0x032C
> +#define PCI_DEVICE_ID_INTEL_80332_0	0x0330
> +#define PCI_DEVICE_ID_INTEL_80332_1	0x0332
> +#define PCI_DEVICE_ID_INTEL_80333_0	0x0370
> +#define PCI_DEVICE_ID_INTEL_80333_1	0x0372
>  #define PCI_DEVICE_ID_INTEL_82375	0x0482
>  #define PCI_DEVICE_ID_INTEL_82424	0x0483
>  #define PCI_DEVICE_ID_INTEL_82378	0x0484

Please move the PCI ids out into a separate patch instead of adding
them gradually.

> diff --git a/include/linux/pci_quirks.h b/include/linux/pci_quirks.h
> new file mode 100644

Do we really need a separate header for this ?

> index 0000000..d875b87
> --- /dev/null
> +++ b/include/linux/pci_quirks.h
> @@ -0,0 +1,28 @@
> +/*
> + *	pci_quirks.h
> + *
> + *	PCI quirks defines
> + *	Copyright 2008, Olaf Dabrunz
> + */
> +
> +#ifndef LINUX_PCI_QUIRKS_H
> +#define LINUX_PCI_QUIRKS_H
> +
> +#ifdef CONFIG_X86_IO_APIC
> +#define MAX_QUIRK_BOOTIRQ_REROUTE_VARIANTS	32
> +#define VARIANT_INTEL_BUS_INT_REMAPPING		1

Aside of the horrible names, if there are multiple variants, please
use an enum.

> +
> +struct quirk_bootirq_reroute_dev {
> +	unsigned short	vendor;
> +	unsigned short	device;
> +	unsigned short	quirk_variant;
> +};
> +
> +/* max number of different quirky devices */
> +#define MAX_QUIRK_BOOTIRQ_REROUTE_DEVS		32
> +
> +extern struct quirk_bootirq_reroute_dev
> +	quirk_bootirq_reroute_devs[];
> +#endif /* CONFIG_X86_IO_APIC */
> +
> +#endif /* LINUX_PCI_QUIRKS_H */
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
