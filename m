Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYKZLHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYKZLHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYKZLHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:07:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYKZLHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:07:02 -0500
Date: Wed, 26 Nov 2008 12:17:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
Message-ID: <20081126111727.GQ6703@one.firstfloor.org>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:42:00AM -0800, eranian@googlemail.com wrote:
> +	 * __pfm_unload_context() cannot fail
> +	 * in the context states we are interested in
> +	 */
> +	switch (ctx->state) {
> +	case PFM_CTX_LOADED:
> +		ret = __pfm_unload_context(ctx);
> +		break;
> +	case PFM_CTX_ZOMBIE:
> +		ret = __pfm_unload_context(ctx);
> +		free_ok = 1;
> +		break;
> +	default:
> +		BUG_ON(ctx->state != PFM_CTX_LOADED);

That is just BUG() because the condition is always true here.

> + *
> + * we come here if:
> + *
> + *  - we are zombie and we need to cleanup our state

...
> +void pfm_handle_work(struct pt_regs *regs)
> +{
> +	struct pfm_context *ctx;
> +	unsigned long flags;
> +	int type;
> +
> +	if (!user_mode(regs))
> +		return;

zombies are never in user mode. Either the comment 
is wrong or the test.

> +	 * enable interrupt for vfree()
> +	 */
> +	local_irq_enable();
> +
> +	/*
> +	 * actual context free
> +	 */
> +	pfm_free_context(ctx);
> +
> +	/*
> +	 * restore interrupts as they were upon entry
> +	 */
> +	local_irq_restore(flags);

That seems redundant after the local_irq_enable() above.

> + */
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/vfs.h>
> +#include <linux/mount.h>
> +#include <linux/perfmon_kern.h>
> +#include "perfmon_priv.h"
> +
> +#define PFMFS_MAGIC 0xa0b4d889	/* perfmon filesystem magic number */

This should be probably somewhere else.

> +	return 1;
> +}
> +__setup("perfmon_debug", enable_debug);

There's a new generic dynamic_printk.h now that might be an alternative.

> +{
> +	PFM_LOG("version %u.%u", PFM_VERSION_MAJ, PFM_VERSION_MIN);
> +
> +	if (pfm_init_ctx())
> +		goto error_disable;
> +
> +	if (pfm_init_fs())
> +		goto error_disable;
> +
> +	/*
> +	 * one time, arch-specific global initialization
> +	 */
> +	if (pfm_arch_init())
> +		goto error_disable;
> +
> +	return 0;
> +
> +error_disable:
> +	PFM_ERR("perfmon is disabled due to initialization error");
> +	perfmon_disabled = 1;
> +	return -1;

I presume failure is very unlikely, but this has leaks under various
error conditions, hasn't it?

If they are very unlikely a comment that you don't handle it 
intentionally is enough, but at least the comment if not
proper code should be there.

> +{
> +#ifdef CONFIG_SMP
> +	struct pfm_context *ctxp;
> +
> +	ctxp = __get_cpu_var(pmu_ctx);
> +	if (!ctxp)
> +		return;
> +	/*
> +	 * in UP per-thread, due to lazy save

But that's in CONFIG_SMP?

Also that assumption might be not true on !x86?

> +	 * there could be a context from another
> +	 * task. We need to push it first before
> +	 * installing our new state
> +	 */
> +	pfm_save_pmds(ctxp);
> +	/*
> +	 * do not clear ownership because we rewrite
> +	 * right away
> +	 */
> +#endif
> +}
> + * global information about all sessions
> + */
> +struct pfm_resources {
> +	cpumask_t sys_cpumask;     /* bitmask of used cpus */
> +	u32 thread_sessions; /* #num loaded per-thread sessions */
> +};
> +
> +static struct pfm_resources pfm_res;
> +
> +static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_res_lock);

Would it make sense to share other global perfmon context 
on the same cache line? 

> +	 */
> +	spin_lock_irqsave(&pfm_res_lock, flags);
> +
> +	PFM_DBG("in  thread=%u",
> +		pfm_res.thread_sessions);
> +
> +	pfm_res.thread_sessions++;
> +
> +	PFM_DBG("out thread=%u ret=%d",
> +		pfm_res.thread_sessions,
> +		ret);
> +
> +	spin_unlock_irqrestore(&pfm_res_lock, flags);

The usual pattern would be to just do this with an atomic
counter. I suppose it wouldn't buy scalability, but perhaps
shorter code.

-Andi

-- 
ak@linux.intel.com
