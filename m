Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZFASQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZFASQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZFASQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:16:27 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47569 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbZFASQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:16:26 -0400
Date: Mon, 1 Jun 2009 23:46:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 10/12] Sample HW breakpoint over kernel data address
Message-ID: <20090601181620.GK23582@in.ibm.com>
References: <20090601180605.799735829@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=samples_hw_breakpoint_10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a sample kernel module to demonstrate the use of Hardware
Breakpoint feature. It places a breakpoint over the kernel variable 'pid_max'
to monitor all write operations and emits a function-backtrace when done.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 samples/Kconfig                         |    6 ++
 samples/Makefile                        |    3 -
 samples/hw_breakpoint/Makefile          |    1 
 samples/hw_breakpoint/data_breakpoint.c |   83 ++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 1 deletion(-)

Index: linux-2.6-tip.hbkpt/samples/Kconfig
===================================================================
--- linux-2.6-tip.hbkpt.orig/samples/Kconfig
+++ linux-2.6-tip.hbkpt/samples/Kconfig
@@ -45,5 +45,11 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
+config SAMPLE_HW_BREAKPOINT
+	tristate "Build kernel hardware breakpoint examples -- loadable modules only"
+	depends on HAVE_HW_BREAKPOINT && m
+	help
+	  This builds kernel hardware breakpoint example modules.
+
 endif # SAMPLES
 
Index: linux-2.6-tip.hbkpt/samples/Makefile
===================================================================
--- linux-2.6-tip.hbkpt.orig/samples/Makefile
+++ linux-2.6-tip.hbkpt/samples/Makefile
@@ -1,3 +1,4 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace_events/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ \
+			trace_events/ hw_breakpoint/
Index: linux-2.6-tip.hbkpt/samples/hw_breakpoint/Makefile
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/samples/hw_breakpoint/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_HW_BREAKPOINT) += data_breakpoint.o
Index: linux-2.6-tip.hbkpt/samples/hw_breakpoint/data_breakpoint.c
===================================================================
--- /dev/null
+++ linux-2.6-tip.hbkpt/samples/hw_breakpoint/data_breakpoint.c
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

