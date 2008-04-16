Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbYDPVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbYDPVi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYDPVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35042 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbYDPVgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:10 -0400
Message-Id: <20080416213549.355561634@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Subject: [RFC patch 07/27] Text Edit Lock - Architecture Independent Code
Content-Disposition: inline; filename=text-edit-lock-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:49 +0000
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
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/memory.h |    7 +++++++
 mm/memory.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux-2.6-lttng/include/linux/memory.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/memory.h	2008-04-08 12:01:44.000000000 -0400
+++ linux-2.6-lttng/include/linux/memory.h	2008-04-08 12:01:56.000000000 -0400
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
--- linux-2.6-lttng.orig/mm/memory.c	2008-04-08 12:01:44.000000000 -0400
+++ linux-2.6-lttng/mm/memory.c	2008-04-08 12:01:56.000000000 -0400
@@ -51,6 +51,8 @@
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -96,6 +98,12 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ */
+static DEFINE_MUTEX(text_mutex);
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -2737,3 +2745,29 @@ void print_vma_addr(char *prefix, unsign
 	}
 	up_read(&current->mm->mmap_sem);
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
