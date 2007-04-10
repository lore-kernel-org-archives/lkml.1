Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXDJXUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXDJXUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXDJXUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:20:51 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:39896 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbXDJXUu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:20:50 -0400
Date: Tue, 10 Apr 2007 19:20:48 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-i386-doc-section-flags-optimized-state-change
Message-ID: <20070410232048.GD7092@Krystal>
References: <20070410231126.GC7092@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070410231126.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:17:09 up 67 days, 13:24,  6 users,  load average: 2.00, 2.00, 2.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Document the i386 marker header, change it to use the __marker,
__marker_data and __marker_strings sections. Change the flag usage to
use MF_* directly (which is now a bitmask). In marker.c, for the i386
optimized marker enabling, check the a simple test is the value will be
changed. If not, simply return : we would set it to the same value
anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-i386/marker.h
+++ b/include/asm-i386/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_I386_MARKER_H
+#define _ASM_I386_MARKER_H
+
 /*
  * marker.h
  *
@@ -12,42 +15,54 @@
 
 #ifdef CONFIG_MARKERS
 
-#define _MF_DEFAULT (_MF_OPTIMIZED | _MF_LOCKDEP | _MF_PRINTK)
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
 
+/* Optimized version of the markers */
 #define MARK_OPTIMIZED(flags, name, format, args...) \
 	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			(flags) | _MF_OPTIMIZED } ; \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
 		char condition; \
-		asm volatile(	".section .markers, \"a\", @progbits;\n\t" \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
 					".long %1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 2\n\t" \
 					"0:\n\t" \
 					"movb $0,%0;\n\t" \
 				: "=r" (condition) \
-				: "m" (__mark_c_##name)); \
+				: "m" (__mark_data_##name)); \
 		__mark_check_format(format, ## args); \
 		if (unlikely(condition)) { \
 			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
 			preempt_enable(); \
 		} \
 	} while (0)
 
+/* Marker macro selecting the generic or optimized version of marker, depending
+ * on the flags specified. */
 #define _MARK(flags, format, args...) \
 do { \
-	if (((flags) & _MF_LOCKDEP) && ((flags) & _MF_OPTIMIZED)) \
+	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
 		MARK_OPTIMIZED(flags, format, ## args); \
 	else \
 		MARK_GENERIC(flags, format, ## args); \
 } while (0)
 
-#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
+/* Marker with default behavior */
+#define MARK(format, args...) _MARK(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
 
 /* Offset of the immediate value from the start of the movb instruction, in
  * bytes. */
@@ -61,3 +76,4 @@ do { \
 extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
+#endif //_ASM_I386_MARKER_H
--- a/arch/i386/kernel/marker.c
+++ b/arch/i386/kernel/marker.c
@@ -4,7 +4,9 @@
  *
  * Permits marker activation by XMC with correct serialization.
  *
- * Reentrant for NMI and trap handler instrumentation. :-)
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
+ * location that has preemption enabled because it involves no temporary or
+ * reused data structure.
  *
  * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  */
@@ -63,8 +65,10 @@ int marker_optimized_set_enable(void *address, char enable)
 	int ret;
 	char *dest = address;
 
+	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
+		return 0;
+
 	mutex_lock(&mark_mutex);
-	BUG_ON(!(enable ^ dest[1]));	/* Must be a state change 0<->1 */
 	target_eip = (long)address + BREAKPOINT_INS_LEN;
 	/* register_die_notifier has memory barriers */
 	register_die_notifier(&mark_notify);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
