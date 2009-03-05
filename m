Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZCEX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZCEX23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbZCEX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:27:42 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33708 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759AbZCEX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:27:40 -0500
Message-Id: <20090305225517.022282304@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 24/41] Linux Kernel Markers - Use Immediate Values
Content-Disposition: inline; filename=linux-kernel-markers-immediate-values.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:13 +0000
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
 kernel/marker.c           |   12 ++++++++----
 ltt/ltt-marker-control.c  |    4 ++--
 4 files changed, 35 insertions(+), 14 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2009-02-06 15:03:19.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2009-02-06 15:17:46.000000000 -0500
@@ -14,6 +14,7 @@
 
 #include <stdarg.h>
 #include <linux/types.h>
+#include <linux/immediate.h>
 
 struct module;
 struct marker;
@@ -43,7 +44,7 @@ struct marker {
 	const char *format;	/* Marker format string, describing the
 				 * variable argument list.
 				 */
-	char state;		/* Marker state. */
+	DEFINE_IMV(char, state);/* Immediate value state. */
 	char ptype;		/* probe type : 0 : single, 1 : multi */
 				/* Probe wrapper */
 	void (*call)(const struct marker *mdata, void *call_private, ...);
@@ -86,9 +87,16 @@ struct marker {
 	do {								\
 		DEFINE_MARKER(name, format);				\
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
 
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2009-02-06 15:03:19.000000000 -0500
+++ linux-2.6-lttng/kernel/marker.c	2009-02-06 15:17:46.000000000 -0500
@@ -24,6 +24,7 @@
 #include <linux/marker.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/immediate.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
@@ -532,7 +533,7 @@ static int set_marker(struct marker_entr
 	smp_wmb();
 	elem->ptype = entry->ptype;
 
-	if (elem->tp_name && (active ^ elem->state)) {
+	if (elem->tp_name && (active ^ _imv_read(elem->state))) {
 		WARN_ON(!elem->tp_cb);
 		/*
 		 * It is ok to directly call the probe registration because type
@@ -562,7 +563,7 @@ static int set_marker(struct marker_entr
 				(unsigned long)elem->tp_cb));
 		}
 	}
-	elem->state = active;
+	elem->state__imv = active;
 
 	return ret;
 }
@@ -578,7 +579,7 @@ static void disable_marker(struct marker
 	int ret;
 
 	/* leave "call" as is. It is known statically. */
-	if (elem->tp_name && elem->state) {
+	if (elem->tp_name && _imv_read(elem->state)) {
 		WARN_ON(!elem->tp_cb);
 		/*
 		 * It is ok to directly call the probe registration because type
@@ -593,7 +594,7 @@ static void disable_marker(struct marker
 		 */
 		module_put(__module_text_address((unsigned long)elem->tp_cb));
 	}
-	elem->state = 0;
+	elem->state__imv = 0;
 	elem->single.func = __mark_empty_function;
 	/* Update the function before setting the ptype */
 	smp_wmb();
@@ -657,6 +658,9 @@ static void marker_update_probes(void)
 	/* Markers in modules. */
 	module_update_markers();
 	tracepoint_probe_update_all();
+	/* Update immediate values */
+	core_imv_update();
+	module_imv_update();
 }
 
 /**
Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/markers.txt	2009-02-06 14:45:26.000000000 -0500
+++ linux-2.6-lttng/Documentation/markers.txt	2009-02-06 15:17:46.000000000 -0500
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
@@ -90,6 +92,13 @@ notrace void probe_tracepoint_name(unsig
 	/* write data to trace buffers ... */
 }
 
+* Optimization for a given architecture
+
+To force use of a non-optimized version of the markers, _trace_mark() should be
+used. It takes the same parameters as the normal markers, but it does not use
+the immediate values based on code patching.
+
+
 * Probe / marker example
 
 See the example provided in samples/markers/src

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
