Return-Path: <linux-kernel-owner+w=401wt.eu-S1765949AbZFQNBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765949AbZFQNBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765860AbZFQNBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:01:23 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:41396 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbZFQNBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iyZ/yl+2TCqE+raVjvrl4A0zN8/PrfS4e8pVoW9pnJMB3nuq+XJeUdzVqwq9IkwYsl
         pHvj8+zoWqbLQsmwoMfDvAujVA95Oj3J8A3ajgJ0agDJNBgcRcMI24onRX3/S7mMuj1k
         hhQ7xqLXBy//r9pLDvGAMP2CLmdAfU7kfJTCE=
MIME-Version: 1.0
In-Reply-To: <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
	 <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
Date: Wed, 17 Jun 2009 16:01:22 +0300
X-Google-Sender-Auth: 452a8d81bc81380e
Message-ID: <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: Only use GFP_KERNEL|GFP_ATOMIC for the internal 
	allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Wed, Jun 17, 2009 at 3:52 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> Kmemleak allocates memory for pointer tracking and it tries to avoid
> using GFP_ATOMIC if the caller doesn't require it. However other gfp
> flags may be passed by the caller which aren't required by kmemleak.
> This patch filters the gfp flags so that only GFP_KERNEL | GFP_ATOMIC
> are used.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Is this really safe? What if we're in a middle of a filesystem
operation that uses GFP_NOFAIL and all of a sudden kmemleak allocation
fails and causes a panic?

                                     Pekka

> ---
>  mm/kmemleak.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 58ec86c..25e2034 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -109,6 +109,9 @@
>
>  #define BYTES_PER_POINTER      sizeof(void *)
>
> +/* GFP bitmask for kmemleak internal allocations */
> +#define GFP_KMEMLEAK_MASK      (GFP_KERNEL | GFP_ATOMIC)
> +
>  /* scanning area inside a memory block */
>  struct kmemleak_scan_area {
>        struct hlist_node node;
> @@ -462,7 +465,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
>        struct prio_tree_node *node;
>        struct stack_trace trace;
>
> -       object = kmem_cache_alloc(object_cache, gfp & ~GFP_SLAB_BUG_MASK);
> +       object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
>        if (!object) {
>                kmemleak_panic("kmemleak: Cannot allocate a kmemleak_object "
>                               "structure\n");
> @@ -636,7 +639,7 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
>                return;
>        }
>
> -       area = kmem_cache_alloc(scan_area_cache, gfp & ~GFP_SLAB_BUG_MASK);
> +       area = kmem_cache_alloc(scan_area_cache, gfp & GFP_KMEMLEAK_MASK);
>        if (!area) {
>                kmemleak_warn("kmemleak: Cannot allocate a scan area\n");
>                goto out;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
