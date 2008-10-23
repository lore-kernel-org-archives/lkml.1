Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYJWX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYJWX6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYJWX6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:58:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:49819 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYJWX6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:58:11 -0400
Date: Fri, 24 Oct 2008 08:57:41 +0900
To: fenghua.yu@intel.com
Cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       david.woodhouse@intel.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, adobriyan@gmail.com
Subject: Re: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081023235100.GA2192@linux-os.sc.intel.com>
References: <a4423d670810231609h76323d2fqa4ed7d9ba0a46e3b@mail.gmail.com>
	<20081023235100.GA2192@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024085808J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 16:51:00 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Thu, Oct 23, 2008 at 04:09:52PM -0700, Alexander Beregalov wrote:
> > arch/x86/kernel/built-in.o: In function `iommu_setup':
> > pci-dma.c:(.init.text+0x36ad): undefined reference to `forbid_dac'
> > pci-dma.c:(.init.text+0x36cc): undefined reference to `forbid_dac'
> > pci-dma.c:(.init.text+0x3711): undefined reference to `forbid_dac
> > 
> > commit 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
> > Author: Fenghua Yu <fenghua.yu@intel.com>
> > Date:   Thu Oct 16 18:02:32 2008 -0700
> > 
> >     intel-iommu: IA64 support
> 
> Could you please try the following fix patch?
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Looks fine to me.

For X86, there is no point to move forbid_dac from pci-dma.c.

For IA64, there is no point to have forbid_dac in
iommu_dma_supported(). IA64 doesn't even use it.


> ---
> 
>  arch/ia64/include/asm/iommu.h |    1 -
>  arch/ia64/kernel/pci-dma.c    |    7 -------
>  arch/x86/include/asm/iommu.h  |    1 -
>  arch/x86/kernel/pci-dma.c     |   16 ++++++++++++++++
>  drivers/pci/pci.h             |    0 
>  drivers/pci/quirks.c          |   14 --------------
>  6 files changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
> index 5fb2bb9..0490794 100644
> --- a/arch/ia64/include/asm/iommu.h
> +++ b/arch/ia64/include/asm/iommu.h
> @@ -11,6 +11,5 @@ extern int force_iommu, no_iommu;
>  extern int iommu_detected;
>  extern void iommu_dma_init(void);
>  extern void machvec_init(const char *name);
> -extern int forbid_dac;
>  
>  #endif
> diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
> index 10a75b5..031abbf 100644
> --- a/arch/ia64/kernel/pci-dma.c
> +++ b/arch/ia64/kernel/pci-dma.c
> @@ -89,13 +89,6 @@ int iommu_dma_supported(struct device *dev, u64 mask)
>  {
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  
> -#ifdef CONFIG_PCI
> -	if (mask > 0xffffffff && forbid_dac > 0) {
> -		dev_info(dev, "Disallowing DAC for device\n");
> -		return 0;
> -	}
> -#endif
> -
>  	if (ops->dma_supported_op)
>  		return ops->dma_supported_op(dev, mask);
>  
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 1972266..1926248 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -9,6 +9,8 @@
>  #include <asm/calgary.h>
>  #include <asm/amd_iommu.h>
>  
> +static int forbid_dac __read_mostly;
> +
>  struct dma_mapping_ops *dma_ops;
>  EXPORT_SYMBOL(dma_ops);
>  
> @@ -291,3 +293,17 @@ void pci_iommu_shutdown(void)
>  }
>  /* Must execute after PCI subsystem */
>  fs_initcall(pci_iommu_init);
> +
> +#ifdef CONFIG_PCI
> +/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
> +
> +static __devinit void via_no_dac(struct pci_dev *dev)
> +{
> +	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
> +		printk(KERN_INFO "PCI: VIA PCI bridge detected."
> +				 "Disabling DAC.\n");
> +		forbid_dac = 1;
> +	}
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
> +#endif
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 96cf8ec..bbf66ea 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -43,20 +43,6 @@ static void __devinit quirk_mellanox_tavor(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX,PCI_DEVICE_ID_MELLANOX_TAVOR,quirk_mellanox_tavor);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX,PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE,quirk_mellanox_tavor);
>  
> -/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
> -int forbid_dac __read_mostly;
> -EXPORT_SYMBOL(forbid_dac);
> -
> -static __devinit void via_no_dac(struct pci_dev *dev)
> -{
> -	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
> -		dev_info(&dev->dev,
> -			"VIA PCI bridge detected. Disabling DAC.\n");
> -		forbid_dac = 1;
> -	}
> -}
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
> -
>  /* Deal with broken BIOS'es that neglect to enable passive release,
>     which can cause problems in combination with the 82441FX/PPro MTRRs */
>  static void quirk_passive_release(struct pci_dev *dev)
> diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
> index 2daaffc..9a118bf 100644
> --- a/arch/x86/include/asm/iommu.h
> +++ b/arch/x86/include/asm/iommu.h
> @@ -7,7 +7,6 @@ extern struct dma_mapping_ops nommu_dma_ops;
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
>  extern int dmar_disabled;
> -extern int forbid_dac;
>  
>  extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
