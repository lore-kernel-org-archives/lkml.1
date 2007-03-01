Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXCAHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXCAHSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXCAHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:18:38 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:44769 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933023AbXCAHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:18:37 -0500
Date: Thu, 1 Mar 2007 02:18:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] linux-kernel-markers-non-optimized-architures-fallback-flags
Message-ID: <20070301071835.GE19339@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:16:38 up 26 days, 21:24,  7 users,  load average: 1.60, 1.53, 1.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-markers-non-optimized-architures-fallback-flags

- asm-generic/marker.h is now only used as a fallback defining _MARK as
  MARK_GENERIC.
- flags support

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-generic/marker.h
+++ b/include/asm-generic/marker.h
@@ -1,8 +1,11 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
 /*
  * marker.h
  *
  * Code markup for dynamic and static tracing. Generic header.
  *
  * This file is released under the GPLv2.
  * See the file COPYING for more details.
  *
@@ -10,31 +13,18 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#ifdef CONFIG_MARKERS
+#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
 
-#define GEN_MARK(name, format, args...) \
-	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
-		static char __marker_enable_##name = 0; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			MARKER_GENERIC } ; \
-		static const struct __mark_marker __mark_##name \
-			__attribute__((section(".markers"))) = \
-			{ &__mark_c_##name, &__marker_enable_##name } ; \
-		asm volatile ( "" : : "i" (&__mark_##name)); \
-		__mark_check_format(format, ## args); \
-		if (unlikely(__marker_enable_##name)) { \
-			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
-			preempt_enable(); \
-		} \
-	} while (0)
+#define MARK_OPTIMIZED			MARK_GENERIC
+#define _MARK				MARK_GENERIC
+#define MARK(format, args...)		_MARK(_MF_DEFAULT, format, ## args)
 
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
+		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
+#define MARK_OPTIMIZED_ENABLE_TYPE	MARK_GENERIC_ENABLE_TYPE
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE		MARK_GENERIC_ENABLE
 
-#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
-#define GEN_MARK_ENABLE_TYPE char
+#define marker_optimized_set_enable marker_generic_set_enable
 
-#endif
+#endif /* _ASM_GENERIC_MARKER_H */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
