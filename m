Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZASAxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZASAxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZASAwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:52:34 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:41242 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbZASAwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:52:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HW32i4BblUugdwK49ci1e3JzFxARo2jYRZw0LCnTTrV8f58S/3xBSOKdafxCx81Pdi
         g5hwmGwewWQEX9Fr4G8wThcFMhoHbya/vWGiAkGNvpHTITEwvKOmKYJq989dJrgT+MIG
         mUD/TBPJHdjTvPAQXbPml+Wk6EbGw5uaglJws=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 3/5] x86-64: Rework __per_cpu_load adjustments
Date: Sun, 18 Jan 2009 19:52:23 -0500
Message-Id: <1232326345-3534-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232326345-3534-2-git-send-email-brgerst@gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu_number to determine if the adjustment is necessary.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/head_64.S |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index c8ace88..98ea26a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -207,19 +207,15 @@ ENTRY(secondary_startup_64)
 
 #ifdef CONFIG_SMP
 	/*
-	 * early_gdt_base should point to the gdt_page in static percpu init
-	 * data area.  Computing this requires two symbols - __per_cpu_load
-	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
-	 * it by hand.  As early_gdt_descr is manipulated by C code for
-	 * secondary CPUs, this should be done only once for the boot CPU
-	 * when early_gdt_descr_base contains zero.
+	 * Fix up static pointers that need __per_cpu_load added.  The assembler
+	 * is unable to do this directly.  This is only needed for the boot cpu.
+	 * These values are set up with the correct base addresses by C code for
+	 * secondary cpus.
 	 */
-	movq	early_gdt_descr_base(%rip), %rax
-	testq	%rax, %rax
-	jnz	1f
-	movq	$__per_cpu_load, %rax
-	addq	$per_cpu__gdt_page, %rax
-	movq	%rax, early_gdt_descr_base(%rip)
+	movq	initial_gs(%rip), %rax
+	cmpl	$0, per_cpu__cpu_number(%rax)
+	jne	1f
+	addq	%rax, early_gdt_descr_base(%rip)
 1:
 #endif
 	/*
@@ -431,12 +427,8 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-#ifdef CONFIG_SMP
 early_gdt_descr_base:
-	.quad   0x0000000000000000
-#else
 	.quad	per_cpu__gdt_page
-#endif
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
-- 
1.6.1.rc1

