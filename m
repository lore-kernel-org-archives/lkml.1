Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYAJGmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYAJGmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYAJGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:42:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYAJGmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:42:33 -0500
Date: Wed, 9 Jan 2008 22:42:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [patch]  Add a simple backtrace test module
Message-ID: <20080109224208.541a659f@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: Add a simple backtrace test module
From: Arjan van de Ven <arjan@linux.intel.com>

During the work on the x86 32 and 64 bit backtrace code I found it useful
to have a simple test module to test a process and irq context backtrace.
Since the existing backtrace code was buggy, I figure it might be useful
to have such a test module in the kernel so that maybe we can even
detect such bugs earlier..

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 kernel/Makefile        |    1 +
 kernel/backtracetest.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |   12 ++++++++++++
 3 files changed, 60 insertions(+)

Index: linux-2.6.24-rc7/kernel/Makefile
===================================================================
--- linux-2.6.24-rc7.orig/kernel/Makefile
+++ linux-2.6.24-rc7/kernel/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softl
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
+obj-$(BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
Index: linux-2.6.24-rc7/kernel/backtracetest.c
===================================================================
--- /dev/null
+++ linux-2.6.24-rc7/kernel/backtracetest.c
@@ -0,0 +1,47 @@
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
Index: linux-2.6.24-rc7/lib/Kconfig.debug
===================================================================
--- linux-2.6.24-rc7.orig/lib/Kconfig.debug
+++ linux-2.6.24-rc7/lib/Kconfig.debug
@@ -462,6 +462,18 @@ config RCU_TORTURE_TEST
 	  Say M if you want the RCU torture tests to build as a module.
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
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
