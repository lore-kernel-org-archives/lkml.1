Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYBNUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYBNUrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbYBNUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:46:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35011 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYBNUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:46:56 -0500
Message-ID: <47B4A87F.8020800@cs.helsinki.fi>
Date: Thu, 14 Feb 2008 22:45:51 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/4] kmemcheck v4
References: <47B49DB2.2090402@gmail.com>
In-Reply-To: <47B49DB2.2090402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:

> +DEFINE_PER_CPU(bool, kmemcheck_busy) = false;
> +DEFINE_PER_CPU(uint32_t, kmemcheck_addr1) = 0;
> +DEFINE_PER_CPU(uint32_t, kmemcheck_addr2) = 0;
> +DEFINE_PER_CPU(uint32_t, kmemcheck_reg_flags) = 0;
> +
> +DEFINE_PER_CPU(int, kmemcheck_num) = 0;
> +DEFINE_PER_CPU(int, kmemcheck_balance) = 0;

No need to explicitly initialize these, they're automatically zeroed.

> +
> +/*
> + * Called from the #PF handler.
> + */
> +void
> +kmemcheck_show(struct pt_regs *regs)
> +{
> +    int n;
> +
> +    BUG_ON(!irqs_disabled());
> +
> +    if (__get_cpu_var(kmemcheck_balance) != 0) {
> +        oops_in_progress = 1;

Why?

> +        panic("kmemcheck: extra #PF");
> +    }
> +

> +/*
> + * Called from the #DB handler.
> + */
> +void
> +kmemcheck_hide(struct pt_regs *regs)
> +{
> +    BUG_ON(!irqs_disabled());
> +
> +    --__get_cpu_var(kmemcheck_balance);
> +    if (unlikely(__get_cpu_var(kmemcheck_balance) != 0)) {
> +        oops_in_progress = 1;

ditto

> +        panic("kmemcheck: extra #DB");
> +    }
> +
> +static void
> +kmemcheck_read(struct pt_regs *regs, uint32_t address, unsigned int size)
> +{
> +    void *shadow;
> +    enum shadow status;
> +
> +    shadow = address_get_shadow(address);
> +    if (!shadow)
> +        return;
> +
> +    status = test(shadow, size);
> +    if (status == SHADOW_INITIALIZED)
> +        return;
> +
> +    /* Don't warn about it again. */
> +    set(shadow, size);
> +
> +    oops_in_progress = 1;

I don't see you setting that to zero anywhere. What's this doing here 
anyway?

> +    error_save(status, address, size, regs);
> +}

> +
> +/*
> + * A faster implementation of memset() when tracking is enabled. We cannot
> + * assume that all pages within the range are tracked, so copying has 
> to be
> + * split into page-sized (or smaller, for the ends) chunks.
> + */
> +void
> +kmemcheck_memset(unsigned long s, int c, size_t n)
> +{
> +    unsigned long a_page, a_offset;
> +    unsigned long b_page, b_offset;

Uhm, s/a_page/start_page/g, s/b_page/end_page/g and same for the offsets 
too.

> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 0c6ce51..2138d64 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -50,8 +50,9 @@ struct vm_area_struct;
>  #define __GFP_THISNODE    ((__force gfp_t)0x40000u)/* No fallback, no 
> policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is 
> reclaimable */
>  #define __GFP_MOVABLE    ((__force gfp_t)0x100000u)  /* Page is movable */
> +#define __GFP_NOTRACK    ((__force gfp_t)0x200000u)  /* Don't track 
> with kmemcheck */

I think we can set __GFP_NOTRACK to zero to eliminate all dead code when 
  CONFIG_KMEMCHECK is disabled?

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index bbad43f..1593859 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -90,6 +90,8 @@
>  #define PG_reclaim        17    /* To be reclaimed asap */
>  #define PG_buddy        19    /* Page is free, on buddy lists */
> 
> +#define PG_tracked        20    /* Page is tracked by kmemcheck */
> +

I think we should re-use PG_owner_priv_1 for this (see PG_pinned, for 
example).
