Return-Path: <linux-kernel-owner+w=401wt.eu-S965612AbXA3QyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612AbXA3QyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965614AbXA3QyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:54:00 -0500
Received: from [198.99.130.12] ([198.99.130.12]:57602 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965612AbXA3Qx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:53:59 -0500
Message-Id: <200701301646.l0UGkXd6005828@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org, stable@vger.kernel.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] UML - Fix signal frame alignment
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 30 Jan 2007 11:46:32 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is both 2.6.20 and -stable material.

Use the same signal frame alignment calculations as the underlying
architecture.  x86_64 appeared to do this, but the "- 8" was really
subtracting 8 * sizeof(struct rt_sigframe) rather than 8 bytes.

UML/i386 might have been OK, but I changed the calculation to match
i386 just to be sure.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/sys-i386/signal.c   |    3 ++-
 arch/um/sys-x86_64/signal.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.18-mm/arch/um/sys-x86_64/signal.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-x86_64/signal.c	2007-01-29 14:20:57.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-x86_64/signal.c	2007-01-30 11:46:38.000000000 -0500
@@ -191,8 +191,9 @@ int setup_signal_stack_si(unsigned long 
 	struct task_struct *me = current;
 
 	frame = (struct rt_sigframe __user *)
-		round_down(stack_top - sizeof(struct rt_sigframe), 16) - 8;
-        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128);
+		round_down(stack_top - sizeof(struct rt_sigframe), 16);
+	/* Subtract 128 for a red zone and 8 for proper alignment */
+        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
 
 	if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 		goto out;
Index: linux-2.6.18-mm/arch/um/sys-i386/signal.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-i386/signal.c	2007-01-17 06:02:52.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-i386/signal.c	2007-01-30 11:39:10.000000000 -0500
@@ -219,7 +219,8 @@ int setup_signal_stack_sc(unsigned long 
 	unsigned long save_sp = PT_REGS_SP(regs);
 	int err = 0;
 
-	stack_top &= -8UL;
+	/* This is the same calculation as i386 - ((sp + 4) & 15) == 0 */
+	stack_top = ((stack_top + 4) & -16UL) - 4;
 	frame = (struct sigframe __user *) stack_top - 1;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return 1;

