Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZFBWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZFBWqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZFBWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:33384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZFBWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pCWOy8SOuVByHHZhKio1h99egcFi8I2wxoBL2Ap4JwVUbmBv6GHMjiWHvrCh/vMBHr
         eQ7fnv2GR6br/Us9bAZMXev50SUzLLEI0wiUGefX2EPKZBTXX6NU+TEnBZZ3Ws72hVLD
         Zihzdo2mv0OvG5OQ41XVRbattHm1s0NwZxtc4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/12] hw-breakpoints: sample HW breakpoint over kernel data address
Date: Wed,  3 Jun 2009 00:43:34 +0200
Message-Id: <1243982616-18212-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch introduces a sample kernel module to demonstrate the use of Hardware
Breakpoint feature. It places a breakpoint over the kernel variable 'pid_max'
to monitor all write operations and emits a function-backtrace when done.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 samples/Kconfig                         |    6 ++
 samples/Makefile                        |    3 +-
 samples/hw_breakpoint/Makefile          |    1 +
 samples/hw_breakpoint/data_breakpoint.c |   83 +++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 1 deletions(-)
 create mode 100644 samples/hw_breakpoint/Makefile
 create mode 100644 samples/hw_breakpoint/data_breakpoint.c

diff --git a/samples/Kconfig b/samples/Kconfig
index b75d28c..8458516 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -45,5 +45,11 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
+config SAMPLE_HW_BREAKPOINT
+	tristate "Build kernel hardware breakpoint examples -- loadable module only"
+	depends on HAVE_HW_BREAKPOINT && m
+	help
+	  This builds kernel hardware breakpoint example modules.
+
 endif # SAMPLES
 
diff --git a/samples/Makefile b/samples/Makefile
index 13e4b47..42e1755 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,4 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace_events/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ \
+			trace_events/ hw_breakpoint/
diff --git a/samples/hw_breakpoint/Makefile b/samples/hw_breakpoint/Makefile
new file mode 100644
index 0000000..0f5c31c
--- /dev/null
+++ b/samples/hw_breakpoint/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_HW_BREAKPOINT) += data_breakpoint.o
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
new file mode 100644
index 0000000..9cbdbb8
--- /dev/null
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -0,0 +1,83 @@
+/*
+ * data_breakpoint.c - Sample HW Breakpoint file to watch kernel data address
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * usage: insmod data_breakpoint.ko ksym=<ksym_name>
+ *
+ * This file is a kernel module that places a breakpoint over ksym_name kernel
+ * variable using Hardware Breakpoint register. The corresponding handler which
+ * prints a backtrace is invoked everytime a write operation is performed on
+ * that variable.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+#include <linux/module.h>	/* Needed by all modules */
+#include <linux/kernel.h>	/* Needed for KERN_INFO */
+#include <linux/init.h>		/* Needed for the macros */
+
+#include <asm/hw_breakpoint.h>
+
+struct hw_breakpoint sample_hbp;
+
+static char ksym_name[KSYM_NAME_LEN] = "pid_max";
+module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
+MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
+			" write operations on the kernel symbol");
+
+void sample_hbp_handler(struct hw_breakpoint *temp, struct pt_regs
+								*temp_regs)
+{
+	printk(KERN_INFO "%s value is changed\n", ksym_name);
+	dump_stack();
+	printk(KERN_INFO "Dump stack from sample_hbp_handler\n");
+}
+
+static int __init hw_break_module_init(void)
+{
+	int ret;
+
+#ifdef CONFIG_X86
+	sample_hbp.info.name = ksym_name;
+	sample_hbp.info.type = HW_BREAKPOINT_WRITE;
+	sample_hbp.info.len = HW_BREAKPOINT_LEN_4;
+#endif /* CONFIG_X86 */
+
+	sample_hbp.triggered = (void *)sample_hbp_handler;
+
+	ret = register_kernel_hw_breakpoint(&sample_hbp);
+
+	if (ret < 0) {
+		printk(KERN_INFO "Breakpoint registration failed\n");
+		return ret;
+	} else
+		printk(KERN_INFO "HW Breakpoint for %s write installed\n",
+								ksym_name);
+
+	return 0;
+}
+
+static void __exit hw_break_module_exit(void)
+{
+	unregister_kernel_hw_breakpoint(&sample_hbp);
+	printk(KERN_INFO "HW Breakpoint for %s write uninstalled\n", ksym_name);
+}
+
+module_init(hw_break_module_init);
+module_exit(hw_break_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("K.Prasad");
+MODULE_DESCRIPTION("ksym breakpoint");
-- 
1.6.2.3

