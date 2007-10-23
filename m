Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbXJWEle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbXJWEle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXJWEjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:39:22 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58885 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752832AbXJWEjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:39:21 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bs4a001796@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix syscall restart handling
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix system call restart handling. We can call directly to the
restart handler, no need to back track through trap that isn't
even implemented on m68knommu.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/kernel/signal.c linux-2.6.23-uc0/arch/m68knommu/kernel/signal.c
--- linux-2.6.23/arch/m68knommu/kernel/signal.c	2007-10-19 10:30:55.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/kernel/signal.c	2007-10-19 10:35:40.000000000 +1000
@@ -781,15 +781,7 @@ asmlinkage int do_signal(sigset_t *oldse
 	/* Did we come from a system call? */
 	if (regs->orig_d0 >= 0) {
 		/* Restart the system call - no handlers present */
-		if (regs->d0 == -ERESTARTNOHAND
-		    || regs->d0 == -ERESTARTSYS
-		    || regs->d0 == -ERESTARTNOINTR) {
-			regs->d0 = regs->orig_d0;
-			regs->pc -= 2;
-		} else if (regs->d0 == -ERESTART_RESTARTBLOCK) {
-			regs->d0 = __NR_restart_syscall;
-			regs->pc -= 2;
-		}
+		handle_restart(regs, NULL, 0);
 	}
 	return 0;
 }
