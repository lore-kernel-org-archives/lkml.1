Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbYKTTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbYKTTab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYKTTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:30:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:51276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbYKTTaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f+PZc81R+YCvH95Cxqn/EIH/MpoyQgjYM/ebW25b1zdF17NnA841YEqa7yAfh/kOt5
         axBQS/rLLYQT3fmkS9Lq++RWm5LhaxERn88fIU5AiO1JeLebaT0jKo/hlS4v/RuTxsHM
         WFGVVa25BVifhC3XySgTS0OuzXcU6d1IQF/Ic=
Message-ID: <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
Date: Thu, 20 Nov 2008 21:30:08 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory allocation/freeing hooks
Cc: linux-kernel@vger.kernel.org, "Matt Mackall" <mpm@selenic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 71763d807a0d1a1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, Nov 20, 2008 at 1:30 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from
> kmalloc/kfree, kmem_cache_(alloc|free), vmalloc/vfree etc.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

[snip]

> @@ -2610,6 +2611,9 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
>                /* Slab management obj is off-slab. */
>                slabp = kmem_cache_alloc_node(cachep->slabp_cache,
>                                              local_flags & ~GFP_THISNODE, nodeid);
> +               /* only scan the list member to avoid false negatives */
> +               memleak_scan_area(slabp, offsetof(struct slab, list),
> +                                 sizeof(struct list_head));

I find this comment somewhat confusing. Does it mean we _must_ scan
the list members to avoid false negatives (i.e. leaks that happened
but were not reported) or that if we scan the whole of struct slab, we
get false negatives?

>                if (!slabp)
>                        return NULL;
>        } else {

Other than that, the SLAB, SLUB, and SLOB hooks look good to me. You
might want to split up the patch a bit and CC Matt for the SLOB and
Christoph for the SLUB hooks and me for all of the three.
