Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYEESB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYEESB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYEESBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:01:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:34982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYEESBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=NRUZD00lHwCLNl9MoX5ipnAnH+224hglBGIIRIecQAF/BP4NfwydxnY/WeW0Eva3oqx2peT2yepF4BPpqQufecFoGrAULQws6QfBdCmfJOpm/93mxI5Lc5U9LVWYZ/IGah8mIYBGJ4nWRtzDvbqvKvG+mbVko48W3AT98iK35Hs=
Date: Mon, 5 May 2008 20:00:53 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: Oops with strace_test
Message-ID: <20080505180053.GB5576@slug>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505100008.GA2354@alice>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 12:00:08PM +0200, Eric Sesterhenn wrote:
> * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > hi,
> > 
> > running the strace_test from ltp 20080229 (ltp.sf.net) gives me
> > two different oopses, so far i was not able to pinpoint to a specific
> > testcase (propably because the strace uses the rng to decided what fails
> > and what not) one oops is in iret_exc(), the other in __copy_from_user_ll()
> > The oopses dont happen with 2.6.24 so this appears to be a regression, i am starting
> > a git-bisect, but this might take some time
> > 
[...]
> 
> after some bisecting i found commit
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=aa283f49276e7d840a40fb01eee6de97eaa7e012;hp=61c4628b538608c1a85211ed8438136adfeb9a95
> to be guilty. After reverting this manually (didnt revert cleanly)
Hi Eric,

This appears to be caused by init_fpu() missing from the
restore_sigcontext->restore_i387->restore_fpu_checking code path.

I believe that moving the init_fpu() call from math_state_restore to
restore_fpu_checking should fix the problem?

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 8069073..5b1af48 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1142,22 +1142,6 @@ asmlinkage void math_state_restore(void)
 {
 	struct task_struct *me = current;
 
-	if (!used_math()) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(me)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
-	clts();			/* Allow maths ops (or we recurse) */
 	restore_fpu_checking(&me->thread.xstate->fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index da2adb4..bf1cabe 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -47,7 +47,20 @@ static inline void tolerant_fwait(void)
 
 static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 {
-	int err;
+	int err = -1;
+
+	if (!used_math()) {
+		local_irq_enable();
+		/*
+		 * does a slab alloc which can sleep
+		 */
+		if (init_fpu(current))
+			return err;
+		local_irq_disable();
+	}
+
+	clts();			/* Allow maths ops (or we recurse) */
 
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
 		     "2:\n"

