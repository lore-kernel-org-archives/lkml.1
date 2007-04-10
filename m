Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXDJXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXDJXWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDJXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:22:48 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:59719 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXDJXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:22:47 -0400
Date: Tue, 10 Apr 2007 19:22:45 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-powerpc-doc-section-flags
Message-ID: <20070410232245.GE7092@Krystal>
References: <20070410231126.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410231126.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:20:52 up 67 days, 13:28,  6 users,  load average: 1.11, 1.51, 1.96
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the powerpc marker header : Use the new MF_* bitmask, use the
__markers, __markers_data and __markers_strings sections, add
documentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/marker.h
+++ b/include/asm-powerpc/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_POWERPC_MARKER_H
+#define _ASM_POWERPC_MARKER_H
+
 /*
  * marker.h
  *
@@ -14,42 +17,54 @@
 
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
 					PPC_LONG "%1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 4\n\t" \
 					"0:\n\t" \
 					"li %0,0;\n\t" \
 				: "=r" (condition) \
-				: "i" (&__mark_c_##name)); \
+				: "i" (&__mark_data_##name)); \
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
-	if ((flags) & _MF_OPTIMIZED) \
+	if ((flags) & MF_OPTIMIZED) \
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
 
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
@@ -63,3 +78,4 @@ do { \
 extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
+#endif //_ASM_POWERPC_MARKER_H
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
