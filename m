Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYKZPV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYKZPV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYKZPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:21:47 -0500
Received: from www.tglx.de ([62.245.132.106]:55278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYKZPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:21:46 -0500
Date: Wed, 26 Nov 2008 16:20:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 22/24] perfmon: AMD64 processor support (x86)
In-Reply-To: <492d0c11.11355e0a.16fe.57b3@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811261555300.3325@localhost.localdomain>
References: <492d0c11.11355e0a.16fe.57b3@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> +static struct pfm_regmap_desc pfm_amd64_pmc_desc[] = {
> +/* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
> +/* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
> +/* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
> +/* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),

Why is PMC_D defined in include/linux/perfmon_pmu.h and only used here ?


> +static int pfm_amd64_acquire_nb(struct pfm_context *ctx)
> +{
> +        struct pfm_context **entry, *old;
> +        int proc_id;
> +
> +#ifdef CONFIG_SMP
> +        proc_id = cpu_data(smp_processor_id()).phys_proc_id;
> +#else
> +        proc_id = 0;
> +#endif

And the actual vaule of proc_id aside of generating a compiler warning
is ?

> +/**
> + * pfm_amd64_pmc_write_check -- check validity of pmc writes
> + * @ctx: context to use
> + * @set: event set to use
> + * @req: user request to modify the pmc
> + *
> + * invoked from pfm_write_pmcs() when pfm_nb_sys_owners is not NULL,i.e.,
> + * when we have detected a multi-core processor.
> + *
> + * context is locked, interrupts are masked
> + */
> +static int pfm_amd64_pmc_write_check(struct pfm_context *ctx,
> +			     struct pfm_event_set *set,
> +			     struct pfarg_pmr *req)
> +{
> +	unsigned int event;
> +
> +	/*
> +	 * delay checking NB event until we load the context
> +	 */
> +	if (ctx->state == PFM_CTX_UNLOADED)
> +		return 0;
> +
> +	/*
> +	 * check event is NB event
> +	 */
> +	event = (unsigned int)(req->reg_value & 0xff);
> +	if (event < 0xee)

  Magic 0xee means what ?

> +/**
> + * pfm_amd64_unload_context -- amd64 mdoels-specific unload callback
> + * @ctx: context to use
> + *
> + * invoked on pfm_unload_context()
> + */
> +static void pfm_amd64_unload_context(struct pfm_context *ctx)
> +{
> +	struct pfm_context **entry, *old;
> +	int proc_id;
> +
> +#ifdef CONFIG_SMP
> +	proc_id = cpu_data(smp_processor_id()).phys_proc_id;
> +#else
> +	proc_id = 0;
> +#endif

  See above.

> +	pfm_arch_bv_set_bit(0, enable_mask);
> +	pfm_arch_bv_set_bit(1, enable_mask);
> +	pfm_arch_bv_set_bit(2, enable_mask);
> +	pfm_arch_bv_set_bit(3, enable_mask);
> +	max_enable = 3+1;

  Nifty.  

> +static int pfm_amd64_setup_nb_event_ctrl(void)

  __init ?

> +static void pfm_amd64_setup_registers(void)

  Ditto.

> +static int pfm_amd64_probe_pmu(void)

  Ditto.

> +/**
> + * pfm_amd64_stop_save - stop monitoring, collect pending overflows
> + * @ctx: context to use
> + * @set: event set to stop
> + *
> + * interrupts are masked, PMU access guaranteed
> + */
> +static int pfm_amd64_stop_save(struct pfm_context *ctx,
> +			       struct pfm_event_set *set)
> +{
> +	struct pfm_arch_pmu_info *pmu_info;
> +	u64 used_mask[PFM_PMC_BV];
> +	u64 *cnt_pmds;
> +	u64 val, wmask, ovfl_mask;
> +	u32 i, count;
> +
> +	pmu_info = pfm_pmu_info();

  We go via a global variable to get a pointer to pfm_amd64_pmu_info,
  right ?

> +	wmask = 1ULL << pfm_pmu_conf->counter_width;
> +
> +	pfm_arch_bv_and(used_mask,
> +		        set->used_pmcs,
> +		        enable_mask,
> +		        max_enable);
> +
> +	count = pfm_arch_bv_weight(used_mask, max_enable);

  See comments on intel

> +	/*
> +	 * stop monitoring
> +	 * Unfortunately, this is very expensive!
> +	 * wrmsrl() is serializing.
> +	 */
> +	for (i = 0; count; i++) {
> +		if (pfm_arch_bv_test_bit(i, used_mask)) {
> +			wrmsrl(pfm_pmu_conf->pmc_desc[i].hw_addr, 0);
> +			count--;
> +		}
> +	}
> +
> +	/*
> +	 * if we already having a pending overflow condition, we simply
> +	 * return to take care of this first.
> +	 */
> +	if (set->npend_ovfls)
> +		return 1;

  Ditto.

> +/**
> + * pfm_amd64_quiesce_pmu -- stop monitoring without grabbing any lock
> + *
> + * called from NMI interrupt handler to immediately stop monitoring
> + * cannot grab any lock, including perfmon related locks

And can race against some other code modifying the msrs

> + */
> +static void __kprobes pfm_amd64_quiesce(void)
> +{
> +	/*
> +	 * quiesce PMU by clearing available registers that have
> +	 * the start/stop capability
> +	 */
> +	if (pfm_arch_bv_test_bit(0, pfm_pmu_conf->regs_all.pmcs))
> +		wrmsrl(MSR_K7_EVNTSEL0, 0);
> +	if (pfm_arch_bv_test_bit(1, pfm_pmu_conf->regs_all.pmcs))
> +		wrmsrl(MSR_K7_EVNTSEL0+1, 0);
> +	if (pfm_arch_bv_test_bit(2, pfm_pmu_conf->regs_all.pmcs))
> +		wrmsrl(MSR_K7_EVNTSEL0+2, 0);
> +	if (pfm_arch_bv_test_bit(3, pfm_pmu_conf->regs_all.pmcs))
> +		wrmsrl(MSR_K7_EVNTSEL0+3, 0);
> +}

