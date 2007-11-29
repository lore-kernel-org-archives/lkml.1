Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbXK2Aml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbXK2Aml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbXK2Ama
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:42:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbXK2Am3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:42:29 -0500
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
Subject: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
In-Reply-To: Roland McGrath's message of  Wednesday, 28 November 2007 16:38:49 -0800 <20071129003849.428E026F8E7@magilla.localdomain>
References: <20071129003849.428E026F8E7@magilla.localdomain>
X-Shopping-List: (1) Resurgent religious prescriptions
   (2) Emphatic checks
   (3) Constant selector brunch
   (4) Ferocious perversions
   (5) Spontaneous perspiration
Message-Id: <20071129004222.E49AD26F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:42:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This generalizes the getreg32 and putreg32 functions so they can be used on
the current task, as well as on a task stopped in TASK_TRACED and switched
off.  This lays the groundwork to share this code for all kinds of
user-mode machine state access, not just ptrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index c52d066..d5663e2 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -48,19 +48,27 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 		if (val && (val & 3) != 3)
 			return -EIO;
 		child->thread.fsindex = val & 0xffff;
+		if (child == current)
+			loadsegment(fs, child->thread.fsindex);
 		break;
 	case offsetof(struct user32, regs.gs):
 		if (val && (val & 3) != 3)
 			return -EIO;
 		child->thread.gsindex = val & 0xffff;
+		if (child == current)
+			load_gs_index(child->thread.gsindex);
 		break;
 	case offsetof(struct user32, regs.ds):
 		if (val && (val & 3) != 3)
 			return -EIO;
 		child->thread.ds = val & 0xffff;
+		if (child == current)
+			loadsegment(ds, child->thread.ds);
 		break;
 	case offsetof(struct user32, regs.es):
 		child->thread.es = val & 0xffff;
+		if (child == current)
+			loadsegment(es, child->thread.ds);
 		break;
 	case offsetof(struct user32, regs.ss):
 		if ((val & 3) != 3)
@@ -129,15 +137,23 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 	switch (regno) {
 	case offsetof(struct user32, regs.fs):
 		*val = child->thread.fsindex;
+		if (child == current)
+			asm("movl %%fs,%0" : "=r" (*val));
 		break;
 	case offsetof(struct user32, regs.gs):
 		*val = child->thread.gsindex;
+		if (child == current)
+			asm("movl %%gs,%0" : "=r" (*val));
 		break;
 	case offsetof(struct user32, regs.ds):
 		*val = child->thread.ds;
+		if (child == current)
+			asm("movl %%ds,%0" : "=r" (*val));
 		break;
 	case offsetof(struct user32, regs.es):
 		*val = child->thread.es;
+		if (child == current)
+			asm("movl %%es,%0" : "=r" (*val));
 		break;
 
 	R32(cs, cs);
