Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbZJMULV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbZJMULV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934282AbZJMULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:19 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43646 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934284AbZJMULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:15 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 7
	times
Message-Id: <20091013200302.142601669@gentwo.org>
References: <20091013200233.260324963@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Oct 2009 16:02:34 -0400
From: Christoph Lameter <cl@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC In-kernel benchmarks 1/3] Add slab performance tests
Content-Disposition: inline; filename=0001-Add-slab-performance-tests.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a test of slab allocator performance tests.

Run

	modprobe slab_test

to execute.  Output will be written to the syslog.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 Makefile          |    2 
 include/Kbuild    |    1 
 lib/Kconfig.debug |    1 
 tests/Kconfig     |   19 ++
 tests/Makefile    |    2 
 tests/slab_test.c |  373 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100644 tests/Makefile
 create mode 100644 tests/slab_test.c

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile	2009-10-12 15:32:26.000000000 -0500
+++ linux-2.6/Makefile	2009-10-12 15:32:30.000000000 -0500
@@ -686,7 +686,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ tests/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
Index: linux-2.6/include/Kbuild
===================================================================
--- linux-2.6.orig/include/Kbuild	2009-10-12 15:32:26.000000000 -0500
+++ linux-2.6/include/Kbuild	2009-10-12 15:32:30.000000000 -0500
@@ -10,3 +10,4 @@ header-y += video/
 header-y += drm/
 header-y += xen/
 header-y += scsi/
+header-y += tests/
Index: linux-2.6/tests/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/tests/Makefile	2009-10-12 15:32:30.000000000 -0500
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BENCHMARK_SLAB) += slab_test.o
+
Index: linux-2.6/tests/slab_test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/tests/slab_test.c	2009-10-12 15:32:47.000000000 -0500
@@ -0,0 +1,373 @@
+/* test-slab.c
+ *
+ * Test module for synthetic in kernel slab allocator testing.
+ *
+ * The test is triggered by loading the module (which will fail).
+ *
+ * (C) 2009 Linux Foundation <cl@linux-foundation.org>
+ */
+
+
+#include <linux/jiffies.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/timex.h>
+#include <asm/system.h>
+
+#define TEST_COUNT 10000
+
+#ifdef CONFIG_SMP
+#include <linux/completion.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+
+static struct test_struct {
+	struct task_struct *task;
+	int cpu;
+	int size;
+	int count;
+	void **v;
+	void (*test_p1)(struct test_struct *);
+	void (*test_p2)(struct test_struct *);
+	unsigned long start1;
+	unsigned long stop1;
+	unsigned long start2;
+	unsigned long stop2;
+} test[NR_CPUS];
+
+/*
+ * Allocate TEST_COUNT objects on cpus > 0 and then all the
+ * objects later on cpu 0
+ */
+static void remote_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	/* Perform no allocations on cpu 0 */
+	for (i = 0; i < t->count; i++) {
+		u8 *p;
+
+		if (smp_processor_id()) {
+			p = kmalloc(t->size, GFP_KERNEL);
+			/* Use object */
+			*p = 17;
+		} else
+			p = NULL;
+		t->v[i] = p;
+	}
+}
+
+static void remote_free_test_p2(struct test_struct *t)
+{
+	int i;
+	int cpu;
+
+	/* All frees are completed on cpu zero */
+	if (smp_processor_id())
+		return;
+
+	for_each_online_cpu(cpu)
+		for (i = 0; i < t->count; i++) {
+			u8 *p = test[cpu].v[i];
+
+			if (!p)
+				continue;
+
+			*p = 16;
+			kfree(p);
+		}
+}
+
+/*
+ * Allocate TEST_COUNT objects on cpu 0 and free them immediately on the
+ * other processors.
+ */
+static void alloc_n_free_test_p1(struct test_struct *t)
+{
+	int i;
+	int cpu;
+	char *p;
+
+	if (smp_processor_id()) {
+		/* Consumer */
+		for (i = 0; i < t->count / num_online_cpus(); i++) {
+			do {
+				p = t->v[i];
+				if (!p)
+					cpu_relax();
+				else
+					*p = 17;
+			} while (!p);
+			kfree(p);
+			t->v[i] = NULL;
+		}
+		return;
+	}
+	/* Producer */
+	for (i = 0; i < t->count; i++) {
+		for_each_online_cpu(cpu) {
+			if (cpu) {
+				p = kmalloc(t->size, GFP_KERNEL);
+				/* Use object */
+				*p = 17;
+				test[cpu].v[i] = p;
+			}
+		}
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects and later free them all again
+ */
+static void kmalloc_alloc_then_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		u8 *p = kmalloc(t->size, GFP_KERNEL);
+
+		*p = 14;
+		t->v[i] = p;
+	}
+}
+
+static void kmalloc_alloc_then_free_test_p2(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		u8 *p = t->v[i];
+
+		*p = 13;
+		kfree(p);
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects. Free them immediately.
+ */
+static void kmalloc_alloc_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < TEST_COUNT; i++) {
+		u8 *p = kmalloc(t->size, GFP_KERNEL);
+
+		*p = 12;
+		kfree(p);
+	}
+}
+
+static atomic_t tests_running;
+static atomic_t phase1_complete;
+static DECLARE_COMPLETION(completion1);
+static DECLARE_COMPLETION(completion2);
+static int started;
+
+static int test_func(void *private)
+{
+	struct test_struct *t = private;
+	cpumask_t newmask = CPU_MASK_NONE;
+
+        cpu_set(t->cpu, newmask);
+        set_cpus_allowed(current, newmask);
+	t->v = kzalloc(t->count * sizeof(void *), GFP_KERNEL);
+
+	atomic_inc(&tests_running);
+	wait_for_completion(&completion1);
+	t->start1 = get_cycles();
+	t->test_p1(t);
+	t->stop1 = get_cycles();
+	atomic_inc(&phase1_complete);
+	wait_for_completion(&completion2);
+	t->start2 = get_cycles();
+	if (t->test_p2)
+		t->test_p2(t);
+	t->stop2 = get_cycles();
+	kfree(t->v);
+	atomic_dec(&tests_running);
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule();
+	return 0;
+}
+
+static void do_concurrent_test(void (*p1)(struct test_struct *),
+		void (*p2)(struct test_struct *),
+		int size, const char *name)
+{
+	int cpu;
+	unsigned long time1 = 0;
+	unsigned long time2 = 0;
+	unsigned long sum1 = 0;
+	unsigned long sum2 = 0;
+
+	atomic_set(&tests_running, 0);
+	atomic_set(&phase1_complete, 0);
+	started = 0;
+	init_completion(&completion1);
+	init_completion(&completion2);
+
+	for_each_online_cpu(cpu) {
+		struct test_struct *t = &test[cpu];
+
+		t->cpu = cpu;
+		t->count = TEST_COUNT;
+		t->test_p1 = p1;
+		t->test_p2 = p2;
+		t->size = size;
+		t->task = kthread_run(test_func, t, "test%d", cpu);
+		if (IS_ERR(t->task)) {
+			printk("Failed to start test func\n");
+			return;
+		}
+	}
+
+	/* Wait till all processes are running */
+	while (atomic_read(&tests_running) < num_online_cpus()) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	complete_all(&completion1);
+
+	/* Wait till all processes have completed phase 1 */
+	while (atomic_read(&phase1_complete) < num_online_cpus()) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	complete_all(&completion2);
+
+	while (atomic_read(&tests_running)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+
+	for_each_online_cpu(cpu)
+		kthread_stop(test[cpu].task);
+
+	printk(KERN_ALERT "%s(%d):", name, size);
+	for_each_online_cpu(cpu) {
+		struct test_struct *t = &test[cpu];
+
+		time1 = t->stop1 - t->start1;
+		time2 = t->stop2 - t->start2;
+		sum1 += time1;
+		sum2 += time2;
+		printk(" %d=%lu", cpu, time1 / TEST_COUNT);
+		if (p2)
+			printk("/%lu", time2 / TEST_COUNT);
+	}
+	printk(" Average=%lu", sum1 / num_online_cpus() / TEST_COUNT);
+	if (p2)
+		printk("/%lu", sum2 / num_online_cpus() / TEST_COUNT);
+	printk("\n");
+	schedule_timeout(200);
+}
+#endif
+
+static int slab_test_init(void)
+{
+	void **v = kmalloc(TEST_COUNT * sizeof(void *), GFP_KERNEL);
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	int size;
+
+	printk(KERN_ALERT "test init\n");
+
+	printk(KERN_ALERT "Single thread testing\n");
+	printk(KERN_ALERT "=====================\n");
+	printk(KERN_ALERT "1. Kmalloc: Repeatedly allocate then free test\n");
+	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = kmalloc(size, GFP_KERNEL);
+
+			*p = 22;
+			v[i] = p;
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk(KERN_ALERT "%i times kmalloc(%d) ", i, size);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles ", time);
+
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = v[i];
+
+			*p = 23;
+			kfree(p);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk("kfree ");
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles\n", time);
+	}
+
+	printk(KERN_ALERT "2. Kmalloc: alloc/free test\n");
+	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = kmalloc(size, GFP_KERNEL);
+
+			kfree(p);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk(KERN_ALERT "%i times kmalloc(%d)/kfree ", i, size);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles\n", time);
+	}
+	kfree(v);
+#ifdef CONFIG_SMP
+	printk(KERN_INFO "Concurrent allocs\n");
+	printk(KERN_INFO "=================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(kmalloc_alloc_then_free_test_p1,
+			kmalloc_alloc_then_free_test_p2,
+			1 << i, "Kmalloc N*alloc N*free");
+	}
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(kmalloc_alloc_free_test_p1, NULL,
+			1 << i, "Kmalloc N*(alloc free)");
+	}
+
+	printk(KERN_INFO "Remote free test\n");
+	printk(KERN_INFO "================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(remote_free_test_p1,
+				remote_free_test_p2,
+			1 << i, "N*remote free");
+	}
+
+	printk(KERN_INFO "1 alloc N free test\n");
+	printk(KERN_INFO "===================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(alloc_n_free_test_p1,
+				NULL,
+			1 << i, "1 alloc N free");
+	}
+
+#endif
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void slab_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(slab_test_init)
+module_exit(slab_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter and Mathieu Desnoyers");
+MODULE_DESCRIPTION("SLAB test");
+
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug	2009-10-12 15:32:26.000000000 -0500
+++ linux-2.6/lib/Kconfig.debug	2009-10-12 15:32:30.000000000 -0500
@@ -920,6 +920,7 @@ config SYSCTL_SYSCALL_CHECK
 
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
+source tests/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
Index: linux-2.6/tests/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/tests/Kconfig	2009-10-12 15:32:30.000000000 -0500
@@ -0,0 +1,19 @@
+menuconfig BENCHMARKS
+	bool "In kernel benchmarks"
+	def_bool n
+	help
+	  Includes in kernel benchmark modules in the build. These modules can
+	  be loaded later to trigger benchmarking kernel subsystems.
+	  Output will be generated in the system log.
+
+if BENCHMARKS
+
+config BENCHMARK_SLAB
+	tristate "Slab allocator Benchmark"
+	depends on m
+	default m
+	help
+	  A benchmark that measures slab allocator performance.
+
+endif # BENCHMARKS
+

-- 
