Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZFYBBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZFYBBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZFYBB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:01:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:49349 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZFYBB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:01:27 -0400
Date: Thu, 25 Jun 2009 10:00:00 +0900
To: fenghua.yu@intel.com
Cc: dwmw2@infradead.org, tony.luck@intel.com, chrisw@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090625003841.GA12226@linux-os.sc.intel.com>
References: <20090618180835.GB6838@il.ibm.com>
	<A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com>
	<20090625003841.GA12226@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 25 Jun 2009 10:00:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 17:38:41 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> IA64 Compilation error fix for Intel IOMMU identity mapping
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
>  arch/x86/kernel/pci-dma.c   |   22 ++++++++++++++++++++++
>  drivers/pci/intel-iommu.c   |   38 ++++++++++++++++++++++----------------
>  include/linux/intel-iommu.h |    4 ++++
>  4 files changed, 75 insertions(+), 16 deletions(-)
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
> index 4763047..775ece5 100644
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
> @@ -314,3 +315,24 @@ static __devinit void via_no_dac(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
>  #endif
> +
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

iommu_prepare_identity_map() is in drivers/pci/intel-iommu.c. So this
patch breaks x86_64 build on !CONFIG_DMAR. IA64 works since
arch/ia64/kernel/pci-dma.c is only build on CONFIG_DMAR though.
