Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0BMJl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 04:41:57 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:37808 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0BMJlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 04:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wUAkbGxslGuppBMieV69F5U8xKgWvcUrLmEdo1wPg+br1eIN4YXQIqgAgCLU5mqQF0
         UovNQ8729NRZtM9id69LXjkfHW1ilsek7ARNC5+FOuagsdk/fgjdbzRnunHLNTQ3cObT
         eFhEccw9xsFYH7U6+T6SH3SUfnOpEJZxKBBr4=
MIME-Version: 1.0
In-Reply-To: <20100212204427.5F75CA18@magilla.sf.frob.com>
References: <20100202185907.GE3630@lst.de> <1265881389-26925-2-git-send-email-vapier@gentoo.org> 
	<20100211204653.34BB3900@magilla.sf.frob.com> <8bd0f97a1002111554ib69bd48rc3c5f4af65058281@mail.gmail.com> 
	<20100212032406.BE645C81B@magilla.sf.frob.com> <8bd0f97a1002112033m5805d4eco3add4d5625e71e9@mail.gmail.com> 
	<20100212204427.5F75CA18@magilla.sf.frob.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Feb 2010 04:41:31 -0500
Message-ID: <8bd0f97a1002130141v301af30av3ec51f065656b65f@mail.gmail.com>
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

On Fri, Feb 12, 2010 at 15:44, Roland McGrath wrote:
> Moreover, the usual cleanup is to make your arch_ptrace() use
> copy_regset_from_user() and copy_regset_to_user() to implement existing
> calls ike PTRACE_GETREGS.  That way, existing ptrace users (strace, gdb)
> become tests of the user_regset paths (some of them).

OK, this should be doable.  are there any guidelines for what should
be in a specific regset ?  the Blackfin processor does not have a FPU,
so the only set i have defined atm is the "general" set and that is
exactly the same as the current set of ptrace registers.  this is also
what the current PTRACE_{G,S}ETREGS operates on (struct pt_regs).

there are more pseudo regs as required by FDPIC, but they arent in the
pt_regs layout ...

> What happens today when PTRACE_SINGLESTEP is used with the PC sitting at a
> syscall instruction?  If that gets a single-step report (SIGTRAP) after the
> syscall is done, with the PC sitting at the instruction immediately
> following the syscall instruction, then you are already doing the right
> thing.  On some other machines, making that happen involves arch assembly
> code making sure it gets to its syscall_trace_leave() for this case.

i believe the single step exception is taken first and then the
syscall exception, but i'll have to do some hardware tests on the
hardware to confirm

>> also, in reading the kerneldocs for tracehook_report_syscall_exit(),
>> it says "an attempted system call".  should system calls greater than
>> NR_syscall (-ENOSYS) also get traced ?  we dont currently do this on
>> the Blackfin port, but going by `strace` differences between my
>> desktop and the board, i guess the answer is "the Blackfin code is
>> currently broken".
>
> Yes.  It's any syscall attempt.  Inside tracehook_report_syscall_entry(),
> all the registers can be changed (via user_regset, i.e. ptrace) so that
> what starts as an entry with a bogus syscall number becomes an entry with a
> different syscall number and/or arguments.  So you can't decide before
> tracehook_report_syscall_entry() whether it is "real" or not.  For every
> tracehook_report_syscall_entry() call, there must be a corresponding
> tracehook_report_syscall_exit() call (unless TIF_SYSCALL_TRACE was cleared
> in the interim).  At that exit point, the registers can again be changed.
>
> For example, an "expected" use (that some things do today via ptrace) is to
> catch the entry, abort the syscall by changing the syscall number register
> to something bogus like -1, resume so it diagnoses -ENOSYS and gets to
> syscall exit, then catch the exit and reset the return value registers to
> pretend some particular syscall results happened.

i fixed the Blackfin code to do NR checking after tracing and now
`strace` shows the bad syscall

as for register munging, i didnt realize this was accepted practice
and something that should actively be supported.  i had been toying
around locally with optimizing some of the syscall paths by breaking
this behavior, so i'll add some comments to prevent any further
mucking here.

the Blackfin code when traced now does:
call tracehook_report_syscall_entry(regs)
reload syscall NR and all 6 args from regs
if syscall NR is valid, call it
if syscall NR is invalid, set return value to -ENOSYS
store return value into regs
call tracehook_report_syscall_exit(regs)
-mike
