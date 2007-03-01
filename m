Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXCAHOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXCAHOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXCAHOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:14:00 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:38297 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932904AbXCAHN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:13:59 -0500
Date: Thu, 1 Mar 2007 02:13:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] linux-kernel-markers-i386-optimization-flags
Message-ID: <20070301071358.GD19339@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:12:07 up 26 days, 21:20,  7 users,  load average: 1.34, 1.34, 1.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-markers-i386-optimization-flags

i386 marker optimization flags support.
Also fixes the @progbits assembly section declaration.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/i386/kernel/marker.c
+++ b/arch/i386/kernel/marker.c
@@ -40,7 +40,7 @@ static int mark_notifier(struct notifier_block *nb,
 {
 	enum die_val die_val = (enum die_val) val;
 	struct die_args *args = (struct die_args *)data;
-
+	
 	if (!args->regs || user_mode_vm(args->regs))
 		return NOTIFY_DONE;
 
@@ -56,7 +56,7 @@ static struct notifier_block mark_notify = {
 	.priority = 0x7fffffff,	/* we need to be notified first */
 };
 
-int arch_marker_set_ins_enable(void *address, char enable)
+int marker_optimized_set_enable(void *address, char enable)
 {
 	char saved_byte;
 	int ret;
@@ -91,4 +91,4 @@ int arch_marker_set_ins_enable(void *address, char enable)
 	flush_icache_range(address, size);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(arch_marker_set_ins_enable);
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
--- a/include/asm-i386/marker.h
+++ b/include/asm-i386/marker.h
@@ -11,16 +11,19 @@
 
 
 #ifdef CONFIG_MARKERS
-#define MARK(name, format, args...) \
+
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
 					".long %1, 0f;\n\t" \
 					".previous;\n\t" \
 					".align 2\n\t" \
@@ -36,12 +39,25 @@
 		} \
 	} while (0)
 
+#define _MARK(flags, format, args...) \
+do { \
+	if (((flags) & _MF_LOCKDEP) && ((flags) & _MF_OPTIMIZED)) \
+		MARK_OPTIMIZED(flags, format, ## args); \
+	else \
+		MARK_GENERIC(flags, format, ## args); \
+} while (0)
+
+#define MARK(format, args...) _MARK(_MF_DEFAULT, format, ## args)
+
 /* Offset of the immediate value from the start of the movb instruction, in
  * bytes. */
-#define MARK_ENABLE_IMMEDIATE_OFFSET 1
-#define MARK_ENABLE_TYPE char
-#define MARK_POLYMORPHIC
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_OPTIMIZED_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
 
-extern int arch_marker_set_ins_enable(void *address, char enable);
+extern int marker_optimized_set_enable(void *address, char enable);
 
 #endif
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
