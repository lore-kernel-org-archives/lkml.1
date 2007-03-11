Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXCKAZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXCKAZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXCKAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:25:54 -0500
Received: from sccrmhc15.comcast.net ([204.127.200.85]:55468 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbXCKAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:25:53 -0500
X-Greylist: delayed 12278 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 19:25:53 EST
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
	 <1173556374.2958.12.camel@entropy>
	 <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
	 <1173560473.2958.23.camel@entropy>
	 <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
	 <1173563796.2958.28.camel@entropy>
	 <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 16:25:51 -0800
Message-Id: <1173572751.2958.107.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 14:42 -0800, Linus Torvalds wrote:
> 
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> > 
> > Care to elaborate on why they're a horrible crock?
> 
> It's a *classic* case of an interface that tries to do everything under 
> the sun.
> 
> Here's a clue: look at any system call that takes a union as part of its 
> arguments. Count them. I think we have two:
>  - struct siginfo

No argument here -- just about everything related to signals is stupidly
complex.

>  - struct sigevent

However, this I take issue with.

Conceptually (and what the user ends up actually using), struct sigevent
is just:

struct sigevent
{
	int sigev_notify;			 /* delivery method */
	sigval_t sigev_value			 /* user cookie */
	int sigev_signo;			 /* signal number */
	void (*sigev_notify_function)(sigval_t); /* thread fn */
	pthread_attr_t *sigev_notify_attributes; /* thread attr */
};

You could complain about sigval_t being a union, but that's probably
just because it predates uintptr_t. (Plus, no ugly casting.)

You also could complain that the above isn't what you actually see when
you look at /usr/include/bits/siginfo.h -- there's a union involved and
some macros to hide the fact, but that's just internal implementation
details related to how threads are created and padding out the struct
for any future expansion. 

The actual complexity for understanding and using struct sigevent isn't
all that much, and once you've figured that out, you know how to
configure event delivery for AIO completion, DNS resolution, and
messages queues, not just timers.

> and they are both broken horrible interfaces where the data structures 
> depend on various flags.
> 
> It's just not the UNIX system call way. And none of it really makes sense 
> if you already have a file descriptor, since at that point you know what 
> the notification mechanism is.
> 
> I'd actually much rather do POSIX timers the other way around: associate a 
> generic notification mechanism with the file descriptor, and then 
> implement posix_timer_create() on top of timerfd. Now THAT sounds like a 
> clean unix-like interface ("everything is a file") and would imply that 
> you'd be able to do the same kind of notification for any file descriptor, 
> not just timers.
> 

But timers aren't files or even remotely file-like -- if they were a
real files, you could just
open /dev/timers/realtime/2007/June/3rd/half-past-teatime and get a
timer. (Or, more realisticly, open /dev/timer and use ioctl().)

timerfd() had to be created to coerce them into some semblance of
filehood just to make them work with existing (and new) polling/queuing
interfaces just because those interfaces can only deal with file
descriptors.

Making non-file things look like files just because that's what poll()
and friends can deal with isn't much different from holding a hammer in
your hand and looking for what you have to do in order to turn every
problem into a nail.

Sometimes you need to go back to your toolbox for a screwdriver or a
saw.


> But posix timers as they are done now are just an abomination. They are 
> not unix-like at all.
> 
> > And are the bugs fixed? If so, why replace them? They work now.
> 
> .. but the reason for the bugs was largely a very baroque interface, which 
> didn't get fixed (because it's specified by the standard).
>

But the API isn't baroque.

There's a veritable boutique of clock sources to choose from, but they
all serve specific needs, it's just one parameter to timer_create, and
you probably want CLOCK_MONOTONIC anyway.

struct sigevent  might be a bit complex, but the difficultly in learning
that is amortized across all the other APIs that also use it to specify
how their events are delivered.

Delivering via signals and dealing with struct siginfo is painful, but
everything related to signals is painful. This is what you get when you
take an interface designed essentially for exception handling and start
abusing it for general information delivery. But, hey!, that's what
SIGEV_THREAD and SIGEV_PORT are for.[1]

About the worst that can be said of it is that using timer_settime to
both arm and disarm the timer and set the interval is awkward.






[1] A SIGEV_FUNCTION which skips all the signal baggage and just passes
a supplied cookie and a purpose-specific struct pointer to an
object-specific user-supplied function pointer might be interesting, but
then you run into all of the reentrancy/masking/choosing which thread to
deliver to and other issues that signals already have without the
benefit of the existing signal infrastructure for all that stuff. Gah, I
don't want to think about this anymore.

-- 
Nicholas Miell <nmiell@comcast.net>

