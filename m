Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbXEDL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbXEDL5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXEDL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:57:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36225 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXEDL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:57:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
Date: Fri, 04 May 2007 05:56:05 -0600
Message-ID: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.

Entering the kernel at startup_32 without passing our real mode data
in %esi, and without guaranteeing that physical and virtual addresses
are identity mapped makes head.S impossible to maintain.

The only user of this infrastructure is lguest which is not merged so
nothing we currently support will break by removing this over designed
nightmare, and only the pending lguest patches will be affected. The
pending Xen patches have a different entry point that they use.

We are currently discussing what Xen and lguest need to do to boot the
kernel in a more normal fashion so using startup_32 in this weird
manner is clearly not their long term direction.

So let's remove this code in head.S before it causes brain damage to
people trying to maintain head.S

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@osdl.org>
CC: H. Peter Anvin <hpa@zytor.com> 
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/head.S        |   38 --------------------------------------
 arch/i386/kernel/paravirt.c    |    1 -
 arch/i386/kernel/vmlinux.lds.S |    6 ------
 include/asm-i386/paravirt.h    |    5 -----
 4 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 3fa7f93..9a8c7f0 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -56,12 +56,6 @@
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
 
-#ifdef CONFIG_PARAVIRT
-        movl %cs, %eax
-        testl $0x3, %eax
-        jnz startup_paravirt
-#endif
-
 /*
  * Set segments to known values.
  */
@@ -503,38 +497,6 @@ ignore_int:
 	iret
 
 .section .text
-#ifdef CONFIG_PARAVIRT
-startup_paravirt:
-	cld
- 	movl $(init_thread_union+THREAD_SIZE),%esp
-
-	/* We take pains to preserve all the regs. */
-	pushl	%edx
-	pushl	%ecx
-	pushl	%eax
-
-	pushl	$__start_paravirtprobe
-1:
-	movl	0(%esp), %eax
-	cmpl	$__stop_paravirtprobe, %eax
-	je	unhandled_paravirt
-	pushl	(%eax)
-	movl	8(%esp), %eax
-	call	*(%esp)
-	popl	%eax
-
-	movl	4(%esp), %eax
-	movl	8(%esp), %ecx
-	movl	12(%esp), %edx
-
-	addl	$4, (%esp)
-	jmp	1b
-
-unhandled_paravirt:
-	/* Nothing wanted us: we're screwed. */
-	ud2
-#endif
-
 /*
  * Real beginning of normal "text" segment
  */
diff --git a/arch/i386/kernel/paravirt.c b/arch/i386/kernel/paravirt.c
index 2ec331e..fe9e4dc 100644
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/efi.h>
 #include <linux/bcd.h>
-#include <linux/start_kernel.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index 6f38f81..28c5477 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -79,12 +79,6 @@ SECTIONS
 	CONSTRUCTORS
 	} :data
 
-  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
-
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index e63f1e4..ce61030 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -160,11 +160,6 @@ struct paravirt_ops
 	void (*startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
-/* Mark a paravirt probe function. */
-#define paravirt_probe(fn)						\
- static asmlinkage void (*__paravirtprobe_##fn)(void) __attribute_used__ \
-		__attribute__((__section__(".paravirtprobe"))) = fn
-
 extern struct paravirt_ops paravirt_ops;
 
 #define paravirt_enabled() (paravirt_ops.paravirt_enabled)
-- 
1.5.1.1.181.g2de0

