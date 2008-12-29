Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYL2Vmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYL2Vmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYL2Vm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:42:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53821 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYL2Vm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:42:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=ESZ5WVKBE2Hb4vXhFtx8HPKoQQ4D14lkZL1tAnBYZE/kD29tvn6mW8eL14D3ooRj4W
         WbgIKTISDFT7OYqqx07dUrgpOSRQhNCCsz7hN2QvHd+bfoCKJdo7iSdW/xwEbjS+df9U
         7/f40U3gdJZdiETK8tcEFeKoPK25+0OvXnjRo=
Message-ID: <4959443f.09a1660a.44f3.2686@mx.google.com>
Date: Mon, 29 Dec 2008 13:42:23 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       fweisbec@gmail.com
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/kmemtrace: normalize the raw tracer event to the unified tracing API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new tracer

This patch adapts kmemtrace raw events tracing to the unified tracing API.
It applies on latest tip/tracing/kmemtrace
To enable and use this tracer, just do the following:

echo kmemtrace > /debugfs/tracing/current_tracer
cat /debugfs/tracing/trace

You will have the following output:

type_id 1 call_site 18446744071565527833 ptr 18446612134395152256
type_id 0 call_site 18446744071565585597 ptr 18446612134405955584 bytes_req 4096 bytes_alloc 4096 gfp_flags 208 node -1
type_id 1 call_site 18446744071565585534 ptr 18446612134405955584
type_id 0 call_site 18446744071565585597 ptr 18446612134405955584 bytes_req 4096 bytes_alloc 4096 gfp_flags 208 node -1
type_id 0 call_site 18446744071565636711 ptr 18446612134345164672 bytes_req 240 bytes_alloc 240 gfp_flags 208 node -1
type_id 1 call_site 18446744071565585534 ptr 18446612134405955584
type_id 0 call_site 18446744071565585597 ptr 18446612134405955584 bytes_req 4096 bytes_alloc 4096 gfp_flags 208 node -1
type_id 0 call_site 18446744071565636711 ptr 18446612134345164912 bytes_req 240 bytes_alloc 240 gfp_flags 208 node -1
type_id 1 call_site 18446744071565585534 ptr 18446612134405955584
type_id 0 call_site 18446744071565585597 ptr 18446612134405955584 bytes_req 4096 bytes_alloc 4096 gfp_flags 208 node -1
type_id 0 call_site 18446744071565636711 ptr 18446612134345165152 bytes_req 240 bytes_alloc 240 gfp_flags 208 node -1
type_id 0 call_site 18446744071566144042 ptr 18446612134346191680 bytes_req 1304 bytes_alloc 1312 gfp_flags 208 node -1
type_id 1 call_site 18446744071565585534 ptr 18446612134405955584
type_id 0 call_site 18446744071565585597 ptr 18446612134405955584 bytes_req 4096 bytes_alloc 4096 gfp_flags 208 node -1
type_id 1 call_site 18446744071565585534 ptr 18446612134405955584

That was to stay backward compatible with the format output produced in linux/tracepoint.h
This is the default ouput, but note that I tried something else.
If you change an option:

echo kmem_minimalistic > /debugfs/trace_options

and then cat /debugfs/trace
You will have the following output:

  -      C                            0xffff88007c088780          file_free_rcu
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc780     -1   d_alloc
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc870     -1   d_alloc
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  +      K    240    240   000000d0   0xffff8800790dc960     -1   d_alloc
  +      K   1304   1312   000000d0   0xffff8800791d7340     -1   reiserfs_alloc_inode
  -      C                            0xffff88007cad6000          putname
  +      K   4096   4096   000000d0   0xffff88007cad6000     -1   getname
  -      C                            0xffff88007cad6000          putname
  +      K    992   1000   000000d0   0xffff880079045b58     -1   alloc_inode
  +      K    768   1024   000080d0   0xffff88007c096400     -1   alloc_pipe_info
  +      K    240    240   000000d0   0xffff8800790dca50     -1   d_alloc
  +      K    272    320   000080d0   0xffff88007c088780     -1   get_empty_filp
  +      K    272    320   000080d0   0xffff88007c088000     -1   get_empty_filp

Yeah I shall confess kmem_minimalistic should be: kmem_alternative.

Whatever, I find it more readable but this a personal opinion of course. We can drop it if you want.
On the ALLOC/FREE column, + means an allocation and - a free.

On the type column, you have K = kmalloc, C = cache, P = page
I would like the flags to be GFP_* strings but that would not be easy to not break the column with strings....

About the node...it seems to always be -1. I don't know why but that shouldn't be difficult to find.

I moved linux/tracepoint.h to trace/tracepoint.h as well. I think that would be more easy to find the tracer
headers if they are all in their common directory.

Don't hesitate to comment, I'm not a kmemtrace specialist so...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/kmemtrace.h      |   86 ----------
 include/linux/slab_def.h       |    2 +-
 include/linux/slub_def.h       |    2 +-
 include/trace/kmemtrace.h      |   75 +++++++++
 init/main.c                    |    2 +-
 kernel/trace/Kconfig           |   21 +++
 kernel/trace/Makefile          |    1 +
 kernel/trace/trace.h           |   25 +++
 kernel/trace/trace_kmemtrace.c |  345 ++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug              |   20 ---
 mm/kmemtrace.c                 |    2 +-
 mm/slob.c                      |    2 +-
 mm/slub.c                      |    2 +-
 13 files changed, 473 insertions(+), 112 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
deleted file mode 100644
index 5bea8ea..0000000
--- a/include/linux/kmemtrace.h
+++ /dev/null
@@ -1,86 +0,0 @@
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
-#include <linux/types.h>
-#include <linux/marker.h>
-
-enum kmemtrace_type_id {
-	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
-	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
-	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
-};
-
-#ifdef CONFIG_KMEMTRACE
-
-extern void kmemtrace_init(void);
-
-static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node)
-{
-	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
-		   type_id, call_site, (unsigned long) ptr,
-		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
-		   (unsigned long) gfp_flags, node);
-}
-
-static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr)
-{
-	trace_mark(kmemtrace_free, "type_id %d call_site %lu ptr %lu",
-		   type_id, call_site, (unsigned long) ptr);
-}
-
-#else /* CONFIG_KMEMTRACE */
-
-static inline void kmemtrace_init(void)
-{
-}
-
-static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node)
-{
-}
-
-static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr)
-{
-}
-
-#endif /* CONFIG_KMEMTRACE */
-
-static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
-					unsigned long call_site,
-					const void *ptr,
-					size_t bytes_req,
-					size_t bytes_alloc,
-					gfp_t gfp_flags)
-{
-	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
-				  bytes_req, bytes_alloc, gfp_flags, -1);
-}
-
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_KMEMTRACE_H */
-
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 7555ce9..455f9af 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,7 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 
 /* Size description struct for general caches. */
 struct cache_sizes {
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index dc28432..6b657f7 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,7 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
new file mode 100644
index 0000000..ad8b785
--- /dev/null
+++ b/include/trace/kmemtrace.h
@@ -0,0 +1,75 @@
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
+#include <linux/types.h>
+#include <linux/marker.h>
+
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
+#ifdef CONFIG_KMEMTRACE
+
+extern void kmemtrace_init(void);
+
+extern void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node);
+
+extern void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr);
+
+#else /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_init(void)
+{
+}
+
+static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node)
+{
+}
+
+static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr)
+{
+}
+
+#endif /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
+					unsigned long call_site,
+					const void *ptr,
+					size_t bytes_req,
+					size_t bytes_alloc,
+					gfp_t gfp_flags)
+{
+	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
+				  bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/init/main.c b/init/main.c
index 9711586..beca7aa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -70,7 +70,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e2a4ff6..1c0b750 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -264,6 +264,27 @@ config HW_BRANCH_TRACER
 	  This tracer records all branches on the system in a circular
 	  buffer giving access to the last N branches for each cpu.
 
+config KMEMTRACE
+	bool "Trace SLAB allocations"
+	select TRACING
+	help
+	  kmemtrace provides tracing for slab allocator functions, such as
+	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
+	  data is then fed to the userspace application in order to analyse
+	  allocation hotspots, internal fragmentation and so on, making it
+	  possible to see how well an allocator performs, as well as debug
+	  and profile kernel code.
+
+	  This requires an userspace application to use. See
+	  Documentation/vm/kmemtrace.txt for more information.
+
+	  Saying Y will make the kernel somewhat larger and slower. However,
+	  if you disable kmemtrace at run-time or boot-time, the performance
+	  impact is minimal (depending on the arch the kernel is built for).
+
+	  If unsure, say N.
+
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 349d5a9..df106e3 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -33,5 +33,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
+obj-$(CONFIG_KMEMTRACE) += trace_kmemtrace.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cc7a4f8..534505b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -9,6 +9,7 @@
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
+#include <trace/kmemtrace.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -29,6 +30,8 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_HW_BRANCHES,
+	TRACE_KMEM_ALLOC,
+	TRACE_KMEM_FREE,
 	TRACE_POWER,
 
 	__TRACE_LAST_TYPE
@@ -170,6 +173,24 @@ struct trace_power {
 	struct power_trace	state_data;
 };
 
+struct kmemtrace_alloc_entry {
+	struct trace_entry	ent;
+	enum kmemtrace_type_id type_id;
+	unsigned long call_site;
+	const void *ptr;
+	size_t bytes_req;
+	size_t bytes_alloc;
+	gfp_t gfp_flags;
+	int node;
+};
+
+struct kmemtrace_free_entry {
+	struct trace_entry	ent;
+	enum kmemtrace_type_id type_id;
+	unsigned long call_site;
+	const void *ptr;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -280,6 +301,10 @@ extern void __ftrace_bad_type(void);
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
  		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
+		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
+			  TRACE_KMEM_ALLOC);	\
+		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
+			  TRACE_KMEM_FREE);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_kmemtrace.c b/kernel/trace/trace_kmemtrace.c
new file mode 100644
index 0000000..a9809b5
--- /dev/null
+++ b/kernel/trace/trace_kmemtrace.c
@@ -0,0 +1,345 @@
+/*
+ * Memory allocator tracing
+ *
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2008 Pekka Enberg <penberg@cs.helsinki.fi>
+ *
+ * Some parts based on the old linux/kmemtrace.h which is
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ *
+ */
+
+#include <linux/dcache.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <trace/kmemtrace.h>
+
+#include "trace.h"
+
+/* Select an alternative, minimalistic output than the original one */
+#define TRACE_KMEM_OPT_MINIMAL	0x1
+
+static struct tracer_opt kmem_opts[] = {
+	/* Default disable the minimalistic output */
+	{ TRACER_OPT(kmem_minimalistic, TRACE_KMEM_OPT_MINIMAL) },
+	{ }
+};
+
+static struct tracer_flags kmem_tracer_flags = {
+	.val = 0,
+	.opts = kmem_opts
+};
+
+
+static bool kmem_tracing_enabled __read_mostly;
+static struct trace_array *kmemtrace_array;
+
+static int kmem_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	kmemtrace_array = tr;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+
+	kmem_tracing_enabled = true;
+
+	return 0;
+}
+
+static void kmem_trace_reset(struct trace_array *tr)
+{
+	kmem_tracing_enabled = false;
+}
+
+static void kmemtrace_headers(struct seq_file *s)
+{
+	/* Don't need headers for the original kmemtrace output */
+	if (!(kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL))
+		return;
+
+	seq_printf(s, "#\n");
+	seq_printf(s, "# ALLOC  TYPE  REQ   GIVEN  FLAGS     "
+			"      POINTER         NODE    CALLER\n");
+	seq_printf(s, "# FREE   |      |     |       |       "
+			"       |   |            |        |\n");
+	seq_printf(s, "# |\n\n");
+}
+
+/*
+ * The two following functions give the original output from kmemtrace,
+ * or something close to....perhaps they need some missing things
+ */
+static enum print_line_t
+kmemtrace_print_alloc_original(struct trace_iterator *iter,
+				struct kmemtrace_alloc_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Taken from the old linux/kmemtrace.h */
+	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu "
+	  "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
+	   entry->type_id, entry->call_site, (unsigned long) entry->ptr,
+	   (unsigned long) entry->bytes_req, (unsigned long) entry->bytes_alloc,
+	   (unsigned long) entry->gfp_flags, entry->node);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free_original(struct trace_iterator *iter,
+				struct kmemtrace_free_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Taken from the old linux/kmemtrace.h */
+	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu\n",
+	   entry->type_id, entry->call_site, (unsigned long) entry->ptr);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+
+/* The two other following provide a more minimalistic output */
+static enum print_line_t
+kmemtrace_print_alloc_compress(struct trace_iterator *iter,
+					struct kmemtrace_alloc_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Alloc entry */
+	ret = trace_seq_printf(s, "  +      ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Type */
+	switch (entry->type_id) {
+	case KMEMTRACE_TYPE_KMALLOC:
+		ret = trace_seq_printf(s, "K   ");
+		break;
+	case KMEMTRACE_TYPE_CACHE:
+		ret = trace_seq_printf(s, "C   ");
+		break;
+	case KMEMTRACE_TYPE_PAGES:
+		ret = trace_seq_printf(s, "P   ");
+		break;
+	default:
+		ret = trace_seq_printf(s, "?   ");
+	}
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Requested */
+	ret = trace_seq_printf(s, "%4d   ", entry->bytes_req);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Allocated */
+	ret = trace_seq_printf(s, "%4d   ", entry->bytes_alloc);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Flags
+	 * TODO: would be better to see the name of the GFP flag names
+	 */
+	ret = trace_seq_printf(s, "%08x   ", entry->gfp_flags);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Pointer to allocated */
+	ret = trace_seq_printf(s, "0x%tx   ", (ptrdiff_t)entry->ptr);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Node */
+	ret = trace_seq_printf(s, "%4d   ", entry->node);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Call site */
+	ret = seq_print_ip_sym(s, entry->call_site, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!trace_seq_printf(s, "\n"))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free_compress(struct trace_iterator *iter,
+				struct kmemtrace_free_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Free entry */
+	ret = trace_seq_printf(s, "  -      ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Type */
+	switch (entry->type_id) {
+	case KMEMTRACE_TYPE_KMALLOC:
+		ret = trace_seq_printf(s, "K     ");
+		break;
+	case KMEMTRACE_TYPE_CACHE:
+		ret = trace_seq_printf(s, "C     ");
+		break;
+	case KMEMTRACE_TYPE_PAGES:
+		ret = trace_seq_printf(s, "P     ");
+		break;
+	default:
+		ret = trace_seq_printf(s, "?     ");
+	}
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Skip requested/allocated/flags */
+	ret = trace_seq_printf(s, "                       ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Pointer to allocated */
+	ret = trace_seq_printf(s, "0x%tx   ", (ptrdiff_t)entry->ptr);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Skip node */
+	ret = trace_seq_printf(s, "       ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Call site */
+	ret = seq_print_ip_sym(s, entry->call_site, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!trace_seq_printf(s, "\n"))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+
+	switch (entry->type) {
+	case TRACE_KMEM_ALLOC: {
+		struct kmemtrace_alloc_entry *field;
+		trace_assign_type(field, entry);
+		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
+			return kmemtrace_print_alloc_compress(iter, field);
+		else
+			return kmemtrace_print_alloc_original(iter, field);
+	}
+
+	case TRACE_KMEM_FREE: {
+		struct kmemtrace_free_entry *field;
+		trace_assign_type(field, entry);
+		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
+			return kmemtrace_print_free_compress(iter, field);
+		else
+			return kmemtrace_print_free_original(iter, field);
+	}
+
+	default:
+		return TRACE_TYPE_UNHANDLED;
+	}
+}
+
+/* Trace allocations */
+void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+			     unsigned long call_site,
+			     const void *ptr,
+			     size_t bytes_req,
+			     size_t bytes_alloc,
+			     gfp_t gfp_flags,
+			     int node)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_alloc_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	if (!kmem_tracing_enabled)
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+	entry->bytes_req = bytes_req;
+	entry->bytes_alloc = bytes_alloc;
+	entry->gfp_flags = gfp_flags;
+	entry->node	=	node;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+		       unsigned long call_site,
+		       const void *ptr)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_free_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	if (!kmem_tracing_enabled)
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_FREE;
+	entry->type_id	= type_id;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+static struct tracer kmem_tracer __read_mostly = {
+	.name		= "kmemtrace",
+	.init		= kmem_trace_init,
+	.reset		= kmem_trace_reset,
+	.print_line	= kmemtrace_print_line,
+	.print_header = kmemtrace_headers,
+	.flags		= &kmem_tracer_flags
+};
+
+static int __init init_kmem_tracer(void)
+{
+	return register_tracer(&kmem_tracer);
+}
+
+device_initcall(init_kmem_tracer);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b5417e2..b0f239e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -803,26 +803,6 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
-config KMEMTRACE
-	bool "Kernel memory tracer (kmemtrace)"
-	depends on RELAY && DEBUG_FS && MARKERS
-	help
-	  kmemtrace provides tracing for slab allocator functions, such as
-	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
-	  data is then fed to the userspace application in order to analyse
-	  allocation hotspots, internal fragmentation and so on, making it
-	  possible to see how well an allocator performs, as well as debug
-	  and profile kernel code.
-
-	  This requires an userspace application to use. See
-	  Documentation/vm/kmemtrace.txt for more information.
-
-	  Saying Y will make the kernel somewhat larger and slower. However,
-	  if you disable kmemtrace at run-time or boot-time, the performance
-	  impact is minimal (depending on the arch the kernel is built for).
-
-	  If unsure, say N.
-
 menuconfig BUILD_DOCSRC
 	bool "Build targets in Documentation/ tree"
 	depends on HEADERS_CHECK
diff --git a/mm/kmemtrace.c b/mm/kmemtrace.c
index 2a70a80..0573b50 100644
--- a/mm/kmemtrace.c
+++ b/mm/kmemtrace.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/marker.h>
 #include <linux/gfp.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 
 #define KMEMTRACE_SUBBUF_SIZE		524288
 #define KMEMTRACE_DEF_N_SUBBUFS		20
diff --git a/mm/slob.c b/mm/slob.c
index 0f1a49f..4d1c0fc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,7 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 #include <asm/atomic.h>
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index cc4001f..7bf8cf8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/kmemtrace.h>
+#include <trace/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
-- 
1.6.0.4


