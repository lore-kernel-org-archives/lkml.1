Return-Path: <linux-kernel-owner+w=401wt.eu-S935244AbXKPXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244AbXKPXhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762121AbXKPXhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:37:36 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:36230 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbXKPXhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:37:35 -0500
Date: Fri, 16 Nov 2007 18:37:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
In-Reply-To: <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On Sat, 17 Nov 2007, Remy Bohmer wrote:

> Hello Steven,
>
> Thanks for your reply
>
> > The above sounds more like you need a completion.
> Funny, I first started with using completion structures, but that did
> not work either. I get similar OOPses on all these kind of locking
> mechanisms, as long as I use the _interruptible() type. I tried every
> work-around I can think of, but none worked :-((
> Even if I block on an ordinary rt-mutex in the same routine, wait a
> _interruptible() type, I get the same problem.

The taker of a mutex must also be the one that releases it.  I don't see
how you could use a mutex for this. It really requires some kind of
completion, or a compat_semaphore.

>
> > What's used to wake up the caller of down_interruptible?
> A call to up() is used from inside an interrupt(thread) context, but
> this is not relevant for the problem, because only blocking on a
> semaphore with down_interruptible() and waking the thread by CTRL-C is
> enough to get this Oops.
>
> I saw that the code is trying to wake 'other waiters', while there is
> only 1 thread waiting on the semaphore at most. I feel that the root
> cause of this problem has to be searched there.
>
> I believe that executing any PI code on semaphores is a strange
> behavior anyway, because a semaphore is never 'owned' by a thread, and
> it is always another thread that wakes the thread that blocks on a
> semaphore, and because the waker is unknown, the PI code will always
> boost the prio of the wrong thread.

Exactly why it should be a completion or compat semaphores. The reason we
did PI on semaphores is only because they were used as mutexes before Ingo
pushed to actually get a mutex primative into the kernel. Since then,
we've been trying to remove all semaphores with either a mutex or
completion.

>
> Strange is also, that I get different behavior on ARM if I use
> sema_init(&sema, 1) versus sema_init(&sema,0). The latter seems to
> crash less, it will not crash until the first up(); while the first
> will crash even without any up().
>
> Attached I have put a sample driver I just hacked together a few
> minutes ago. It is NOT the driver that has generates the oops in the
> previous mail, but I have stripped a scull-driver down that much that
> it will be much easier to talk about, and to keep us focussed on the
> part of the code that is causing this.
> Besides: I tested this driver on X86 with 2.6.23.1-rt5 and I get the
> also OOPSes although slightly different than on ARM. See the attached
> dummy.txt file.
>
>
> Beware: The up(&sema) is NOT required to get this OOPS, I get it even
> without any up(&sema) !
>
> I hope you can look at the attached driver source and help me with this...
>

        down_interruptible(&dummy);
        printk("We will block now, and if you press CTRL-C from here, we get an OOPS.\n");
        down_interruptible(&dummy);


This double down is actually illegal with rt semaphores. Because we treat
semaphores as mutexes unless they are declared as compat_semaphores. In
which case we don't do PI.

Seems that you need to work out how to use a completion for your code. And
if that doesn't work, then use a compat_semaphore. But beware, that the
compat_semaphore can cause unbounded latencies. But then again, so can
completions.


-- Steve

