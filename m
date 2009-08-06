Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZHFU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZHFU43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZHFU42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZHFU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:56:26 -0400
Date: Thu, 6 Aug 2009 22:56:21 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 5/9] writeback: support > 1 flusher thread per bdi
Message-ID: <20090806205621.GB8177@duck.suse.cz>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-6-git-send-email-jens.axboe@oracle.com> <20090805195504.GD27505@duck.suse.cz> <20090806070546.GH12579@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20090806070546.GH12579@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 06-08-09 09:05:46, Jens Axboe wrote:
> On Wed, Aug 05 2009, Jan Kara wrote:
> > > +static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
> > > +{
> > > +	if (work) {
> > > +		work->seen = bdi->wb_mask;
> > > +		BUG_ON(!work->seen);
> > > +		atomic_set(&work->pending, bdi->wb_cnt);
> >   I guess the idea here is that every writeback thread has to acknowledge
> > the work. But what if some thread decides to die after the work is queued
> > but before it manages to acknowledge it? We would end up waiting
> > indefinitely...
> 
> The writeback thread checks for race added work on exit, so it should be
> fine.
  Sorry if I'm a bit dense but I don't get it (hmm, probably I gave too few
details in my comment above). Assume there are at least two writeback
threads on bdi->wb_list:

	CPU1					CPU2
    bdi_writeback_task()
    list_del_rcu(wb->list);
    if (!list_empty(&bdi->work_list))
        wb_do_writeback(wb, 1);
						bdi_queue_work()
						  ...
						  atomic_set(&work->pending, bdi->wb_cnt);
						  ...
						  bdi->wb_list isn't empty
						    bdi_sched_work()
        bdi_put_wb(bdi, wb); -> only now the bdi->wb_cnt is decreased...

  Looking at the code more in detail, it actually gets fixed once the
forker task wakes up, notices there's some work to do and adds the default
flusher thread again but still it could have strange effects.

> Additionally, only the default thread will exit and that one will
> always have it's count and mask be valid (since we auto-fork it again,
> if needed).
  Ah OK, I see.

> > > +		BUG_ON(!bdi->wb_cnt);
> > > +
> > > +		/*
> > > +		 * Make sure stores are seen before it appears on the list
> > > +		 */
> > > +		smp_mb();
> > > +
> > > +		spin_lock(&bdi->wb_lock);
> > > +		list_add_tail_rcu(&work->list, &bdi->work_list);
> > > +		spin_unlock(&bdi->wb_lock);
> > > +	}
> > > +
> > >  	/*
> > > -	 * This only happens the first time someone kicks this bdi, so put
> > > -	 * it out-of-line.
> > > +	 * If the default thread isn't there, make sure we add it. When
> > > +	 * it gets created and wakes up, we'll run this work.
> > >  	 */
> > > -	if (unlikely(!bdi->wb.task))
> > > +	if (unlikely(list_empty_careful(&bdi->wb_list)))
> > >  		wake_up_process(default_backing_dev_info.wb.task);
> > > +	else
> > > +		bdi_sched_work(bdi, work);
> > > +}
> > > +
> > > +/*
> > > + * Used for on-stack allocated work items. The caller needs to wait until
> > > + * the wb threads have acked the work before it's safe to continue.
> > > + */
> > > +static void bdi_wait_on_work_clear(struct bdi_work *work)
> > > +{
> > > +	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
> > > +}
> >   I still feel the rules for releasing / cleaning up work are too
> > complicated.
> >   1) I believe we can bear one more "int" for flags in the struct bdi_work
> > so that you don't have to hide them in sb_data.
> 
> Sure, but there's little reason to do that I think, since it's only used
> internally. Let me put it another way, why add an extra int if we can
> avoid it?
  Actually, looking again that the work struct "state" field has lots of
free bits. I think the code looks nicer with the attached patch, what do
you think?

> >   2) I'd introduce a flag with the meaning: free the work when you are
> > done. Obviusly this flag makes sence only with dynamically allocated work
> > structure. There would be no "on stack" flag.
> >   3) I'd create a function:
> > bdi_wait_work_submitted()
> >   which you'd have to call whenever you didn't set the flag and want to
> > free the work (either explicitely, or via returning from a function which
> > has the structure on stack).
> >   It would do:
> > bdi_wait_on_work_clear(work);
> > call_rcu(&work->rcu_head, bdi_work_free);
> > 
> >   wb_work_complete() would just depending on the flag setting either
> > completely do away with the work struct or just do bdi_work_clear().
> > 
> >   IMO that would make the code easier to check and also less prone to
> > errors (currently you have to think twice when you have to wait for the rcu
> > period, call bdi_work_free, etc.).
> 
> Didn't we go over all that last time, too?
  Well, probably about something similar. But this time I have a patch ;-)
Compile tested only... IMO it looks nicer this way as it wraps up all the
details of work freeing into one function.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Cleanup-flags-handling-in-per-bdi-flusher-threads-pa.patch"

>From 4a8615747d96efc5067932936c1330e17edfbd16 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 6 Aug 2009 21:35:30 +0200
Subject: [PATCH 1/2] Cleanup flags handling in per-bdi flusher threads patches.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index dfb4767..fc7e4a3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -53,21 +53,24 @@ struct bdi_work {
 	unsigned long seen;
 	atomic_t pending;
 
-	unsigned long sb_data;
+	struct super_block *sb;
 	unsigned long nr_pages;
 	enum writeback_sync_modes sync_mode;
 
 	unsigned long state;
 };
 
-static struct super_block *bdi_work_sb(struct bdi_work *work)
-{
-	return (struct super_block *) (work->sb_data & ~1UL);
-}
+enum {
+	WS_USED_B = 0,
+	WS_ONSTACK_B,
+};
+
+#define WS_USED (1 << WS_USED_B)
+#define WS_ONSTACK (1 << WS_ONSTACK_B)
 
 static inline bool bdi_work_on_stack(struct bdi_work *work)
 {
-	return work->sb_data & 1UL;
+	return test_bit(WS_ONSTACK_B, &work->state);
 }
 
 static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
@@ -75,10 +78,10 @@ static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
 				 enum writeback_sync_modes sync_mode)
 {
 	INIT_RCU_HEAD(&work->rcu_head);
-	work->sb_data = (unsigned long) sb;
+	work->sb = sb;
 	work->nr_pages = nr_pages;
 	work->sync_mode = sync_mode;
-	work->state = 1;
+	work->state = WS_USED;
 }
 
 static inline void bdi_work_init_on_stack(struct bdi_work *work,
@@ -87,7 +90,7 @@ static inline void bdi_work_init_on_stack(struct bdi_work *work,
 					  enum writeback_sync_modes sync_mode)
 {
 	bdi_work_init(work, sb, nr_pages, sync_mode);
-	work->sb_data |= 1UL;
+	work->state |= WS_ONSTACK;
 }
 
 /**
@@ -104,9 +107,9 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 
 static void bdi_work_clear(struct bdi_work *work)
 {
-	clear_bit(0, &work->state);
+	clear_bit(WS_USED_B, &work->state);
 	smp_mb__after_clear_bit();
-	wake_up_bit(&work->state, 0);
+	wake_up_bit(&work->state, WS_USED_B);
 }
 
 static void bdi_work_free(struct rcu_head *head)
@@ -215,7 +218,8 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
  */
 static void bdi_wait_on_work_clear(struct bdi_work *work)
 {
-	wait_on_bit(&work->state, 0, bdi_sched_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&work->state, WS_USED_B, bdi_sched_wait,
+		    TASK_UNINTERRUPTIBLE);
 }
 
 static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
@@ -376,7 +380,6 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 	long nr_pages, wrote = 0;
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
-		struct super_block *sb = bdi_work_sb(work);
 		enum writeback_sync_modes sync_mode;
 
 		nr_pages = work->nr_pages;
@@ -396,7 +399,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		if (sync_mode == WB_SYNC_NONE)
 			wb_clear_pending(wb, work);
 
-		wrote += wb_writeback(wb, nr_pages, sb, sync_mode, 0);
+		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
 
 		/*
 		 * This is a data integrity writeback, so only do the
-- 
1.6.0.2


--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Cleanup-freeing-of-work-struct.patch"

>From 54366b186d1e50b3453dfd2881a7eae559ab6cbc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 6 Aug 2009 22:24:57 +0200
Subject: [PATCH 2/2] Cleanup freeing of work struct

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |  121 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 70 insertions(+), 51 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fc7e4a3..bdc8dd5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -61,16 +61,35 @@ struct bdi_work {
 };
 
 enum {
-	WS_USED_B = 0,
-	WS_ONSTACK_B,
+	WS_USED_B = 0,	/* Still processed by the writeback thread */
+	WS_ALLOCATED_B,	/* Work is dynamically allocated */
+	WS_ASYNC_B,	/* Should be freed by the writeback thread */
 };
 
 #define WS_USED (1 << WS_USED_B)
-#define WS_ONSTACK (1 << WS_ONSTACK_B)
+#define WS_ALLOCATED (1 << WS_ALLOCATED_B)
+#define WS_ASYNC (1 << WS_ASYNC_B)
 
-static inline bool bdi_work_on_stack(struct bdi_work *work)
+static inline bool bdi_work_async(struct bdi_work *work)
 {
-	return test_bit(WS_ONSTACK_B, &work->state);
+
+	return test_bit(WS_ASYNC_B, &work->state);
+}
+
+static inline bool bdi_work_allocated(struct bdi_work *work)
+{
+	return test_bit(WS_ALLOCATED_B, &work->state);
+}
+
+static inline void bdi_set_work_async(struct bdi_work *work)
+{
+	WARN_ON(!bdi_work_allocated(work));
+	set_bit(WS_ASYNC_B, &work->state);
+}
+
+static inline void bdi_set_work_allocated(struct bdi_work *work)
+{
+	set_bit(WS_ALLOCATED_B, &work->state);
 }
 
 static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
@@ -84,15 +103,6 @@ static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
 	work->state = WS_USED;
 }
 
-static inline void bdi_work_init_on_stack(struct bdi_work *work,
-					  struct super_block *sb,
-					  unsigned long nr_pages,
-					  enum writeback_sync_modes sync_mode)
-{
-	bdi_work_init(work, sb, nr_pages, sync_mode);
-	work->state |= WS_ONSTACK;
-}
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -116,26 +126,19 @@ static void bdi_work_free(struct rcu_head *head)
 {
 	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
 
-	if (!bdi_work_on_stack(work))
-		kfree(work);
-	else
-		bdi_work_clear(work);
+	kfree(work);
 }
 
 static void wb_work_complete(struct bdi_work *work)
 {
-	const enum writeback_sync_modes sync_mode = work->sync_mode;
-
 	/*
-	 * For allocated work, we can clear the done/seen bit right here.
-	 * For on-stack work, we need to postpone both the clear and free
-	 * to after the RCU grace period, since the stack could be invalidated
-	 * as soon as bdi_work_clear() has done the wakeup.
+	 * Either free the work if it is ASYNC one (and thus nobody
+	 * should wait on it) or mark it as done.
 	 */
-	if (!bdi_work_on_stack(work))
-		bdi_work_clear(work);
-	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
+	if (bdi_work_async(work))
 		call_rcu(&work->rcu_head, bdi_work_free);
+	else
+		bdi_work_clear(work);
 }
 
 static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
@@ -213,8 +216,9 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 }
 
 /*
- * Used for on-stack allocated work items. The caller needs to wait until
- * the wb threads have acked the work before it's safe to continue.
+ * Wait until the writeback thread is done with the work. For WB_SYNC_NONE
+ * work, it is the moment the thread has copied the contents of the structure,
+ * for WB_SYNC_ALL work, it is the moment the thread has submitted all the IO.
  */
 static void bdi_wait_on_work_clear(struct bdi_work *work)
 {
@@ -228,44 +232,58 @@ static struct bdi_work *bdi_alloc_work(struct super_block *sb, long nr_pages,
 	struct bdi_work *work;
 
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work)
+	if (work) {
 		bdi_work_init(work, sb, nr_pages, sync_mode);
+		bdi_set_work_allocated(work);
+	}
 
 	return work;
 }
 
+/*
+ * Wait until the work is safe to be freed and free it.
+ *
+ * Note that for WB_SYNC_ALL work, this waits until all the IO is submitted
+ */
+static void bdi_wait_free_work(struct bdi_work *work)
+{
+	if (!bdi_work_async(work)) {
+		bdi_wait_on_work_clear(work);
+		if (bdi_work_allocated(work))
+			call_rcu(&work->rcu_head, bdi_work_free);
+		else {
+			/*
+			 * For on-stack work, we have to wait as the structure
+			 * on stack can be freed as soon as we return.
+			 */
+			synchronize_rcu();
+		}
+	}
+}
+
 void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages, enum writeback_sync_modes sync_mode)
 {
 	const bool must_wait = sync_mode == WB_SYNC_ALL;
 	struct bdi_work work_stack, *work = NULL;
 
-	if (!must_wait)
+	if (!must_wait) {
 		work = bdi_alloc_work(sb, nr_pages, sync_mode);
+		/*
+		 * Mark that we don't want to wait on work and the writeback
+		 * thread can free it.
+		 */
+		if (work)
+			bdi_set_work_async(work);
+	}
 
 	if (!work) {
 		work = &work_stack;
-		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
+		bdi_work_init(work, sb, nr_pages, sync_mode);
 	}
 
 	bdi_queue_work(bdi, work);
-
-	/*
-	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
-	 * complete. If not, we only need to wait for the work to be started,
-	 * if we allocated it on-stack. We use the same mechanism, if the
-	 * wait bit is set in the bdi_work struct, then threads will not
-	 * clear pending until after they are done.
-	 *
-	 * Note that work == &work_stack if must_wait is true, so we don't
-	 * need to do call_rcu() here ever, since the completion path will
-	 * have done that for us.
-	 */
-	if (must_wait || work == &work_stack) {
-		bdi_wait_on_work_clear(work);
-		if (work != &work_stack)
-			call_rcu(&work->rcu_head, bdi_work_free);
-	}
+	bdi_wait_free_work(work);
 }
 
 /*
@@ -507,6 +525,8 @@ restart:
 		}
 		if (must_wait)
 			list_add_tail(&work->wait_list, &list);
+		else
+			bdi_set_work_async(work);
 
 		bdi_queue_work(bdi, work);
 	}
@@ -520,8 +540,7 @@ restart:
 	while (!list_empty(&list)) {
 		work = list_entry(list.next, struct bdi_work, wait_list);
 		list_del(&work->wait_list);
-		bdi_wait_on_work_clear(work);
-		call_rcu(&work->rcu_head, bdi_work_free);
+		bdi_wait_free_work(work);
 	}
 }
 
-- 
1.6.0.2


--tThc/1wpZn/ma/RB--
