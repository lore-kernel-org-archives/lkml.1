Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbZINUWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbZINUWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbZINUWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:22:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54020 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbZINUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 13/72] Blackfin: sanitize manual control of IPEND[4]
Date: Mon, 14 Sep 2009 16:07:17 -0400
Message-Id: <1252958896-25150-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Cleanup is performed in two ways:

- remove extraneous updates of IPEND[4] w/ CONFIG_IPIPE,
  and document remaining use.

- substitute pop-reg-from-stack instructions with plain SP fixups in
  all save-RETI-then-discard patterns.

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/entry.S |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 919f7ae..2c58b60 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -708,8 +708,14 @@ ENTRY(_system_call)
 #ifdef CONFIG_IPIPE
 	cc = BITTST(r7, TIF_IRQ_SYNC);
 	if !cc jump .Lsyscall_no_irqsync;
+	/*
+	 * Clear IPEND[4] manually to undo what resume_userspace_1 just did;
+	 * we need this so that high priority domain interrupts may still
+	 * preempt the current domain while the pipeline log is being played
+	 * back.
+	 */
 	[--sp] = reti;
-	r0 = [sp++];
+	SP += 4; /* don't merge with next insn to keep the pattern obvious */
 	SP += -12;
 	call ___ipipe_sync_root;
 	SP += 12;
@@ -721,7 +727,7 @@ ENTRY(_system_call)
 
 	/* Reenable interrupts.  */
 	[--sp] = reti;
-	r0 = [sp++];
+	sp += 4;
 
 	SP += -12;
 	call _schedule;
@@ -737,7 +743,7 @@ ENTRY(_system_call)
 .Lsyscall_do_signals:
 	/* Reenable interrupts.  */
 	[--sp] = reti;
-	r0 = [sp++];
+	sp += 4;
 
 	r0 = sp;
 	SP += -12;
@@ -747,10 +753,6 @@ ENTRY(_system_call)
 .Lsyscall_really_exit:
 	r5 = [sp + PT_RESERVED];
 	rets = r5;
-#ifdef CONFIG_IPIPE
-	[--sp] = reti;
-	r5 = [sp++];
-#endif /* CONFIG_IPIPE */
 	rts;
 ENDPROC(_system_call)
 
@@ -904,14 +906,9 @@ ENDPROC(_ret_from_exception)
 
 #ifdef CONFIG_IPIPE
 
-_sync_root_irqs:
-	[--sp] = reti;		/* Reenable interrupts */
-	r0 = [sp++];
-	jump.l ___ipipe_sync_root
-
 _resume_kernel_from_int:
-	r0.l = _sync_root_irqs
-	r0.h = _sync_root_irqs
+	r0.l = ___ipipe_sync_root;
+	r0.h = ___ipipe_sync_root;
 	[--sp] = rets;
 	[--sp] = ( r7:4, p5:3 );
 	SP += -12;
-- 
1.6.4.2

