Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXFLNIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXFLNIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbXFLNHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:07:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54305 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbXFLNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:07:31 -0400
Message-Id: <20070612121916.649465522@chello.nl>
References: <20070612121351.448814658@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 12 Jun 2007 14:13:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 3/4] lockstat: measure lock bouncing
Content-Disposition: inline; filename=lockstat_bounce.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    __acquire
        |
       lock _____
        |        \
        |    __contended
        |         |
        |        wait
        | _______/
        |/
        |
   __acquired
        |
   __release
        |
     unlock


We measure acquisition and contention bouncing. 

This is done by recording a cpu stamp in each lock instance.

Contention bouncing requires the cpu stamp to be set on acquisition. Hence we
move __acquired into the generic path. 

__acquired is then used to measure acquisition bouncing by comparing the
current cpu with the old stamp before replacing it.

__contended is used to measure contention bouncing (only useful for preemptable
locks) 

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |   17 ++++++++++++++++-
 kernel/lockdep.c        |   38 ++++++++++++++++++++++++++------------
 kernel/lockdep_proc.c   |   18 +++++++++++-------
 kernel/mutex.c          |    2 +-
 4 files changed, 54 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -130,12 +130,24 @@ struct lock_time {
 	unsigned long			nr;
 };
 
+enum bounce_type {
+	bounce_acquired_write,
+	bounce_acquired_read,
+	bounce_contended_write,
+	bounce_contended_read,
+	nr_bounce_types,
+
+	bounce_acquired = bounce_acquired_write,
+	bounce_contended = bounce_contended_write,
+};
+
 struct lock_class_stats {
 	unsigned long			contention_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
 	struct lock_time		read_holdtime;
 	struct lock_time		write_holdtime;
+	unsigned long			bounces[nr_bounce_types];
 };
 
 struct lock_class_stats lock_stats(struct lock_class *class);
@@ -150,6 +162,9 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache;
 	const char			*name;
+#ifdef CONFIG_LOCK_STAT
+	int				cpu;
+#endif
 };
 
 /*
@@ -321,8 +336,8 @@ do {								\
 	if (!try(_lock)) {					\
 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
 		lock(_lock);					\
-		lock_acquired(&(_lock)->dep_map);		\
 	}							\
+	lock_acquired(&(_lock)->dep_map);			\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -177,6 +177,9 @@ struct lock_class_stats lock_stats(struc
 
 		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
 		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);
+
+		for (i = 0; i < ARRAY_SIZE(stats.bounces); i++)
+			stats.bounces[i] += pcs->bounces[i];
 	}
 
 	return stats;
@@ -2328,6 +2331,9 @@ void lockdep_init_map(struct lockdep_map
 	lock->name = name;
 	lock->key = key;
 	lock->class_cache = NULL;
+#ifdef CONFIG_LOCK_STAT
+	lock->cpu = raw_smp_processor_id();
+#endif
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
@@ -2778,6 +2784,8 @@ found_it:
 	stats = get_lock_stats(hlock->class);
 	if (point < ARRAY_SIZE(stats->contention_point))
 		stats->contention_point[i]++;
+	if (lock->cpu != smp_processor_id())
+		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);
 }
 
@@ -2789,8 +2797,8 @@ __lock_acquired(struct lockdep_map *lock
 	struct lock_class_stats *stats;
 	unsigned int depth;
 	u64 now;
-	s64 waittime;
-	int i;
+	s64 waittime = 0;
+	int i, cpu;
 
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -2812,19 +2820,25 @@ __lock_acquired(struct lockdep_map *lock
 	return;
 
 found_it:
-	if (!hlock->waittime_stamp)
-		return;
-
-	now = sched_clock();
-	waittime = now - hlock->waittime_stamp;
-	hlock->holdtime_stamp = now;
+	cpu = smp_processor_id();
+	if (hlock->waittime_stamp) {
+		now = sched_clock();
+		waittime = now - hlock->waittime_stamp;
+		hlock->holdtime_stamp = now;
+	}
 
 	stats = get_lock_stats(hlock->class);
-	if (hlock->read)
-		lock_time_inc(&stats->read_waittime, waittime);
-	else
-		lock_time_inc(&stats->write_waittime, waittime);
+	if (waittime) {
+		if (hlock->read)
+			lock_time_inc(&stats->read_waittime, waittime);
+		else
+			lock_time_inc(&stats->write_waittime, waittime);
+	}
+	if (lock->cpu != cpu)
+		stats->bounces[bounce_acquired + !!hlock->read]++;
 	put_lock_stats(stats);
+
+	lock->cpu = cpu;
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -430,16 +430,18 @@ static void seq_stats(struct seq_file *m
 		else
 			seq_printf(m, "%40s:", name);
 
+		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
 		seq_lock_time(m, &stats->write_waittime);
-		seq_puts(m, " ");
+		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
 		seq_lock_time(m, &stats->write_holdtime);
 		seq_puts(m, "\n");
 	}
 
 	if (stats->read_holdtime.nr) {
 		seq_printf(m, "%38s-R:", name);
+		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_read]);
 		seq_lock_time(m, &stats->read_waittime);
-		seq_puts(m, " ");
+		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_read]);
 		seq_lock_time(m, &stats->read_holdtime);
 		seq_puts(m, "\n");
 	}
@@ -469,26 +471,28 @@ static void seq_stats(struct seq_file *m
 	}
 	if (i) {
 		seq_puts(m, "\n");
-		seq_line(m, '.', 0, 40 + 1 + 8 * (14 + 1));
+		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
 		seq_puts(m, "\n");
 	}
 }
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.1\n");
-	seq_line(m, '-', 0, 40 + 1 + 8 * (14 + 1));
-	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s\n",
+	seq_printf(m, "lock_stat version 0.2\n");
+	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s\n",
 			"class name",
+			"con-bounces",
 			"contentions",
 			"waittime-min",
 			"waittime-max",
 			"waittime-total",
+			"acq-bounces",
 			"acquisitions",
 			"holdtime-min",
 			"holdtime-max",
 			"holdtime-total");
-	seq_line(m, '-', 0, 40 + 1 + 8 * (14 + 1));
+	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "\n");
 }
 
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -180,8 +180,8 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
-	lock_acquired(&lock->dep_map);
 done:
+	lock_acquired(&lock->dep_map);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));

-- 

