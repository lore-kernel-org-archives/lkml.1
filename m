Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbXGNW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbXGNW7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXGNW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 18:59:27 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:56525 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbXGNW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 18:59:26 -0400
Date: Sat, 14 Jul 2007 18:59:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Architecture Independent Code - Fixes following HCH comments
Message-ID: <20070714225925.GC18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.231272637@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012623.231272637@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:58:35 up 7 days, 13:03,  2 users,  load average: 2.08, 0.73, 0.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Architecture Independent Code - Fixes following HCH comments

Various coding style fixes following Christoph's comments
Put asm-generic/immediate.h content into linux/immediate.h.
Remove ifdef __KERNEL__ in .h never exported to user space.
Make immediate_mutex static.

It applies after "Immediate Values - Architecture Independent Code".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
---
 include/linux/immediate.h |   18 ++++++++++++++----
 kernel/immediate.c        |   15 +++++++--------
 2 files changed, 21 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2007-07-14 18:13:58.000000000 -0400
+++ linux-2.6-lttng/include/linux/immediate.h	2007-07-14 18:16:26.000000000 -0400
@@ -10,12 +10,23 @@
  * See the file COPYING for more details.
  */
 
-#ifdef __KERNEL__
-
 #ifdef CONFIG_IMMEDIATE
 #include <asm/immediate.h>
 #else
-#include <asm-generic/immediate.h>
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+struct module;
+
+#define immediate_read(var)		_immediate_read(var)
+#define immediate_set(var, i)		((var)->value = (i))
+#define _immediate_set(var, i)		immediate_set(var, i)
+#define immediate_set_early(var, i)	immediate_set(var, i)
+#define immediate_if(var)		if (immediate_read(var))
+
+static inline void module_immediate_setup(struct module *mod) { }
+static inline void immediate_update_early(void) { }
 #endif
 
 /*
@@ -49,5 +60,4 @@ DEFINE_IMMEDIATE_TYPE(void*, immediate_v
  */
 #define _immediate_if(var)		if (_immediate_read(var))
 
-#endif /* __KERNEL__ */
 #endif
Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2007-07-14 18:13:58.000000000 -0400
+++ linux-2.6-lttng/kernel/immediate.c	2007-07-14 18:27:03.000000000 -0400
@@ -27,13 +27,13 @@ extern const struct __immediate __stop__
  * modules_mutex nests inside immediate_mutex. immediate_mutex protects builtin
  * immediates and module immediates.
  */
-DEFINE_MUTEX(immediate_mutex);
+static DEFINE_MUTEX(immediate_mutex);
 
 /*
  * Sets a range of immediates to a enabled state : set the enable bit.
  */
-static void _immediate_update_range(
-	const struct __immediate *begin, const struct __immediate *end)
+static inline void _immediate_update_range(const struct __immediate *begin,
+		const struct __immediate *end)
 {
 	const struct __immediate *iter;
 	int ret;
@@ -63,11 +63,10 @@ static void _immediate_update_range(
  */
 void module_immediate_setup(struct module *mod)
 {
-	_immediate_update_range(mod->immediate, mod->immediate+mod->num_immediate);
+	_immediate_update_range(mod->immediate,
+				mod->immediate+mod->num_immediate);
 }
-#endif
 
-#ifdef CONFIG_MODULES
 /*
  * immediate mutex nests inside the modules mutex.
  */
@@ -103,8 +102,8 @@ EXPORT_SYMBOL_GPL(immediate_update);
  * Update the immediate values to the state of the variables they refer to. It
  * is done before SMP is active, at the very beginning of start_kernel().
  */
-void __init immediate_update_early_range(
-	const struct __immediate *begin, const struct __immediate *end)
+void __init immediate_update_early_range(const struct __immediate *begin,
+		const struct __immediate *end)
 {
 	const struct __immediate *iter;
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
