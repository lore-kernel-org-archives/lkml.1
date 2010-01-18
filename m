Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423Ab0ARBAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0ARBAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219Ab0ARAxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:54266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab0ARAxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:13 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/40] workqueue: reimplement workqueue flushing using color coded works
Date: Mon, 18 Jan 2010 09:57:29 +0900
Message-Id: <1263776272-382-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement workqueue flushing using color coded works.  wq has the
current work color which is painted on the works being issued via
cwqs.  Flushing a workqueue is achieved by advancing the current work
colors of cwqs and waiting for all the works which have any of the
previous colors to drain.

Currently there are 16 possible colors, one is reserved for no color
and 15 colors are useable allowing 14 concurrent flushes.  When color
space gets full, flush attempts are batched up and processed together
when color frees up, so even with many concurrent flushers, the new
implementation won't build up huge queue of flushers which has to be
processed one after another.

Only works which are queued via __queue_work() are colored.  Works
which are directly put on queue using insert_work() use NO_COLOR and
don't participate in workqueue flushing.  Currently only works used
for work-specific flush fall in this category.

This new implementation leaves only cleanup_workqueue_thread() as the
user of flush_cpu_workqueue().  Just make its users use
flush_workqueue() and kthread_stop() directly and kill
cleanup_workqueue_thread().  As workqueue flushing doesn't use barrier
request anymore, the comment describing the complex synchronization
around it in cleanup_workqueue_thread() is removed together with the
function.

This new implementation is to allow having and sharing multiple
workers per cpu.

Please note that one more bit is reserved for a future work flag by
this patch.  This is to avoid shifting bits and updating comments
later.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   17 ++-
 kernel/workqueue.c        |  351 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 315 insertions(+), 53 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 011738a..316cc48 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -29,7 +29,22 @@ enum {
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
 	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
 
-	WORK_STRUCT_FLAG_BITS	= 2,
+	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
+	WORK_STRUCT_COLOR_BITS	= 4,
+
+	/*
+	 * The last color is no color used for works which don't
+	 * participate in workqueue flushing.
+	 */
+	WORK_NR_COLORS		= (1 << WORK_STRUCT_COLOR_BITS) - 1,
+	WORK_NO_COLOR		= WORK_NR_COLORS,
+
+	/*
+	 * Reserve 7 bits off of cwq pointer.  This makes cwqs aligned
+	 * to 128 bytes which isn't too excessive while allowing 15
+	 * workqueue flush colors.
+	 */
+	WORK_STRUCT_FLAG_BITS	= 7,
 
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 14edfcd..9e55c80 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -41,6 +41,8 @@
  *
  * L: cwq->lock protected.  Access with cwq->lock held.
  *
+ * F: wq->flush_mutex protected.
+ *
  * W: workqueue_lock protected.
  */
 
@@ -59,10 +61,23 @@ struct cpu_workqueue_struct {
 	struct work_struct *current_work;
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
+	int			work_color;	/* L: current color */
+	int			flush_color;	/* L: flushing color */
+	int			nr_in_flight[WORK_NR_COLORS];
+						/* L: nr of in_flight works */
 	struct task_struct	*thread;
 };
 
 /*
+ * Structure used to wait for workqueue flush.
+ */
+struct wq_flusher {
+	struct list_head	list;		/* F: list of flushers */
+	int			flush_color;	/* F: flush color waiting for */
+	struct completion	done;		/* flush completion */
+};
+
+/*
  * The externally visible workqueue abstraction is an array of
  * per-CPU workqueues:
  */
@@ -70,6 +85,15 @@ struct workqueue_struct {
 	unsigned int		flags;		/* I: WQ_* flags */
 	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
 	struct list_head	list;		/* W: list of all workqueues */
+
+	struct mutex		flush_mutex;	/* protects wq flushing */
+	int			work_color;	/* F: current work color */
+	int			flush_color;	/* F: current flush color */
+	atomic_t		nr_cwqs_to_flush; /* flush in progress */
+	struct wq_flusher	*first_flusher;	/* F: first flusher */
+	struct list_head	flusher_queue;	/* F: flush waiters */
+	struct list_head	flusher_overflow; /* F: flush overflow list */
+
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
@@ -206,6 +230,22 @@ static struct cpu_workqueue_struct *target_cwq(unsigned int cpu,
 	return get_cwq(cpu, wq);
 }
 
+static unsigned int work_color_to_flags(int color)
+{
+	return color << WORK_STRUCT_COLOR_SHIFT;
+}
+
+static int work_flags_to_color(unsigned int flags)
+{
+	return (flags >> WORK_STRUCT_COLOR_SHIFT) &
+		((1 << WORK_STRUCT_COLOR_BITS) - 1);
+}
+
+static int work_next_color(int color)
+{
+	return (color + 1) % WORK_NR_COLORS;
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -265,7 +305,9 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 	spin_lock_irqsave(&cwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
-	insert_work(cwq, work, &cwq->worklist, 0);
+	cwq->nr_in_flight[cwq->work_color]++;
+	insert_work(cwq, work, &cwq->worklist,
+		    work_color_to_flags(cwq->work_color));
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -379,6 +421,44 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
 /**
+ * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
+ * @cwq: cwq of interest
+ * @color: color of work which left the queue
+ *
+ * A work either has completed or is removed from pending queue,
+ * decrement nr_in_flight of its cwq and handle workqueue flushing.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
+{
+	/* ignore uncolored works */
+	if (color == WORK_NO_COLOR)
+		return;
+
+	cwq->nr_in_flight[color]--;
+
+	/* is flush in progress and are we at the flushing tip? */
+	if (likely(cwq->flush_color != color))
+		return;
+
+	/* are there still in-flight works? */
+	if (cwq->nr_in_flight[color])
+		return;
+
+	/* this cwq is done, clear flush_color */
+	cwq->flush_color = -1;
+
+	/*
+	 * If this was the last cwq, wake up the first flusher.  It
+	 * will handle the rest.
+	 */
+	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
+		complete(&cwq->wq->first_flusher->done);
+}
+
+/**
  * process_one_work - process single work
  * @cwq: cwq to process work for
  * @work: work to process
@@ -396,6 +476,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 			     struct work_struct *work)
 {
 	work_func_t f = work->func;
+	int work_color;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -409,6 +490,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	/* claim and process */
 	debug_work_deactivate(work);
 	cwq->current_work = work;
+	work_color = work_flags_to_color(*work_data_bits(work));
 	list_del_init(&work->entry);
 
 	spin_unlock_irq(&cwq->lock);
@@ -435,6 +517,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 
 	/* we're done with it, release */
 	cwq->current_work = NULL;
+	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
@@ -517,29 +600,72 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	init_completion(&barr->done);
 
 	debug_work_activate(&barr->work);
-	insert_work(cwq, &barr->work, head, 0);
+	insert_work(cwq, &barr->work, head, work_color_to_flags(WORK_NO_COLOR));
 }
 
-static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
+/**
+ * flush_workqueue_prep_cwqs - prepare cwqs for workqueue flushing
+ * @wq: workqueue being flushed
+ * @flush_color: new flush color, < 0 for no-op
+ * @work_color: new work color, < 0 for no-op
+ *
+ * Prepare cwqs for workqueue flushing.
+ *
+ * If @flush_color is non-negative, flush_color on all cwqs should be
+ * -1.  If no cwq has in-flight commands at the specified color, all
+ * cwq->flush_color's stay at -1 and %false is returned.  If any cwq
+ * has in flight commands, its cwq->flush_color is set to
+ * @flush_color, @wq->nr_cwqs_to_flush is updated accordingly, cwq
+ * wakeup logic is armed and %true is returned.
+ *
+ * The caller should have initialized @wq->first_flusher prior to
+ * calling this function with non-negative @flush_color.  If
+ * @flush_color is negative, no flush color update is done and %false
+ * is returned.
+ *
+ * If @work_color is non-negative, all cwqs should have the same
+ * work_color which is previous to @work_color and all will be
+ * advanced to @work_color.
+ *
+ * CONTEXT:
+ * mutex_lock(wq->flush_mutex).
+ *
+ * RETURNS:
+ * %true if @flush_color >= 0 and wakeup logic is armed.  %false
+ * otherwise.
+ */
+static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
+				      int flush_color, int work_color)
 {
-	int active = 0;
-	struct wq_barrier barr;
+	bool wait = false;
+	unsigned int cpu;
 
-	WARN_ON(cwq->thread == current);
+	BUG_ON(flush_color >= 0 && atomic_read(&wq->nr_cwqs_to_flush));
 
-	spin_lock_irq(&cwq->lock);
-	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-		insert_wq_barrier(cwq, &barr, &cwq->worklist);
-		active = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-	if (active) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
+		spin_lock_irq(&cwq->lock);
+
+		if (flush_color >= 0) {
+			BUG_ON(cwq->flush_color != -1);
+
+			if (cwq->nr_in_flight[flush_color]) {
+				cwq->flush_color = flush_color;
+				atomic_inc(&wq->nr_cwqs_to_flush);
+				wait = true;
+			}
+		}
+
+		if (work_color >= 0) {
+			BUG_ON(work_color != work_next_color(cwq->work_color));
+			cwq->work_color = work_color;
+		}
+
+		spin_unlock_irq(&cwq->lock);
 	}
 
-	return active;
+	return wait;
 }
 
 /**
@@ -554,13 +680,144 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	int cpu;
+	struct wq_flusher this_flusher = {
+		.list = LIST_HEAD_INIT(this_flusher.list),
+		.flush_color = -1,
+		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
+	};
+	int next_color;
 
-	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_possible_cpu(cpu)
-		flush_cpu_workqueue(get_cwq(cpu, wq));
+
+	mutex_lock(&wq->flush_mutex);
+
+	/*
+	 * Start-to-wait phase
+	 */
+	next_color = work_next_color(wq->work_color);
+
+	if (next_color != wq->flush_color) {
+		/*
+		 * Color space is not full.  The current work_color
+		 * becomes our flush_color and work_color is advanced
+		 * by one.
+		 */
+		BUG_ON(!list_empty(&wq->flusher_overflow));
+		this_flusher.flush_color = wq->work_color;
+		wq->work_color = next_color;
+
+		if (!wq->first_flusher) {
+			/* no flush in progress, become the first flusher */
+			BUG_ON(wq->flush_color != this_flusher.flush_color);
+
+			wq->first_flusher = &this_flusher;
+
+			if (!flush_workqueue_prep_cwqs(wq, wq->flush_color,
+						       wq->work_color)) {
+				/* nothing to flush, done */
+				wq->flush_color = next_color;
+				wq->first_flusher = NULL;
+				goto out_unlock;
+			}
+		} else {
+			/* wait in queue */
+			BUG_ON(wq->flush_color == this_flusher.flush_color);
+			list_add_tail(&this_flusher.list, &wq->flusher_queue);
+			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+		}
+	} else {
+		/*
+		 * Oops, color space is full, wait on overflow queue.
+		 * The next flush completion will assign us
+		 * flush_color and transfer to flusher_queue.
+		 */
+		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
+	}
+
+	mutex_unlock(&wq->flush_mutex);
+
+	wait_for_completion(&this_flusher.done);
+
+	/*
+	 * Wake-up-and-cascade phase
+	 *
+	 * First flushers are responsible for cascading flushes and
+	 * handling overflow.  Non-first flushers can simply return.
+	 */
+	if (wq->first_flusher != &this_flusher)
+		return;
+
+	mutex_lock(&wq->flush_mutex);
+
+	wq->first_flusher = NULL;
+
+	BUG_ON(!list_empty(&this_flusher.list));
+	BUG_ON(wq->flush_color != this_flusher.flush_color);
+
+	while (true) {
+		struct wq_flusher *next, *tmp;
+
+		/* complete all the flushers sharing the current flush color */
+		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
+			if (next->flush_color != wq->flush_color)
+				break;
+			list_del_init(&next->list);
+			complete(&next->done);
+		}
+
+		BUG_ON(!list_empty(&wq->flusher_overflow) &&
+		       wq->flush_color != work_next_color(wq->work_color));
+
+		/* this flush_color is finished, advance by one */
+		wq->flush_color = work_next_color(wq->flush_color);
+
+		/* one color has been freed, handle overflow queue */
+		if (!list_empty(&wq->flusher_overflow)) {
+			/*
+			 * Assign the same color to all overflowed
+			 * flushers, advance work_color and append to
+			 * flusher_queue.  This is the start-to-wait
+			 * phase for these overflowed flushers.
+			 */
+			list_for_each_entry(tmp, &wq->flusher_overflow, list)
+				tmp->flush_color = wq->work_color;
+
+			wq->work_color = work_next_color(wq->work_color);
+
+			list_splice_tail_init(&wq->flusher_overflow,
+					      &wq->flusher_queue);
+			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+		}
+
+		if (list_empty(&wq->flusher_queue)) {
+			BUG_ON(wq->flush_color != wq->work_color);
+			break;
+		}
+
+		/*
+		 * Need to flush more colors.  Make the next flusher
+		 * the new first flusher and arm cwqs.
+		 */
+		BUG_ON(wq->flush_color == wq->work_color);
+		BUG_ON(wq->flush_color != next->flush_color);
+
+		list_del_init(&next->list);
+		wq->first_flusher = next;
+
+		if (flush_workqueue_prep_cwqs(wq, wq->flush_color, -1))
+			break;
+
+		/*
+		 * Meh... this color is already done, clear first
+		 * flusher and repeat cascading.
+		 */
+		wq->first_flusher = NULL;
+		complete(&next->done);
+	}
+
+out_unlock:
+	mutex_unlock(&wq->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -647,6 +904,8 @@ static int try_to_grab_pending(struct work_struct *work)
 		if (cwq == get_wq_data(work)) {
 			debug_work_deactivate(work);
 			list_del_init(&work->entry);
+			cwq_dec_nr_in_flight(cwq,
+				work_flags_to_color(*work_data_bits(work)));
 			ret = 1;
 		}
 	}
@@ -1020,6 +1279,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		goto err;
 
 	wq->flags = flags;
+	mutex_init(&wq->flush_mutex);
+	atomic_set(&wq->nr_cwqs_to_flush, 0);
+	INIT_LIST_HEAD(&wq->flusher_queue);
+	INIT_LIST_HEAD(&wq->flusher_overflow);
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
@@ -1036,6 +1299,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
 		cwq->wq = wq;
+		cwq->flush_color = -1;
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		init_waitqueue_head(&cwq->more_work);
@@ -1069,33 +1333,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
-{
-	/*
-	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
-	 * cpu_add_remove_lock protects cwq->thread.
-	 */
-	if (cwq->thread == NULL)
-		return;
-
-	lock_map_acquire(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
-
-	flush_cpu_workqueue(cwq);
-	/*
-	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
-	 * a concurrent flush_workqueue() can insert a barrier after us.
-	 * However, in that case run_workqueue() won't return and check
-	 * kthread_should_stop() until it flushes all work_struct's.
-	 * When ->worklist becomes empty it is safe to exit because no
-	 * more work_structs can be queued on this cwq: flush_workqueue
-	 * checks list_empty(), and a "normal" queue_work() can't use
-	 * a dead CPU.
-	 */
-	kthread_stop(cwq->thread);
-	cwq->thread = NULL;
-}
-
 /**
  * destroy_workqueue - safely terminate a workqueue
  * @wq: target workqueue
@@ -1110,8 +1347,20 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_possible_cpu(cpu)
-		cleanup_workqueue_thread(get_cwq(cpu, wq));
+	flush_workqueue(wq);
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		int i;
+
+		if (cwq->thread) {
+			kthread_stop(cwq->thread);
+			cwq->thread = NULL;
+		}
+
+		for (i = 0; i < WORK_NR_COLORS; i++)
+			BUG_ON(cwq->nr_in_flight[i]);
+	}
 
 	free_cwqs(wq->cpu_wq);
 	kfree(wq);
@@ -1141,9 +1390,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			break;
 
 		case CPU_POST_DEAD:
-			lock_map_acquire(&cwq->wq->lockdep_map);
-			lock_map_release(&cwq->wq->lockdep_map);
-			flush_cpu_workqueue(cwq);
+			flush_workqueue(wq);
 			break;
 		}
 	}
-- 
1.6.4.2

