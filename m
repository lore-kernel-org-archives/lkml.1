Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0BLEdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 23:33:45 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:35162 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0BLEdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 23:33:44 -0500
X-Greylist: delayed 70253 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 23:33:43 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XsWw1hfXex7tDMRXV/t+wxPaGUxJIsgrwK/l8Lf2MsWl4/hum/bJpTJOTbqao3sjoC
         7nWaZPKRPzW+hn8EBS3ClbNdtWDDqhDPKwRHbbE29mVvYKHl+TGnWGgwtOCSEQnY6Fte
         K4sMRq9/RMAuECnIOdAjk26Kxmm857VHGcdXQ=
MIME-Version: 1.0
In-Reply-To: <20100212032406.BE645C81B@magilla.sf.frob.com>
References: <20100202185907.GE3630@lst.de> <1265881389-26925-2-git-send-email-vapier@gentoo.org> 
	<20100211204653.34BB3900@magilla.sf.frob.com> <8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com> 
	<20100212032406.BE645C81B@magilla.sf.frob.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Feb 2010 23:33:20 -0500
Message-ID: <8bd0f97a1002112033m5805d4eco3add4d5625e71e9@mail.gmail.com>
Subject: Re: [PATCH 1/2] Blackfin: initial tracehook support
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 22:24, Roland McGrath wrote:
>> where is user_regset actually used ?  i only see it in fs/binfmt_elf.c
>> and core dumps, neither of which work on nommu systems (or at least on
>> Blackfin systems).
>
> The core dump code in binfmt_elf_fdpic.c appears identical to an old
> version of the binfmt_elf.c code.  That file appears to have been made with
> the "copy and paste" school of code sharing, of which I am a detractor.
> The ELF core dump code can be shared between those two, and really should
> be.  Once that's done, you will want to use the CORE_DUMP_USE_REGSET flavor
> of the code and clean out any old core-related cruft you had in asm/elf.h.
> In the long run, the non-user_regset version of the core dump code will go
> away after every arch has been cleaned up.

cant say we've had anything to do with this ;).  nor does Blackfin
support coredumps on FDPIC ELF (and FLAT has never supported
coredumps), and i'm pretty sure we havent looked at anything in gdb
along these lines.  no one has ever asked, so we've never looked.

> The "ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET"
> patch making its way through the obstacle course right now will make the
> generic ptrace code use user_regset.  That use is conditional on
> CONFIG_HAVE_ARCH_TRACEHOOK and your kernel will stop building if you have
> set that without meeting its requirements.
>
> Moreover, the whole point of CONFIG_HAVE_ARCH_TRACEHOOK is to indicate the
> minimum arch requirements that all future generic code can rely on.  If you
> set it without meeting the documented requirements as arch/Kconfig tells
> you to, then your arch will one day be broken by new generic code getting
> merged in.

i dont have a problem with implementing user_regsets ... my point was
more that if there's no code using these interfaces, then i could slap
together a whole lot of crap and never know if it's correct since i
cant test it.  Blackfin doesnt currently implement
PTRACE_{G,S}ETREGSET, so even with that patch i dont think i have any
(straight forward) test vectors.

>> i dont see anyone calling syscall_get_arguments() with i!=0, and a few
>> other arches are doing the BUG_ON(i) thing too.
>
> Someone will, and then they will crash.  A few others being half-assed is
> no good reason for you to follow suit.

the original reason was like the comment said -- i had no idea what
the "i" was for and the few arches that did implement it didnt exactly
have clear code/documentation.  ive added some nice kerneldoc stuff to
the Blackfin version in case anyone looks at this.

>> this is unchanged from the previous Blackfin behavior, and it's how
>> most arches behaved in 2.6.32.  but looking in latest mainline, it
>> seems people are changing to:
>> if (test_thread_flag(TIF_SINGLESTEP) || test_thread_flag(TIF_SYSCALL_TRACE))
>>     tracehook_report_syscall_exit(regs, 0);
>>
>> so changing Blackfin too should be straightforward i guess
>
> You can't blindly follow another arch.  All the details that tell you what
> is the right thing to do here are arch-specific.  I see no arch that does
> what you say, and it seems certain they would be wrong if they did.

i missed the passing of TIF_SINGLESTEP in as the second arg.  i
thought you were taking issue with the if(...) portions.

the way we do it on Blackfin atm is that syscall_trace_{enter,leave}
are only called when TIF_SYSCALL_TRACE is set (in the low level
assembly), so any checking of thread_flags here is pointless.  i guess
the low level code needs updating to check a mask so that we can add
TIF_SYSCALL_TRACEPOINT easier.

> You should always call tracehook_report_syscall_exit() if TIF_SYSCALL_TRACE
> is set.  Whether to call it otherwise depends on arch details.

this is all set for us

> On some machines, single-step into a syscall instruction is no different
> from other user instructions, so the normal SIGTRAP will come afterwards
> anyway.
>
> On other machines, entering the kernel for the syscall instruction defeats
> the normal user-mode effects of single-step being enabled.  In that event,
> you want to call tracehook_report_syscall_exit() if single-step is enabled.
> You must pass a nonzero second argument if your arch code is not going to
> generate the normal SIGTRAP associated with having single-stepped into the
> syscall instruction.

so tracehook_report_syscall_exit() checking TIF_SINGLESTEP only makes
sense when the arch doesnt support hardware single stepping in user
mode ?  the Blackfin processor does support hardware single stepping
(and we utilize it in Linux).

also, in reading the kerneldocs for tracehook_report_syscall_exit(),
it says "an attempted system call".  should system calls greater than
NR_syscall (-ENOSYS) also get traced ?  we dont currently do this on
the Blackfin port, but going by `strace` differences between my
desktop and the board, i guess the answer is "the Blackfin code is
currently broken".
-mike
