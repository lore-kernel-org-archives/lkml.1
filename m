Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZALQP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZALQP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZALQPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:15:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZALQPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:15:08 -0500
Message-ID: <496B6C23.8000808@redhat.com>
Date: Mon, 12 Jan 2009 18:13:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
References: <1231774622.4371.96.camel@laptop>
In-Reply-To: <1231774622.4371.96.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Subject: mutex: implement adaptive spinning
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jan 12 14:01:47 CET 2009
>
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.
>
> This concept got ported to mainline from the -rt tree, where it was originally
> implemented for rtmutexes by Steven Rostedt, based on work by Gregory Haskins.
>
> Testing with Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
> gave a 345% boost for VFS scalability on my testbox:
>
>  # ./test-mutex-shm V 16 10 | grep "^avg ops"
>  avg ops/sec:               296604
>
>  # ./test-mutex-shm V 16 10 | grep "^avg ops"
>  avg ops/sec:               85870
>
> The key criteria for the busy wait is that the lock owner has to be running on
> a (different) cpu. The idea is that as long as the owner is running, there is a
> fair chance it'll release the lock soon, and thus we'll be better off spinning
> instead of blocking/scheduling.
>
> Since regular mutexes (as opposed to rtmutexes) do not atomically track the
> owner, we add the owner in a non-atomic fashion and deal with the races in
> the slowpath.
>
> Furthermore, to ease the testing of the performance impact of this new code,
> there is means to disable this behaviour runtime (without having to reboot
> the system), when scheduler debugging is enabled (CONFIG_SCHED_DEBUG=y),
> by issuing the following command:
>
>  # echo NO_OWNER_SPIN > /debug/sched_features
>
> This command re-enables spinning again (this is also the default):
>
>  # echo OWNER_SPIN > /debug/sched_features
>   

One thing that worries me here is that the spinners will spin on a 
memory location in struct mutex, which means that the cacheline holding 
the mutex (which is likely to be under write activity from the owner) 
will be continuously shared by the spinners, slowing the owner down when 
it needs to unshare it.  One way out of this is to spin on a location in 
struct mutex_waiter, and have the mutex owner touch it when it schedules 
out.

So:
- each task_struct has an array of currently owned mutexes, appended to 
by mutex_lock()
- mutex waiters spin on mutex_waiter.wait, which they initialize to zero
- when switching out of a task, walk the mutex list, and for each mutex, 
bump each waiter's wait variable, and clear the owner array
- when unlocking a mutex, bump the nearest waiter's wait variable, and 
remove from the owner array

Something similar might be done to spinlocks to reduce cacheline 
contention from spinners and the owner.

-- 
error compiling committee.c: too many arguments to function

