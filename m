Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXKMSna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXKMSna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbXKMSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52222 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXKMSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:04 -0500
Message-Id: <20071113184247.877632200@polymtl.ca>
References: <20071113183923.190808360@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:39:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/3] Linux Kernel Markers - Fix marker mutex not taken upon module load
Content-Disposition: inline; filename=markers-fix-markers-mutex-upon-module-load.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 18:42:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Upon module load, we must take the markers mutex. It implies that the marker
mutex must be nested inside the module mutex.

It implies changing the nesting order : now the marker mutex nests inside the
module mutex. Make the necessary changes to reverse the order in which the
mutexes are taken.

Includes some cleanup from Dave Hansen <haveblue@us.ibm.com>.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 kernel/marker.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2007-11-13 10:27:22.000000000 -0500
+++ linux-2.6-lttng/kernel/marker.c	2007-11-13 13:34:19.000000000 -0500
@@ -28,7 +28,7 @@ extern struct marker __start___markers[]
 extern struct marker __stop___markers[];
 
 /*
- * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
  * and module markers, the hash table and deferred_sync.
  */
 static DEFINE_MUTEX(markers_mutex);
@@ -257,7 +257,6 @@ static void disable_marker(struct marker
  * @refcount: number of references left to the given probe_module (out)
  *
  * Updates the probe callback corresponding to a range of markers.
- * Must be called with markers_mutex held.
  */
 void marker_update_probe_range(struct marker *begin,
 	struct marker *end, struct module *probe_module,
@@ -266,6 +265,7 @@ void marker_update_probe_range(struct ma
 	struct marker *iter;
 	struct marker_entry *mark_entry;
 
+	mutex_lock(&markers_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_marker(iter->name);
 		if (mark_entry && mark_entry->refcount) {
@@ -281,6 +281,7 @@ void marker_update_probe_range(struct ma
 			disable_marker(iter);
 		}
 	}
+	mutex_unlock(&markers_mutex);
 }
 
 /*
@@ -293,7 +294,6 @@ static void marker_update_probes(struct 
 {
 	int refcount = 0;
 
-	mutex_lock(&markers_mutex);
 	/* Core kernel markers */
 	marker_update_probe_range(__start___markers,
 			__stop___markers, probe_module, &refcount);
@@ -303,7 +303,6 @@ static void marker_update_probes(struct 
 		synchronize_sched();
 		deferred_sync = 0;
 	}
-	mutex_unlock(&markers_mutex);
 }
 
 /**
@@ -320,7 +319,7 @@ int marker_probe_register(const char *na
 			marker_probe_func *probe, void *private)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -335,11 +334,11 @@ int marker_probe_register(const char *na
 	ret = add_marker(name, format, probe, private);
 	if (ret)
 		goto end;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(NULL);
+	return ret;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_probe_register);
@@ -355,7 +354,6 @@ void *marker_probe_unregister(const char
 	struct module *probe_module;
 	struct marker_entry *entry;
 	void *private;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -368,11 +366,11 @@ void *marker_probe_unregister(const char
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(name);
 	deferred_sync = 1;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(probe_module);
+	return private;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister);
@@ -392,7 +390,6 @@ void *marker_probe_unregister_private_da
 	struct marker_entry *entry;
 	int found = 0;
 	unsigned int i;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
@@ -414,11 +411,11 @@ iter_end:
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(entry->name);
 	deferred_sync = 1;
-	need_update = 1;
+	mutex_unlock(&markers_mutex);
+	marker_update_probes(probe_module);
+	return private;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
@@ -434,7 +431,7 @@ EXPORT_SYMBOL_GPL(marker_probe_unregiste
 int marker_arm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -447,11 +444,9 @@ int marker_arm(const char *name)
 	 */
 	if (entry->refcount++)
 		goto end;
-	need_update = 1;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
+	marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_arm);
@@ -467,7 +462,7 @@ EXPORT_SYMBOL_GPL(marker_arm);
 int marker_disarm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -486,11 +481,9 @@ int marker_disarm(const char *name)
 		ret = -EPERM;
 		goto end;
 	}
-	need_update = 1;
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
+	marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_disarm);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
