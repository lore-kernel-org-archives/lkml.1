Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYKQN2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYKQN2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYKQN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:37 -0500
Received: from ozlabs.org ([203.10.76.45]:39450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYKQN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:27 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 7/7] Improve alloc_percpu: Simple testing patch.
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132631.A88A0DDE0A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that we can use the ptr ops on static percpu vars now.  We should
remove the "per_cpu__" token-pasting which was designed to catch raw
usage, and use sparse annotations instead.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu.h |    2 +
 init/Kconfig           |    6 ++++
 init/Makefile          |    1
 init/main.c            |    1
 init/test-cpualloc.c   |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/allocpercpu.c       |    7 ++---
 6 files changed, 74 insertions(+), 4 deletions(-)

diff -r 3b3fa686230f init/Kconfig
--- a/init/Kconfig	Mon Nov 17 23:19:14 2008 +1030
+++ b/init/Kconfig	Mon Nov 17 23:39:58 2008 +1030
@@ -929,3 +929,9 @@
 	  designed for best read-side performance on non-realtime
 	  systems.  Classic RCU is the default.  Note that the
 	  PREEMPT_RCU symbol is used to select/deselect this option.
+
+config TEST_CPUALLOC
+	tristate "Test alloc_percpu"
+	depends on DEBUG_KERNEL
+	help
+	  This tests the replacement alloc_percpu() implementation.
diff -r 3b3fa686230f init/Makefile
--- a/init/Makefile	Mon Nov 17 23:19:14 2008 +1030
+++ b/init/Makefile	Mon Nov 17 23:39:58 2008 +1030
@@ -9,6 +9,7 @@
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
+obj-$(CONFIG_TEST_CPUALLOC) += test-cpualloc.o
 
 mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
diff -r 3b3fa686230f init/test-cpualloc.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/init/test-cpualloc.c	Mon Nov 17 23:39:58 2008 +1030
@@ -0,0 +1,75 @@
+/* Not a very informative test: it just crashes if something's wrong. */
+#include <linux/percpu.h>
+#include <linux/module.h>
+
+static DEFINE_PER_CPU(u64, static_pcpu);
+
+static int init(void)
+{
+	void *p, *thisp;
+	u64 *p64, *thisp64;
+	unsigned int i;
+
+	printk(KERN_INFO "Testing cpualloc for %u cpus\n",
+	       cpus_weight(cpu_possible_map));
+
+	p = __alloc_percpu(100, 128);
+	/* Don't expect failure. */
+	BUG_ON(!p);
+
+	thisp = get_cpu_ptr(p);
+	for_each_possible_cpu(i) {
+		unsigned int j;
+		/* Must be aligned. */
+		BUG_ON((unsigned long)per_cpu_ptr(p, i) % 128);
+		/* Must be zeroed. */
+		for (j = 0; j < 100; j++)
+			BUG_ON(((char *)per_cpu_ptr(p, i))[j]);
+		if (i == smp_processor_id())
+			BUG_ON(per_cpu_ptr(p, i) != thisp);
+		/* Check they're different pointers. */
+		memset(per_cpu_ptr(p, i), 0xFF, 100);
+	}
+	free_percpu(p);
+	put_cpu_ptr(p);
+
+	p64 = alloc_percpu(u64);
+	/* Don't expect failure. */
+	BUG_ON(!p64);
+
+	thisp64 = get_cpu_ptr(p64);
+	for_each_possible_cpu(i) {
+		/* Must be aligned. */
+		BUG_ON((unsigned long)per_cpu_ptr(p64, i) % __alignof__(u64));
+		/* Must be zeroed. */
+		BUG_ON(*per_cpu_ptr(p64, i));
+		if (i == smp_processor_id())
+			BUG_ON(per_cpu_ptr(p64, i) != thisp64);
+		/* Check they're different pointers. */
+		*per_cpu_ptr(p64, i) = -1ULL;
+	}
+	free_percpu(p64);
+	put_cpu_ptr(p64);
+
+	/* It even works on static percpu vars (though currently awkward) */
+	p64 = &per_cpu__static_pcpu;
+	thisp64 = get_cpu_ptr(p64);
+	for_each_possible_cpu(i) {
+		/* Must be aligned. */
+		BUG_ON((unsigned long)per_cpu_ptr(p64, i) % __alignof__(u64));
+		/* Must be zeroed. */
+		BUG_ON(*per_cpu_ptr(p64, i));
+		if (i == smp_processor_id())
+			BUG_ON(per_cpu_ptr(p64, i) != thisp64);
+		/* Check they're different pointers. */
+		*per_cpu_ptr(p64, i) = -1ULL;
+	}
+	put_cpu_ptr(p64);
+	return 0;
+}
+
+static void fini(void)
+{
+}
+module_init(init);
+module_exit(fini);

