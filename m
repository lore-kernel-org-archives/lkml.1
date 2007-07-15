Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbXGOXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbXGOXqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbXGOXqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:46:09 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:64171 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbXGOXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:46:08 -0400
Date: Sun, 15 Jul 2007 19:46:04 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Linux Kernel Markers - Architecture Independent Code - kerneldoc for implementation
Message-ID: <20070715234604.GL22428@Krystal>
References: <20070714012914.508504384@polymtl.ca> <20070714013050.289300592@polymtl.ca> <20070715013431.GE23209@Krystal> <20070715234350.GK22428@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715234350.GK22428@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:44:31 up 8 days, 13:49,  3 users,  load average: 0.31, 0.49, 0.48
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Architecture Independent Code - kerneldoc for implementation

Add kerneldoc to Linux Kernel Markers API.
It applies after:
"linux-kernel-markers-architecture-independent-code-remove-ifdef-kernel.patch"

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/linux/marker.h |   37 +++++++++++++---
 kernel/marker.c        |  113 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 112 insertions(+), 38 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-07-15 19:19:10.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-07-15 19:20:47.000000000 -0400
@@ -18,6 +18,15 @@
 struct module;
 struct __mark_marker;
 
+/**
+ * marker_probe_func - Type of a marker probe function
+ * @mdata: pointer of type struct __mark_marker
+ * @fmt: format string
+ * @...: variable argument list
+ *
+ * Type of marker probe functions. They receive the mdata and need to parse the
+ * format string to recover the variable argument list.
+ */
 typedef void marker_probe_func(const struct __mark_marker *mdata,
 	const char *fmt, ...);
 
@@ -86,18 +95,36 @@ extern void module_marker_update(struct 
 static inline void module_marker_update(struct module *mod) { }
 #endif /* CONFIG_MARKERS */
 
-/* Marker with default behavior */
+/**
+ * trace_mark - Marker using code patching
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker using optimized code patching technique (immediate_if ())
+ * to be enabled.
+ */
 #define trace_mark(name, format, args...) \
 	__trace_mark(0, name, format, ## args)
-/*
- * Map to the generic marker. Should be used for markers in __init and __exit
- * functions and in lockdep code.
+
+/**
+ * _trace_mark - Marker using variable read
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker using a standard memory read (_immediate_if ()) to be
+ * enabled. Should be used for markers in __init and __exit functions and in
+ * lockdep code.
  */
 #define _trace_mark(name, format, args...) \
 	__trace_mark(1, name, format, ## args)
 
 #define MARK_MAX_FORMAT_LEN	1024
-/* Pass this as a format string for a marker with no argument */
+
+/**
+ * MARK_NOARGS - Format string for a marker with no argument.
+ */
 #define MARK_NOARGS " "
 
 /* To be used for string format validity checking with gcc */
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2007-07-15 19:20:53.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2007-07-15 19:26:53.000000000 -0400
@@ -62,7 +62,12 @@ struct marker_entry {
 
 static struct hlist_head marker_table[MARKER_TABLE_SIZE];
 
-/*
+/**
+ * __mark_empty_function - Empty probe callback
+ * @mdata: pointer of type const struct __mark_marker
+ * @fmt: format string
+ * @...: variable argument list
+ *
  * Empty callback provided as a probe to the markers. By providing this to a
  * disabled marker, we makes sure the  execution flow is always valid even
  * though the function pointer change and the marker enabling are two distinct
@@ -199,7 +204,9 @@ static int _marker_set_format(struct mar
 	return 0;
 }
 
-/* Sets the probe callback corresponding to one marker. */
+/*
+ * Sets the probe callback corresponding to one marker.
+ */
 static int _set_marker(struct marker_entry **entry,
 			struct __mark_marker *elem)
 {
@@ -320,11 +327,13 @@ static inline void __marker_update_probe
 }
 
 #ifdef CONFIG_MODULES
-/*
+/**
+ * module_marker_update - Update module's markers
+ * @mod: pointer of type struct module identifying the target module
+ *
  * Setup the marker according to the data present in the marker hash table
- * upon module load. If an error occur during the set probe range,
- * refuse to load the module. Must be called with module_mutex held.
- * Since the probe_module parameter is NULL, it is safe for refcount to be NULL.
+ * upon module load. Must be called with module_mutex held.  Since the
+ * probe_module parameter is NULL, it is safe for refcount to be NULL.
  */
 void module_marker_update(struct module *mod)
 {
@@ -334,7 +343,8 @@ void module_marker_update(struct module 
 }
 
 /*
- * Update the system wide probes, with modules. */
+ * Update the system wide probes, with modules.
+ */
 static inline void _marker_update_probes(struct module *probe_module)
 {
 	mutex_lock(&module_mutex);
@@ -342,16 +352,24 @@ static inline void _marker_update_probes
 	mutex_unlock(&module_mutex);
 }
 #else
-/* Update the system wide probes, without modules. */
+/*
+ * Update the system wide probes, without modules.
+ */
 static inline void _marker_update_probes(struct module *probe_module)
 {
 	__marker_update_probes(probe_module);
 }
 #endif
 
-/*
- * Register a probe : set the callback for each marker.
- * Markers must be disarmed to be registered.
+/**
+ * marker_probe_register -  Connect a probe to a marker
+ * @name: marker name
+ * @format: format string
+ * @probe: probe handler
+ * @pdata: probe private data
+ *
+ * pdata must be a valid allocated memory address, or NULL.
+ * Returns 0 if ok, error value on error.
  */
 int marker_probe_register(const char *name, const char *format,
 			marker_probe_func *probe, void *pdata)
@@ -379,10 +397,11 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_probe_register);
 
-/*
- * Unregister a probe : unset the callback for each marker.
- * returns the pdata if ok.
- * else, returns a ERR_PTR().
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @name: marker name
+ *
+ * Returns the pdata given to marker_probe_register, or an ERR_PTR().
  */
 void *marker_probe_unregister(const char *name)
 {
@@ -408,11 +427,12 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister);
 
-/*
- * Unregister a probe by pdata : unset the callback for each marker.
- * Markers must be disarmed to be unregistered.
- * returns the pdata if ok.
- * else, returns a ERR_PTR().
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @pdata: probe private data
+ *
+ * Unregister a marker by providing the registered pdata.
+ * Returns the pdata given to marker_probe_register, or an ERR_PTR().
  */
 void *marker_probe_unregister_pdata(void *pdata)
 {
@@ -450,9 +470,13 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister_pdata);
 
-/*
- * Arm the probe : arm the immediate values.
- * A probe must have been previously registered.
+/**
+ * marker_arm - Arm a marker
+ * @name: marker name
+ *
+ * Activate a marker. It keeps a reference count of the number of
+ * arming/disarming done.
+ * Returns 0 if ok, error value on error.
  */
 int marker_arm(const char *name)
 {
@@ -477,9 +501,13 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_arm);
 
-/*
- * Disarm the probe : disarm the immediate and set the empty callback for each
- * marker.
+/**
+ * marker_disarm - Disarm a marker
+ * @name: marker name
+ *
+ * Disarm a marker. It keeps a reference count of the number of arming/disarming
+ * done.
+ * Returns 0 if ok, error value on error.
  */
 int marker_disarm(const char *name)
 {
@@ -510,6 +538,15 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_disarm);
 
+/**
+ * marker_get_pdata - Get a marker's probe private data
+ * @name: marker name
+ *
+ * Returns the pdata pointer, or an ERR_PTR.
+ * The pdata pointer should _only_ be dereferenced if the caller is the owner of
+ * the data, or its content could vanish. This is mostly used to confirm that a
+ * caller is the owner of a registered probe.
+ */
 void *marker_get_pdata(const char *name)
 {
 	struct hlist_head *head;
@@ -530,7 +567,6 @@ void *marker_get_pdata(const char *name)
 }
 EXPORT_SYMBOL_GPL(marker_get_pdata);
 
-
 /*
  * No markers are added to the core marker section, no lock needed.
  * Must be called with modules mutex held for modules markers.
@@ -609,11 +645,12 @@ static inline int marker_get_next_module
 }
 #endif
 
-/*
- * Only need to increment the module use count.
- * We allow modification of markers beneath us, since we only want to output
- * their information.
- * Returns NULL when it reaches the last marker.
+/**
+ * marker_get_next - Get next marker of an iteration
+ * @iter: previous marker
+ *
+ * Get the next marker found in the kernel. It should get its previous marker
+ * from either marker_get_first() or marker_get_next().
  */
 struct __mark_marker *marker_get_next(struct __mark_marker *cur)
 {
@@ -635,13 +672,23 @@ end:
 }
 EXPORT_SYMBOL_GPL(marker_get_next);
 
+/**
+ * marker_get_first - Get first marker to start iteration
+ *
+ * Get the first marker found in the kernel. It should have a matching
+ * marker_release.
+ */
 struct __mark_marker *marker_get_first(void)
 {
 	return marker_get_next(NULL);
 }
 EXPORT_SYMBOL_GPL(marker_get_first);
 
-/*
+/**
+ * marker_release - Release the marker iterator
+ * @iter: previous marker
+ *
+ * Release the ressources held to insure iterator validity.
  * FIXME: suboptimal
  * Gets the markers until the end, so no module refcount is held when the
  * function ends.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
