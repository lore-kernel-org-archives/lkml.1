Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXI3OA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXI3OA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXI3OAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:00:19 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:39067 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbXI3OAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:00:17 -0400
Date: Sun, 30 Sep 2007 10:00:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Linux Kernel Markers - Coding Style Fixes
Message-ID: <20070930140013.GB16981@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.299956378@polymtl.ca> <1191116135.26950.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1191116135.26950.54.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:56:29 up 62 days, 14:15,  1 user,  load average: 1.25, 1.33, 1.15
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Coding Style Fixes

- Use struct marker instead of struct __mark_marker.
- Change a "private_data" parameter name for "private".
- DEFINE_MUTEX(markers_mutex) is made static.

This patch applies after linux-kernel-markers.patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/marker.h |   18 +++++++++---------
 include/linux/module.h |    2 +-
 kernel/marker.c        |   22 ++++++++++------------
 3 files changed, 20 insertions(+), 22 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-09-30 09:33:48.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-09-30 09:35:13.000000000 -0400
@@ -15,11 +15,11 @@
 #include <linux/types.h>
 
 struct module;
-struct __mark_marker;
+struct marker;
 
 /**
  * marker_probe_func - Type of a marker probe function
- * @mdata: pointer of type struct __mark_marker
+ * @mdata: pointer of type struct marker
  * @private_data: caller site private data
  * @fmt: format string
  * @...: variable argument list
@@ -27,10 +27,10 @@ struct __mark_marker;
  * Type of marker probe functions. They receive the mdata and need to parse the
  * format string to recover the variable argument list.
  */
-typedef void marker_probe_func(const struct __mark_marker *mdata,
+typedef void marker_probe_func(const struct marker *mdata,
 	void *private_data, const char *fmt, ...);
 
-struct __mark_marker {
+struct marker {
 	const char *name;	/* Marker name */
 	const char *format;	/* Marker format string, describing the
 				 * variable argument list.
@@ -57,7 +57,7 @@ struct __mark_marker {
 		static const char __mstrtab_format_##name[]		\
 		__attribute__((section("__markers_strings")))		\
 		= format;						\
-		static struct __mark_marker __mark_##name		\
+		static struct marker __mark_##name			\
 		__attribute__((section("__markers"))) =			\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
@@ -72,13 +72,13 @@ struct __mark_marker {
 		}							\
 	} while (0)
 
-extern void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module, int *refcount);
+extern void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount);
 #else /* !CONFIG_MARKERS */
 #define __trace_mark(name, call_data, format, args...) \
 		__mark_check_format(format, ## args)
-static inline void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module, int *refcount)
+static inline void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module, int *refcount)
 { }
 #endif /* CONFIG_MARKERS */
 
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-09-30 09:35:26.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-09-30 09:35:35.000000000 -0400
@@ -372,7 +372,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_MARKERS
-	struct __mark_marker *markers;
+	struct marker *markers;
 	unsigned int num_markers;
 #endif
 };
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2007-09-30 09:35:48.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2007-09-30 09:44:14.000000000 -0400
@@ -24,14 +24,14 @@
 #include <linux/marker.h>
 #include <linux/err.h>
 
-extern struct __mark_marker __start___markers[];
-extern struct __mark_marker __stop___markers[];
+extern struct marker __start___markers[];
+extern struct marker __stop___markers[];
 
 /*
  * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
  * and module markers, the hash table and deferred_sync.
  */
-DEFINE_MUTEX(markers_mutex);
+static DEFINE_MUTEX(markers_mutex);
 
 /*
  * Marker deferred synchronization.
@@ -63,7 +63,7 @@ static struct hlist_head marker_table[MA
 
 /**
  * __mark_empty_function - Empty probe callback
- * @mdata: pointer of type const struct __mark_marker
+ * @mdata: pointer of type const struct marker
  * @fmt: format string
  * @...: variable argument list
  *
@@ -72,8 +72,7 @@ static struct hlist_head marker_table[MA
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-void __mark_empty_function(const struct __mark_marker *mdata,
-	void *private_data,
+void __mark_empty_function(const struct marker *mdata, void *private,
 	const char *fmt, ...)
 {
 }
@@ -207,8 +206,7 @@ static int marker_set_format(struct mark
 /*
  * Sets the probe callback corresponding to one marker.
  */
-static int set_marker(struct marker_entry **entry,
-			struct __mark_marker *elem)
+static int set_marker(struct marker_entry **entry, struct marker *elem)
 {
 	int ret;
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
@@ -240,7 +238,7 @@ static int set_marker(struct marker_entr
  * empty function insures that the original callback is not used anymore. This
  * insured by preemption disabling around the call site.
  */
-static void disable_marker(struct __mark_marker *elem)
+static void disable_marker(struct marker *elem)
 {
 	elem->state = 0;
 	elem->call = __mark_empty_function;
@@ -261,11 +259,11 @@ static void disable_marker(struct __mark
  * Updates the probe callback corresponding to a range of markers.
  * Must be called with markers_mutex held.
  */
-void marker_update_probe_range(struct __mark_marker *begin,
-	struct __mark_marker *end, struct module *probe_module,
+void marker_update_probe_range(struct marker *begin,
+	struct marker *end, struct module *probe_module,
 	int *refcount)
 {
-	struct __mark_marker *iter;
+	struct marker *iter;
 	struct marker_entry *mark_entry;
 
 	for (iter = begin; iter < end; iter++) {
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
