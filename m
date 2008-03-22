Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYCVVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYCVVE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYCVVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:03:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:63082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYCVVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=JbFzjuh9IRpoIRyFIrV6o+emDroAOk719yhQb5dpG6UifU0X+ZcMWu/J1QoMFODcbpF+VhKNO50qIZEgVdW83eJiZbQaOW4B+fURRtlJ3pJf0DxeJKcKjvcTxt9cOQCEROUjEVKwss93mMumMrP1W54JUTv4kfPmwWZxTmojsbI=
Message-Id: <20080322210311.174337634@gmail.com>
References: <20080322210005.117475478@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 23 Mar 2008 00:00:08 +0300
From: gorcunov@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [patch 3/4] x86: relocate_kernel - use predefined macroses for processor state
Content-Disposition: inline; filename=x86-cr-states
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 22:22:06.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 22:53:11.000000000 +0300
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/kexec.h>
+#include <asm/processor-flags.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
@@ -167,16 +168,16 @@ identity_mapped:
 	pushl   %edx
 
 	/* Set cr0 to a known state:
-	 * 31 0 == Paging disabled
-	 * 18 0 == Alignment check disabled
-	 * 16 0 == Write protect disabled
-	 * 3  0 == No task switch
-	 * 2  0 == Don't do FP software emulation.
-	 * 0  1 == Proctected mode enabled
+	 *  - Paging disabled
+	 *  - Alignment check disabled
+	 *  - Write protect disabled
+	 *  - No task switch
+	 *  - Don't do FP software emulation.
+	 *  - Proctected mode enabled
 	 */
 	movl	%cr0, %eax
-	andl	$~((1<<31)|(1<<18)|(1<<16)|(1<<3)|(1<<2)), %eax
-	orl	$(1<<0), %eax
+	andl	$~(X86_CR0_PG | X86_CR0_AM | X86_CR0_WP | X86_CR0_TS | X86_CR0_EM), %eax
+	orl	$(X86_CR0_PE), %eax
 	movl	%eax, %cr0
 
 	/* clear cr4 if applicable */
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 22:22:06.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 22:53:28.000000000 +0300
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/kexec.h>
+#include <asm/processor-flags.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
@@ -171,33 +172,22 @@ identity_mapped:
 	pushq   %rdx
 
 	/* Set cr0 to a known state:
-	 * 31 1 == Paging enabled
-	 * 18 0 == Alignment check disabled
-	 * 16 0 == Write protect disabled
-	 * 3  0 == No task switch
-	 * 2  0 == Don't do FP software emulation.
-	 * 0  1 == Proctected mode enabled
+	 *  - Paging enabled
+	 *  - Alignment check disabled
+	 *  - Write protect disabled
+	 *  - No task switch
+	 *  - Don't do FP software emulation.
+	 *  - Proctected mode enabled
 	 */
 	movq	%cr0, %rax
-	andq	$~((1<<18)|(1<<16)|(1<<3)|(1<<2)), %rax
-	orl	$((1<<31)|(1<<0)), %eax
+	andq	$~(X86_CR0_AM | X86_CR0_WP | X86_CR0_TS | X86_CR0_EM), %rax
+	orl	$(X86_CR0_PG | X86_CR0_PE), %eax
 	movq	%rax, %cr0
 
 	/* Set cr4 to a known state:
-	 * 10 0 == xmm exceptions disabled
-	 * 9  0 == xmm registers instructions disabled
-	 * 8  0 == performance monitoring counter disabled
-	 * 7  0 == page global disabled
-	 * 6  0 == machine check exceptions disabled
-	 * 5  1 == physical address extension enabled
-	 * 4  0 == page size extensions	disabled
-	 * 3  0 == Debug extensions disabled
-	 * 2  0 == Time stamp disable (disabled)
-	 * 1  0 == Protected mode virtual interrupts disabled
-	 * 0  0 == VME disabled
+	 *  - physical address extension enabled
 	 */
-
-	movq	$((1<<5)), %rax
+	movq	$X86_CR4_PAE, %rax
 	movq	%rax, %cr4
 
 	jmp 1f

-- 
