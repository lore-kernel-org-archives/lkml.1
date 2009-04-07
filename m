Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbZDGGhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbZDGGhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbZDGGgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:36:50 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45956 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZDGGgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:36:48 -0400
Date: Tue, 7 Apr 2009 12:06:29 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 08/11] Modify Ptrace routines to access breakpoint registers
Message-ID: <20090407063629.GI17461@in.ibm.com>
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_ptrace_08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the ptrace code to use the new wrapper routines around the 
debug/breakpoint registers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Maneesh Soni <maneesh@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/ptrace.c |  227 ++++++++++++++++++++++++++++-------------------
 1 file changed, 137 insertions(+), 90 deletions(-)

Index: arch/x86/kernel/ptrace.c
===================================================================
--- arch/x86/kernel/ptrace.c.orig
+++ arch/x86/kernel/ptrace.c
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
+	for (i = 0; i < hbp_kernel_pos; i++)
+		/*
+		 * We will check bp->info.address against the address stored in
+		 * thread's hbp structure and not debugreg[i]. This is to ensure
+		 * that the corresponding bit for 'i' in DR7 register is enabled
+		 */
+		if (bp->info.address == thread->hbp[i]->info.address)
+			break;
 
-	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
-		return -EIO;
+	thread->debugreg6 |= (DR_TRAP0 << i);
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
+	struct thread_struct *thread = &(tsk->thread);
+	unsigned long old_dr7 = thread->debugreg7;
+	int i, rc = 0;
+	int enabled;
+	unsigned len, type;
+	struct hw_breakpoint *bp;
 
-	case 6:
-		if ((data & ~0xffffffffUL) != 0)
-			return -EIO;
-		child->thread.debugreg6 = data;
-		break;
+	data &= ~DR_CONTROL_RESERVED;
 
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
-		else
-			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break;
+restore:
+	/*
+	 * Loop through all the hardware breakpoints, making the
+	 * appropriate changes to each.
+	 */
+	for (i = 0; i < HB_NUM; i++) {
+		enabled = decode_dr7(data, i, &len, &type);
+		bp = thread->hbp[i];
+
+		if (!enabled) {
+			if (bp) {
+				__unregister_user_hw_breakpoint(i, tsk);
+				kfree(bp);
+			}
+			continue;
+		}
+
+		if (!bp) {
+			rc = -ENOMEM;
+			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
+			if (bp) {
+				bp->info.address = thread->debugreg[i];
+				bp->triggered = ptrace_triggered;
+				bp->info.len = len;
+				bp->info.type = type;
+				rc = __register_user_hw_breakpoint(i, tsk, bp);
+				if (!rc)
+					set_tsk_thread_flag(tsk, TIF_DEBUG);
+				else
+					kfree(bp);
+			}
+		} else
+			rc = __modify_user_hw_breakpoint(i, tsk, bp);
+
+		if (rc)
+			break;
+ 	}
+
+	/* If anything above failed, restore the original settings */
+	if (rc < 0) {
+		data = old_dr7;
+		goto restore;
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
+
+	if (n < HB_NUM)
+		val = thread->debugreg[n];
+	else if (n == 6)
+		val = thread->debugreg6;
+	else if (n == 7)
+		val = thread->debugreg7;
+
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
+	int rc = 0;
+
+	/* There are no DR4 or DR5 registers */
+	if (n == 4 || n == 5)
+		return -EIO;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	if (n == 6) {
+		tsk->thread.debugreg6 = val;
+		goto ret_path;
+	}
+	if (n < HB_NUM) {
+		if (thread->hbp[n]) {
+			if (arch_check_va_in_userspace(val,
+					thread->hbp[n]->info.len) == 0) {
+				rc = -EIO;
+				goto ret_path;
+			}
+			thread->hbp[n]->info.address = val;
+		}
+		thread->debugreg[n] = val;
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

