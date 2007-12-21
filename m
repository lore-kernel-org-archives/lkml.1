Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbXLUB6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbXLUB6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXLUB5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:57:44 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35372 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXLUB5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:57:42 -0500
Message-Id: <20071221015730.645681568@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:55:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 24/24] Linux Kernel Markers - Use Immediate Values
Content-Disposition: inline; filename=linux-kernel-markers-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make markers use immediate values.

Changelog :
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/markers.txt |   17 +++++++++++++----
 include/linux/marker.h    |   42 ++++++++++++++++++++++++++++++++----------
 kernel/marker.c           |    8 ++++++--
 kernel/module.c           |    1 +
 4 files changed, 52 insertions(+), 16 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-12-05 20:53:25.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2007-12-05 20:53:54.000000000 -0500
@@ -12,6 +12,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/immediate.h>
 #include <linux/types.h>
 
 struct module;
@@ -42,7 +43,7 @@ struct marker {
 	const char *format;	/* Marker format string, describing the
 				 * variable argument list.
 				 */
-	char state;		/* Marker state. */
+	DEFINE_IMV(char, state);/* Immediate value state. */
 	char ptype;		/* probe type : 0 : single, 1 : multi */
 	void (*call)(const struct marker *mdata,	/* Probe wrapper */
 		void *call_private, const char *fmt, ...);
@@ -53,13 +54,14 @@ struct marker {
 #ifdef CONFIG_MARKERS
 
 /*
+ * Generic marker flavor always available.
  * Note : the empty asm volatile with read constraint is used here instead of a
  * "used" attribute to fix a gcc 4.1.x bug.
  * Make sure the alignment of the structure in the __markers section will
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __trace_mark(name, call_private, format, args...)		\
+#define __trace_mark(generic, name, call_private, format, args...)	\
 	do {								\
 		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
@@ -70,17 +72,23 @@ struct marker {
 		0, 0, marker_probe_cb,					\
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
-		if (unlikely(__mark_##name.state)) {			\
-			(*__mark_##name.call)				\
-				(&__mark_##name, call_private,		\
-				format, ## args);			\
+		if (!generic) {						\
+			if (unlikely(imv_read(__mark_##name.state)))	\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_private,	\
+					format, ## args);		\
+		} else {						\
+			if (unlikely(_imv_read(__mark_##name.state)))	\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_private,	\
+					format, ## args);		\
 		}							\
 	} while (0)
 
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
 #else /* !CONFIG_MARKERS */
-#define __trace_mark(name, call_private, format, args...) \
+#define __trace_mark(generic, name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
 static inline void marker_update_probe_range(struct marker *begin,
 	struct marker *end)
@@ -88,15 +96,29 @@ static inline void marker_update_probe_r
 #endif /* CONFIG_MARKERS */
 
 /**
- * trace_mark - Marker
+ * trace_mark - Marker using code patching
  * @name: marker name, not quoted.
  * @format: format string
  * @args...: variable argument list
  *
- * Places a marker.
+ * Places a marker using optimized code patching technique (imv_read())
+ * to be enabled.
  */
 #define trace_mark(name, format, args...) \
-	__trace_mark(name, NULL, format, ## args)
+	__trace_mark(0, name, NULL, format, ## args)
+
+/**
+ * _trace_mark - Marker using variable read
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker using a standard memory read (_imv_read()) to be
+ * enabled. Should be used for markers in __init and __exit functions and in
+ * lockdep code.
+ */
+#define _trace_mark(name, format, args...) \
+	__trace_mark(1, name, NULL, format, ## args)
 
 /**
  * MARK_NOARGS - Format string for a marker with no argument.
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2007-12-05 20:53:24.000000000 -0500
+++ linux-2.6-lttng/kernel/marker.c	2007-12-05 20:53:54.000000000 -0500
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/marker.h>
 #include <linux/err.h>
+#include <linux/immediate.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
@@ -544,7 +545,7 @@ static int set_marker(struct marker_entr
 	 */
 	smp_wmb();
 	elem->ptype = (*entry)->ptype;
-	elem->state = active;
+	elem->state__imv = active;
 
 	return 0;
 }
@@ -558,7 +559,7 @@ static int set_marker(struct marker_entr
 static void disable_marker(struct marker *elem)
 {
 	/* leave "call" as is. It is known statically. */
-	elem->state = 0;
+	elem->state__imv = 0;
 	elem->single.func = __mark_empty_function;
 	/* Update the function before setting the ptype */
 	smp_wmb();
@@ -625,6 +626,9 @@ static void marker_update_probes(void)
 	marker_update_probe_range(__start___markers, __stop___markers);
 	/* Markers in modules. */
 	module_update_markers();
+	/* Update immediate values */
+	core_imv_update();
+	module_imv_update();
 }
 
 /**
Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/markers.txt	2007-12-05 20:50:33.000000000 -0500
+++ linux-2.6-lttng/Documentation/markers.txt	2007-12-05 20:53:54.000000000 -0500
@@ -15,10 +15,12 @@ provide at runtime. A marker can be "on"
 (no probe is attached). When a marker is "off" it has no effect, except for
 adding a tiny time penalty (checking a condition for a branch) and space
 penalty (adding a few bytes for the function call at the end of the
-instrumented function and adds a data structure in a separate section).  When a
-marker is "on", the function you provide is called each time the marker is
-executed, in the execution context of the caller. When the function provided
-ends its execution, it returns to the caller (continuing from the marker site).
+instrumented function and adds a data structure in a separate section). The
+immediate values are used to minimize the impact on data cache, encoding the
+condition in the instruction stream. When a marker is "on", the function you
+provide is called each time the marker is executed, in the execution context of
+the caller. When the function provided ends its execution, it returns to the
+caller (continuing from the marker site).
 
 You can put markers at important locations in the code. Markers are
 lightweight hooks that can pass an arbitrary number of parameters,
@@ -69,6 +71,13 @@ a printk warning which identifies the in
 "Format mismatch for probe probe_name (format), marker (format)"
 
 
+* Optimization for a given architecture
+
+To force use of a non-optimized version of the markers, _trace_mark() should be
+used. It takes the same parameters as the normal markers, but it does not use
+the immediate values based on code patching.
+
+
 * Probe / marker example
 
 See the example provided in samples/markers/src
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-12-05 20:53:34.000000000 -0500
+++ linux-2.6-lttng/kernel/module.c	2007-12-05 20:53:54.000000000 -0500
@@ -2005,6 +2005,7 @@ static struct module *load_module(void _
 			mod->markers + mod->num_markers);
 #endif
 #ifdef CONFIG_IMMEDIATE
+		/* Immediate values must be updated after markers */
 		imv_update_range(mod->immediate,
 			mod->immediate + mod->num_immediate);
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
