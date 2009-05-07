Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbZEGWbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbZEGWbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763015AbZEGW1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:36123 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756484AbZEGW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470475"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 11/14] x86, boot: use rep movsq to move kernel on 64 bits
Date: Thu,  7 May 2009 15:26:59 -0700
Message-Id: <1241735222-6640-12-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

rep movsq is the architecturally preferred way to move a block of
data.  It isn't the fastest way on all existing CPUs, but it it likely
to be in the future, and perhaps more importantly, we should encourage
the architecturally right thing to do.

This means saving and restoring %rsi around the copy code, which is
easily done by setting up the stack early.  However, we should not
copy .bss (which we are about to zero anyway); we should only copy up
to the *beginning* of .bss (just as on 32 bits.)

This also makes the code quite a bit more similar between 32 and 64 bits.

[ Impact: trivial optimization ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/head_64.S |   41 ++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2678fdf..8bc8ed8 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -220,18 +220,30 @@ ENTRY(startup_64)
 #endif
 	leaq	z_extract_offset(%rbp), %rbx
 
-/* Copy the compressed kernel to the end of our buffer
+/*
+ * Set up the stack
+ */
+	leaq boot_stack_end(%rbx), %rsp
+
+/*
+ * Zero EFLAGS after setting rsp
+ */
+	pushq	$0
+	popfq
+
+/*
+ * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-	leaq	_end_before_pgt(%rip), %r8
-	leaq	_end_before_pgt(%rbx), %r9
-	movq	$_end_before_pgt /* - $startup_32 */, %rcx
-1:	subq	$8, %r8
-	subq	$8, %r9
-	movq	0(%r8), %rax
-	movq	%rax, 0(%r9)
-	subq	$8, %rcx
-	jnz	1b
+	pushq	%rsi		/* Kernel structure pointer */
+	leaq	(_bss-8)(%rip), %rsi
+	leaq	(_bss-8)(%rbx), %rdi
+	movq	$_bss /* - $startup_32 */, %rcx
+	shrq	$3, %rcx
+	std
+	rep	movsq
+	cld
+	popq	%rsi
 
 /*
  * Jump to the relocated address.
@@ -243,7 +255,7 @@ ENTRY(startup_64)
 relocated:
 
 /*
- * Clear BSS
+ * Clear BSS (stack is empty at this point)
  */
 	xorl	%eax, %eax
 	leaq    _edata(%rip), %rdi
@@ -253,13 +265,6 @@ relocated:
 	cld
 	rep	stosq
 
-	/* Setup the stack */
-	leaq	boot_stack_end(%rip), %rsp
-
-	/* zero EFLAGS after setting rsp */
-	pushq	$0
-	popfq
-
 /*
  * Do the decompression, and jump to the new kernel..
  */
-- 
1.6.0.6

