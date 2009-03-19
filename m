Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZCSXvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZCSXvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762256AbZCSXtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:49:51 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60968 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762238AbZCSXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:49:49 -0400
Date: Fri, 20 Mar 2009 05:19:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 08/11] Modify Ptrace routines to access breakpoint registers
Message-ID: <20090319234940.GI10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=8
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch modifies the ptrace code to use the new wrapper routines around the 
debug/breakpoint registers.

[K.Prasad: Adapted the ptrace routines and to changes post x86/x86_64 merger,
	   split the minor patch from bigger patch. Re-wrote ptrace_write_dr7()
           and ptrace_set_debugreg() functions to use new data-structures]

[K.Prasad: Changed code to suit the simplified HW breakpoint implementation]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/ptrace.c |  229 ++++++++++++++++++++++++++++-------------------
 1 file changed, 138 insertions(+), 91 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
@@ -34,6 +34,7 @@
 #include <asm/prctl.h>
 #include <asm/proto.h>
 #include <asm/ds.h>
+#include <asm/hw_breakpoint.h>
 
 #include "tls.h"
 
@@ -134,11 +135,6 @@ static int set_segment_reg(struct task_s
 	return 0;
 }
 
-static unsigned long debugreg_addr_limit(struct task_struct *task)
-{
-	return TASK_SIZE - 3;
-}
-
 #else  /* CONFIG_X86_64 */
 
 #define FLAG_MASK		(FLAG_MASK_32 | X86_EFLAGS_NT)
@@ -263,15 +259,6 @@ static int set_segment_reg(struct task_s
 	return 0;
 }
 
-static unsigned long debugreg_addr_limit(struct task_struct *task)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (test_tsk_thread_flag(task, TIF_IA32))
-		return IA32_PAGE_OFFSET - 3;
-#endif
-	return TASK_SIZE_MAX - 7;
-}
-
 #endif	/* CONFIG_X86_32 */
 
 static unsigned long get_flags(struct task_struct *task)
@@ -462,95 +449,155 @@ static int genregs_set(struct task_struc
 }
 
 /*
- * This function is trivial and will be inlined by the compiler.
- * Having it separates the implementation details of debug
- * registers from the interface details of ptrace.
+ * Decode the length and type bits for a particular breakpoint as
+ * stored in debug register 7.  Return the "enabled" status.
  */
-static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
+static int decode_dr7(unsigned long dr7, int bpnum, unsigned *len,
+		unsigned *type)
 {
-	switch (n) {
-	case 0:		return child->thread.debugreg0;
-	case 1:		return child->thread.debugreg1;
-	case 2:		return child->thread.debugreg2;
-	case 3:		return child->thread.debugreg3;
-	case 6:		return child->thread.debugreg6;
-	case 7:		return child->thread.debugreg7;
-	}
-	return 0;
+	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
+
+	*len = (temp & 0xc) | 0x40;
+	*type = (temp & 0x3) | 0x80;
+	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
 }
 
-static int ptrace_set_debugreg(struct task_struct *child,
-			       int n, unsigned long data)
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
 {
+	struct thread_struct *thread = &(current->thread);
 	int i;
 
-	if (unlikely(n == 4 || n == 5))
-		return -EIO;
+	/* Store in the virtual DR6 register the fact that the breakpoint
+	 * was hit so the thread's debugger will see it.
+	 */
+	for (i = 0; i < hbkpt_user_max; i++)
+		if (bp->info.address == thread->hbkpt[i]->info.address)
+			break;
 
-	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
-		return -EIO;
+	thread->dr6 |= (DR_TRAP0 << i);
+}
 
-	switch (n) {
-	case 0:		child->thread.debugreg0 = data; break;
-	case 1:		child->thread.debugreg1 = data; break;
-	case 2:		child->thread.debugreg2 = data; break;
-	case 3:		child->thread.debugreg3 = data; break;
+/*
+ * Handle ptrace writes to debug register 7.
+ */
+static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
+{
+	struct hw_breakpoint *bp;
+	struct thread_struct *thread = &(tsk->thread);
+	int i;
+	int rc = 0;
+	unsigned long old_dr7 = thread->dr7;
 
-	case 6:
-		if ((data & ~0xffffffffUL) != 0)
-			return -EIO;
-		child->thread.debugreg6 = data;
-		break;
+	data &= ~DR_CONTROL_RESERVED;
+	/* Loop through all the hardware breakpoints, making the
+	 * appropriate changes to each.
+	 */
+restore_settings:
+	thread->dr7 = data;
+	for (i = 0; i < HB_NUM; i++) {
+		int enabled;
+		unsigned len, type;
+
+		bp = thread->hbkpt[i];
+		if (!bp)
+			continue;
+
+		enabled = decode_dr7(data, i, &len, &type);
+		if (!enabled) {
+			if (bp->triggered)
+				__unregister_user_hw_breakpoint(i, tsk, bp);
+			continue;
+		}
 
-	case 7:
-		/*
-		 * Sanity-check data. Take one half-byte at once with
-		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
-		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
-		 * 2 and 3 are LENi. Given a list of invalid values,
-		 * we do mask |= 1 << invalid_value, so that
-		 * (mask >> check) & 1 is a correct test for invalid
-		 * values.
-		 *
-		 * R/Wi contains the type of the breakpoint /
-		 * watchpoint, LENi contains the length of the watched
-		 * data in the watchpoint case.
-		 *
-		 * The invalid values are:
-		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.	[32-bit]
-		 * - R/Wi == 0x10 (break on I/O reads or writes), so
-		 *   mask |= 0x4444.
-		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
-		 *   0x1110.
-		 *
-		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
-		 *
-		 * See the Intel Manual "System Programming Guide",
-		 * 15.2.4
-		 *
-		 * Note that LENi == 0x10 is defined on x86_64 in long
-		 * mode (i.e. even for 32-bit userspace software, but
-		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
-		 * See the AMD manual no. 24593 (AMD64 System Programming)
-		 */
-#ifdef CONFIG_X86_32
-#define	DR7_MASK	0x5f54
-#else
-#define	DR7_MASK	0x5554
-#endif
-		data &= ~DR_CONTROL_RESERVED;
-		for (i = 0; i < 4; i++)
-			if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-				return -EIO;
-		child->thread.debugreg7 = data;
-		if (data)
-			set_tsk_thread_flag(child, TIF_DEBUG);
+		if (bp->triggered)
+			rc = __modify_user_hw_breakpoint(i, tsk, bp);
+		else {
+			bp->triggered = ptrace_triggered;
+			bp->info.len = len;
+			bp->info.type = type;
+			rc = __register_user_hw_breakpoint(i, tsk, bp);
+		}
+		if (rc < 0)
+			break;
 		else
-			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break;
+			set_tsk_thread_flag(tsk, TIF_DEBUG);
+	}
+	/* If anything above failed, restore the original settings */
+	if (rc < 0) {
+		data = old_dr7;
+		goto restore_settings;
 	}
+	return rc;
+}
 
-	return 0;
+/*
+ * Handle PTRACE_PEEKUSR calls for the debug register area.
+ */
+unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
+{
+	struct thread_struct *thread = &(tsk->thread);
+	unsigned long val = 0;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	if (n < HB_NUM) {
+		if (thread->hbkpt[n])
+			val = thread->hbkpt[n]->info.address;
+	} else if (n == 6) {
+		val = thread->dr6;
+	} else if (n == 7) {
+		val = thread->dr7;
+	}
+	mutex_unlock(&hw_breakpoint_mutex);
+	return val;
+}
+
+/*
+ * Handle PTRACE_POKEUSR calls for the debug register area.
+ */
+int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+{
+	struct thread_struct *thread = &(tsk->thread);
+	int rc = -EIO;
+
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* There are no DR4 or DR5 registers */
+	if (n == 4 || n == 5)
+		goto ret_path;
+
+	/* Writes to DR6 modify the virtualized value */
+	if (n == 6) {
+		tsk->thread.dr6 = val;
+		rc = 0;
+		goto ret_path;
+	}
+
+	/* Writes to DR0 - DR3 change a breakpoint address */
+	rc = 0;
+	if (n < HB_NUM) {
+		if (!val)
+			goto ret_path;
+		if (thread->hbkpt[n]) {
+			thread->hbkpt[n]->info.address = val;
+			rc = __modify_user_hw_breakpoint(n, tsk,
+							  thread->hbkpt[n]);
+			goto ret_path;
+		}
+		thread->hbkpt[n] = kzalloc(sizeof(struct hw_breakpoint),
+								GFP_KERNEL);
+		if (!thread->hbkpt[n]) {
+			rc = -ENOMEM;
+			goto ret_path;
+		} else
+			thread->hbkpt[n]->info.address = val;
+	}
+	/* All that's left is DR7 */
+	if (n == 7)
+		rc = ptrace_write_dr7(tsk, val);
+
+ret_path:
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
 }
 
 /*
@@ -871,7 +918,7 @@ long arch_ptrace(struct task_struct *chi
 		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
 			 addr <= offsetof(struct user, u_debugreg[7])) {
 			addr -= offsetof(struct user, u_debugreg[0]);
-			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
+			tmp = ptrace_get_debugreg(child, addr/sizeof(data));
 		}
 		ret = put_user(tmp, datap);
 		break;
@@ -889,7 +936,7 @@ long arch_ptrace(struct task_struct *chi
 			 addr <= offsetof(struct user, u_debugreg[7])) {
 			addr -= offsetof(struct user, u_debugreg[0]);
 			ret = ptrace_set_debugreg(child,
-						  addr / sizeof(data), data);
+						addr/sizeof(data), data);
 		}
 		break;
 

