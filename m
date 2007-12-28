Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXL1CIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXL1CIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 21:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXL1CIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 21:08:23 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:36281 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXL1CIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 21:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XsqqHJ+VMASecmmRNaYMW3/N5trmRNLR9MdYFdGN1vAOCjtZhzA7SRWIBm7QVTHlJrE/5J2RmLsNQ5EGSNdOZD3mkppvXBXmzGTwIxggpCbtyPZ+RIvecJY1ED1S4XQ4hq4VoUCBYIFDkSv+jh7K/naJ4t0paQab5xtfby01xqk=
Subject: [PATCH] x86: kprobes change kprobe_handler flow
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 18:08:22 -0800
Message-Id: <1198807702.6323.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the control flow of kprobe_handler more obvious.

Collapse the separate if blocks/gotos with if/else blocks
this unifies the duplication of the check for a breakpoint
instruction race with another cpu.

Create two jump targets:
	preempt_out: re-enables preemption before returning ret
	out: only returns ret

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Masami, noticed a small bug in the previous version in the !p
case when the breakpoint was the kernel's.  Please review this
version.

 arch/x86/kernel/kprobes.c |   60 +++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 4e33329..f8c7ac1 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -480,32 +480,28 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	preempt_disable();
 	kcb = get_kprobe_ctlblk();
 
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
+	p = get_kprobe(addr);
+	if (p) {
+		/* Check we're not actually recursing */
+		if (kprobe_running()) {
 			ret = reenter_kprobe(p, regs, kcb);
 			if (kcb->kprobe_status == KPROBE_REENTER)
-				return 1;
+			{
+				ret = 1;
+				goto out;
+			}
+			goto preempt_out;
 		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->ip = (unsigned long)addr;
+			set_current_kprobe(p, regs, kcb);
+			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+			if (p->pre_handler && p->pre_handler(p, regs))
+			{
+				/* handler set things up, skip ss setup */
 				ret = 1;
-				goto no_kprobe;
+				goto out;
 			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
 		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
+	} else {
 		if (*addr != BREAKPOINT_INSTRUCTION) {
 			/*
 			 * The breakpoint instruction was removed right
@@ -518,34 +514,34 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 */
 			regs->ip = (unsigned long)addr;
 			ret = 1;
+			goto preempt_out;
+		}
+		if (kprobe_running()) {
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
 		}
 		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
+		goto preempt_out;
 	}
 
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
 ss_probe:
+	ret = 1;
 #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
 		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
-		return 1;
+		goto preempt_out;
 	}
 #endif
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
+	goto out;
 
-no_kprobe:
+preempt_out:
 	preempt_enable_no_resched();
+out:
 	return ret;
 }
 
-- 
1.5.4.rc2.1097.gb6e0d



