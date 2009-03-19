Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZCSXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZCSXvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762274AbZCSXuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:50:16 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44281 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762293AbZCSXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:50:15 -0400
Date: Fri, 20 Mar 2009 05:20:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 10/11] Sample HW breakpoint over kernel data address
Message-ID: <20090319235001.GK10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=10
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
 samples/Makefile                        |    4 +
 samples/hw_breakpoint/Makefile          |    1 
 samples/hw_breakpoint/data_breakpoint.c |   79 ++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 1 deletion(-)

Index: linux-2.6-tip.hbkpt/samples/Kconfig
===================================================================
--- linux-2.6-tip.hbkpt.orig/samples/Kconfig
+++ linux-2.6-tip.hbkpt/samples/Kconfig
@@ -39,5 +39,11 @@ config SAMPLE_KRETPROBES
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
@@ -1,3 +1,5 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ \
+			   hw_breakpoint/
+
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
@@ -0,0 +1,79 @@
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
+ * This file is a kernel module that places a breakpoint over 'pid_max' kernel
+ * variable using Hardware Breakpoint register. The corresponding handler which
+ * prints a backtrace is invoked everytime a write operation is performed on
+ * that variable.
+ *
+ * After inserting this module, invoke a write operation using
+ * 'echo <desired_value> > /proc/sys/kernel/pid_max'
+ * to find the function-call backtrace.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+#include <linux/module.h>	/* Needed by all modules */
+#include <linux/kernel.h>	/* Needed for KERN_INFO */
+#include <linux/init.h>		/* Needed for the macros */
+
+#include <asm/hw_breakpoint.h>
+
+struct hw_breakpoint pid_max_hbkpt;
+
+void pid_max_hbkpt_handler(struct hw_breakpoint *temp, struct pt_regs
+								*temp_regs)
+{
+	printk(KERN_INFO "pid_max value is changed\n");
+	dump_stack();
+	printk(KERN_INFO "Dump stack from pid_max_hbkpt_handler\n");
+}
+
+static int __init hw_break_module_init(void)
+{
+	int ret;
+
+#ifdef CONFIG_X86
+	pid_max_hbkpt.info.name = "pid_max";
+	pid_max_hbkpt.info.type = HW_BREAKPOINT_WRITE;
+	pid_max_hbkpt.info.len = HW_BREAKPOINT_LEN_4;
+
+	pid_max_hbkpt.triggered = (void *)pid_max_hbkpt_handler;
+#endif /* CONFIG_X86 */
+
+	ret = register_kernel_hw_breakpoint(&pid_max_hbkpt);
+
+	if (ret < 0) {
+		printk(KERN_INFO "Breakpoint registration failed\n");
+		return ret;
+	} else
+		printk(KERN_INFO "HW Breakpoint for pid_max write installed\n");
+
+	return 0;
+}
+
+static void __exit hw_break_module_exit(void)
+{
+	unregister_kernel_hw_breakpoint(&pid_max_hbkpt);
+	printk(KERN_INFO "HW Breakpoint for pid_max write uninstalled\n");
+}
+
+module_init(hw_break_module_init);
+module_exit(hw_break_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("K.Prasad");
+MODULE_DESCRIPTION("pid_max breakpoint");

