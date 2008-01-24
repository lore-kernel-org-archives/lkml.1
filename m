Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYAXHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYAXHgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYAXHgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:36:11 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7736 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYAXHgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:36:10 -0500
Date: Thu, 24 Jan 2008 08:36:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 4/6] block: cfq: make the io contect sharing lockless
Message-ID: <20080124073606.GN6258@kernel.dk>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com> <1200995361-24001-5-git-send-email-jens.axboe@oracle.com> <20080123140819.d53bc976.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123140819.d53bc976.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23 2008, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 10:49:19 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > The io context sharing introduced a per-ioc spinlock, that would protect
> > the cfq io context lookup. That is a regression from the original, since
> > we never needed any locking there because the ioc/cic were process private.
> > 
> > The cic lookup is changed from an rbtree construct to a radix tree, which
> > we can then use RCU to make the reader side lockless. That is the performance
> > critical path, modifying the radix tree is only done on process creation
> > (when that process first does IO, actually) and on process exit (if that
> > process has done IO).
> 
> Perhaps Paul would review the rcu usage here sometime?

That would indeed be awesome :-)

> > +/*
> > + * Add cic into ioc, using cfqd as the search key. This enables us to lookup
> > + * the process specific cfq io context when entered from the block layer.
> > + * Also adds the cic to a per-cfqd list, used when this queue is removed.
> > + */
> > +static inline int
> 
> There's a lot of pointless inlining in there.

Will kill.

> > +++ b/block/ll_rw_blk.c
> > @@ -3831,6 +3831,16 @@ int __init blk_dev_init(void)
> >  	return 0;
> >  }
> >  
> > +static void cfq_dtor(struct io_context *ioc)
> > +{
> > +	struct cfq_io_context *cic[1];
> > +	int r;
> > +
> > +	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
> > +	if (r > 0)
> > +		cic[0]->dtor(ioc);
> > +}
> 
> Some comments here might help others who are wondering why we can't just
> use radix_tree_lookup().

Sure, will add a comment.

> > @@ -3900,7 +3911,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
> >  		ret->last_waited = jiffies; /* doesn't matter... */
> >  		ret->nr_batch_requests = 0; /* because this is 0 */
> >  		ret->aic = NULL;
> > -		ret->cic_root.rb_node = NULL;
> > +		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
> 
> Did this need to be atomic?

It's actually only ever used with a radix_tree_preload() where the
proper gfp mask is passed, the actual radix_tree_insert() is done under
lock protecting the tree.

-- 
Jens Axboe

