Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYJGArf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYJGArf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYJGAnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:23 -0400
Received: from ns.suse.de ([195.135.220.2]:46712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbYJGAnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:21 -0400
Date: Mon, 6 Oct 2008 17:38:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 19/71] x86-64: Clean up save/restore_i387() usage
Message-ID: <20081007003815.GT3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-64-clean-up-save-restore-i387-usage.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 arch/x86/kernel/signal_64.c |   53 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/i387.h      |   54 --------------------------------------------
 2 files changed, 53 insertions(+), 54 deletions(-)

--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -53,6 +53,59 @@ sys_sigaltstack(const stack_t __user *us
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
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -138,60 +138,6 @@ static inline void __save_init_fpu(struc
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

-- 
