Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZFCFWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZFCFWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZFCFWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:22:31 -0400
Received: from ozlabs.org ([203.10.76.45]:33022 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZFCFWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:22:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lguest: fix 'unhandled trap 13' with CONFIG_CC_STACKPROTECTOR
Date: Wed, 3 Jun 2009 14:52:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: lguest <lguest@ozlabs.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031452.25589.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't set up the canary; let's disable stack protector on boot.c so
we can get into lguest_init, then set it up.  As a side effect,
switch_to_new_gdt() sets up %fs for us properly too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/lguest/Makefile |    1 +
 arch/x86/lguest/boot.c   |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lguest/Makefile b/arch/x86/lguest/Makefile
--- a/arch/x86/lguest/Makefile
+++ b/arch/x86/lguest/Makefile
@@ -1,1 +1,2 @@
 obj-y		:= i386_head.o boot.o
+CFLAGS_boot.o	:= $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -67,6 +67,7 @@
 #include <asm/mce.h>
 #include <asm/io.h>
 #include <asm/i387.h>
+#include <asm/stackprotector.h>
 #include <asm/reboot.h>		/* for struct machine_ops */
 
 /*G:010 Welcome to the Guest!
@@ -1088,13 +1089,21 @@ __init void lguest_init(void)
 	 * lguest_init() where the rest of the fairly chaotic boot setup
 	 * occurs. */
 
+	/* The stack protector is a weird thing where gcc places a canary
+	 * value on the stack and then checks it on return.  This file is
+	 * compiled with -fno-stack-protector it, so we got this far without
+	 * problems.  The value of the canary is kept at offset 20 from the
+	 * %gs register, so we need to set that up before calling C functions
+	 * in other files. */
+	setup_stack_canary_segment(0);
+	/* We could just call load_stack_canary_segment(), but we might as
+	 * call switch_to_new_gdt() which loads the whole table and sets up
+	 * the per-cpu segment descriptor register %fs as well. */
+	switch_to_new_gdt(0);
+
 	/* As described in head_32.S, we map the first 128M of memory. */
 	max_pfn_mapped = (128*1024*1024) >> PAGE_SHIFT;
 
-	/* Load the %fs segment register (the per-cpu segment register) with
-	 * the normal data segment to get through booting. */
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
-
 	/* The Host<->Guest Switcher lives at the top of our address space, and
 	 * the Host told us how big it is when we made LGUEST_INIT hypercall:
 	 * it put the answer in lguest_data.reserve_mem  */

