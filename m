Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYEPN1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYEPN1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbYEPN1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:27:42 -0400
Received: from aun.it.uu.se ([130.238.12.36]:61289 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163AbYEPN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:27:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18477.35703.679574.760417@harpo.it.uu.se>
Date: Fri, 16 May 2008 15:26:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       andi@firstfloor.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <20080513011030.GA31448@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha writes:
 > hi,
 > 
 > Appended patch adds the support for xsave/xrstor infrastructure for x86.
 > xsave/xrstor manages the existing and future processor extended states in x86
 > architecutre.
 > 
 > More info on xsave/xrstor can be found in the Intel SDM's located at
 > http://www.intel.com/products/processor/manuals/index.htm
 > 
 > Please let me know your feedback and comments. Specifically, I am not sure
 > if I break anything or make anyone's life harder with the ucontext_t extensions
 > that are proposed in the patch.

This is a large patch, and somewhat difficult to review since it mixes
kernel-private and user-visible changes. I'm going to focus on the
user-visible changes.

 > BTW, Traditionally glibc has this definition for struct ucontext.

glibc's definition is irrelevant, in part because glibc can and does lie
about kernel types to applications, and in part because glibc is not the
only user-space consumer of kernel types: there are other libcs, and there
are user-space virtualisation tools (my interest in this matter) that care
deeply about kernel types and sigframe layouts. In particular, user-space
needs to be able to copy and assemble sigframes.

So however the xsave support ends up looking, user-space must have a
sensible way of detecting and handling the layout changes.

 > --- linux-2.6-x86.orig/include/asm-x86/ucontext.h	2008-05-12 13:09:03.000000000 -0700
 > +++ linux-2.6-x86/include/asm-x86/ucontext.h	2008-05-12 15:15:12.000000000 -0700
 > @@ -6,7 +6,10 @@
 >  	struct ucontext  *uc_link;
 >  	stack_t		  uc_stack;
 >  	struct sigcontext uc_mcontext;
 > -	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 > +	sigset_t	  uc_sigmask;
 > +	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
 > +	int		  __unused[32 - (sizeof (sigset_t) / sizeof (int))];
 > +	struct xstate_cntxt  uc_xstate;
 >  };
 >  
 >  #endif /* _ASM_X86_UCONTEXT_H */

You're changing the layout of struct ucontext in two ways: uc_mcontext
changes elsewhere, and you're adding __unused and uc_xstate.

How is user-space supposed to know whether it's looking at a current
layout ucontext or an xsave-layout ucontext?

It seems that uc_flags is unused and always zero. Could you define a
flag bit (e.g. 1) for uc_flags to indicate the xsave layout?

 > --- linux-2.6-x86.orig/arch/x86/kernel/sigframe.h	2008-05-12 13:09:02.000000000 -0700
 > +++ linux-2.6-x86/arch/x86/kernel/sigframe.h	2008-05-12 13:09:56.000000000 -0700
 > @@ -3,9 +3,10 @@
 >  	char __user *pretcode;
 >  	int sig;
 >  	struct sigcontext sc;
 > -	struct _fpstate fpstate;
 > +	struct xstate_cntxt xst_cnxt;
 >  	unsigned long extramask[_NSIG_WORDS-1];
 >  	char retcode[8];
 > +	/* fp and rest of the extended context state follows here */
 >  };

Offset to extramask[] and retcode changes, as well as the size of the structure.

Why contract xstate_cntxt to xst_cnxt? That just obscures things.

 > --- linux-2.6-x86.orig/include/asm-x86/sigcontext.h	2008-05-12 13:09:03.000000000 -0700
 > +++ linux-2.6-x86/include/asm-x86/sigcontext.h	2008-05-12 14:54:21.000000000 -0700
 > @@ -202,4 +202,26 @@
 >  
 >  #endif /* !__i386__ */
 >  
 > +struct _xsave_hdr_struct {
 > + 	u64 xstate_bv;
 > + 	u64 reserved1[2];
 > + 	u64 reserved2[5];
 > +} __attribute__((packed));
 > +
 > +struct _xstate {
 > +	/*
 > +	 * Applications need to refer to fpstate through fpstate pointer
 > +	 * in sigcontext. Not here directly.
 > +	 */
 > + 	struct _fpstate fpstate;
 > + 	struct _xsave_hdr_struct xsave_hdr;
 > + 	/* new processor state extensions will go here */
 > +} __attribute__ ((aligned (64)));
 > +
 > +struct xstate_cntxt {
 > +	struct  _xstate __user *xstate;
 > +	u32	size;
 > +	u32 	lmask;
 > +	u32	hmask;
 > +};
 >  #endif

What is the purpose of the xstate pointer in xstate_cntxt?
As far as I can tell, it's redundant and can alway be derived
from the ucontext's uc_mcontext.fpstate pointer.

On x86-64 we have:

 > --- linux-2.6-x86.orig/arch/x86/kernel/signal_64.c	2008-05-12 13:09:02.000000000 -0700
 > +++ linux-2.6-x86/arch/x86/kernel/signal_64.c	2008-05-12 13:09:56.000000000 -0700
...
 >  	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
 > +
 > +	if (cpu_has_xsave) {
 > +		err |= __put_user(fp, &frame->uc.uc_xstate.xstate);
 > +		err |= __put_user(xstate_size, &frame->uc.uc_xstate.size);
 > +		err |= __put_user(pcntxt_lmask, &frame->uc.uc_xstate.lmask);
 > +		err |= __put_user(pcntxt_hmask, &frame->uc.uc_xstate.hmask);
 > +	} else {
 > +		err |= __put_user(0, &frame->uc.uc_xstate.xstate);

and on x86-32 we have:

 > --- linux-2.6-x86.orig/arch/x86/kernel/signal_32.c	2008-05-12 13:09:02.000000000 -0700
 > +++ linux-2.6-x86/arch/x86/kernel/signal_32.c	2008-05-12 13:09:56.000000000 -0700
...
 > -get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 > +get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 > +	     struct _fpstate **fpstate, struct xsave_struct **xstate)
...
 > -	sp -= frame_size;
 > +	if (used_math()) {
 > +		sp = round_down(sp - xstate_size, 64);
 > +		if (cpu_has_xsave)
 > +			*xstate = (struct xsave_struct *) sp;
 > +
 > +		sp = sp - (sizeof(struct _fpstate) - FXSAVE_SIZE);
 > +
 > +		*fpstate = (struct _fpstate *) sp;
 > +
 > +		sp -= frame_size;
 > +	} else
 > +		sp -= frame_size;
...(in setup_frame())
 > -	err = setup_sigcontext(&frame->sc, &frame->fpstate, regs, set->sig[0]);
 > +	err = setup_sigcontext(&frame->sc, regs, set->sig[0],
 > +			       fpstate, xstate);
 >  	if (err)
 >  		goto give_sigsegv;
 > +	if (cpu_has_xsave) {
 > +		err |= __put_user(xstate, &frame->xst_cnxt.xstate);
 > +		err |= __put_user(xstate_size, &frame->xst_cnxt.size);
 > +		err |= __put_user(pcntxt_lmask, &frame->xst_cnxt.lmask);
 > +		err |= __put_user(pcntxt_hmask, &frame->xst_cnxt.hmask);
 > +	} else {
 > +		err |= __put_user(0, &frame->xst_cnxt.xstate);
...(in setup_rt_frame())
 > -	err |= setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
 > -				regs, set->sig[0]);
 > +	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0],
 > +				fpstate, xstate);
 > +	if (cpu_has_xsave) {
 > +		err |= __put_user(xstate, &frame->uc.uc_xstate.xstate);
 > +		err |= __put_user(xstate_size, &frame->uc.uc_xstate.size);
 > +		err |= __put_user(pcntxt_lmask, &frame->uc.uc_xstate.lmask);
 > +		err |= __put_user(pcntxt_hmask, &frame->uc.uc_xstate.hmask);
 > +	} else {
 > +		err |= __put_user(0, &frame->uc.uc_xstate.xstate);

In all cases .xstate seems to be a function of fpstate and cpu_has_xsave.

And why does x86-64 make xstate == fpstate while on x86-32 they're at an
offset from each other?

The fpstate pointer may be pointing into a struct _xstate.
How is user-space supposed to know if this is the case?

struct _fpstate has a 'magic' field which distinguishes x87-only
from x87+FXSR structs. Could that field also be used to indicate XSAVE?

How is user-space supposed to know how large the _xstate struct is?
Is that the size field in the struct xstate_cntxt?

 > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
 > +++ linux-2.6-x86/arch/x86/kernel/xsave.c	2008-05-12 13:09:56.000000000 -0700
...
 > +	/*
 > +	 * FP and SSE state can't be restored directly from the userspace
 > +	 * because of legacy reasons. Lets restore it to the fpstate
 > +	 * in the task struct.
 > +	 */

Can you please explain what those 'legacy reasons' are?

 > --- linux-2.6-x86.orig/arch/x86/kernel/signal_32.c	2008-05-12 13:09:02.000000000 -0700
 > +++ linux-2.6-x86/arch/x86/kernel/signal_32.c	2008-05-12 13:09:56.000000000 -0700
...(in setup_frame)
 >  
 > -	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 > +	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 >  		goto give_sigsegv;

Gratuitous whitespace change.

I know xsave will be needed once AVX is released to the masses.
Any idea on when that will happen?

/Mikael
