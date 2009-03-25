Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZCYU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZCYU3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZCYU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:29:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZCYU3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:29:33 -0400
Date: Wed, 25 Mar 2009 21:28:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: fenghua.yu@intel.com
Cc: dwmw2@infradead.org, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [patch 2/2] Intel IOMMU Suspend/Resume Support for Queued
	Invalidation.
Message-ID: <20090325202830.GB26204@elte.hu>
References: <20090325184548.012018000@intel.com> <20090325184635.523469000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325184635.523469000@intel.com>
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


(only small style nits.)

* fenghua.yu@intel.com <fenghua.yu@intel.com> wrote:

>  /*
> + * Enable queued invalidation.
> + */
> +static void __dmar_enable_qi(struct intel_iommu *iommu)

nice helper function.

> +{
> +	u32 cmd, sts;
> +	unsigned long flags;
> +	struct q_inval *qi = iommu->qi;
> +
> +	qi->free_head = qi->free_tail = 0;
> +	qi->free_cnt = QI_LENGTH;
> +
> +	spin_lock_irqsave(&iommu->register_lock, flags);
> +	/* write zero to the tail reg */
> +	writel(0, iommu->reg + DMAR_IQT_REG);

( small nit: critical sections are important to see at a glance, and 
  they are easier to recognize if there's a newline before and after 
  the spin_lock_irqsave() call. That will also make the comment 
  after that stand out more. )

> +
> +	dmar_writeq(iommu->reg + DMAR_IQA_REG, virt_to_phys(qi->desc));
> +
> +	cmd = iommu->gcmd | DMA_GCMD_QIE;
> +	iommu->gcmd |= DMA_GCMD_QIE;
> +	writel(cmd, iommu->reg + DMAR_GCMD_REG);
> +
> +	/* Make sure hardware complete it */
> +	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
> +	spin_unlock_irqrestore(&iommu->register_lock, flags);

(ditto.)

> +}
> +
> +/*
>   * Enable Queued Invalidation interface. This is a must to support
>   * interrupt-remapping. Also used by DMA-remapping, which replaces
>   * register based IOTLB invalidation.
>   */
>  int dmar_enable_qi(struct intel_iommu *iommu)
>  {
> -	u32 cmd, sts;
> -	unsigned long flags;
>  	struct q_inval *qi;
>  
>  	if (!ecap_qis(iommu->ecap))
> @@ -835,19 +860,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>  
>  	spin_lock_init(&qi->q_lock);
>  
> -	spin_lock_irqsave(&iommu->register_lock, flags);
> -	/* write zero to the tail reg */
> -	writel(0, iommu->reg + DMAR_IQT_REG);
> -
> -	dmar_writeq(iommu->reg + DMAR_IQA_REG, virt_to_phys(qi->desc));
> -
> -	cmd = iommu->gcmd | DMA_GCMD_QIE;
> -	iommu->gcmd |= DMA_GCMD_QIE;
> -	writel(cmd, iommu->reg + DMAR_GCMD_REG);
> -
> -	/* Make sure hardware complete it */
> -	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
> -	spin_unlock_irqrestore(&iommu->register_lock, flags);
> +	__dmar_enable_qi(iommu);
>  
>  	return 0;
>  }
> @@ -1102,3 +1115,27 @@ int __init enable_drhd_fault_handling(void)
>  
>  	return 0;
>  }
> +
> +/*
> + * Re-enable Queued Invalidation interface.
> + */
> +int dmar_reenable_qi(struct intel_iommu *iommu)
> +{
> +	if (!ecap_qis(iommu->ecap))
> +		return -ENOENT;
> +
> +	if (!iommu->qi)
> +		return -ENOENT;

> +
> +	/*
> +	 * First disable queued invalidation.
> +	 */
> +	dmar_disable_qi(iommu);
> +	/* Then enable queued invalidation again. Since there is no pending
> +	 * invalidation requests now, it's safe to re-enable queued
> +	 * invalidation.
> +	 */
> +	__dmar_enable_qi(iommu);

the comment style looks a bit inconsistent here - the second 
one should be full winged comments as well, i.e.:

> +	/*
> +	 * First disable queued invalidation.
> +	 */
> +	dmar_disable_qi(iommu);
> +
> +	/*
> +	 * Then enable queued invalidation again. Since there is no pending
> +	 * invalidation requests now, it's safe to re-enable queued
> +	 * invalidation.
> +	 */
> +	__dmar_enable_qi(iommu);

Thanks,

	Ingo
