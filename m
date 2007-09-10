Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXIJNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXIJNjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXIJNji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:39:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:39021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114AbXIJNjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:39:37 -0400
Date: Mon, 10 Sep 2007 15:39:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc][patch] dynamic data structure switching
Message-ID: <20070910133935.GA31595@wotan.suse.de>
References: <20070902182738.GA13145@wotan.suse.de> <1189425352.21778.12.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189425352.21778.12.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 01:55:52PM +0200, Peter Zijlstra wrote:
> On Sun, 2007-09-02 at 20:27 +0200, Nick Piggin wrote:
> 
> > Index: linux-2.6/lib/dyndata.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/lib/dyndata.c
> > @@ -0,0 +1,80 @@
> > +#include <linux/dyndata.h>
> > +#include <linux/mutex.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/seqlock.h>
> > +
> > +void dyn_data_init(struct dyn_data *dd, void *cur_data)
> > +{
> > +	dd->cur = cur_data;
> > +	dd->old = NULL;
> > +	seqcount_init(&dd->resize_seq);
> > +	mutex_init(&dd->resize_mutex);
> > +}
> > +
> > +/*
> > + * Slowpath lookup. There is a resize in progress and we weren't able to
> > + * find the item we wanted in dyn_data_lookup: run the full race-free
> > + * lookup protocol.
> > + */
> > +static noinline void *dyn_data_lookup_slow(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
> > +{
> > +	void *ret;
> > +	void *cur, *old;
> > +	unsigned seq;
> > +
> > +	cur = dd->cur;
> > +	old = dd->old;
> > +
> > +	do {
> > +		seq = read_seqcount_begin(&dd->resize_seq);
> > +		ret = fn(cur, arg);
> > +		if (ret)
> > +			return ret;
> > +		if (!old)
> > +			return NULL;
> > +
> > +		ret = fn(old, arg);
> > +		if (ret)
> > +			return ret;
> > +	} while (read_seqcount_retry(&dd->resize_seq, seq));
> 
> With the seqlock protecting the whole xfer a lookup for a non-existing
> item might spin here for a very long time.
> 
> Maybe we should create this sleeping seqlock we talked and provide both
> a sleeping and non sleeping version of this lookup function.

Yeah, it isn't the best this way. One thing that could be done is to
fine grain the write-side seqlock (eg. take it once per object moved,
or have multiple seqlocks eg. per bucket). It would need some careful
measurement to see what we can get away with.


> > +	return NULL;
> > +}
> > +
> > +void *dyn_data_lookup(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
> > +{
> > +	void *ret;
> > +
> > +	rcu_read_lock();
> > +	if (likely(!dd->old))
> > +		ret = fn(dd->cur, arg);
> > +	else
> > +		ret = dyn_data_lookup_slow(dd, fn, arg);
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> > +void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new)
> > +{
> > +	int xfer_done;
> > +	void *old;
> > +
> > +	BUG_ON(!mutex_is_locked(&dd->resize_mutex));
> 
> So its up to the caller to take resize_mutex, but there is no mention of
> this requirement. Why cannot it be taken inside this function?
 
Yeah, I didn't want to document the API yet because it is to horrible :)
In the case of the dynamic pid hash, this mutex serialises resizers, and
so after you take the lock, you can check whether the hash still needs
resizing, for example (and can also do a trylock instead of a lock).


> > +	old = dd->cur;
> > +	BUG_ON(dd->old);
> > +	dd->old = old;
> > +	synchronize_rcu();
> > +	rcu_assign_pointer(dd->cur, new);
> > +	synchronize_rcu();
> > +	do {
> > +		write_seqcount_begin(&dd->resize_seq);
> > +		xfer_done = fn(old, new);
> > +		write_seqcount_end(&dd->resize_seq);
> > +	} while (!xfer_done);
> > +	dd->old = NULL;
> > +	synchronize_rcu();
> > +
> > +
> > +	return old;
> > +}
