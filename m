Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYCPIWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYCPIWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 04:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYCPIVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 04:21:55 -0400
Received: from io.site5.com ([74.53.58.9]:41953 "EHLO io.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbYCPIVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 04:21:30 -0400
X-Greylist: delayed 1877 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2008 04:21:30 EDT
Subject: [PATCH] Subject: kprobes-x86: correct post-eip value in post_hander()
From: "Yakov Lerner" <iler.ml@gmail.com>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org, iler.ml@gmail.com
Message-Id: <E1Jao7N-0005OC-Fe@io.site5.com>
Date: Sun, 16 Mar 2008 03:21:21 -0500
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - io.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [32290 32293] / [47 12]
X-AntiAbuse: Sender Address Domain - io.site5.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was trying to get the address of instruction to be executed 
next after the kprobed instruction.  But regs->eip in post_handler()
contains value which is useless to the user. It's pre-corrected value.
This value is difficult to use without access to resume_execution(), which
is not exported anyway.
I moved the invocation of post_handler() to *after* resume_execution().
Now regs->eip contains meaningful value in post_handler().

I do not think this change breaks any backward-compatibility.
To make meaning of the old value, post_handler() would need access to
resume_execution() which is not exported.  I have difficulty to believe
that previous, uncorrected, regs->eip can be meaningfully used in
post_handler().

Signed-off-by: Yakov Lerner <iler.ml@gmail.com>
---
 arch/x86/kernel/kprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 34a5912..60392e2 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -858,15 +858,15 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	if (!cur)
 		return 0;
 
+	resume_execution(cur, regs, kcb);
+	regs->flags |= kcb->kprobe_saved_flags;
+	trace_hardirqs_fixup_flags(regs->flags);
+
 	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
 		kcb->kprobe_status = KPROBE_HIT_SSDONE;
 		cur->post_handler(cur, regs, 0);
 	}
 
-	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_flags;
-	trace_hardirqs_fixup_flags(regs->flags);
-
 	/* Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
-- 
1.5.4.4

