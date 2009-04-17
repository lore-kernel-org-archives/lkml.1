Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbZDQONe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbZDQONe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZDQONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:13:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZDQONZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:13:25 -0400
Date: Fri, 17 Apr 2009 16:13:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dwmw2@infradead.org, allen.m.kay@intel.com, fenghua.yu@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 3/5] x86, intr-remap: enable interrupt remapping early
Message-ID: <20090417141310.GD23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <1239957736-6161-4-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239957736-6161-4-git-send-email-weidong.han@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Weidong Han <weidong.han@intel.com> wrote:

> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -118,6 +118,8 @@ static int x2apic_preenabled;
>  static int disable_x2apic;
>  static __init int setup_nox2apic(char *str)
>  {
> +	if (x2apic_enabled())
> +		panic("Bios already enabled x2apic, can't enforce nox2apic");

Could you please turn that into something like:

		printk(KERN_WARNING "Bios already enabled x2apic, can't enforce nox2apic");
		return 1;

panic-ing the box just because we cannot meet a boot option is not 
good.

> +#ifdef CONFIG_X86_X2APIC
> +	if (cpu_has_x2apic)
> +		ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
> +	else
> +#endif
> +		ret = enable_intr_remapping(EIM_8BIT_APIC_ID);

That construct looks rather ugly.

Why not clear x2apic from the CPU flags if CONFIG_X86_X2APIC is 
disabled. (and print a one-liner during bootup that we did so)

Then this could be written as:

	if (cpu_has_x2apic)
		ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
	else
		ret = enable_intr_remapping(EIM_8BIT_APIC_ID);

which looks far more nice.

> +#ifdef CONFIG_X86_X2APIC
> +	if (cpu_has_x2apic && !x2apic) {
>  		x2apic = 1;
>  		enable_x2apic();
> +		pr_info("Enabled x2apic\n");
>  	}
> +#endif

ditto - this #ifdef could go away with the cpuflags trick.

> +ir_failed:
> +	if (x2apic_preenabled)
> +		panic("x2apic enabled by bios. But IR enabling failed");

What is the likelyhood that we can continue in compat mode? If 
there's some chance, we should rather print a KERN_WARNING and 
should try to continue. If IRQs are not coming we'll hang shortly 
afterwards anyway.

>  		panic("x2apic enabled prior OS handover,"
> -		      " enable CONFIG_INTR_REMAP");

ditto.

> +++ b/drivers/pci/intel-iommu.c
> @@ -1968,15 +1968,6 @@ static int __init init_dmars(void)
>  		}
>  	}
>  
> -#ifdef CONFIG_INTR_REMAP
> -	if (!intr_remapping_enabled) {
> -		ret = enable_intr_remapping(0);
> -		if (ret)
> -			printk(KERN_ERR
> -			       "IOMMU: enable interrupt remapping failed\n");
> -	}
> -#endif

David, is this fine with you? Doing ir-remap setup in the ioapic 
code and early on is the obviously right thing to do.

> --- a/drivers/pci/intr_remapping.c
> +++ b/drivers/pci/intr_remapping.c
> @@ -423,20 +423,6 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
>  		      readl, (sts & DMA_GSTS_IRTPS), sts);
>  	spin_unlock_irqrestore(&iommu->register_lock, flags);
>  
> -	if (mode == 0) {
> -		spin_lock_irqsave(&iommu->register_lock, flags);
> -
> -		/* enable comaptiblity format interrupt pass through */

(this removal also fixes a typo ;-)

> -		cmd = iommu->gcmd | DMA_GCMD_CFI;
> -		iommu->gcmd |= DMA_GCMD_CFI;
> -		writel(cmd, iommu->reg + DMAR_GCMD_REG);
> -
> -		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
> -			      readl, (sts & DMA_GSTS_CFIS), sts);
> -
> -		spin_unlock_irqrestore(&iommu->register_lock, flags);
> -	}

Btw., switching on compat mode might be worthwile to do in one of 
the failure paths? I.e. we try to switch to IR mode but fail - we 
should then try to switch to compat pass-through instead of leaving 
the controller in limbo. Does it matter in your opinion?

> -
>  	/*
>  	 * global invalidation of interrupt entry cache before enabling
>  	 * interrupt-remapping.
> @@ -516,6 +502,20 @@ end:
>  	spin_unlock_irqrestore(&iommu->register_lock, flags);
>  }
>  
> +int __init intr_remapping_supported(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +
> +	for_each_drhd_unit(drhd) {
> +		struct intel_iommu *iommu = drhd->iommu;
> +
> +		if (!ecap_ir_support(iommu->ecap))
> +			return 0;
> +	}
> +
> +	return 1;
> +}

Jesse, are these bits fine with you? The layering is still a bit 
incestous but it's a marked improvement over what we had there 
before.

	Ingo
