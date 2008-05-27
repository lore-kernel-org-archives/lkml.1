Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYE0EFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYE0EFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYE0EFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:05:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYE0EFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:05:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Luming Yu" <luming.yu@gmail.com>
X-Fcc: ~/Mail/linus
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
In-Reply-To: Luming Yu's message of  Tuesday, 27 May 2008 11:31:43 +0800 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	<20080522111826.BB90326FA24@magilla.localdomain>
	<3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	<20080522203428.835D626FA24@magilla.localdomain>
	<3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	<20080523041940.39E8726FA24@magilla.localdomain>
	<3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	<20080526001527.81E1126FA9E@magilla.localdomain>
	<3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	<3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
Emacs: don't cry -- it won't help.
Message-Id: <20080527040454.053C526FA9E@magilla.localdomain>
Date: Mon, 26 May 2008 21:04:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > if happens, it should be a bug, right?

It doesn't even make sense that it should be possible.
So if it somehow is possible, that is certainly a bug.
But the mind boggles as to exactly what sort of bug it could be.

> It does happen!!

Um.  Really?  What does happen exactly?

> Call Trace:
>  [<a000000100011bd0>] show_stack+0x50/0xa0
>                                 sp=e000000146bbfbb0 bsp=e000000146bb0e08
>  [<a000000100011c50>] dump_stack+0x30/0x60
>                                 sp=e000000146bbfd80 bsp=e000000146bb0de8
>  [<a0000001000979a0>] get_signal_to_deliver+0x60/0x6e0
>                                 sp=e000000146bbfd80 bsp=e000000146bb0d80
>  [<a0000001000343d0>] ia64_do_signal+0xb0/0xd00
>                                 sp=e000000146bbfd80 bsp=e000000146bb0cd8
>  [<a000000100012650>] do_notify_resume_user+0xf0/0x140
>                                 sp=e000000146bbfe20 bsp=e000000146bb0ca8
>  [<a00000010000aac0>] notify_resume_user+0x40/0x60
>                                 sp=e000000146bbfe20 bsp=e000000146bb0c58
>  [<a00000010000a9f0>] skip_rbs_switch+0xe0/0x110
>                                 sp=e000000146bbfe30 bsp=e000000146bb0c58
>  [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
>                                 sp=e000000146bc0000 bsp=e000000146bb0c58

So this here shows a perfectly normal trace that bottoms out at a syscall
entry from user mode.  You seem to be saying that, somehow, inside
ptrace_stop(), we tried to return to user mode--I guess you mean losing the
kernel stack with the call chain leading to ptrace_stop()--and then
reentered the kernel as for a signal after a syscall.  

> I applied the following patch , and got the call trace above..
> If apply my RFC patch as antidote,  I don't see "deliver" ...

With just that diagnostic patch as shown, these might be two different
threads.  But I guess you've ruled that out somehow?  If this does in fact
happen in the thread that is supposed to be in ptrace_stop(), then the
trail we need to follow is in arch_ptrace_stop(), i.e. ia64_ptrace_stop().

> Is the problem clear now?  

I'm sorry, it's not at all clear to me.

> I will serve you until every thing is clear to you.

That's quite a commitment!  My full enlightenment may be a long time off.
I won't hold you to it once we've fixed this particular bug, though. ;-)

What should be happening is that ia64_ptrace_stop() should do its work,
possibly blocking, and then return to its caller in ptrace_stop().  At no
point should it be possible for ia64_ptrace_stop() to return directly to
user mode, or to reenter notify_resume_user() in any fashion.

Please focus on the exact code path taken inside the ia64_ptrace_stop()
call.  It should be possible to identify every step of that and see exactly
where it goes astray from what we expect.


Thanks,
Roland
