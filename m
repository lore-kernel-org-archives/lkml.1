Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0BYNaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:30:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab0BYNaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:30:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3&10 05/18] kprobes/x86: Boost probes when reentering
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
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
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Date: Thu, 25 Feb 2010 08:34:23 -0500
Message-ID: <20100225133423.6725.12071.stgit@localhost6.localdomain6>
In-Reply-To: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate prepare_singlestep() into setup_singlestep() to boost up reenter
probes, if possible.

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
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
---

 arch/x86/kernel/kprobes.c |   48 ++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 15177cd..c69bb65 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -406,18 +406,6 @@ static void __kprobes restore_btf(void)
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
@@ -430,19 +418,38 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 }
 
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
-				       struct kprobe_ctlblk *kcb)
+				       struct kprobe_ctlblk *kcb, int reenter)
 {
 #if !defined(CONFIG_PREEMPT)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
+		if (!reenter)
+			reset_current_kprobe();
+		/*
+		 * Reentering boosted probe doesn't reset current_kprobe,
+		 * nor set current_kprobe, because it doesn't use single
+		 * stepping.
+		 */
 		regs->ip = (unsigned long)p->ainsn.insn;
 		preempt_enable_no_resched();
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
@@ -456,11 +463,8 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
-		save_previous_kprobe(kcb);
-		set_current_kprobe(p, regs, kcb);
 		kprobes_inc_nmissed_count(p);
-		prepare_singlestep(p, regs);
-		kcb->kprobe_status = KPROBE_REENTER;
+		setup_singlestep(p, regs, kcb, 1);
 		break;
 	case KPROBE_HIT_SS:
 		/* A probe has been hit in the codepath leading up to, or just
@@ -535,13 +539,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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
