Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZAVONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZAVONT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZAVONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:13:09 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37943 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZAVONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:13:06 -0500
Date: Thu, 22 Jan 2009 19:42:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 10/10] Sample HW breakpoint over kernel data address
Message-ID: <20090122141259.GI19592@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090122135640.GA11161@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122135640.GA11161@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a sample kernel module to demonstrate the use of 
Hardware Breakpoint feature. It places a breakpoint over the kernel
variable 'pid_max' to monitor all write operations and emits a
function-backtrace when done.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 samples/Kconfig                         |    6 ++
 samples/Makefile                        |    3 -
 samples/hw_breakpoint/Makefile          |    1 
 samples/hw_breakpoint/data_breakpoint.c |   81 ++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 1 deletion(-)

Index: linux-hbkpt-lkml-29-rc2/samples/Kconfig
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/samples/Kconfig
+++ linux-hbkpt-lkml-29-rc2/samples/Kconfig
@@ -39,5 +39,11 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
+config SAMPLE_HW_BREAKPOINT
+	tristate "Build kernel hardware breakpoint examples -- loadable modules only"
+	depends on m
+	help
+	  This builds kernel hardware breakpoint example modules.
+
 endif # SAMPLES
 
Index: linux-hbkpt-lkml-29-rc2/samples/Makefile
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/samples/Makefile
+++ linux-hbkpt-lkml-29-rc2/samples/Makefile
@@ -1,3 +1,4 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ \
+			   hw_breakpoint/
Index: linux-hbkpt-lkml-29-rc2/samples/hw_breakpoint/Makefile
===================================================================
--- /dev/null
+++ linux-hbkpt-lkml-29-rc2/samples/hw_breakpoint/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_HW_BREAKPOINT) += data_breakpoint.o
Index: linux-hbkpt-lkml-29-rc2/samples/hw_breakpoint/data_breakpoint.c
===================================================================
--- /dev/null
+++ linux-hbkpt-lkml-29-rc2/samples/hw_breakpoint/data_breakpoint.c
@@ -0,0 +1,81 @@
+/*
+ * data_breakpoint.c - Sample HW Breakpoint file to watch kernel data address
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
+struct hw_breakpoint pid_max_hw_breakpoint;
+
+void pid_max_hw_breakpoint_installed(struct hw_breakpoint *temp, struct pt_regs
+								*temp_regs)
+{
+	printk(KERN_INFO "pid_max_hw_breakpoint ENABLED\n");
+}
+
+void pid_max_hw_breakpoint_uninstalled(struct hw_breakpoint *temp, struct
+							pt_regs *temp_regs)
+{
+	printk(KERN_INFO "pid_max_hw_breakpoint DISABLED\n");
+}
+
+void pid_max_hw_breakpoint_handler(struct hw_breakpoint *temp, struct pt_regs
+								*temp_regs)
+{
+	printk(KERN_INFO "pid_max value is changed\n");
+	dump_stack();
+	printk(KERN_INFO "Dump stack from pid_max_hw_breakpoint_handler\n");
+}
+
+static int __init hw_break_module_init(void)
+{
+	int ret;
+
+#ifdef CONFIG_X86
+	pid_max_hw_breakpoint.info.name = "pid_max";
+	pid_max_hw_breakpoint.info.type = HW_BREAKPOINT_WRITE;
+	pid_max_hw_breakpoint.info.len = HW_BREAKPOINT_LEN_4;
+	pid_max_hw_breakpoint.priority = HW_BREAKPOINT_PRIO_NORMAL;
+
+	pid_max_hw_breakpoint.installed = (void*)pid_max_hw_breakpoint_installed;
+	pid_max_hw_breakpoint.uninstalled = (void*)pid_max_hw_breakpoint_uninstalled;
+	pid_max_hw_breakpoint.triggered = (void*)pid_max_hw_breakpoint_handler;
+#endif /* CONFIG_X86 */
+
+	ret = register_kernel_hw_breakpoint(&pid_max_hw_breakpoint);
+
+	if (ret < 0) {
+		printk(KERN_INFO "Breakpoint registration failed\n");
+		return ret;
+	}
+	else
+		printk(KERN_INFO "HW Breakpoint for pid_max write installed\n");
+
+	return 0;
+}
+
+static void __exit hw_break_module_exit(void)
+{
+	unregister_kernel_hw_breakpoint(&pid_max_hw_breakpoint);
+	printk(KERN_INFO "HW Breakpoint for pid_max write uninstalled\n");
+}
+
+module_init(hw_break_module_init);
+module_exit(hw_break_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("K.Prasad");
+MODULE_DESCRIPTION("pid_max breakpoint");
