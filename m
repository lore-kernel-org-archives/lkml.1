Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZF0OIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZF0OIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZF0OIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZF0OIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] score: fix function prototypes
Date: Sat, 27 Jun 2009 16:08:15 +0200
Message-Id: <bddc605955bca2d914ca621a7ef4ca6c271f55d8.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4rlQgIlvRPI2lPFvAYlEGLUkFKSzCAas8uTS
 FIejKWwi+t7k5SUi13zGkCgeIGx990NScog2ZCar6LbrnFhUqF
 10QSR/LtaEy1KpPlc7bsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syscalls should return 'long' and be marked as 'asmlinkage'.
Functions that are only used in a single file should be 'static'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/kernel/signal.c    |   22 +++++++++++++---------
 arch/score/kernel/sys_score.c |    5 +++--
 arch/score/kernel/time.c      |    2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index 1634aaa..afbfe33 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -42,7 +42,7 @@ struct rt_sigframe {
 	struct ucontext rs_uc;
 };
 
-int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 {
 	int err = 0;
 	unsigned long reg;
@@ -76,7 +76,7 @@ int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	return err;
 }
 
-int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+static int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 {
 	int err = 0;
 	u32 reg;
@@ -118,8 +118,8 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 /*
  * Determine which stack to use..
  */
-void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-			size_t frame_size)
+static void __user *get_sigframe(struct k_sigaction *ka,
+			struct pt_regs *regs, size_t frame_size)
 {
 	unsigned long sp;
 
@@ -134,7 +134,8 @@ void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	return (void __user*)((sp - frame_size) & ~7);
 }
 
-int score_sigaltstack(struct pt_regs *regs)
+asmlinkage long
+score_sigaltstack(struct pt_regs *regs)
 {
 	const stack_t __user *uss = (const stack_t __user *) regs->regs[4];
 	stack_t __user *uoss = (stack_t __user *) regs->regs[5];
@@ -143,7 +144,8 @@ int score_sigaltstack(struct pt_regs *regs)
 	return do_sigaltstack(uss, uoss, usp);
 }
 
-void score_rt_sigreturn(struct pt_regs *regs)
+asmlinkage long
+score_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	sigset_t set;
@@ -183,9 +185,11 @@ void score_rt_sigreturn(struct pt_regs *regs)
 
 badframe:
 	force_sig(SIGSEGV, current);
+
+	return 0;
 }
 
-int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
+static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 		int signr, sigset_t *set, siginfo_t *info)
 {
 	struct rt_sigframe __user *frame;
@@ -238,7 +242,7 @@ give_sigsegv:
 	return -EFAULT;
 }
 
-int handle_signal(unsigned long sig, siginfo_t *info,
+static int handle_signal(unsigned long sig, siginfo_t *info,
 	struct k_sigaction *ka, sigset_t *oldset, struct pt_regs *regs)
 {
 	int ret;
@@ -278,7 +282,7 @@ int handle_signal(unsigned long sig, siginfo_t *info,
 	return ret;
 }
 
-void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	struct k_sigaction ka;
 	sigset_t *oldset;
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 16ace29..5b3cc4e 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -34,7 +34,7 @@
 unsigned long shm_align_mask = PAGE_SIZE - 1;
 EXPORT_SYMBOL(shm_align_mask);
 
-asmlinkage unsigned long
+asmlinkage unsigned
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
 	  unsigned long flags, unsigned long fd, unsigned long pgoff)
 {
@@ -66,7 +66,8 @@ sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
  * Clone a task - this clones the calling program thread.
  * This is called indirectly via a small wrapper
  */
-int score_clone(struct pt_regs *regs)
+asmlinkage long
+score_clone(struct pt_regs *regs)
 {
 	unsigned long clone_flags;
 	unsigned long newsp;
diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
index cd66ba3..f0a43af 100644
--- a/arch/score/kernel/time.c
+++ b/arch/score/kernel/time.c
@@ -28,7 +28,7 @@
 
 #include <asm/scoreregs.h>
 
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evdev = dev_id;
 
-- 
1.6.3.1

