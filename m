Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYGXWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYGXWrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYGXWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:47:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYGXWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:47:07 -0400
Date: Thu, 24 Jul 2008 15:43:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724222523.GN14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
 <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org>
 <20080724222523.GN14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
> > 
> > but the thing is, the only really valid reason for "restore_i387()" to
> > fail is because the read failed.
> 
> Not really. It can cause #GP, if someone sets reserved bits of mxcsr
> in the memory image.

Ahh, ok, I can imagine that. And I guess we might copy the data from user 
space into the memory image without validating it at points (signal 
handler restore and/or ptrace). Do we?

> But restore_i387() may be in an insane state (we did clts() but doesn't
> have the proper state in its live registers etc) when it failed to restore fpu.
> Ideally we should fix this inside restore_i387(). But restore_i387()
> is in header file and I have to re-arrange some of the code
> in the header file, to call clear_fpu() from restore_i387().

Ok, how about we just move restore_i387() out of the header file? I 
realize that the x86 code plays some games with this whole thing (that 
whole '#define restore_i387_ia32 restore_i387'), but that is 32-bit 
specific, and the restore_i387() in the header file is 64-bit specific. 

Hmm. In fact, I think that x86-64 version is actually only used in a 
single place - arch/x86/kernel/signal_64.c. So it's actively *wrong* to 
have that thing in a header file to begin with!

So how about this patch as a starting point? This is the RightThing(tm) to 
do regardless, and if it then makes it easier to do some other cleanups, 
we should do it first. What do you think?

		Linus

---
 arch/x86/kernel/signal_64.c |   20 ++++++++++++++++++++
 include/asm-x86/i387.h      |   21 ---------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 47c3d24..c40ddcb 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -53,6 +53,26 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+static inline int restore_i387(struct _fpstate __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+}
 
 /*
  * Do a signal return; undo the signal stack.
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 37672f7..a355264 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -170,27 +170,6 @@ static inline int save_i387(struct _fpstate __user *buf)
 	return 1;
 }
 
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-}
-
 #else  /* CONFIG_X86_32 */
 
 extern void finit(void);
