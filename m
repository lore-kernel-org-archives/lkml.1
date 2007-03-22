Return-Path: <linux-kernel-owner+w=401wt.eu-S1030369AbXCVKJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbXCVKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXCVKJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:09:59 -0400
Received: from ozlabs.org ([203.10.76.45]:45010 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369AbXCVKJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:09:58 -0400
Subject: [PATCH] lguest: clean rest of linkage warnings (bar one)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: virtualization <virtualization@lists.osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1174532243.2713.95.camel@localhost.localdomain>
References: <1174532243.2713.95.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 21:09:42 +1100
Message-Id: <1174558182.2713.151.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My previous warning fix broke lguest if your text size wasn't correct
to make the __start_paravirtprobe aligned correctly.  Put the separate
paravirtprobe section back, but inside the init section so it gets
discarded.

It also fixes the remaining warnings, except one.  The code in
modpost.c which needs to be taught that it's legal to link from
.paravirtprobe to .init.text is horrible, and I'm pretty sure I'd just
make it worse.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a38b5b461807 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S	Thu Mar 22 19:28:55 2007 +1100
+++ b/arch/i386/kernel/vmlinux.lds.S	Thu Mar 22 20:12:26 2007 +1100
@@ -145,12 +145,7 @@ SECTIONS
 	*(.init.text)
 	_einittext = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	*(.init.data)
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
   . = ALIGN(16);
   .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
   	__setup_start = .;
@@ -178,6 +173,11 @@ SECTIONS
 	*(.altinstr_replacement)
   }
   . = ALIGN(4);
+  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
+ 	__start_paravirtprobe = .;
+	*(.paravirtprobe)
+  	__stop_paravirtprobe = .;
+  }
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
   	__start_parainstructions = .;
 	*(.parainstructions)
diff -r a38b5b461807 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Thu Mar 22 19:28:55 2007 +1100
+++ b/arch/i386/lguest/core.c	Thu Mar 22 20:21:21 2007 +1100
@@ -131,7 +131,7 @@ free_some_pages:
 	return err;
 }
 
-static __exit void unmap_hypervisor(void)
+static void unmap_hypervisor(void)
 {
 	unsigned int i;
 
diff -r a38b5b461807 arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h	Thu Mar 22 19:28:55 2007 +1100
+++ b/arch/i386/lguest/lg.h	Thu Mar 22 20:20:15 2007 +1100
@@ -38,7 +38,7 @@ struct lguest_regs
 	u32 ss;
 };
 
-__exit void free_pagetables(void);
+void free_pagetables(void);
 __init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
diff -r a38b5b461807 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Thu Mar 22 19:28:55 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Thu Mar 22 20:40:22 2007 +1100
@@ -550,7 +550,7 @@ static __attribute_used__ __init void lg
 	start_kernel();
 }
 
-asm(".section .init.text\n"
+asm(".pushsection .init.text,\"ax\",@progbits\n"
     "lguest_maybe_init:\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_EBP)", %ebp\n"
     "	jne 1f\n"
@@ -558,6 +558,7 @@ asm(".section .init.text\n"
     "	jne 1f\n"
     "	cmpl $"__stringify(LGUEST_MAGIC_ESI)", %esi\n"
     "	je lguest_init\n"
-    "1: ret");
+    "1: ret\n"
+    ".popsection");
 extern void asmlinkage lguest_maybe_init(void);
 paravirt_probe(lguest_maybe_init);
diff -r a38b5b461807 arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c	Thu Mar 22 19:28:55 2007 +1100
+++ b/arch/i386/lguest/page_tables.c	Thu Mar 22 20:06:03 2007 +1100
@@ -381,7 +381,7 @@ __init int init_pagetables(struct page *
 	return 0;
 }
 
-__exit void free_pagetables(void)
+void free_pagetables(void)
 {
 	free_hypervisor_pte_pages();
 }


