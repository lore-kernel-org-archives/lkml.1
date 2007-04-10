Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXDJWhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXDJWhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030651AbXDJWhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:37:03 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:45256 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030650AbXDJWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:37:00 -0400
Date: Tue, 10 Apr 2007 18:36:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-generic
Message-ID: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:27:58 up 67 days, 12:35,  5 users,  load average: 1.36, 1.43, 1.54
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Defines the linker marcro EXTRA_RWDATA for marker data section. It
puts the marker data in a separate section that will not pollute the
normal .data section, which minimize the cache impact. Markers need such
a special section because they define a lot of spreaded and small data
structures at multiple sites.

This patch also creates the __markers_strings section (ro marker
strings) and makes sure the __markers section is aligned by putting it
before the __ksymtab_strings (not after).

It applies on 2.6.21-rc6-mm1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -116,21 +116,19 @@
 		*(__kcrctab_gpl_future)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
-									\
-	/* Kernel symbol table: strings */				\
-        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
-	}								\
 	/* Kernel markers : pointers */					\
-	.markers : AT(ADDR(.markers) - LOAD_OFFSET) {			\
+	__markers : AT(ADDR(__markers) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___markers) = .;			\
-		*(.markers)						\
+		*(__markers)						\
 		VMLINUX_SYMBOL(__stop___markers) = .;			\
 	}								\
-	.markers.c : AT(ADDR(.markers.c) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___markers_c) = .;		\
-		*(.markers.c)						\
-		VMLINUX_SYMBOL(__stop___markers_c) = .;			\
+	/* Kernel symbol table: strings */				\
+        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
+		*(__ksymtab_strings)					\
+	}								\
+	/* Kernel markers : strings */					\
+	__markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
+		*(__markers_strings)					\
 	}								\
 	__end_rodata = .;						\
 	. = ALIGN(4096);						\
@@ -147,6 +145,10 @@
 									\
 	. = ALIGN(4096);
 
+#define EXTRA_RWDATA							\
+	. = ALIGN(8);							\
+	*(__markers_data)						\
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
@@ -263,4 +265,3 @@
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
-
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
