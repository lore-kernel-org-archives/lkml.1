Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZGGA3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZGGA3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZGGASg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:18:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917AbZGGASf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:18:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH -tip v3 4/7] kprobes: x86: Boost probes when reentering
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>
Date: Mon, 06 Jul 2009 20:21:16 -0400
Message-ID: <20090707002116.10694.41638.stgit@localhost.localdomain>
In-Reply-To: <20090707002051.10694.53741.stgit@localhost.localdomain>
References: <20090707002051.10694.53741.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup prepare_singlestep() and setup_singlestep() to boost up reenter
probes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
---

 arch/x86/kernel/kprobes.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b77e050..4e9cf46 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -411,18 +411,6 @@ static void __kprobes restore_btf(void)
 		update_debugctlmsr(current->thread.debugctlmsr);
 }
 
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	clear_btf();
-	regs->flags |= X86_EFLAGS_TF;
-	regs->flags &= ~X86_EFLAGS_IF;
-	/* single step inline if the instruction is an int3 */
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->ip = (unsigned long)p->addr;
-	else
-		regs->ip = (unsigned long)p->ainsn.insn;
-}
-
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -435,7 +423,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 }
 
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
-				       struct kprobe_ctlblk *kcb)
+				       struct kprobe_ctlblk *kcb, int reenter)
 {
 #if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
@@ -446,8 +434,21 @@ static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 		return;
 	}
 #endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
+	if (reenter) {
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p, regs, kcb);
+		kcb->kprobe_status = KPROBE_REENTER;
+	} else
+		kcb->kprobe_status = KPROBE_HIT_SS;
+	/* Prepare real single stepping */
+	clear_btf();
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+	/* single step inline if the instruction is an int3 */
+	if (p->opcode == BREAKPOINT_INSTRUCTION)
+		regs->ip = (unsigned long)p->addr;
+	else
+		regs->ip = (unsigned long)p->ainsn.insn;
 }
 
 /*
@@ -472,11 +473,8 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 		break;
 #endif
 	case KPROBE_HIT_ACTIVE:
-		save_previous_kprobe(kcb);
-		set_current_kprobe(p, regs, kcb);
 		kprobes_inc_nmissed_count(p);
-		prepare_singlestep(p, regs);
-		kcb->kprobe_status = KPROBE_REENTER;
+		setup_singlestep(p, regs, kcb, 1);
 		break;
 	case KPROBE_HIT_SS:
 		if (p == kprobe_running()) {
@@ -553,13 +551,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * more here.
 			 */
 			if (!p->pre_handler || !p->pre_handler(p, regs))
-				setup_singlestep(p, regs, kcb);
+				setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
 	} else if (kprobe_running()) {
 		p = __get_cpu_var(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
-			setup_singlestep(p, regs, kcb);
+			setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
