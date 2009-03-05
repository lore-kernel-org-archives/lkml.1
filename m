Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbZCEX2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbZCEX2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbZCEX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:27:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33675 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632AbZCEX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:27:23 -0500
Message-Id: <20090305225516.181324063@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:48 -0500
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
Subject: [RFC patch 20/41] Linux Kernel Markers - Iterator
Content-Disposition: inline; filename=linux-kernel-markers-iterator.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add marker iterators. Useful for /proc interface (listing markers).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |   12 ++++++++
 include/linux/module.h |    6 ++++
 kernel/marker.c        |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/module.c        |   32 ++++++++++++++++++++++
 4 files changed, 120 insertions(+)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2009-03-05 15:21:58.000000000 -0500
+++ linux-2.6-lttng/kernel/marker.c	2009-03-05 15:45:38.000000000 -0500
@@ -898,6 +898,76 @@ EXPORT_SYMBOL_GPL(marker_get_private_dat
 
 #ifdef CONFIG_MODULES
 
+/**
+ * marker_get_iter_range - Get a next marker iterator given a range.
+ * @marker: current markers (in), next marker (out)
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Returns whether a next marker has been found (1) or not (0).
+ * Will return the first marker in the range if the input marker is NULL.
+ */
+int marker_get_iter_range(struct marker **marker, struct marker *begin,
+	struct marker *end)
+{
+	if (!*marker && begin != end) {
+		*marker = begin;
+		return 1;
+	}
+	if (*marker >= begin && *marker < end)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_get_iter_range);
+
+static void marker_get_iter(struct marker_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel markers */
+	if (!iter->module) {
+		found = marker_get_iter_range(&iter->marker,
+				__start___markers, __stop___markers);
+		if (found)
+			goto end;
+	}
+	/* Markers in modules. */
+	found = module_get_iter_markers(iter);
+end:
+	if (!found)
+		marker_iter_reset(iter);
+}
+
+void marker_iter_start(struct marker_iter *iter)
+{
+	marker_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(marker_iter_start);
+
+void marker_iter_next(struct marker_iter *iter)
+{
+	iter->marker++;
+	/*
+	 * iter->marker may be invalid because we blindly incremented it.
+	 * Make sure it is valid by marshalling on the markers, getting the
+	 * markers from following modules if necessary.
+	 */
+	marker_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(marker_iter_next);
+
+void marker_iter_stop(struct marker_iter *iter)
+{
+}
+EXPORT_SYMBOL_GPL(marker_iter_stop);
+
+void marker_iter_reset(struct marker_iter *iter)
+{
+	iter->module = NULL;
+	iter->marker = NULL;
+}
+EXPORT_SYMBOL_GPL(marker_iter_reset);
+
 int marker_module_notify(struct notifier_block *self,
 			 unsigned long val, void *data)
 {
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2009-03-05 15:45:37.000000000 -0500
+++ linux-2.6-lttng/kernel/module.c	2009-03-05 15:45:38.000000000 -0500
@@ -2814,6 +2814,38 @@ void module_update_markers(void)
 				mod->markers + mod->num_markers);
 	mutex_unlock(&module_mutex);
 }
+
+/*
+ * Returns 0 if current not found.
+ * Returns 1 if current found.
+ */
+int module_get_iter_markers(struct marker_iter *iter)
+{
+	struct module *iter_mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		if (!iter_mod->taints) {
+			/*
+			 * Sorted module list
+			 */
+			if (iter_mod < iter->module)
+				continue;
+			else if (iter_mod > iter->module)
+				iter->marker = NULL;
+			found = marker_get_iter_range(&iter->marker,
+				iter_mod->markers,
+				iter_mod->markers + iter_mod->num_markers);
+			if (found) {
+				iter->module = iter_mod;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2009-03-05 15:21:58.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2009-03-05 15:45:38.000000000 -0500
@@ -218,4 +218,16 @@ extern void *marker_get_private_data(con
  */
 #define marker_synchronize_unregister() synchronize_sched()
 
+struct marker_iter {
+	struct module *module;
+	struct marker *marker;
+};
+
+extern void marker_iter_start(struct marker_iter *iter);
+extern void marker_iter_next(struct marker_iter *iter);
+extern void marker_iter_stop(struct marker_iter *iter);
+extern void marker_iter_reset(struct marker_iter *iter);
+extern int marker_get_iter_range(struct marker **marker, struct marker *begin,
+	struct marker *end);
+
 #endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2009-03-05 15:21:58.000000000 -0500
+++ linux-2.6-lttng/include/linux/module.h	2009-03-05 15:45:38.000000000 -0500
@@ -472,6 +472,7 @@ int unregister_module_notifier(struct no
 extern void print_modules(void);
 
 extern void module_update_markers(void);
+extern int module_get_iter_markers(struct marker_iter *iter);
 
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
@@ -589,6 +590,11 @@ static inline int module_get_iter_tracep
 	return 0;
 }
 
+static inline int module_get_iter_markers(struct marker_iter *iter)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
