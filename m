Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbYKZO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbYKZO4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYKZO4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:56:14 -0500
Received: from www.tglx.de ([62.245.132.106]:36136 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYKZO4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:56:13 -0500
Date: Wed, 26 Nov 2008 15:55:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 21/24] perfmon: Intel architectural PMU support (x86)
In-Reply-To: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain>
References: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> +static u64 enable_mask[PFM_MAX_PMCS];

Why do we need enable_mask twice for AMD and Intel ?

> +static u16 max_enable;
> +static int pfm_intel_arch_version;
> +
> +DEFINE_PER_CPU(u64, saved_global_ctrl);

static

> +/*
> + * layout of EAX for CPUID.0xa leaf function
> + */
> +struct pmu_eax {
> +	unsigned int version:8;		/* architectural perfmon version */
> +	unsigned int num_cnt:8; 	/* number of generic counters */
> +	unsigned int cnt_width:8;	/* width of generic counters */
> +	unsigned int ebx_length:8;	/* number of architected events */
> +};

in arch/x86/include/asm/intel_arch_perfmon.h we have already:

union cpuid10_eax {
        struct {
                unsigned int version_id:8;
                unsigned int num_counters:8;
                unsigned int bit_width:8;
                unsigned int mask_length:8;
        } split;
        unsigned int full;
};

Can we either use this or remove it ?

> +/*
> + * layout of EDX for CPUID.0xa leaf function when perfmon v2 is detected
> + */
> +struct pmu_edx {
> +	unsigned int num_cnt:5;		/* number of fixed counters */
> +	unsigned int cnt_width:8;	/* width of fixed counters */
> +	unsigned int reserved:19;
> +};

> +static void pfm_intel_arch_acquire_pmu_percpu(void);
> +static void pfm_intel_arch_release_pmu_percpu(void);
> +static int pfm_intel_arch_stop_save(struct pfm_context *ctx,
> +				    struct pfm_event_set *set);
> +static int pfm_intel_arch_has_ovfls(struct pfm_context *ctx);
> +static void __kprobes pfm_intel_arch_quiesce(void);
> +
> +/*
> + * physical addresses of MSR controlling the perfevtsel and counter registers
> + */
> +struct pfm_arch_pmu_info pfm_intel_arch_pmu_info = {
> +	.stop_save = pfm_intel_arch_stop_save,
> +	.has_ovfls = pfm_intel_arch_has_ovfls,
> +	.quiesce = pfm_intel_arch_quiesce,
> +	.acquire_pmu_percpu = pfm_intel_arch_acquire_pmu_percpu,
> +	.release_pmu_percpu = pfm_intel_arch_release_pmu_percpu
> +};

A) static
B) Please move it to the bottom to avoid all the forward declarations.

> +static void pfm_intel_arch_check_errata(void)

  __init ?

> +static void pfm_intel_arch_setup_generic(unsigned int version,

  Ditto.

> +static void pfm_intel_arch_setup_fixed(unsigned int version,

  Ditto.

> +static int pfm_intel_arch_probe_pmu(void)

  Ditto.

> +	/*
> +	 * handle version new anythread bit (bit 2)
> +	 */

  -ENOPARSE

> +	if (version == 3)
> +		rsvd = 1ULL << 3;

  This sets bit 3

> +	else
> +		rsvd = 3ULL << 2;

  And this sets bit 2 and 3. 

> +static int pfm_intel_arch_stop_save(struct pfm_context *ctx,
> +				    struct pfm_event_set *set)
> +{
> +	u64 used_mask[PFM_PMC_BV];
> +	u64 val, wmask, ovfl_mask;
> +	u32 i, count;
> +
> +	wmask = 1ULL << pfm_pmu_conf->counter_width;
> +
> +	pfm_arch_bv_and(used_mask,
> +			set->used_pmcs,
> +			enable_mask,
> +			max_enable);
> +
> +	count = pfm_arch_bv_weight(used_mask, max_enable);

So we have:

   set->used_pmcs and enable_mask and max_enable.

Why can set->used_pmcs contain bits which are not in the enable_mask
in the first place ? Why does the arch code not tell the generic code
which pmcs are available so we can avoid all this mask, weight
whatever magic ?

We store the same information in slightly different incarnations in
various places and then we need to mingle them all together to get to
the real data. That makes no sense at all.

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

Why are the counters enabled at all when an overflow is pending, which
stopped the counters anyway ?

Thanks,

	tglx
