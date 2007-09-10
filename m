Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbXIJUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbXIJUs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbXIJUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:48:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:59350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbXIJUsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:48:42 -0400
Date: Mon, 10 Sep 2007 22:48:40 +0200
From: Nick Piggin <npiggin@suse.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic data structure switching
Message-ID: <20070910204840.GA5202@wotan.suse.de>
References: <20070910165814.GA347@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910165814.GA347@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:58:14PM +0400, Oleg Nesterov wrote:
> Nick Piggin wrote:
> >
> > +void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new)
> > +{
> > +	int xfer_done;
> > +	void *old;
> > +
> > +	BUG_ON(!mutex_is_locked(&dd->resize_mutex));
> > +	old = dd->cur;
> > +	BUG_ON(dd->old);
> > +	dd->old = old;
> > +	synchronize_rcu();
> > +	rcu_assign_pointer(dd->cur, new);
> 
> I think this all is correct, but I have a somewhat offtopic question, hopefully
> you can help.
> 
> Suppose that we have a global "pid_t NR = 0", and another CPU does
> 
> 	pid = alloc_pid();
> 	wmb();
> 	NR = pid->nr;
> 
> Suppose that this CPU sees dd->cur == new, and adds the new item to it.
> 
> Now, yet another CPU does:
> 
> 	nr = NR;
> 	rmb();
> 	BUG_ON(nr && !find_pind(nr));
> 
> dyn_data_replace() didn't do synchronize_rcu() yet.

Hmm, it would have to have done synchronize_rcu() otherwise the first could
not see that dd->cur == new...? Or maybe you mean it hasn't done a second
synchronize_rcu()? I'll assume you mean that.


> The question is: how it is
> possible to "prove" that the BUG_ON() above can't happen? IOW, why find_pind()
> above must also see dd->cur == new if it sees NR != 0 ?

Hmm, that's a very good question. I was in the middle of starting to write
why I thought it would work, but after thinking about it more, I'm not sure
that it is correct.

I think we have only pairwise barrier semantics, and not causal semantics
(so the write to dd->cur from the 3rd CPU can be seen in any order by
the others, regardless of what barriers _they_ perform).

So you do have a problem. We'd need to do another synchronize_rcu here to
ensure that dd->cur gets propogated out to all CPUs before the first
insert happens. This shouldn't be too hard (simplest way is probably to use
a low-bit in the pointer).
 

> Once again, I believe this is true, but I can't find a "good" explanation for
> myself. To simplify the example above, consider:
> 
> 		A = B = X = 0;
> 		P = Q = &A;
> 
> CPU_1		CPU_2		CPU_3
> 
> P = &B;		*P = 1;		if (X) {
> 		wmb();			rmb();
> 		X = 1;			BUG_ON(*P != 1 && *Q != 1);
> 				}
> 
> So, it is not possible that CPU_2 sees P == &B, but CPU_3 sees P == &A in this
> case, yes?
> 
> It looks "obvious" that rmb() guarantees that CPU_3 must see the new value if
> any other CPU (CPU_2) already saw it "before", but I can't derive this from the
> "all the LOAD operations specified before the barrier will appear to happen
>  before all the LOAD operations specified after the barrier" definition.

I believe this can go out of order (according to Linux memory model, I don't
know if any actual implementations will do this). The invalidations from CPU1
and 2 may reach CPU3 at different times I think.

Good point. Thanks.
