Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbXKYWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbXKYWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbXKYWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:09:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbXKYWI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:08:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 26/27] x86: debugctlmsr kprobes
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220854.CA77726F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:08:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adjusts the x86 kprobes implementation to cope with per-thread
MSR_IA32_DEBUGCTLMSR being set for user mode.  I haven't delved deep
enough into the kprobes code to be really sure this covers all the
cases where the user-mode BTF setting needs to be cleared or restored.
It looks about right to me.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/kprobes_32.c |   15 +++++++++++++++
 arch/x86/kernel/kprobes_64.c |   15 +++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index d87a523..f151f06 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -217,8 +217,21 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_eflags &= ~IF_MASK;
 }
 
+static __always_inline void clear_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
+}
+
+static __always_inline void restore_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
+}
+
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
+	clear_btf();
 	regs->eflags |= TF_MASK;
 	regs->eflags &= ~IF_MASK;
 	/*single step inline if the instruction is an int3*/
@@ -542,6 +555,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 	regs->eip = orig_eip + (regs->eip - copy_eip);
 
 no_change:
+	restore_btf();
+
 	return;
 }
 
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 3db3611..d3be418 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -256,8 +256,21 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_rflags &= ~IF_MASK;
 }
 
+static __always_inline void clear_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+}
+
+static __always_inline void restore_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
+}
+
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
+	clear_btf();
 	regs->eflags |= TF_MASK;
 	regs->eflags &= ~IF_MASK;
 	/*single step inline if the instruction is an int3*/
@@ -534,6 +547,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 	} else {
 		regs->rip = orig_rip + (regs->rip - copy_rip);
 	}
+
+	restore_btf();
 }
 
 int __kprobes post_kprobe_handler(struct pt_regs *regs)
