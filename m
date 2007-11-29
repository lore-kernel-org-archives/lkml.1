Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbXK2MBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbXK2MBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762908AbXK2MA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:00:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762907AbXK2MA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:57 -0500
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
Subject: [PATCH x86/mm 06/11] x86 ptrace arch merge
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Zippy-Says: I have accepted Provolone into my life!
Message-Id: <20071129120014.E34C326F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 04:00:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds 64-bit support to arch_ptrace in arch/x86/kernel/ptrace.c,
so this function can be used for native ptrace on both 32 and 64.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   65 ++++++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f42f8d2..f4355f3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -461,12 +461,13 @@ static int ptrace_set_debugreg(struct task_struct *child,
 void ptrace_disable(struct task_struct *child)
 {
 	user_disable_single_step(child);
+#ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
+#endif
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	struct user * dummy = NULL;
 	int i, ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
@@ -482,18 +483,17 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
+		    addr >= sizeof(struct user))
 			break;
 
 		tmp = 0;  /* Default return condition */
-		if(addr < FRAME_SIZE*sizeof(long))
+		if (addr < sizeof(struct user_regs_struct))
 			tmp = getreg(child, addr);
-		if(addr >= (long) &dummy->u_debugreg[0] &&
-		   addr <= (long) &dummy->u_debugreg[7]){
-			addr -= (long) &dummy->u_debugreg[0];
-			addr = addr >> 2;
-			tmp = ptrace_get_debugreg(child, addr);
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
 		}
 		ret = put_user(tmp, datap);
 		break;
@@ -507,34 +507,26 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
+		    addr >= sizeof(struct user))
 			break;
 
-		if (addr < FRAME_SIZE*sizeof(long)) {
+		if (addr < sizeof(struct user_regs_struct))
 			ret = putreg(child, addr, data);
-			break;
+		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
+			 addr <= offsetof(struct user, u_debugreg[7])) {
+			addr -= offsetof(struct user, u_debugreg[0]);
+			ret = ptrace_set_debugreg(child,
+						  addr / sizeof(data), data);
 		}
-		/* We need to be very careful here.  We implicitly
-		   want to modify a portion of the task_struct, and we
-		   have to be selective about what portions we allow someone
-		   to modify. */
-
-		  ret = -EIO;
-		  if(addr >= (long) &dummy->u_debugreg[0] &&
-		     addr <= (long) &dummy->u_debugreg[7]){
-			  addr -= (long) &dummy->u_debugreg;
-			  addr = addr >> 2;
-			  ret = ptrace_set_debugreg(child, addr, data);
-		  }
-		  break;
+		break;
 
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
-	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
+		if (!access_ok(VERIFY_WRITE, datap, sizeof(struct user_regs_struct))) {
 			ret = -EIO;
 			break;
 		}
-		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
+		for (i = 0; i < sizeof(struct user_regs_struct); i += sizeof(long)) {
 			__put_user(getreg(child, i), datap);
 			datap++;
 		}
@@ -544,11 +536,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
 		unsigned long tmp;
-	  	if (!access_ok(VERIFY_READ, datap, FRAME_SIZE*sizeof(long))) {
+		if (!access_ok(VERIFY_READ, datap, sizeof(struct user_regs_struct))) {
 			ret = -EIO;
 			break;
 		}
-		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
+		for (i = 0; i < sizeof(struct user_regs_struct); i += sizeof(long)) {
 			__get_user(tmp, datap);
 			putreg(child, i, tmp);
 			datap++;
@@ -582,6 +574,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 	}
 
+#ifdef CONFIG_X86_32
 	case PTRACE_GETFPXREGS: { /* Get the child extended FPU state. */
 		if (!access_ok(VERIFY_WRITE, datap,
 			       sizeof(struct user_fxsr_struct))) {
@@ -604,7 +597,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = set_fpxregs(child, (struct user_fxsr_struct __user *)data);
 		break;
 	}
+#endif
 
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 	case PTRACE_GET_THREAD_AREA:
 		if (addr < 0)
 			return -EIO;
@@ -618,6 +613,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = do_set_thread_area(child, addr,
 					 (struct user_desc __user *) data, 0);
 		break;
+#endif
+
+#ifdef CONFIG_X86_64
+		/* normal 64bit interface to access TLS data.
+		   Works just like arch_prctl, except that the arguments
+		   are reversed. */
+	case PTRACE_ARCH_PRCTL:
+		ret = do_arch_prctl(child, data, addr);
+		break;
+#endif
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
