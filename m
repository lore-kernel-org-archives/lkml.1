Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbYALJVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbYALJVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbYALJVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:21:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:25070 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148AbYALJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=uTwPxcP8YVGEQTAmZ42Y2opERgDeQDYMkXbj64CDJpx06wL8QtQS4quSjwyhsWUTbJPyI4CRxF/YWFQLALAVDDPSSEu3eQwGK08Ow6kW/dE4AHAAVWV8Y78+UVzdim5FTRc0nALJiBdDS7HJIY+MuFydlb3/sT1iw8FqQJkmYIk=
Message-ID: <47888685.7050002@gmail.com>
Date: Sat, 12 Jan 2008 14:51:09 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: [PATCH] x86: Fix singlestep handling in reenter_kprobe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Highlight peculiar cases in singles-step kprobe handling. 

In reenter_kprobe(), a breakpoint in KPROBE_HIT_SS case can only occur when single-stepping a breakpoint on which a probe was installed. Since such probes are single-stepped inline, identifying these cases is unambiguous. All other cases leading up to KPROBE_HIT_SS are possible bugs. Identify and WARN_ON such cases.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 93aff49..afb5c96 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -443,17 +443,6 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
-static void __kprobes recursive_singlestep(struct kprobe *p,
-					   struct pt_regs *regs,
-					   struct kprobe_ctlblk *kcb)
-{
-	save_previous_kprobe(kcb);
-	set_current_kprobe(p, regs, kcb);
-	kprobes_inc_nmissed_count(p);
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_REENTER;
-}
-
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb)
 {
@@ -492,20 +481,29 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 		break;
 #endif
 	case KPROBE_HIT_ACTIVE:
-		recursive_singlestep(p, regs, kcb);
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p, regs, kcb);
+		kprobes_inc_nmissed_count(p);
+		prepare_singlestep(p, regs);
+		kcb->kprobe_status = KPROBE_REENTER;
 		break;
 	case KPROBE_HIT_SS:
-		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+		if (p == kprobe_running()) {
 			regs->flags &= ~TF_MASK;
 			regs->flags |= kcb->kprobe_saved_flags;
 			return 0;
 		} else {
-			recursive_singlestep(p, regs, kcb);
+			/* A probe has been hit in the codepath leading up
+			 * to, or just after, single-stepping of a probed
+			 * instruction. This entire codepath should strictly
+			 * reside in .kprobes.text section. Raise a warning
+			 * to highlight this peculiar case.
+			 */
 		}
-		break;
 	default:
 		/* impossible cases */
 		WARN_ON(1);
+		return 0;
 	}
 
 	return 1;
