Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXDJXLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXDJXLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXDJXLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:11:30 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33022 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161053AbXDJXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:11:28 -0400
Date: Tue, 10 Apr 2007 19:11:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-generic-doc-section-fix-flags
Message-ID: <20070410231126.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:00:15 up 67 days, 13:07,  6 users,  load average: 2.02, 3.50, 2.65
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documents the linux/marker.h header. Fix a bitwise flag manipulation mistake
in the MARK_GENERIC macro.

Use the __marker (ro), new __marker_strings (ro) and __marker_data (rw)
sections. It depends on the linker modification which defines this last
section.

It allows the use of a probe "private" data : upon probe connexion, it
can provide a pointer to its own data structure which will be available
at the probe call site as the pdata field of the mdata structure.

With the new __marker_data section, much less data has to be defined in
the kernel .data segment : only the enable flag, in non-optimized
markers, is left in .data because it is used very often.

The marker flags now only define MF_* which are bitmasks. There is no
way to use the bitmask shift value, so it is less error prone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -16,48 +16,59 @@
 
 #ifdef __KERNEL__
 
-typedef void marker_probe_func(const char *fmt, ...);
+struct __mark_marker_data;
 
-struct __mark_marker_c {
+typedef void marker_probe_func(const struct __mark_marker_data *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker_data {
 	const char *name;
-	marker_probe_func **call;
 	const char *format;
 	int flags;
+	marker_probe_func *call;
+	void *pdata;
 } __attribute__((packed));
 
 struct __mark_marker {
-	const struct __mark_marker_c *cmark;
+	struct __mark_marker_data *mdata;
 	void *enable;
 } __attribute__((packed));
 
-/* Generic marker flavor always available */
 #ifdef CONFIG_MARKERS
 
-#define MF_OPTIMIZED 1	/* Use optimized markers */
-#define MF_LOCKDEP 2	/* Can call lockdep */
-#define MF_PRINTK 3	/* vprintk can be called in the probe */
+/* Marker flags : selects the mechanism used to connect the probes to the
+ * markers and what can be executed within the probes. This is primarily
+ * used at reentrancy-unfriendly sites. */
+#define MF_OPTIMIZED	(1 << 0)	/* Use optimized markers */
+#define MF_LOCKDEP	(1 << 1)	/* Can call lockdep */
+#define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
+#define _MF_NR		3		/* Number of marker flags */
 
-#define _MF_OPTIMIZED (1 << MF_OPTIMIZED)
-#define _MF_LOCKDEP (1 << MF_LOCKDEP)
-#define _MF_PRINTK (1 << MF_PRINTK)
+#define DECLARE_MARKER_DATA(flags, name, format) \
 
+/* Generic marker flavor always available */
 #define MARK_GENERIC(flags, name, format, args...) \
 	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) & ~MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		static char __marker_enable_##name = 0; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			(flags) | ~_MF_OPTIMIZED } ; \
 		static const struct __mark_marker __mark_##name \
-			__attribute__((section(".markers"))) = \
-			{ &__mark_c_##name, &__marker_enable_##name } ; \
+			__attribute__((section("__markers"))) = \
+			{ &__mark_data_##name, &__marker_enable_##name } ; \
 		asm volatile ( "" : : "i" (&__mark_##name)); \
 		__mark_check_format(format, ## args); \
 		if (unlikely(__marker_enable_##name)) { \
 			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
 			preempt_enable(); \
 		} \
 	} while (0)
@@ -87,21 +98,23 @@ static inline int marker_generic_set_enable(void *address, char enable)
 #endif
 
 #define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
 #define MARK_NOARGS " "
 
-static inline __attribute__ ((format (printf, 1, 2)))
+/* To be used for string format validity checking with sparse */
+static inline
 void __mark_check_format(const char *fmt, ...)
 { }
 
 extern marker_probe_func __mark_empty_function;
 
 extern int _marker_set_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe);
+				marker_probe_func *probe, void *pdata);
 
-#define marker_set_probe(name, format, probe) \
-	_marker_set_probe(_MF_DEFAULT, name, format, probe)
+#define marker_set_probe(name, format, probe, pdata) \
+	_marker_set_probe(MF_DEFAULT, name, format, probe, pdata)
 
-extern int marker_remove_probe(marker_probe_func *probe);
+extern int marker_remove_probe(const char *name);
 extern int marker_list_probe(marker_probe_func *probe);
 
 #endif /* __KERNEL__ */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
