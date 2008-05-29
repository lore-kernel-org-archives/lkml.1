Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYE2G03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYE2G03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYE2G0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:26:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYE2G0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:26:19 -0400
Date: Thu, 29 May 2008 08:26:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080529062617.GH25504@kernel.dk>
References: <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080528132012.GF8255@linux.vnet.ibm.com> <20080529043852.GA15489@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529043852.GA15489@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28 2008, Paul E. McKenney wrote:
> On Wed, May 28, 2008 at 06:20:12AM -0700, Paul E. McKenney wrote:
> > On Wed, May 28, 2008 at 02:44:24PM +0200, Jens Axboe wrote:
> > > On Wed, May 28 2008, Paul E. McKenney wrote:
> > > > On Wed, May 28, 2008 at 12:07:21PM +0200, Jens Axboe wrote:
> > > > > On Tue, May 27 2008, Paul E. McKenney wrote:
> > > > > > On Tue, May 27, 2008 at 03:35:10PM +0200, Jens Axboe wrote:
> > > > > > > On Tue, May 27 2008, Alexey Dobriyan wrote:
> > > > > > > > On Sat, May 10, 2008 at 02:37:19PM +0400, Alexey Dobriyan wrote:
> > > > > > > > > > > > > @@ -41,8 +41,8 @@ int put_io_context(struct io_context *ioc)
> > > > > > > > > > > > >  		rcu_read_lock();
> > > > > > > > > > > > >  		if (ioc->aic && ioc->aic->dtor)
> > > > > > > > > > > > >  			ioc->aic->dtor(ioc->aic);
> > > > > > > > > > > > > -		rcu_read_unlock();
> > > > > > > > > > > > >  		cfq_dtor(ioc);
> > > > > > > > > > > > > +		rcu_read_unlock();
> > > > > > > > > > > > >  
> > > > > > > > > > > > >  		kmem_cache_free(iocontext_cachep, ioc);
> > > > > > > > > > > > >  		return 1;
> > > > > > > > > > > > 
> > > > > > > > > > > > This helps in sense that 3 times bulk cross-compiles finish to the end.
> > > > > > > > > > > > You'll hear me if another such oops will resurface.
> > > > > > > > > > > 
> > > > > > > > > > > Still looking good?
> > > > > > > > > > 
> > > > > > > > > > Yup!
> > > > > > > > > 
> > > > > > > > > And this with patch in mainline, again with PREEMPT_RCU.
> > > > > > > > 
> > > > > > > > Ping, this happened again with 2.6.26-rc4 and PREEMPT_RCU.
> > > > > > > 
> > > > > > > Worrisome... Paul, would you mind taking a quick look at cfq
> > > > > > > and see if you can detect why breaks with preempt rcu? It's
> > > > > > > clearly a use-after-free symptom, but I don't see how it can
> > > > > > > happen.
> > > > > > 
> > > > > > Some quick and probably off-the-mark questions...
> > > > > 
> > > > > Thanks!
> > > > 
> > > > Glad it actually was of help!  ;-)
> > > 
> > > Your reviews are ALWAYS greatly appreciated!
> > 
> > :-)
> > 
> > > > > > o	What is the purpose of __call_for_each_cic()?  When called
> > > > > > 	from call_for_each_cic(), it is under rcu_read_lock(), as
> > > > > > 	required, but it is also called from cfq_free_io_context(),
> > > > > > 	which is assigned to the ->dtor and ->exit members of the
> > > > > > 	cfq_io_context struct.  What protects calls through these
> > > > > > 	members?
> > > > > > 
> > > > > > 	(This is for the ->cic_list field of the cfq_io_context structure.
> > > > > > 	One possibility is that the io_context's ->lock member is held,
> > > > > > 	but I don't see this.  Not that I looked all that hard...)
> > > > > > 
> > > > > > 	My suggestion would be to simply change all invocations of
> > > > > > 	__call_for_each_cic() to instead invoke call_for_each_cic().
> > > > > > 	The rcu_read_lock()/rcu_read_unlock() pair is pretty
> > > > > > 	lightweight, even in CONFIG_PREEMPT_RCU.
> > > > > 
> > > > > __call_for_each_cic() is always called under rcu_read_lock(), it merely
> > > > > exists to avoid a double rcu_read_lock(). Even if it is cheap. The
> > > > > convention follows the usual __lock_is_already_held() double under
> > > > > score, but I guess it could do with a comment! There are only two
> > > > > callers of the function, call_for_each_cic() which does the
> > > > > rcu_read_lock(), and cfq_free_io_context() which is called from ->dtor
> > > > > (and holds the rcu_read_lock() and ->trim which actually does not. That
> > > > > looks like it could be problematic, but it's only called when an io
> > > > > scheduler module is removed so not really critical. I'll add it, though!
> > > > > Actually, the task_lock() should be enough there. So no bug, but (again)
> > > > > it could do with a comment.
> > > > 
> > > > Sounds good!
> > > > 
> > > > > > o	When calling cfq_slab_kill(), for example from cfq_exit(),
> > > > > > 	what ensures that all previous RCU callbacks have completed?
> > > > > > 	
> > > > > > 	I suspect that you need an rcu_barrier() at the beginning
> > > > > > 	of cfq_slab_kill(), but I could be missing something.
> > > > > 
> > > > > So we have two callers of that, one is from the error path at init time
> > > > > and is obviously ok. The other does need rcu_barrier()! I'll add that.
> > > > 
> > > > OK, that does make my brain hurt less.  ;-)
> > > 
> > > So that one was also OK, as Fabio pointed out. If you follow the
> > > ioc_gone and user tracking, the:
> > > 
> > >         if (elv_ioc_count_read(ioc_count))
> > >                 wait_for_completion(ioc_gone);
> > > 
> > > also has the side effect of waiting for RCU callbacks calling
> > > kmem_cache_free() to have finished as well.
> > 
> > I stand corrected.
> 
> But one additional question...
> 
> 	static void cfq_cic_free_rcu(struct rcu_head *head)
> 	{
> 		struct cfq_io_context *cic;
> 
> 		cic = container_of(head, struct cfq_io_context, rcu_head);
> 
> 		kmem_cache_free(cfq_ioc_pool, cic);
> 		elv_ioc_count_dec(ioc_count);
> 
> 		if (ioc_gone && !elv_ioc_count_read(ioc_count))
> 			complete(ioc_gone);
> 	}
> 
> Suppose that a pair of tasks both execute the elv_ioc_count_dec()
> at the same time, so that all counters are now zero.  Both then
> find that there is still an ioc_gone, and that the count is
> now zero.  One of the tasks invokes complete(ioc_gone).  This
> awakens the corresponding cfq_exit(), which now returns, getting
> rid of its stack frame -- and corrupting the all_gone auto variable
> that ioc_gone references.
> 
> Now the second task gets a big surprise when it tries to invoke
> complete(ioc_gone).
> 
> Or is there something else that I am missing here?

No, I think that's a problem spot as well. To my knowledge, nobody has
ever hit that. The anticipatory scheduler has the same code.

What we want to avoid here is making cfq_cic_free_rcu() a lot more
expensive, which is why the elv_ioc_count_read() is behind that
ioc_gone check. I'll need to think a bit on how to handle that
better :-)

-- 
Jens Axboe

