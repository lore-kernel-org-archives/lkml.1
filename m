Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXKYWG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXKYWG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758485AbXKYWFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286AbXKYWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:16 -0500
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
Subject: [PATCH 18/27] x86-64 ia32 ptrace debugreg cleanup
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20071125220505.BF3F726F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:05:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the ia32 compat ptrace code to use shared code from
native ptrace for the implementation guts of debug register access.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c |   63 ++++++----------------------------------------
 1 files changed, 8 insertions(+), 55 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index a9a5cd4..5661abd 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -40,7 +40,6 @@
 
 static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 {
-	int i;
 	__u64 *stack = (__u64 *)task_pt_regs(child);
 
 	switch (regno) {
@@ -95,43 +94,10 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 		break;
 	}
 
-	case offsetof(struct user32, u_debugreg[4]): 
-	case offsetof(struct user32, u_debugreg[5]):
-		return -EIO;
-
-	case offsetof(struct user32, u_debugreg[0]):
-		child->thread.debugreg0 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[1]):
-		child->thread.debugreg1 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[2]):
-		child->thread.debugreg2 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[3]):
-		child->thread.debugreg3 = val;
-		break;
-
-	case offsetof(struct user32, u_debugreg[6]):
-		child->thread.debugreg6 = val;
-		break; 
-
-	case offsetof(struct user32, u_debugreg[7]):
-		val &= ~DR_CONTROL_RESERVED;
-		/* See arch/i386/kernel/ptrace.c for an explanation of
-		 * this awkward check.*/
-		for(i=0; i<4; i++)
-			if ((0x5454 >> ((val >> (16 + 4*i)) & 0xf)) & 1)
-			       return -EIO;
-		child->thread.debugreg7 = val; 
-		if (val)
-			set_tsk_thread_flag(child, TIF_DEBUG);
-		else
-			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break; 
+	case offsetof(struct user32, u_debugreg[0]) ...
+		offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		return ptrace_set_debugreg(child, regno / 4, val);
 		    
 	default:
 		if (regno > sizeof(struct user32) || (regno & 3))
@@ -188,23 +154,10 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 			*val &= ~X86_EFLAGS_TF;
 		break;
 
-	case offsetof(struct user32, u_debugreg[0]): 
-		*val = child->thread.debugreg0; 
-		break; 
-	case offsetof(struct user32, u_debugreg[1]): 
-		*val = child->thread.debugreg1; 
-		break; 
-	case offsetof(struct user32, u_debugreg[2]): 
-		*val = child->thread.debugreg2; 
-		break; 
-	case offsetof(struct user32, u_debugreg[3]): 
-		*val = child->thread.debugreg3; 
-		break; 
-	case offsetof(struct user32, u_debugreg[6]): 
-		*val = child->thread.debugreg6; 
-		break; 
-	case offsetof(struct user32, u_debugreg[7]): 
-		*val = child->thread.debugreg7; 
+	case offsetof(struct user32, u_debugreg[0]) ...
+		offsetof(struct user32, u_debugreg[7]):
+		regno -= offsetof(struct user32, u_debugreg[0]);
+		*val = ptrace_get_debugreg(child, regno / 4);
 		break; 
 		    
 	default:
