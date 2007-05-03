Return-Path: <linux-kernel-owner+w=401wt.eu-S1767444AbXECWOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767444AbXECWOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767447AbXECWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:14:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1248 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767444AbXECWOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:14:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 3 May 2007 15:14:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br> 
 <20070502104936.674a4b54.dada1@cosmosbay.com> 
 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com> 
 <4638C37D.7050503@haxent.com.br>  <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
  <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com> 
 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com> 
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com> 
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com> 
 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Ulrich Drepper wrote:

> On 5/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > I thought you were talking about the poll/epoll interface in general, and
> > the approach on how to extend it for the very few cases that ppl asks for.
> > but I see we're focusing on futexes ...
> 
> Futexes must be part of the whole approach.  If they cannot sanely be
> integrated the whole approach is more than questionable IMO.

Why is that futexes *must* be part of the "whole solution"? Ppl needs 
solutions to specific problems, not an bloated interface that, like a 
giant blob, includes everything just because it exists.



> > I'm not sure if futexes are the best approach to do that, but a way for
> > the user to signal an event into a main event loop is needed.
> 
> I haven't necessarily seen much of this demand and, as you pointed out
> yourself, there is already a completely valid and POSIX compliant way
> to achieve that.  The situation would be very different if you
> couldn't reliably implement this.

Before you try to bash a solution becuase it's costly, then you bounce 
back from another angle, and say that a solution (pipes) that uses 2 
descriptors, one file, one inode, one dentry and 4KB of kernel memory for 
each instance, is a perfectly legal solution.
The 1024 file cap is a bogus problem. If you decided to leave the POSIX 
compatibility (poll/select) for your code, to use something like epoll, it 
means already that your application is handling quite a huge amount of 
files and the 1024 cap must be out of the way. And here the cost 
associated with each file is already pretty big (inode, dentry, file, and 
buffers - for each one of them). We cannot change that cost. 



> I don't suggest this as a long term solution, it's neither nice nor
> fast.  But it is a way to achieve the goal until a real soution comes
> along.  Signals cannot serve as a justification for introducing these
> new concepts.

Fast, I think we have that pretty much covered with Ingo poiting out a few 
flaws in the numbers posted previously. Nice, I'll leave that out. 
Monolitic and interface-centric solutions, or better, solutions in search 
of a problem, do not fit the "nice" category IMO.
So, let's leave hand-waving and ugly/nice BS out of the picture, and let's 
see what is currently missing.
Epoll scales and already covers a large amount of things you may be 
interested in receiving events from. Basically everything that have a 
working f_op->poll.
The other big piece is AIO. Now you can have *another* layer on top of 
AIO, that is included in your blob interface, but why? The AIO API is 
already defined, and all you need is a way to signal the main loop that 
AIO events will be ready to be spilled out from the AIO context. And at 
that point you use the *already existing* AIO API for it. Why do you want 
to add another layer on top? What you end up doing, is pushing userspace 
code into the kernel.
The 20 lines AIO patch I posted, simply signals to an eventfd when the 
AIO context has something to be fetched.
Then we have signals and timers, covered in the other two patches. And all 
this works without being bound to an interface. Your application can just 
use poll if it does not have scalability problems.




- Davide


