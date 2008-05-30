Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYE3NQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYE3NQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYE3NQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:16:44 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:42339 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYE3NQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:16:43 -0400
Date: Fri, 30 May 2008 06:16:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080530131628.GA8624@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080529043852.GA15489@linux.vnet.ibm.com> <20080529062617.GH25504@kernel.dk> <20080529064202.GI25504@kernel.dk> <20080529091706.GB31816@linux.vnet.ibm.com> <20080529101354.GU25504@kernel.dk> <20080529112553.GE31816@linux.vnet.ibm.com> <20080529114431.GZ25504@kernel.dk> <20080529121141.GH31816@linux.vnet.ibm.com> <20080529121352.GC25504@kernel.dk> <20080530110410.GA20000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530110410.GA20000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 04:04:10AM -0700, Paul E. McKenney wrote:
> On Thu, May 29, 2008 at 02:13:53PM +0200, Jens Axboe wrote:
> > On Thu, May 29 2008, Paul E. McKenney wrote:
> > > On Thu, May 29, 2008 at 01:44:31PM +0200, Jens Axboe wrote:
> > > > On Thu, May 29 2008, Paul E. McKenney wrote:
> > > > > On Thu, May 29, 2008 at 12:13:54PM +0200, Jens Axboe wrote:
> > > > > > On Thu, May 29 2008, Paul E. McKenney wrote:
> > > > > > > On Thu, May 29, 2008 at 08:42:02AM +0200, Jens Axboe wrote:
> > > > > > > > On Thu, May 29 2008, Jens Axboe wrote:
> > > > > > > > > > But one additional question...
> > > > > > > > > > 
> > > > > > > > > > 	static void cfq_cic_free_rcu(struct rcu_head *head)
> > > > > > > > > > 	{
> > > > > > > > > > 		struct cfq_io_context *cic;
> > > > > > > > > > 
> > > > > > > > > > 		cic = container_of(head, struct cfq_io_context, rcu_head);
> > > > > > > > > > 
> > > > > > > > > > 		kmem_cache_free(cfq_ioc_pool, cic);
> > > > > > > > > > 		elv_ioc_count_dec(ioc_count);
> > > > > > > > > > 
> > > > > > > > > > 		if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > > > > > > > > > 			complete(ioc_gone);
> > > > > > > > > > 	}
> > > > > > > > > > 
> > > > > > > > > > Suppose that a pair of tasks both execute the elv_ioc_count_dec()
> > > > > > > > > > at the same time, so that all counters are now zero.  Both then
> > > > > > > > > > find that there is still an ioc_gone, and that the count is
> > > > > > > > > > now zero.  One of the tasks invokes complete(ioc_gone).  This
> > > > > > > > > > awakens the corresponding cfq_exit(), which now returns, getting
> > > > > > > > > > rid of its stack frame -- and corrupting the all_gone auto variable
> > > > > > > > > > that ioc_gone references.
> > > > > > > > > > 
> > > > > > > > > > Now the second task gets a big surprise when it tries to invoke
> > > > > > > > > > complete(ioc_gone).
> > > > > > > > > > 
> > > > > > > > > > Or is there something else that I am missing here?
> > > > > > > > > 
> > > > > > > > > No, I think that's a problem spot as well. To my knowledge, nobody has
> > > > > > > > > ever hit that. The anticipatory scheduler has the same code.
> > > > > > > > > 
> > > > > > > > > What we want to avoid here is making cfq_cic_free_rcu() a lot more
> > > > > > > > > expensive, which is why the elv_ioc_count_read() is behind that
> > > > > > > > > ioc_gone check. I'll need to think a bit on how to handle that
> > > > > > > > > better :-)
> > > > > > > > 
> > > > > > > > So how about this? Add a spinlock for checking and clearing ioc_gone
> > > > > > > > back to NULL. It doesn't matter if we make the ioc_gone != NULL
> > > > > > > > case a little more expensive, as it will only happen on cfq-iosched
> > > > > > > > module unload. And it seems the clearest way of making this safe.
> > > > > > > > The last hunk should really not be necessary, as ioc_gone wont be
> > > > > > > > set back to NULL before wait_for_completion() is entered.
> > > > > > > 
> > > > > > > Looks better!  I do have one scenario that seems troublesome, but
> > > > > > > it should be easy to fix, see below.  (Assuming it really is a
> > > > > > > problem, that is...)
> > > > > > > 
> > > > > > > 						Thanx, Paul
> > > > > > > 
> > > > > > > > An identical patch is needed in AS as well.
> > > > > > > > 
> > > > > > > > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > > > > > > > index d01b411..32aa367 100644
> > > > > > > > --- a/block/cfq-iosched.c
> > > > > > > > +++ b/block/cfq-iosched.c
> > > > > > > > @@ -48,6 +48,7 @@ static struct kmem_cache *cfq_ioc_pool;
> > > > > > > > 
> > > > > > > >  static DEFINE_PER_CPU(unsigned long, ioc_count);
> > > > > > > >  static struct completion *ioc_gone;
> > > > > > > > +static DEFINE_SPINLOCK(ioc_gone_lock);
> > > > > > > > 
> > > > > > > >  #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
> > > > > > > >  #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
> > > > > > > > @@ -1177,8 +1178,19 @@ static void cfq_cic_free_rcu(struct rcu_head *head)
> > > > > > > >  	kmem_cache_free(cfq_ioc_pool, cic);
> > > > > > > >  	elv_ioc_count_dec(ioc_count);
> > > > > > > > 
> > > > > > > > -	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > > > > > > > -		complete(ioc_gone);
> > > > > > > > +	if (ioc_gone) {
> > > > > > > > +		/*
> > > > > > > > +		 * CFQ scheduler is exiting, grab exit lock and check
> > > > > > > > +		 * the pending io context count. If it hits zero,
> > > > > > > > +		 * complete ioc_gone and set it back to NULL
> > > > > > > > +		 */
> > > > > > > 
> > > > > > > Suppose that at this point some other CPU does the last complete().
> > > > > > > They have set ioc_gone to NULL, so everything is fine.  But suppose
> > > > > > > that in the meantime, some other CPU sets up a cfq and then starts
> > > > > > > tearing it down.  Then ioc_gone would be non-NULL, and we would cause
> > > > > > > this new teardown to end prematurely.
> > > > > > > 
> > > > > > > If this is a real problem, one way to get around it is to have a
> > > > > > > generation number.  We capture this before doing the elv_ioc_count_dec()
> > > > > > > (alas, with a memory barrier between the capture and the elv_ioc_count_dec()),
> > > > > > > and then check it under the lock.  If it has changed, we know someone else
> > > > > > > has already done the awakening for us.  Increment the generation number
> > > > > > > in the same place that ioc_gone is set to NULL.
> > > > > > > 
> > > > > > > Seem reasonable?
> > > > > > 
> > > > > > This isn't a problem, since cfq_exit() cannot be called before
> > > > > > all block queues in the system have been detached from CFQ.
> > > > > 
> > > > > And once all block queues have been detached, no future block queues
> > > > > can ever be attached again?  Or perhaps a better way of putting it,
> > > > > once CFQ has been shut down, can it be restarted without rebooting
> > > > > the system?  If it can be restarted without reboot, then I do not
> > > > > yet see how the scenario above is avoided.
> > > > 
> > > > Certainly, you can modprobe cfq-iosched and switch any device to cfq
> > > > again. But I really don't see the problem in this case. Once CFQ
> > > > has exited, all tasks are detached from CFQ. They have to be, or
> > > > we could not unload the module.
> > > 
> > > Ah, OK -- so we cannot reload the module until the earlier
> > > instantiation has been unloaded, which cannot happen until everyone
> > > has returned from any code in the CFQ module.  If it is linked
> > > directly into the kernel, it can only be "unloaded" by bringing the
> > > system down.
> > 
> > Right!
> > 
> > > Sorry for my confusion!
> > > 
> > > This approach looks good to me.
> > 
> > Pheew good, I was starting to have a brain melt down as well :-)
> 
> OK, my apologies in advance, but one more thing to consider...
> 
> > @@ -1177,8 +1178,19 @@ static void cfq_cic_free_rcu(struct rcu_head *head)
> >  	kmem_cache_free(cfq_ioc_pool, cic);
> >  	elv_ioc_count_dec(ioc_count);
> 
> Need an smp_mb() here, and ...
> 
> > 
> > -	if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > -		complete(ioc_gone);
> > +	if (ioc_gone) {
> > +		/*
> > +		 * CFQ scheduler is exiting, grab exit lock and check
> > +		 * the pending io context count. If it hits zero,
> > +		 * complete ioc_gone and set it back to NULL
> > +		 */
> > +		spin_lock(&ioc_gone_lock);
> > +		if (ioc_gone && !elv_ioc_count_read(ioc_count)) {
> > +			complete(ioc_gone);
> > +			ioc_gone = NULL;
> > +		}
> > +		spin_unlock(&ioc_gone_lock);
> > +	}
> >  }
> > 
> >  static void cfq_cic_free(struct cfq_io_context *cic)
> 
> > static void __exit cfq_exit(void)
> > {
> > 	DECLARE_COMPLETION_ONSTACK(all_gone);
> > 	elv_unregister(&iosched_cfq);
> > 	ioc_gone = &all_gone;
> > 	/* ioc_gone's update must be visible before reading ioc_count */
> > 	smp_wmb();
> 
> This needs to be upgraded to an smp_mb() because we have a write followed
> by a read that we need to keep ordered.
> 
> > 	if (elv_ioc_count_read(ioc_count))
> > 		wait_for_completion(ioc_gone);
> > 	cfq_slab_kill();
> > }
> 
> In absence of these two changes, either compiler or CPU could reorder
> the accesses to ioc_gone on the one hand and to ioc_count on the other,
> which could result in a hang, for example, cfq_exit() might see the
> reader's old count, but the reader might fail to see the assignment
> to ioc_gone.

OK, make that two more things to consider...

Why the smp_read_barrier_depends() in cfq_get_io_context()?  It appears
to be guarding the dereferencing of ioc.  But we would have obtained
ioc from get_io_context(), which already dereferenced this pointer when
it bumped the ->refcount.  So any barriers would seem to need to be
inside of get_io_context().

So what am I missing this time?

							Thanx, Paul
