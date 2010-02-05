Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0BEMoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0BEMoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:44:44 -0500
Date: Fri, 5 Feb 2010 13:44:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? process_32.c:__switch_to() calls __math_state_restore()
	before updating current_task
Message-ID: <20100205124407.GA24974@redhat.com>
References: <20100204165105.GA5905@redhat.com> <1265305253.2768.7.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265305253.2768.7.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Suresh Siddha wrote:
>
> On Thu, 2010-02-04 at 08:51 -0800, Oleg Nesterov wrote:
> >
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -377,9 +377,6 @@ __switch_to(struct task_struct *prev_p,
> >  	 */
> >  	arch_end_context_switch(next_p);
> >
> > -	if (preload_fpu)
> > -		__math_state_restore();
> > -
> >  	/*
> >  	 * Restore %gs if needed (which is common)
> >  	 */
> > @@ -388,6 +385,9 @@ __switch_to(struct task_struct *prev_p,
> >
> >  	percpu_write(current_task, next_p);
> >
> > +	if (preload_fpu)
> > +		__math_state_restore();
> > +
> >  	return prev_p;
> >  }
>
> Oleg, __math_state_restore() uses current_thread_info() which at that
> point already has the right esp and as such uses the correct thread
> struct etc.

Ah, indeed. I didn't notice that, unlike X86_64, X86_32 uses esp, not
kernel_stack to get thread_info, and __math_state_restore() pathes never
use get_current().

> After saying that, in the past I have also ran into this question and
> got satisfied by looking deeper. Best is to make the 32bit and 64bit
> code similar as much as possible and as such your patch is acceptable.
>
> Can you please re-post with a proper changelog (and ofcourse testing
> etc)? You can add my Ack to that.

OK, will do once I have a 32bit machine to test.

Thanks a lot for your explanation!


Could you please explain me another issue? I know nothing about fpu
handling, I am reading this code trying to understand the unrelated
bug with the old kernel.

In short: why restore_i387_xstate() does init_fpu() when !used_math(),
can't (or shouldn't) it merely do set_used_math() ?

	restore_i387_xstate:
		
		if (!used_math()) {
			err = init_fpu(tsk);
			if (err)
				return err;
		}

note that buf != NULL. This means that used_math() was true when
get_sigframe() was called, otherwise buf == sigcontext->fpstate
would be NULL, right?

So, the task must have the valid ->thread.xstate, and init_fpu()
just resets the contents of *thread.xstate. Why? We are going to
reload the FPU registers and set TS_USEDFPU. This means .xstate
must be never used until we save the FPU registers back, correct?

IOW, I'd appreciate very much if you can explain me why the patch
below is wrong. To clarify, even if the patch is correct I do not
mean it is really needed, I am just trying to understand what I
have missed here.

Thanks,

Oleg.

--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -215,11 +215,7 @@ int restore_i387_xstate(void __user *buf
 		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
 			return -EACCES;
 
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
+	set_stopped_child_used_math(tsk);
 
 	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
 		clts();

