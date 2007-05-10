Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbXEJCw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbXEJCw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXEJCwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:52:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35937 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXEJCws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:52:48 -0400
Message-Id: <20070510020917.463378427@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:56:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       <linux-arch@vger.kernel.org>
Subject: [patch 08/10] Defines the linker macro EXTRA_RWDATA for the marker data section.
Content-Disposition: inline; filename=linux-kernel-markers-define-the-linker-macro-extra_rwdata.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:52:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Defines the linker macro EXTRA_RWDATA for the marker data section.  It puts
the marker data in a separate section that will not pollute the normal .data
section, which minimize the cache impact.  Markers need such a special section
because they define a lot of spreaded and small data structures at multiple
sites.

This patch also creates the __markers_strings section (ro marker strings) and
makes sure the __markers section is aligned by putting it before the
__ksymtab_strings (not after).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-08 17:07:12.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-08 17:09:12.000000000 -0400
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
@@ -145,6 +143,10 @@
 									\
 	. = ALIGN(4096);
 
+#define EXTRA_RWDATA							\
+	. = ALIGN(8);							\
+	*(__markers_data)						\
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
@@ -241,4 +243,3 @@
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
-

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
