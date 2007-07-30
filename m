Return-Path: <linux-kernel-owner+w=401wt.eu-S966923AbXG3QhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966923AbXG3QhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967195AbXG3QgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:36:00 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:40417
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967185AbXG3Qfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:35:55 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 12:35:54 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH][RFC] RT: Preemptible Function-Call-IPI Support
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       ghaskins@novell.com
Date: Mon, 30 Jul 2007 12:16:40 -0400
Message-ID: <20070730161123.5223.91476.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an RFC for the "Threaded IPI" idea I was talking about last
week on the linux-rt/kvm list.  It builds and boots fine for me.  However,
note the following:

1) Currently only x86_64 has been converted.  After I get more feedback I will
   convert the other relevant architectures as well
2) The priority-inheritance logic is non-functioning.  All FUNCTION_CALL IPIs
   are directed at a task with normal priority.  Eventually the task will
   inherit the priority of the highest waiter.

I have confirmed that KVM now shutdows cleanly in RT without modifying the KVM
code.

Comments/Suggestions/Bug-reports welcome!

Thanks!
-Greg

----------------------------------------------------------------

This code allows FUNCTION_CALL IPIs to become preemptible by executing
them in kthread context instead of interrupt context.  They are referred
to as "Virtual Function Call IPIs" (VFCIPI) because we no longer rely
on the actual FCIPI facility.  Instead we schedule a thread to run.  This
essentially replaces the synchronous FCIPI with an async RESCHEDULE IPI.

Since the function will be executed in kthread context, it is fully
sleepable and preemptible, thus providing more determinism.  It also allows
code that was written to expect spin_locks to work properly, even though
they may have converted to rt_mutex under the hood.  In summary, this
subsystem does for FCIPI interrupts what PREEMPT_HARDIRQs does for normal
interrupts.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86_64/kernel/smp.c |   18 +-
 include/linux/smp.h      |   25 ++-
 include/linux/vfcipi.h   |   10 +
 init/main.c              |    3 
 kernel/Kconfig.preempt   |   12 +
 kernel/Makefile          |    1 
 kernel/vfcipi/Makefile   |    4 
 kernel/vfcipi/heap.c     |  136 ++++++++++++++
 kernel/vfcipi/heap.h     |   20 ++
 kernel/vfcipi/thread.c   |  445 ++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 662 insertions(+), 12 deletions(-)

diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index 8cf7a0d..71fbe2f 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -367,7 +367,7 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function_single - Run a function on another CPU
+ * smp_call_function_single__nodelay - Run a function on another CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: Currently unused.
@@ -378,9 +378,9 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
  * Does not return until the remote CPU is nearly ready to execute <func>
  * or is or has executed.
  */
-
-int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
-	int nonatomic, int wait)
+int
+smp_call_function_single__nodelay (int cpu, void (*func) (void *info),
+				  void *info, int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
@@ -398,7 +398,7 @@ int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
 	put_cpu();
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_single);
+EXPORT_SYMBOL(smp_call_function_single__nodelay);
 
 /*
  * this function sends a 'generic call function' IPI to all other CPUs
@@ -437,7 +437,7 @@ static void __smp_call_function (void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function - run a function on all other CPUs.
+ * smp_call_function__nodelay - run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: currently unused.
@@ -451,15 +451,15 @@ static void __smp_call_function (void (*func) (void *info), void *info,
  * hardware interrupt handler or from a bottom half handler.
  * Actually there are a few legal cases, like panic.
  */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+int smp_call_function__nodelay (void (*func) (void *info), void *info,
+				int nonatomic, int wait)
 {
 	spin_lock(&call_lock);
 	__smp_call_function(func,info,nonatomic,wait);
 	spin_unlock(&call_lock);
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(smp_call_function__nodelay);
 
 static void stop_this_cpu(void *dummy)
 {
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 442f87b..5017a97 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -62,10 +62,29 @@ extern void smp_cpus_done(unsigned int max_cpus);
 /*
  * Call a function on all other processors
  */
-int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int retry, int wait);
+int smp_call_function__nodelay(void(*func)(void *info), void *info,
+			       int retry, int wait);
+
+int smp_call_function_single__nodelay(int cpuid, void (*func) (void *info),
+				      void *info, int retry, int wait);
+
+#ifdef CONFIG_PREEMPT_FCIPI
+
+int smp_call_function(void(*func)(void *info), void *info,
+		      int retry, int wait);
+
+int smp_call_function_single(int cpuid, void (*func) (void *info),
+			     void *info, int retry, int wait);
+
+#else
+
+#define smp_call_function(func, info, retry, wait)  \
+       smp_call_function__nodelay(func, info, retry, wait)
+#define smp_call_function_single(cpuid, func, info, retry, wait) \
+       smp_call_function_single__nodelay(cpuid, func, info, retry, wait)
+
+#endif /* CONFIG_PREEMPT_FCIPI */
 
 /*
  * Call a function on all processors
diff --git a/include/linux/vfcipi.h b/include/linux/vfcipi.h
new file mode 100644
index 0000000..8cedf21
--- /dev/null
+++ b/include/linux/vfcipi.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_VFCIPI_H
+#define _LINUX_VFCIPI_H
+
+#ifdef CONFIG_PREEMPT_FCIPI
+extern int vfcipi_init(void);
+#else
+#define vfcipi_init() {}
+#endif
+
+#endif /* */
diff --git a/init/main.c b/init/main.c
index 9829b27..ff28740 100644
--- a/init/main.c
+++ b/init/main.c
@@ -57,6 +57,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/vfcipi.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -842,6 +843,8 @@ static int __init kernel_init(void * unused)
 
 	do_basic_setup();
 
+	vfcipi_init();
+
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 8355494..f509ccf 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -120,6 +120,18 @@ config PREEMPT_HARDIRQS
 
 	  Say N if you are unsure.
 
+config PREEMPT_FCIPI
+	bool "Thread Function-Call Interprocessor Interrupts"
+	default n
+	depends on SMP
+	help
+	  This option reduces the latency of the kernel by 'threading'
+          FUNCTION_CALL IPIs. This means that all (or selected) FCIPIs will
+	  run in their own kernel thread context. While this helps latency,
+          this feature can also reduce performance.
+
+	  Say N if you are unsure.
+
 config SPINLOCK_BKL
 	bool "Old-Style Big Kernel Lock"
 	depends on (PREEMPT || SMP) && !PREEMPT_RT
diff --git a/kernel/Makefile b/kernel/Makefile
index e592de8..ab1a8ae 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_PREEMPT_RT) += rt.o
+obj-$(CONFIG_PREEMPT_FCIPI) += vfcipi/
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += cpu.o spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
diff --git a/kernel/vfcipi/Makefile b/kernel/vfcipi/Makefile
new file mode 100644
index 0000000..55100fa
--- /dev/null
+++ b/kernel/vfcipi/Makefile
@@ -0,0 +1,4 @@
+
+obj-y := thread.o
+obj-$(CONFIG_PREEMPT_RT) += heap.o
+
diff --git a/kernel/vfcipi/heap.c b/kernel/vfcipi/heap.c
new file mode 100644
index 0000000..5fc4c5e
--- /dev/null
+++ b/kernel/vfcipi/heap.c
@@ -0,0 +1,136 @@
+/*
+ * kernel/vfcipi/heap
+ *
+ * kmalloc(GFP_ATOMIC) is currently broken on RT.  This file implements a
+ * simple heap manager that supports true GFP_ATOMIC like guarantees in the
+ * interim.
+ *
+ * Copyright (C) 2007 Novell, Gregory Haskins <ghaskins@novell.com>
+ *
+ * This code is licensed under the GPLv2
+ */
+
+#include <linux/sched.h>
+
+struct vfcipi_heap {
+	raw_spinlock_t   lock;
+	char            *data;
+	int              element_size;
+	struct list_head free;
+	struct list_head inuse;
+};
+
+#define VFCIPI_HEAP_MAGIC 0xf347ab23
+
+struct vfcipi_heap_item {
+	u32                 magic;
+	struct vfcipi_heap *heap;
+	struct list_head    list;
+	u8                  inuse;
+	char                data[1];
+};
+
+static __init int _vfcipi_heap_init(struct vfcipi_heap *heap,
+				    int element_size, int nr_elements)
+{
+	size_t actual_size = (element_size + sizeof(struct vfcipi_heap_item) - 1);
+	int i;
+
+	heap->data = kzalloc(actual_size * nr_elements, GFP_KERNEL);
+	if (!heap->data)
+		return -ENOMEM;
+
+	spin_lock_init(&heap->lock);
+	heap->element_size = element_size;
+	INIT_LIST_HEAD(&heap->free);
+	INIT_LIST_HEAD(&heap->inuse);
+
+	for (i = 0; i<nr_elements; ++i) {
+		struct vfcipi_heap_item *hi;
+		size_t offset = i*actual_size;
+
+		hi = (struct vfcipi_heap_item*)&heap->data[offset];
+
+		hi->magic = VFCIPI_HEAP_MAGIC;
+		hi->heap  = heap;
+		hi->inuse = 0;
+		INIT_LIST_HEAD(&hi->list);
+		list_add_tail(&hi->list, &heap->free);
+	}
+
+	return 0;
+}
+
+static void* _vfcipi_heap_alloc(struct vfcipi_heap *heap)
+{
+	void *ptr = NULL;
+	struct vfcipi_heap_item *hi;
+
+	spin_lock(&heap->lock);
+
+	if (!list_empty(&heap->free)) {
+		hi = list_first_entry(&heap->free,
+				      struct vfcipi_heap_item, list);
+		BUG_ON(!hi);
+		list_del_init(&hi->list);
+
+		ptr = &hi->data[0];
+
+		list_add_tail(&hi->list, &heap->inuse);
+		hi->inuse = 1;
+
+	}
+
+	spin_unlock(&heap->lock);
+
+	return ptr;
+}
+
+void vfcipi_heap_free(void *ptr)
+{
+	struct vfcipi_heap_item *hi;
+	struct vfcipi_heap *heap;
+
+	hi = container_of(ptr, struct vfcipi_heap_item, data);
+
+	BUG_ON(hi->magic != VFCIPI_HEAP_MAGIC);
+	BUG_ON(!hi->inuse);
+
+	heap = hi->heap;
+
+	spin_lock(&heap->lock);
+
+	list_del_init(&hi->list);
+	list_add_tail(&hi->list, &heap->free);
+	hi->inuse = 0;
+
+	spin_unlock(&heap->lock);
+}
+
+static struct vfcipi_heap vfcipi_heap;
+
+__init void vfcipi_heap_init(int element_size, int nr_elements)
+{
+	_vfcipi_heap_init(&vfcipi_heap, element_size, nr_elements);
+}
+
+void* vfcipi_heap_alloc(size_t size)
+{
+	BUG_ON(size > vfcipi_heap.element_size);
+
+	return _vfcipi_heap_alloc(&vfcipi_heap);
+}
+
+void* vfcipi_heap_zalloc(size_t size)
+{
+	void *ptr = vfcipi_heap_alloc(size);
+	if (ptr)
+		memset(ptr, 0, size);
+
+	return ptr;
+}
+
+
+
+
+
diff --git a/kernel/vfcipi/heap.h b/kernel/vfcipi/heap.h
new file mode 100644
index 0000000..3cd264e
--- /dev/null
+++ b/kernel/vfcipi/heap.h
@@ -0,0 +1,20 @@
+#ifndef _VFCIPI_HEAP_H
+#define _VFCIPI_HEAP_H
+
+#ifdef CONFIG_PREEMPT_RT
+
+void vfcipi_heap_init(int element_size, int nr_elements);
+void* vfcipi_heap_alloc(size_t);
+void* vfcipi_heap_zalloc(size_t);
+void  vfcipi_heap_free(void *);
+
+#else
+
+#define vfcipi_heap_init(element_size, nr_elements) {}
+#define vfcipi_heap_alloc(size_t size) kmalloc(size, GFP_ATOMIC);
+#define vfcipi_heap_alloc(size_t size) kzalloc(size, GFP_ATOMIC);
+#define vfcipi_heap_free(void *ptr)    kfree(ptr);
+
+#endif
+
+#endif /* _VFCIPI_HEAP_H */
diff --git a/kernel/vfcipi/thread.c b/kernel/vfcipi/thread.c
new file mode 100644
index 0000000..f542926
--- /dev/null
+++ b/kernel/vfcipi/thread.c
@@ -0,0 +1,445 @@
+/*
+ * kernel/vfcipi/thread
+ *
+ * Preemptible Function-Call-IPI Support
+ * -------------------------------------
+ *  This code allows FUNCTION_CALL IPIs to become preemptible by executing
+ *  them in kthread context instead of interrupt context.  They are referred
+ *  to as "Virtual Function Call IPIs" (VFCIPI) because we no longer rely
+ *  on the actual FCIPI facility.  Instead we schedule a thread to run.  This
+ *  essentially replaces the synchronous FCIPI with an async RESCHEDULE IPI.
+ *
+ *  Since the function will be executed in kthread context, it is fully
+ *  sleepable and preemptible, thus providing more determinism.  It also allows
+ *  code that was written to expect spin_locks to work properly, even though
+ *  they may have converted to rt_mutex under the hood.  In summary, this
+ *  subsystem does for FCIPI interrupts what PREEMPT_HARDIRQs does for normal
+ *  interrupts.
+ *
+ * Copyright (C) 2007 Novell, Gregory Haskins <ghaskins@novell.com>
+ *
+ * This code is licensed under the GPLv2
+ */
+
+#include <linux/sched.h>
+#include <linux/kthread.h>
+#include <linux/hardirq.h>
+#include <linux/irqflags.h>
+#include <linux/module.h>
+#include <linux/cpumask.h>
+
+#include <asm/atomic.h>
+#include <asm/cmpxchg.h>
+
+#include "heap.h"
+
+struct vfcipi_status {
+	atomic_t            curr;
+	int                 threshold;
+	struct task_struct *task;
+};
+
+struct vfcipi_workitem {
+	atomic_t              ref;
+	void                 (*func)(void *data);
+	void                 *data;
+	int                   prio;
+	struct vfcipi_status  started;
+	struct vfcipi_status  finished;
+};
+
+struct vfcipi_queueitem {
+	struct list_head        list;
+	struct vfcipi_workitem *item;
+};
+
+struct prio_array {
+	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
+	unsigned long    count;
+	struct list_head queue[MAX_RT_PRIO];
+};
+
+struct vfcipi_task {
+	raw_spinlock_t      lock;
+	struct task_struct *task;
+	struct prio_array   rt_rq; /* Real-time request queue */
+	struct list_head    rq;    /* Normal request queue */
+};
+
+static DEFINE_PER_CPU(struct vfcipi_task*, vfcipi_tasks);
+
+/*
+ * ----------------------------------------
+ * prio_array
+ * ----------------------------------------
+ */
+static void prio_array_init(struct prio_array *array)
+{
+	int i;
+
+	memset(array->bitmap, 0, sizeof(array->bitmap));
+	array->count = 0;
+
+	for (i=0; i<MAX_RT_PRIO; i++)
+		INIT_LIST_HEAD(&array->queue[i]);
+}
+
+/* Note: prio_array code credit goes to the RT scheduler...*/
+static struct vfcipi_queueitem* prio_array_dequeue(struct prio_array *array)
+{
+	struct list_head       *head;
+	struct vfcipi_queueitem *qi;
+	int                     idx;
+
+	if (!array->count)
+		return NULL;
+
+	idx = sched_find_first_bit(array->bitmap);
+
+	head = array->queue + idx;
+
+	/* If we got here, there better be something in the list */
+	BUG_ON(!head);
+	BUG_ON(list_empty(head));
+
+	qi = list_first_entry(head, struct vfcipi_queueitem, list);
+	BUG_ON(!qi);
+
+	list_del(&qi->list);
+	array->count--;
+
+	if (list_empty(head))
+		__clear_bit(idx, &array->bitmap);
+
+	return qi;
+}
+
+static void prio_array_enqueue(struct prio_array *array,
+			       struct vfcipi_queueitem *qi,
+			       int prio)
+{
+	struct list_head *head;
+
+	BUG_ON(prio > MAX_RT_PRIO);
+
+	head = array->queue + prio;
+	list_add_tail(&qi->list, head);
+	__set_bit(prio, &array->bitmap);
+	array->count++;
+}
+
+/*
+ * ----------------------------------------
+ * vfcipi_status
+ * ----------------------------------------
+ */
+static void vfcipi_status_init(struct vfcipi_status *s, int threshold, int wait)
+{
+	atomic_set(&s->curr, 0);
+	s->threshold = threshold;
+
+	if (wait && !in_atomic() && !irqs_disabled())
+		s->task = current;
+}
+
+static void vfcipi_status_signal(struct vfcipi_status *s)
+{
+	int curr = atomic_inc_return(&s->curr);
+
+	if (s->task && (curr >= s->threshold))
+		wake_up_process(s->task);
+}
+
+static void vfcipi_status_wait(struct vfcipi_status *s)
+{
+	while (1) {
+		if (s->task)
+			set_current_state(TASK_UNINTERRUPTIBLE);
+
+		if (atomic_read(&s->curr) != s->threshold) {
+			if (s->task) {
+				schedule();
+			} else
+				cpu_relax();
+		} else
+			break;
+	}
+
+	set_current_state(TASK_RUNNING);
+}
+
+/*
+ * ----------------------------------------
+ * vfcipi_workitem
+ * ----------------------------------------
+ */
+static struct vfcipi_workitem* vfcipi_workitem_init(void (*func)(void *data),
+					  void *data, int nr_cpus, int wait)
+{
+	struct vfcipi_workitem *item = vfcipi_heap_zalloc(sizeof(*item));
+	if (!item)
+		return NULL;
+
+	atomic_set(&item->ref, 1);
+	item->func = func;
+	item->data = data;
+	item->prio = -1;
+
+	/*
+	 * Theres no need to wait for both a start and a finish event.  You
+	 * really only need one.  Therefore, we exclusively select one based
+	 * on the *wait* variable
+	 */
+	vfcipi_status_init(&item->started, nr_cpus, !wait);
+	vfcipi_status_init(&item->finished, nr_cpus, wait);
+
+	return item;
+}
+
+static void vfcipi_workitem_dropref(struct vfcipi_workitem *item)
+{
+	if (atomic_dec_and_test(&item->ref))
+		vfcipi_heap_free(item);
+}
+
+static void vfcipi_workitem_wait(struct vfcipi_workitem *item, int wait)
+{
+	if (!wait)
+		/*
+		 * If the user indicated we should not wait, we will still wait
+		 * for the execution to at least start.  This is how the
+		 * standard IPI based FUNCTION_CALL works, so we will replicate
+		 * that behavior.
+		 */
+		vfcipi_status_wait(&item->started);
+	else
+		/*
+		 * Likewise, if they selected to wait, we will wait until the
+		 * function completes entirely.
+		 */
+		vfcipi_status_wait(&item->finished);
+
+	/* We are finished with the reference in this context */
+	vfcipi_workitem_dropref(item);
+}
+
+/*
+ * ----------------------------------------
+ * vfcipi_thread - daemon process for vfcipi per CPU
+ * ----------------------------------------
+ */
+static int vfcipi_thread(void *data)
+{
+	struct vfcipi_task *ftask = per_cpu(vfcipi_tasks,
+					   raw_smp_processor_id());
+
+	while (1) {
+		struct vfcipi_workitem *item;
+		struct vfcipi_queueitem *qi;
+
+		spin_lock(&ftask->lock);
+
+		/* First check the RT items */
+		qi  = prio_array_dequeue(&ftask->rt_rq);
+		if (!qi) {
+			/* If nothing is found there, check the normal queue */
+			if (!list_empty(&ftask->rq)) {
+				qi = list_first_entry(&ftask->rq,
+						      struct vfcipi_queueitem,
+						      list);
+				BUG_ON(!qi);
+				list_del(&qi->list);
+			}
+		}
+
+		if (!qi) {
+			/* Nothing to process for now.. */
+			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock(&ftask->lock);
+			schedule();
+			continue;
+		}
+
+		spin_unlock(&ftask->lock);
+
+		/*
+		 * Extract the real pointer and discard the queueitem shell.
+		 * We no longer need it.
+		 */
+		item = qi->item;
+		vfcipi_heap_free(qi);
+
+		/*
+		 * Execute the actual user-provided function
+		 */
+		vfcipi_status_signal(&item->started);
+		item->func(item->data);
+		vfcipi_status_signal(&item->finished);
+
+		vfcipi_workitem_dropref(item);
+	}
+}
+
+/*
+ * ----------------------------------------
+ * client side code
+ * ----------------------------------------
+ */
+static int vfcipi_enqueue(struct vfcipi_workitem *item, int cpu)
+{
+	struct vfcipi_task *ftask = per_cpu(vfcipi_tasks, cpu);
+	struct vfcipi_queueitem *qi = vfcipi_heap_alloc(sizeof(*qi));
+
+	BUG_ON(!ftask);
+
+	if (!qi)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&qi->list);
+	qi->item = item;
+
+	/*
+	 * We increment the ref count here right before the list insertion.
+	 * It will get decremented when the kthread finishes processing it
+	 */
+	atomic_inc(&item->ref);
+
+	spin_lock(&ftask->lock);
+
+#ifdef NOT_YET
+	if (rt_task(current)) {
+		item->prio = task_prio(current);
+		prio_array_enqueue(&ftask->rt_rq, qi, item->prio);
+
+		/* Priority inheritance on the kthread */
+		if (task_prio(ftask->task) < item->prio)
+			set_prio_somehow(ftask->task, item->prio);
+	} else
+#endif
+		list_add_tail(&qi->list, &ftask->rq);
+
+	wake_up_process(ftask->task);
+
+	spin_unlock(&ftask->lock);
+
+	return 0;
+}
+
+static int vfcipi_call_function_single(int cpu, void (*func)(void *data),
+				      void *data, int nonatomic, int wait)
+{
+	struct vfcipi_workitem *item;
+	int ret;
+
+	item = vfcipi_workitem_init(func, data, 1, wait);
+
+	ret = vfcipi_enqueue(item, cpu);
+	if (ret < 0)
+		return ret;
+
+	vfcipi_workitem_wait(item, wait);
+
+	return 0;
+}
+
+static int vfcipi_call_function(void (*func)(void *data), void *data,
+			       int nonatomic, int wait)
+{
+	struct vfcipi_workitem *item;
+	int ret;
+	int cpu;
+	int mycpu = raw_smp_processor_id();
+	int nr_cpus = num_online_cpus()-1;
+
+	item = vfcipi_workitem_init(func, data, nr_cpus, wait);
+
+	for_each_online_cpu(cpu) {
+		if (cpu != mycpu) {
+			ret = vfcipi_enqueue(item, cpu);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	vfcipi_workitem_wait(item, wait);
+
+	return 0;
+}
+
+struct vfcipi_vtable {
+	int (*call_single)(int cpu, void (*func)(void *data),
+			   void *data, int nonatomic, int wait);
+	int (*call_allbutself)(void (*func)(void *data), void *data,
+			       int nonatomic, int wait);
+};
+
+static struct vfcipi_vtable vfcipi_vtable__nodelay = {
+	.call_single     = smp_call_function_single__nodelay,
+	.call_allbutself = smp_call_function__nodelay
+};
+
+static struct vfcipi_vtable vfcipi_vtable__threaded = {
+	.call_single     = vfcipi_call_function_single,
+	.call_allbutself = vfcipi_call_function
+};
+
+/*
+ * By default the system will fall back on the __nodelay implementation
+ * since the __threaded version will not be online until the vfcipi_init()
+ * function has a chance to run
+ */
+static struct vfcipi_vtable *vfcipi_vtable = &vfcipi_vtable__nodelay;
+
+int smp_call_function_single(int cpu, void (*func)(void *data),
+				       void *data, int nonatomic, int wait)
+{
+	return vfcipi_vtable->call_single(cpu, func, data, nonatomic, wait);
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
+int smp_call_function(void (*func)(void *data), void *data,
+				int nonatomic, int wait)
+{
+	return vfcipi_vtable->call_allbutself(func, data, nonatomic, wait);
+}
+EXPORT_SYMBOL(smp_call_function);
+
+int __init vfcipi_init(void)
+{
+	int cpu;
+	struct vfcipi_vtable *old;
+
+	vfcipi_heap_init(sizeof(struct vfcipi_workitem), 4096);
+
+	for_each_present_cpu(cpu) {
+		struct vfcipi_task *ftask = kzalloc(sizeof(*ftask), GFP_KERNEL);
+
+		if (!ftask)
+			goto out_free;
+
+		spin_lock_init(&ftask->lock);
+		prio_array_init(&ftask->rt_rq);
+		INIT_LIST_HEAD(&ftask->rq);
+		per_cpu(vfcipi_tasks, cpu) = ftask;
+
+		ftask->task = kthread_create(vfcipi_thread, NULL,
+					     "vfcipi/%d", cpu);
+		kthread_bind(ftask->task, cpu);
+
+		wake_up_process(ftask->task);
+	}
+
+	/* Now atomically switch to threaded mode */
+	old = xchg(&vfcipi_vtable, &vfcipi_vtable__threaded);
+
+	return 0;
+
+ out_free:
+	for_each_present_cpu(cpu) {
+		struct vfcipi_task *ftask = per_cpu(vfcipi_tasks, cpu);
+		kfree(ftask);
+		per_cpu(vfcipi_tasks, cpu) = NULL;
+	}
+
+	return -ENOMEM;
+}

