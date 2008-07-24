Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYGXVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYGXVZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYGXVYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:24:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:12466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYGXVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:24:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="600735657"
Date: Thu, 24 Jul 2008 14:23:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724212351.GM14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org> <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 01:30:51PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 24 Jul 2008, Suresh Siddha wrote:
> >
> > Only the first init_fpu() can fail (memory allocation failure). But here,
> > it is def not the first time.
> 
> Ahh. Agreed. I missed that. But yes, clear_fpu() is still preferable, I
> think.

Appended the patch(tested) with modified changelog. restore_i387() for
64bit is in the header file, which complicates calling clear_fpu().

To simplify, I am doing the error check at the caller sites in c files.

I am planning to clean (move the 64-bit save/restore_i387() to c files etc)
some of this up in the upcoming xsave/xrstor patchset anyhow.

Meanwhile, I wanted to keep this patch simple, so that it can be easily
applied to -stable series aswell.

thanks,
suresh
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

For the error conditions in restore_fpu_checking(), clear the fpu
state present in the thread struct.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index bf87684..672f35a 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -96,15 +96,25 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	}
 
 	{
+		int ret = 0;
 		struct _fpstate __user * buf;
 		err |= __get_user(buf, &sc->fpstate);
 
 		if (buf) {
 			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
 				goto badframe;
-			err |= restore_i387(buf);
-		} else {
+			ret = restore_i387(buf);
+		}
+		
+		/*
+		 * clear the fpu state if there is no math info found in the
+		 * sigcontext, or we encountered an error while restoring
+		 * it.
+		 */
+		if (!buf || ret) {
 			struct task_struct *me = current;
+
+			err |= ret;
 			if (used_math()) {
 				clear_fpu(me);
 				clear_used_math();
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3f18d73..6abf39c 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1131,7 +1131,18 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+	/*
+	 * Paranoid restore. If it fails, we return with math state cleared.
+	 * Next attempt to restore will init the state and continue.
+	 */
+	if (restore_fpu_checking(&me->thread.xstate->fxsave)) {
+		stts();		/* TS_USEDFPU is still not set, hence
+				 * clear_fpu() doesn't achieve what we want
+				 * here. stts() is enough.
+				 */
+		clear_used_math();
+		return;
+	}
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 37672f7..d46d591 100644
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
 
