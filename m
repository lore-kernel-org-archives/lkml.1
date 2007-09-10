Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbXIJQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbXIJQzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXIJQzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:55:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46684 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbXIJQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:55:44 -0400
Date: Mon, 10 Sep 2007 20:58:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Nick Piggin <npiggin@suse.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic data structure switching
Message-ID: <20070910165814.GA347@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>
> +void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new)
> +{
> +	int xfer_done;
> +	void *old;
> +
> +	BUG_ON(!mutex_is_locked(&dd->resize_mutex));
> +	old = dd->cur;
> +	BUG_ON(dd->old);
> +	dd->old = old;
> +	synchronize_rcu();
> +	rcu_assign_pointer(dd->cur, new);

I think this all is correct, but I have a somewhat offtopic question, hopefully
you can help.

Suppose that we have a global "pid_t NR = 0", and another CPU does

	pid = alloc_pid();
	wmb();
	NR = pid->nr;

Suppose that this CPU sees dd->cur == new, and adds the new item to it.

Now, yet another CPU does:

	nr = NR;
	rmb();
	BUG_ON(nr && !find_pind(nr));

dyn_data_replace() didn't do synchronize_rcu() yet. The question is: how it is
possible to "prove" that the BUG_ON() above can't happen? IOW, why find_pind()
above must also see dd->cur == new if it sees NR != 0 ?

Once again, I believe this is true, but I can't find a "good" explanation for
myself. To simplify the example above, consider:

		A = B = X = 0;
		P = Q = &A;

CPU_1		CPU_2		CPU_3

P = &B;		*P = 1;		if (X) {
		wmb();			rmb();
		X = 1;			BUG_ON(*P != 1 && *Q != 1);
				}

So, it is not possible that CPU_2 sees P == &B, but CPU_3 sees P == &A in this
case, yes?

It looks "obvious" that rmb() guarantees that CPU_3 must see the new value if
any other CPU (CPU_2) already saw it "before", but I can't derive this from the
"all the LOAD operations specified before the barrier will appear to happen
 before all the LOAD operations specified after the barrier" definition.

Thanks,

Oleg.

