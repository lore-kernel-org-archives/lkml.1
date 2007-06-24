Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXFXSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXFXSM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXFXSMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:12:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:6007 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXFXSMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jNX09NmdUt0XF8+dOM6hWvfBr5dnCp1Aq6eu47KzAUrIkyYrbhXJ2GWprG/EmEo5+kk9TaPFacbCQHVjV1H0aUXtDgp0BxgpYg0v5teGYneWW1rew8E8S+YIBYEda2K96bwDWjOMslKX8i5hWVqZvqtTAhChrCJ+RGjgxmdwKFE=
Message-ID: <a781481a0706241112g5d50a0c7necdebb1c8d3bca09@mail.gmail.com>
Date: Sun, 24 Jun 2007 23:42:47 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706241256380.8409@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622173839.GB8398@iucha.net>
	 <200706221934.18436.arnd@arndb.de>
	 <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
	 <200706231402.03617.arnd@arndb.de>
	 <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
	 <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain>
	 <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com>
	 <Pine.LNX.4.64.0706241123130.7006@localhost.localdomain>
	 <a781481a0706240945j3a8afe8dkbb6b74d92bdedfc4@mail.gmail.com>
	 <Pine.LNX.4.64.0706241256380.8409@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sun, 24 Jun 2007, Satyam Sharma wrote:
>
> > Whoa, hold on. But I've been explicitly mentioning *binary*
> > semaphores all along!
> >
> > Of course users who want / allow multiple tasks (but only upto a
> > specific maximum number, which is what counted semaphores are all
> > about) to be present in a given critical section simultaneously
> > would still want to use the _counted_ semaphores, which is why you
> > won't see the old "struct semaphores" dying anytime soon.
>
> ah, ok, i've been misreading all this, sorry.  i'm wondering, then,
> if, given both mutexes and completions, whether the general semantics
> of semaphores can be tightened up at all.  just curious.

[ Ok, I'll elaborate, just in case someone else interested regarding
this is watching or reading the archives ... but this may be waaaaay
too basic for you and others here, so those can safely ignore it. ]

First: By a semaphore being binary, I mean that the value of that
semaphore (counter) variable can only be 0 or 1. Say we follow the
rule that 1 == available (unlocked) and 0 == unavailable (locked).
So down == lock == test-and-decrement, up == unlock == increment.

Also, note that there is nothing (I'm _not_ talking of implementation
details here) that the "struct mutex" can do something that a *binary*
"struct semaphore" can't, if usage ensures that its value is always
in {0, 1}. So semantically speaking they are equivalent.

1. (Binary) semaphores used for locking:
========================================

Binary semaphores may be used to synchronize access to critical sections
that can (must) only be executed by _only_ *one* task at any given time.
That is, _no_ concurrent execution of that piece of code can be tolerated.
This is often the most common case / usage to implement lock-protection
of any shared data.

Now obviously, because only _one_ task can be in such critical sections
at any given time, who (and only who) can be allowed to unlock the
semaphore (i.e. increment the counter variable back to 1)?

The task that took this (binary) semaphore in the first place, isn't it?
So this precisely one of those extra sanity checks that the "struct
mutex" introduces. [ There are other sanity checks listed at the top of
include/linux/mutex.h, but this is one of the important ones, IMHO. ]

Why is this check _not_ applicable to *counting* semaphores? Because
_multiple_ tasks can be in that given critical section _concurrently_
so the task that _last_ down()'ed the semaphore *need not be* forced
to be same as the task that _next_ wants to up() it!

2. Semaphores used to indicate completion:
==========================================

Ok, this one's again purely an implementation thing -- in fact if you
look at the way "struct semaphore"s are currently implemented in the
kernel they _do_ use waitqueues, which is precisely what
"struct completion"s use as well. The difference is even less pronounced
because all down()'s do become (in the slowpath i.e. when the test failed
so we decide to schedule() ourselves out) _add_wait_queue_tail with
callers marking themselves as exclusive waiters), and all up()'s also do
call __wake_up_common with NR_EXCLUSIVE == 1 to ensure that at
least one exclusively-waiting task _is_ woken up when the lock is
released (i.e. counter incremented).

So this basically means that one _can_ use semaphores as completion
notification primitives, and also (to again give the technically
accurate answer to Florin's original question on this thread) "upping"
is not illegal per-se from interrupt/atomic contexts.

But wait_for_completion() and complete() are to be still preferred in
new code (although they have a very similar implementation) because they
are specifically for this purpose, plus they avoid all the extra
fastpath/lock-acquiring stuff that the semaphore implementation involves
(and one less member in the struct if nothing else). [ I have never
benchmarked, of course, but I'd expect use of the completion primitives
to be microscopically faster than using semaphores in this manner too. ]

Satyam
