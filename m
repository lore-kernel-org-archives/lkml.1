Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYBKKv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYBKKv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYBKKvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:51:17 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47404 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYBKKvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:51:16 -0500
Date: Mon, 11 Feb 2008 16:21:45 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 7/8] Move backtrace tests to tests/ 
Message-ID: <20080211105145.GI7944@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211104452.GB7944@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Move backtrace selftests to tests/

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/backtracetest.c |   48 ------------------------------------------------
 kernel/Makefile        |    1 -
 lib/Kconfig.debug      |   12 ------------
 tests/Kconfig          |   12 ++++++++++++
 tests/Makefile         |    1 +
 tests/backtracetest.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 61 insertions(+), 61 deletions(-)

Index: linux-2.6.25-rc1/kernel/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/kernel/Makefile
+++ linux-2.6.25-rc1/kernel/Makefile
@@ -35,7 +35,6 @@ obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
-obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
Index: linux-2.6.25-rc1/kernel/backtracetest.c
===================================================================
--- linux-2.6.25-rc1.orig/kernel/backtracetest.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Simple stack backtrace regression test module
- *
- * (C) Copyright 2008 Intel Corporation
- * Author: Arjan van de Ven <arjan@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
-
-static struct timer_list backtrace_timer;
-
-static void backtrace_test_timer(unsigned long data)
-{
-	printk("Testing a backtrace from irq context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
-}
-static int backtrace_regression_test(void)
-{
-	printk("====[ backtrace testing ]===========\n");
-	printk("Testing a backtrace from process context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
-
-	init_timer(&backtrace_timer);
-	backtrace_timer.function = backtrace_test_timer;
-	mod_timer(&backtrace_timer, jiffies + 10);
-
-	msleep(10);
-	printk("====[ end of backtrace testing ]====\n");
-	return 0;
-}
-
-static void exitf(void)
-{
-}
-
-module_init(backtrace_regression_test);
-module_exit(exitf);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
Index: linux-2.6.25-rc1/lib/Kconfig.debug
===================================================================
--- linux-2.6.25-rc1.orig/lib/Kconfig.debug
+++ linux-2.6.25-rc1/lib/Kconfig.debug
@@ -466,18 +466,6 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
-config BACKTRACE_SELF_TEST
-	tristate "Self test for the backtrace code"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that can be used to test
-	  the kernel stack backtrace code. This option is not useful
-	  for distributions or general kernels, but only for kernel
-	  developers working on architecture code.
-
-	  Say N if you are unsure.
-
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
Index: linux-2.6.25-rc1/tests/Kconfig
===================================================================
--- linux-2.6.25-rc1.orig/tests/Kconfig
+++ linux-2.6.25-rc1/tests/Kconfig
@@ -64,4 +64,16 @@ config KPROBES_SANITY_TEST
 
 	  Say N if you are unsure.
 
+config BACKTRACE_SELF_TEST
+	tristate "Self test for the backtrace code"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that can be used to test
+	  the kernel stack backtrace code. This option is not useful
+	  for distributions or general kernels, but only for kernel
+	  developers working on architecture code.
+
+	  Say N if you are unsure.
+
 endif # KERNEL_TESTS
Index: linux-2.6.25-rc1/tests/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/tests/Makefile
+++ linux-2.6.25-rc1/tests/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutor
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_LKDTM) += lkdtm.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
+obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
Index: linux-2.6.25-rc1/tests/backtracetest.c
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/backtracetest.c
@@ -0,0 +1,48 @@
+/*
+ * Simple stack backtrace regression test module
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+
+static struct timer_list backtrace_timer;
+
+static void backtrace_test_timer(unsigned long data)
+{
+	printk("Testing a backtrace from irq context.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
+	dump_stack();
+}
+static int backtrace_regression_test(void)
+{
+	printk("====[ backtrace testing ]===========\n");
+	printk("Testing a backtrace from process context.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
+	dump_stack();
+
+	init_timer(&backtrace_timer);
+	backtrace_timer.function = backtrace_test_timer;
+	mod_timer(&backtrace_timer, jiffies + 10);
+
+	msleep(10);
+	printk("====[ end of backtrace testing ]====\n");
+	return 0;
+}
+
+static void exitf(void)
+{
+}
+
+module_init(backtrace_regression_test);
+module_exit(exitf);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
