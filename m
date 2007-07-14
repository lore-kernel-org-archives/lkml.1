Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbXGNBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbXGNBZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763220AbXGNBYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:24:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38139 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764825AbXGNBYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:24:44 -0400
Message-Id: <20070714012411.845928928@polymtl.ca>
References: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/8] Text Edit Lock - Architecture Independent Code
Content-Disposition: inline; filename=text-edit-lock-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an architecture independant synchronization around kernel text
modifications through use of a global mutex.

A mutex has been chosen so that kprobes, the main user of this, can sleep during
memory allocation between the memory read of the instructions it must replace
and the memory write of the breakpoint.

Other users of this interface: paravirt, alternatives and immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/memory.h |    7 +++++++
 mm/memory.c            |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

Index: linux-2.6-lttng/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/memory.h	2007-07-13 17:01:24.000000000 -0400
+++ linux-2.6-lttng/include/linux/memory.h	2007-07-13 17:14:38.000000000 -0400
@@ -86,4 +86,11 @@
 	register_memory_notifier(&fn##_mem_nb);			\
 }
 
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
--- linux-2.6-lttng.orig/mm/memory.c	2007-07-13 17:01:24.000000000 -0400
+++ linux-2.6-lttng/mm/memory.c	2007-07-13 17:01:26.000000000 -0400
@@ -50,6 +50,8 @@
 #include <linux/delayacct.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -84,6 +86,12 @@
 
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
@@ -2811,3 +2819,19 @@
 	return buf - old_buf;
 }
 EXPORT_SYMBOL_GPL(access_process_vm);
+
+/*
+ * Lock the kernel text for mutual write exclusion. Used for dynamic code
+ * patching.
+ */
+void __kprobes kernel_text_lock(void)
+{
+	mutex_lock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_lock);
+
+void __kprobes kernel_text_unlock(void)
+{
+	mutex_unlock(&text_mutex);
+}
+EXPORT_SYMBOL_GPL(kernel_text_unlock);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
