Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXCVC5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXCVC5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965625AbXCVC5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:57:39 -0400
Received: from ozlabs.org ([203.10.76.45]:45827 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbXCVC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:57:38 -0400
Subject: [PATCH] lguest: clean up some l"references .init.text" warnings
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: virtualization <virtualization@lists.osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 13:57:23 +1100
Message-Id: <1174532243.2713.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Andrew for pointing these out.

This patch moves the parvirtprobe section into .init.data: it's only
used in very very early boot, and for similar reasons, puts
lguest_maybe_init and lguest_memory_setup in init.text.

As well as fixing some warnings, this frees up a tiny bit more memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r ecec388180b2 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S	Mon Mar 19 14:58:08 2007 +1100
+++ b/arch/i386/kernel/vmlinux.lds.S	Tue Mar 20 12:10:39 2007 +1100
@@ -81,12 +81,6 @@ SECTIONS
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
@@ -151,7 +145,12 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+	*(.init.data)
+  	__start_paravirtprobe = .;
+	*(.paravirtprobe)
+  	__stop_paravirtprobe = .;
+  }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
diff -r ecec388180b2 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Mon Mar 19 14:58:08 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Tue Mar 20 11:34:07 2007 +1100
@@ -136,7 +136,7 @@ static struct notifier_block paniced = {
 	.notifier_call = lguest_panic
 };
 
-static char *lguest_memory_setup(void)
+static __init char *lguest_memory_setup(void)
 {
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
@@ -549,7 +549,8 @@ static __attribute_used__ __init void lg
 	start_kernel();
 }
 
-asm("lguest_maybe_init:\n"
+asm(".section .init.text\n"
+    "lguest_maybe_init:\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EDI)", %edi\n"


