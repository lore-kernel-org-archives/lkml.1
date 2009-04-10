Return-Path: <linux-kernel-owner+w=401wt.eu-S937771AbZDJG0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937771AbZDJG0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761142AbZDJG0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:26:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbZDJG0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:26:38 -0400
Message-ID: <49DEE68A.5040902@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 14:26:18 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ftrace: Separate include/trace/kmemtrace.h to kmemtrace
 part and tracepoint part
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kmemtrace.h is used both as header file of kmemtrace and kmem's
tracepoints definition.
Tracepoints' definition file may be used by other code, and should only have
definition of tracepoint.

We can separate include/trace/kmemtrace.h into 2 files:
  include/linux/kmemtrace.h: header file for kmemtrace
  include/trace/kmem.h:      definition of kmem tracepoints

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/kmemtrace.h             |   25 +++++++++++++++++++++++++
 include/linux/slab_def.h              |    2 +-
 include/linux/slub_def.h              |    2 +-
 include/trace/{kmemtrace.h => kmem.h} |   25 +++----------------------
 init/main.c                           |    2 +-
 kernel/trace/kmemtrace.c              |    2 +-
 kernel/trace/trace.h                  |    2 +-
 mm/slab.c                             |    2 +-
 mm/slob.c                             |    2 +-
 mm/slub.c                             |    2 +-
 10 files changed, 36 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/kmemtrace.h
 rename include/trace/{kmemtrace.h => kmem.h} (78%)

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
index 1a78b7a..850d057 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,7 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 /*
  * struct kmem_cache
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
diff --git a/include/trace/kmemtrace.h b/include/trace/kmem.h
similarity index 78%
rename from include/trace/kmemtrace.h
rename to include/trace/kmem.h
index 28ee69f..24d2519 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmem.h
@@ -1,25 +1,9 @@
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
+#ifndef _TRACE_KMEM_H
+#define _TRACE_KMEM_H
 
 #include <linux/tracepoint.h>
 #include <linux/types.h>
 
-#ifdef CONFIG_KMEMTRACE
-extern void kmemtrace_init(void);
-#else
-static inline void kmemtrace_init(void)
-{
-}
-#endif
-
 DECLARE_TRACE(kmalloc,
 	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
@@ -57,7 +41,4 @@ DECLARE_TRACE(kmem_cache_free,
 	      TP_PROTO(unsigned long call_site, const void *ptr),
 	      TP_ARGS(call_site, ptr));
 
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_KMEMTRACE_H */
-
+#endif /* _TRACE_KMEM_H */
diff --git a/init/main.c b/init/main.c
index ed702d9..694a563 100644
--- a/init/main.c
+++ b/init/main.c
@@ -65,6 +65,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
+#include <linux/kmemtrace.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -72,7 +73,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
-#include <trace/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 91cd0a5..86cdf67 100644
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
index ee23ea2..ce6bdc4 100644
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
index 6bf8a95..762acc2 100644
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
index 4ac5e3e..a98d456 100644
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
-- 
1.5.5.3


