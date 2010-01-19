Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498Ab0ASWWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0ASWWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863Ab0ASWWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:22:21 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:49517 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0ASWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:22:20 -0500
Date: Tue, 19 Jan 2010 16:21:12 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [x86] Unify semaphore_32.S and rwlock_64.S
Message-ID: <alpine.DEB.2.00.1001191616280.28622@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Lameter <cl@linux-foundation.org>
Subject: [x86] Unify semaphore_32.S and rwlock_64.S

Both implement semaphore handling and the code for __read_lock_failed()
and __write_lock_failed() look eearily similar aside from the use of
different registers.

Create a new arch/x86/lib/semaphore.S out of the two files.

This is also a good preparatory patch for getting the rwsem XADD stuff
to work on x86_64.

x86_64 gains the FRAME/ENDFRAME handling that i386 has (not sure what the
point is of having that there).

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/lib/Makefile       |    5 -
 arch/x86/lib/rwlock_64.S    |   38 -----------
 arch/x86/lib/semaphore.S    |  146 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/semaphore_32.S |  136 ----------------------------------------
 4 files changed, 149 insertions(+), 176 deletions(-)

Index: linux-2.6/arch/x86/lib/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/lib/Makefile	2010-01-19 14:35:40.000000000 -0600
+++ linux-2.6/arch/x86/lib/Makefile	2010-01-19 14:36:29.000000000 -0600
@@ -21,6 +21,7 @@ lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_KPROBES) += insn.o inat.o
+lib-y += semaphore.o

 obj-y += msr.o msr-reg.o msr-reg-export.o

@@ -28,7 +29,7 @@ ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o
+        lib-y += string_32.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o
 endif
@@ -38,5 +39,5 @@ else
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
-        lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+        lib-y += copy_user_64.o copy_user_nocache_64.o
 endif
Index: linux-2.6/arch/x86/lib/rwlock_64.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/rwlock_64.S	2010-01-19 14:35:40.000000000 -0600
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,38 +0,0 @@
-/* Slow paths of read/write spinlocks. */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/dwarf2.h>
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	addl $RW_LOCK_BIAS,(%rdi)
-1:	rep
-	nop
-	cmpl $RW_LOCK_BIAS,(%rdi)
-	jne 1b
-	LOCK_PREFIX
-	subl $RW_LOCK_BIAS,(%rdi)
-	jnz  __write_lock_failed
-	ret
-	CFI_ENDPROC
-END(__write_lock_failed)
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	incl (%rdi)
-1:	rep
-	nop
-	cmpl $1,(%rdi)
-	js 1b
-	LOCK_PREFIX
-	decl (%rdi)
-	js __read_lock_failed
-	ret
-	CFI_ENDPROC
-END(__read_lock_failed)
Index: linux-2.6/arch/x86/lib/semaphore.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/lib/semaphore.S	2010-01-19 14:43:40.000000000 -0600
@@ -0,0 +1,146 @@
+/*
+ * i386/x86_64 semaphore implementation.
+ *
+ * (C) Copyright 1999 Linus Torvalds
+ *
+ * Portions Copyright 1999 Red Hat, Inc.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
+ * 32 and 64 bit versions merged Jan 2010 by Christoph Lameter
+ */
+
+#include <linux/linkage.h>
+#include <asm/rwlock.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+#ifdef CONFIG_64BIT
+#define SEMPOINTER %rdi
+#else
+#define SEMPOINTER %eax
+#endif
+
+/*
+ * The semaphore operations have a special calling sequence that
+ * allow us to do a simpler in-line version of them. These routines
+ * need to convert that sequence back into the C sequence when
+ * there is contention on the semaphore.
+ *
+ * The register SEMPOINTER contains the semaphore pointer on entry. Save the
+ * C-clobbered registers except SEMPOINTER which is either a return value or
+ * just clobbered..
+ */
+	.section .sched.text, "ax"
+
+/*
+ * rw spinlock fallbacks
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_64BIT)
+ENTRY(__write_lock_failed)
+#ifdef CONFIG_64BIT
+	CFI_STARTPROC
+#else
+	CFI_STARTPROC simple
+#endif
+	FRAME
+2: 	LOCK_PREFIX
+	addl	$ RW_LOCK_BIAS,(SEMPOINTER)
+1:	rep; nop
+	cmpl	$ RW_LOCK_BIAS,(SEMPOINTER)
+	jne	1b
+	LOCK_PREFIX
+	subl	$ RW_LOCK_BIAS,(SEMPOINTER)
+	jnz	2b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+ENDPROC(__write_lock_failed)
+
+ENTRY(__read_lock_failed)
+	CFI_STARTPROC
+	FRAME
+2: 	LOCK_PREFIX
+	incl	(SEMPOINTER)
+1:	rep; nop
+	cmpl	$1,(SEMPOINTER)
+	js	1b
+	LOCK_PREFIX
+	decl	(SEMPOINTER)
+	js	2b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+ENDPROC(__read_lock_failed)
+#endif
+
+#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_down_read_failed)
+	CFI_STARTPROC
+	push %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx,0
+	push %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edx,0
+	call rwsem_down_read_failed
+	pop %edx
+	CFI_ADJUST_CFA_OFFSET -4
+	pop %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	ret
+	CFI_ENDPROC
+	ENDPROC(call_rwsem_down_read_failed)
+
+ENTRY(call_rwsem_down_write_failed)
+	CFI_STARTPROC
+	push %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx,0
+	calll rwsem_down_write_failed
+	pop %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	ret
+	CFI_ENDPROC
+	ENDPROC(call_rwsem_down_write_failed)
+
+ENTRY(call_rwsem_wake)
+	CFI_STARTPROC
+	decw %dx    /* do nothing if still outstanding active readers */
+	jnz 1f
+	push %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx,0
+	call rwsem_wake
+	pop %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+1:	ret
+	CFI_ENDPROC
+	ENDPROC(call_rwsem_wake)
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_downgrade_wake)
+	CFI_STARTPROC
+	push %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx,0
+	push %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edx,0
+	call rwsem_downgrade_wake
+	pop %edx
+	CFI_ADJUST_CFA_OFFSET -4
+	pop %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	ret
+	CFI_ENDPROC
+	ENDPROC(call_rwsem_downgrade_wake)
+
+#endif
Index: linux-2.6/arch/x86/lib/semaphore_32.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/semaphore_32.S	2010-01-19 14:35:40.000000000 -0600
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,136 +0,0 @@
-/*
- * i386 semaphore implementation.
- *
- * (C) Copyright 1999 Linus Torvalds
- *
- * Portions Copyright 1999 Red Hat, Inc.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
- */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
-/*
- * The semaphore operations have a special calling sequence that
- * allow us to do a simpler in-line version of them. These routines
- * need to convert that sequence back into the C sequence when
- * there is contention on the semaphore.
- *
- * %eax contains the semaphore pointer on entry. Save the C-clobbered
- * registers (%eax, %edx and %ecx) except %eax whish is either a return
- * value or just clobbered..
- */
-	.section .sched.text, "ax"
-
-/*
- * rw spinlock fallbacks
- */
-#ifdef CONFIG_SMP
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
-	FRAME
-2: 	LOCK_PREFIX
-	addl	$ RW_LOCK_BIAS,(%eax)
-1:	rep; nop
-	cmpl	$ RW_LOCK_BIAS,(%eax)
-	jne	1b
-	LOCK_PREFIX
-	subl	$ RW_LOCK_BIAS,(%eax)
-	jnz	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__write_lock_failed)
-
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	FRAME
-2: 	LOCK_PREFIX
-	incl	(%eax)
-1:	rep; nop
-	cmpl	$1,(%eax)
-	js	1b
-	LOCK_PREFIX
-	decl	(%eax)
-	js	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__read_lock_failed)
-
-#endif
-
-#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_down_read_failed)
-	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	call rwsem_down_read_failed
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_read_failed)
-
-ENTRY(call_rwsem_down_write_failed)
-	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	calll rwsem_down_write_failed
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_write_failed)
-
-ENTRY(call_rwsem_wake)
-	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	call rwsem_wake
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-1:	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_wake)
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_downgrade_wake)
-	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	call rwsem_downgrade_wake
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_downgrade_wake)
-
-#endif
