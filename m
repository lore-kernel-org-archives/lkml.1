Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbXK2MAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbXK2MAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXK2MAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:00:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759918AbXK2MAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:05 -0500
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
Subject: [PATCH x86/mm 05/11] x86 ptrace getreg/putreg merge
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Shopping-List: (1) Dicey caves
   (2) Archaic exhibitions
   (3) Antic pincushion beagles
Message-Id: <20071129115954.12D3126F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 03:59:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This merges 64-bit support into the low-level register access
functions in arch/x86/kernel/ptrace.c, paving the way to share
this file between 32-bit and 64-bit builds.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |  215 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 211 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index eaec75a..f42f8d2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -24,6 +24,8 @@
 #include <asm/debugreg.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
+#include <asm/prctl.h>
+#include <asm/proto.h>
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -40,6 +42,14 @@
 				  X86_EFLAGS_DF | X86_EFLAGS_OF |	\
 				  X86_EFLAGS_RF | X86_EFLAGS_AC))
 
+/*
+ * Determines whether a value may be installed in a segment register.
+ */
+#define invalid_selector(value) \
+	((value) != 0 && ((value) & SEGMENT_RPL_MASK) != USER_RPL)
+
+#ifdef CONFIG_X86_32
+
 #define FLAG_MASK		FLAG_MASK_32
 
 static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
@@ -73,7 +83,7 @@ static int set_segment_reg(struct task_struct *task,
 	/*
 	 * The value argument was already truncated to 16 bits.
 	 */
-	if (value && (value & 3) != 3)
+	if (invalid_selector(value))
 		return -EIO;
 
 	if (offset != offsetof(struct user_regs_struct, gs))
@@ -91,6 +101,142 @@ static int set_segment_reg(struct task_struct *task,
 	return 0;
 }
 
+static unsigned long debugreg_addr_limit(struct task_struct *task)
+{
+	return TASK_SIZE - 3;
+}
+
+#else  /* CONFIG_X86_64 */
+
+#define FLAG_MASK		(FLAG_MASK_32 | X86_EFLAGS_NT)
+
+static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long offset)
+{
+	BUILD_BUG_ON(offsetof(struct pt_regs, r15) != 0);
+	return &regs->r15 + (offset / sizeof(regs->r15));
+}
+
+static u16 get_segment_reg(struct task_struct *task, unsigned long offset)
+{
+	/*
+	 * Returning the value truncates it to 16 bits.
+	 */
+	unsigned int seg;
+
+	switch (offset) {
+	case offsetof(struct user_regs_struct, fs):
+		if (task == current) {
+			/* Older gas can't assemble movq %?s,%r?? */
+			asm("movl %%fs,%0" : "=r" (seg));
+			return seg;
+		}
+		return task->thread.fsindex;
+	case offsetof(struct user_regs_struct, gs):
+		if (task == current) {
+			asm("movl %%gs,%0" : "=r" (seg));
+			return seg;
+		}
+		return task->thread.gsindex;
+	case offsetof(struct user_regs_struct, ds):
+		if (task == current) {
+			asm("movl %%ds,%0" : "=r" (seg));
+			return seg;
+		}
+		return task->thread.ds;
+	case offsetof(struct user_regs_struct, es):
+		if (task == current) {
+			asm("movl %%es,%0" : "=r" (seg));
+			return seg;
+		}
+		return task->thread.es;
+
+	case offsetof(struct user_regs_struct, cs):
+	case offsetof(struct user_regs_struct, ss):
+		break;
+	}
+	return *pt_regs_access(task_pt_regs(task), offset);
+}
+
+static int set_segment_reg(struct task_struct *task,
+			   unsigned long offset, u16 value)
+{
+	/*
+	 * The value argument was already truncated to 16 bits.
+	 */
+	if (invalid_selector(value))
+		return -EIO;
+
+	switch (offset) {
+	case offsetof(struct user_regs_struct,fs):
+		/*
+		 * If this is setting fs as for normal 64-bit use but
+		 * setting fs_base has implicitly changed it, leave it.
+		 */
+		if ((value == FS_TLS_SEL && task->thread.fsindex == 0 &&
+		     task->thread.fs != 0) ||
+		    (value == 0 && task->thread.fsindex == FS_TLS_SEL &&
+		     task->thread.fs == 0))
+			break;
+		task->thread.fsindex = value;
+		if (task == current)
+			loadsegment(fs, task->thread.fsindex);
+		break;
+	case offsetof(struct user_regs_struct,gs):
+		/*
+		 * If this is setting gs as for normal 64-bit use but
+		 * setting gs_base has implicitly changed it, leave it.
+		 */
+		if ((value == GS_TLS_SEL && task->thread.gsindex == 0 &&
+		     task->thread.gs != 0) ||
+		    (value == 0 && task->thread.gsindex == GS_TLS_SEL &&
+		     task->thread.gs == 0))
+			break;
+		task->thread.gsindex = value;
+		if (task == current)
+			load_gs_index(task->thread.gsindex);
+		break;
+	case offsetof(struct user_regs_struct,ds):
+		task->thread.ds = value;
+		if (task == current)
+			loadsegment(ds, task->thread.ds);
+		break;
+	case offsetof(struct user_regs_struct,es):
+		task->thread.es = value;
+		if (task == current)
+			loadsegment(es, task->thread.es);
+		break;
+
+		/*
+		 * Can't actually change these in 64-bit mode.
+		 */
+	case offsetof(struct user_regs_struct,cs):
+#ifdef CONFIG_IA32_EMULATION
+		if (test_tsk_thread_flag(task, TIF_IA32))
+			task_pt_regs(task)->cs = value;
+		break;
+#endif
+	case offsetof(struct user_regs_struct,ss):
+#ifdef CONFIG_IA32_EMULATION
+		if (test_tsk_thread_flag(task, TIF_IA32))
+			task_pt_regs(task)->ss = value;
+		break;
+#endif
+	}
+
+	return 0;
+}
+
+static unsigned long debugreg_addr_limit(struct task_struct *task)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_tsk_thread_flag(task, TIF_IA32))
+		return IA32_PAGE_OFFSET - 3;
+#endif
+	return TASK_SIZE64 - 7;
+}
+
+#endif	/* CONFIG_X86_32 */
+
 static unsigned long get_flags(struct task_struct *task)
 {
 	unsigned long retval = task_pt_regs(task)->flags;
@@ -137,6 +283,29 @@ static int putreg(struct task_struct *child,
 
 	case offsetof(struct user_regs_struct, flags):
 		return set_flags(child, value);
+
+#ifdef CONFIG_X86_64
+	case offsetof(struct user_regs_struct,fs_base):
+		if (value >= TASK_SIZE_OF(child))
+			return -EIO;
+		/*
+		 * When changing the segment base, use do_arch_prctl
+		 * to set either thread.fs or thread.fsindex and the
+		 * corresponding GDT slot.
+		 */
+		if (child->thread.fs != value)
+			return do_arch_prctl(child, ARCH_SET_FS, value);
+		return 0;
+	case offsetof(struct user_regs_struct,gs_base):
+		/*
+		 * Exactly the same here as the %fs handling above.
+		 */
+		if (value >= TASK_SIZE_OF(child))
+			return -EIO;
+		if (child->thread.gs != value)
+			return do_arch_prctl(child, ARCH_SET_GS, value);
+		return 0;
+#endif
 	}
 
 	*pt_regs_access(task_pt_regs(child), offset) = value;
@@ -156,6 +325,37 @@ static unsigned long getreg(struct task_struct *task, unsigned long offset)
 
 	case offsetof(struct user_regs_struct, flags):
 		return get_flags(task);
+
+#ifdef CONFIG_X86_64
+	case offsetof(struct user_regs_struct, fs_base): {
+		/*
+		 * do_arch_prctl may have used a GDT slot instead of
+		 * the MSR.  To userland, it appears the same either
+		 * way, except the %fs segment selector might not be 0.
+		 */
+		unsigned int seg = task->thread.fsindex;
+		if (task->thread.fs != 0)
+			return task->thread.fs;
+		if (task == current)
+			asm("movl %%fs,%0" : "=r" (seg));
+		if (seg != FS_TLS_SEL)
+			return 0;
+		return get_desc_base(&task->thread.tls_array[FS_TLS]);
+	}
+	case offsetof(struct user_regs_struct, gs_base): {
+		/*
+		 * Exactly the same here as the %fs handling above.
+		 */
+		unsigned int seg = task->thread.gsindex;
+		if (task->thread.gs != 0)
+			return task->thread.gs;
+		if (task == current)
+			asm("movl %%gs,%0" : "=r" (seg));
+		if (seg != GS_TLS_SEL)
+			return 0;
+		return get_desc_base(&task->thread.tls_array[GS_TLS]);
+	}
+#endif
 	}
 
 	return *pt_regs_access(task_pt_regs(task), offset);
@@ -187,7 +387,7 @@ static int ptrace_set_debugreg(struct task_struct *child,
 	if (unlikely(n == 4 || n == 5))
 		return -EIO;
 
-	if (n < 4 && unlikely(data >= TASK_SIZE - 3))
+	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
 		return -EIO;
 
 	switch (n) {
@@ -197,6 +397,8 @@ static int ptrace_set_debugreg(struct task_struct *child,
 	case 3:		child->thread.debugreg3 = data; break;
 
 	case 6:
+		if ((data & ~0xffffffffUL) != 0)
+			return -EIO;
 		child->thread.debugreg6 = data;
 		break;
 
@@ -215,7 +417,7 @@ static int ptrace_set_debugreg(struct task_struct *child,
 		 * data in the watchpoint case.
 		 *
 		 * The invalid values are:
-		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.
+		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.	[32-bit]
 		 * - R/Wi == 0x10 (break on I/O reads or writes), so
 		 *   mask |= 0x4444.
 		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
@@ -231,9 +433,14 @@ static int ptrace_set_debugreg(struct task_struct *child,
 		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
 		 * See the AMD manual no. 24593 (AMD64 System Programming)
 		 */
+#ifdef CONFIG_X86_32
+#define	DR7_MASK	0x5f54
+#else
+#define	DR7_MASK	0x5554
+#endif
 		data &= ~DR_CONTROL_RESERVED;
 		for (i = 0; i < 4; i++)
-			if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
+			if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
 				return -EIO;
 		child->thread.debugreg7 = data;
 		if (data)
