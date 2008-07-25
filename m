Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYGYBIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYGYBIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYGYBH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:07:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:17696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYGYBH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,249,1215414000"; 
   d="scan'208";a="318934806"
Date: Thu, 24 Jul 2008 18:07:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080725010755.GQ14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org> <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org> <20080724222523.GN14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241532240.8109@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> So how about this patch as a starting point? This is the RightThing(tm) to
> do regardless, and if it then makes it easier to do some other cleanups,
> we should do it first. What do you think?

Linus, Attached is my last attempt for the day. Please review. Thanks.
---

restore_fpu_checking() calls init_fpu() in error conditions.
While this is wrong(as our main intention is to clear the fpu state
of the thread), this was benign before the commit
92d140e21f1ce8cf99320afbbcad73879128e6dc.

Post commit 92d140e21f1ce8cf99320afbbcad73879128e6dc, live FPU registers
may not belong to this process at this error scenario.

In the error condition for restore_fpu_checking() (especially during
the 64bit signal return), we are doing init_fpu(), which saves the live
FPU register state (possibly belonging to some other process context) into the
thread struct (through unlazy_fpu() in init_fpu()). This is wrong and can leak
the FPU data.

For the signal handler restore error condition in restore_i387(), clear the fpu
state present in the thread struct(before ultimately sending a SIGSEGV for
badframe).

For the paranoid error condition check in math_state_restore(), send a
SIGSEGV, if we fail to restore the state.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index b45ef8d..ca316b5 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -104,7 +104,16 @@ static inline int restore_i387(struct _fpstate __user *buf)
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
 	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+	if (unlikely(err)) {
+		/*
+		 * Encountered an error while doing the restore from the
+		 * user buffer, clear the fpu state.
+		 */
+		clear_fpu(tsk);
+		clear_used_math();
+	}
+	return err;
 }
 
 /*
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3f18d73..513caac 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1131,7 +1131,14 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+		stts();
+		force_sig(SIGSEGV, me);
+		return;
+	}
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 96fa844..0048fb7 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -62,8 +62,6 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
-		init_fpu(current);
 	return err;
 }
 
