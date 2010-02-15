Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0BOUIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:08:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0BOUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:08:08 -0500
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
In-Reply-To: Mike Frysinger's message of  Saturday, 13 February 2010 04:41:31 -0500 <8bd0f97a1002130141v301af30av3ec51f065656b65f@mail.gmail.com>
References: <20100202185907.GE3630@lst.de>
	<1265881389-26925-2-git-send-email-vapier@gentoo.org>
	<20100211204653.34BB3900@magilla.sf.frob.com>
	<8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com>
	<20100212032406.BE645C81B@magilla.sf.frob.com>
	<8bd0f97a1002112033m5805d4eco3add4d5625e71e9@mail.gmail.com>
	<20100212204427.5F75CA18@magilla.sf.frob.com>
	<8bd0f97a1002130141v301af30av3ec51f065656b65f@mail.gmail.com>
X-Zippy-Says: Will this never-ending series of PLEASURABLE EVENTS never cease?
Message-Id: <20100215200738.3BFBB19@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 12:07:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, this should be doable.  are there any guidelines for what should
> be in a specific regset ?  the Blackfin processor does not have a FPU,
> so the only set i have defined atm is the "general" set and that is
> exactly the same as the current set of ptrace registers.  this is also
> what the current PTRACE_{G,S}ETREGS operates on (struct pt_regs).

For most machines, the decision was already made implicitly in the formats
used in ELF core dumps (e.g. elf_gregset_t).  If you've never had ELF core
dumps, then you are not constrained by any existing userland compatibility.
The fundamental guideline is that you should use the "natural" layouts and
divisions for your arch.  Usually what that means is fairly clear to people
well-versed in the particular arch.  When you have a PTRACE_GETREGS format
and there is nothing particularly wrong with that layout choice, then that
is the obvious thing to use as the user_regset layout for NT_PRSTATUS.

> there are more pseudo regs as required by FDPIC, but they arent in the
> pt_regs layout ...

IMHO these do not belong in a regset at all.  Like the name says, the
regset is for registers.  If something is not really an arch-specific
detail, I don't think it belongs in user_regset.

> i believe the single step exception is taken first and then the
> syscall exception, but i'll have to do some hardware tests on the
> hardware to confirm

The ptrace-tests suite (see http://sourceware.org/systemtap/wiki/utrace/tests)
has some tests for various corners of these semantics.  You'll have to port
some of the asm bits to blackfin, but that is probably easier and more
complete than what you'd try yourself from scratch.

> i fixed the Blackfin code to do NR checking after tracing and now
> `strace` shows the bad syscall

Good!

> as for register munging, i didnt realize this was accepted practice
> and something that should actively be supported.  

Indeed.  Try "strace -f" and see that its fork/clone tracing code relies
on fiddling syscall argument registers.

This stop (i.e. inside tracehook_report_syscall_entry) is the one and only
place where syscall_set_arguments() can validly be used.

Moreover, the fundamental rule is that at every tracehook_report_* call
site (aka ptrace stop), full access (including modification) via
user_regset interfaces (aka ptrace) should work and have the same effect as
if userland had set those register values normally before entering the
kernel (or just after exiting it, depending on the site in question).

> i had been toying around locally with optimizing some of the syscall
> paths by breaking this behavior, so i'll add some comments to prevent any
> further mucking here.

Other machines do have such fast paths for syscalls.  
They take the slow paths when TIF_SYSCALL_TRACE is set.
Note that you can still have fast paths when TIF_SYSCALL_AUDIT
is set--those don't have to permit modification.
Note also that syscall_get_arguments() works anywhere.

> the Blackfin code when traced now does:
> call tracehook_report_syscall_entry(regs)
> reload syscall NR and all 6 args from regs
> if syscall NR is valid, call it
> if syscall NR is invalid, set return value to -ENOSYS
> store return value into regs
> call tracehook_report_syscall_exit(regs)

That's correct.  Also do whatever reloading is required after so that the
return value register and other registers seen in userland have whatever
values may have been set inside tracehook_report_syscall_exit().


Thanks,
Roland
