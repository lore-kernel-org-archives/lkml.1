Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYKNXCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYKNXCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:02:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYKNXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:22 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52171 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224948.293222043@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 07/16] Markers : create DEFINE_MARKER and GET_MARKER (new API)
Content-Disposition: inline; filename=markers-define-get.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow markers to be used only for declaration, without function call associated.
Useful to create specialized probes.

The problem we had is that two function calls were required when one wanted to
put a marker in a tracepoint probe. Now the marker can be used simply for trace
data type declaration, leaving the trace write work within the tracepoint probe
without any additional function call.

Impact: new API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/markers.txt |   14 ++++++++++++++
 include/linux/marker.h    |   39 +++++++++++++++++++++++----------------
 2 files changed, 37 insertions(+), 16 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-11-14 16:59:26.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2008-11-14 16:59:28.000000000 -0500
@@ -55,6 +55,22 @@ struct marker {
 
 #ifdef CONFIG_MARKERS
 
+#define _DEFINE_MARKER(name, tp_name_str, tp_cb, format)		\
+		static const char __mstrtab_##name[]			\
+		__attribute__((section("__markers_strings")))		\
+		= #name "\0" format;					\
+		static struct marker __mark_##name			\
+		__attribute__((section("__markers"), aligned(8))) =	\
+		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
+		  0, 0, marker_probe_cb, { __mark_empty_function, NULL},\
+		  NULL, tp_name_str, tp_cb }
+
+#define DEFINE_MARKER(name, format)					\
+		_DEFINE_MARKER(name, NULL, NULL, format)
+
+#define DEFINE_MARKER_TP(name, tp_name, tp_cb, format)			\
+		_DEFINE_MARKER(name, #tp_name, tp_cb, format)
+
 /*
  * Note : the empty asm volatile with read constraint is used here instead of a
  * "used" attribute to fix a gcc 4.1.x bug.
@@ -68,14 +84,7 @@ struct marker {
  */
 #define __trace_mark(generic, name, call_private, format, args...)	\
 	do {								\
-		static const char __mstrtab_##name[]			\
-		__attribute__((section("__markers_strings")))		\
-		= #name "\0" format;					\
-		static struct marker __mark_##name			\
-		__attribute__((section("__markers"), aligned(8))) =	\
-		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
-		0, 0, marker_probe_cb,					\
-		{ __mark_empty_function, NULL}, NULL, NULL, NULL };	\
+		DEFINE_MARKER(name, format);				\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			(*__mark_##name.call)				\
@@ -89,14 +98,7 @@ struct marker {
 		{							\
 			register_trace_##tp_name(tp_cb);		\
 		}							\
-		static const char __mstrtab_##name[]			\
-		__attribute__((section("__markers_strings")))		\
-		= #name "\0" format;					\
-		static struct marker __mark_##name			\
-		__attribute__((section("__markers"), aligned(8))) =	\
-		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
-		0, 0, marker_probe_cb,					\
-		{ __mark_empty_function, NULL}, NULL, #tp_name, tp_cb };\
+		DEFINE_MARKER_TP(name, tp_name, tp_cb, format);		\
 		__mark_check_format(format, ## args);			\
 		(*__mark_##name.call)(&__mark_##name, call_private,	\
 					## args);			\
@@ -104,7 +106,11 @@ struct marker {
 
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
+
+#define GET_MARKER(name)	(__mark_##name)
+
 #else /* !CONFIG_MARKERS */
+#define DEFINE_MARKER(name, tp_name, tp_cb, format)
 #define __trace_mark(generic, name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
 #define __trace_mark_tp(name, call_private, tp_name, tp_cb, format, args...) \
@@ -118,6 +124,7 @@ extern void marker_update_probe_range(st
 static inline void marker_update_probe_range(struct marker *begin,
 	struct marker *end)
 { }
+#define GET_MARKER(name)
 #endif /* CONFIG_MARKERS */
 
 /**
Index: linux-2.6-lttng/Documentation/markers.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/markers.txt	2008-11-14 16:59:26.000000000 -0500
+++ linux-2.6-lttng/Documentation/markers.txt	2008-11-14 16:59:28.000000000 -0500
@@ -70,6 +70,20 @@ a printk warning which identifies the in
 
 "Format mismatch for probe probe_name (format), marker (format)"
 
+Another way to use markers is to simply define the marker without generating any
+function call to actually call into the marker. This is useful in combination
+with tracepoint probes in a scheme like this :
+
+void probe_tracepoint_name(unsigned int arg1, struct task_struct *tsk);
+
+DEFINE_MARKER_TP(marker_eventname, tracepoint_name, probe_tracepoint_name,
+	"arg1 %u pid %d");
+
+notrace void probe_tracepoint_name(unsigned int arg1, struct task_struct *tsk)
+{
+	struct marker *marker = &GET_MARKER(kernel_irq_entry);
+	/* write data to trace buffers ... */
+}
 
 * Probe / marker example
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
