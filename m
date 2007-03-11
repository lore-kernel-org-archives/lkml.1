Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbXCKBtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbXCKBtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXCKBtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:49:23 -0500
Received: from sccrmhc14.comcast.net ([204.127.200.84]:53433 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbXCKBtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:49:22 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
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
	 <1173572751.2958.107.camel@entropy>
	 <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 17:49:19 -0800
Message-Id: <1173577759.2958.124.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 16:35 -0800, Linus Torvalds wrote:
> 
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> > > 
> > > I'd actually much rather do POSIX timers the other way around: associate a 
> > > generic notification mechanism with the file descriptor, and then 
> > > implement posix_timer_create() on top of timerfd. Now THAT sounds like a 
> > > clean unix-like interface ("everything is a file") and would imply that 
> > > you'd be able to do the same kind of notification for any file descriptor, 
> > > not just timers.
> > > 
> > 
> > But timers aren't files or even remotely file-like
> 
> What do you think "a file" is?
> 
> In UNIX, a file descriptor is pretty much anything. You could say that 
> sockets aren't remotely file-like, and you'd be right. What's your point? 
> If you can read on it, it's a file.

Ah, I see. You're just interested in fds as a generic handle concept,
and not a more Plan 9 type thing.

If that's the goal, somebody should start thinking about reducing the
contents of struct file to the bare minimum (i.e. not much more than a
file_operations pointer).

> 
> And the real point of the whole signalfd() is that there really *are* a 
> lot of UNIX interfaces that basically only work with file descriptors. Not 
> just read, but select/poll/epoll.

It'd be useful if the polling interfaces could return small datums
beyond just the POLL* flags -- having to do a read on timerfd just to
get the overrun count has a lot of overhead for just an integer, and I
imagine other things would like to pass back stuff too.


> They currently have just one timeout, but the thing is, if UNIX had just 
> had "timer file descriptors", they'd not need even that one. And even with 
> the timeout, Davide's patch actually makes for a *better* timeout than the 
> ones provided by select/poll/epoll, exactly because you can do things like 
> repeating timers and absolute time etc.
> 
> Much more naturally than the timer interface we currently have for those 
> system calls.
> 

You still want timeouts, creating/setting/destroying at timer just for
a single call to select/poll/epoll is probably too heavy weight.

timerfd() still leaves out the basic clock selection functionality
provided by both setitimer() and timer_create().

> The same goes for signals. The whole "pselect()" thing shows that signals 
> really *should* have been file descriptors, and suddenly you don't need 
> "pselect()" at all.
> 
> So the "not remotely file-like" is not actually a real argument. One of 
> the big *points* of UNIX was that it unified a lot under the general 
> umbrella of a "file descriptor". Davide just unifies even more.
>
> 		Linus
-- 
Nicholas Miell <nmiell@comcast.net>

