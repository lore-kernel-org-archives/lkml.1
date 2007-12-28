Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbXL1Bof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbXL1Bof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 20:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXL1Bo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 20:44:27 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:64534 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXL1Bo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 20:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j2C1H39ol55bZJYYKUrUTYBXgb9y327XzfK4DawhNzqlolQsY0cANWRim1PCOSspypB/MdhH1+YGGxA7B+GYZIsN3STMyW2wXH6Pno/YHG+SJmP769UUBEVVi1QHooN0RR6fnogLnVo5xVmVk0INmI1VQeuzotoVeTmEERCCnJU=
Subject: [PATCH] x86: kprobes change kprobe_handler flow
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 17:44:25 -0800
Message-Id: <1198806265.6323.34.camel@brick>
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

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Masami, please have a look at this, I think it's much more obvious
written this way.  The way the old code fell through or not was rather
non-obvious.  Some further work eliminating the nested returns and
creating a out: and preempt_out: target at the end of the function
would make it easier to notice preempt imbalances in later  changes.

 arch/x86/kernel/kprobes.c |   48 ++++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 4e33329..d656215 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -480,32 +480,22 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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
 				return 1;
+			goto no_kprobe;
 		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->ip = (unsigned long)addr;
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
+			set_current_kprobe(p, regs, kcb);
+			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+			if (p->pre_handler && p->pre_handler(p, regs))
+				/* handler set things up, skip ss setup */
+				return 1;
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
@@ -518,18 +508,16 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 */
 			regs->ip = (unsigned long)addr;
 			ret = 1;
+			goto no_kprobe;
+		}
+		if (kprobe_running()) {
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs))
+				goto ss_probe;
+			goto no_kprobe;
 		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
 	}
 
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
 ss_probe:
 #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
-- 
1.5.4.rc2.1097.gb6e0d



