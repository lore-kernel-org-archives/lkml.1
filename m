Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYKNXEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYKNXEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYKNXA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:26 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57181 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYKNXAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:25 -0500
Message-Id: <20081114224948.134716055@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 06/16] Markers auto enable tracepoints (new API : trace_mark_tp())
Content-Disposition: inline; filename=markers-auto-enable-tracepoints.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new API trace_mark_tp(), which declares a marker within a tracepoint
probe. When the marker is activated, the tracepoint is automatically enabled.

No branch test is used at the marker site, because it would be a duplicate of
the branch already present in the tracepoint.

Impact: new API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/marker.h |   45 ++++++++++++++++++++++++++++++++++++++++-
 init/Kconfig           |    1 
 kernel/marker.c        |   53 +++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 96 insertions(+), 3 deletions(-)

Index: linux.trees.git/include/linux/marker.h
===================================================================
--- linux.trees.git.orig/include/linux/marker.h	2008-11-14 17:38:47.000000000 -0500
+++ linux.trees.git/include/linux/marker.h	2008-11-14 17:39:45.000000000 -0500
@@ -49,6 +49,8 @@ struct marker {
 	void (*call)(const struct marker *mdata, void *call_private, ...);
 	struct marker_probe_closure single;
 	struct marker_probe_closure *multi;
+	const char *tp_name;	/* Optional tracepoint name */
+	void *tp_cb;		/* Optional tracepoint callback */
 } __attribute__((aligned(8)));
 
 #ifdef CONFIG_MARKERS
@@ -73,7 +75,7 @@ struct marker {
 		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
 		0, 0, marker_probe_cb,					\
-		{ __mark_empty_function, NULL}, NULL };			\
+		{ __mark_empty_function, NULL}, NULL, NULL, NULL };	\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			(*__mark_##name.call)				\
@@ -81,11 +83,38 @@ struct marker {
 		}							\
 	} while (0)
 
+#define __trace_mark_tp(name, call_private, tp_name, tp_cb, format, args...) \
+	do {								\
+		void __check_tp_type(void)				\
+		{							\
+			register_trace_##tp_name(tp_cb);		\
+		}							\
+		static const char __mstrtab_##name[]			\
+		__attribute__((section("__markers_strings")))		\
+		= #name "\0" format;					\
+		static struct marker __mark_##name			\
+		__attribute__((section("__markers"), aligned(8))) =	\
+		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
+		0, 0, marker_probe_cb,					\
+		{ __mark_empty_function, NULL}, NULL, #tp_name, tp_cb };\
+		__mark_check_format(format, ## args);			\
+		(*__mark_##name.call)(&__mark_##name, call_private,	\
+					## args);			\
+	} while (0)
+
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
 #else /* !CONFIG_MARKERS */
 #define __trace_mark(generic, name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
+#define __trace_mark_tp(name, call_private, tp_name, tp_cb, format, args...) \
+	do {								\
+		void __check_tp_type(void)				\
+		{							\
+			register_trace_##tp_name(tp_cb);		\
+		}							\
+		__mark_check_format(format, ## args);			\
+	} while (0)
 static inline void marker_update_probe_range(struct marker *begin,
 	struct marker *end)
 { }
@@ -118,6 +147,20 @@ static inline void marker_update_probe_r
 	__trace_mark(1, name, NULL, format, ## args)
 
 /**
+ * trace_mark_tp - Marker in a tracepoint callback
+ * @name: marker name, not quoted.
+ * @tp_name: tracepoint name, not quoted.
+ * @tp_cb: tracepoint callback. Should have an associated global symbol so it
+ *         is not optimized away by the compiler (should not be static).
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker in a tracepoint callback.
+ */
+#define trace_mark_tp(name, tp_name, tp_cb, format, args...)	\
+	__trace_mark_tp(name, NULL, tp_name, tp_cb, format, ## args)
+
+/**
  * MARK_NOARGS - Format string for a marker with no argument.
  */
 #define MARK_NOARGS " "
Index: linux.trees.git/kernel/marker.c
===================================================================
--- linux.trees.git.orig/kernel/marker.c	2008-11-14 17:39:28.000000000 -0500
+++ linux.trees.git/kernel/marker.c	2008-11-14 17:39:45.000000000 -0500
@@ -479,7 +479,7 @@ static int marker_set_format(struct mark
 static int set_marker(struct marker_entry *entry, struct marker *elem,
 		int active)
 {
-	int ret;
+	int ret = 0;
 	WARN_ON(strcmp(entry->name, elem->name) != 0);
 
 	if (entry->format) {
@@ -531,9 +531,40 @@ static int set_marker(struct marker_entr
 	 */
 	smp_wmb();
 	elem->ptype = entry->ptype;
+
+	if (elem->tp_name && (active ^ elem->state)) {
+		WARN_ON(!elem->tp_cb);
+		/*
+		 * It is ok to directly call the probe registration because type
+		 * checking has been done in the __trace_mark_tp() macro.
+		 */
+
+		if (active) {
+			/*
+			 * try_module_get should always succeed because we hold
+			 * lock_module() to get the tp_cb address.
+			 */
+			ret = try_module_get(__module_text_address(
+				(unsigned long)elem->tp_cb));
+			BUG_ON(!ret);
+			ret = tracepoint_probe_register_noupdate(
+				elem->tp_name,
+				elem->tp_cb);
+		} else {
+			ret = tracepoint_probe_unregister_noupdate(
+				elem->tp_name,
+				elem->tp_cb);
+			/*
+			 * tracepoint_probe_update_all() must be called
+			 * before the module containing tp_cb is unloaded.
+			 */
+			module_put(__module_text_address(
+				(unsigned long)elem->tp_cb));
+		}
+	}
 	elem->state = active;
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -544,7 +575,24 @@ static int set_marker(struct marker_entr
  */
 static void disable_marker(struct marker *elem)
 {
+	int ret;
+
 	/* leave "call" as is. It is known statically. */
+	if (elem->tp_name && elem->state) {
+		WARN_ON(!elem->tp_cb);
+		/*
+		 * It is ok to directly call the probe registration because type
+		 * checking has been done in the __trace_mark_tp() macro.
+		 */
+		ret = tracepoint_probe_unregister_noupdate(elem->tp_name,
+			elem->tp_cb);
+		WARN_ON(ret);
+		/*
+		 * tracepoint_probe_update_all() must be called
+		 * before the module containing tp_cb is unloaded.
+		 */
+		module_put(__module_text_address((unsigned long)elem->tp_cb));
+	}
 	elem->state = 0;
 	elem->single.func = __mark_empty_function;
 	/* Update the function before setting the ptype */
@@ -608,6 +656,7 @@ static void marker_update_probes(void)
 	marker_update_probe_range(__start___markers, __stop___markers);
 	/* Markers in modules. */
 	module_update_markers();
+	tracepoint_probe_update_all();
 }
 
 /**
Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/init/Kconfig	2008-11-14 17:39:45.000000000 -0500
@@ -808,6 +808,7 @@ config TRACEPOINTS
 
 config MARKERS
 	bool "Activate markers"
+	depends on TRACEPOINTS
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
