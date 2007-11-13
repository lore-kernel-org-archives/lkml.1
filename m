Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXKMSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXKMSta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760807AbXKMSsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:48:04 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48315 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761719AbXKMSr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:47:59 -0500
Message-Id: <20071113184719.180708864@polymtl.ca>
References: <20071113184627.667866257@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:46:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 05/11] Text Edit Lock - Architecture Independent Code
Content-Disposition: inline; filename=text-edit-lock-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:47:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
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

Index: linux-2.6-lttng/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/memory.h	2007-11-07 11:11:26.000000000 -0500
+++ linux-2.6-lttng/include/linux/memory.h	2007-11-07 11:13:48.000000000 -0500
@@ -93,4 +93,11 @@ extern int memory_notify(unsigned long v
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
Index: linux-2.6-lttng/mm/memory.c
===================================================================
--- linux-2.6-lttng.orig/mm/memory.c	2007-11-07 11:12:33.000000000 -0500
+++ linux-2.6-lttng/mm/memory.c	2007-11-07 11:14:25.000000000 -0500
@@ -50,6 +50,8 @@
 #include <linux/delayacct.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -84,6 +86,12 @@ EXPORT_SYMBOL(high_memory);
 
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
@@ -2748,3 +2756,29 @@ int access_process_vm(struct task_struct
 
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
