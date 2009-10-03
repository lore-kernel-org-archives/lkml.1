Return-Path: <linux-kernel-owner+w=401wt.eu-S1751274AbZJCEO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbZJCEO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 00:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZJCEO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 00:14:28 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48280 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZJCEO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 00:14:28 -0400
Message-ID: <4AC6CF92.8020800@gmail.com>
Date: Sat, 03 Oct 2009 06:14:10 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Anirban Sinha <ASinha@zeugmasystems.com>
CC: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Kaz Kylheku <KKylheku@zeugmasystems.com>
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <DDFD17CC94A9BD49A82147DDF7D545C501FD860D@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501FD860D@exchange.ZeugmaSystems.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 03 Oct 2009 06:14:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anirban Sinha a écrit :
>>
>> Thanks for sending the patch.  I'm looking into it now.  Couple
> questions:
>> 1) What caused you to instrument this path in the first place?  Were
> you
>> seeing some unexpected behavior?
> 
> Basically, all this started as a means to aid debug or at least isolate
> cases of memory corruption. When a process holding a futex died, the
> robust futex cleanup operation can be foiled if there are any memory
> corruptions in the user land. The "carefully inspecting the user land
> linked list" part would bail out silently. So no process would get
> EOWNERDEAD and wake up. So we decided to add printks so that we can
> track these silent return cases.
> 
> We thought that actual number of cases of silently bailing out would be
> rare so we did not expect any of those logs in the kernel buffer under
> regular circumstances. To our surprise, we found lots of those logs!
> This puzzled us.  I looked at the code again and again but it deed some
> seem to have any issues. Then it occurred to us (kaz) that an execve()
> call can also cause invalid pointer values to remain in the task
> structure. I did some testing and it seemed to indicate that this was
> indeed the case.
> 
> There is a discussion on this by Kaz on the linux mips mailing list:
> 
> http://www.linux-mips.org/archives/linux-mips/2009-09/msg00130.html

This exactly looks like what I discovered a while ago about futex used
for pthread management. Anirban, this is a real security flaw and this
should be fixed as fast as possible :)

Commit 9c8a8228d0827e0d91d28527209988f672f97d28
author	Eric Dumazet <eric.dumazet@gmail.com>
	Thu, 6 Aug 2009 22:09:28 +0000 (15:09 -0700)
execve: must clear current->clear_child_tid

While looking at Jens Rosenboom bug report
(http://lkml.org/lkml/2009/7/27/35) about strange sys_futex call done from
a dying "ps" program, we found following problem.

clone() syscall has special support for TID of created threads.  This
support includes two features.

One (CLONE_CHILD_SETTID) is to set an integer into user memory with the
TID value.

One (CLONE_CHILD_CLEARTID) is to clear this same integer once the created
thread dies.

The integer location is a user provided pointer, provided at clone()
time.

kernel keeps this pointer value into current->clear_child_tid.

At execve() time, we should make sure kernel doesnt keep this user
provided pointer, as full user memory is replaced by a new one.

As glibc fork() actually uses clone() syscall with CLONE_CHILD_SETTID and
CLONE_CHILD_CLEARTID set, chances are high that we might corrupt user
memory in forked processes.

Following sequence could happen:

1) bash (or any program) starts a new process, by a fork() call that
   glibc maps to a clone( ...  CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID
   ...) syscall

2) When new process starts, its current->clear_child_tid is set to a
   location that has a meaning only in bash (or initial program) context
   (&THREAD_SELF->tid)

3) This new process does the execve() syscall to start a new program.
   current->clear_child_tid is left unchanged (a non NULL value)

4) If this new program creates some threads, and initial thread exits,
   kernel will attempt to clear the integer pointed by
   current->clear_child_tid from mm_release() :

        if (tsk->clear_child_tid
            && !(tsk->flags & PF_SIGNALED)
            && atomic_read(&mm->mm_users) > 1) {
                u32 __user * tidptr = tsk->clear_child_tid;
                tsk->clear_child_tid = NULL;

                /*
                 * We don't check the error code - if userspace has
                 * not set up a proper pointer then tough luck.
                 */
<< here >>      put_user(0, tidptr);
                sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
        }

5) OR : if new program is not multi-threaded, but spied by /proc/pid
   users (ps command for example), mm_users > 1, and the exiting program
   could corrupt 4 bytes in a persistent memory area (shm or memory mapped
   file)

If current->clear_child_tid points to a writeable portion of memory of the
new program, kernel happily and silently corrupts 4 bytes of memory, with
unexpected effects.

Fix is straightforward and should not break any sane program.

Reported-by: Jens Rosenboom <jens@mcbone.net>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

