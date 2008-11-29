Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYK2LqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYK2LqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYK2LqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:46:12 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:15724 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2LqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Cxhc2zn8C/93eqH0TzjlCGfmDygGRtxQ6npY6KBcD/WM24d9NU8s0MVWbEjd66Ijcm
         F8sDGBfbSuoJbnxSft6WIODMNaLXvvULk/mrs/WaesFj5je0QRXjYTRNq8Q350Jxq/9N
         JZaEWw0Fenhq/qMvyZcTMG+UthOn7lSLGYntQ=
Message-ID: <84144f020811290346t313ec724j1aacc8685ea45f5a@mail.gmail.com>
Date: Sat, 29 Nov 2008 13:46:10 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing hooks
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20081129104334.16726.54138.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104334.16726.54138.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 42bffb8e502012a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Please use the penberg@cs.helsinki.fi email address when cc'ing me.

On Sat, Nov 29, 2008 at 12:43 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from the
> slub allocator.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/slub.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 7ad489a..b683571 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -18,6 +18,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
> +#include <linux/memleak.h>
>  #include <linux/mempolicy.h>
>  #include <linux/ctype.h>
>  #include <linux/debugobjects.h>
> @@ -140,7 +141,7 @@
>  * Set of flags that will prevent slab merging
>  */
>  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> -               SLAB_TRACE | SLAB_DESTROY_BY_RCU)
> +               SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
>
>  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
>                SLAB_CACHE_DMA)
> @@ -1608,6 +1609,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
>        if (unlikely((gfpflags & __GFP_ZERO) && object))
>                memset(object, 0, objsize);
>
> +       memleak_alloc_recursive(object, objsize, 1, s->flags);
>        return object;
>  }
>
> @@ -1710,6 +1712,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
>        struct kmem_cache_cpu *c;
>        unsigned long flags;
>
> +       memleak_free_recursive(x, s->flags);
>        local_irq_save(flags);
>        c = get_cpu_slab(s, smp_processor_id());
>        debug_check_no_locks_freed(object, c->objsize);
>
>
