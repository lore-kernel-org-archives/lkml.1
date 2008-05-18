Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYERBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYERBeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYERBeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 21:34:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:5543 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYERBeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 21:34:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,502,1204531200"; 
   d="scan'208";a="282535115"
Date: Sat, 17 May 2008 18:34:16 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, andi@firstfloor.org, roland@redhat.com,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080518013416.GB30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18477.35703.679574.760417@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:26:15PM +0200, Mikael Pettersson wrote:
> This is a large patch, and somewhat difficult to review since it mixes
> kernel-private and user-visible changes.

Sorry. I wanted to give the complete picture. Will see if I can split it up
while posting for upstream.

> I'm going to focus on the user-visible changes.
> 
>  > BTW, Traditionally glibc has this definition for struct ucontext.
> 
> glibc's definition is irrelevant, in part because glibc can and does lie
> about kernel types to applications, and in part because glibc is not the
> only user-space consumer of kernel types: there are other libcs, and there
> are user-space virtualisation tools (my interest in this matter) that care
> deeply about kernel types and sigframe layouts. In particular, user-space
> needs to be able to copy and assemble sigframes.

Ok. I hope user-space is doing this copy and assemble in a (sane) way that
allows the kernel to modify the sigframe with out  breaking old apps.

Do you know how the user-space is determining how much to copy today?

I have to probably use some magic values(or other flags), indicating the
presence of extended state context information in the ucontext.

> So however the xsave support ends up looking, user-space must have a
> sensible way of detecting and handling the layout changes.

cpuid information (cpuid.0x1.ecx.osxsave) indicates whether the
OS supports xsave or not. This can be one way, that signal handlers
can use to interpret the ucontext.

Given that it is more than signal handlers, I can add a flag also,
representing ucontext extensions.

>  > --- linux-2.6-x86.orig/include/asm-x86/ucontext.h	2008-05-12 13:09:03.000000000 -0700
>  > +++ linux-2.6-x86/include/asm-x86/ucontext.h	2008-05-12 15:15:12.000000000 -0700
>  > @@ -6,7 +6,10 @@
>  >  	struct ucontext  *uc_link;
>  >  	stack_t		  uc_stack;
>  >  	struct sigcontext uc_mcontext;
>  > -	sigset_t	  uc_sigmask;	/* mask last for extensibility */
>  > +	sigset_t	  uc_sigmask;
>  > +	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
>  > +	int		  __unused[32 - (sizeof (sigset_t) / sizeof (int))];
>  > +	struct xstate_cntxt  uc_xstate;
>  >  };
>  >  
>  >  #endif /* _ASM_X86_UCONTEXT_H */
> 
> You're changing the layout of struct ucontext in two ways: uc_mcontext
> changes elsewhere, and you're adding __unused and uc_xstate.

I am not changing the uc_mcontext (struct sigcontext). Just extending
the ucontext.

> 
> How is user-space supposed to know whether it's looking at a current
> layout ucontext or an xsave-layout ucontext?
> 
> It seems that uc_flags is unused and always zero. Could you define a
> flag bit (e.g. 1) for uc_flags to indicate the xsave layout?

Sure. I can even add a magic word to indicate the xsave presence,
so that sigreturn can be double sure and not break older apps.

>  > --- linux-2.6-x86.orig/arch/x86/kernel/sigframe.h	2008-05-12 13:09:02.000000000 -0700
>  > +++ linux-2.6-x86/arch/x86/kernel/sigframe.h	2008-05-12 13:09:56.000000000 -0700
>  > @@ -3,9 +3,10 @@
>  >  	char __user *pretcode;
>  >  	int sig;
>  >  	struct sigcontext sc;
>  > -	struct _fpstate fpstate;
>  > +	struct xstate_cntxt xst_cnxt;
>  >  	unsigned long extramask[_NSIG_WORDS-1];
>  >  	char retcode[8];
>  > +	/* fp and rest of the extended context state follows here */
>  >  };
> 
> Offset to extramask[] and retcode changes, as well as the size of the structure.

hm yes. this will break the restore of extramask[], for apps which set their
own sig return frames.

I can leave _fpstate as it is(and unused) and move xstate context (which
will contain fpstate + the extended state) after extramask[].

> Why contract xstate_cntxt to xst_cnxt? That just obscures things.

ok.

> 
>  > --- linux-2.6-x86.orig/include/asm-x86/sigcontext.h	2008-05-12 13:09:03.000000000 -0700
>  > +++ linux-2.6-x86/include/asm-x86/sigcontext.h	2008-05-12 14:54:21.000000000 -0700
>  > @@ -202,4 +202,26 @@
>  >  
>  >  #endif /* !__i386__ */
>  >  
>  > +struct _xsave_hdr_struct {
>  > + 	u64 xstate_bv;
>  > + 	u64 reserved1[2];
>  > + 	u64 reserved2[5];
>  > +} __attribute__((packed));
>  > +
>  > +struct _xstate {
>  > +	/*
>  > +	 * Applications need to refer to fpstate through fpstate pointer
>  > +	 * in sigcontext. Not here directly.
>  > +	 */
>  > + 	struct _fpstate fpstate;
>  > + 	struct _xsave_hdr_struct xsave_hdr;
>  > + 	/* new processor state extensions will go here */
>  > +} __attribute__ ((aligned (64)));
>  > +
>  > +struct xstate_cntxt {
>  > +	struct  _xstate __user *xstate;
>  > +	u32	size;
>  > +	u32 	lmask;
>  > +	u32	hmask;
>  > +};
>  >  #endif
> 
> What is the purpose of the xstate pointer in xstate_cntxt?
> As far as I can tell, it's redundant and can alway be derived
> from the ucontext's uc_mcontext.fpstate pointer.

This is true in 64bit.

While doing sigreturn, there is no way, kernel can know if the
uc_mcontext.fpstate is pointing to just the legacy fpstate(512 bytes)
or the extended state pointer (unless we incorporate
some magic word at the end of fpstate image, see below)

during sigreturn, fpstate will be restored from the uc_mcontext.fpstate
and extended state will be restored from xstate pointer.

> And why does x86-64 make xstate == fpstate while on x86-32 they're at an
> offset from each other?

because sigcontext's 32bit fpstate is different from 64bit fpstate.
32bit fp state is fsave frame followed by fxsave frame. Whereas 64bit
fp state is just fxsave frame. To maintain 32bit legacy compatibility,
32bit xstate is different from 32bit fpstate.

> The fpstate pointer may be pointing into a struct _xstate.
> How is user-space supposed to know if this is the case?

user-space doesn't have to know. user has to refer fpstate through
fpstate pointer, and all the extended state through xstate pointer.
during the sigreturn, kernel will restore fp state through
fpstate pointer and the rest (exclusing FP/SSE) will be restored
from xstate pointer.

> struct _fpstate has a 'magic' field which distinguishes x87-only
> from x87+FXSR structs. Could that field also be used to indicate XSAVE?

I don't think we can use the existing 'magic' field. But we can
use some what similar magic, if the fxsave/fxrstor give away
some of the fields at the end of fxsave image (today it is reserved
and ignored during fxsave/fxrstor) for software use.
We can then use these fields at the end of fpstate, to indicate the presence of
xstate. But this requires some architecture changes like giving
away this space for SW use. We can take this to architects and
see what they think.

> How is user-space supposed to know how large the _xstate struct is?
> Is that the size field in the struct xstate_cntxt?

yes. I will make the names more descriptive :)

> 
>  > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>  > +++ linux-2.6-x86/arch/x86/kernel/xsave.c	2008-05-12 13:09:56.000000000 -0700
> ...
>  > +	/*
>  > +	 * FP and SSE state can't be restored directly from the userspace
>  > +	 * because of legacy reasons. Lets restore it to the fpstate
>  > +	 * in the task struct.
>  > +	 */
> 
> Can you please explain what those 'legacy reasons' are?

As I mentioned earlier, fpstate contains both fsave frame followed by fxsave
frame. So the kernel can't directly restore the information.

> I know xsave will be needed once AVX is released to the masses.
> Any idea on when that will happen?

AVX is currently planned for Sandybridge time frame.

thanks,
suresh
