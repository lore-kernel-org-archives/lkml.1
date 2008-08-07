Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYHGXip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYHGXip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYHGXii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:38:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYHGXih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:38:37 -0400
Date: Thu, 7 Aug 2008 20:35:31 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: CLONE_PTRACE Oops (was Re: 'strace -f' regression, bisected to
	tracehook)
Message-ID: <20080807233530.GD7957@blackpad>
References: <20080807222434.GC7957@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807222434.GC7957@blackpad>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 07:24:34PM -0300, Eduardo Habkost wrote:
> 
> Hi,
> 
> I have just hit a problem with strace when following forks, using
> recent trees. I have bisected the problem to commit 09a05394 (tracehook:
> clone).
> 
> 'strace -f' is not being able to trace child processes just after fork,
> and traces them only after the child has run for some time. I am getting
> the following output, when tracing a test program whose child exits just
> after returning from fork:
> 
>   clone(Process 399 attached (waiting for parent)
> * resume: ptrace(PTRACE_SYSCALL, ...): No such process
>   child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f8df681a780) = 399
>   [pid   398] --- SIGCHLD (Child exited) @ 0 (0) ---
>   [pid   398] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
>   [...]
> 
> What I expect to get (and was getting on 2.6.26 and before the bisected
> commit) is:
> 
>   clone(Process 391 attached (waiting for parent)
> * Process 391 resumed (parent 390 ready)
>   child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fa84cf3c780) = 391
> * [pid   391] exit_group(1)               = ?
> * Process 391 detached
>   --- SIGCHLD (Child exited) @ 0 (0) ---
>   rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
>   [...]
> 
> 
> strace uses a trick to set the CLONE_PTRACE flag on clone() syscalls
> made by the traced process. I don't know if the trick used by strace is
> broken, or the handling of CLONE_PTRACE itself is broken.

While trying to investigate this, I have hit a BUG_ON() that can be
triggered by user-space code.

Steps to reproduce:

Compile the C program below. It will call clone() with the CLONE_PTRACE
flag set. Run it from bash (_not_ under strace).

====================
#include <sched.h>
#include <stdlib.h>

int e(void *p)
{
	exit(1);
}

char stack[4096*2];

int main()
{
	int r = clone(e, stack+4096, CLONE_PTRACE, 0);
	if (r < 0) {
		perror("clone");
		return 1;
	}
	return 0;
}
====================

When running the program, bash hangs on a wait4() loop. Probably because
it is getting notified of the termination of the CLONE_PTRACE child but
doesn't know anything about it.

Send SIGTERM to bash. It won't have any effect.

Send SIGKILL to bash. It will trigger the BUG_ON(!child->ptrace)
at __ptrace_unlink():

------------[ cut here ]------------
kernel BUG at kernel/ptrace.c:69!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1784, comm: bash Not tainted 2.6.26-kvm #47
RIP: 0010:[<ffffffff802393d0>]  [<ffffffff802393d0>] __ptrace_unlink+0xa/0x5b
RSP: 0018:ffff88007e9dbc88  EFLAGS: 00010046
RAX: ffff88007f900328 RBX: ffff88007e9dbcc8 RCX: ffffffff8066a5a0
RDX: ffff88007ea982d8 RSI: ffff88007e9dbc58 RDI: ffff88007f900080
RBP: ffff88007e9dbc88 R08: ffffffff80681880 R09: ffffffff806817e0
R10: ffff88007e9dbc58 R11: 0000000000000282 R12: ffff88007ea98040
R13: ffff88007f900080 R14: ffff88007f9ad440 R15: 00000000ffffffff
FS:  0000000000000000(0000) GS:ffffffff806a5a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000483400 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 1784, threadinfo ffff88007e9da000, task ffff88007ea98040)
Stack:  ffff88007e9dbd08 ffffffff80234cad 0000000100000087 ffff88007f9ad438
 ffff88007ea982d8 ffff88007f900328 ffff88007f9ad450 ffff88007ea98030
 ffff88007e9dbcc8 ffff88007e9dbcc8 ffff88007e9dbd18 ffff88007f9ad440
Call Trace:
 [<ffffffff80234cad>] do_exit+0x34c/0x7f3
 [<ffffffff802351d1>] do_group_exit+0x7d/0xaa
 [<ffffffff8023de2c>] get_signal_to_deliver+0x31a/0x342
 [<ffffffff8020b4d5>] ? sysret_signal+0x3d/0x67
 [<ffffffff8020a68e>] do_notify_resume+0x7b/0x89f
 [<ffffffff80209b47>] ? __switch_to+0x1b6/0x3b2
 [<ffffffff80225e69>] ? set_next_entity+0x62/0xb2
 [<ffffffff804ef652>] ? thread_return+0x3d/0xc5
 [<ffffffff8020b4d5>] ? sysret_signal+0x3d/0x67
 [<ffffffff8020b877>] ptregscall_common+0x67/0xb0


Code: 48 89 df e8 2b 2e 00 00 48 8b bb 68 05 00 00 48 81 c7 08 08 00 00 e8 2e 0f fe ff 90 41 5b 5b c9 c3 83 7f 18 00 55 48 89 e5 75 04 <0f> 0b eb fe 48 8b 87 60 02 00 00 48 8b 97 a8 02 00 00 48 8d 8f
RIP  [<ffffffff802393d0>] __ptrace_unlink+0xa/0x5b
 RSP <ffff88007e9dbc88>
---[ end trace 9740fb23e0450ea6 ]---


The problem was reproduced on commit 09a05394, and not reproduced on
the commit immediately before it.


> 
> 
> The bisected commit is this:
> 
> commit 09a05394fe2448a4139b014936330af23fa7ec83
> Author: Roland McGrath <roland@redhat.com>
> Date:   Fri Jul 25 19:45:47 2008 -0700
> 
>     tracehook: clone
>     
>     This moves all the ptrace initialization and tracing logic for task
>     creation into tracehook.h and ptrace.h inlines.  It reorganizes the code
>     slightly, but should not change any behavior.
>     
>     There are four tracehook entry points, at each important stage of task
>     creation.  This keeps the interface from the core fork.c code fairly
>     clean, while supporting the complex setup required for ptrace or something
>     like it.
>     
>     Signed-off-by: Roland McGrath <roland@redhat.com>
>     Cc: Oleg Nesterov <oleg@tv-sign.ru>
>     Reviewed-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 

-- 
Eduardo
