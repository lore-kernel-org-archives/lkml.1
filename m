Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbZJOTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbZJOTAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZJOTAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:00:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49125 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbZJOTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:00:06 -0400
Message-ID: <4AD770FB.5030104@cs.helsinki.fi>
Date: Thu, 15 Oct 2009 21:59:07 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] kmemleak: Do not use off-slab management with SLAB_NOLEAKTRACE
References: <20091014153146.8955.19964.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091014153146.8955.19964.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas wrote:
> With the slab allocator, if off-slab management is enabled for the
> kmem_caches used by kmemleak, it leads to recursive calls into
> kmemleak_alloc(). Off-slab management can be triggered by other config
> options increasing the slab size, e.g. DEBUG_PAGEALLOC.
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Forcing slabs to use on-slab management is pretty bad from memory 
consumption point of view. Wouldn't it be better to annotate the 
recursive calls somehow?

			Pekka

> ---
>  mm/slab.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7dfa481..646db30 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2261,9 +2261,11 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  	/*
>  	 * Determine if the slab management is 'on' or 'off' slab.
>  	 * (bootstrapping cannot cope with offslab caches so don't do
> -	 * it too early on.)
> +	 * it too early on. Always use on-slab management when
> +	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
>  	 */
> -	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init)
> +	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
> +	    !(flags & SLAB_NOLEAKTRACE))
>  		/*
>  		 * Size is large, assume best to place the slab management obj
>  		 * off-slab (should allow better packing of objs).
> 

