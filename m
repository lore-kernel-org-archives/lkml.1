Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYAXQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYAXQnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYAXQnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:43:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51598 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbYAXQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:43:32 -0500
Date: Thu, 24 Jan 2008 08:42:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       knikanth@novell.com
Subject: Re: [PATCH 4/6] block: cfq: make the io contect sharing lockless
Message-ID: <20080124164252.GB14706@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com> <1200995361-24001-5-git-send-email-jens.axboe@oracle.com> <20080123140819.d53bc976.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123140819.d53bc976.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 02:08:19PM -0800, Andrew Morton wrote:
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

I will take a look -- long plane trip about 36 hours from now.  ;-)

							Thanx, Paul

> > +/*
> > + * Add cic into ioc, using cfqd as the search key. This enables us to lookup
> > + * the process specific cfq io context when entered from the block layer.
> > + * Also adds the cic to a per-cfqd list, used when this queue is removed.
> > + */
> > +static inline int
> 
> There's a lot of pointless inlining in there.
> 
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
> 
> > +static void cfq_exit(struct io_context *ioc)
> > +{
> > +	struct cfq_io_context *cic[1];
> > +	int r;
> > +
> > +	rcu_read_lock();
> > +	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
> > +	rcu_read_unlock();
> > +
> > +	if (r > 0)
> > +		cic[0]->exit(ioc);
> > +}
> 
> ditto.
> 
> >  /* Called by the exitting task */
> >  void exit_io_context(void)
> >  {
> >  	struct io_context *ioc;
> > -	struct cfq_io_context *cic;
> >  
> >  	task_lock(current);
> >  	ioc = current->io_context;
> > @@ -3876,11 +3891,7 @@ void exit_io_context(void)
> >  	if (atomic_dec_and_test(&ioc->nr_tasks)) {
> >  		if (ioc->aic && ioc->aic->exit)
> >  			ioc->aic->exit(ioc->aic);
> > -		if (ioc->cic_root.rb_node != NULL) {
> > -			cic = rb_entry(rb_first(&ioc->cic_root),
> > -				struct cfq_io_context, rb_node);
> > -			cic->exit(ioc);
> > -		}
> > +		cfq_exit(ioc);
> >  
> >  		put_io_context(ioc);
> >  	}
> > @@ -3900,7 +3911,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
> >  		ret->last_waited = jiffies; /* doesn't matter... */
> >  		ret->nr_batch_requests = 0; /* because this is 0 */
> >  		ret->aic = NULL;
> > -		ret->cic_root.rb_node = NULL;
> > +		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
> 
> Did this need to be atomic?
> 
> 
