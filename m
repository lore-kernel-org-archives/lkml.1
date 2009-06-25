Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZFYUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZFYUIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZFYUIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:08:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48522 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZFYUIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:08:31 -0400
Date: Thu, 25 Jun 2009 22:08:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625200833.GD31415@kernel.dk>
References: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625195538.GC31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625195538.GC31415@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009, Jens Axboe wrote:
> On Wed, Jun 24 2009, Andrew Morton wrote:
> > On Wed, 24 Jun 2009 13:40:11 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > 
> > > 
> > > On Wed, 24 Jun 2009, Linus Torvalds wrote:
> > > > On Wed, 24 Jun 2009, Andrew Morton wrote:
> > > > > 
> > > > > If the caller gets oom-killed, the allocation attempt fails.  Callers need
> > > > > to handle that.
> > > > 
> > > > I actually disagree. I think we should just admit that we can always free 
> > > > up enough space to get a few pages, in order to then oom-kill things.
> > > 
> > > Btw, if you want to change the WARN_ON() to warn when you're in the 
> > > "allocate in order to free memory" recursive case, then I'd have no issues 
> > > with that.
> > > 
> > > In fact, in that case it probably shouldn't even be conditional on the 
> > > order. 
> > > 
> > > So a
> > > 
> > > 	WARN_ON_ONCE((p->flags & PF_MEMALLOC) && (gfpmask & __GFP_NOFAIL));
> > > 
> > > actually makes tons of sense. 
> > 
> > I suspect that warning will trigger.
> > 
> > alloc_pages
> > -> ...
> >   -> pageout
> >     -> ...
> >       -> get_request
> >         -> blk_alloc_request
> >           -> elv_set_request
> >             -> cfq_set_request
> >               -> cfq_get_queue
> >                 -> cfq_find_alloc_queue
> >                   -> kmem_cache_alloc_node(__GFP_NOFAIL)
> >                     -> Jens
> > 
> > How much this can happen in practice I don't know, but it looks bad.
> 
> Yeah it sucks, but I don't think it's that bad to fixup.
> 
> The request allocation can fail, if we just return NULL in
> cfq_find_alloc_queue() and let that error propagate back up to
> get_request_wait(), it would simply io_schedule() and wait for a request
> to be freed. The only issue here is that if we have no requests going
> for this queue already, we would be stuck since there's noone to wake us
> up eventually. So if we did this, we'd have to make the io_schedule()
> dependent on whether there are allocations out already. Use global
> congestion wait in that case, or just io_schedule_timeout() for
> retrying.
> 
> The other option is to retry in cfq_find_alloc_queue() without the
> NOFAIL and do the congestion wait logic in there.
> 
> Yet another option would be to have a dummy queue that is allocated when
> the queue io scheduler is initialized. If cfq_find_alloc_queue() fails,
> just punt the IO to that dummy queue. That would allow progress even
> under extreme failure conditions.
> 
> With all that said, the likely hood of ever hitting this path is about
> 0%. Those failures are the ones that really suck when it's hit in the
> field eventually, though :-)

Something like the below implements option 3. Totally untested, I'll
throw it through some memfail injections and blktrace before I fully
trust it. And split it into 2 patches, the first doing the
cfq_init_cfqq() stuff and the second adding oom_cfqq and using it there
too.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 833ec18..3b075a8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -71,6 +71,51 @@ struct cfq_rb_root {
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
 
 /*
+ * Per process-grouping structure
+ */
+struct cfq_queue {
+	/* reference count */
+	atomic_t ref;
+	/* various state flags, see below */
+	unsigned int flags;
+	/* parent cfq_data */
+	struct cfq_data *cfqd;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key */
+	unsigned long rb_key;
+	/* prio tree member */
+	struct rb_node p_node;
+	/* prio tree root we belong to, if any */
+	struct rb_root *p_root;
+	/* sorted list of pending requests */
+	struct rb_root sort_list;
+	/* if fifo isn't expired, next request to serve */
+	struct request *next_rq;
+	/* requests queued in sort_list */
+	int queued[2];
+	/* currently allocated requests */
+	int allocated[2];
+	/* fifo list of requests in sort_list */
+	struct list_head fifo;
+
+	unsigned long slice_end;
+	long slice_resid;
+	unsigned int slice_dispatch;
+
+	/* pending metadata requests */
+	int meta_pending;
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
+
+	/* io prio of this group */
+	unsigned short ioprio, org_ioprio;
+	unsigned short ioprio_class, org_ioprio_class;
+
+	pid_t pid;
+};
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
@@ -135,51 +180,11 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
-};
-
-/*
- * Per process-grouping structure
- */
-struct cfq_queue {
-	/* reference count */
-	atomic_t ref;
-	/* various state flags, see below */
-	unsigned int flags;
-	/* parent cfq_data */
-	struct cfq_data *cfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-	/* service_tree key */
-	unsigned long rb_key;
-	/* prio tree member */
-	struct rb_node p_node;
-	/* prio tree root we belong to, if any */
-	struct rb_root *p_root;
-	/* sorted list of pending requests */
-	struct rb_root sort_list;
-	/* if fifo isn't expired, next request to serve */
-	struct request *next_rq;
-	/* requests queued in sort_list */
-	int queued[2];
-	/* currently allocated requests */
-	int allocated[2];
-	/* fifo list of requests in sort_list */
-	struct list_head fifo;
-
-	unsigned long slice_end;
-	long slice_resid;
-	unsigned int slice_dispatch;
 
-	/* pending metadata requests */
-	int meta_pending;
-	/* number of requests that are on the dispatch list or inside driver */
-	int dispatched;
-
-	/* io prio of this group */
-	unsigned short ioprio, org_ioprio;
-	unsigned short ioprio_class, org_ioprio_class;
-
-	pid_t pid;
+	/*
+	 * Fallback dummy cfqq for extrem OOM conditions
+	 */
+	struct cfq_queue oom_cfqq;
 };
 
 enum cfqq_state_flags {
@@ -1641,6 +1646,26 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 	ioc->ioprio_changed = 0;
 }
 
+static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+			  pid_t pid, int is_sync)
+{
+	RB_CLEAR_NODE(&cfqq->rb_node);
+	RB_CLEAR_NODE(&cfqq->p_node);
+	INIT_LIST_HEAD(&cfqq->fifo);
+
+	atomic_set(&cfqq->ref, 0);
+	cfqq->cfqd = cfqd;
+
+	cfq_mark_cfqq_prio_changed(cfqq);
+
+	if (is_sync) {
+		if (!cfq_class_idle(cfqq))
+			cfq_mark_cfqq_idle_window(cfqq);
+		cfq_mark_cfqq_sync(cfqq);
+	}
+	cfqq->pid = pid;
+}
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -1666,10 +1691,11 @@ retry:
 			 */
 			spin_unlock_irq(cfqd->queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
-					gfp_mask | __GFP_NOFAIL | __GFP_ZERO,
+					gfp_mask | __GFP_ZERO,
 					cfqd->queue->node);
 			spin_lock_irq(cfqd->queue->queue_lock);
-			goto retry;
+			if (new_cfqq)
+				goto retry;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
@@ -1678,23 +1704,8 @@ retry:
 				goto out;
 		}
 
-		RB_CLEAR_NODE(&cfqq->rb_node);
-		RB_CLEAR_NODE(&cfqq->p_node);
-		INIT_LIST_HEAD(&cfqq->fifo);
-
-		atomic_set(&cfqq->ref, 0);
-		cfqq->cfqd = cfqd;
-
-		cfq_mark_cfqq_prio_changed(cfqq);
-
+		cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 		cfq_init_prio_data(cfqq, ioc);
-
-		if (is_sync) {
-			if (!cfq_class_idle(cfqq))
-				cfq_mark_cfqq_idle_window(cfqq);
-			cfq_mark_cfqq_sync(cfqq);
-		}
-		cfqq->pid = current->pid;
 		cfq_log_cfqq(cfqd, cfqq, "alloced");
 	}
 
@@ -1702,6 +1713,8 @@ retry:
 		kmem_cache_free(cfq_pool, new_cfqq);
 
 out:
+	if (!cfqq)
+		cfqq = &cfqd->oom_cfqq;
 	WARN_ON((gfp_mask & __GFP_WAIT) && !cfqq);
 	return cfqq;
 }
@@ -1735,11 +1748,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 		cfqq = *async_cfqq;
 	}
 
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
-		if (!cfqq)
-			return NULL;
-	}
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -2465,6 +2475,11 @@ static void *cfq_init_queue(struct request_queue *q)
 	for (i = 0; i < CFQ_PRIO_LISTS; i++)
 		cfqd->prio_trees[i] = RB_ROOT;
 
+	/*
+	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues
+	 */
+	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
+
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
 	cfqd->queue = q;

-- 
Jens Axboe

