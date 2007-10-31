Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbXJaEro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbXJaEro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJaErh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:47:37 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:23740 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752222AbXJaErg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:47:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2QhnnVFIoy4b1k3GJWWqRXJqYgYDq9wXHQFkGy5dm8o0x/CAmMDUnGclwrj0okRBwM2626QNokBj/GOjScujPwDBr1+5eMYSD2vN38o4Z5NmGe4N/qPWYpeWEMzKO1fmONr2Pj17JyzUk8nM18DQqQrijcG9wfjcnz6GAbL1vKg=  ;
X-YMail-OSG: KtbGpMAVM1nlcBHdgfsv4_CSXQ.LBGf6Csm80JZt_bE3cOha2SYvOdXohEKXCTERfYdl6_XM_Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 04/33] mm: allow mempool to fall back to memalloc reserves
Date: Wed, 31 Oct 2007 14:40:54 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <20071030160911.031845000@chello.nl>
In-Reply-To: <20071030160911.031845000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311440.54695.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Allow the mempool to use the memalloc reserves when all else fails and
> the allocation context would otherwise allow it.

I don't see what this is for. The whole point of when I fixed this
to *not* use the memalloc reserves is because processes that were
otherwise allowed to use those reserves, were. They should not.



> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/mempool.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/mm/mempool.c
> ===================================================================
> --- linux-2.6.orig/mm/mempool.c
> +++ linux-2.6/mm/mempool.c
> @@ -14,6 +14,7 @@
>  #include <linux/mempool.h>
>  #include <linux/blkdev.h>
>  #include <linux/writeback.h>
> +#include "internal.h"
>
>  static void add_element(mempool_t *pool, void *element)
>  {
> @@ -204,7 +205,7 @@ void * mempool_alloc(mempool_t *pool, gf
>  	void *element;
>  	unsigned long flags;
>  	wait_queue_t wait;
> -	gfp_t gfp_temp;
> +	gfp_t gfp_temp, gfp_orig = gfp_mask;
>
>  	might_sleep_if(gfp_mask & __GFP_WAIT);
>
> @@ -228,6 +229,15 @@ repeat_alloc:
>  	}
>  	spin_unlock_irqrestore(&pool->lock, flags);
>
> +	/* if we really had right to the emergency reserves try those */
> +	if (gfp_to_alloc_flags(gfp_orig) & ALLOC_NO_WATERMARKS) {
> +		if (gfp_temp & __GFP_NOMEMALLOC) {
> +			gfp_temp &= ~(__GFP_NOMEMALLOC|__GFP_NOWARN);
> +			goto repeat_alloc;
> +		} else
> +			gfp_temp |= __GFP_NOMEMALLOC|__GFP_NOWARN;
> +	}
> +
>  	/* We must not sleep in the GFP_ATOMIC case */
>  	if (!(gfp_mask & __GFP_WAIT))
>  		return NULL;
>
> --
