Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYAKKoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYAKKoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYAKKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:44:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYAKKob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:44:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] x86_64 save_i387_ia32 snafu
In-Reply-To: H. Peter Anvin's message of  Thursday, 10 January 2008 18:58:03 -0800 <4786DB3B.8070808@zytor.com>
References: <4786A9CA.2090008@zytor.com>
	<20080111004422.2B3F926F9A6@magilla.localdomain>
	<4786BE15.6040604@zytor.com>
	<20080111024929.37FDB26F9A9@magilla.localdomain>
	<4786DB3B.8070808@zytor.com>
X-Shopping-List: (1) Astronomical gumption
   (2) Romantic incantation sugar
   (3) Inelastic casino pigs
Message-Id: <20080111104357.8364826F9A9@magilla.localdomain>
Date: Fri, 11 Jan 2008 02:43:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about this one, mea culpa.  This should go right after
the "x86 i387 user_regset" patch, or be rolled into it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32_signal.c |    5 ++---
 arch/x86/kernel/ptrace.c    |    1 -
 include/asm-x86/fpu32.h     |   10 ----------
 include/asm-x86/i387.h      |    6 ++++++
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0e24e3f..0a34c24 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -29,7 +29,6 @@
 #include <asm/ia32_unistd.h>
 #include <asm/user32.h>
 #include <asm/sigcontext32.h>
-#include <asm/fpu32.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
 
@@ -258,7 +257,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	if (buf) {
 		if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
 			goto badframe;
-		err |= restore_i387_ia32(current, buf, 0);
+		err |= restore_i387_ia32(buf);
 	} else {
 		struct task_struct *me = current;
 
@@ -377,7 +376,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user((u32)regs->flags, &sc->flags);
 	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_ia32(current, fpstate, regs, 0);
+	tmp = save_i387_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
 	else {
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5d7d82f..96286df 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -981,7 +981,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 #include <linux/compat.h>
 #include <linux/syscalls.h>
 #include <asm/ia32.h>
-#include <asm/fpu32.h>
 #include <asm/user32.h>
 
 #define R32(l,q)							\
diff --git a/include/asm-x86/fpu32.h b/include/asm-x86/fpu32.h
deleted file mode 100644
index 4153db5..0000000
--- a/include/asm-x86/fpu32.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _FPU32_H
-#define _FPU32_H 1
-
-struct _fpstate_ia32;
-
-int restore_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, int fsave);
-int save_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, 
-		   struct pt_regs *regs, int fsave);
-
-#endif
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 3f4c4a5..ba8105c 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -28,6 +28,12 @@ extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
+#ifdef CONFIG_IA32_EMULATION
+struct _fpstate_ia32;
+extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
+extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
+#endif
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
