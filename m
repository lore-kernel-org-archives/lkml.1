Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYE2KOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYE2KOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYE2KN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:13:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9703 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYE2KN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:13:57 -0400
Date: Thu, 29 May 2008 12:13:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080529101354.GU25504@kernel.dk>
References: <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080528132012.GF8255@linux.vnet.ibm.com> <20080529043852.GA15489@linux.vnet.ibm.com> <20080529062617.GH25504@kernel.dk> <20080529064202.GI25504@kernel.dk> <20080529091706.GB31816@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529091706.GB31816@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Paul E. McKenney wrote:
> On Thu, May 29, 2008 at 08:42:02AM +0200, Jens Axboe wrote:
> > On Thu, May 29 2008, Jens Axboe wrote:
> > > > But one additional question...
> > > > 
> > > > 	static void cfq_cic_free_rcu(struct rcu_head *head)
> > > > 	{
> > > > 		struct cfq_io_context *cic;
> > > > 
> > > > 		cic = container_of(head, struct cfq_io_context, rcu_head);
> > > > 
> > > > 		kmem_cache_free(cfq_ioc_pool, cic);
> > > > 		elv_ioc_count_dec(ioc_count);
> > > > 
> > > > 		if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > > > 			complete(ioc_gone);
> > > > 	}
> > > > 
> > > > Suppose that a pair of tasks both execute the elv_ioc_count_dec()
> > > > at the same time, so that all counters are now zero.  Both then
> > > > find that there is still an ioc_gone, and that the count is
> > > > now zero.  One of the tasks invokes complete(ioc_gone).  This
> > > > awakens the corresponding cfq_exit(), which now returns, getting
> > > > rid of its stack frame -- and corrupting the all_gone auto variable
> > > > that ioc_gone references.
> > > > 
> > > > Now the second task gets a big surprise when it tries to invoke
> > > > complete(ioc_gone).
> > > > 
> > > > Or is there something else that I am missing here?
> > > 
> > > No, I think that's a problem spot as well. To my knowledge, nobody has
> > > ever hit that. The anticipatory scheduler has the same code.
> > > 
> > > What we want to avoid here is making cfq_cic_free_rcu() a lot more
> > > expensive, which is why the elv_ioc_count_read() is behind that
> > > ioc_gone check. I'll need to think a bit on how to handle that
> > > better :-)
> > 
> > So how about this? Add a spinlock for checking and clearing ioc_gone
> > back to NULL. It doesn't matter if we make the ioc_gone != NULL
> > case a little more expensive, as it will only happen on cfq-iosched
> > module unload. And it seems the clearest way of making this safe.
> > The last hunk should really not be necessary, as ioc_gone wont be
> > set back to NULL before wait_for_completion() is entered.
> 
> Looks better!  I do have one scenario that seems troublesome, but
> it should be easy to fix, see below.  (Assuming it really is a
> problem, that is...)
> 
> 						Thanx, Paul
> 
> > An identical patch is needed in AS as well.
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index d01b411..32aa367 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -48,6 +48,7 @@ static struct kmem_cache *cfq_ioc_pool;
> > 
> >  static DEFINE_PER_CPU(unsigned long, ioc_count);
> >  static struct completion *ioc_gone;
> > +static DEFINE_SPINLOCK(ioc_gone_lock);
> > 
> >  #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
> >  #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
> > @@ -1177,8 +1178,19 @@ static void cfq_cic_free_rcu(struct rcu_head *head)
> >  	kmem_cache_free(cfq_ioc_pool, cic);
> >  	elv_ioc_count_dec(ioc_count);
> > 
> > -	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > -		complete(ioc_gone);
> > +	if (ioc_gone) {
> > +		/*
> > +		 * CFQ scheduler is exiting, grab exit lock and check
> > +		 * the pending io context count. If it hits zero,
> > +		 * complete ioc_gone and set it back to NULL
> > +		 */
> 
> Suppose that at this point some other CPU does the last complete().
> They have set ioc_gone to NULL, so everything is fine.  But suppose
> that in the meantime, some other CPU sets up a cfq and then starts
> tearing it down.  Then ioc_gone would be non-NULL, and we would cause
> this new teardown to end prematurely.
> 
> If this is a real problem, one way to get around it is to have a
> generation number.  We capture this before doing the elv_ioc_count_dec()
> (alas, with a memory barrier between the capture and the elv_ioc_count_dec()),
> and then check it under the lock.  If it has changed, we know someone else
> has already done the awakening for us.  Increment the generation number
> in the same place that ioc_gone is set to NULL.
> 
> Seem reasonable?

This isn't a problem, since cfq_exit() cannot be called before
all block queues in the system have been detached from CFQ.
cfq_exit() calls elv_unregister() before setting ioc_gone, so
when elv_unregister() has returned, CFQ is in its own little world.
Do we need an smp_wmb() between elv_unregister() and the ioc_gone
assignment to ensure this ordering as well? IIRC, the spin_lock
and spin_unlock in elv_unregister() isn't enough to guarentee this.
We are really down to splitting hairs now, but better safe than
sorry :-)

-- 
Jens Axboe

