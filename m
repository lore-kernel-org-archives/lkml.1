Return-Path: <linux-kernel-owner+w=401wt.eu-S1030886AbXAZQyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030886AbXAZQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030875AbXAZQxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:53:37 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59408 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030886AbXAZQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:53:09 -0500
Date: Fri, 26 Jan 2007 17:53:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Fix kprobes breakpoint handling.
Message-ID: <20070126165300.GS11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Fix kprobes breakpoint handling.

In case of an illegal op the die notifier gets called with DIE_TRAP
instead of DIE_BPT first.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/traps.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/traps.c linux-2.6-patched/arch/s390/kernel/traps.c
--- linux-2.6/arch/s390/kernel/traps.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/traps.c	2007-01-26 17:28:05.000000000 +0100
@@ -490,8 +490,15 @@ static void illegal_op(struct pt_regs * 
 #endif
 		} else
 			signal = SIGILL;
-	} else
-		signal = SIGILL;
+	} else {
+		/*
+		 * If we get an illegal op in kernel mode, send it through the
+		 * kprobes notifier. If kprobes doesn't pick it up, SIGILL
+		 */
+		if (notify_die(DIE_BPT, "bpt", regs, interruption_code,
+			       3, SIGTRAP) != NOTIFY_STOP)
+			signal = SIGILL;
+	}
 
 #ifdef CONFIG_MATHEMU
         if (signal == SIGFPE)
