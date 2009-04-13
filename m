Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZDMWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZDMWXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZDMWXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:23:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:51524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZDMWXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:23:02 -0400
Date: Mon, 13 Apr 2009 22:21:49 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, penberg@cs.helsinki.fi, zhaolei@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DEE68A.5040902@cn.fujitsu.com>
References: <49DEE68A.5040902@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing, kmemtrace: Separate include/trace/kmemtrace.h to kmemtrace part and tracepoint part
Message-ID: <tip-02af61bb50f5d5f0322dbe5ab2a0d75808d25c7b@git.kernel.org>
Git-Commit-ID: 02af61bb50f5d5f0322dbe5ab2a0d75808d25c7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 22:21:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02af61bb50f5d5f0322dbe5ab2a0d75808d25c7b
Gitweb:     http://git.kernel.org/tip/02af61bb50f5d5f0322dbe5ab2a0d75808d25c7b
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 10 Apr 2009 14:26:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 15:22:55 +0200

tracing, kmemtrace: Separate include/trace/kmemtrace.h to kmemtrace part and tracepoint part

Impact: refactor code for future changes

Current kmemtrace.h is used both as header file of kmemtrace and kmem's
tracepoints definition.

Tracepoints' definition file may be used by other code, and should only have
definition of tracepoint.

We can separate include/trace/kmemtrace.h into 2 files:

  include/linux/kmemtrace.h: header file for kmemtrace
  include/trace/kmem.h:      definition of kmem tracepoints

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49DEE68A.5040902@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/kmemtrace.h |   25 ++++++++++++++++++
 include/linux/slab_def.h  |    2 +-
 include/linux/slub_def.h  |    2 +-
 include/trace/kmem.h      |   44 +++++++++++++++++++++++++++++++
 include/trace/kmemtrace.h |   63 ---------------------------------------------
 init/main.c               |    2 +-
 kernel/trace/kmemtrace.c  |    2 +-
 kernel/trace/trace.h      |    2 +-
 mm/slab.c                 |    2 +-
 mm/slob.c                 |    2 +-
 mm/slub.c                 |    2 +-
 11 files changed, 77 insertions(+), 71 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
new file mode 100644
index 0000000..15c45a2
--- /dev/null
+++ b/include/linux/kmemtrace.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_KMEMTRACE_H
+#define _LINUX_KMEMTRACE_H
+
+#ifdef __KERNEL__
+
+#include <trace/kmem.h>
+
+#ifdef CONFIG_KMEMTRACE
+extern void kmemtrace_init(void);
+#else
+static inline void kmemtrace_init(void)
+{
+}
+#endif
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 5ac9b0b..713f841 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,7 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 /* Size description struct for general caches. */
 struct cache_sizes {
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 5046f90..be5d40c 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,7 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
diff --git a/include/trace/kmem.h b/include/trace/kmem.h
new file mode 100644
index 0000000..24d2519
--- /dev/null
+++ b/include/trace/kmem.h
@@ -0,0 +1,44 @@
+#ifndef _TRACE_KMEM_H
+#define _TRACE_KMEM_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+DECLARE_TRACE(kmalloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmem_cache_alloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmalloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kmem_cache_alloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kfree,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
+DECLARE_TRACE(kmem_cache_free,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
+
+#endif /* _TRACE_KMEM_H */
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
deleted file mode 100644
index 28ee69f..0000000
--- a/include/trace/kmemtrace.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Copyright (C) 2008 Eduard - Gabriel Munteanu
- *
- * This file is released under GPL version 2.
- */
-
-#ifndef _LINUX_KMEMTRACE_H
-#define _LINUX_KMEMTRACE_H
-
-#ifdef __KERNEL__
-
-#include <linux/tracepoint.h>
-#include <linux/types.h>
-
-#ifdef CONFIG_KMEMTRACE
-extern void kmemtrace_init(void);
-#else
-static inline void kmemtrace_init(void)
-{
-}
-#endif
-
-DECLARE_TRACE(kmalloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmem_cache_alloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmalloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kmem_cache_alloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kfree,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
-DECLARE_TRACE(kmem_cache_free,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
-
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_KMEMTRACE_H */
-
diff --git a/init/main.c b/init/main.c
index 3585f07..eece40c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -64,6 +64,7 @@
 #include <linux/idr.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
+#include <linux/kmemtrace.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -71,7 +72,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
-#include <trace/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 5011f4d..7a0aa0e 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -12,7 +12,7 @@
 #include <linux/dcache.h>
 #include <linux/fs.h>
 
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 #include "trace_output.h"
 #include "trace.h"
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f76a8f8..34b94c3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -9,7 +9,7 @@
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <trace/power.h>
 
 enum trace_type {
diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..f85831d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -102,7 +102,7 @@
 #include	<linux/cpu.h>
 #include	<linux/sysctl.h>
 #include	<linux/module.h>
-#include	<trace/kmemtrace.h>
+#include	<linux/kmemtrace.h>
 #include	<linux/rcupdate.h>
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
diff --git a/mm/slob.c b/mm/slob.c
index a2d4ab3..494f05f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,7 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <asm/atomic.h>
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..ea9e716 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
