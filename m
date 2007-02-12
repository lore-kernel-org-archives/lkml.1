Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXBLDcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXBLDcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbXBLDcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:32:47 -0500
Received: from ozlabs.org ([203.10.76.45]:50808 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXBLDcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:32:47 -0500
Subject: [PATCH 1/7] cleanup: paravirt unhandled fallthrough
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>, Andi Kleen <ak@muc.de>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:32:00 +1100
Message-Id: <1171251120.10409.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current code simply calls "start_kernel" directly if we're under a
hypervisor and no paravirt_ops backend wants us, because paravirt.c
registers that as a backend.

This was always a vain hope; start_kernel won't get far without setup.
It's also impossible for paravirt_ops backends which don't sit in the
arch/i386/kernel directory: they can't link before paravirt.o anyway.

Keep it simple: if we pass all the registered paravirt probes, BUG().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 4fb7fc327801 arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile	Mon Feb 12 12:37:01 2007 +1100
+++ b/arch/i386/kernel/Makefile	Mon Feb 12 12:55:00 2007 +1100
@@ -41,8 +41,6 @@ obj-$(CONFIG_KWATCH)		+= debugreg.o kwat
 obj-$(CONFIG_KWATCH)		+= debugreg.o kwatch.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
-
-# Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 EXTRA_AFLAGS   := -traditional
diff -r 4fb7fc327801 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Mon Feb 12 12:37:01 2007 +1100
+++ b/arch/i386/kernel/head.S	Mon Feb 12 12:54:19 2007 +1100
@@ -513,10 +513,11 @@ startup_paravirt:
 	pushl	%ecx
 	pushl	%eax
 
-	/* paravirt.o is last in link, and that probe fn never returns */
 	pushl	$__start_paravirtprobe
 1:
 	movl	0(%esp), %eax
+	cmpl	$__stop_paravirtprobe, %eax
+	je	unhandled_paravirt
 	pushl	(%eax)
 	movl	8(%esp), %eax
 	call	*(%esp)
@@ -528,6 +529,10 @@ 1:
 
 	addl	$4, (%esp)
 	jmp	1b
+
+unhandled_paravirt:
+	/* Nothing wanted us: we're screwed. */ 
+	ud2
 #endif
 
 /*
diff -r 4fb7fc327801 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Mon Feb 12 12:37:01 2007 +1100
+++ b/arch/i386/kernel/paravirt.c	Mon Feb 12 12:54:19 2007 +1100
@@ -481,9 +481,6 @@ static int __init print_banner(void)
 	return 0;
 }
 core_initcall(print_banner);
-
-/* We simply declare start_kernel to be the paravirt probe of last resort. */
-paravirt_probe(start_kernel);
 
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",


