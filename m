Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0BLDYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:24:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab0BLDYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:24:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] Blackfin: initial tracehook support
In-Reply-To: Mike Frysinger's message of  Thursday, 11 February 2010 18:54:04 -0500 <8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com>
References: <20100202185907.GE3630@lst.de>
	<1265881389-26925-2-git-send-email-vapier@gentoo.org>
	<20100211204653.34BB3900@magilla.sf.frob.com>
	<8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100212032406.BE645C81B@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 19:24:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> where is user_regset actually used ?  i only see it in fs/binfmt_elf.c
> and core dumps, neither of which work on nommu systems (or at least on
> Blackfin systems).

The core dump code in binfmt_elf_fdpic.c appears identical to an old
version of the binfmt_elf.c code.  That file appears to have been made with
the "copy and paste" school of code sharing, of which I am a detractor.
The ELF core dump code can be shared between those two, and really should
be.  Once that's done, you will want to use the CORE_DUMP_USE_REGSET flavor
of the code and clean out any old core-related cruft you had in asm/elf.h.
In the long run, the non-user_regset version of the core dump code will go
away after every arch has been cleaned up.

The "ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET"
patch making its way through the obstacle course right now will make the
generic ptrace code use user_regset.  That use is conditional on
CONFIG_HAVE_ARCH_TRACEHOOK and your kernel will stop building if you have
set that without meeting its requirements.

Moreover, the whole point of CONFIG_HAVE_ARCH_TRACEHOOK is to indicate the
minimum arch requirements that all future generic code can rely on.  If you
set it without meeting the documented requirements as arch/Kconfig tells
you to, then your arch will one day be broken by new generic code getting
merged in.

> i dont see anyone calling syscall_get_arguments() with i!=0, and a few
> other arches are doing the BUG_ON(i) thing too.

Someone will, and then they will crash.  A few others being half-assed is
no good reason for you to follow suit.

> but should be easy to implement this with memory walking code ...

Good!

> this is unchanged from the previous Blackfin behavior, and it's how
> most arches behaved in 2.6.32.  but looking in latest mainline, it
> seems people are changing to:
> if (test_thread_flag(TIF_SINGLESTEP) || test_thread_flag(TIF_SYSCALL_TRACE))
>     tracehook_report_syscall_exit(regs, 0);
> 
> so changing Blackfin too should be straightforward i guess

You can't blindly follow another arch.  All the details that tell you what
is the right thing to do here are arch-specific.  I see no arch that does
what you say, and it seems certain they would be wrong if they did.

You should always call tracehook_report_syscall_exit() if TIF_SYSCALL_TRACE
is set.  Whether to call it otherwise depends on arch details.  

On some machines, single-step into a syscall instruction is no different
from other user instructions, so the normal SIGTRAP will come afterwards
anyway.  

On other machines, entering the kernel for the syscall instruction defeats
the normal user-mode effects of single-step being enabled.  In that event,
you want to call tracehook_report_syscall_exit() if single-step is enabled.
You must pass a nonzero second argument if your arch code is not going to
generate the normal SIGTRAP associated with having single-stepped into the
syscall instruction.

> sounds like this issue is unrelated to tracehook and how we've been
> doing signal/ptrace stuff has always been a little broken ...

Yes.  It's related to tracehook in the sense that the tracehook interfaces
as described by the kerneldoc cover explicitly all the corners of the
semantics that were fuzzy or implicit in the ancient code.  Getting all
these corners right for your arch makes sure that any future generic
features that differ from the ancient ptrace muck will behave as intended
on your arch without you having to go fix things up later on.

> i'll move it to how most arches seem to do it -- in do_signal after a
> successful call to handle_signal and after clearing
> TIF_RESTORE_SIGMASK.

That is correct.


Thanks,
Roland
