Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYLDTRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYLDTRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYLDTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:16:59 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54262 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLDTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:16:58 -0500
Date: Fri, 5 Dec 2008 00:46:48 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 8/9] Modify Ptrace routines to access breakpoint
	registers
Message-ID: <20081204191648.GH20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch code to use the debug/breakpoint registers
through the new in-kernel interfaces to access the same.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/ptrace.c |  226 +++++++++++++++++++++++++++++++----------------
 1 file changed, 150 insertions(+), 76 deletions(-)

Index: linux-HBKPT-2.6.28-rc7/arch/x86/kernel/ptrace.c
===================================================================
--- linux-HBKPT-2.6.28-rc7.orig/arch/x86/kernel/ptrace.c
+++ linux-HBKPT-2.6.28-rc7/arch/x86/kernel/ptrace.c
@@ -33,6 +33,7 @@
 #include <asm/prctl.h>
 #include <asm/proto.h>
 #include <asm/ds.h>
+#include <asm/hw_breakpoint.h>
 
 #include "tls.h"
 
@@ -466,95 +467,168 @@ static int genregs_set(struct task_struc
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
+	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
+
+	*len = (temp & 0xc) | 0x40;
+	*type = (temp & 0x3) | 0x80;
+	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
+}
+
+static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct thread_hw_breakpoint *thbi = tsk->thread.hw_breakpoint_info;
+	int i;
+
+	/* Store in the virtual DR6 register the fact that the breakpoint
+	 * was hit so the thread's debugger will see it.
+	 */
+	if (thbi) {
+		i = bp - thbi->vdr_bps;
+		tsk->thread.vdr6 |= (DR_TRAP0 << i);
 	}
-	return 0;
 }
 
-static int ptrace_set_debugreg(struct task_struct *child,
-			       int n, unsigned long data)
+/*
+ * Handle ptrace writes to debug register 7.
+ */
+static int ptrace_write_dr7(struct task_struct *tsk,
+		struct thread_hw_breakpoint *thbi, unsigned long data)
 {
+	struct hw_breakpoint *bp;
 	int i;
+	int rc = 0;
+	unsigned long old_dr7 = thbi->vdr7;
 
-	if (unlikely(n == 4 || n == 5))
-		return -EIO;
+	data &= ~DR_CONTROL_RESERVED;
 
-	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
-		return -EIO;
+	/* Loop through all the hardware breakpoints, making the
+	 * appropriate changes to each.
+	 */
+ restore_settings:
+	thbi->vdr7 = data;
+	bp = &thbi->vdr_bps[0];
+	for (i = 0; i < HB_NUM; (++i, ++bp)) {
+		int enabled;
+		unsigned len, type;
+
+		enabled = decode_dr7(data, i, &len, &type);
+
+		/* Unregister the breakpoint before trying to change it */
+		if (bp->status)
+			__unregister_user_hw_breakpoint(tsk, bp);
 
-	switch (n) {
-	case 0:		child->thread.debugreg0 = data; break;
-	case 1:		child->thread.debugreg1 = data; break;
-	case 2:		child->thread.debugreg2 = data; break;
-	case 3:		child->thread.debugreg3 = data; break;
+		/* Now register the breakpoint if it should be enabled.
+		 * New invalid entries will raise an error here.
+		 */
+		if (enabled) {
+			bp->triggered = ptrace_triggered;
 
-	case 6:
-		if ((data & ~0xffffffffUL) != 0)
-			return -EIO;
-		child->thread.debugreg6 = data;
-		break;
+			bp->priority = HW_BREAKPOINT_PRIO_PTRACE;
+			if (rc == 0 && __register_user_hw_breakpoint(tsk, bp,
+					bp->info.address, len, type) < 0)
+				break;
+		}
+	}
 
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
+	/* If anything above failed, restore the original settings */
+	if (i < HB_NUM) {
+		rc = -EIO;
+		data = old_dr7;
+		goto restore_settings;
+	}
+	return rc;
+}
+
+/*
+ * Handle PTRACE_PEEKUSR calls for the debug register area.
+ */
+unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
+{
+	struct thread_hw_breakpoint *thbi;
+	unsigned long val = 0;
+
+	mutex_lock(&hw_breakpoint_mutex);
+	thbi = tsk->thread.hw_breakpoint_info;
+	if (n < HB_NUM) {
+		if (thbi)
+			val = thbi->vdr_bps[n].info.address;
+	} else if (n == 6) {
+		val = tsk->thread.vdr6;
+	} else if (n == 7) {
+		if (thbi)
+			val = thbi->vdr7;
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
+	struct thread_hw_breakpoint *thbi;
+	int rc = -EIO;
+
+	/* We have to hold this lock the entire time, to prevent thbi
+	 * from being deallocated out from under us.
+	 */
+	mutex_lock(&hw_breakpoint_mutex);
+
+	/* There are no DR4 or DR5 registers */
+	if (n == 4 || n == 5)
+		;
+
+	/* Writes to DR6 modify the virtualized value */
+	else if (n == 6) {
+		tsk->thread.vdr6 = val;
+		rc = 0;
+	}
+
+	else if (!tsk->thread.hw_breakpoint_info && val == 0)
+		rc = 0;		/* Minor optimization */
+
+	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
+		rc = -ENOMEM;
+
+	/* Writes to DR0 - DR3 change a breakpoint address */
+	else if (n < HB_NUM) {
+		struct hw_breakpoint *bp = &thbi->vdr_bps[n];
+
+		/* If the breakpoint is registered then unregister it,
+		 * change it, and re-register it.  Revert to the original
+		 * address if an error occurs.
 		 */
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
+		if (bp->status) {
+			unsigned long old_addr = bp->info.address;
+
+			__unregister_user_hw_breakpoint(tsk, bp);
+			rc = __register_user_hw_breakpoint(tsk, bp,
+					val, bp->info.len, bp->info.type);
+			if (rc < 0) {
+				__register_user_hw_breakpoint(tsk, bp,
+						old_addr,
+						bp->info.len, bp->info.type);
+			}
+		} else {
+			bp->info.address = val;
+			rc = 0;
+		}
 	}
 
-	return 0;
+	/* All that's left is DR7 */
+	else
+		rc = ptrace_write_dr7(tsk, thbi, val);
+
+	mutex_unlock(&hw_breakpoint_mutex);
+	return rc;
 }
 
 /*
@@ -1008,7 +1082,7 @@ long arch_ptrace(struct task_struct *chi
 		else if (addr >= offsetof(struct user, u_debugreg[0]) &&
 			 addr <= offsetof(struct user, u_debugreg[7])) {
 			addr -= offsetof(struct user, u_debugreg[0]);
-			tmp = ptrace_get_debugreg(child, addr / sizeof(data));
+			tmp = ptrace_get_debugreg(child, addr/sizeof(data));
 		}
 		ret = put_user(tmp, datap);
 		break;
@@ -1026,7 +1100,7 @@ long arch_ptrace(struct task_struct *chi
 			 addr <= offsetof(struct user, u_debugreg[7])) {
 			addr -= offsetof(struct user, u_debugreg[0]);
 			ret = ptrace_set_debugreg(child,
-						  addr / sizeof(data), data);
+						addr/sizeof(data), data);
 		}
 		break;
 
