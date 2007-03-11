Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXCKFbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXCKFbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 00:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXCKFbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 00:31:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbXCKFbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 00:31:07 -0500
Date: Sat, 10 Mar 2007 21:31:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173577759.2958.124.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703102119020.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
  <1173563796.2958.28.camel@entropy>  <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
  <1173572751.2958.107.camel@entropy>  <Pine.LNX.4.64.0703101630260.10330@woody.linux-foundation.org>
 <1173577759.2958.124.camel@entropy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Nicholas Miell wrote:
> 
> Ah, I see. You're just interested in fds as a generic handle concept,
> and not a more Plan 9 type thing.

Indeed. It's a "handle".

UNIX has pid's for "process" handles, and "file descriptors" for just 
about everything else.

> If that's the goal, somebody should start thinking about reducing the
> contents of struct file to the bare minimum (i.e. not much more than a
> file_operations pointer).

Well, there's more there, but it really is fairly close. If you look at 
it, a "struct file" ends up not having a lot more than the minimal stuff 
required to use it as a a handle: it really isn't a very big structure. 

The biggest part is actually the read-ahead state, which is arguably a 
generic thing for a file handle, even though not all kinds will be able to 
use it. We *could* make that be behind a pointer (along with the "f_pos" 
thing, that really logically goes along with the read-ahead thing), of 
course, but since most files probably do end up being "traditional file" 
structures, it's probably not wrong to just have it in the file.

> It'd be useful if the polling interfaces could return small datums
> beyond just the POLL* flags -- having to do a read on timerfd just to
> get the overrun count has a lot of overhead for just an integer, and I
> imagine other things would like to pass back stuff too.

Well, since a lot of the interfaces harken back to "select()", we really 
are stuck with basically a couple of bits total (poll extends on the 
number of bits, but not a whole lot). So right now we have just "an event 
happened", and if you want to know more, you do need to do a read() or 
similar. That's true of all the traditional file descriptors too, of 
course.

> You still want timeouts, creating/setting/destroying at timer just for
> a single call to select/poll/epoll is probably too heavy weight.

Well, since the interfaces for that already exists, I'm certainly not 
going to disagree.

> timerfd() still leaves out the basic clock selection functionality
> provided by both setitimer() and timer_create().

Well, the setitimer ones do not really make sense for a timer that isn't 
directly associated with one particular process. Once it's associated with 
a file descriptor, it really isn't bound to any particular execution 
context, and as such, virtual and profiling timers really don't make any 
sense any more!

The only thing that exists outside of an execution context is really just 
"relative" and "absolute". Of course, you could still specify just what 
you want your timers to be based on (ie the "realtime" vs "monotonic" 
thing), and possibly the resolution, but it really does boil down to just 
those two choices (and the rest is just confusion).

So I really don't think you lose a lot by just limiting it to "real time" 
vs "relative time". Those really *are* the choices.

			Linus
