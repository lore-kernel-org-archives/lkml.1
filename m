Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbXEBMUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbXEBMUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXEBMUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:20:20 -0400
Received: from haxent.com ([65.99.219.155]:4916 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbXEBMUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:20:16 -0400
Message-ID: <463881FB.3010300@haxent.com.br>
Date: Wed, 02 May 2007 09:20:11 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br> <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
In-Reply-To: <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/1/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> The pollable futex approach is far superior (send and receive events from
>> userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.
>> [...]
> 
> You have to explain in detail how these interfaces are supposed to
> work.  From first sight and without understanding (all) the it seems
> it's far from useful.

It's basically a asynchronous FUTEX_WAIT with notification delivery
through a file descriptor.

> Pollable futexes are useful, but any solution which gets implemented
> must be sufficiently useful for all the uses we might have.

It's very useful for asynchronous event notification libraries
(libevent, liboop, libivykis, etc) because it integrates nicely with
their (e)poll main loops.

Usage schenario: you have 10 worker threads (and 10 futexes) for  disk
i/o (or whatever) and one manager thread which is a state machine
serving many clients (epoll loop).

In this scenario the workers threads have only two possible ways of
notifying the manager thread once a job is done: signals and pipe tricks.

For libraries, signals sux. They dont integrate well with poll() loops,
may have overflow issues (RT), and signal numbers may clash with other
libraries/code. The self-pipe trick waste resources (mostly unused pipe
buffer).

By using pollable futexes, all the manager thread has todo is to
associate each of these futexes with a file descriptor (plfutex) and
epoll() for their completion. Once the futex is signaled, epoll()
returns POLLIN for the file descriptor and the manager thread may
dequeue the notification status from anywhere.


> - the trivial is that you have a futex and you are just interest in
> seeing it change.   The same as FUTEX_WAIT. 

I'm just interested in seeing a FUTEX_WAKE. Yes, same as FUTEX_WAIT.

> I cannot figure out how all this works in your code.

Every futex has a wait queue (q->waiters) which is used to track
processes waiting on the futex. When the futex receives a FUTEX_WAKE it
wakes up all waiters on the wait queue. Also, a futex is considered
woken when it wait queue is empty (or lock_ptr == NULL).

When you register a file descriptor with select(), poll() or epoll() a
callback is queued into the futex wait queue. When the futex receives a
FUTEX_WAKE every callback is called and the event is registered within
each select(), poll() or epoll() table. This initiates a chain reaction
waking up all process sleeping on poll()/whatever.

> Does your read() call (that's the one to wait, yes?) work with O_NONBLOCK
> or how else do you get that behavior?

If the fd is marked O_NONBLOCK and the futex is not woken yet, it simply
returns -EAGAIN (pfs_read_nonblock). If O_NONBLOCK is not set, it waits
synchronously (pfs_read_block/wait_event_interruptible) on the futex
wait queue.

> - more complicated case: I have to wait for multiple futexes and lock
> them all at the same time or don't return at all.  This is possible with
> SysV semaphores and generally useful and needed. How can this be
> implemented with your scheme?

Remember, it's only about FUTEX_WAIT.

> - how does it work with PI futexes?

It dosen't work. AFAICS PI futexes don't use FUTEX_WAKE.

> - can I use a futex at the same time through this mechanism and using the normal
>   FUTEX_WAIT operation?  This is a killer if it's not the case.

Yes.

> - if you have multiple threads polling a futex and the waker wakes up
> one, what happens? It is simply not acceptable to have more than one 
> thread return from the poll() call, this would waste too many cycles,
> just to put all threads but one back to sleep.

Only one is waked up (whatever matches first on the futex hashed bucket).

--
Davi Arnaut
