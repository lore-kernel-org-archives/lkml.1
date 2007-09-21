Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXIUWo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXIUWo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764073AbXIUWcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:42 -0400
Received: from ns1.suse.de ([195.135.220.2]:57082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763785AbXIUWce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:34 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [33/50] x86: rename .i assembler includes to .h
Message-Id: <20070921223232.ECF9413DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


.i is an ending used for preprocessed stuff.

This patch therefore renames assembler include files to .h and guards 
the contents with an #ifdef __ASSEMBLY__.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/lib/semaphore.S            |    4 ++--
 arch/x86_64/lib/rwlock.S             |    2 +-
 include/asm-i386/alternative-asm.h   |   16 ++++++++++++++++
 include/asm-i386/alternative-asm.i   |   12 ------------
 include/asm-i386/frame.h             |   27 +++++++++++++++++++++++++++
 include/asm-i386/frame.i             |   23 -----------------------
 include/asm-um/alternative-asm.h     |    6 ++++++
 include/asm-um/alternative-asm.i     |    6 ------
 include/asm-um/frame.h               |    6 ++++++
 include/asm-um/frame.i               |    6 ------
 include/asm-x86_64/alternative-asm.h |   16 ++++++++++++++++
 include/asm-x86_64/alternative-asm.i |   12 ------------
 12 files changed, 74 insertions(+), 62 deletions(-)

7b64536780b39820b13bebd144983c3c8c9ae64c 
Index: linux/arch/i386/lib/semaphore.S
===================================================================
--- linux.orig/arch/i386/lib/semaphore.S
+++ linux/arch/i386/lib/semaphore.S
@@ -15,8 +15,8 @@
 
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
-#include <asm/alternative-asm.i>
-#include <asm/frame.i>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
 #include <asm/dwarf2.h>
 
 /*
Index: linux/arch/x86_64/lib/rwlock.S
===================================================================
--- linux.orig/arch/x86_64/lib/rwlock.S
+++ linux/arch/x86_64/lib/rwlock.S
@@ -2,7 +2,7 @@
 
 #include <linux/linkage.h>
 #include <asm/rwlock.h>
-#include <asm/alternative-asm.i>
+#include <asm/alternative-asm.h>
 #include <asm/dwarf2.h>
 
 /* rdi:	pointer to rwlock_t */
Index: linux/include/asm-i386/alternative-asm.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/alternative-asm.h
@@ -0,0 +1,16 @@
+#ifdef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+	.macro LOCK_PREFIX
+1:	lock
+	.section .smp_locks,"a"
+	.align 4
+	.long 1b
+	.previous
+	.endm
+#else
+	.macro LOCK_PREFIX
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
Index: linux/include/asm-i386/alternative-asm.i
===================================================================
--- linux.orig/include/asm-i386/alternative-asm.i
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifdef CONFIG_SMP
-	.macro LOCK_PREFIX
-1:	lock
-	.section .smp_locks,"a"
-	.align 4
-	.long 1b
-	.previous
-	.endm
-#else
-	.macro LOCK_PREFIX
-	.endm
-#endif
Index: linux/include/asm-i386/frame.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/frame.h
@@ -0,0 +1,27 @@
+#ifdef __ASSEMBLY__
+
+#include <asm/dwarf2.h>
+
+/* The annotation hides the frame from the unwinder and makes it look
+   like a ordinary ebp save/restore. This avoids some special cases for
+   frame pointer later */
+#ifdef CONFIG_FRAME_POINTER
+	.macro FRAME
+	pushl %ebp
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebp,0
+	movl %esp,%ebp
+	.endm
+	.macro ENDFRAME
+	popl %ebp
+	CFI_ADJUST_CFA_OFFSET -4
+	CFI_RESTORE ebp
+	.endm
+#else
+	.macro FRAME
+	.endm
+	.macro ENDFRAME
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
Index: linux/include/asm-i386/frame.i
===================================================================
--- linux.orig/include/asm-i386/frame.i
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <asm/dwarf2.h>
-
-/* The annotation hides the frame from the unwinder and makes it look
-   like a ordinary ebp save/restore. This avoids some special cases for
-   frame pointer later */
-#ifdef CONFIG_FRAME_POINTER
-	.macro FRAME
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebp,0
-	movl %esp,%ebp
-	.endm
-	.macro ENDFRAME
-	popl %ebp
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ebp
-	.endm
-#else
-	.macro FRAME
-	.endm
-	.macro ENDFRAME
-	.endm
-#endif
Index: linux/include/asm-um/alternative-asm.h
===================================================================
--- /dev/null
+++ linux/include/asm-um/alternative-asm.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ALTERNATIVE_ASM_I
+#define __UM_ALTERNATIVE_ASM_I
+
+#include "asm/arch/alternative-asm.h"
+
+#endif
Index: linux/include/asm-um/alternative-asm.i
===================================================================
--- linux.orig/include/asm-um/alternative-asm.i
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_ALTERNATIVE_ASM_I
-#define __UM_ALTERNATIVE_ASM_I
-
-#include "asm/arch/alternative-asm.i"
-
-#endif
Index: linux/include/asm-um/frame.h
===================================================================
--- /dev/null
+++ linux/include/asm-um/frame.h
@@ -0,0 +1,6 @@
+#ifndef __UM_FRAME_I
+#define __UM_FRAME_I
+
+#include "asm/arch/frame.h"
+
+#endif
Index: linux/include/asm-um/frame.i
===================================================================
--- linux.orig/include/asm-um/frame.i
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_FRAME_I
-#define __UM_FRAME_I
-
-#include "asm/arch/frame.i"
-
-#endif
Index: linux/include/asm-x86_64/alternative-asm.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/alternative-asm.h
@@ -0,0 +1,16 @@
+#ifdef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+	.macro LOCK_PREFIX
+1:	lock
+	.section .smp_locks,"a"
+	.align 8
+	.quad 1b
+	.previous
+	.endm
+#else
+	.macro LOCK_PREFIX
+	.endm
+#endif
+
+#endif  /*  __ASSEMBLY__  */
Index: linux/include/asm-x86_64/alternative-asm.i
===================================================================
--- linux.orig/include/asm-x86_64/alternative-asm.i
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifdef CONFIG_SMP
-	.macro LOCK_PREFIX
-1:	lock
-	.section .smp_locks,"a"
-	.align 8
-	.quad 1b
-	.previous
-	.endm
-#else
-	.macro LOCK_PREFIX
-	.endm
-#endif
