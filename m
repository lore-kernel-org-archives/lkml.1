Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZDWMPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZDWMPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZDWMP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:15:28 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37024 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZDWMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U6Pp1zb7wU/Ja/UQMFwXIymqv63X5CTxFYN4wUPvQ8MAhWnnezT8TbB6gG5siMacRa
         KA5EcFAaC83MSK8nIailxBSW8OcNOn/Fa05pqeUI0SmnGFNiTagdrscUyXuhW5S+Scap
         bcirCWP8vBe8Pea9/W/HNrVQegjRd61cEi730=
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 14:15:25 +0200
Message-ID: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com>
Subject: ptrace(PTRACE_SYSCALL/CONT/DETACH, ..., SIGSTOP) does not work
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Bringing the discussion to lkml per your request.

Lets focus on ptrace() API, not the actual kernel behavior (which may be
different due to bugs). In other words, how ptrace should work?

ptrace(PTRACE_SYSCALL/CONT/DETACH, ..., sig) API is needed in order to continue
the process after ptrace stop, and let it see and handle the signal.

For example, imagine that you are stracing cat process. It is blocked on read
syscall:

# { sleep 10; echo Hello; } | strace cat
...
read(0,

What strace is doing at this point? It is in wait4(-1, &status, __WALL, NULL).

Now someone sends a signal. strace sees this:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == <sig>}], __WALL, NULL) = <PID>

strace will inform user with "--- SIGxxxx ---", and what strace needs to do
now? Right! It needs to deliver the signal to <PID>, and wait again:

ptrace(PTRACE_SYSCALL, <PID>, 0x1, <sig>);
wait4(-1, &status, __WALL, NULL);

And now, this signal should NOT show up in wait4 (because tracer already saw
it, we don't want infinite cycle here :), but should act as normal.


Example 1: cat is signaled with a signal with default action "nop". Strace does
this (irrelevant syscalls removed):

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGWINCH}], __WALL, NULL) = 31027
write(2, "--- SIGWINCH (Window changed) @ "..., 42) = 42
ptrace(PTRACE_SYSCALL, 31027, 0x1, SIGWINCH) = 0
wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == 133}], __WALL, NULL) = 31027
...

Example 2: cat is signaled with a signal with default action "die". Strace does
this:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTERM}], __WALL, NULL) = 32654
write(2, "--- SIGTERM (Terminated) @ 0 (0)"..., 37) = 37
ptrace(PTRACE_SYSCALL, 32654, 0x1, SIGTERM) = 0
wait4(-1, [{WIFSIGNALED(s) && WTERMSIG(s) == SIGTERM}], __WALL, NULL) = 32654
write(2, "+++ killed by SIGTERM +++\n", 26) = 26
wait4(-1, 0x7fff02e98f7c, WNOHANG|__WALL, NULL) = -1 ECHILD (No child
processes)

There two examples works as expected. In particular, user-observed cat's
behavior is not changed by the fact that it is straced.


Now, the bug:

Example 3: cat is signaled with SIGSTOP. Strace does this:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989
write(2, "--- SIGSTOP (Stopped (signal)) @"..., 43) = 43
ptrace(PTRACE_SYSCALL, 30989, 0x1, SIGSTOP) = 0

  Note: traced process is NOT stopped here as it should be!
  Somehow, we get another SIGSTOP notification:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989

  strace is confused (it thinks it's another SIGSTOP).
  it injects SIGSTOP again:

write(2, "--- SIGSTOP (Stopped (signal)) @"..., 43) = 43
ptrace(PTRACE_SYSCALL, 30989, 0x1, SIGSTOP) = 0

  thankfully, this doesn't loop forever, but tracee is still not stopped!
  we are immediately getting notification that it entered read syscall:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == 133}], __WALL, NULL) = 30989
ptrace(PTRACE_PEEKUSER, 30989, 8*ORIG_RAX, [0]) = 0
ptrace(PTRACE_PEEKUSER, 30989, 8*CS, [0x33]) = 0
ptrace(PTRACE_PEEKUSER, 30989, 8*RAX, [0xffffffffffffffda]) = 0
ptrace(PTRACE_PEEKUSER, 30989, 8*RDI, [0]) = 0
ptrace(PTRACE_PEEKUSER, 30989, 8*RSI, [0x77a000]) = 0
ptrace(PTRACE_PEEKUSER, 30989, 8*RDX, [0x1000]) = 0
write(2, "read(0, ", 8)                 = 8
ptrace(PTRACE_SYSCALL, 30989, 0x1, SIG_0) = 0
wait4(-1, ..., __WALL, NULL) = ....

This does not look correct to me. Straced process is not behaving in the same
way as it would without strace.


If you disagree with me, let me know what, in your opinion, strace should do to
properly emulate process behavior?


BTW, same happens with other stopping signal, TSTP:

wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTSTP}], __WALL, NULL) = 32682
write(2, "--- SIGTSTP (Stopped) @ 0 (0) --"..., 34) = 34
ptrace(PTRACE_SYSCALL, 32682, 0x1, SIGTSTP) = 0
wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTSTP}], __WALL, NULL) = 32682
write(2, "--- SIGTSTP (Stopped) @ 0 (0) --"..., 34) = 34
ptrace(PTRACE_SYSCALL, 32682, 0x1, SIGTSTP) = 0
wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == 133}], __WALL, NULL) = 32682
ptrace(PTRACE_PEEKUSER, 32682, 8*ORIG_RAX, [0]) = 0
ptrace(PTRACE_PEEKUSER, 32682, 8*CS, [0x33]) = 0
ptrace(PTRACE_PEEKUSER, 32682, 8*RAX, [0xffffffffffffffda]) = 0
ptrace(PTRACE_PEEKUSER, 32682, 8*RDI, [0]) = 0
ptrace(PTRACE_PEEKUSER, 32682, 8*RSI, [0x2483000]) = 0
ptrace(PTRACE_PEEKUSER, 32682, 8*RDX, [0x1000]) = 0
write(2, "read(0, ", 8)                 = 8
wait4(-1, ...., __WALL, NULL) = ...


>From  Oleg Nesterov 2009-04-22 19:22:29 EDT
> > Now, the bug:
> >
> > Example 3: cat is signaled with SIGSTOP. Strace does this:
> >
> > wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989
>
> The tracee dequeues SIGSTOP, does get_signal_to_deliver()->ptrace_stop(),
> and do not really handle SIGSTOP.
>
> > write(2, "--- SIGSTOP (Stopped (signal)) @"..., 43) = 43
> > ptrace(PTRACE_SYSCALL, 30989, 0x1, SIGSTOP) = 0
> >
> >   Note: traced process is NOT stopped here as it should be!
> >   Somehow, we get another SIGSTOP notification:
> >
> > wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], __WALL, NULL) = 30989
>
> strace does ptrace(PTRACE_SYSCALL, SIGSTOP), this sets ->exit_code = SIGSTOP.
> The tracee sees the debugger wants SIGSTOP to be handled and calls
> do_signal_stop().
> (we have some complications with SIGNAL_STOP_DEQUEUED, but lets ignore them).
>
> finish_stop() notifies ->parent == tracer about jctl stop, strace does
> do_wait()
> and gets WSTOPSIG(s) == SIGSTOP.
>
> What is wrong?

It's wrong that single SIGSTOP gets reported twice, yet fails to act even once.

You are replying from the point of view of kernel's current implementation.
Stop thinking about implementation. Think about he API.
Does kernel fulfil what API promises? It does not look like it does.

What strace told kernel to do? strace said:

    Kernel, please make traced process act as if it received <sig>:
    * ignore <sig> if <sig> is blocked
      (and keep it pending in pending signal mask);
    * jump to handler if handler is registered;
    * ignore <sig> if it is SIG_IGNed, or if default action is no-op;
    * make process die if default handler is to die;
    * make process stop if default handler is to stop.

IOW: strace does NOT want to see this signal reported back to strace -
it already saw that, what's the point in seeing it again?

All of the above is working correctly, except for the last line:
"make process stop if default handler is to stop". This one does not work.
Instead it acts really weird, as shown in my SIGSTOP and SIGTSTP
examples above.

I think this is a bug.
--
vda
