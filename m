Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYKQN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYKQN23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKQN0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:36 -0500
Received: from ozlabs.org ([203.10.76.45]:39449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYKQN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:27 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 6/7] Improve alloc_percpu: __get_cpu_ptr/get_cpu_ptr/put_cpu_ptr
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132631.76367DDE07@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now we have a decent implementation it makes sense to have an
interface for "this cpu", analogous to __get_cpu_var.

Alpha is untested.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 arch/alpha/include/asm/percpu.h |   10 ++++++++++
 include/asm-generic/percpu.h    |   11 +++++++++++
 include/linux/percpu.h          |   16 ++++++++++++++++
 3 files changed, 37 insertions(+)

diff -r 0fb05e4271a6 arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h	Mon Nov 17 22:19:40 2008 +1030
+++ b/arch/alpha/include/asm/percpu.h	Mon Nov 17 22:21:09 2008 +1030
@@ -62,8 +62,16 @@
 	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
 #define __raw_get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
+#define __get_cpu_ptr(ptr) \
+	RELOC_HIDE(ptr, my_cpu_offset)
+#define __raw_get_cpu_ptr(ptr) \
+	RELOC_HIDE(ptr, __my_cpu_offset)
 #define per_cpu_ptr(ptr, cpu) \
 	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
+#define __get_cpu_ptr(ptr) \
+	RELOC_HIDE(ptr, my_cpu_offset)
+#define __raw_get_cpu_ptr(ptr) \
+	RELOC_HIDE(ptr, __my_cpu_offset)
 
 #else /* ! SMP */
 
@@ -71,6 +79,8 @@
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
 #define per_cpu_ptr(ptr, cpu)		(ptr)
+#define __get_cpu_ptr(ptr)		(ptr)
+#define __raw_get_cpu_ptr(ptr)		(ptr)
 
 #define PER_CPU_ATTRIBUTES
 
diff -r 0fb05e4271a6 include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h	Mon Nov 17 22:19:40 2008 +1030
+++ b/include/asm-generic/percpu.h	Mon Nov 17 22:21:09 2008 +1030
@@ -72,6 +72,15 @@
 #define per_cpu_ptr(ptr, cpu) \
 	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
 
+/**
+ * __get_cpu_ptr - get a pointer to this cpu's allocated memory
+ * @ptr: the pointer returned from alloc_percpu
+ *
+ * Similar to __get_cpu_var(), except for dynamic memory.
+ */
+#define __get_cpu_ptr(ptr) RELOC_HIDE(ptr, my_cpu_offset)
+#define __raw_get_cpu_ptr(ptr) RELOC_HIDE(ptr, __my_cpu_offset)
+
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
@@ -82,6 +91,8 @@
 #define __get_cpu_var(var)			per_cpu_var(var)
 #define __raw_get_cpu_var(var)			per_cpu_var(var)
 #define per_cpu_ptr(ptr, cpu)			(ptr)
+#define __get_cpu_ptr(ptr)			(ptr)
+#define __raw_get_cpu_ptr(ptr)			(ptr)
 
 #endif	/* SMP */
 
diff -r 0fb05e4271a6 include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 22:19:40 2008 +1030
+++ b/include/linux/percpu.h	Mon Nov 17 22:21:09 2008 +1030
@@ -57,6 +57,22 @@
 	&__get_cpu_var(var); }))
 #define put_cpu_var(var) preempt_enable()
 
+/**
+ * put_cpu_ptr - return a pointer to this cpu's allocated memory
+ * @ptr: the pointer passed to get_cpu_ptr().
+ *
+ * Counterpart to get_cpu_ptr(): re-enables preemption
+ */
+#define put_cpu_ptr(ptr) preempt_enable()
+
+/**
+ * get_cpu_ptr - hold a pointer to this cpu's allocated memory
+ * @ptr: the pointer returned from alloc_percpu
+ *
+ * Similar to get_cpu_var(), except for dynamic memory.  Disabled preemption.
+ */
+#define get_cpu_ptr(ptr) ({ preempt_disable(); __get_cpu_ptr(ptr); })
+
 #ifdef CONFIG_SMP
 void *__alloc_percpu(unsigned long size, unsigned long align);
 void free_percpu(void *pcpuptr);

