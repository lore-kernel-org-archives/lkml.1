Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZFIMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZFIMGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbZFIMFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:05:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50731 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758913AbZFIMFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:05:51 -0400
Message-ID: <4A2E506D.9090107@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 20:07:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: paulmck@linux.vnet.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       dipankar@in.ibm.com
Subject: [PATCH -mm] cpuhotplug: introduce try_get_online_cpus() take 3
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090605153714.GB6778@linux.vnet.ibm.com> <20090608041934.GB17979@in.ibm.com> <20090608142520.GA6961@linux.vnet.ibm.com>
In-Reply-To: <20090608142520.GA6961@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's for -mm tree.

It also works for mainline if you apply this at first:
http://lkml.org/lkml/2009/2/17/58

Subject: [PATCH -mm] cpuhotplug: introduce try_get_online_cpus() take 3

get_online_cpus() is a typically coarsely granular lock.
It's a source of ABBA deadlock.

Thanks to the CPU notifiers, Some subsystem's global lock will
be required after cpu_hotplug.lock. Subsystem's global lock
is coarsely granular lock too, thus a lot's of lock in kernel
should be required after cpu_hotplug.lock(if we need
cpu_hotplug.lock held too)

Otherwise it may come to a ABBA deadlock like this:

thread 1                                      |        thread 2
_cpu_down()                                   |  Lock a-kernel-lock.
  cpu_hotplug_begin()                         |
    down_write(&cpu_hotplug.lock)             |
  __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
------------------------------------------------------------------------
    Lock a-kernel-lock.(wait thread2)         |    down_read(&cpu_hotplug.lock)
                                                   (wait thread 1)

But CPU online/offline are happened very rarely, get_online_cpus()
returns success quickly in all probability.
So it's an asinine behavior that get_online_cpus() is not allowed
to be required after we had held "a-kernel-lock".

To dispel the ABBA deadlock, this patch introduces
try_get_online_cpus(). It returns fail very rarely. It gives the
caller a chance to select an alternative way to finish works,
instead of sleeping or deadlock.

Changed from V1
Lockless for get_online_cpus()'s fast path

Changed from V2
Fix patch as Oleg Nesterov valuable suggestions.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..eeb9ca5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -99,6 +99,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern int try_get_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -112,6 +113,7 @@ int cpu_down(unsigned int cpu);
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+static inline int try_get_online_cpus(void) { return 1; }
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 609fae1..afecc95 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,8 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <asm/atomic.h>
+#include <linux/wait.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -26,16 +28,23 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
  */
 static int cpu_hotplug_disabled;
 
+/*
+ * @cpu_hotplug is a special read-write semaphore with these semantics:
+ * 1) It is read-preference and allows reader-in-reader recursion.
+ * 2) It allows writer to downgrade to a reader when required.
+ *    (allows reader-in-writer recursion.)
+ * 3) It allows only one thread to require the write-side lock at most.
+ *    (cpu_add_remove_lock ensures it.)
+ */
 static struct {
 	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
-	/*
-	 * Also blocks the new readers during
-	 * an ongoing cpu hotplug operation.
-	 */
-	int refcount;
+	wait_queue_head_t sleeping_readers;
+	/* refcount = 0 means the writer owns the lock. */
+	atomic_t refcount;
 } cpu_hotplug = {
-	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
+	NULL,
+	__WAIT_QUEUE_HEAD_INITIALIZER(cpu_hotplug.sleeping_readers),
+	ATOMIC_INIT(1),
 };
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -45,10 +54,9 @@ void get_online_cpus(void)
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
 
+	wait_event(cpu_hotplug.sleeping_readers,
+		   likely(atomic_inc_not_zero(&cpu_hotplug.refcount)));
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
@@ -56,14 +64,27 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
 
+	if (unlikely(atomic_dec_and_test(&cpu_hotplug.refcount))) {
+		/* atomic_dec_and_test() implies smp_mb__after_atomic_dec() */
+		BUG_ON(!cpu_hotplug.active_writer);
+		wake_up_process(cpu_hotplug.active_writer);
+	}
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
+int try_get_online_cpus(void)
+{
+	if (cpu_hotplug.active_writer == current)
+		return 1;
+
+	if (likely(atomic_inc_not_zero(&cpu_hotplug.refcount)))
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(try_get_online_cpus);
+
 #endif	/* CONFIG_HOTPLUG_CPU */
 
 /*
@@ -81,46 +102,42 @@ void cpu_maps_update_done(void)
 }
 
 /*
- * This ensures that the hotplug operation can begin only when the
- * refcount goes to zero.
+ * This ensures that the hotplug operation can begin only when
+ * there is no ongoing reader.
  *
  * Note that during a cpu-hotplug operation, the new readers, if any,
- * will be blocked by the cpu_hotplug.lock
+ * will be blocked and queued at cpu_hotplug.sleeping_readers.
  *
  * Since cpu_hotplug_begin() is always called after invoking
  * cpu_maps_update_begin(), we can be sure that only one writer is active.
  *
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
  */
 static void cpu_hotplug_begin(void)
 {
 	cpu_hotplug.active_writer = current;
 
+	/* atomic_dec_and_test() implies smp_mb__before_atomic_dec() */
+	if (atomic_dec_and_test(&cpu_hotplug.refcount))
+		return;
+
 	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
-		if (likely(!cpu_hotplug.refcount))
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!atomic_read(&cpu_hotplug.refcount))
 			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
 	}
+
+	__set_current_state(TASK_RUNNING);
 }
 
 static void cpu_hotplug_done(void)
 {
+	atomic_inc(&cpu_hotplug.refcount);
+	wake_up_all(&cpu_hotplug.sleeping_readers);
+
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
 }
+
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {

