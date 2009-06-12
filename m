Return-Path: <linux-kernel-owner+w=401wt.eu-S1764538AbZFLQ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764538AbZFLQ1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764771AbZFLQZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39065 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764562AbZFLQY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 07/27] Blackfin: fix trap_c() exit paths
Date: Fri, 12 Jun 2009 12:24:25 -0400
Message-Id: <1244823885-22410-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trap_c() code pushes the hardware trace status onto the stack, but
doesn't always restore it when returning from some trap code paths.  So
unify the exit code paths to all head to the end of the function.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 2405f19..ed7127b 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -309,7 +309,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a breakpoint in kernel space */
 		if (fp->ipend & 0xffc0)
-			return;
+			goto traps_done;
 		else
 			break;
 	/* 0x03 - User Defined, userspace stack overflow */
@@ -325,7 +325,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		info.si_code = TRAP_ILLTRAP;
 		sig = SIGTRAP;
 		CHK_DEBUGGER_TRAP();
-		return;
+		goto traps_done;
 #endif
 	/* 0x04 - User Defined */
 	/* 0x05 - User Defined */
@@ -355,7 +355,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a single step in kernel space */
 		if (fp->ipend & 0xffc0)
-			return;
+			goto traps_done;
 		else
 			break;
 	/* 0x11 - Trace Buffer Full, handled here */
@@ -459,7 +459,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a watchpoint in kernel space */
 		if (fp->ipend & 0xffc0)
-			return;
+			goto traps_done;
 		else
 			break;
 #ifdef CONFIG_BF535
@@ -624,8 +624,8 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	if (ANOMALY_05000461 && trapnr == VEC_HWERR && !access_ok(VERIFY_READ, fp->pc, 8))
 		fp->pc = SAFE_USER_INSTRUCTION;
 
+ traps_done:
 	trace_buffer_restore(j);
-	return;
 }
 
 /* Typical exception handling routines	*/
-- 
1.6.3.1

