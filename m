Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYJVOgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYJVOgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYJVOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:35:43 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:20660 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYJVOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:35:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH 8/16 v6] PCI: add boot options to reassign resources
Date: Wed, 22 Oct 2008 08:35:34 -0600
User-Agent: KMail/1.9.9
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084303.GH3773@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081022084303.GH3773@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220835.35866.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 02:43:03 am Yu Zhao wrote:
> This patch adds boot options so user can reassign device resources
> of all devices under a bus.
> 
> The boot options can be used as:
> 	pci=assign-mmio=0000:01,assign-pio=0000:02
> '[dddd:]bb' is the domain and bus number.

I think this example is incorrect because you look for ";" to
separate options, not ",".

Bjorn

> Cc: Alex Chiang <achiang@hp.com>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> 
> ---
>  arch/x86/pci/common.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/i386.c   |   10 ++++---
>  arch/x86/pci/pci.h    |    3 ++
>  3 files changed, 82 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index b67732b..06e1ce0 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -137,6 +137,72 @@ static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
>  	}
>  }
>  
> +static char *pci_assign_pio;
> +static char *pci_assign_mmio;
> +
> +static int pcibios_bus_resource_needs_fixup(struct pci_bus *bus)
> +{
> +	int i;
> +	int type = 0;
> +	int domain, busnr;
> +
> +	if (!bus->self)
> +		return 0;
> +
> +	for (i = 0; i < 2; i++) {
> +		char *str = i ? pci_assign_pio : pci_assign_mmio;
> +
> +		while (str && *str) {
> +			if (sscanf(str, "%04x:%02x", &domain, &busnr) != 2) {
> +				if (sscanf(str, "%02x", &busnr) != 1)
> +					break;
> +				domain = 0;
> +			}
> +
> +			if (pci_domain_nr(bus) == domain &&
> +			    bus->number == busnr) {
> +				type |= i ? IORESOURCE_IO : IORESOURCE_MEM;
> +				break;
> +			}
> +
> +			str = strchr(str, ';');
> +			if (str)
> +				str++;
> +		}
> +	}
> +
> +	return type;
> +}
> +
> +static void __devinit pcibios_fixup_bus_resources(struct pci_bus *bus)
> +{
> +	int i;
> +	int type = pcibios_bus_resource_needs_fixup(bus);
> +
> +	if (!type)
> +		return;
> +
> +	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> +		struct resource *res = bus->resource[i];
> +
> +		if (!res)
> +			continue;
> +		if (res->flags & type)
> +			res->flags = 0;
> +	}
> +}
> +
> +int pcibios_resource_needs_fixup(struct pci_dev *dev, int resno)
> +{
> +	struct pci_bus *bus;
> +
> +	for (bus = dev->bus; bus && bus != pci_root_bus; bus = bus->parent)
> +		if (pcibios_bus_resource_needs_fixup(bus))
> +			return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   *  Called after each bus is probed, but before its children
>   *  are examined.
> @@ -147,6 +213,7 @@ void __devinit  pcibios_fixup_bus(struct pci_bus *b)
>  	struct pci_dev *dev;
>  
>  	pci_read_bridge_bases(b);
> +	pcibios_fixup_bus_resources(b);
>  	list_for_each_entry(dev, &b->devices, bus_list)
>  		pcibios_fixup_device_resources(dev);
>  }
> @@ -519,6 +586,12 @@ char * __devinit  pcibios_setup(char *str)
>  	} else if (!strcmp(str, "skip_isa_align")) {
>  		pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
>  		return NULL;
> +	} else if (!strncmp(str, "assign-pio=", 11)) {
> +		pci_assign_pio = str + 11;
> +		return NULL;
> +	} else if (!strncmp(str, "assign-mmio=", 12)) {
> +		pci_assign_mmio = str + 12;
> +		return NULL;
>  	}
>  	return str;
>  }
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 8729bde..ea82a5b 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -169,10 +169,12 @@ static void __init pcibios_allocate_resources(int pass)
>  					(unsigned long long) r->start,
>  					(unsigned long long) r->end,
>  					r->flags, enabled, pass);
> -			pr = pci_find_parent_resource(dev, r);
> -			if (pr && !request_resource(pr, r))
> -				continue;
> -			dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
> +			if (!pcibios_resource_needs_fixup(dev, idx)) {
> +				pr = pci_find_parent_resource(dev, r);
> +				if (pr && !request_resource(pr, r))
> +					continue;
> +				dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
> +			}
>  			/* We'll assign a new address later */
>  			r->end -= r->start;
>  			r->start = 0;
> diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
> index 15b9cf6..f22737d 100644
> --- a/arch/x86/pci/pci.h
> +++ b/arch/x86/pci/pci.h
> @@ -117,6 +117,9 @@ extern int __init pcibios_init(void);
>  extern int __init pci_mmcfg_arch_init(void);
>  extern void __init pci_mmcfg_arch_free(void);
>  
> +/* pci-common.c */
> +extern int pcibios_resource_needs_fixup(struct pci_dev *dev, int resno);
> +
>  /*
>   * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
>   * on their northbrige except through the * %eax register. As such, you MUST


