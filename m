Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZFYEtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZFYEtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZFYEtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:49:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:44178 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZFYEtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:49:10 -0400
Date: Thu, 25 Jun 2009 13:48:33 +0900
To: fenghua.yu@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org, chrisw@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090625041605.GA9330@linux-os.sc.intel.com>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	<20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	<20090625041605.GA9330@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 25 Jun 2009 13:48:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 21:16:05 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> IA64 compilation error fix for Intel IOMMU identity mapping
>  
> The Intel IOMMU identity mapping uses e820 to walk the memory map. This causes
> compilation error on IA64 when IOMMU is configured:
>  
> drivers/pci/intel-iommu.c:42:22: error: asm/e820.h: No such file or directory
>  
> This patch fixes this compilation error on IA64. It defines architecture
> dependent memory map walk functions on x86 and ia64 seperately to set up
> identity mapping for all devices.
>  
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Acked-by: Tony Luck <tony.luck@intel.com>
>  
> ---
>  
> This patch is against the latest upstream tree.
> 
>  arch/ia64/kernel/pci-dma.c  |   27 +++++++++++++++++++++++++++
>  arch/x86/kernel/pci-dma.c   |   29 +++++++++++++++++++++++++++++
>  drivers/pci/intel-iommu.c   |   38 ++++++++++++++++++++++----------------
>  include/linux/intel-iommu.h |    4 ++++
>  4 files changed, 82 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
> index 0569596..9cb3700 100644
> --- a/arch/ia64/kernel/pci-dma.c
> +++ b/arch/ia64/kernel/pci-dma.c
> @@ -10,7 +10,9 @@
>  #include <linux/dmar.h>
>  #include <asm/iommu.h>
>  #include <asm/machvec.h>
> +#include <linux/efi.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/intel-iommu.h>
>  
>  #include <asm/system.h>
>  
> @@ -122,4 +124,29 @@ void __init pci_iommu_alloc(void)
>  #endif
>  }
>  
> +static int __initdata identity_mapped = 1;
> +
> +static int __init __iommu_prepare_identity_map(u64 start, u64 end, void *pdev)
> +{
> +	int ret;
> +
> +	ret = iommu_prepare_identity_map((struct pci_dev *)pdev, start, end);
> +	if (ret)  {
> +		printk(KERN_INFO "1:1 mapping to one domain failed.\n");
> +		identity_mapped = 0;
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +int __init iommu_setup_identity_map(struct pci_dev *pdev)
> +{
> +	efi_memmap_walk(__iommu_prepare_identity_map, pdev);
> +	if (!identity_mapped)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  #endif
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 4763047..16dcc61 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -10,6 +10,7 @@
>  #include <asm/gart.h>
>  #include <asm/calgary.h>
>  #include <asm/amd_iommu.h>
> +#include <linux/intel-iommu.h>
>  
>  static int forbid_dac __read_mostly;
>  
> @@ -314,3 +315,31 @@ static __devinit void via_no_dac(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
>  #endif
> +
> +#ifdef CONFIG_DMAR
> +int iommu_setup_identity_map(struct pci_dev *pdev)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +
> +		if (ei->type == E820_RAM) {
> +			ret = iommu_prepare_identity_map(pdev,
> +				ei->addr, ei->addr + ei->size);
> +			if (ret)  {
> +				printk(KERN_INFO "1:1 mapping to one domain failed.\n");
> +				return -EFAULT;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +#else
> +int iommu_setup_identity_map(struct pci_dev *pdev)
> +{
> +	return 0;
> +}
> +#endif

I don't think that we need #else part.

This patch is really ugly; adds another ifdef and VT-D specific code
to the generic place (arch/x86/kernel/pci-dma.c).

However, I guess that we need to live with this for now since this
fixes the build error.

Another complaint from me is that, IIRC, the patch causes this build
error was posted was posted first during the merge window (18 June)
and merged few days later without properly reviewed (or compile
tested).
