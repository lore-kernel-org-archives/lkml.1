Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbXCAHMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbXCAHMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932743AbXCAHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:12:08 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:38232 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932741AbXCAHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:12:03 -0500
Date: Thu, 1 Mar 2007 02:12:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] linux-kernel-markers-powerpc-optimization-flags
Message-ID: <20070301071201.GC19339@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:08:30 up 26 days, 21:16,  7 users,  load average: 1.12, 1.36, 1.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-markers-powerpc-optimization-flags

Add flag support to powerpc optimization
Fix the .section .markers, \"a\", @progbits;\n\t inline assembly :
adding the @progbits seems to remove a warning from the linker (forces
the section to DATA, which is the same a what the MARK_GENERIC version
does).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -92,3 +92,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
--- /dev/null
+++ b/arch/powerpc/kernel/marker.c
@@ -0,0 +1,25 @@
+/* marker.c
+ *
+ * Powerpc optimized marker enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char newi[MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(MARK_OPTIMIZED_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
diff --git a/include/asm-powerpc/marker.h b/include/asm-powerpc/marker.h
index 7ff8387..eeb6ad3 100644
--- a/include/asm-powerpc/marker.h
+++ b/include/asm-powerpc/marker.h
@@ -14,16 +14,18 @@
 
 #ifdef CONFIG_MARKERS
 
-#define MARK(name, format, args...) \
+#define _MF_DEFAULT (_MF_OPTIMIZED | _MF_LOCKDEP | _MF_PRINTK)
+
+#define MARK_OPTIMIZED(flags, name, format, args...) \
 	do { \
 		static marker_probe_func *__mark_call_##name = \
 					__mark_empty_function; \
 		static const struct __mark_marker_c __mark_c_##name \
 			__attribute__((section(".markers.c"))) = \
 			{ #name, &__mark_call_##name, format, \
-			MARKER_OPTIMIZED } ; \
+			(flags) | _MF_OPTIMIZED } ; \
 		char condition; \
-		asm volatile(	".section .markers, \"a\";\n\t" \
+		asm volatile(	".section .markers, \"a\", @progbits;\n\t" \
 					PPC_LONG "%1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 4\n\t" \
@@ -39,11 +41,25 @@
 		} \
 	} while (0)
 
+#define _MARK(flags, format, args...) \
+do { \
+	if ((flags) & _MF_OPTIMIZED) \
+		MARK_OPTIMIZED(flags, format, ## args); \
+	else \
+		MARK_GENERIC(flags, format, ## args); \
+} while (0)
+
+#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
 
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
-#define MARK_ENABLE_IMMEDIATE_OFFSET 2
-#define MARK_ENABLE_TYPE short
-#define MARK_POLYMORPHIC
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define MARK_OPTIMIZED_ENABLE_TYPE short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
