Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYE1KHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYE1KHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYE1KH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:07:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27064 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYE1KHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:07:23 -0400
Date: Wed, 28 May 2008 12:07:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080528100721.GQ25504@kernel.dk>
References: <20080428195509.GA5247@martell.zuzino.mipt.ru> <20080429062116.GA5059@martell.zuzino.mipt.ru> <20080429090604.GK12774@kernel.dk> <20080430221250.GA10150@martell.zuzino.mipt.ru> <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527151809.GA14296@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27 2008, Paul E. McKenney wrote:
> On Tue, May 27, 2008 at 03:35:10PM +0200, Jens Axboe wrote:
> > On Tue, May 27 2008, Alexey Dobriyan wrote:
> > > On Sat, May 10, 2008 at 02:37:19PM +0400, Alexey Dobriyan wrote:
> > > > > > > > @@ -41,8 +41,8 @@ int put_io_context(struct io_context *ioc)
> > > > > > > >  		rcu_read_lock();
> > > > > > > >  		if (ioc->aic && ioc->aic->dtor)
> > > > > > > >  			ioc->aic->dtor(ioc->aic);
> > > > > > > > -		rcu_read_unlock();
> > > > > > > >  		cfq_dtor(ioc);
> > > > > > > > +		rcu_read_unlock();
> > > > > > > >  
> > > > > > > >  		kmem_cache_free(iocontext_cachep, ioc);
> > > > > > > >  		return 1;
> > > > > > > 
> > > > > > > This helps in sense that 3 times bulk cross-compiles finish to the end.
> > > > > > > You'll hear me if another such oops will resurface.
> > > > > > 
> > > > > > Still looking good?
> > > > > 
> > > > > Yup!
> > > > 
> > > > And this with patch in mainline, again with PREEMPT_RCU.
> > > 
> > > Ping, this happened again with 2.6.26-rc4 and PREEMPT_RCU.
> > 
> > Worrisome... Paul, would you mind taking a quick look at cfq
> > and see if you can detect why breaks with preempt rcu? It's
> > clearly a use-after-free symptom, but I don't see how it can
> > happen.
> 
> Some quick and probably off-the-mark questions...

Thanks!

> o	What is the purpose of __call_for_each_cic()?  When called
> 	from call_for_each_cic(), it is under rcu_read_lock(), as
> 	required, but it is also called from cfq_free_io_context(),
> 	which is assigned to the ->dtor and ->exit members of the
> 	cfq_io_context struct.  What protects calls through these
> 	members?
> 
> 	(This is for the ->cic_list field of the cfq_io_context structure.
> 	One possibility is that the io_context's ->lock member is held,
> 	but I don't see this.  Not that I looked all that hard...)
> 
> 	My suggestion would be to simply change all invocations of
> 	__call_for_each_cic() to instead invoke call_for_each_cic().
> 	The rcu_read_lock()/rcu_read_unlock() pair is pretty
> 	lightweight, even in CONFIG_PREEMPT_RCU.

__call_for_each_cic() is always called under rcu_read_lock(), it merely
exists to avoid a double rcu_read_lock(). Even if it is cheap. The
convention follows the usual __lock_is_already_held() double under
score, but I guess it could do with a comment! There are only two
callers of the function, call_for_each_cic() which does the
rcu_read_lock(), and cfq_free_io_context() which is called from ->dtor
(and holds the rcu_read_lock() and ->trim which actually does not. That
looks like it could be problematic, but it's only called when an io
scheduler module is removed so not really critical. I'll add it, though!
Actually, the task_lock() should be enough there. So no bug, but (again)
it could do with a comment.

> o	When calling cfq_slab_kill(), for example from cfq_exit(),
> 	what ensures that all previous RCU callbacks have completed?
> 	
> 	I suspect that you need an rcu_barrier() at the beginning
> 	of cfq_slab_kill(), but I could be missing something.

So we have two callers of that, one is from the error path at init time
and is obviously ok. The other does need rcu_barrier()! I'll add that.

> o	Updates to the ->ioc_data field of the cfq_io_context
> 	seem to be protected by the request_queue ->queue_lock
> 	field.  This seems very strange to me.  It is OK if every
> 	cfq_io_context is associated with only one request_queue
> 	structure -- is this the case?

->ioc_data is part of the io_context, not cfq_io_context. And it can be
shared now, so the correct locking for that would be ioc->lock and not
the queue lock. __cfq_exit_single_io_context() is serialized in the
sense that only one process gets to call the exit path.

> o	What protects the first rcu_dereference() in cfq_cic_lookup()?
> 	There needs to be either an enclose rcu_read_lock() on the
> 	one hand or the ->queue_lock needs to be held.
> 
> 	(My guess is the latter, given the later rcu_assign_pointer()
> 	in this same function, but I don't see a lock acquisition
> 	in the immediate vicinity -- might be further up the function
> 	call stack, though.)

There's no locking going into that function when coming from
cfq_get_io_context(), the other paths (happen) to hold the queue lock
already though.

> o	Why is there no grace period associated with the ioc_data?
> 	For example, what happens to the old value of ->ioc_data
> 	after the rcu_assign_pointer() in cfq_cic_lookup()?  Readers
> 	might still be referencing the old version, right?  If so,
> 	how do we avoid messing them up?
> 
> 	Or are we somehow leveraging the call_rcu() in cfq_cic_free()?

The data belonging to ->ioc_data (the cic, or per-process per-queue
context) is only freed through call_rcu().

> Any of this at all helpful?

Very, perhaps with a few more rounds we can find some more bugs :-). I'm
attaching a patch below, how does that look?

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4df3f05..75db529 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1142,6 +1142,9 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
+/*
+ * Must always be called with the rcu_read_lock() held
+ */
 static void
 __call_for_each_cic(struct io_context *ioc,
 		    void (*func)(struct io_context *, struct cfq_io_context *))
@@ -1197,6 +1200,11 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 	cfq_cic_free(cic);
 }
 
+/*
+ * Must be called with rcu_read_lock() held or preemption otherwise disabled.
+ * Only two callers of this - ->dtor() which is called with the rcu_read_lock(),
+ * and ->trim() which is called with the task lock held
+ */
 static void cfq_free_io_context(struct io_context *ioc)
 {
 	/*
@@ -1502,20 +1510,24 @@ static struct cfq_io_context *
 cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
 	struct cfq_io_context *cic;
+	unsigned long flags;
 	void *k;
 
 	if (unlikely(!ioc))
 		return NULL;
 
+	rcu_read_lock();
+
 	/*
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
 	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->key == cfqd)
+	if (cic && cic->key == cfqd) {
+		rcu_read_unlock();
 		return cic;
+	}
 
 	do {
-		rcu_read_lock();
 		cic = radix_tree_lookup(&ioc->radix_root, (unsigned long) cfqd);
 		rcu_read_unlock();
 		if (!cic)
@@ -1524,10 +1536,13 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 		k = cic->key;
 		if (unlikely(!k)) {
 			cfq_drop_dead_cic(cfqd, ioc, cic);
+			rcu_read_lock();
 			continue;
 		}
 
+		spin_lock_irqsave(&ioc->lock, flags);
 		rcu_assign_pointer(ioc->ioc_data, cic);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 		break;
 	} while (1);
 
@@ -2134,6 +2149,11 @@ static void *cfq_init_queue(struct request_queue *q)
 
 static void cfq_slab_kill(void)
 {
+	/*
+	 * Make sure that all existing RCU callbacks have been processed
+	 */
+	rcu_barrier();
+
 	if (cfq_pool)
 		kmem_cache_destroy(cfq_pool);
 	if (cfq_ioc_pool)

-- 
Jens Axboe

