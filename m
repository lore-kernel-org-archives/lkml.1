Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZDGGiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZDGGiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbZDGGhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:37:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46773 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbZDGGhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:37:12 -0400
Date: Tue, 7 Apr 2009 12:07:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 10/11] Sample HW breakpoint over kernel data address
Message-ID: <20090407063700.GK17461@in.ibm.com>
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com>
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
 samples/Makefile                        |    4 +
 samples/hw_breakpoint/Makefile          |    1 
 samples/hw_breakpoint/data_breakpoint.c |   83 ++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 1 deletion(-)

Index: samples/Kconfig
===================================================================
--- samples/Kconfig.orig
+++ samples/Kconfig
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
 
Index: samples/Makefile
===================================================================
--- samples/Makefile.orig
+++ samples/Makefile
@@ -1,3 +1,5 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ \
+			   hw_breakpoint/
+
Index: samples/hw_breakpoint/Makefile
===================================================================
--- /dev/null
+++ samples/hw_breakpoint/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_HW_BREAKPOINT) += data_breakpoint.o
Index: samples/hw_breakpoint/data_breakpoint.c
===================================================================
--- /dev/null
+++ samples/hw_breakpoint/data_breakpoint.c
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
+
+	sample_hbp.triggered = (void *)sample_hbp_handler;
+#endif /* CONFIG_X86 */
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

