Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYIZSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYIZSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYIZSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:06:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:37180 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYIZSGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:06:03 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/5] kgdb, x86_64: fix PS CS SS registers in gdb serial
Date: Fri, 26 Sep 2008 13:05:19 -0500
Message-Id: <1222452320-16281-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
In-Reply-To: <1222452320-16281-4-git-send-email-jason.wessel@windriver.com>
References: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-3-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Sep 2008 18:05:39.0112 (UTC) FILETIME=[7B853280:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 the gdb serial register structure defines the PS (also known
as eflags), CS and SS registers as 4 bytes entities.

This patch splits the x86_64 regnames enum into a 32 and 64 version to
account for the 32 bit entities in the gdb serial packets.

Also the program counter is properly filled in for the sleeping
threads.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   25 +++++++++++++++++++++----
 include/asm-x86/kgdb.h |   20 +++++++++-----------
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 00f7896..8282a21 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -69,6 +69,9 @@ static int gdb_x86vector = -1;
  */
 void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
+#ifndef CONFIG_X86_32
+	u32 *gdb_regs32 = (u32 *)gdb_regs;
+#endif
 	gdb_regs[GDB_AX]	= regs->ax;
 	gdb_regs[GDB_BX]	= regs->bx;
 	gdb_regs[GDB_CX]	= regs->cx;
@@ -76,9 +79,9 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs[GDB_SI]	= regs->si;
 	gdb_regs[GDB_DI]	= regs->di;
 	gdb_regs[GDB_BP]	= regs->bp;
-	gdb_regs[GDB_PS]	= regs->flags;
 	gdb_regs[GDB_PC]	= regs->ip;
 #ifdef CONFIG_X86_32
+	gdb_regs[GDB_PS]	= regs->flags;
 	gdb_regs[GDB_DS]	= regs->ds;
 	gdb_regs[GDB_ES]	= regs->es;
 	gdb_regs[GDB_CS]	= regs->cs;
@@ -94,6 +97,9 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	gdb_regs[GDB_R13]	= regs->r13;
 	gdb_regs[GDB_R14]	= regs->r14;
 	gdb_regs[GDB_R15]	= regs->r15;
+	gdb_regs32[GDB_PS]	= regs->flags;
+	gdb_regs32[GDB_CS]	= regs->cs;
+	gdb_regs32[GDB_SS]	= regs->ss;
 #endif
 	gdb_regs[GDB_SP]	= regs->sp;
 }
@@ -112,6 +118,9 @@ void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
  */
 void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 {
+#ifndef CONFIG_X86_32
+	u32 *gdb_regs32 = (u32 *)gdb_regs;
+#endif
 	gdb_regs[GDB_AX]	= 0;
 	gdb_regs[GDB_BX]	= 0;
 	gdb_regs[GDB_CX]	= 0;
@@ -129,8 +138,10 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs[GDB_FS]	= 0xFFFF;
 	gdb_regs[GDB_GS]	= 0xFFFF;
 #else
-	gdb_regs[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
-	gdb_regs[GDB_PC]	= 0;
+	gdb_regs32[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
+	gdb_regs32[GDB_CS]	= __KERNEL_CS;
+	gdb_regs32[GDB_SS]	= __KERNEL_DS;
+	gdb_regs[GDB_PC]	= p->thread.ip;
 	gdb_regs[GDB_R8]	= 0;
 	gdb_regs[GDB_R9]	= 0;
 	gdb_regs[GDB_R10]	= 0;
@@ -153,6 +164,9 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
  */
 void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
+#ifndef CONFIG_X86_32
+	u32 *gdb_regs32 = (u32 *)gdb_regs;
+#endif
 	regs->ax		= gdb_regs[GDB_AX];
 	regs->bx		= gdb_regs[GDB_BX];
 	regs->cx		= gdb_regs[GDB_CX];
@@ -160,9 +174,9 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	regs->si		= gdb_regs[GDB_SI];
 	regs->di		= gdb_regs[GDB_DI];
 	regs->bp		= gdb_regs[GDB_BP];
-	regs->flags		= gdb_regs[GDB_PS];
 	regs->ip		= gdb_regs[GDB_PC];
 #ifdef CONFIG_X86_32
+	regs->flags		= gdb_regs[GDB_PS];
 	regs->ds		= gdb_regs[GDB_DS];
 	regs->es		= gdb_regs[GDB_ES];
 	regs->cs		= gdb_regs[GDB_CS];
@@ -175,6 +189,9 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	regs->r13		= gdb_regs[GDB_R13];
 	regs->r14		= gdb_regs[GDB_R14];
 	regs->r15		= gdb_regs[GDB_R15];
+	regs->flags		= gdb_regs32[GDB_PS];
+	regs->cs		= gdb_regs32[GDB_CS];
+	regs->ss		= gdb_regs32[GDB_SS];
 #endif
 }
 
diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
index e86b306..94d63db 100644
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -39,8 +39,9 @@ enum regnames {
 	GDB_FS,			/* 14 */
 	GDB_GS,			/* 15 */
 };
+#define NUMREGBYTES		((GDB_GS+1)*4)
 #else /* ! CONFIG_X86_32 */
-enum regnames {
+enum regnames64 {
 	GDB_AX,			/* 0 */
 	GDB_BX,			/* 1 */
 	GDB_CX,			/* 2 */
@@ -58,18 +59,15 @@ enum regnames {
 	GDB_R14,		/* 14 */
 	GDB_R15,		/* 15 */
 	GDB_PC,			/* 16 */
-	GDB_PS,			/* 17 */
 };
-#endif /* CONFIG_X86_32 */
 
-/*
- * Number of bytes of registers:
- */
-#ifdef CONFIG_X86_32
-# define NUMREGBYTES		64
-#else
-# define NUMREGBYTES		((GDB_PS+1)*8)
-#endif
+enum regnames32 {
+	GDB_PS = 34,
+	GDB_CS,
+	GDB_SS,
+};
+#define NUMREGBYTES		((GDB_SS+1)*4)
+#endif /* CONFIG_X86_32 */
 
 static inline void arch_kgdb_breakpoint(void)
 {
-- 
1.6.0.90.g436ed.dirty

