Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYKTTfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYKTTfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYKTTfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:35:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:56364 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYKTTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:35:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IYEEiWWuZD6DVvaOGUD6+onVFtOHg8aGXGe4+SdPm5GEqeZ0BYjedhe0Az+5aAvisI
         srF4ZoeByQKuMvWeWS8HhiNMu4ZYVnvGx7Jqe3BdenugnqM+EXcHW6nHtHtQdBkeZtJx
         fH/kjmOUkB0scUPJfy6pOUD/IETuAAXfDRon8=
Message-ID: <84144f020811201135l7b83404etb311a7b62390dd19@mail.gmail.com>
Date: Thu, 20 Nov 2008 21:35:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: c2522675707d6ad6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, Nov 20, 2008 at 1:30 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> +#ifdef CONFIG_SMP
> +#define cache_line_align(x)    L1_CACHE_ALIGN(x)
> +#else
> +#define cache_line_align(x)    (x)
> +#endif

Maybe we should be put to <linux/cache.h> and call it cache_line_align_in_smp()?

> +/*
> + * Object allocation
> + */
> +static void *fast_cache_alloc(struct fast_cache *cache)
> +{
> +       unsigned int cpu = get_cpu();
> +       unsigned long flags;
> +       struct list_head *entry;
> +       struct fast_cache_page *page;
> +
> +       local_irq_save(flags);
> +
> +       if (list_empty(&cache->free_list[cpu]))
> +               __fast_cache_grow(cache, cpu);
> +
> +       entry = cache->free_list[cpu].next;
> +       page = entry_to_page(entry);
> +       list_del(entry);
> +       page->free_nr[cpu]--;
> +       BUG_ON(page->free_nr[cpu] < 0);
> +       fast_cache_dec_free(cache, cpu);
> +
> +       local_irq_restore(flags);
> +       put_cpu_no_resched();
> +
> +       return (void *)(entry + 1);
> +}

The slab allocators are pretty fast as well. Is there a reason you
can't use kmalloc() or kmem_cache_alloc() for this? You can fix the
recursion problem by adding a new GFP_NOLEAKTRACK flag that makes sure
memleak hooks are not invoked if it's set.
