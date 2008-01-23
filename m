Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYAWWK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYAWWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYAWWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:08:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216AbYAWWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:08:38 -0500
Date: Wed, 23 Jan 2008 14:08:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com, jens.axboe@oracle.com,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 4/6] block: cfq: make the io contect sharing lockless
Message-Id: <20080123140819.d53bc976.akpm@linux-foundation.org>
In-Reply-To: <1200995361-24001-5-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
	<1200995361-24001-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 10:49:19 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> The io context sharing introduced a per-ioc spinlock, that would protect
> the cfq io context lookup. That is a regression from the original, since
> we never needed any locking there because the ioc/cic were process private.
> 
> The cic lookup is changed from an rbtree construct to a radix tree, which
> we can then use RCU to make the reader side lockless. That is the performance
> critical path, modifying the radix tree is only done on process creation
> (when that process first does IO, actually) and on process exit (if that
> process has done IO).

Perhaps Paul would review the rcu usage here sometime?

> +/*
> + * Add cic into ioc, using cfqd as the search key. This enables us to lookup
> + * the process specific cfq io context when entered from the block layer.
> + * Also adds the cic to a per-cfqd list, used when this queue is removed.
> + */
> +static inline int

There's a lot of pointless inlining in there.

> +++ b/block/ll_rw_blk.c
> @@ -3831,6 +3831,16 @@ int __init blk_dev_init(void)
>  	return 0;
>  }
>  
> +static void cfq_dtor(struct io_context *ioc)
> +{
> +	struct cfq_io_context *cic[1];
> +	int r;
> +
> +	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
> +	if (r > 0)
> +		cic[0]->dtor(ioc);
> +}

Some comments here might help others who are wondering why we can't just
use radix_tree_lookup().

> +static void cfq_exit(struct io_context *ioc)
> +{
> +	struct cfq_io_context *cic[1];
> +	int r;
> +
> +	rcu_read_lock();
> +	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
> +	rcu_read_unlock();
> +
> +	if (r > 0)
> +		cic[0]->exit(ioc);
> +}

ditto.

>  /* Called by the exitting task */
>  void exit_io_context(void)
>  {
>  	struct io_context *ioc;
> -	struct cfq_io_context *cic;
>  
>  	task_lock(current);
>  	ioc = current->io_context;
> @@ -3876,11 +3891,7 @@ void exit_io_context(void)
>  	if (atomic_dec_and_test(&ioc->nr_tasks)) {
>  		if (ioc->aic && ioc->aic->exit)
>  			ioc->aic->exit(ioc->aic);
> -		if (ioc->cic_root.rb_node != NULL) {
> -			cic = rb_entry(rb_first(&ioc->cic_root),
> -				struct cfq_io_context, rb_node);
> -			cic->exit(ioc);
> -		}
> +		cfq_exit(ioc);
>  
>  		put_io_context(ioc);
>  	}
> @@ -3900,7 +3911,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
>  		ret->last_waited = jiffies; /* doesn't matter... */
>  		ret->nr_batch_requests = 0; /* because this is 0 */
>  		ret->aic = NULL;
> -		ret->cic_root.rb_node = NULL;
> +		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);

Did this need to be atomic?


