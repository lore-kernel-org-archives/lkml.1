Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZBRRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZBRRol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZBRRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:44:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBRRob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:44:31 -0500
Date: Wed, 18 Feb 2009 18:44:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       'iommu@lists.linux-foundation.org', LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Suspend and Resume Support for Intel IOMMU
Message-ID: <20090218174418.GA13325@elte.hu>
References: <20090218165633.GA20167@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218165633.GA20167@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> Current Intel IOMMU does not support suspend and resume. In S3 
> event, kernel crashes when IOMMU is enabled. The attached 
> patch implements the suspend and resume feature for Intel 
> IOMMU. It hooks to kernel suspend and resume interface. When 
> suspend happens, it saves necessary hardware registers. When 
> resume happens it restores the registers and restarts IOMMU.

hm, i think the patch is broken in its current form, and not 
only for the unclean structure reason Linus pointed out:

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
> 
>  drivers/pci/intel-iommu.c   |  164 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/intel-iommu.h |    1 
>  include/linux/iommu.h       |    3 
>  3 files changed, 168 insertions(+)
> 
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index c842438..83a206e 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -282,6 +282,7 @@ int dmar_disabled = 1;
>  static int __initdata dmar_map_gfx = 1;
>  static int dmar_forcedac;
>  static int intel_iommu_strict;
> +static int vtd_enabled;
>  
>  #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
>  static DEFINE_SPINLOCK(device_domain_lock);
> @@ -2763,6 +2764,7 @@ int __init intel_iommu_init(void)
>  	init_timer(&unmap_timer);
>  	force_iommu = 1;
>  	dma_ops = &intel_dma_ops;
> +	vtd_enabled = 1;
>  
>  	register_iommu(&intel_iommu_ops);
>  
> @@ -3168,3 +3170,165 @@ static void __devinit quirk_cantiga_iommu(struct pci_dev *dev)
>  }
>  
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
> +
> +#ifdef CONFIG_PM
> +static int init_iommu_hw(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	int ret, unit = 0;
> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;
> +		if (dmar_enable_qi(iommu)) {
> +			/*
> +			 * Queued Invalidate not enabled, use Register Based
> +			 * Invalidate
> +			 */
> +			iommu->flush.flush_context = __iommu_flush_context;
> +			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
> +			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
> +			       "invalidation\n",
> +			       (unsigned long long)drhd->reg_base_addr);

[ small nit: do we really need a KERN_INFO printout for ever 
  s2ram cycle? ]

> +		} else {
> +			iommu->flush.flush_context = qi_flush_context;
> +			iommu->flush.flush_iotlb = qi_flush_iotlb;
> +			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
> +			       "invalidation\n",
> +			       (unsigned long long)drhd->reg_base_addr);
> +		}
> +	}
> +
> +	/*
> +	 * for each drhd
> +	 *   enable fault log
> +	 *   global invalidate context cache
> +	 *   global invalidate iotlb
> +	 *   enable translation
> +	 */
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +		iommu = drhd->iommu;
> +		sprintf(iommu->name, "dmar%d", unit++);
> +
> +		iommu_flush_write_buffer(iommu);
> +
> +		ret = dmar_set_interrupt(iommu);
> +		if (ret)
> +			goto error;
> +

hm, if this fails (due to irq space shortage for example) then 
we do not clean up properly - is that intended? We have all 
units so far enabled and configured and the iommus registered.

In fact, this whole sequence seems buggy, as there's no 
free_irq() pair - nor should there be any.

Using dmar_set_interrupt() is plain buggy here - the irq wont go 
away during a S3 event. So we leak IRQs at every S3 event and 
eventually we'll lock up and run into this sequence, and will 
hang. The point in time when this happens depends on NR_IRQS.

> +		iommu_set_root_entry(iommu);
> +
> +		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
> +					   0);
> +		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
> +					 0);
> +		iommu_disable_protect_mem_regions(iommu);
> +
> +	}
> +
> +	return 0;
> +error:
> +	return ret;
> +}

Also, the whole sequence shares a lot of code with init_dmars(). 
Shouldnt there be a common helper function that does the 
initialization?

> +
> +static void iommu_flush_all(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +
> +	for_each_drhd_unit(drhd) {
> +		iommu = drhd->iommu;
> +		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
> +					   0);
> +		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
> +					 0);
> +	}
> +}

Hm, doesnt this loop body miss a drhd->ignored check?

> +
> +static u32 iommu_state[MAX_IOMMUS][MAX_IOMMU_REGS];
> +static int iommu_suspend(struct sys_device *dev, pm_message_t state)
> +{

[ style nit: please always separate variables from function 
  prototypes, by at least one newline. ]

> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	int    i = 0;
> +
> +	if (!vtd_enabled)
> +		return 0;
> +
> +	iommu_flush_all();
> +
> +	for_each_drhd_unit(drhd) {
> +		iommu = drhd->iommu;
> +
> +		iommu_state[i][DMAR_FECTL_REG] =
> +			(u32) readl(iommu->reg + DMAR_FECTL_REG);
> +		iommu_state[i][DMAR_FEDATA_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEDATA_REG);
> +		iommu_state[i][DMAR_FEADDR_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEADDR_REG);
> +		iommu_state[i][DMAR_FEUADDR_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEUADDR_REG);
> +		i++;
> +	}
> +	return 0;
> +}

This loop body too appears to miss a drhd->ignored check. Or is 
it not needed for some reason?

If the check is needed here then it would be cleaner if the 
for_each_drhd_unit() iterator automatically included a check for 
drhd->ignored, that way it cannot be missed.

> +static int iommu_resume(struct sys_device *dev)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	int i = 0;
> +
> +	if (!vtd_enabled)
> +		return 0;
> +
> +	iommu_flush_all();
> +
> +	if (init_iommu_hw())
> +		panic("IOMMU setup failed, DMAR can not start!\n");
> +
> +	for_each_drhd_unit(drhd) {
> +		iommu = drhd->iommu;
> +
> +		writel((u32) iommu_state[i][DMAR_FECTL_REG],
> +			iommu->reg + DMAR_FECTL_REG);
> +		writel((u32) iommu_state[i][DMAR_FEDATA_REG],
> +			iommu->reg + DMAR_FEDATA_REG);
> +		writel((u32) iommu_state[i][DMAR_FEADDR_REG],
> +			iommu->reg + DMAR_FEADDR_REG);
> +		writel((u32) iommu_state[i][DMAR_FEUADDR_REG],
> +			iommu->reg + DMAR_FEUADDR_REG);
> +		iommu_enable_translation(iommu);
> +		i++;
> +	}
> +	return 0;
> +}
> +
> +static struct sysdev_class iommu_sysclass = {
> +	.name		= "iommu",
> +	.resume		= iommu_resume,
> +	.suspend	= iommu_suspend,
> +};
> +
> +static struct sys_device device_iommu = {
> +	.id	= 0,

no need to initialize .id to zero, it's a static variable.

> +	.cls	= &iommu_sysclass,
> +};
> +
> +static int __init init_iommu_sysfs(void)
> +{
> +	int error;
> +
> +	error = sysdev_class_register(&iommu_sysclass);
> +	if (!error)
> +		error = sysdev_register(&device_iommu);
> +	return error;
> +}
> +device_initcall(init_iommu_sysfs);
> +
> +#endif	/* CONFIG_PM */
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index c4f6c10..5bc2da7 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -23,6 +23,7 @@
>  #define _INTEL_IOMMU_H_
>  
>  #include <linux/types.h>
> +#include <linux/sysdev.h>
>  #include <linux/iova.h>
>  #include <linux/io.h>
>  #include <linux/dma_remapping.h>

small cleanliness nit: since the intel-iommu.h header clearly 
does not need the sysdev.h include, it would be cleaner to 
include it in intel-iommu.c only.

Header files should not add 'convenience' headers, they should 
strictly only include types they need themselves for their own 
type and method definitions.

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 8a7bfb1..01942ca 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -22,6 +22,9 @@
>  #define IOMMU_READ	(1)
>  #define IOMMU_WRITE	(2)

[ small style nit: the parenthesis looks superfluous. ]

>  
> + #define MAX_IOMMUS	32
> + #define MAX_IOMMU_REGS	0xc0
> +
>  struct device;
>  
>  struct iommu_domain {

	Ingo
