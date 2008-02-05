Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYBEHvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYBEHvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYBEHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:51:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYBEHvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:51:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: make traps on 'iret' be debuggable in user space
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Corpulent devotion inversions
   (2) Stagnant carnations
   (3) Pulsing cheese eggs
   (4) Lily-livered inhibitions
   (5) Psychic snore seducers
Message-Id: <20080205075137.617012701A8@magilla.localdomain>
Date: Mon,  4 Feb 2008 23:51:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This makes the x86-64 behavior for 32-bit processes that set
bogus %cs/%ss values (the only ones that can fault in iret)
match what the native i386 behavior has been since:

	commit a879cbbb34cbecfa9707fbb6e5a00c503ac1ecb9
	Author: Linus Torvalds <torvalds@ppc970.osdl.org>
	Date:   Fri Apr 29 09:38:44 2005 -0700

	    x86: make traps on 'iret' be debuggable in user space

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 07d4aba..62744b1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -592,13 +592,26 @@ ENTRY(native_iret)
 	.quad native_iret, bad_iret
 	.previous
 	.section .fixup,"ax"
-	/* force a signal here? this matches i386 behaviour */
-	/* running with kernel gs */
 bad_iret:
-	movq $11,%rdi	/* SIGSEGV */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
-	jmp do_exit
+	/*
+	 * The iret traps when the %cs or %ss being restored is bogus.
+	 * (This can only happen in a 32-bit process, and only by invalid
+	 * selectors being set via ptrace.  Changing the value enforces
+	 * that the USER_RPL bits are set, but not that the index is valid.)
+	 * We've lost the original trap vector and error code.
+	 * #GPF is the most likely one to get for an invalid selector.
+	 * So pretend we completed the iret and took the #GPF in user mode.
+	 *
+	 * We are now running with the kernel GS after exception recovery.
+	 * But error_entry expects us to have user GS to match the user %cs,
+	 * so swap back.
+	 */
+	INTR_FRAME
+	pushq $0
+	CFI_ADJUST_CFA_OFFSET 8
+	SWAPGS
+	jmp general_protection
+	CFI_ENDPROC
 	.previous
 
 	/* edi: workmask, edx: work */
