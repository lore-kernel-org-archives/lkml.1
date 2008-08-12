Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbYHLHqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbYHLHqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYHLHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:46:28 -0400
Received: from ns.suse.de ([195.135.220.2]:36548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYHLHq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:46:27 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 12 Aug 2008 17:46:14 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18593.16326.701825.625469@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 12/30] mm: memory reserve management
In-Reply-To: message from Peter Zijlstra on Thursday July 24
References: <20080724140042.408642539@chello.nl>
	<20080724141530.127530749@chello.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 24, a.p.zijlstra@chello.nl wrote:
> Generic reserve management code. 
> 
> It provides methods to reserve and charge. Upon this, generic alloc/free style
> reserve pools could be build, which could fully replace mempool_t
> functionality.

More comments on this patch .....

> +void *___kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> +			 struct mem_reserve *res, int *emerg);
> +
> +static inline
> +void *__kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> +			struct mem_reserve *res, int *emerg)
> +{
> +	void *obj;
> +
> +	obj = __kmalloc_node_track_caller(size,
> +			flags | __GFP_NOMEMALLOC | __GFP_NOWARN, node, ip);
> +	if (!obj)
> +		obj = ___kmalloc_reserve(size, flags, node, ip, res, emerg);
> +
> +	return obj;
> +}
> +
> +#define kmalloc_reserve(size, gfp, node, res, emerg) 			\
> +	__kmalloc_reserve(size, gfp, node, 				\
> +			  __builtin_return_address(0), res, emerg)
> +
.....
> +/*
> + * alloc wrappers
> + */
> +
> +void *___kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> +			 struct mem_reserve *res, int *emerg)
> +{
> +	void *obj;
> +	gfp_t gfp;
> +
> +	gfp = flags | __GFP_NOMEMALLOC | __GFP_NOWARN;
> +	obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> +
> +	if (obj || !(gfp_to_alloc_flags(flags) & ALLOC_NO_WATERMARKS))
> +		goto out;
> +
> +	if (res && !mem_reserve_kmalloc_charge(res, size)) {
> +		if (!(flags & __GFP_WAIT))
> +			goto out;
> +
> +		wait_event(res->waitqueue,
> +				mem_reserve_kmalloc_charge(res, size));
> +
> +		obj = __kmalloc_node_track_caller(size, gfp, node, ip);
> +		if (obj) {
> +			mem_reserve_kmalloc_charge(res, -size);
> +			goto out;
> +		}
> +	}
> +
> +	obj = __kmalloc_node_track_caller(size, flags, node, ip);
> +	WARN_ON(!obj);
> +	if (emerg)
> +		*emerg |= 1;
> +
> +out:
> +	return obj;
> +}

Two comments to be precise.

1/ __kmalloc_reserve attempts a __GFP_NOMEMALLOC allocation, and then
   if that fails, ___kmalloc_reserve immediately tries again.
   Is that pointless?  Should the second one be removed?

2/ mem_reserve_kmalloc_charge appears to assume that the 'mem_reserve'
   has been 'connected' and so is active.
   While callers probably only set GFP_MEMALLOC in cases where the
   mem_reserve is connected, ALLOC_NO_WATERMARKS could get via
   PF_MEMALLOC so we could end up calling mem_reserve_kmalloc_charge
   when the mem_reserve is not connected.
   That seems to be 'odd' at least.
   It might even be 'wrong' as mem_reserve_connect doesn't add the
   usage of the child to the parent - only the ->pages and ->limit.

   What is your position on this?  Mine is "still slightly confused".

NeilBrown

  
