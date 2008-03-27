Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYC0Nan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYC0Nan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYC0NaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:30:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45323 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbYC0NaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:30:20 -0400
Message-Id: <20080327133012.811514216@polymtl.ca>
References: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:20:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch for 2.6.26 1/7] Markers - define non optimized marker
Content-Disposition: inline; filename=markers-define-non-optimized-marker.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support the forthcoming "immediate values" marker optimization, we must have
a way to declare markers in few code paths that does not use instruction
modification based enable. This will be the case of printk(), some traps and
eventually lockdep instrumentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-03-27 07:52:45.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-03-27 08:10:38.000000000 -0400
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
@@ -80,7 +84,7 @@ struct marker {
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
 #else /* !CONFIG_MARKERS */
-#define __trace_mark(name, call_private, format, args...) \
+#define __trace_mark(generic, name, call_private, format, args...) \
 		__mark_check_format(format, ## args)
 static inline void marker_update_probe_range(struct marker *begin,
 	struct marker *end)
@@ -88,15 +92,30 @@ static inline void marker_update_probe_r
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
+	__trace_mark(1, name, NULL, format, ## args)
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
+	__trace_mark(0, name, NULL, format, ## args)
 
 /**
  * MARK_NOARGS - Format string for a marker with no argument.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
