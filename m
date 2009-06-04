Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZFDG5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZFDG5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFDG4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:56:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZFDG4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:56:55 -0400
Message-ID: <4A27708C.6030703@cn.fujitsu.com>
Date: Thu, 04 Jun 2009 14:58:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com>
In-Reply-To: <20090530043739.GA12157@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> On Fri, May 29, 2009 at 06:53:42PM -0700, Paul E. McKenney wrote:
>> On Fri, May 29, 2009 at 04:29:30PM +0800, Lai Jiangshan wrote:
>>> Current get_online_cpus()/put_online_cpus() re-implement
>>> a rw_semaphore, so it is converted to a real rw_semaphore in this fix.
>>> It simplifies codes, and is good for read.
>>>
>>> And misc fix:
>>> 1) Add comments for cpu_hotplug.active_writer.
>>> 2) The theoretical disadvantage described in cpu_hotplug_begin()'s
>>>    comments is no longer existed when we use rw_semaphore,
>>>    so this part of comments was removed.
>>>
>>> [Impact: improve get_online_cpus()/put_online_cpus() ]
>> Actually, it turns out that for my purposes it is only necessary to check:
>>
>> 	cpu_hotplug.active_writer != NULL
>>
>> The only time that it is unsafe to invoke get_online_cpus() is when
>> in a notifier, and in that case the value of cpu_hotplug.active_writer
>> is stable.  There could be false positives, but these are harmless, as
>> the fallback is simply synchronize_sched().
>>
>> Even this is only needed should the deadlock scenario you pointed out
>> arise in practice.
>>
>> As Oleg noted, there are some "interesting" constraints on
>> get_online_cpus().  Adding Gautham Shenoy to CC for his views.
> 
> So, to put it in a sentence, get_online_cpus()/put_online_cpus() is a
> read-write semaphore with read-preference while allowing writer to
> downgrade to a reader when required.
> 
> Read-preference was one of the ways of allowing unsuspecting functions
> which need the protection against cpu-hotplug to end up seeking help of
> functions which also need protection against cpu-hotplug. IOW allow a
> single context to call get_online_cpus() without giving away to circular
> deadlock. A fair reader-write lock wouldn't allow that since in the
> presence of a write, the recursive reads would block, thereby causing a
> deadlock.
> 
> Also, around the time when this design was chosen, we had a whole bunch
> of functions which did try to take the original "cpu_hotplug_mutex"
> recursively. We could do well to use Lai's implementation if such
> functions have mended their ways since this would make it a lot simpler
> :-) . But I suspect it is easier said than done!
> 
> BTW, I second the idea of try_get_online_cpus(). I had myself proposed
> this idea a year back. http://lkml.org/lkml/2008/4/29/222.
> 
> 
> 

Add CC to Peter Zijlstra <peterz@infradead.org>

(This patch is against mainline but not for inclusion, it will adapted
against -mm when request)

Requst For Comments and Reviewing Hungeringly.

- Lockless for get_online_cpus()'s fast path
- Introduce try_get_online_cpus()

---
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2643d84..63b216c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -104,6 +104,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern int try_get_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -117,6 +118,7 @@ int cpu_down(unsigned int cpu);
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+static inline int try_get_online_cpus(void) { return 1; }
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 395b697..54d6e0d 100644
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
@@ -26,21 +28,26 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
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
 } cpu_hotplug;
 
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
-	mutex_init(&cpu_hotplug.lock);
-	cpu_hotplug.refcount = 0;
+	init_waitqueue_head(&cpu_hotplug.sleeping_readers);
+	atomic_set(&cpu_hotplug.refcount, 1);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -50,10 +57,20 @@ void get_online_cpus(void)
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
 
+	if (unlikely(!atomic_inc_not_zero(&cpu_hotplug.refcount))) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&cpu_hotplug.sleeping_readers, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (atomic_inc_not_zero(&cpu_hotplug.refcount))
+				break;
+			schedule();
+		}
+
+		finish_wait(&cpu_hotplug.sleeping_readers, &wait);
+	}
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
@@ -61,14 +78,27 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
 
+	if (unlikely(atomic_dec_and_test(&cpu_hotplug.refcount))) {
+		smp_mb__after_atomic_dec();
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
@@ -86,46 +116,41 @@ void cpu_maps_update_done(void)
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
+	smp_mb__before_atomic_dec();
+	atomic_dec(&cpu_hotplug.refcount);
 
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
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	atomic_inc(&cpu_hotplug.refcount);
+
+	if (waitqueue_active(&cpu_hotplug.sleeping_readers))
+		wake_up(&cpu_hotplug.sleeping_readers);
 }
+
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {


