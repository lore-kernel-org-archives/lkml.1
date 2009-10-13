Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbZJMSat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbZJMSat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbZJMSat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:30:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZJMSas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:30:48 -0400
Date: Tue, 13 Oct 2009 20:29:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20091013182958.GA16311@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      oprofile: fix race condition in event_buffer free

Peter Zijlstra (1):
      lockdep: Use cpu_clock() for lockstat

Robert Richter (1):
      oprofile: warn on freeing event buffer too early


 drivers/oprofile/event_buffer.c |   35 ++++++++++++++++++++++++++---------
 kernel/lockdep.c                |   20 ++++++++++++--------
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 2b7ae36..5df60a6 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -35,12 +35,23 @@ static size_t buffer_pos;
 /* atomic_t because wait_event checks it outside of buffer_mutex */
 static atomic_t buffer_ready = ATOMIC_INIT(0);
 
-/* Add an entry to the event buffer. When we
- * get near to the end we wake up the process
- * sleeping on the read() of the file.
+/*
+ * Add an entry to the event buffer. When we get near to the end we
+ * wake up the process sleeping on the read() of the file. To protect
+ * the event_buffer this function may only be called when buffer_mutex
+ * is set.
  */
 void add_event_entry(unsigned long value)
 {
+	/*
+	 * This shouldn't happen since all workqueues or handlers are
+	 * canceled or flushed before the event buffer is freed.
+	 */
+	if (!event_buffer) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	if (buffer_pos == buffer_size) {
 		atomic_inc(&oprofile_stats.event_lost_overflow);
 		return;
@@ -69,7 +80,6 @@ void wake_up_buffer_waiter(void)
 
 int alloc_event_buffer(void)
 {
-	int err = -ENOMEM;
 	unsigned long flags;
 
 	spin_lock_irqsave(&oprofilefs_lock, flags);
@@ -80,21 +90,22 @@ int alloc_event_buffer(void)
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
 
+	buffer_pos = 0;
 	event_buffer = vmalloc(sizeof(unsigned long) * buffer_size);
 	if (!event_buffer)
-		goto out;
+		return -ENOMEM;
 
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 
 
 void free_event_buffer(void)
 {
+	mutex_lock(&buffer_mutex);
 	vfree(event_buffer);
-
+	buffer_pos = 0;
 	event_buffer = NULL;
+	mutex_unlock(&buffer_mutex);
 }
 
 
@@ -167,6 +178,12 @@ static ssize_t event_buffer_read(struct file *file, char __user *buf,
 
 	mutex_lock(&buffer_mutex);
 
+	/* May happen if the buffer is freed during pending reads. */
+	if (!event_buffer) {
+		retval = -EINTR;
+		goto out;
+	}
+
 	atomic_set(&buffer_ready, 0);
 
 	retval = -EFAULT;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3815ac1..9af5672 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -142,6 +142,11 @@ static inline struct lock_class *hlock_class(struct held_lock *hlock)
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
+static inline u64 lockstat_clock(void)
+{
+	return cpu_clock(smp_processor_id());
+}
+
 static int lock_point(unsigned long points[], unsigned long ip)
 {
 	int i;
@@ -158,7 +163,7 @@ static int lock_point(unsigned long points[], unsigned long ip)
 	return i;
 }
 
-static void lock_time_inc(struct lock_time *lt, s64 time)
+static void lock_time_inc(struct lock_time *lt, u64 time)
 {
 	if (time > lt->max)
 		lt->max = time;
@@ -234,12 +239,12 @@ static void put_lock_stats(struct lock_class_stats *stats)
 static void lock_release_holdtime(struct held_lock *hlock)
 {
 	struct lock_class_stats *stats;
-	s64 holdtime;
+	u64 holdtime;
 
 	if (!lock_stat)
 		return;
 
-	holdtime = sched_clock() - hlock->holdtime_stamp;
+	holdtime = lockstat_clock() - hlock->holdtime_stamp;
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (hlock->read)
@@ -2792,7 +2797,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
-	hlock->holdtime_stamp = sched_clock();
+	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
 	if (check == 2 && !mark_irqflags(curr, hlock))
@@ -3322,7 +3327,7 @@ found_it:
 	if (hlock->instance != lock)
 		return;
 
-	hlock->waittime_stamp = sched_clock();
+	hlock->waittime_stamp = lockstat_clock();
 
 	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
 	contending_point = lock_point(hlock_class(hlock)->contending_point,
@@ -3345,8 +3350,7 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	struct held_lock *hlock, *prev_hlock;
 	struct lock_class_stats *stats;
 	unsigned int depth;
-	u64 now;
-	s64 waittime = 0;
+	u64 now, waittime = 0;
 	int i, cpu;
 
 	depth = curr->lockdep_depth;
@@ -3374,7 +3378,7 @@ found_it:
 
 	cpu = smp_processor_id();
 	if (hlock->waittime_stamp) {
-		now = sched_clock();
+		now = lockstat_clock();
 		waittime = now - hlock->waittime_stamp;
 		hlock->holdtime_stamp = now;
 	}
