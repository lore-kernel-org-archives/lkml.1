Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbXK2Aln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbXK2Aln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbXK2Al0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:41:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416AbXK2AlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:41:25 -0500
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
Subject: [PATCH x86/mm 4/6] x86-64 ptrace get/putreg current task
In-Reply-To: Roland McGrath's message of  Wednesday, 28 November 2007 16:38:49 -0800 <20071129003849.428E026F8E7@magilla.localdomain>
References: <20071129003849.428E026F8E7@magilla.localdomain>
X-Shopping-List: (1) Fictitious inhibitions
   (2) Fresh-frozen chocolate
   (3) Bucolic inquisition goats
   (4) Geopolitical dwarf ripping-cats
Message-Id: <20071129004118.D317B26F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:41:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This generalizes the getreg and putreg functions so they can be used on the
current task, as well as on a task stopped in TASK_TRACED and switched off.
This lays the groundwork to share this code for all kinds of user-mode
machine state access, not just ptrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_64.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 2427548..5979dbe 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -67,21 +67,29 @@ static int putreg(struct task_struct *child,
 		if (value && (value & 3) != 3)
 			return -EIO;
 		child->thread.fsindex = value & 0xffff;
+		if (child == current)
+			loadsegment(fs, child->thread.fsindex);
 		return 0;
 	case offsetof(struct user_regs_struct,gs):
 		if (value && (value & 3) != 3)
 			return -EIO;
 		child->thread.gsindex = value & 0xffff;
+		if (child == current)
+			load_gs_index(child->thread.gsindex);
 		return 0;
 	case offsetof(struct user_regs_struct,ds):
 		if (value && (value & 3) != 3)
 			return -EIO;
 		child->thread.ds = value & 0xffff;
+		if (child == current)
+			loadsegment(ds, child->thread.ds);
 		return 0;
 	case offsetof(struct user_regs_struct,es):
 		if (value && (value & 3) != 3)
 			return -EIO;
 		child->thread.es = value & 0xffff;
+		if (child == current)
+			loadsegment(es, child->thread.es);
 		return 0;
 	case offsetof(struct user_regs_struct,ss):
 		if ((value & 3) != 3)
@@ -135,14 +143,32 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 {
 	struct pt_regs *regs = task_pt_regs(child);
 	unsigned long val;
+	unsigned int seg;
 	switch (regno) {
 	case offsetof(struct user_regs_struct, fs):
+		if (child == current) {
+			/* Older gas can't assemble movq %?s,%r?? */
+			asm("movl %%fs,%0" : "=r" (seg));
+			return seg;
+		}
 		return child->thread.fsindex;
 	case offsetof(struct user_regs_struct, gs):
+		if (child == current) {
+			asm("movl %%gs,%0" : "=r" (seg));
+			return seg;
+		}
 		return child->thread.gsindex;
 	case offsetof(struct user_regs_struct, ds):
+		if (child == current) {
+			asm("movl %%ds,%0" : "=r" (seg));
+			return seg;
+		}
 		return child->thread.ds;
 	case offsetof(struct user_regs_struct, es):
+		if (child == current) {
+			asm("movl %%es,%0" : "=r" (seg));
+			return seg;
+		}
 		return child->thread.es;
 	case offsetof(struct user_regs_struct, fs_base):
 		/*
@@ -152,7 +178,10 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 		 */
 		if (child->thread.fs != 0)
 			return child->thread.fs;
-		if (child->thread.fsindex != FS_TLS_SEL)
+		seg = child->thread.fsindex;
+		if (child == current)
+			asm("movl %%fs,%0" : "=r" (seg));
+		if (seg != FS_TLS_SEL)
 			return 0;
 		return get_desc_base(&child->thread.tls_array[FS_TLS]);
 	case offsetof(struct user_regs_struct, gs_base):
@@ -161,7 +190,10 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 		 */
 		if (child->thread.gs != 0)
 			return child->thread.gs;
-		if (child->thread.gsindex != GS_TLS_SEL)
+		seg = child->thread.gsindex;
+		if (child == current)
+			asm("movl %%gs,%0" : "=r" (seg));
+		if (seg != GS_TLS_SEL)
 			return 0;
 		return get_desc_base(&child->thread.tls_array[GS_TLS]);
 	case offsetof(struct user_regs_struct, flags):
