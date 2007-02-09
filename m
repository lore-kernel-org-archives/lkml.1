Return-Path: <linux-kernel-owner+w=401wt.eu-S1946232AbXBIJPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946232AbXBIJPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946239AbXBIJPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:15:06 -0500
Received: from ozlabs.org ([203.10.76.45]:38688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946232AbXBIJPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:15:04 -0500
Subject: [PATCH 1/10] lguest: Don't rely on last-linked fallthru when no
	paravirt handler
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171012296.2718.26.camel@localhost.localdomain>
References: <1171012296.2718.26.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 20:14:18 +1100
Message-Id: <1171012458.2718.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current code simply calls "start_kernel" directly if we're under a
hypervisor and no paravirt_ops backend wants us, because paravirt.c
registers that as a backend and it's linked last.

This was always a vain hope; start_kernel won't get far without setup.
It's also impossible for paravirt_ops backends which don't sit in the
arch/i386/kernel directory: they can't link before paravirt.o anyway.

This implements a real fallthrough if we pass all the registered
paravirt probes.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -39,8 +39,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
-
-# Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 EXTRA_AFLAGS   := -traditional
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -502,10 +502,11 @@ startup_paravirt:
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
@@ -517,6 +518,12 @@ 1:
 
 	addl	$4, (%esp)
 	jmp	1b
+
+unhandled_paravirt:
+	/* Nothing wanted us: try to die with dignity (impossible trap). */ 
+	movl	$0x1F, %edx
+	pushl	$0
+	jmp	early_fault
 #endif
 
 /*
===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -481,9 +481,6 @@ static int __init print_banner(void)
 	return 0;
 }
 core_initcall(print_banner);
-
-/* We simply declare start_kernel to be the paravirt probe of last resort. */
-paravirt_probe(start_kernel);
 
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",


