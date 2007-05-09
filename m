Return-Path: <linux-kernel-owner+w=401wt.eu-S1032835AbXEIC5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032835AbXEIC5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032675AbXEIC44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:56:56 -0400
Received: from waste.org ([66.93.16.53]:47461 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032664AbXEIC4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:56:55 -0400
Date: Tue, 8 May 2007 21:56:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509025634.GC11115@waste.org>
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070508.185141.85412154.davem@davemloft.net> <46412BB5.1060605@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46412BB5.1060605@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:02:29PM +1000, Nick Piggin wrote:
> BTW, we _really_ should be doing RCU properly in slob, because you
> technically can't noop RCU on UP (even though the current users may be
> safe...).

Thanks. Hugh was pretty convinced it was unneeded:

http://marc.info/?l=linux-mm&m=116413907023393&w=2

And since I didn't care much about the SMP case, I didn't pursue it.

This almost looks reasonable. I think HW_ALIGN | RCU is going to make
it break though:

> +	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU))
> +		b += sizeof(struct slob_rcu);
> +

That could be dealt with by putting the slob_rcu at the end of the
object and having the RCU helper function use ->size to work backward
to the actual pointer.

>  void kmem_cache_free(struct kmem_cache *c, void *b)
>  {
>  	if (c->dtor)
>  		c->dtor(b, c, 0);

I think if we want RCU to actually work, we want to run ->dtor in
__kmem_cache_free?

> -	if (c->size < PAGE_SIZE)
> -		slob_free(b, c->size);
> -	else
> -		free_pages((unsigned long)b, find_order(c->size));
> +	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
> +		struct slob_rcu *slob_rcu;
> +		b -= sizeof(struct slob_rcu);
> +		slob_rcu = b;
> +		slob_rcu->size = c->size;

Which means just store c in the header^Wfooter, then we can retrieve the size
and the dtor in the RCU helper.

We might as well add slab_is_available and make the damn thing work on
sparsemem again too.

-- 
Mathematics is the supreme nostalgia of our time.
