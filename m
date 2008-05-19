Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYESOyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYESOyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYESOyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:54:00 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46842 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYESOx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:53:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18481.37905.297556.288317@harpo.it.uu.se>
Date: Mon, 19 May 2008 16:52:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, andi@firstfloor.org, roland@redhat.com,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <20080518013416.GB30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 18:34:16 -0700, Suresh Siddha wrote:
>On Fri, May 16, 2008 at 03:26:15PM +0200, Mikael Pettersson wrote:
>> This is a large patch, and somewhat difficult to review since it mixes
>> kernel-private and user-visible changes.
>
>Sorry. I wanted to give the complete picture. Will see if I can split it up
>while posting for upstream.

Ok.

>>  > BTW, Traditionally glibc has this definition for struct ucontext.
>> 
>> glibc's definition is irrelevant, in part because glibc can and does lie
>> about kernel types to applications, and in part because glibc is not the
>> only user-space consumer of kernel types: there are other libcs, and there
>> are user-space virtualisation tools (my interest in this matter) that care
>> deeply about kernel types and sigframe layouts. In particular, user-space
>> needs to be able to copy and assemble sigframes.
>
>Ok. I hope user-space is doing this copy and assemble in a (sane) way that
>allows the kernel to modify the sigframe with out  breaking old apps.
>
>Do you know how the user-space is determining how much to copy today?

The de-facto ABI for signal delivery and sigreturn is unfortunately
based on fairly fixed-layout structs on the stack (sigframes). The
only flexibility there that I've found is the sigcontext's fpstate
pointer which allows the fpstate to be located elsewhere.

User-space pretty much has to know the kernel's sigframe layout, for
instance, non-siginfo sigframes on x86-32 hide additional sigmask words
above the fpstate.

User-space could in theory compare SP with the sigcontext's SP and
the altstack (if any) and deduce the sigframe size from that, but
that gives incomplete information; for instance, user-space must
still be able to locate and adjust embedded pointers in the sigframe.

In my case we "know" the sigframe struct layout based on OS and CPU
combination. I can't comment on how others deal with this.

It's pretty much guaranteed that any extension of these structs will
break some applications. I think the best we can hope for is that
1) applications that only inspect sigframes without copying them
   don't break, and
2) applications get a mechanism for detecting the new layout of
   sigframes and ucontexts, allowing them to be updated to handle
   those changes.

>I have to probably use some magic values(or other flags), indicating the
>presence of extended state context information in the ucontext.

I believe so too.

>cpuid information (cpuid.0x1.ecx.osxsave) indicates whether the
>OS supports xsave or not. This can be one way, that signal handlers
>can use to interpret the ucontext.
>
>Given that it is more than signal handlers, I can add a flag also,
>representing ucontext extensions.

My problem with the OSXAVE flag is that it's a very indirect way of
communicating the layout of sigframes and sigcontexts. These structures
should, if at all possible, be self-describing. A single flag bit in
the sigcontext could handle both structures (since a sigframe always
includes a sigcontext).

[But see my comment below about uc_flags.]

>> You're changing the layout of struct ucontext in two ways: uc_mcontext
>> changes elsewhere, and you're adding __unused and uc_xstate.
>
>I am not changing the uc_mcontext (struct sigcontext). Just extending
>the ucontext.

Correct, my mistake.

>> How is user-space supposed to know whether it's looking at a current
>> layout ucontext or an xsave-layout ucontext?
>> 
>> It seems that uc_flags is unused and always zero. Could you define a
>> flag bit (e.g. 1) for uc_flags to indicate the xsave layout?
>
>Sure. I can even add a magic word to indicate the xsave presence,
>so that sigreturn can be double sure and not break older apps.

The uc_flags field is not specified by SUSv3. Linux stores a zero
in it on signal delivery but doesn't use it on signal return.
Solaris describes it as implementation-dependent, and stores a bit
vector in it describing which parts of the ucontext are valid and
should be restored by setcontext (i.e. sigreturn in Linux). Thus
uc_flags would be a perfect place to store an XSAVE flag or cookie.

Using uc_flags takes care of x86-64 and x86-32 with "rt" sigframes
(SA_SIGINFO signal dispositions). The remaining problem is x86-32
with non-SA_SIGINFO sigframes, since they store plain sigcontexts
on the stack not ucontexts, and so don't have a uc_flags field.
To handle those we have to augment either sigcontexts or the plain
non-rt sigframes with some kind of marker.

>>  > --- linux-2.6-x86.orig/arch/x86/kernel/sigframe.h	2008-05-12 13:09:02.000000000 -0700
>>  > +++ linux-2.6-x86/arch/x86/kernel/sigframe.h	2008-05-12 13:09:56.000000000 -0700
>>  > @@ -3,9 +3,10 @@
>>  >  	char __user *pretcode;
>>  >  	int sig;
>>  >  	struct sigcontext sc;
>>  > -	struct _fpstate fpstate;
>>  > +	struct xstate_cntxt xst_cnxt;
>>  >  	unsigned long extramask[_NSIG_WORDS-1];
>>  >  	char retcode[8];
>>  > +	/* fp and rest of the extended context state follows here */
>>  >  };
>> 
>> Offset to extramask[] and retcode changes, as well as the size of the structure.
>
>hm yes. this will break the restore of extramask[], for apps which set their
>own sig return frames.

Updating extramask[] is useful for combining sigprocmask(SIG_SETMASK,_,_) and
sigreturn into an atomic operation. AFAIK, there's no way to reach extramask[]
without knowing the sigframe layout.

>I can leave _fpstate as it is(and unused) and move xstate context (which
>will contain fpstate + the extended state) after extramask[].

I think that would be best.

>> Why contract xstate_cntxt to xst_cnxt? That just obscures things.
>
>ok.

Thanks.

>> What is the purpose of the xstate pointer in xstate_cntxt?
>> As far as I can tell, it's redundant and can alway be derived
>> from the ucontext's uc_mcontext.fpstate pointer.
>
>This is true in 64bit.
>
>While doing sigreturn, there is no way, kernel can know if the
>uc_mcontext.fpstate is pointing to just the legacy fpstate(512 bytes)
>or the extended state pointer (unless we incorporate
>some magic word at the end of fpstate image, see below)
>
>during sigreturn, fpstate will be restored from the uc_mcontext.fpstate
>and extended state will be restored from xstate pointer.
>
>> And why does x86-64 make xstate == fpstate while on x86-32 they're at an
>> offset from each other?
>
>because sigcontext's 32bit fpstate is different from 64bit fpstate.
>32bit fp state is fsave frame followed by fxsave frame. Whereas 64bit
>fp state is just fxsave frame. To maintain 32bit legacy compatibility,
>32bit xstate is different from 32bit fpstate.

Ok, thanks for clarifying this.

>> struct _fpstate has a 'magic' field which distinguishes x87-only
>> from x87+FXSR structs. Could that field also be used to indicate XSAVE?
>
>I don't think we can use the existing 'magic' field.

Hmm, right now it seems this field has a de-facto ABI of being
either 0xffff (plain) or 0x0000 (fxsr). Using other values would
confuse at least one application I know of. Sad.

> But we can
>use some what similar magic, if the fxsave/fxrstor give away
>some of the fields at the end of fxsave image (today it is reserved
>and ignored during fxsave/fxrstor) for software use.
>We can then use these fields at the end of fpstate, to indicate the presence of
>xstate. But this requires some architecture changes like giving
>away this space for SW use. We can take this to architects and
>see what they think.

If the HW doesn't store anything valuable there, we could store
SW flags/cookies there on signal delivery, and clear them before
fxrstor (unless the HW is known to ignore those fields).
But it depends on how forgiving the HW is.

Another idea I have at the moment is that it seems that struct
_fpstate reserves storage for x87 in both the legacy part and
the fxsr part. Looking through arch/x86/kernel/i387.c it seems
that the x87 space in the fxsr part isn't actually used (see
convert_to_fxsr()). If so, it might be possible to reuse it for
an XSAVE indicator.

Another idea is that marking non-siginfo sigframes could be done
by adding a sys_xsave_sigreturn() and letting those sigframes
have a return address pointing to a vsyscall that invokes this
new syscall.

/Mikael
