Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYJGArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYJGArw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYJGAn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:60429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbYJGAnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:25 -0400
Date: Mon, 6 Oct 2008 17:38:18 -0700
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
Subject: [patch 20/71] x64, fpu: fix possible FPU leakage in error
	conditions
Message-ID: <20081007003818.GU3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x64-fpu-fix-possible-fpu-leakage-in-error-conditions.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/signal_64.c |   11 ++++++++++-
 arch/x86/kernel/traps_64.c  |    9 ++++++++-
 include/asm-x86/i387.h      |    2 --
 3 files changed, 18 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -104,7 +104,16 @@ static inline int restore_i387(struct _f
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
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1141,7 +1141,14 @@ asmlinkage void math_state_restore(void)
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
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -63,8 +63,6 @@ static inline int restore_fpu_checking(s
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
-		init_fpu(current);
 	return err;
 }
 

-- 
