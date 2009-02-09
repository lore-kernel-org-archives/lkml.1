Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZBINnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZBINnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZBINlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:41:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:37881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbZBINk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:59 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/11] x86: add %gs accessors for x86_32
Date: Mon,  9 Feb 2009 22:39:56 +0900
Message-Id: <1234186798-16820-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

On x86_32, %gs is handled lazily.  It's not saved and restored on
kernel entry/exit but only when necessary which usually is during task
switch but there are few other places.  Currently, it's done by
calling savesegment() and loadsegment() explicitly.  Define
get_user_gs(), set_user_gs() and task_user_gs() and use them instead.

While at it, clean up register access macros in signal.c.

This cleans up code a bit and will help future changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/a.out-core.h  |    2 +-
 arch/x86/include/asm/elf.h         |    2 +-
 arch/x86/include/asm/mmu_context.h |    2 +-
 arch/x86/include/asm/system.h      |    9 ++++++++
 arch/x86/kernel/process_32.c       |    6 ++--
 arch/x86/kernel/ptrace.c           |   14 +++++-------
 arch/x86/kernel/signal.c           |   41 ++++++++++++++----------------------
 arch/x86/kernel/vm86_32.c          |    4 +-
 arch/x86/math-emu/get_address.c    |    6 +---
 9 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
index 3c601f8..bb70e39 100644
--- a/arch/x86/include/asm/a.out-core.h
+++ b/arch/x86/include/asm/a.out-core.h
@@ -55,7 +55,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.ds = (u16)regs->ds;
 	dump->regs.es = (u16)regs->es;
 	dump->regs.fs = (u16)regs->fs;
-	savesegment(gs, dump->regs.gs);
+	dump->regs.gs = get_user_gs(regs);
 	dump->regs.orig_ax = regs->orig_ax;
 	dump->regs.ip = regs->ip;
 	dump->regs.cs = (u16)regs->cs;
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f51a3dd..39b0aac 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -124,7 +124,7 @@ do {						\
 	pr_reg[7] = regs->ds & 0xffff;		\
 	pr_reg[8] = regs->es & 0xffff;		\
 	pr_reg[9] = regs->fs & 0xffff;		\
-	savesegment(gs, pr_reg[10]);		\
+	pr_reg[10] = get_user_gs(regs);		\
 	pr_reg[11] = regs->orig_ax;		\
 	pr_reg[12] = regs->ip;			\
 	pr_reg[13] = regs->cs & 0xffff;		\
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 52948df..4955165 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -79,7 +79,7 @@ do {						\
 #ifdef CONFIG_X86_32
 #define deactivate_mm(tsk, mm)			\
 do {						\
-	loadsegment(gs, 0);			\
+	set_user_gs(task_pt_regs(tsk), 0);	\
 } while (0)
 #else
 #define deactivate_mm(tsk, mm)			\
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c223837..72082d3 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -182,6 +182,15 @@ extern void native_load_gs_index(unsigned);
 #define savesegment(seg, value)				\
 	asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
 
+/*
+ * x86_32 user gs accessors.
+ */
+#ifdef CONFIG_X86_32
+#define get_user_gs(regs)	(u16)({unsigned long v; savesegment(gs, v); v;})
+#define set_user_gs(regs, v)	loadsegment(gs, (unsigned long)(v))
+#define task_user_gs(tsk)	((tsk)->thread.gs)
+#endif
+
 static inline unsigned long get_limit(unsigned long segment)
 {
 	unsigned long __limit;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index eccfb58..317d956 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -129,7 +129,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
 		ss = regs->ss & 0xffff;
-		savesegment(gs, gs);
+		gs = get_user_gs(regs);
 	} else {
 		sp = (unsigned long) (&regs->sp);
 		savesegment(ss, ss);
@@ -302,7 +302,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 
 	p->thread.ip = (unsigned long) ret_from_fork;
 
-	savesegment(gs, p->thread.gs);
+	task_user_gs(p) = get_user_gs(regs);
 
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
@@ -340,7 +340,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 void
 start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
-	__asm__("movl %0, %%gs" : : "r"(0));
+	set_user_gs(regs, 0);
 	regs->fs		= 0;
 	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a5df5f..508b6b5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -90,9 +90,10 @@ static u16 get_segment_reg(struct task_struct *task, unsigned long offset)
 	if (offset != offsetof(struct user_regs_struct, gs))
 		retval = *pt_regs_access(task_pt_regs(task), offset);
 	else {
-		retval = task->thread.gs;
 		if (task == current)
-			savesegment(gs, retval);
+			retval = get_user_gs(task_pt_regs(task));
+		else
+			retval = task_user_gs(task);
 	}
 	return retval;
 }
@@ -126,13 +127,10 @@ static int set_segment_reg(struct task_struct *task,
 		break;
 
 	case offsetof(struct user_regs_struct, gs):
-		task->thread.gs = value;
 		if (task == current)
-			/*
-			 * The user-mode %gs is not affected by
-			 * kernel entry, so we must update the CPU.
-			 */
-			loadsegment(gs, value);
+			set_user_gs(task_pt_regs(task), value);
+		else
+			task_user_gs(task) = value;
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40e089b..b2f977e 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -50,27 +50,23 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
-#define COPY(x)			{		\
-	get_user_ex(regs->x, &sc->x);		\
-}
+#define COPY(x)			do {			\
+	get_user_ex(regs->x, &sc->x);			\
+} while (0)
 
-#define COPY_SEG(seg)		{			\
-		unsigned short tmp;			\
-		get_user_ex(tmp, &sc->seg);		\
-		regs->seg = tmp;			\
-}
+#define GET_SEG(seg)		({			\
+	unsigned short tmp;				\
+	get_user_ex(tmp, &sc->seg);			\
+	tmp;						\
+})
 
-#define COPY_SEG_CPL3(seg)	{			\
-		unsigned short tmp;			\
-		get_user_ex(tmp, &sc->seg);		\
-		regs->seg = tmp | 3;			\
-}
+#define COPY_SEG(seg)		do {			\
+	regs->seg = GET_SEG(seg);			\
+} while (0)
 
-#define GET_SEG(seg)		{			\
-		unsigned short tmp;			\
-		get_user_ex(tmp, &sc->seg);		\
-		loadsegment(seg, tmp);			\
-}
+#define COPY_SEG_CPL3(seg)	do {			\
+	regs->seg = GET_SEG(seg) | 3;			\
+} while (0)
 
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
@@ -86,7 +82,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	get_user_try {
 
 #ifdef CONFIG_X86_32
-		GET_SEG(gs);
+		set_user_gs(regs, GET_SEG(gs));
 		COPY_SEG(fs);
 		COPY_SEG(es);
 		COPY_SEG(ds);
@@ -138,12 +134,7 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	put_user_try {
 
 #ifdef CONFIG_X86_32
-		{
-			unsigned int tmp;
-
-			savesegment(gs, tmp);
-			put_user_ex(tmp, (unsigned int __user *)&sc->gs);
-		}
+		put_user_ex(get_user_gs(regs), (unsigned int __user *)&sc->gs);
 		put_user_ex(regs->fs, (unsigned int __user *)&sc->fs);
 		put_user_ex(regs->es, (unsigned int __user *)&sc->es);
 		put_user_ex(regs->ds, (unsigned int __user *)&sc->ds);
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 4eeb5cf..55ea30d 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -158,7 +158,7 @@ struct pt_regs *save_v86_state(struct kernel_vm86_regs *regs)
 	ret = KVM86->regs32;
 
 	ret->fs = current->thread.saved_fs;
-	loadsegment(gs, current->thread.saved_gs);
+	set_user_gs(ret, current->thread.saved_gs);
 
 	return ret;
 }
@@ -323,7 +323,7 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	info->regs32->ax = 0;
 	tsk->thread.saved_sp0 = tsk->thread.sp0;
 	tsk->thread.saved_fs = info->regs32->fs;
-	savesegment(gs, tsk->thread.saved_gs);
+	tsk->thread.saved_gs = get_user_gs(info->regs32);
 
 	tss = &per_cpu(init_tss, get_cpu());
 	tsk->thread.sp0 = (unsigned long) &info->VM86_TSS_ESP0;
diff --git a/arch/x86/math-emu/get_address.c b/arch/x86/math-emu/get_address.c
index 420b3b6..6ef5e99 100644
--- a/arch/x86/math-emu/get_address.c
+++ b/arch/x86/math-emu/get_address.c
@@ -150,11 +150,9 @@ static long pm_address(u_char FPU_modrm, u_char segment,
 #endif /* PARANOID */
 
 	switch (segment) {
-		/* gs isn't used by the kernel, so it still has its
-		   user-space value. */
 	case PREFIX_GS_ - 1:
-		/* N.B. - movl %seg, mem is a 2 byte write regardless of prefix */
-		savesegment(gs, addr->selector);
+		/* user gs handling can be lazy, use special accessors */
+		addr->selector = get_user_gs(FPU_info->regs);
 		break;
 	default:
 		addr->selector = PM_REG_(segment);
-- 
1.6.0.2

