Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXKYWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXKYWGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbXKYWF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502AbXKYWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:24 -0500
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
Subject: [PATCH 17/27] x86-64 ptrace debugreg cleanup
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220449.D288126F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:04:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the 64-bit ptrace code to separate the guts of the
debug register access from the implementation of PTRACE_PEEKUSR and
PTRACE_POKEUSR.  The new functions ptrace_[gs]et_debugreg are made
global so that the ia32 code can later be changed to call them too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_64.c |  140 ++++++++++++++++++++-----------------------
 include/asm-x86/ptrace.h    |    3 +
 2 files changed, 69 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 8123ecb..bad8b3c 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -183,9 +183,63 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 
 }
 
+unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
+{
+	switch (n) {
+	case 0:		return child->thread.debugreg0;
+	case 1:		return child->thread.debugreg1;
+	case 2:		return child->thread.debugreg2;
+	case 3:		return child->thread.debugreg3;
+	case 6:		return child->thread.debugreg6;
+	case 7:		return child->thread.debugreg7;
+	}
+	return 0;
+}
+
+int ptrace_set_debugreg(struct task_struct *child, int n, unsigned long data)
+{
+	int i;
+
+	if (n < 4) {
+		int dsize = test_tsk_thread_flag(child, TIF_IA32) ? 3 : 7;
+		if (unlikely(data >= TASK_SIZE_OF(child) - dsize))
+			return -EIO;
+	}
+
+	switch (n) {
+	case 0:		child->thread.debugreg0 = data; break;
+	case 1:		child->thread.debugreg1 = data; break;
+	case 2:		child->thread.debugreg2 = data; break;
+	case 3:		child->thread.debugreg3 = data; break;
+
+	case 6:
+		if (data >> 32)
+			return -EIO;
+		child->thread.debugreg6 = data;
+		break;
+
+	case 7:
+		/*
+		 * See ptrace_32.c for an explanation of this awkward check.
+		 */
+		data &= ~DR_CONTROL_RESERVED;
+		for (i = 0; i < 4; i++)
+			if ((0x5554 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
+				return -EIO;
+		child->thread.debugreg7 = data;
+		if (data)
+			set_tsk_thread_flag(child, TIF_DEBUG);
+		else
+			clear_tsk_thread_flag(child, TIF_DEBUG);
+		break;
+	}
+
+	return 0;
+}
+
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	long i, ret;
+	long ret;
 	unsigned ui;
 
 	switch (request) {
@@ -204,32 +258,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		    addr > sizeof(struct user) - 7)
 			break;
 
-		switch (addr) {
-		case 0 ... sizeof(struct user_regs_struct) - sizeof(long):
+		tmp = 0;
+		if (addr < sizeof(struct user_regs_struct))
 			tmp = getreg(child, addr);
-			break;
-		case offsetof(struct user, u_debugreg[0]):
-			tmp = child->thread.debugreg0;
-			break;
-		case offsetof(struct user, u_debugreg[1]):
-			tmp = child->thread.debugreg1;
-			break;
-		case offsetof(struct user, u_debugreg[2]):
-			tmp = child->thread.debugreg2;
-			break;
-		case offsetof(struct user, u_debugreg[3]):
-			tmp = child->thread.debugreg3;
-			break;
-		case offsetof(struct user, u_debugreg[6]):
-			tmp = child->thread.debugreg6;
-			break;
-		case offsetof(struct user, u_debugreg[7]):
-			tmp = child->thread.debugreg7;
-			break;
-		default:
-			tmp = 0;
-			break;
+		else if (addr >= offsetof(struct user, u_debugreg[0])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			tmp = ptrace_get_debugreg(child, addr / sizeof(long));
 		}
+
 		ret = put_user(tmp,(unsigned long __user *) data);
 		break;
 	}
@@ -241,63 +277,19 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-	{
-		int dsize = test_tsk_thread_flag(child, TIF_IA32) ? 3 : 7;
 		ret = -EIO;
 		if ((addr & 7) ||
 		    addr > sizeof(struct user) - 7)
 			break;
 
-		switch (addr) {
-		case 0 ... sizeof(struct user_regs_struct) - sizeof(long):
+		if (addr < sizeof(struct user_regs_struct))
 			ret = putreg(child, addr, data);
-			break;
-		/* Disallows to set a breakpoint into the vsyscall */
-		case offsetof(struct user, u_debugreg[0]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg0 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[1]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg1 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[2]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg2 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[3]):
-			if (data >= TASK_SIZE_OF(child) - dsize) break;
-			child->thread.debugreg3 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[6]):
-				  if (data >> 32)
-				break;
-			child->thread.debugreg6 = data;
-			ret = 0;
-			break;
-		case offsetof(struct user, u_debugreg[7]):
-			/* See arch/i386/kernel/ptrace.c for an explanation of
-			 * this awkward check.*/
-			data &= ~DR_CONTROL_RESERVED;
-			for(i=0; i<4; i++)
-				if ((0x5554 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-					break;
-			if (i == 4) {
-			  child->thread.debugreg7 = data;
-			  if (data)
-			  	set_tsk_thread_flag(child, TIF_DEBUG);
-			  else
-			  	clear_tsk_thread_flag(child, TIF_DEBUG);
-			  ret = 0;
-		  	}
-		  break;
+		else if (addr >= offsetof(struct user, u_debugreg[0])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			ret = ptrace_set_debugreg(child,
+						  addr / sizeof(long), data);
 		}
 		break;
-	}
 
 #ifdef CONFIG_IA32_EMULATION
 		/* This makes only sense with 32bit programs. Allow a
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index fe75422..d223dec 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -110,6 +110,9 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 struct task_struct;
 
+extern unsigned long ptrace_get_debugreg(struct task_struct *child, int n);
+extern int ptrace_set_debugreg(struct task_struct *child, int n, unsigned long);
+
 extern unsigned long
 convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
