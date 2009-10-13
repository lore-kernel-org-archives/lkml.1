Return-Path: <linux-kernel-owner+w=401wt.eu-S934294AbZJMULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbZJMULS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934285AbZJMULR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:17 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:58861 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934282AbZJMULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:14 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 7
	times
Message-Id: <20091013200302.536418191@gentwo.org>
References: <20091013200233.260324963@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Oct 2009 16:02:36 -0400
From: Christoph Lameter <cl@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC In-kernel benchmarks 3/3] Page allocator test
Content-Disposition: inline; filename=0003-Page-allocator-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a test of the page allocator speed in the same way as for the
slab allocators.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
---
 tests/Kconfig          |    7 +
 tests/Makefile         |    3 
 tests/pagealloc_test.c |  334 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 343 insertions(+), 1 deletion(-)
 create mode 100644 tests/page_test.c

Index: linux-2.6/tests/Makefile
===================================================================
--- linux-2.6.orig/tests/Makefile	2009-10-12 15:17:45.000000000 -0500
+++ linux-2.6/tests/Makefile	2009-10-12 15:17:46.000000000 -0500
@@ -1,3 +1,4 @@
 obj-$(CONFIG_BENCHMARK_SLAB) += slab_test.o
-obj-#(CONFIG_BENCHMARK_VMSTAT) += vmstat_test.o
+obj-$(CONFIG_BENCHMARK_VMSTAT) += vmstat_test.o
+obj-$(CONFIG_BENCHMARK_PAGEALLOC) += pagealloc_test.o
 
Index: linux-2.6/tests/pagealloc_test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/tests/pagealloc_test.c	2009-10-12 15:17:46.000000000 -0500
@@ -0,0 +1,334 @@
+/* pagealloc_test.c
+ *
+ * Test module for in kernel synthetic page allocator testing.
+ *
+ * Compiled as a module. The module needs to be loaded to run.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@linux-foundation.org>
+ */
+
+
+#include <linux/jiffies.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <asm/timex.h>
+#include <asm/system.h>
+
+#define TEST_COUNT 1000
+
+#define CONCURRENT_MAX_ORDER 6
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
+	int order;
+	int count;
+	struct page **v;
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
+		struct page *p;
+
+		if (smp_processor_id()) {
+			p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+			/* Use object */
+			memset(page_address(p), 17, 4);
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
+			struct page *p = test[cpu].v[i];
+
+			if (!p)
+				continue;
+
+			__free_pages(p, t->order);
+		}
+}
+
+/*
+ * Allocate TEST_COUNT objects and later free them all again
+ */
+static void alloc_then_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+
+		memset(page_address(p), 14, 4);
+		t->v[i] = p;
+	}
+}
+
+static void alloc_then_free_test_p2(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		struct page *p = t->v[i];
+
+		__free_pages(p, t->order);
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects. Free them immediately.
+ */
+static void alloc_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < TEST_COUNT; i++) {
+		struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+
+		memset(page_address(p), 12, 4);
+		__free_pages(p, t->order);
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
+	cpu_set(t->cpu, newmask);
+	set_cpus_allowed(current, newmask);
+	t->v = kmalloc(t->count * sizeof(struct page *), GFP_KERNEL);
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
+		int order, const char *name)
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
+		t->order = order;
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
+	printk(KERN_ALERT "%s(%d):", name, order);
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
+static int pagealloc_test_init(void)
+{
+	void **v = kmalloc(TEST_COUNT * sizeof(void *), GFP_KERNEL);
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	int order;
+
+	printk(KERN_ALERT "test init\n");
+
+	printk(KERN_ALERT "Single thread testing\n");
+	printk(KERN_ALERT "=====================\n");
+	printk(KERN_ALERT "1. Repeatedly allocate then free test\n");
+	for (order = 0; order < MAX_ORDER; order++) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP,
+						order);
+
+			if (!p) {
+				printk("Cannot allocate order=%d\n", order);
+				break;
+			}
+
+			/* Touch page */
+			memset(page_address(p), 22, 4);
+			v[i] = p;
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk(KERN_ALERT "%i times alloc_page(,%d) ", i, order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles ", time);
+
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = v[i];
+
+			__free_pages(p, order);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk("__free_pages(,%d)", order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles\n", time);
+	}
+
+	printk(KERN_ALERT "2. alloc/free test\n");
+	for (order = 0; order < MAX_ORDER; order++) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = alloc_pages(GFP_KERNEL| __GFP_COMP, order);
+
+			__free_pages(p, order);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		printk(KERN_ALERT "%i times alloc( ,%d)/free ", i, order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		printk("-> %llu cycles\n", time);
+	}
+	kfree(v);
+#ifdef CONFIG_SMP
+	printk(KERN_INFO "Concurrent allocs\n");
+	printk(KERN_INFO "=================\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(alloc_then_free_test_p1,
+			alloc_then_free_test_p2,
+			order, "Page alloc N*alloc N*free");
+	}
+	printk("----Fastpath---\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(alloc_free_test_p1, NULL,
+			order, "Page N*(alloc free)");
+	}
+
+	printk(KERN_INFO "Remote free test\n");
+	printk(KERN_INFO "================\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(remote_free_test_p1,
+				remote_free_test_p2,
+			order, "N*remote free");
+	}
+
+#endif
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void pagealloc_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(pagealloc_test_init)
+module_exit(pagealloc_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter");
+MODULE_DESCRIPTION("page allocator performance test");
+
Index: linux-2.6/tests/Kconfig
===================================================================
--- linux-2.6.orig/tests/Kconfig	2009-10-12 15:17:45.000000000 -0500
+++ linux-2.6/tests/Kconfig	2009-10-12 15:17:46.000000000 -0500
@@ -22,5 +22,12 @@ config BENCHMARK_VMSTAT
 	help
 	  A benchmark measuring the performance of vm statistics.
 
+config BENCHMARK_PAGEALLOC
+	tristate "Page Allocator Benchmark"
+	default m
+	depends on m
+	help
+	  A benchmark measuring the performance of the page allocator.
+
 endif # BENCHMARKS
 

-- 
