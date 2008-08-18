Return-Path: <linux-kernel-owner+w=401wt.eu-S1763401AbYHRTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763401AbYHRTdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762014AbYHRTcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:32:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:37761 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbYHRTcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:32:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,230,1217833200"; 
   d="scan'208";a="34906764"
Date: Mon, 18 Aug 2008 12:32:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [stable 1/2] x86-64: Clean up save/restore_i387() usage
Message-ID: <20080818193217.GA1152@linux-os.sc.intel.com>
References: <20080818183605.719267000@linux-os.sc.intel.com> <alpine.LFD.1.10.0808181146540.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808181146540.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:48:12AM -0700, Linus Torvalds wrote:
> 
> On Mon, 18 Aug 2008, Suresh Siddha wrote:
> >
> > [Upstream commit: b30f3ae50cd03ef2ff433a5030fbf88dd8323528]
> 
> And it's authorship got destroyed by you.
> 
> Please guys, add teh proper "From:" line at the top. Don't forward patches
> like this unattributed. It doesn't matter if they are trivial or not, it's
> just really bad form.

Sorry! Noticed it while sending but ignored. Will fix up my scripts
accordingly.

Greg, please ignore the earlier patch titled,
	[stable 1/2] x86-64: Clean up save/restore_i387() usage

And accept the appended one, instead: Thanks.
---
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: x86-64: Clean up 'save/restore_i387()' usage

    [ Upstream commit b30f3ae50cd03ef2ff433a5030fbf88dd8323528]

    Suresh Siddha wants to fix a possible FPU leakage in error conditions,
    but the fact that save/restore_i387() are inlines in a header file makes
    that harder to do than necessary.  So start off with an obvious cleanup.
    
    This just moves the x86-64 version of save/restore_i387() out of the
    header file, and moves it to the only file that it is actually used in:
    arch/x86/kernel/signal_64.c.  So exposing it in a header file was wrong
    to begin with.
    
    [ Side note: I'd like to fix up some of the games we play with the
      32-bit version of these functions too, but that's a separate
      matter.  The 32-bit versions are shared - under different names
      at that! - by both the native x86-32 code and the x86-64 32-bit
      compatibility code ]
    
    Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 47c3d24..b45ef8d 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -53,6 +53,59 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+/*
+ * Signal frame handlers.
+ */
+
+static inline int save_i387(struct _fpstate __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
+			sizeof(tsk->thread.xstate->fxsave));
+
+	if ((unsigned long)buf % 16)
+		printk("save_i387: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		err = save_i387_checking((struct i387_fxsave_struct __user *)
+					 buf);
+		if (err)
+			return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   sizeof(struct i387_fxsave_struct)))
+			return -1;
+	}
+	return 1;
+}
+
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
index 37672f7..96fa844 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -137,60 +137,6 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-/*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
-}
-
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
