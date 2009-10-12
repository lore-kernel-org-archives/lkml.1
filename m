Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZJLOyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZJLOyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZJLOyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:54:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbZJLOyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:54:35 -0400
Subject: Re: Mutex vs semaphores scheduler bug
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwin@clamav.net>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       aCaB <acab@clamav.net>, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4AD0A0F7.9070700@clamav.net>
References: <4AD0A0F7.9070700@clamav.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 12 Oct 2009 16:53:27 +0200
Message-Id: <1255359207.10420.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 17:57 +0300, Török Edwin wrote:
> If a semaphore (such as mmap_sem) is heavily congested, then using a
> userspace mutex makes the program faster.
> 
> For example using a mutex around *anonymous* mmaps, speeds it up
> significantly (~80% on this microbenchmark,
> ~15% on real applications). Such workarounds shouldn't  be necessary for
> userspace applications, the kernel should
> by default use the most efficient implementation for locks.

Should, yes, does, no.

> However when using a mutex the number of context switches is SMALLER by
> 40-60%.

That matches the problem, see below.

> I think its a bug in the scheduler, it scheduler the mutex case much
> better. 

It's not, the scheduler doesn't know about mutexes/futexes/rwsems.

> Maybe because userspace also spins a bit before actually calling
> futex().

Nope, if we would ever spin, it would be in the kernel after calling
FUTEX_LOCK (which currently doesn't exist). glibc shouldn't do any
spinning on its own (if it does, I have yet another reason to try and
supplant the glibc futex code).

> I think its important to optimize the mmap_sem semaphore

It is.

The problem appears to be that rwsem doesn't allow lock-stealing, and
very strictly maintains FIFO order on contention. This results in extra
schedules and reduced performance as you noticed.

What happens is that when we release a contended rwsem we assign it to
the next waiter, if before that waiter gets ran, another (running) tasks
comes along and tries to acquire the lock, that gets put to sleep, even
though it could possibly get to acquire it (and the woken waiter would
detect failure and go back to sleep).

So what I think we need to do is have a look at all this lib/rwsem.c
slowpath code and hack in lock stealing.


