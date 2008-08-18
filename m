Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYHRSkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYHRSkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHRSkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:40:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48170 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYHRSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:40:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,229,1217833200"; 
   d="scan'208";a="607689256"
Message-Id: <20080818183605.860693000@linux-os.sc.intel.com>
References: <20080818183605.719267000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Aug 2008 11:35:47 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: greg@kroah.com, mingo@elte.hu
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [stable 2/2] x64, fpu: fix possible FPU leakage in error conditions
Content-Disposition: inline; filename=fix_fpu_leakage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Upstream commit: 6ffac1e90a17ea0aded5c581204397421eec91b6]

On Thu, Jul 24, 2008 at 03:43:44PM -0700, Linus Torvalds wrote:
> So how about this patch as a starting point? This is the RightThing(tm) to
> do regardless, and if it then makes it easier to do some other cleanups,
> we should do it first. What do you think?

restore_fpu_checking() calls init_fpu() in error conditions.

While this is wrong(as our main intention is to clear the fpu state of
the thread), this was benign before commit 92d140e21f1 ("x86: fix taking
DNA during 64bit sigreturn").

Post commit 92d140e21f1, live FPU registers may not belong to this
process at this error scenario.

In the error condition for restore_fpu_checking() (especially during the
64bit signal return), we are doing init_fpu(), which saves the live FPU
register state (possibly belonging to some other process context) into
the thread struct (through unlazy_fpu() in init_fpu()). This is wrong
and can leak the FPU data.

For the signal handler restore error condition in restore_i387(), clear
the fpu state present in the thread struct(before ultimately sending a
SIGSEGV for badframe).

For the paranoid error condition check in math_state_restore(), send a
SIGSEGV, if we fail to restore the state.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <stable@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

Index: linux-2.6.26.2/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6.26.2.orig/arch/x86/kernel/signal_64.c	2008-08-18 11:16:43.000000000 -0700
+++ linux-2.6.26.2/arch/x86/kernel/signal_64.c	2008-08-18 11:16:50.000000000 -0700
@@ -104,7 +104,16 @@
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
Index: linux-2.6.26.2/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.26.2.orig/arch/x86/kernel/traps_64.c	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/arch/x86/kernel/traps_64.c	2008-08-18 11:17:43.000000000 -0700
@@ -1141,7 +1141,14 @@
 	}
 
 	clts();			/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+ 	/*
+ 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+ 	 */
+ 	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+ 		stts();
+ 		force_sig(SIGSEGV, me);
+ 		return;
+ 	}
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
Index: linux-2.6.26.2/include/asm-x86/i387.h
===================================================================
--- linux-2.6.26.2.orig/include/asm-x86/i387.h	2008-08-18 11:16:43.000000000 -0700
+++ linux-2.6.26.2/include/asm-x86/i387.h	2008-08-18 11:16:50.000000000 -0700
@@ -62,8 +62,6 @@
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
-		init_fpu(current);
 	return err;
 }
 

-- 

