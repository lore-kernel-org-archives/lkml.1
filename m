Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0BDUaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:30:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:19023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0BDU3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:29:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,407,1262592000"; 
   d="scan'208";a="240579381"
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
In-Reply-To: <20100203230817.E6529AA@magilla.sf.frob.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	 <20100203230817.E6529AA@magilla.sf.frob.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 04 Feb 2010 12:28:49 -0800
Message-Id: <1265315329.2768.167.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 15:08 -0800, Roland McGrath wrote:
> Please also CC Oleg on things related to user_regset and/or ptrace,
> as per MAINTAINERS.

Sure.

> 
> Please make this two patches.  The first one should add the regset, which
> implicitly adds it to core dumps, and makes fixed the note layout aspect of
> the permanent userland ABI.  The second one should add the new ptrace
> requests, which is a further addition to the userland ABI.

Sure. Let's come to the agreement on the ABI changes and then I can
split the patches accordingly.

> 
> > For more information on how to use this API by users like debuggers and core
> > dump, please refer to comments in arch/x86/include/asm/ptrace-abi.h
> 
> There are some obvious typos in that comment.  Please fix those up.

Can you please elaborate?

> 
> > +int xstateregs_active(struct task_struct *target,
> > +		      const struct user_regset *regset)
> > +{
> > +	return (cpu_has_xsave && tsk_used_math(target)) ? xstate_size : 0;
> > +}
> 
> The return value here is "n" not "n * size", so xstate_size is wrong.  You
> can just use regset->n instead.  I'll further note that when !cpu_has_xsave,
> regset->n will be zero.  So all you really need is:
> 
> 	return tsk_used_math(target) ? regset->n : 0;
> 
> i.e., the same as fpregs_active.  So I would just use:
> 
> 	#define xstateregs_active	fpregs_active
> 
> with a comment explaining that they are same and why.

Makes sense.

> 
> > +	/*
> > +	 * First copy the fxsave bytes 0..463
> > +	 */
> > +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +				  &target->thread.xstate->xsave, 0,
> > +				  (sizeof(struct i387_fxsave_struct) -
> > +				   sizeof(xstate_fx_sw_bytes)));
> > +	/*
> > +	 * Copy the 48bytes defined by software
> > +	 */
> > +	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +				   xstate_fx_sw_bytes,
> > +				   (sizeof(struct i387_fxsave_struct) -
> > +				    sizeof(xstate_fx_sw_bytes)),
> > +				   sizeof(struct i387_fxsave_struct));
> > +	/*
> > +	 * Copy the rest of xstate memory layout
> > +	 */
> > +	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +				   &target->thread.xstate->xsave.xsave_hdr,
> > +				   sizeof(struct i387_fxsave_struct), -1);
> 
> This is wrong for the error cases.  user_regset_copyout returns an error
> code or 0, so "|=" is a strange thing to with its return value.  In fact,
> it only ever returns 0 or -EFAULT, so |= will produce the value you want.
> But | is a pretty strange thing to do with two error codes.
> 
> It's problematically wrong for a different reason.  In the error case,
> user_regset_copyout returns without updating pos, count, and ubuf (i.e.
> it returns having done nothing when returning an error, which is a pretty
> normal convention).  So, if the first call fails then the second call will
> have pos < start_pos and hit the BUG_ON.  IOW, be sure to test your new
> ptrace call with an invalid userland pointer (e.g. NULL) passed in.

oops. Will fix it.

> 
> In short, replace "ret |=" with "if (likely(!ret))\n\tret = ".
> 
> 
> This is up to you, but personally I would define something akin to:
> 
> 	struct xstate_info {
> 		union {
> 			struct i387_fxsave_struct fxsave;
> 			struct {
> 				u64 i387[58];
> 				u64 xstate_fx_sw[XSTATE_FX_SW_WORDS];
> 			};
> 		};
> 		struct xsave_hdr_struct xsave_hdr;
> 		u64 xsave_state[0];
> 	};
> 
> and then use offsetof rather than manual arithmetic in those
> user_regset_copyout calls.  IMHO it would be better to have this in
> ptrace-abi.h along with some macros for what the fx_sw indices are (I guess
> only 0 is defined now, but whatever) rather than relegate that info to
> magic numbers in a comment and userland code doing manual arithmetic.
> But even if you just put it locally in ptrace.c, it makes the ptrace
> code less prone to possible arithmetic typos.

Agree. Will update it.

> 
> 
> > +	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
> > +		return copy_regset_to_user(child,
> > +					   task_user_regset_view(current),
> > +					   REGSET_XSTATE,
> > +					   0, xstate_size,
> > +					   datap);
> > +
> > +	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
> > +		return copy_regset_from_user(child,
> > +					     task_user_regset_view(current),
> > +					     REGSET_XSTATE,
> > +					     0, xstate_size,
> > +					     datap);
> 
> I think this is a poor choice of interface for this.  The other existing
> PTRACE_GET*REGS calls use a fixed-size and fixed-layout block that is a
> known constant in the userland ABI.  Here, userland has no way to know
> xstate_size, so you are accessing a chunk of user memory where userland
> doesn't really know how much you are going to access.
> 
> AFAICT from skimming the Intel manuals, there is no specified upper bound
> on how big the xsave size might grow in future processors.  I would think
> that it might be limited to a page, since there is no way to indicate a
> partial copy to restart after a page fault.  So for unpinned access (such
> as in user mode, or the user memory access in the signal frame setup), in
> full-thrashing situations an xsave spanning multiple pages might thrash
> totally and never make progress.  OTOH, the manual does not say that the
> buffer can't span two pages today, just that it has to be 64-byte aligned.
> So perhaps we already have that issue (for signal frame setup or for direct
> user-space uses of xsave/xrstor) and it's just not really an issue that
> matters (thrashing is thrashing--it's already pathological, so who cares if
> it's literal livelock or not).  

This issue is not new and gets handled in the same way as for existing
fxsave/fxrstor, as they don't specify page alignment restrictions.

> The upshot being, I don't think there is an
> obvious upper bound that userland can presume statically here.
> 
> AFAICT, the only way for userland to guess xstate_size is to use cpuid
> itself.  Even if that is actually reliable, or even if the kernel gave
> userland some other means to know the kernel's xstate_size value, IMHO that
> is a pretty dubious and error-prone way to construct the ABI.  Usually when
> userland supplies a buffer whose size is not a permanent constant of the
> ABI, userland says how big a buffer it's passing in.
> 
> The most obvious change would be just s/xstate_size/MIN(addr, xstate_size)/.
> i.e. userland passes in the maximum size it wants in the other argument.

Ok. I would like to enforce that "addr == xstate_size", so that we don't
have to complicate the kernel implementation in trying to interpret what
state the user knows based on the size passed by the user etc. User
should use cpuid to get the size of the xstate buffer supported by the
OS and processor. Kernel can check and throw an error with out silently
corrupting the user who is not following the requirements.

> But IMHO this is a fine opportunity not to add another one-off request for
> a particular regset type, and then never add another one again.  Instead,
> we can add a general-purpose request to handle any regset based on what is
> already part of the userland ABI: the NT_* codes and the regset layouts
> they imply on each machine.
> 
> e.g.
> 	struct iovec iov = { mybuffer, mylength };
> 	ret = ptrace(PTRACE_GETREGSET, NT_X86_XSTATE, &iov);
> 
> or something along those lines.  We could implement a generic
> PTRACE_GETREGSET and PTRACE_SETREGSET in {,compat_}ptrace_request() on
> CONFIG_HAVE_ARCH_TRACEHOOK machines.  
> 
> Then all any arch ever has to do in future is just define a new user_regset
> in its user_regset_view for a new thing.
> 
> I'll make Oleg implement it if you don't do it yourself ;-).  We can all
> work out together exactly what the interface should be, I don't have any
> special fixed ideas.

We probably have to extend regset infrastructure to track which NT_*
types are part of PTRACE_[GET|SET]REGSET and which are not. Also, I am
not sure if pushing the ptrace interpretation of the user pointer into
the regset routines is a good idea. Potentially this regset get/set
routines can be used by signal handling (in addition to kernel core dump
etc) aswell and for compatibility reasons etc their format might be
different from ptrace. Your idea sounds like a good idea in-general and
if there is a clean interface, then I can work with Oleg to make this
generic for future.

thanks,
suresh

