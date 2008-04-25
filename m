Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbYDYSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbYDYSHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764838AbYDYR5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:37 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53142 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762573AbYDYR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:22 -0400
Date: Fri, 25 Apr 2008 13:56:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 18/19] UML - use PAGE_SIZE in linker scripts
Message-ID: <20080425175617.GA11206@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch includes page.h header into liker scripts that
allow us to use PAGE_SIZE macro instead of numeric constant.

To be able to include page.h into linker scripts page.h is
needed for some modification - i.e. we need to use __ASSEMBLY__
and _AC macro

[ jdike@linux.intel.com - fixed conflict with as-layout.h ]

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/as-layout.h |   14 +++++++-------
 arch/um/kernel/dyn.lds.S    |    7 ++++---
 arch/um/kernel/uml.lds.S    |    7 ++++---
 include/asm-um/page.h       |   17 +++++++++++------
 4 files changed, 26 insertions(+), 19 deletions(-)

Index: linux-2.6-git/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/dyn.lds.S	2008-04-24 16:51:07.000000000 -0400
+++ linux-2.6-git/arch/um/kernel/dyn.lds.S	2008-04-24 17:07:28.000000000 -0400
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -21,7 +22,7 @@ SECTIONS
 	_einittext = .;
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   /* Read-only sections, merged into text segment: */
   .hash           : { *(.hash) }
@@ -68,9 +69,9 @@ SECTIONS
     /* .gnu.warning sections are handled specially by elf32.em.  */
     *(.gnu.warning)
 
-    . = ALIGN(4096);
+    . = ALIGN(PAGE_SIZE);
   } =0x90909090
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
Index: linux-2.6-git/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/uml.lds.S	2008-04-24 16:51:07.000000000 -0400
+++ linux-2.6-git/arch/um/kernel/uml.lds.S	2008-04-24 17:07:28.000000000 -0400
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -26,7 +27,7 @@ SECTIONS
 	INIT_TEXT
 	_einittext = .;
   }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   .text      :
   {
@@ -39,7 +40,7 @@ SECTIONS
     *(.gnu.linkonce.t*)
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
@@ -79,7 +80,7 @@ SECTIONS
   .sdata     : { *(.sdata) }
   _edata  =  .;
   PROVIDE (edata = .);
-  . = ALIGN(0x1000);
+  . = ALIGN(PAGE_SIZE);
   .sbss      :
   {
    __bss_start = .;
Index: linux-2.6-git/include/asm-um/page.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/page.h	2008-04-24 16:51:07.000000000 -0400
+++ linux-2.6-git/include/asm-um/page.h	2008-04-24 17:07:28.000000000 -0400
@@ -7,16 +7,20 @@
 #ifndef __UM_PAGE_H
 #define __UM_PAGE_H
 
-struct page;
-
-#include <linux/types.h>
-#include <asm/vm-flags.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#ifndef __ASSEMBLY__
+
+struct page;
+
+#include <linux/types.h>
+#include <asm/vm-flags.h>
+
 /*
  * These are used to make use of C type-checking..
  */
@@ -120,4 +124,5 @@ extern struct page *arch_validate(struct
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif
+#endif	/* __ASSEMBLY__ */
+#endif	/* __UM_PAGE_H */
Index: linux-2.6-git/arch/um/include/as-layout.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/as-layout.h	2008-04-24 16:51:07.000000000 -0400
+++ linux-2.6-git/arch/um/include/as-layout.h	2008-04-24 17:08:16.000000000 -0400
@@ -23,16 +23,16 @@
  */
 
 #ifdef __ASSEMBLY__
-#define _AC(X, Y)	(Y)
+#define _UML_AC(X, Y)	(Y)
 #else
-#define __AC(X, Y)	(X (Y))
-#define _AC(X, Y)	__AC(X, Y)
+#define __UML_AC(X, Y)	(X(Y))
+#define _UML_AC(X, Y)	__UML_AC(X, Y)
 #endif
 
-#define STUB_START _AC(, 0x100000)
-#define STUB_CODE _AC((unsigned long), STUB_START)
-#define STUB_DATA _AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
-#define STUB_END _AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
+#define STUB_START _UML_AC(, 0x100000)
+#define STUB_CODE _UML_AC((unsigned long), STUB_START)
+#define STUB_DATA _UML_AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
+#define STUB_END _UML_AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
 
 #ifndef __ASSEMBLY__
 
