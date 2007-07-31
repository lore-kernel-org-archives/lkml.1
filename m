Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXGaNZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXGaNZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbXGaNYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:24:40 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49912
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761343AbXGaNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:24:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Tue, 31 Jul 2007 09:24:18 -0400
Message-ID: <20070731132416.4790.8971.stgit@novell1.haskins.net>
In-Reply-To: <20070731132153.4790.37217.stgit@novell1.haskins.net>
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

 arch/i386/kernel/smpcommon.c |   16 +-
 arch/ia64/kernel/smp.c       |    8 -
 arch/powerpc/kernel/smp.c    |   12 +
 arch/x86_64/kernel/smp.c     |   18 +-
 include/linux/smp.h          |   25 ++-
 include/linux/vfcipi.h       |   10 +
 init/main.c                  |    3 
 kernel/Kconfig.preempt       |   12 +
 kernel/Makefile              |    1 
 kernel/vfcipi/Makefile       |    4 
 kernel/vfcipi/heap.c         |  136 +++++++++++++++
 kernel/vfcipi/heap.h         |   20 ++
 kernel/vfcipi/thread.c       |  372 ++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 607 insertions(+), 30 deletions(-)

diff --git a/arch/i386/kernel/smpcommon.c b/arch/i386/kernel/smpcommon.c
index 1868ae1..e352773 100644
--- a/arch/i386/kernel/smpcommon.c
+++ b/arch/i386/kernel/smpcommon.c
@@ -25,7 +25,7 @@ __cpuinit void init_gdt(int cpu)
 
 
 /**
- * smp_call_function(): Run a function on all other CPUs.
+ * raw_smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: Unused.
@@ -39,15 +39,15 @@ __cpuinit void init_gdt(int cpu)
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
+int raw_smp_call_function(void (*func) (void *info), void *info,
+			       int nonatomic, int wait)
 {
 	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
-EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(raw_smp_call_function);
 
 /**
- * smp_call_function_single - Run a function on another CPU
+ * raw_smp_call_function_single - Run a function on another CPU
  * @cpu: The target CPU.  Cannot be the calling CPU.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -59,8 +59,8 @@ EXPORT_SYMBOL(smp_call_function);
  * If @wait is true, then returns once @func has returned; otherwise
  * it returns just before the target cpu calls @func.
  */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
+int raw_smp_call_function_single(int cpu, void (*func) (void *info),
+				      void *info, int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
 	int ret;
@@ -76,4 +76,4 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	put_cpu();
 	return ret;
 }
-EXPORT_SYMBOL(smp_call_function_single);
+EXPORT_SYMBOL(raw_smp_call_function_single);
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 2256b08..3c65867 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -374,7 +374,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
  */
 
 int
-smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
+raw_smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
 			  int wait)
 {
 	struct call_data_struct data;
@@ -413,7 +413,7 @@ smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int
 	put_cpu();
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_single);
+EXPORT_SYMBOL(raw_smp_call_function_single);
 
 /*
  * this function sends a 'generic call function' IPI to all other CPUs
@@ -435,7 +435,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * hardware interrupt handler or from a bottom half handler.
  */
 int
-smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
+raw_smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
 {
 	struct call_data_struct data;
 	int cpus;
@@ -473,7 +473,7 @@ smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wai
 	spin_unlock(&call_lock);
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(raw_smp_call_function);
 
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c4987d9..a6cfab8 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -283,15 +283,15 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
 	return ret;
 }
 
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+int raw_smp_call_function(void (*func) (void *info), void *info,
+			       int nonatomic, int wait)
 {
 	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
 }
-EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(raw_smp_call_function);
 
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+int raw_smp_call_function_single(int cpu, void (*func) (void *info),
+				      void *info, int nonatomic, int wait)
 {
 	cpumask_t map = CPU_MASK_NONE;
 	int ret = -EBUSY;
@@ -305,7 +305,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
 	put_cpu();
 	return ret;
 }
-EXPORT_SYMBOL(smp_call_function_single);
+EXPORT_SYMBOL(raw_smp_call_function_single);
 
 void smp_call_function_interrupt(void)
 {
diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index 8cf7a0d..aa77510 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -367,7 +367,7 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function_single - Run a function on another CPU
+ * raw_smp_call_function_single - Run a function on another CPU
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
+raw_smp_call_function_single (int cpu, void (*func) (void *info),
+				  void *info, int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
@@ -398,7 +398,7 @@ int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
 	put_cpu();
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_single);
+EXPORT_SYMBOL(raw_smp_call_function_single);
 
 /*
  * this function sends a 'generic call function' IPI to all other CPUs
@@ -437,7 +437,7 @@ static void __smp_call_function (void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function - run a function on all other CPUs.
+ * raw_smp_call_function - run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: currently unused.
@@ -451,15 +451,15 @@ static void __smp_call_function (void (*func) (void *info), void *info,
  * hardware interrupt handler or from a bottom half handler.
  * Actually there are a few legal cases, like panic.
  */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+int raw_smp_call_function (void (*func) (void *info), void *info,
+				int nonatomic, int wait)
 {
 	spin_lock(&call_lock);
 	__smp_call_function(func,info,nonatomic,wait);
 	spin_unlock(&call_lock);
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(raw_smp_call_function);
 
 static void stop_this_cpu(void *dummy)
 {
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 442f87b..d0b6d61 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -62,10 +62,29 @@ extern void smp_cpus_done(unsigned int max_cpus);
 /*
  * Call a function on all other processors
  */
-int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int retry, int wait);
+int raw_smp_call_function(void(*func)(void *info), void *info,
+			  int retry, int wait);
+
+int raw_smp_call_function_single(int cpuid, void (*func) (void *info),
+				 void *info, int retry, int wait);
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
+       raw_smp_call_function(func, info, retry, wait)
+#define smp_call_function_single(cpuid, func, info, retry, wait) \
+       raw_smp_call_function_single(cpuid, func, info, retry, wait)
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
index 0000000..45bb4e2
--- /dev/null
+++ b/kernel/vfcipi/thread.c
@@ -0,0 +1,372 @@
+/*
+ * kernel/vfcipi/thread
+ *
+ * Preemptible Function-Call-IPI Support
+ * -------------------------------------
+ *  This code allows FUNCTION_CALL IPIs to become preemptible by executing
+ *  them in kthread context instead of interrupt context.  They are referred
+ *  to as "Virtual Function Call IPIs" (VFCIPI) because we no longer rely
+ *  on the actual FCIPI facility.  Instead we schedule a thread to run.	 This
+ *  essentially replaces the synchronous FCIPI with an async RESCHEDULE IPI.
+ *
+ *  Since the function will be executed in kthread context, it is fully
+ *  sleepable and preemptible, thus providing more determinism.	 It also allows
+ *  code that was written to expect spin_locks to work properly, even though
+ *  they may have converted to rt_mutex under the hood.	 In summary, this
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
+	atomic_t	    curr;
+	int		    threshold;
+	struct task_struct *task;
+};
+
+struct vfcipi_workitem {
+	atomic_t	      ref;
+	void		     (*func)(void *data);
+	void		     *data;
+	int		      prio;
+	struct vfcipi_status  started;
+	struct vfcipi_status  finished;
+};
+
+struct vfcipi_queueitem {
+	struct list_head	list;
+	struct vfcipi_workitem *item;
+};
+
+struct vfcipi_task {
+	raw_spinlock_t	    lock;
+	struct task_struct *task;
+	struct prio_array   rt_rq; /* Real-time request queue */
+	struct list_head    rq;	   /* Normal request queue */
+};
+
+static DEFINE_PER_CPU(struct vfcipi_task*, vfcipi_tasks);
+
+/*
+ * ----------------------------------------
+ * vfcipi_status
+ * ----------------------------------------
+ */
+static void vfcipi_status_init(struct vfcipi_status *s, int threshold,
+			       int wait)
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
+static struct vfcipi_workitem*
+vfcipi_workitem_init(void (*func)(void *data), void *data, int nr_cpus,
+		     int wait)
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
+	 * Theres no need to wait for both a start and a finish event.	You
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
+		 * for the execution to at least start.	 This is how the
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
+					    raw_smp_processor_id());
+
+	while (1) {
+		struct vfcipi_workitem *item;
+		struct vfcipi_queueitem *qi = NULL;
+
+		spin_lock(&ftask->lock);
+		
+		if (!list_empty(&ftask->rq)) {
+			qi = list_first_entry(&ftask->rq,
+					      struct vfcipi_queueitem,
+					      list);
+			BUG_ON(!qi);
+			list_del(&qi->list);
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
+	struct vfcipi_task	*ftask = per_cpu(vfcipi_tasks, cpu);
+	struct vfcipi_queueitem *qi    = vfcipi_heap_alloc(sizeof(*qi));
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
+	list_add_tail(&qi->list, &ftask->rq);
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
+		goto out;
+
+	vfcipi_workitem_wait(item, wait);
+
+ out:
+	/* We are finished with the reference in this context */
+	vfcipi_workitem_dropref(item);
+
+	return ret;
+}
+
+static int vfcipi_call_function(void (*func)(void *data), void *data,
+			       int nonatomic, int wait)
+{
+	struct vfcipi_workitem *item;
+	int ret = 0;
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
+				goto out;
+		}
+	}
+
+	vfcipi_workitem_wait(item, wait);
+
+ out:
+	/* We are finished with the reference in this context */
+	vfcipi_workitem_dropref(item);
+
+	return ret;
+}
+
+struct vfcipi_vtable {
+	int (*call_single)(int cpu, void (*func)(void *data),
+			   void *data, int nonatomic, int wait);
+	int (*call_allbutself)(void (*func)(void *data), void *data,
+			       int nonatomic, int wait);
+};
+
+static struct vfcipi_vtable raw_vtable = {
+	.call_single	 = raw_smp_call_function_single,
+	.call_allbutself = raw_smp_call_function
+};
+
+static struct vfcipi_vtable threaded_vtable = {
+	.call_single	 = vfcipi_call_function_single,
+	.call_allbutself = vfcipi_call_function
+};
+
+/*
+ * By default the system will fall back on the __raw implementation
+ * since the __threaded version will not be online until the vfcipi_init()
+ * function has a chance to run
+ */
+static struct vfcipi_vtable *vfcipi_vtable = &raw_vtable;
+
+int smp_call_function_single(int cpu, void (*func)(void *data),
+			     void *data, int nonatomic, int wait)
+{
+	return vfcipi_vtable->call_single(cpu, func, data, nonatomic, wait);
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
+int smp_call_function(void (*func)(void *data), void *data,
+		      int nonatomic, int wait)
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
+		struct vfcipi_task *ftask = kzalloc(sizeof(*ftask),
+						    GFP_KERNEL);
+
+		if (!ftask)
+			goto out_free;
+
+		spin_lock_init(&ftask->lock);
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
+	old = xchg(&vfcipi_vtable, &threaded_vtable);
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

