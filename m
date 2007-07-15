Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbXGOBlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbXGOBlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbXGOBk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:40:59 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:54904 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760534AbXGOBk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:40:58 -0400
Date: Sat, 14 Jul 2007 21:40:56 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Linux Kernel Markers -  Architecture Independent Code - kerneldoc
Message-ID: <20070715014056.GI23209@Krystal>
References: <20070714012914.508504384@polymtl.ca> <20070714013050.289300592@polymtl.ca> <20070715013431.GE23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013431.GE23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:40:11 up 7 days, 15:45,  2 users,  load average: 0.47, 0.25, 0.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Architecture Independent Code - kerneldoc

Add kerneldoc to Linux Kernel Markers API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/linux/marker.h |  108 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 99 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-07-14 20:58:16.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-07-14 21:16:01.000000000 -0400
@@ -20,6 +20,15 @@
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
 
@@ -88,18 +97,36 @@ extern void module_marker_update(struct 
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
@@ -109,27 +136,90 @@ static inline void __mark_check_format(c
 
 extern marker_probe_func __mark_empty_function;
 
-/*
- * Connect a probe to a markers.
+/**
+ * marker_probe_register -  Connect a probe to a marker
+ * @name: marker name
+ * @format: format string
+ * @probe: probe handler
+ * @pdata: probe private data
+ *
  * pdata must be a valid allocated memory address, or NULL.
+ * Returns 0 if ok, error value on error.
  */
 extern int marker_probe_register(const char *name, const char *format,
 				marker_probe_func *probe, void *pdata);
 
-/*
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @name: marker name
+ *
  * Returns the pdata given to marker_probe_register.
  */
 extern void *marker_probe_unregister(const char *name);
-/*
+
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @pdata: probe private data
+ *
  * Unregister a marker by providing the registered pdata.
+ * Returns the pdata given to marker_probe_register.
  */
 extern void *marker_probe_unregister_pdata(void *pdata);
 
+/**
+ * marker_arm - Arm a marker
+ * @name: marker name
+ *
+ * Activate a marker. It keeps a reference count of the number of
+ * arming/disarming done.
+ * Returns 0 if ok, error value on error.
+ */
 extern int marker_arm(const char *name);
+
+/**
+ * marker_disarm - Disarm a marker
+ * @name: marker name
+ *
+ * Disarm a marker. It keeps a reference count of the number of arming/disarming
+ * done.
+ * Returns 0 if ok, error value on error.
+ */
 extern int marker_disarm(const char *name);
+
+/**
+ * marker_get_first - Get first marker to start iteration
+ *
+ * Get the first marker found in the kernel. It should have a matching
+ * marker_release.
+ */
 extern struct __mark_marker *marker_get_first(void);
+
+/**
+ * marker_get_next - Get next marker of an iteration
+ * @iter: previous marker
+ *
+ * Get the next marker found in the kernel. It should get its previous marker
+ * from either marker_get_first() or marker_get_next().
+ */
 extern struct __mark_marker *marker_get_next(struct __mark_marker *iter);
+
+/**
+ * marker_release - Release the marker iterator
+ * @iter: previous marker
+ *
+ * Release the ressources held to insure iterator validity.
+ */
 extern void marker_release(struct __mark_marker *iter);
+
+/**
+ * marker_get_pdata - Get a marker's probe private data
+ * @name: marker name
+ *
+ * Returns the pdata pointer, or an ERR_PTR.
+ * The pdata pointer should _only_ be dereferenced if the caller is the owner of
+ * the data, or its content could vanish. This is mostly used to confirm that a
+ * caller is the owner of a registered probe.
+ */
 extern void *marker_get_pdata(const char *name);
 
 #endif /* __KERNEL__ */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
