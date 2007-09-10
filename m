Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXIJL4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXIJL4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbXIJL4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:56:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48756 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbXIJL4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:56:01 -0400
Subject: Re: [rfc][patch] dynamic data structure switching
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070902182738.GA13145@wotan.suse.de>
References: <20070902182738.GA13145@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 13:55:52 +0200
Message-Id: <1189425352.21778.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 20:27 +0200, Nick Piggin wrote:

> Index: linux-2.6/lib/dyndata.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/lib/dyndata.c
> @@ -0,0 +1,80 @@
> +#include <linux/dyndata.h>
> +#include <linux/mutex.h>
> +#include <linux/rcupdate.h>
> +#include <linux/seqlock.h>
> +
> +void dyn_data_init(struct dyn_data *dd, void *cur_data)
> +{
> +	dd->cur = cur_data;
> +	dd->old = NULL;
> +	seqcount_init(&dd->resize_seq);
> +	mutex_init(&dd->resize_mutex);
> +}
> +
> +/*
> + * Slowpath lookup. There is a resize in progress and we weren't able to
> + * find the item we wanted in dyn_data_lookup: run the full race-free
> + * lookup protocol.
> + */
> +static noinline void *dyn_data_lookup_slow(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
> +{
> +	void *ret;
> +	void *cur, *old;
> +	unsigned seq;
> +
> +	cur = dd->cur;
> +	old = dd->old;
> +
> +	do {
> +		seq = read_seqcount_begin(&dd->resize_seq);
> +		ret = fn(cur, arg);
> +		if (ret)
> +			return ret;
> +		if (!old)
> +			return NULL;
> +
> +		ret = fn(old, arg);
> +		if (ret)
> +			return ret;
> +	} while (read_seqcount_retry(&dd->resize_seq, seq));

With the seqlock protecting the whole xfer a lookup for a non-existing
item might spin here for a very long time.

Maybe we should create this sleeping seqlock we talked and provide both
a sleeping and non sleeping version of this lookup function.

> +	return NULL;
> +}
> +
> +void *dyn_data_lookup(struct dyn_data *dd, dd_lookup_fn fn, void *arg)
> +{
> +	void *ret;
> +
> +	rcu_read_lock();
> +	if (likely(!dd->old))
> +		ret = fn(dd->cur, arg);
> +	else
> +		ret = dyn_data_lookup_slow(dd, fn, arg);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
> +void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new)
> +{
> +	int xfer_done;
> +	void *old;
> +
> +	BUG_ON(!mutex_is_locked(&dd->resize_mutex));

So its up to the caller to take resize_mutex, but there is no mention of
this requirement. Why cannot it be taken inside this function?

> +	old = dd->cur;
> +	BUG_ON(dd->old);
> +	dd->old = old;
> +	synchronize_rcu();
> +	rcu_assign_pointer(dd->cur, new);
> +	synchronize_rcu();
> +	do {
> +		write_seqcount_begin(&dd->resize_seq);
> +		xfer_done = fn(old, new);
> +		write_seqcount_end(&dd->resize_seq);
> +	} while (!xfer_done);
> +	dd->old = NULL;
> +	synchronize_rcu();
> +
> +
> +	return old;
> +}
> Index: linux-2.6/include/linux/dyndata.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/dyndata.h
> @@ -0,0 +1,94 @@
> +#ifndef __DYNDATA_H__
> +#define __DYNDATA_H__
> +

<snip>

> +
> +#include <linux/mutex.h>
> +#include <linux/seqlock.h>
> +
> +struct dyn_data {
> +	void *cur;
> +	void *old;
> +	seqcount_t resize_seq;
> +	struct mutex resize_mutex;
> +};
> +
> +typedef void *(dd_lookup_fn)(void *dstruct, void *arg);
> +typedef int (dd_transfer_fn)(void *old_ds, void *new_ds);
> +
> +void dyn_data_init(struct dyn_data *dd, void *cur_data);
> +void *dyn_data_lookup(struct dyn_data *dd, dd_lookup_fn fn, void *arg);
> +void *dyn_data_replace(struct dyn_data *dd, dd_transfer_fn fn, void *new);
> +
> +static inline void *dyn_data_current_dstruct(struct dyn_data *dd)
> +{
> +	return dd->cur;
> +}
> +
> +#endif


