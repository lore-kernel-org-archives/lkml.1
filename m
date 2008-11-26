Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYKZLWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYKZLWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYKZLWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:22:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33501 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYKZLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:22:44 -0500
Date: Wed, 26 Nov 2008 12:33:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081126113309.GS6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:42:09AM -0800, eranian@googlemail.com wrote:
> + * set cannot be NULL. Context is locked. Interrupts are masked.
> + *
> + * Caller has already restored all PMD and PMC registers, if
> + * necessary (i.e., lazy restore scheme).
> + *
> + * On x86, the only common code just needs to unsecure RDPMC if necessary

What is insecure about RDPMC? (except perhaps when secure
computing mode is on)

I think it should be enabled by default BTW because on Core2+ you
can always read the fixed counters with it.

> +	 */
> +	if (using_nmi)
> +		iip = __get_cpu_var(real_iip);

Call it real_rip perhaps?

> +	/*
> +	 * only NMI related calls
> +	 */
> +	if (val != DIE_NMI_IPI)
> +		return NOTIFY_DONE;
> +
> +	/*
> +	 * perfmon not using NMI
> +	 */
> +	if (!__get_cpu_var(pfm_using_nmi))
> +		return NOTIFY_DONE;

It should not register in this case. die notifiers are costly
because they make a lot of exceptions slower.

> +	/*
> +	 * we need to register our NMI handler when the kernels boots
> +	 * to avoid a deadlock condition with the NMI watchdog or Oprofile

What deadlock? 

> +	 * if we were to try and register/unregister on-demand.
> +	 */
> +	register_die_notifier(&pfm_nmi_nb);
> +	return 0;
> +
> +/*
> + * arch-specific user visible interface definitions
> + */
> +
> +#define PFM_ARCH_MAX_PMCS	(256+64) /* 256 HW 64 SW */
> +#define PFM_ARCH_MAX_PMDS	(256+64) /* 256 HW 64 SW */

A little excessive for current x86s?

> +#define _ASM_X86_PERFMON_KERN_H_
> +
> +#ifdef CONFIG_PERFMON
> +#include <linux/unistd.h>
> +#ifdef CONFIG_4KSTACKS
> +#define PFM_ARCH_STK_ARG	8
> +#else
> +#define PFM_ARCH_STK_ARG	16
> +#endif

Very fancy. But is it really worth it?

> +	 * bits as this may cause crash on some processors.
> +	 */
> +	if (pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_C64)
> +		value = (value | ~pfm_pmu_conf->ovfl_mask)
> +		      & ~pfm_pmu_conf->pmd_desc[cnum].rsvd_msk;
> +
> +	PFM_DBG_ovfl("pfm_arch_write_pmd(0x%lx, 0x%Lx)",
> +		     pfm_pmu_conf->pmd_desc[cnum].hw_addr,
> +		     (unsigned long long) value);
> +
> +	wrmsrl(pfm_pmu_conf->pmd_desc[cnum].hw_addr, value);

Not sure how well error handling would fit in here, but it's
normally a good idea to make at least the first wrmsrl to
these counters a checking_wrmsrl because sometimes simulators
or hypervisors don't implement them.

> + */
> +static inline void pfm_arch_unload_context(struct pfm_context *ctx)

In general a lot of these inlines seem rather large. If they are
called more than once consider out of lining for better code size.

> + * x86 does not need extra alignment requirements for the sampling buffer
> + */
> +#define PFM_ARCH_SMPL_ALIGN_SIZE	0
> +
> +asmlinkage void  pmu_interrupt(void);
> +
> +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)

All these bitmap wrappers just seem like unnecessary obfuscation.
Could you just drop them and call the standard functions directly?


-Andi

-- 
ak@linux.intel.com
