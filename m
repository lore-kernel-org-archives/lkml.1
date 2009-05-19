Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZESLv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZESLv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZESLvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:51:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZESLvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:51:17 -0400
Date: Tue, 19 May 2009 13:50:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dwmw2@infradead.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Message-ID: <20090519115055.GB14305@elte.hu>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com> <1242757912-6041-3-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242757912-6041-3-git-send-email-weidong.han@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Weidong Han <weidong.han@intel.com> wrote:

> To support domain-isolation usages, the platform hardware must be 
> capable of uniquely identifying the requestor (source-id) for each 
> interrupt message. Without source-id checking for interrupt 
> remapping , a rouge guest/VM with assigned devices can launch 
> interrupt attacks to bring down anothe guest/VM or the VMM itself.
> 
> This patch adds source-id checking for interrupt remapping, and 
> then really isolates interrupts for guests/VMs with assigned 
> devices.
> 
> Because PCI subsystem is not initialized yet when set up IOAPIC 
> entries, use read_pci_config_byte to access PCI config space 
> directly.
> 
> Signed-off-by: Weidong Han <weidong.han@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    6 +++
>  drivers/pci/intr_remapping.c   |   90 ++++++++++++++++++++++++++++++++++++++-
>  drivers/pci/intr_remapping.h   |    2 +
>  include/linux/dmar.h           |   11 +++++
>  4 files changed, 106 insertions(+), 3 deletions(-)

Code structure looks nice now. (and i susect you have tested this on 
real and relevant hardware?) I've Cc:-ed Eric too ... does this 
direction look good to you too Eric?

Have a few minor nits only:

> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 30da617..3d10c68 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1559,6 +1559,9 @@ int setup_ioapic_entry(int apic_id, int irq,
>  		irte.vector = vector;
>  		irte.dest_id = IRTE_DEST(destination);
>  
> +		/* Set source-id of interrupt request */
> +		set_ioapic_sid(&irte, apic_id);
> +
>  		modify_irte(irq, &irte);
>  
>  		ir_entry->index2 = (index >> 15) & 0x1;
> @@ -3329,6 +3332,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
>  		irte.vector = cfg->vector;
>  		irte.dest_id = IRTE_DEST(dest);
>  
> +		/* Set source-id of interrupt request */
> +		set_msi_sid(&irte, pdev);
> +
>  		modify_irte(irq, &irte);
>  
>  		msg->address_hi = MSI_ADDR_BASE_HI;
> diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
> index 946e170..9ef7b0d 100644
> --- a/drivers/pci/intr_remapping.c
> +++ b/drivers/pci/intr_remapping.c
> @@ -10,6 +10,8 @@
>  #include <linux/intel-iommu.h>
>  #include "intr_remapping.h"
>  #include <acpi/acpi.h>
> +#include <asm/pci-direct.h>
> +#include "pci.h"
>  
>  static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
>  static int ir_ioapic_num;
> @@ -405,6 +407,61 @@ int free_irte(int irq)
>  	return rc;
>  }
>  
> +int set_ioapic_sid(struct irte *irte, int apic)
> +{
> +	int i;
> +	u16 sid = 0;
> +
> +	if (!irte)
> +		return -1;
> +
> +	for (i = 0; i < MAX_IO_APICS; i++)
> +		if (ir_ioapic[i].id == apic) {
> +			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
> +			break;
> +		}

Please generally put extra curly braces around each multi-line loop 
body. One reason beyond readability is robustness: the above 
structure can be easily extended in a buggy way via [mockup patch 
hunk]:

> 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
> 			break;
> 		}
> +		if (!sid)
> +			break;

And note that if this slips in by accident how unobvious this bug is 
during patch review - the loop head context is not present in the 
3-line default context and the code "looks" correct at a glance.

With extra braces, such typos or mismerges:

> 		}
> 	}
> +		if (!sid)
> +			break;

stick out during review like a sore thumb :-)

> +	if (sid == 0) {
> +		printk(KERN_WARNING "Failed to set source-id of "
> +		       "I/O APIC (%d), because it is not under "
> +		       "any DRHD\n", apic);
> +		return -1;
> +	}

please try to keep kernel messages on a single line - even if 
checkpatch complains. Also, it's a good idea to use pr_warning(), 
it's shorter by 8 characters.

> +
> +	irte->svt = 1; /* requestor ID verification SID/SQ */
> +	irte->sq = 0;  /* comparing all 16-bit of SID */
> +	irte->sid = sid;

this is a borderline suggestion:

Note how you already lined up the _comments_ vertically, so you did 
notice that it makes sense to align vertically. The same visual 
arguments can be made for the initialization itself too:

> +
> +	irte->svt	= 1;	/* requestor ID verification SID/SQ */
> +	irte->sq	= 0;	/* comparing all 16-bit of SID */
> +	irte->sid	= sid;
> +
> +	return 0;

But ... it might make even more sense to introduce a set_irte() 
helper method, so it can all be written in a single line as:

	set_irte(irte, 1, 0, sid);

and explain common values in the set_irte() function's description - 
that way those comments above (and below) dont have to be made at 
the usage sites.

> +}
> +
> +int set_msi_sid(struct irte *irte, struct pci_dev *dev)
> +{
> +	struct pci_dev *tmp;
> +
> +	if (!irte || !dev)
> +		return -1;
> +
> +	tmp = pci_find_upstream_pcie_bridge(dev);

variable names like 'tmp' are only used if they are _really_ short 
in scope. Here a much better name would be 'bridge'.

> +	if (!tmp) { /* PCIE device or integrated PCI device */
> +		irte->svt = 1; /* verify requestor ID verification SID/SQ */
> +		irte->sq = 0;  /* comparing all 16-bit of SID */
> +		irte->sid = (dev->bus->number << 8) | dev->devfn;
> +		return 0;
> +	}
> +
> +	if (tmp->is_pcie) { /* this is a PCIE-to-PCI/PCIX bridge */
> +		irte->svt = 2; /* verify request ID verification SID */
> +		irte->sid = (tmp->bus->number << 8) | dev->bus->number;

is irte->sq left alone intentionally?

> +	} else { /* this is a legacy PCI bridge */
> +		irte->svt = 1; /* verify requestor ID verification SID/SQ */
> +		irte->sq = 0;  /* comparing all 16-bit of SID */
> +		irte->sid = (tmp->bus->number << 8) | tmp->devfn;
> +	}
> +	if (tmp->is_pcie) { /* this is a PCIE-to-PCI/PCIX bridge */
> +		irte->svt = 2; /* verify request ID verification SID */
> +		irte->sid = (tmp->bus->number << 8) | dev->bus->number;

here too?

> +	} else { /* this is a legacy PCI bridge */
> +		irte->svt = 1; /* verify requestor ID verification SID/SQ */
> +		irte->sq = 0;  /* comparing all 16-bit of SID */
> +		irte->sid = (tmp->bus->number << 8) | tmp->devfn;
> +	}
> +
> +	return 0;
> +}
> +
>  static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
>  {
>  	u64 addr;
> @@ -610,6 +667,35 @@ error:
>  	return -1;
>  }
>  
> +static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
> +				      struct intel_iommu *iommu)
> +{
> +	struct acpi_dmar_pci_path *path;
> +	u8 bus;
> +	int count;
> +
> +	bus = scope->bus;
> +	path = (struct acpi_dmar_pci_path *)(scope + 1);
> +	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
> +		/ sizeof(struct acpi_dmar_pci_path);
> +
> +	while (--count > 0) {
> +		/*
> +		 * Access PCI directly due to the PCI
> +		 * subsystem isn't initialized yet.
> +		 */
> +		bus = read_pci_config_byte(bus, path->dev, path->fn,
> +					   PCI_SECONDARY_BUS);
> +		path++;
> +	}
> +
> +	ir_ioapic[ir_ioapic_num].bus = bus;
> +	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->dev, path->fn);
> +	ir_ioapic[ir_ioapic_num].iommu = iommu;
> +	ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;

this too can be aligned vertically.

> +	ir_ioapic_num++;
> +}
> +
>  static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
>  				 struct intel_iommu *iommu)
>  {
> @@ -634,9 +720,7 @@ static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
>  			       " 0x%Lx\n", scope->enumeration_id,
>  			       drhd->address);
>  
> -			ir_ioapic[ir_ioapic_num].iommu = iommu;
> -			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
> -			ir_ioapic_num++;
> +			ir_parse_one_ioapic_scope(scope, iommu);

how much nicer this helper looks like now!

>  		}
>  		start += scope->length;
>  	}
> diff --git a/drivers/pci/intr_remapping.h b/drivers/pci/intr_remapping.h
> index ca48f0d..dd35780 100644
> --- a/drivers/pci/intr_remapping.h
> +++ b/drivers/pci/intr_remapping.h
> @@ -3,6 +3,8 @@
>  struct ioapic_scope {
>  	struct intel_iommu *iommu;
>  	unsigned int id;
> +	u8 bus;			/* PCI bus number */
> +	u8 devfn;		/* PCI devfn number */

hm, in kernel data structures we usually encode devfn as unsigned 
int - and sometimes even bus. Only 8 bits will be used of both so 
it's the same end result, but it results in more efficient 
instructions without byte shuffling.

	Ingo
