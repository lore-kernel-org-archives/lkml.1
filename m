Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbYDPVis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbYDPVis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbYDPVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35043 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbYDPVgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:11 -0400
Message-Id: <20080416213554.673941594@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 19/27] Markers - define non optimized marker
Content-Disposition: inline; filename=markers-define-non-optimized-marker.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support the forthcoming "immediate values" marker optimization, we must have
a way to declare markers in few code paths that does not use instruction
modification based enable. This will be the case of printk(), some traps and
eventually lockdep instrumentation.

Changelog :
- Fix reversed boolean logic of "generic".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-03-27 20:47:44.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-03-27 20:49:04.000000000 -0400
@@ -58,8 +58,12 @@ struct marker {
  * Make sure the alignment of the structure in the __markers section will
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
+ *
+ * The "generic" argument controls which marker enabling mechanism must be used.
+ * If generic is true, a variable read is used.
+ * If generic is false, immediate values are used.
  */
-#define __trace_mark(name, call_private, format, args...)		\
+#define __trace_mark(generic, name, call_private, format, args...)	\
 	do {								\
 		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
@@ -79,7 +83,7 @@ struct marker {
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
 #else /* !CONFIG_MARKERS */
-#define __trace_mark(name, call_private, format, args...) \
+#define __trace_mark(generic, name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
 static inline void marker_update_probe_range(struct marker *begin,
 	struct marker *end)
@@ -87,15 +91,30 @@ static inline void marker_update_probe_r
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
+ * to be enabled when immediate values are present.
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
+ * enabled. Should be used for markers in code paths where instruction
+ * modification based enabling is not welcome. (__init and __exit functions,
+ * lockdep, some traps, printk).
+ */
+#define _trace_mark(name, format, args...) \
+	__trace_mark(1, name, NULL, format, ## args)
 
 /**
  * MARK_NOARGS - Format string for a marker with no argument.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
