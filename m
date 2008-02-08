Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbYBHVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbYBHVuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYBHVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:49:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:58400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBHVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=J1hl37CTPfyfcXSkNGjIv0ddYWSTBanQzk6OCtIoANYem8+aKSIBkzcGdGMj25dwNb39i73VGaMWfC5JGJfNfb6Gi3XxniiKG5mq4IPD3Hsx79LhWCZ8glsNLFdwRxEuil/MG98KW0kFxbr9ZjZuZINex9chqaVfkO4a8pCIc/Q=
Date: Sat, 9 Feb 2008 00:49:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 cleanup: suspend_asm_64.S - use X86_CR4_PGE instead of
	numeric value
Message-ID: <20080208214913.GB6787@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By including <asm/processor-flags.h> we're allowed to use
X86_CR4_PGE instead of numeric constant.

md5 sums of compiled files are differ due to this inclusion
but .text section remains the same.

---

If anyone has an objection on this patch - just drop it please.

I'm not sure but this could have a side effect in case of future
<asm/processor-flags.h> modifications so it would require
__ASSEMBLY__ preprocessor directive.

Index: linux-2.6.git/arch/x86/kernel/suspend_asm_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/suspend_asm_64.S	2008-02-09 00:28:45.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/suspend_asm_64.S	2008-02-09 00:28:48.000000000 +0300
@@ -9,12 +9,13 @@
  * image could very well be data page in "new" image, and overwriting
  * your own stack under you is bad idea.
  */
-	
+
 	.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
 
 ENTRY(swsusp_arch_suspend)
 	movq	$saved_context, %rax
@@ -55,7 +56,7 @@ ENTRY(restore_image)
 	/* Flush TLB */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx	# PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3;
@@ -107,7 +108,7 @@ ENTRY(restore_registers)
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx;  # PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3
