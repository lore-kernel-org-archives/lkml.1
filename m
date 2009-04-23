Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZDWOak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZDWOak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZDWOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:30:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbZDWOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:30:20 -0400
Date: Thu, 23 Apr 2009 16:26:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: SIGSTOP && ptrace (Was: ptrace(PTRACE_SYSCALL/CONT/DETACH, ...,
	SIGSTOP) does not work)
Message-ID: <20090423142627.GA31572@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Denys Vlasenko wrote:
>
> Bringing the discussion to lkml per your request.

You forgot to cc maintainer ;) Add Roland.

> From  Oleg Nesterov 2009-04-22 19:22:29 EDT
> > > Now, the bug:
> > >
> > > Example 3: cat is signaled with SIGSTOP. Strace does this:
> > >
> > > wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989
> >
> > The tracee dequeues SIGSTOP, does get_signal_to_deliver()->ptrace_stop(),
> > and do not really handle SIGSTOP.
> >
> > > write(2, "--- SIGSTOP (Stopped (signal)) @"..., 43) = 43
> > > ptrace(PTRACE_SYSCALL, 30989, 0x1, SIGSTOP) = 0
> > >
> > >   Note: traced process is NOT stopped here as it should be!
> > >   Somehow, we get another SIGSTOP notification:
> > >
> > > wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989
> >
> > strace does ptrace(PTRACE_SYSCALL, SIGSTOP), this sets ->exit_code = SIGSTOP.
> > The tracee sees the debugger wants SIGSTOP to be handled and calls
> > do_signal_stop().
> > (we have some complications with SIGNAL_STOP_DEQUEUED, but lets ignore them).
> >
> > finish_stop() notifies ->parent == tracer about jctl stop, strace does
> > do_wait()
> > and gets WSTOPSIG(s) == SIGSTOP.
> >
> > What is wrong?
>
> It's wrong that single SIGSTOP gets reported twice, yet fails to act even once.

I'd say this is correct. The second time the tracee reports about jctl stop,
given that the tracer did ptrace(PTRACE_SYSCALL, SIGSTOP) this looks right.
The debugger explicitely tells the tracee "proceed with SIGSTOP", what else
can we expect?

> You are replying from the point of view of kernel's current implementation.

Yes,

> Stop thinking about implementation. Think about he API.
> Does kernel fulfil what API promises? It does not look like it does.

I don't really know. More or less, I understand the process-management
part of ptrace, but I never knew what user-space actually expects from
API.

But the behaviour above looks very natural to me.

> What strace told kernel to do? strace said:
>
>     Kernel, please make traced process act as if it received <sig>:
>     * ignore <sig> if <sig> is blocked
>       (and keep it pending in pending signal mask);
>     * jump to handler if handler is registered;
>     * ignore <sig> if it is SIG_IGNed, or if default action is no-op;
>     * make process die if default handler is to die;
>     * make process stop if default handler is to stop.
>
> IOW: strace does NOT want to see this signal reported back to strace -
> it already saw that, what's the point in seeing it again?

As I said many times, the second report is not about the signal, it
reports that the group-stop is completed.

> All of the above is working correctly, except for the last line:
> "make process stop if default handler is to stop". This one does not work.

This does work. The tracee stops and reports. OK, OK, unless I missed
something of course ;)

> Instead it acts really weird, as shown in my SIGSTOP and SIGTSTP
> examples above.

I guess, you don't like the fact that finish_stop() always clear ->exit_code
after wake up. This is why the next ptrace(PTRACE_SYSCALL, SIGSTOP) (called
when the tracee sleeps in finish_stop) "loses" SIGSTOP.

I can't say if this really right or not, but I guess it is too late to
change this behaviour. I may be wrong.

But anyway, I'd say in this case strace should not do ptrace(SIGSTOP),
this looks just wrong to me.

> I think this is a bug.

I don't. At least, I strongly disagree with the subject, and I think you
misunderstand what really happens with this example. Please correct me.


Perhaps, you should ask how strace can distinguish between "SIGSTOP
recieved" and "group-stop completed". I am not 100% sure, but at first
glance this looks possible.

The tracee reports "SIGSTOP recieved". It also sets ->last_siginfo = info.

The tracer can change info->si_signo before ptrace(SYSCALL, SIGSTOP).

This info->si_signo will be used as ->exit_code in status instead of
SIGTOP when the tracee actually stops.


I didn't check this though. And again, I am in no position to tell
you what should be done here. Fortunately, we have knowledgeable
people in cc.

Oleg.

