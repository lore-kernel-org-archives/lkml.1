Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYC1BE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYC1BE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYC1BEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:04:48 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:43209 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYC1BEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:04:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAKDh60dMQWoK/2dsb2JhbACBWqls
Date: Thu, 27 Mar 2008 21:04:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch for 2.6.26 1/7] Markers - define non optimized marker
	(updated)
Message-ID: <20080328010439.GB8186@Krystal>
References: <20080327132057.449831367@polymtl.ca> <200803280101.30026.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200803280101.30026.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:02:25 up 27 days, 21:13,  7 users,  load average: 0.98, 1.25,
	0.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markers - define non optimized marker

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
