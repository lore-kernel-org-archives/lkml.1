Return-Path: <linux-kernel-owner+w=401wt.eu-S965007AbXBLQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbXBLQyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964977AbXBLQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:53655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968AbXBLQvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:49 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [25/29] i386: paravirt unhandled fallthrough
Message-Id: <20070212165146.22BCC13E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>
The current code simply calls "start_kernel" directly if we're under a
hypervisor and no paravirt_ops backend wants us, because paravirt.c
registers that as a backend.

This was always a vain hope; start_kernel won't get far without setup.
It's also impossible for paravirt_ops backends which don't sit in the
arch/i386/kernel directory: they can't link before paravirt.o anyway.

Keep it simple: if we pass all the registered paravirt probes, BUG().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/Makefile   |    2 --
 arch/i386/kernel/head.S     |    7 ++++++-
 arch/i386/kernel/paravirt.c |    3 ---
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -41,8 +41,6 @@ obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
-
-# Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 EXTRA_AFLAGS   := -traditional
Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
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
@@ -528,6 +529,10 @@ startup_paravirt:
 
 	addl	$4, (%esp)
 	jmp	1b
+
+unhandled_paravirt:
+	/* Nothing wanted us: we're screwed. */
+	ud2
 #endif
 
 /*
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -482,9 +482,6 @@ static int __init print_banner(void)
 }
 core_initcall(print_banner);
 
-/* We simply declare start_kernel to be the paravirt probe of last resort. */
-paravirt_probe(start_kernel);
-
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
