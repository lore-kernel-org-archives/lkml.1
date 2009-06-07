Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZFGQ1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZFGQ1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZFGQ06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:26:58 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64372 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZFGQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dGM8eZCJhYombX1rfAwQEU2dxBU9CZPJj/fHF9sURkfhBXkgbILIBMcJLhtsmdqxgt
         6ALDTlPA2iuKqTddWkN1foG8VNh2M2PkMCDbPrOMJx5AHU1/bpq+KTSAv6ld7X3mrrzu
         +0/slqwFT9zyPVK6QSrn6weqmFnE3U/PmEIiI=
From: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] kmemcheck: move hook before preempt_conditional_sti()
Date: Sun,  7 Jun 2009 18:26:52 +0200
Message-Id: <1244392012-638-1-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are actually two problems here:

1. We absolutely cannot enable IRQs in case the fault was caused by
   kmemcheck.

2. We cannot enable preemption and then return from the debug handler
   without disabling preemption afterwards.

The problem seems to be a merge fallout between three commits:

commit 3d2a71a596bd9c761c8487a2178e95f8a61da083
Author: Alexander van Heukelum <heukelum@fastmail.fm>
Date:   Tue Sep 30 18:41:37 2008 +0200

    x86, traps: converge do_debug handlers

commit 08d68323d1f0c34452e614263b212ca556dae47f
Author: K.Prasad <prasad@linux.vnet.ibm.com>
Date:   Mon Jun 1 23:44:08 2009 +0530

    hw-breakpoints: modifying generic debug exception to use thread-specific deb

commit 787ecfaa503dc63ff1831ddc74b15dad49bace1d
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Fri Apr 4 00:53:23 2008 +0200

    x86: add hooks for kmemcheck

I encourage the kprobe developers to check whether their code is correct
as it stands in current tip/master. Also, comments on this particular
change is welcome.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/traps.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c8a7f87..a898c6b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -550,6 +550,10 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		return;
 
+	/* Catch kmemcheck conditions first of all! */
+	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
+		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
 
@@ -559,10 +563,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		return;
 	}
 
-	/* Catch kmemcheck conditions first of all! */
-	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
-
 	/*
 	 * Single-stepping through system calls: ignore any exceptions in
 	 * kernel space, but re-enable TF when returning to user mode.
-- 
1.6.0.6

