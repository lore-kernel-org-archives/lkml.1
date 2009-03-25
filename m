Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZCYUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZCYUNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZCYUNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:13:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZCYUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:13:11 -0400
Date: Wed, 25 Mar 2009 21:12:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: fenghua.yu@intel.com
Cc: dwmw2@infradead.org, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [patch 1/2] Intel IOMMU Suspend/Resume Support for DMAR
Message-ID: <20090325201228.GA26204@elte.hu>
References: <20090325184548.012018000@intel.com> <20090325184635.374969000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325184635.374969000@intel.com>
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


* fenghua.yu@intel.com <fenghua.yu@intel.com> wrote:

> The attached patch implements the suspend and resume feature for 
> DMAR. It hooks to kernel suspend and resume interface.  When 
> suspend happens, it saves necessary hardware registers. When 
> resume happens it restores the registers and restarts DMAR.

The structure looks pretty clean. I suspect David will go over the 
lowlevel details - i only have a few nitpicks:

>  #include <linux/intel-iommu.h>
> +#include <linux/sysdev.h>
> +#include <asm/i8259.h>

why is that needed?

>  #include <asm/cacheflush.h>
>  #include <asm/iommu.h>
>  #include "pci.h"
> @@ -2563,6 +2565,161 @@ static void __init init_no_remapping_devices(void)
>  	}
>  }
>  
> +#ifdef CONFIG_PM
> +static int init_iommu_hw(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;
> +
> +		if (iommu->qi)
> +			dmar_reenable_qi(iommu);
> +	}
> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;

i suggested the following cleanliness detail on the previous 
submission a month or two ago, and it's still valid: why isnt the 
drhd->ignored skipping integrated into for_each_drhd_unit() ?

Perhaps named: for_each_active_drhd_unit().

Also, in practice, we iterate over active iommus, so this whole 
sequence:

> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;

Could perhaps be replaced with for_each_active_iommu(iommu).

> +
> +		iommu_flush_write_buffer(iommu);
> +
> +		iommu_set_root_entry(iommu);
> +
> +		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
> +					   0);
> +		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
> +					 0);

just put those '0);' lines to the end of the call and ignore 
checkpatch.

> +		iommu_disable_protect_mem_regions(iommu);
> +		iommu_enable_translation(iommu);
> +	}
> +
> +	return 0;
> +}
> +
> +static void iommu_flush_all(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;
> +		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
> +					   0);
> +		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
> +					 0);

ditto.

> +	}
> +}
> +
> +static u32 iommu_state[MAX_IOMMUS][MAX_IOMMU_REGS];

hm, this goes up to MAX_IOMMUS which you define to 32.

But dmar_drhd_unit registration in dmar_register_drhd_unit() is 
open-ended and has no such limit.

While i'm sure there's a limit in the spec, there's the chance for 
there to be more than 32 units enumerated (in future hardware) - and 
this will break silently.

It would be far cleaner to embedd the IOMMU state in the IOMMU 
driver data structure directly. That gets rid of the limit and it 
also makes this array allocated dynamically.

> +
> +static int iommu_suspend(struct sys_device *dev, pm_message_t state)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	unsigned long flag;
> +	int    i = 0;

(the tab before the 'i' looks a bit weird.)

> +
> +	iommu_flush_all();
> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;
> +
> +		iommu_disable_translation(iommu);
> +
> +		spin_lock_irqsave(&iommu->register_lock, flag);
> +
> +		iommu_state[i][DMAR_FECTL_REG] =
> +			(u32) readl(iommu->reg + DMAR_FECTL_REG);
> +		iommu_state[i][DMAR_FEDATA_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEDATA_REG);
> +		iommu_state[i][DMAR_FEADDR_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEADDR_REG);
> +		iommu_state[i][DMAR_FEUADDR_REG] =
> +			(u32) readl(iommu->reg + DMAR_FEUADDR_REG);

no need for the cast - readl returns u32.

> +
> +		spin_unlock_irqrestore(&iommu->register_lock, flag);
> +		i++;
> +	}
> +	return 0;
> +}
> +
> +static int iommu_resume(struct sys_device *dev)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	unsigned long flag;
> +	int i = 0;
> +
> +	if (init_iommu_hw())
> +		panic("IOMMU setup failed, DMAR can not start!\n");

Please dont panic boxes ... insert a WARN() and return.

> +
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +
> +		iommu = drhd->iommu;
> +
> +		spin_lock_irqsave(&iommu->register_lock, flag);
> +
> +		writel((u32) iommu_state[i][DMAR_FECTL_REG],
> +			iommu->reg + DMAR_FECTL_REG);
> +		writel((u32) iommu_state[i][DMAR_FEDATA_REG],
> +			iommu->reg + DMAR_FEDATA_REG);
> +		writel((u32) iommu_state[i][DMAR_FEADDR_REG],
> +			iommu->reg + DMAR_FEADDR_REG);
> +		writel((u32) iommu_state[i][DMAR_FEUADDR_REG],
> +			iommu->reg + DMAR_FEUADDR_REG);

there's no need for the (u32) case. iommu_state[] has u32 types, and 
writel takes u32.

> +
> +		spin_unlock_irqrestore(&iommu->register_lock, flag);
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
> +	.cls	= &iommu_sysclass,
> +};
> +
> +static int __init init_iommu_sysfs(void)
> +{
> +	int error;
> +
> +	error = sysdev_class_register(&iommu_sysclass);
> +	if (error)
> +		return error;
> +
> +	error = sysdev_register(&device_iommu);
> +	if (error)
> +		sysdev_class_unregister(&iommu_sysclass);
> +
> +	return error;
> +}
> +
> +#else
> +static init __init init_iommu_sysfs(void)
> +{
> +	return 0;
> +}
> +#endif	/* CONFIG_PM */
> +
>  int __init intel_iommu_init(void)
>  {
>  	int ret = 0;
> @@ -2598,6 +2755,7 @@ int __init intel_iommu_init(void)
>  	init_timer(&unmap_timer);
>  	force_iommu = 1;
>  	dma_ops = &intel_dma_ops;
> +	init_iommu_sysfs();
>  
>  	register_iommu(&intel_iommu_ops);
>  
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 1d6c71d..5ec836b 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -205,6 +205,9 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
>  /* low 64 bit */
>  #define dma_frcd_page_addr(d) (d & (((u64)-1) << PAGE_SHIFT))
>  
> +#define MAX_IOMMUS      32
> +#define MAX_IOMMU_REGS  0xc0

MAX_IOMMU_REGS ... would be nice to add some reference here where 
that limit comes from. Specification / documentation coordinates.

That will give those people who ever extend the hw side (and it will 
happen) a chance to notice this limit in the Linux kernel.

Also, is there a chance that MAX_IOMMU_REGS can be probed from the 
hardware directly? If that's possible and reliable then it would be 
nicer to make this limit dynamic. The registers are saved/restored 
straight and in a linear fashion - no reason to not make that 
extensible if we have a chance for it.

Thanks,

	Ingo
