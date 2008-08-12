Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYHLGXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYHLGXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHLGXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:23:25 -0400
Received: from mail.suse.de ([195.135.220.2]:57622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYHLGXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:23:25 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 12 Aug 2008 16:23:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18593.11340.609526.649904@notabene.brown>
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

This looks quite different to last time I looked at the code (I
think).

You now have a more structured "kmalloc_reserve" interface which
returns a flag to say if the allocation was from an emergency pool.  I
think this will be a distinct improvement at the call sites, though I
haven't looked at them yet. :-)

> +
> +struct mem_reserve {
> +	struct mem_reserve *parent;
> +	struct list_head children;
> +	struct list_head siblings;
> +
> +	const char *name;
> +
> +	long pages;
> +	long limit;
> +	long usage;
> +	spinlock_t lock;	/* protects limit and usage */
                                            ^^^^^
> +
> +	wait_queue_head_t waitqueue;
> +};

....
> +static void __calc_reserve(struct mem_reserve *res, long pages, long limit)
> +{
> +	unsigned long flags;
> +
> +	for ( ; res; res = res->parent) {
> +		res->pages += pages;
> +
> +		if (limit) {
> +			spin_lock_irqsave(&res->lock, flags);
> +			res->limit += limit;
> +			spin_unlock_irqrestore(&res->lock, flags);
> +		}
> +	}
> +}

I cannot figure out why the spinlock is being used to protect updates
to 'limit'.
As far as I can see, mem_reserve_mutex already protects all those
updates.
Certainly we need the spinlock for usage, but why for limit??

> +
> +void *___kmalloc_reserve(size_t size, gfp_t flags, int node, void *ip,
> +			 struct mem_reserve *res, int *emerg)
> +{
....
> +	if (emerg)
> +		*emerg |= 1;

Why not just

	if (emerg)
		*emerg = 1.

I can't we where '*emerg' can have any value but 0 or 1, so the '|' is
pointless ???

Thanks,
NeilBrown
