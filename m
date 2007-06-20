Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXFTSsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXFTSsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762296AbXFTSmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:42:09 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20575 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761561AbXFTSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:42:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:38:28 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] 2.6.22-rc3 perfmon2 : IBS implementation for
 AMD64
Message-ID: <20070620183828.GH24544@erda.amd.com>
References: <20070614215818.509851000@localhost>
 <20070615093331.329763000@localhost>
 <alpine.DEB.0.99.0706151310410.15507@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706151310410.15507@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:38:28.0123 (UTC)
 FILETIME=[31786EB0:01C7B36A]
X-WSS-ID: 6A67ABDE1S4957509-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

> > +u64 pfm_pmd_sread(struct pfm_context *ctx, unsigned int cnum)
> > +{
> > +	unsigned int vpmd = pfm_pmu_conf->pmd_desc[cnum].hw_addr;
> > +	BUG_ON(! spin_is_locked(&ctx->lock));
> > +	if (vpmd >= PFM_NUM_VPMDS)
> > +		return 0;
> > +	return __pfm_pmd_sread(vpmd);
> > +}
> 
> If you're going to do error checking here even though you're already 
> checking for vpmd >= PFM_NUM_VPMDS in pfm_pmd_sinc(), then please return 
> an errno such as -EINVAL instead of 0 here.  Otherwise a distinct caller 
> can still set pfm_pmu_conf->arch_info->vpmds[get_smt_id()][vpmd] to 1 if 
> it calls pfm_pmd_sread() outside of pfm_pmd_sinc().

I modified the error handler, pls. see 2nd patch version.

> > @@ -309,7 +355,13 @@ static int pfm_stop_save_p6(struct pfm_c
> >  	count = set->nused_pmds;
> >  	for (i = 0; count; i++) {
> >  		if (test_bit(i, ulp(set->used_pmds))) {
> > -			val = pfm_arch_read_pmd(ctx, i);
> > +			count--;
> > +			/* Skip for IBS event counter */
> > +			if (unlikely(i == arch_info->ibsfetchctr_idx))
> > +				continue;
> > +			if (unlikely(i == arch_info->ibsopctr_idx))
> > +				continue;
> > +			val = pfm_read_pmd(ctx, i);
> >  			if (likely(test_bit(i, ulp(cnt_mask)))) {
> >  				if (!(val & wmask)) {
> >  					__set_bit(i, ulp(set->povfl_pmds));
> 
> Why are you moving the count-- ahead in this code block?  Isn't it more 
> appropriate in the for() statement alongside i++ anyway?  (There's 
> multiple instances of this in this patch.)

'count' may only be incremented if the PMD is used. The loop finishs
after all used PMDs are served.

> 
> > @@ -318,7 +370,6 @@ static int pfm_stop_save_p6(struct pfm_c
> >  				val = (pmds[i] & ~ovfl_mask) | (val & ovfl_mask);
> >  			}
> >  			pmds[i] = val;
> > -			count--;
> >  		}
> >  	}
> >  	/* 0 means: no need to save PMDs at upper level */
> > @@ -328,6 +379,55 @@ static int pfm_stop_save_p6(struct pfm_c
> >  static int pfm_stop_save_amd64(struct pfm_context *ctx,
> >  			       struct pfm_event_set *set)
> >  {
> 
> Does this need ctx->lock to be locked even in the !(arch_info->flags & 
> PFM_X86_FL_IBS) case?  If so, it needs a comment.

It seems this function is only called if the lock is set, but im not
sure, if the non-IBS code requires the lock. The IBS code requires the
lock, thus I added BUG_ON().

> 
> > +	struct pfm_arch_pmu_info *arch_info = pfm_pmu_conf->arch_info;
> > +	struct pfm_reg_desc *pmc_desc = pfm_pmu_conf->pmc_desc;
> > +	u64 val = 0;
> > +
> > +	if (arch_info->flags & PFM_X86_FL_IBS) {
> > +		/* Check for IBS events */
> > +		BUG_ON(!spin_is_locked(&ctx->lock));
> > +		do {
> > +			if (unlikely(test_bit(arch_info->ibsfetchctr_idx,
> > +					      ulp(set->povfl_pmds)))) {
> > +				PFM_DBG("Warning: IBS fetch data already pending");
> > +				continue;
> > +			}
> > +			rdmsrl(pmc_desc[arch_info->ibsfetchctl_idx].hw_addr,
> > +			       val);
> > +			if (!(val & PFM_AMD64_IBSFETCHVAL))
> > +				continue;
> > +			PFM_DBG_ovfl("New IBS fetch data available");
> > +			__set_bit(arch_info->ibsfetchctr_idx,
> > +				  ulp(set->povfl_pmds));
> > +			set->npend_ovfls++;
> > +			/* Increment event counter */
> > +			pfm_pmd_sinc(ctx, arch_info->ibsfetchctr_idx);
> > +			/* Update PMD */
> > +			set->view->set_pmds[arch_info->ibsfetchctr_idx] =
> > +				pfm_read_pmd(ctx, arch_info->ibsfetchctr_idx);
> > +		} while (0);
> 
> Please move this out of the do { ... } while (0); loop and change the 
> continue's to goto's.

Reworked in patch version 2.

> 
> > +		do {
> > +			if (unlikely(test_bit(arch_info->ibsopctr_idx,
> > +					      ulp(set->povfl_pmds)))) {
> > +				PFM_DBG("Warning: IBS execution data already pending");
> > +				continue;
> > +			}
> > +			rdmsrl(pmc_desc[arch_info->ibsopctl_idx].hw_addr, val);
> > +			if (!(val & PFM_AMD64_IBSOPVAL))
> > +				continue;
> > +			PFM_DBG_ovfl("New IBS execution data available");
> > +			__set_bit(arch_info->ibsopctr_idx,
> > +				  ulp(set->povfl_pmds));
> > +			set->npend_ovfls++;
> > +			/* Increment event counter */
> > +			pfm_pmd_sinc(ctx, arch_info->ibsopctr_idx);
> > +			/* Update PMD */
> > +			set->view->set_pmds[arch_info->ibsopctr_idx] =
> > +				pfm_read_pmd(ctx, arch_info->ibsopctr_idx);
> > +		} while (0);
> 
> Likewise.
> 
> > @@ -637,6 +737,7 @@ void pfm_arch_start(struct task_struct *
> >  		    struct pfm_event_set *set)
> >  {
> >  	struct pfm_arch_context *ctx_arch;
> > +	struct pfm_reg_desc* pmc_desc;
> >  	u64 *mask;
> >  	u16 i, num;
> >  
> 
> Kernel coding style is struct pfm_reg_desc *pmc_desc here.

Changed.

> 
> > @@ -673,11 +774,18 @@ void pfm_arch_start(struct task_struct *
> >  	 */
> >  	num = pfm_pmu_conf->num_pmcs;
> >  	mask = pfm_pmu_conf->impl_pmcs;
> > +	pmc_desc = pfm_pmu_conf->pmc_desc;
> >  	for (i = 0; num; i++) {
> > -		if (test_bit(i, ulp(mask))) {
> > +		if (!test_bit(i, ulp(mask)))
> > +			continue;
> > +		num--;
> > +		if (!test_bit(i, ulp(set->used_pmcs)))
> > +			/* If the PMC is not used, we initialize with
> > +			 * interrupts disabled. */
> > +			pfm_arch_write_pmc(ctx, i, set->pmcs[i]
> > +					   & ~pmc_desc[i].no_emul64_msk);
> > +		else
> >  			pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
> > -			num--;
> > -		}
> >  	}
> 
> num-- should be placed alongside i++ in the for() statement.

Same as above. See 'count' discussion of pfm_stop_save_p6() diff.

> 
> > @@ -839,18 +947,37 @@ static int __kprobes pfm_has_ovfl_p6(voi
> >  	xrd = arch_info->pmd_addrs;
> >  
> >  	for (i = 0; num; i++) {
> > -		if (test_bit(i, ulp(cnt_mask))) {
> > -			rdmsrl(xrd[i].addrs[0], val);
> > -			if (!(val & wmask))
> > -				return 1;
> > -			num--;
> > -		}
> > +		if (!test_bit(i, ulp(cnt_mask)))
> > +			continue;
> > +		num--;
> > +		/* Skip for IBS event counter */
> > +		if (unlikely(i == arch_info->ibsfetchctr_idx))
> > +			continue;
> > +		if (unlikely(i == arch_info->ibsopctr_idx))
> > +			continue;
> > +		rdmsrl(xrd[i].addrs[0], val);
> > +		if (!(val & wmask))
> > +			return 1;
> >  	}
> 
> Same as above.
> 
> > @@ -973,11 +1100,18 @@ static struct notifier_block pfm_nmi_nb=
> >  int pfm_arch_pmu_config_init(struct _pfm_pmu_config *cfg)
> >  {
> >  	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
> > -	struct pfm_arch_ext_reg *pc;
> > +	struct pfm_arch_ext_reg *pc, *pd;
> >  	u64 *mask;
> >  	unsigned int i, num, ena;
> > +	unsigned int ibs_check = 0;
> > +#define IBS_CHECK_FETCHCTL	0x01
> > +#define IBS_CHECK_FETCHCTR	0x02
> > +#define IBS_CHECK_OPCTL		0x04
> > +#define IBS_CHECK_OPCTR		0x08
> > +#define IBS_CHECK_ALL		0x0f
> >  
> 
> These cannot occur in the middle of a function.  Please move them to an 
> appropriate header file.

Changed.

> 
> >  	pc = arch_info->pmc_addrs;
> > +	pd = arch_info->pmd_addrs;
> >  
> >  	/*
> >  	 * ensure that PMU description is able to deal with NMI watchdog using
> > @@ -1023,18 +1157,86 @@ int pfm_arch_pmu_config_init(struct _pfm
> >  	num = cfg->num_pmcs;
> >  	mask = cfg->impl_pmcs;
> >  	ena = 0;
> > +	ibs_check = 0;
> 
> Didn't you initialize this to 0?

Changed.

> 
> > Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> > +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > @@ -5,6 +5,9 @@
> >   * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
> >   * Contributed by Stephane Eranian <eranian@hpl.hp.com>
> >   *
> > + * Copyright (c) 2007 Advanced Micro Devices, Inc.
> > + * Contributed by Robert Richter <robert.richter@amd.com>
> > + *
> >   * This program is free software; you can redistribute it and/or
> >   * modify it under the terms of version 2 of the GNU General Public
> >   * License as published by the Free Software Foundation.
> > @@ -25,6 +28,7 @@
> >  #include <asm/nmi.h>
> >  
> >  MODULE_AUTHOR("Stephane Eranian <eranian@hpl.hp.com>");
> > +MODULE_AUTHOR("Robert Richter <robert.richter@amd.com>");
> >  MODULE_DESCRIPTION("AMD64 PMU description table");
> >  MODULE_LICENSE("GPL");
> >  
> > @@ -38,12 +42,26 @@ static struct pfm_arch_pmu_info pfm_k8_p
> >  /* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
> >  /* pmc2  */	{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
> >  /* pmc3  */	{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
> > +/* pmc4  */	{{MSR_AMD64_IBSFETCHCTL, 0}, 0, PFM_REGT_EN|PFM_REGT_IBS},
> > +/* pmc5  */	{{MSR_AMD64_IBSOPCTL, 0}, 0, PFM_REGT_EN|PFM_REGT_IBS},
> >  	},
> >  	.pmd_addrs = {
> >  /* pmd0  */	{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
> >  /* pmd1  */	{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
> >  /* pmd2  */	{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
> >  /* pmd3  */	{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
> > +/* pmd4  */	{{0, 0}, 0, PFM_REGT_CTR|PFM_REGT_IBS},
> > +/* pmd5  */	{{MSR_AMD64_IBSFETCHCTL, 0}, 0, PFM_REGT_IBS},
> > +/* pmd6  */	{{MSR_AMD64_IBSFETCHLINAD, 0}, 0, PFM_REGT_IBS},
> > +/* pmd7  */	{{MSR_AMD64_IBSFETCHPHYSAD, 0}, 0, PFM_REGT_IBS},
> > +/* pmd8  */	{{0, 0}, 0, PFM_REGT_CTR|PFM_REGT_IBS},
> > +/* pmd9  */	{{MSR_AMD64_IBSOPCTL, 0}, 0, PFM_REGT_IBS},
> > +/* pmd10 */	{{MSR_AMD64_IBSOPRIP, 0}, 0, PFM_REGT_IBS},
> > +/* pmd11 */	{{MSR_AMD64_IBSOPDATA, 0}, 0, PFM_REGT_IBS},
> > +/* pmd12 */	{{MSR_AMD64_IBSOPDATA2, 0}, 0, PFM_REGT_IBS},
> > +/* pmd13 */	{{MSR_AMD64_IBSOPDATA3, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
> > +/* pmd14 */	{{MSR_AMD64_IBSDCLINAD, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
> > +/* pmd15 */	{{MSR_AMD64_IBSDCPHYSAD, 0}, 0, PFM_REGT_IBS|PFM_REGT_IBS_EXT},
> >  	},
> >  	.pmu_style = PFM_X86_PMU_AMD64
> >  };
> > @@ -65,11 +83,26 @@ static struct pfm_arch_pmu_info pfm_k8_p
> >  			| (1ULL<<20)	\
> >  			| (1ULL<<21))
> >  
> > +/*
> > + * We mark readonly bits as reserved and use the PMC for control
> > + * operations only.  Interrupt enable and clear bits are reserved too.
> > + * IBSFETCHCTL is also implemented as PMD, where data can be read
> > + * from. Same applies to IBSOPCTR.
> > + */
> > +#define PFM_AMD64_IBSFETCHCTL_VAL	PFM_AMD64_IBSFETCHEN
> > +#define PFM_AMD64_IBSFETCHCTL_NO64	PFM_AMD64_IBSFETCHEN
> > +#define PFM_AMD64_IBSFETCHCTL_RSVD	(~((1ULL<<16)-1))
> > +#define PFM_AMD64_IBSOPCTL_VAL		PFM_AMD64_IBSOPEN
> > +#define PFM_AMD64_IBSOPCTL_NO64		PFM_AMD64_IBSOPEN
> > +#define PFM_AMD64_IBSOPCTL_RSVD		(~((1ULL<<16)-1))
> > +
> >  static struct pfm_reg_desc pfm_k8_pmc_desc[]={
> >  /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
> >  /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
> >  /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
> >  /* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),
> > +/* pmc4  */ PMC_D(PFM_REG_I, "IBSFETCHCTL", PFM_AMD64_IBSFETCHCTL_VAL, PFM_AMD64_IBSFETCHCTL_RSVD, PFM_AMD64_IBSFETCHCTL_NO64, MSR_AMD64_IBSFETCHCTL),
> > +/* pmc5  */ PMC_D(PFM_REG_I, "IBSOPCTL", PFM_AMD64_IBSOPCTL_VAL, PFM_AMD64_IBSOPCTL_RSVD, PFM_AMD64_IBSOPCTL_NO64, MSR_AMD64_IBSOPCTL),
> >  };
> >  #define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
> >  
> > @@ -78,6 +111,18 @@ static struct pfm_reg_desc pfm_k8_pmd_de
> >  /* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
> >  /* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
> >  /* pmd3  */ PMD_D(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3),
> > +/* pmd4  */ PMD_D(PFM_REG_ICV, "IBSFETCHCTR",	PFM_VPMD_AMD64_IBSFETCHCTR),
> > +/* pmd5  */ PMD_D(PFM_REG_IRO, "IBSFETCHCTL",	MSR_AMD64_IBSFETCHCTL),
> > +/* pmd6  */ PMD_D(PFM_REG_IRO, "IBSFETCHLINAD",	MSR_AMD64_IBSFETCHLINAD),
> > +/* pmd7  */ PMD_D(PFM_REG_IRO, "IBSFETCHPHYSAD", MSR_AMD64_IBSFETCHPHYSAD),
> > +/* pmd8  */ PMD_D(PFM_REG_ICV, "IBSOPCTR",	PFM_VPMD_AMD64_IBSOPCTR),
> > +/* pmd9  */ PMD_D(PFM_REG_IRO, "IBSOPCTL",	MSR_AMD64_IBSOPCTL),
> > +/* pmd10 */ PMD_D(PFM_REG_IRO, "IBSOPRIP",	MSR_AMD64_IBSOPRIP),
> > +/* pmd11 */ PMD_D(PFM_REG_IRO, "IBSOPDATA",	MSR_AMD64_IBSOPDATA),
> > +/* pmd12 */ PMD_D(PFM_REG_IRO, "IBSOPDATA2",	MSR_AMD64_IBSOPDATA2),
> > +/* pmd13 */ PMD_D(PFM_REG_IRO, "IBSOPDATA3",	MSR_AMD64_IBSOPDATA3),
> > +/* pmd14 */ PMD_D(PFM_REG_IRO, "IBSDCLINAD",	MSR_AMD64_IBSDCLINAD),
> > +/* pmd15 */ PMD_D(PFM_REG_IRO, "IBSDCPHYSAD",	MSR_AMD64_IBSDCPHYSAD),
> >  };
> >  #define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
> >  
> > @@ -284,6 +329,9 @@ static int pfm_k8_detect_nmi(void)
> >  	 * auto-detect which perfctr/eventsel is used by NMI watchdog
> >  	 */
> >  	for (i=0; i < PFM_AMD_NUM_PMDS; i++) {
> > +		/* skip IBS registers */
> > +		if (pfm_k8_pmu_info.pmc_addrs[i].reg_type & PFM_REGT_IBS)
> > +			continue;
> >  		if (avail_to_resrv_perfctr_nmi(pfm_k8_pmd_desc[i].hw_addr))
> >  			continue;
> >  
> > @@ -332,10 +380,75 @@ static int pfm_k8_probe_pmu(void)
> >  		pfm_k8_setup_nb_event_control();
> >  
> >  	PFM_INFO("Using AMD64 PMU");
> > +	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS)
> > +		PFM_INFO("IBS is supported by processor");
> > +	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS_EXT)
> > +		PFM_INFO("IBS extended registers are supported by processor");
> >  
> >  	return 0;
> >  }
> >  
> > +static inline void
> > +pfm_amd64_check_register(struct pfm_pmu_config *cfg,
> > +			 struct pfm_reg_desc *reg,
> > +			 struct pfm_arch_ext_reg *ext_reg)
> > +{
> > +	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
> > +
> > +	if (!(ext_reg->reg_type & PFM_REGT_AMD64))
> > +		/* No special AMD64 PMU register */
> > +		return;
> > +
> > +	/* Disable register */
> > +	reg->type &= ~PFM_REG_I;
> > +
> > +	switch (ext_reg->reg_type & PFM_REGT_AMD64) {
> > +	case (PFM_REGT_IBS):
> > +		/* IBS register */
> > +		if (!(arch_info->flags & PFM_X86_FL_IBS))
> > +			return;
> > +		break;
> > +	case (PFM_REGT_IBS|PFM_REGT_IBS_EXT):
> > +		/* IBS extended register */
> > +		if (!(arch_info->flags & PFM_X86_FL_IBS_EXT))
> > +			return;
> > +		break;
> > +	default:
> > +		return;
> > +	}
> > +
> > +	/* Enable register */
> > +	reg->type |= PFM_REG_I;
> > +}
> > +
> > +static void pfm_amd64_setup_pmu(struct pfm_pmu_config *cfg)
> > +{
> > +	u16 i;
> > +	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
> > +
> > +	/* set PMU features depending on CPUID */
> > +	arch_info->flags &= ~(PFM_X86_FL_IBS|PFM_X86_FL_IBS_EXT);
> > +	switch (current_cpu_data.x86) {
> > +	case 15:
> > +		break;
> > +	case 16:
> > +		arch_info->flags |= PFM_X86_FL_IBS;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> 
> Could you just collapse this into
> 
> 	if (current_cpu_data.x86 == 16)
> 		arch_info->flags |= PFM_X86_FL_IBS;
> 
> 

Since this code will be extended in the near future, switch/case is
more appropriate and reduces nested if/then/else statements. You are
right, to implement only this one flag, your suggested 2 lines are
better.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



