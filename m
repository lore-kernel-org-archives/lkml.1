Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXEDP2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXEDP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXEDP2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:28:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:49245 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbXEDP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JhKEAo8N2AOvFz6/HGMg/5qj5cY6dtuLYnS8QW2+tAETTKB8Woz9j5J0fVsMBmP2d5H/A8gSdKISx1YnMjioqxJrvwndHqOFstOmVN7YybkW5wLRAQJ9HcseP4zbLxClqzJkCdOk54WqzzaAYi3obSQNQZ5woCdiAq6Xggw0FRA=
Message-ID: <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
Date: Fri, 4 May 2007 08:28:43 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
	 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
	 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
	 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Why is that futexes *must* be part of the "whole solution"? Ppl needs
> solutions to specific problems, not an bloated interface that, like a
> giant blob, includes everything just because it exists.

Sync objects are essential parts of many programs today and most
programs tomorrow.  Currently you cannot efficiently implement working
on multiple independent areas which are protected through some sync
object (mutex, condvar, ...).  You have to create a separate thread
for each.  Looping with the nonlocking mutex, for instance, is no
possibility.  This is solved by being able to get events for the
availability of the sync object.

And before you start and claim that this is no common cases take a
look at the waitformultipleobjects (with studdly caps somewhere) for
windows' API.  The actual interface is horrible, but the concept is
sound (it comes from VMS).  This is the basis of many programs on that
platform.  Basically, the central loop contains such a call.
Currently programs would have to be completely redesigned when ported
to Linux if they use any object which cannot be waited on.

There is much more.  As I tried to point out in last year's OLS paper,
central loops around such a call are the perfect scalability mechanism
and this is what is needed for the processors from today and tomorrow.


> Before you try to bash a solution becuase it's costly, then you bounce
> back from another angle, and say that a solution (pipes) that uses 2
> descriptors, one file, one inode, one dentry and 4KB of kernel memory for
> each instance, is a perfectly legal solution.

Stop.  I call the proposed code costly in terms of the code added to
the kernel which must be maintained and kept in mind when writing the
real next-gen event mechanism.  Not having this code in the kernel
certainly would make a difference.


> Fast, I think we have that pretty much covered with Ingo poiting out a few
> flaws in the numbers posted previously. Nice, I'll leave that out.

You again miss the context.  I was talking about the pipe-based
solution using a signal handler.


> Epoll scales and already covers a large amount of things you may be
> interested in receiving events from. Basically everything that have a
> working f_op->poll.

epoll doesn't scale if every thread needs its own epoll set.  Beside
the overhead this also has huge program design problems: how do you
atomically remove a file descriptor from a collection of epoll sets?


> The other big piece is AIO. Now you can have *another* layer on top of
> AIO, that is included in your blob interface, but why?

I don't know how you arrive at AIO now.  kevent itself is independent
of the AIO code which was done at the same time by the same person.
It was just one kernel service which uses the event functionality.
The two must be judged independently.
