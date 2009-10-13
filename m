Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbZJMULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbZJMULE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760804AbZJMULD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55116 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670AbZJMULC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:02 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 7
	times
Message-Id: <20091013200302.344340423@gentwo.org>
References: <20091013200233.260324963@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Oct 2009 16:02:35 -0400
From: Christoph Lameter <cl@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC In-kernel benchmarks 2/3] Vm statistics performance test
Content-Disposition: inline; filename=0002-Vm-statistics-performance-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests the performance of some key vm statistics functions.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
---
 tests/Kconfig       |    7 +++
 tests/Makefile      |    1 
 tests/vmstat_test.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)
 create mode 100644 tests/vmstat_test.c

Index: linux-2.6/tests/Makefile
===================================================================
--- linux-2.6.orig/tests/Makefile	2009-10-12 15:13:04.000000000 -0500
+++ linux-2.6/tests/Makefile	2009-10-12 15:15:08.000000000 -0500
@@ -1,2 +1,3 @@
 obj-$(CONFIG_BENCHMARK_SLAB) += slab_test.o
+obj-#(CONFIG_BENCHMARK_VMSTAT) += vmstat_test.o
 
Index: linux-2.6/tests/vmstat_test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/tests/vmstat_test.c	2009-10-12 15:15:08.000000000 -0500
@@ -0,0 +1,97 @@
+/* test-vmstat.c
+ *
+ * Test module for in kernel synthetic vm statistics performance.
+ *
+ * execute
+ *
+ * 	modprobe test-vmstat
+ *
+ * to run this test
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@linux-foundation.org>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/timex.h>
+#include <asm/system.h>
+
+#define TEST_COUNT 10000
+
+static int vmstat_test_init(void)
+{
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	struct page *page = alloc_page(GFP_KERNEL);
+
+	printk(KERN_ALERT "VMstat testing\n");
+	printk(KERN_ALERT "=====================\n");
+	printk(KERN_ALERT "1. inc_zone_page_state() then dec_zone_page_state()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		inc_zone_page_state(page, NR_BOUNCE);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	printk(KERN_ALERT "%i times inc_zone_page_state() ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	printk("-> %llu cycles ", time);
+
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		__dec_zone_page_state(page, NR_BOUNCE);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	printk("__dec_z_p_s() ");
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	printk("-> %llu cycles\n", time);
+
+	printk(KERN_ALERT "2. inc_zone_page_state()/dec_zone_page_state()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++) {
+		inc_zone_page_state(page, NR_BOUNCE);
+		dec_zone_page_state(page, NR_BOUNCE);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	printk(KERN_ALERT "%i times inc/dec ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	printk("-> %llu cycles\n", time);
+
+	printk(KERN_ALERT "3. count_vm_event()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		count_vm_event(SLABS_SCANNED);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+	printk(KERN_ALERT "%i count_vm_events ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	printk("-> %llu cycles\n", time);
+	__free_page(page);
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void vmstat_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(vmstat_test_init)
+module_exit(vmstat_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter");
+MODULE_DESCRIPTION("VM statistics test");
+
Index: linux-2.6/tests/Kconfig
===================================================================
--- linux-2.6.orig/tests/Kconfig	2009-10-12 15:14:54.000000000 -0500
+++ linux-2.6/tests/Kconfig	2009-10-12 15:15:55.000000000 -0500
@@ -15,5 +15,12 @@ config BENCHMARK_SLAB
 	help
 	  A benchmark that measures slab allocator performance.
 
+config BENCHMARK_VMSTAT
+	tristate "VM statistics Benchmark"
+	default m
+	depends on m
+	help
+	  A benchmark measuring the performance of vm statistics.
+
 endif # BENCHMARKS
 

-- 
