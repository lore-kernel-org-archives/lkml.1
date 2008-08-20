Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYHTJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYHTJyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYHTJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:54:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYHTJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:54:10 -0400
Date: Wed, 20 Aug 2008 11:53:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86: Use X86_CR4_PGE in x86/power/hibernate_asm_32.S
Message-ID: <20080820095353.GB28492@elte.hu>
References: <5787cf470808200144ta2f28b4nd9b2922cbec73d78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5787cf470808200144ta2f28b4nd9b2922cbec73d78@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Uros Bizjak <ubizjak@gmail.com> wrote:

> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

applied the commit below to tip/x86/cleanups - thanks Uros.

i did a small change: i moved the .text to after the include files. 
While include files are not supposed to change section attributes, it 
looks logically more consistent to have the .text right before the code.

	Ingo

----------------->
>From c171f465b7281f2d3b03e9145ec763d6a8bab176 Mon Sep 17 00:00:00 2001
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 20 Aug 2008 10:44:47 +0200
Subject: [PATCH] x86, cleanup: use X86_CR4_PGE in x86/power/hibernate_asm_32.S

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/power/hibernate_asm_32.S |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index 4fc7e87..d1e9b53 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -1,5 +1,3 @@
-.text
-
 /*
  * This may not use any stack, nor any variable that is not "NoSave":
  *
@@ -12,17 +10,18 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
 
-	.text
+.text
 
 ENTRY(swsusp_arch_suspend)
-
 	movl %esp, saved_context_esp
 	movl %ebx, saved_context_ebx
 	movl %ebp, saved_context_ebp
 	movl %esi, saved_context_esi
 	movl %edi, saved_context_edi
-	pushfl ; popl saved_context_eflags
+	pushfl
+	popl saved_context_eflags
 
 	call swsusp_save
 	ret
@@ -59,7 +58,7 @@ done:
 	movl	mmu_cr4_features, %ecx
 	jecxz	1f	# cr4 Pentium and higher, skip if zero
 	movl	%ecx, %edx
-	andl	$~(1<<7), %edx;  # PGE
+	andl	$~(X86_CR4_PGE), %edx
 	movl	%edx, %cr4;  # turn off PGE
 1:
 	movl	%cr3, %eax;  # flush TLB
@@ -74,7 +73,8 @@ done:
 	movl saved_context_esi, %esi
 	movl saved_context_edi, %edi
 
-	pushl saved_context_eflags ; popfl
+	pushl saved_context_eflags
+	popfl
 
 	xorl	%eax, %eax
 
