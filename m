Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbYDXPRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbYDXPRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbYDXPOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56017 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbYDXPOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:39 -0400
Message-Id: <20080424151405.695136043@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 30/37] Linux Kernel Markers - Use Immediate Values
Content-Disposition: inline; filename=linux-kernel-markers-immediate-values.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make markers use immediate values.

Changelog :
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/markers.txt |   17 +++++++++++++----
 include/linux/marker.h    |   16 ++++++++++++----
 kernel/marker.c           |    8 ++++++--
 kernel/module.c           |    1 +
 4 files changed, 32 insertions(+), 10 deletions(-)

Index: linux-2.6-sched-devel/include/linux/marker.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/marker.h	2008-04-24 09:17:56.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/marker.h	2008-04-24 09:17:58.000000000 -0400
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
 				/* Probe wrapper */
 	void (*call)(const struct marker *mdata, void *call_private, ...);
@@ -74,9 +75,16 @@ struct marker {
 		0, 0, marker_probe_cb,					\
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
-		if (unlikely(__mark_##name.state)) {			\
-			(*__mark_##name.call)				\
-				(&__mark_##name, call_private, ## args);\
+		if (!generic) {						\
+			if (unlikely(imv_read(__mark_##name.state)))	\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_private,	\
+					## args);			\
+		} else {						\
+			if (unlikely(_imv_read(__mark_##name.state)))	\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_private,	\
+					## args);			\
 		}							\
 	} while (0)
 
Index: linux-2.6-sched-devel/kernel/marker.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/marker.c	2008-04-24 09:17:56.000000000 -0400
+++ linux-2.6-sched-devel/kernel/marker.c	2008-04-24 09:17:58.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/marker.h>
 #include <linux/err.h>
+#include <linux/immediate.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
@@ -542,7 +543,7 @@ static int set_marker(struct marker_entr
 	 */
 	smp_wmb();
 	elem->ptype = (*entry)->ptype;
-	elem->state = active;
+	elem->state__imv = active;
 
 	return 0;
 }
@@ -556,7 +557,7 @@ static int set_marker(struct marker_entr
 static void disable_marker(struct marker *elem)
 {
 	/* leave "call" as is. It is known statically. */
-	elem->state = 0;
+	elem->state__imv = 0;
 	elem->single.func = __mark_empty_function;
 	/* Update the function before setting the ptype */
 	smp_wmb();
@@ -620,6 +621,9 @@ static void marker_update_probes(void)
 	marker_update_probe_range(__start___markers, __stop___markers);
 	/* Markers in modules. */
 	module_update_markers();
+	/* Update immediate values */
+	core_imv_update();
+	module_imv_update();
 }
 
 /**
Index: linux-2.6-sched-devel/Documentation/markers.txt
===================================================================
--- linux-2.6-sched-devel.orig/Documentation/markers.txt	2008-04-24 09:17:57.000000000 -0400
+++ linux-2.6-sched-devel/Documentation/markers.txt	2008-04-24 09:17:58.000000000 -0400
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
Index: linux-2.6-sched-devel/kernel/module.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/module.c	2008-04-24 09:17:56.000000000 -0400
+++ linux-2.6-sched-devel/kernel/module.c	2008-04-24 09:17:58.000000000 -0400
@@ -2052,6 +2052,7 @@ static struct module *load_module(void _
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
