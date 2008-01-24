Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYAXUfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYAXUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYAXUeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:34:10 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58179 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbYAXUeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:34:06 -0500
Message-Id: <20080124203335.465339793@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 08/26] Text Edit Lock - Architecture Independent Code
Content-Disposition: inline; filename=text-edit-lock-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an architecture independant synchronization around kernel text
modifications through use of a global mutex.

A mutex has been chosen so that kprobes, the main user of this, can sleep during
memory allocation between the memory read of the instructions it must replace
and the memory write of the breakpoint.

Other user of this interface: immediate values.

Paravirt and alternatives are always done when SMP is inactive, so there is no
need to use locks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
---
 include/linux/memory.h |    7 +++++++
 mm/memory.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux-2.6-lttng.mm/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/linux/memory.h	2008-01-24 14:10:54.000000000 -0500
+++ linux-2.6-lttng.mm/include/linux/memory.h	2008-01-24 14:23:14.000000000 -0500
@@ -92,4 +92,11 @@ extern int memory_notify(unsigned long v
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * Take and release the kernel text modification lock, used for code patching.
+ * Users of this lock can sleep.
+ */
+extern void kernel_text_lock(void);
+extern void kernel_text_unlock(void);
+
 #endif /* _LINUX_MEMORY_H_ */
Index: linux-2.6-lttng.mm/mm/memory.c
===================================================================
--- linux-2.6-lttng.mm.orig/mm/memory.c	2008-01-24 14:10:56.000000000 -0500
+++ linux-2.6-lttng.mm/mm/memory.c	2008-01-24 14:23:41.000000000 -0500
@@ -51,6 +51,8 @@
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -85,6 +87,12 @@ EXPORT_SYMBOL(high_memory);
 
 int randomize_va_space __read_mostly = 1;
 
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ */
+static DEFINE_MUTEX(text_mutex);
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -2674,3 +2682,29 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+
+/**
+ * kernel_text_lock     -   Take the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
+ */
+void __kprobes kernel_text_lock(void)
+{
+	mutex_lock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+/**
+ * kernel_text_unlock   -   Release the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
+ */
+void __kprobes kernel_text_unlock(void)
+{
+	mutex_unlock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
