Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXCJWmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXCJWmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbXCJWmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:42:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58102 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXCJWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:42:09 -0500
Date: Sat, 10 Mar 2007 14:42:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173563796.2958.28.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
 <1173563796.2958.28.camel@entropy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Nicholas Miell wrote:
> 
> Care to elaborate on why they're a horrible crock?

It's a *classic* case of an interface that tries to do everything under 
the sun.

Here's a clue: look at any system call that takes a union as part of its 
arguments. Count them. I think we have two:
 - struct siginfo
 - struct sigevent
and they are both broken horrible interfaces where the data structures 
depend on various flags.

It's just not the UNIX system call way. And none of it really makes sense 
if you already have a file descriptor, since at that point you know what 
the notification mechanism is.

I'd actually much rather do POSIX timers the other way around: associate a 
generic notification mechanism with the file descriptor, and then 
implement posix_timer_create() on top of timerfd. Now THAT sounds like a 
clean unix-like interface ("everything is a file") and would imply that 
you'd be able to do the same kind of notification for any file descriptor, 
not just timers.

But posix timers as they are done now are just an abomination. They are 
not unix-like at all.

> And are the bugs fixed? If so, why replace them? They work now.

.. but the reason for the bugs was largely a very baroque interface, which 
didn't get fixed (because it's specified by the standard).

I'd rather have straightforward interfaces. The timerfd() one lookedalot 
more straightforward than posix timers.

(That said, using "struct itimerspec" might be a good idea. That would 
also obviate the need for TFD_TIMER_SEQ, since an itimerspec automatically 
has both "base" and "incremental" parts).

		Linus
