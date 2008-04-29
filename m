Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbYD2NCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbYD2NCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYD2NCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:02:09 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:32889 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbYD2NCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:02:07 -0400
Date: Tue, 29 Apr 2008 18:32:01 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 5/8] cpu: cpu-hotplug deadlock
Message-ID: <20080429130201.GF23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: cpu: cpu-hotplug deadlock

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

cpu_hotplug.mutex is basically a lock-internal lock; but by keeping it locked
over the 'write' section (cpu_hotplug_begin/done) a lock inversion happens when
some of the write side code calls into code that would otherwise take a
read lock.

And it so happens that read-in-write recursion is expressly permitted.

Fix this by turning cpu_hotplug into a proper stand alone unfair reader/writer
lock that allows reader-in-reader and reader-in-writer recursion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/cpu.c |   97 +++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..e856c22 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -27,12 +27,13 @@ static int cpu_hotplug_disabled;
 
 static struct {
 	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
+	spinlock_t lock; /* Synchronizes accesses to refcount, */
 	/*
 	 * Also blocks the new readers during
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
+	wait_queue_head_t reader_queue;
 	wait_queue_head_t writer_queue;
 } cpu_hotplug;
 
@@ -41,8 +42,9 @@ static struct {
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
-	mutex_init(&cpu_hotplug.lock);
+	spin_lock_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
+	init_waitqueue_head(&cpu_hotplug.reader_queue);
 	init_waitqueue_head(&cpu_hotplug.writer_queue);
 }
 
@@ -51,27 +53,42 @@ void __init cpu_hotplug_init(void)
 void get_online_cpus(void)
 {
 	might_sleep();
+
+	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
-		return;
-	mutex_lock(&cpu_hotplug.lock);
+		goto unlock;
+
+	if (cpu_hotplug.active_writer) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&cpu_hotplug.reader_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!cpu_hotplug.active_writer)
+				break;
+			spin_unlock(&cpu_hotplug.lock);
+			schedule();
+			spin_lock(&cpu_hotplug.lock);
+		}
+		finish_wait(&cpu_hotplug.reader_queue, &wait);
+	}
 	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
-
+ unlock:
+	spin_unlock(&cpu_hotplug.lock);
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
 void put_online_cpus(void)
 {
+	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
-		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount--;
+		goto unlock;
 
-	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
+	cpu_hotplug.refcount--;
+	if (!cpu_hotplug.refcount)
 		wake_up(&cpu_hotplug.writer_queue);
-
-	mutex_unlock(&cpu_hotplug.lock);
-
+ unlock:
+	spin_unlock(&cpu_hotplug.lock);
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
@@ -95,45 +112,41 @@ void cpu_maps_update_done(void)
  * This ensures that the hotplug operation can begin only when the
  * refcount goes to zero.
  *
- * Note that during a cpu-hotplug operation, the new readers, if any,
- * will be blocked by the cpu_hotplug.lock
- *
- * Since cpu_maps_update_begin is always called after invoking
- * cpu_maps_update_begin, we can be sure that only one writer is active.
- *
- * Note that theoretically, there is a possibility of a livelock:
- * - Refcount goes to zero, last reader wakes up the sleeping
- *   writer.
- * - Last reader unlocks the cpu_hotplug.lock.
- * - A new reader arrives at this moment, bumps up the refcount.
- * - The writer acquires the cpu_hotplug.lock finds the refcount
- *   non zero and goes to sleep again.
- *
- * However, this is very difficult to achieve in practice since
- * get_online_cpus() not an api which is called all that often.
- *
+ * cpu_hotplug is basically an unfair recursive reader/writer lock that
+ * allows reader in writer recursion.
  */
 static void cpu_hotplug_begin(void)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&cpu_hotplug.lock);
+	might_sleep();
 
-	cpu_hotplug.active_writer = current;
-	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
-	while (cpu_hotplug.refcount) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
-		schedule();
-		mutex_lock(&cpu_hotplug.lock);
+	spin_lock(&cpu_hotplug.lock);
+	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&cpu_hotplug.writer_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!cpu_hotplug.refcount && !cpu_hotplug.active_writer)
+				break;
+			spin_unlock(&cpu_hotplug.lock);
+			schedule();
+			spin_lock(&cpu_hotplug.lock);
+		}
+		finish_wait(&cpu_hotplug.writer_queue, &wait);
 	}
-	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
+	cpu_hotplug.active_writer = current;
+	spin_unlock(&cpu_hotplug.lock);
 }
 
 static void cpu_hotplug_done(void)
 {
+	spin_lock(&cpu_hotplug.lock);
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
+		wake_up(&cpu_hotplug.writer_queue);
+	else
+		wake_up_all(&cpu_hotplug.reader_queue);
+	spin_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)
-- 
Thanks and Regards
gautham
