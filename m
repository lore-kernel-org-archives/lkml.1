Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXECSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXECSYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXECSYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:24:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4694 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbXECSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:24:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 3 May 2007 11:24:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br> 
 <20070502095503.a06f5472.dada1@cosmosbay.com> 
 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com> 
 <20070502104936.674a4b54.dada1@cosmosbay.com> 
 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com> 
 <4638C37D.7050503@haxent.com.br>  <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
  <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com> 
 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com> 
 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I thought you were talking about the poll/epoll interface in general, and 
the approach on how to extend it for the very few cases that ppl asks for. 
but I see we're focusing on futexes ...


On Thu, 3 May 2007, Ulrich Drepper wrote:

> On 5/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > 99% of the fds you'll find inside an event loop you care to scale about,
> > are *already* fd based.
> 
> You are missing the point.  To get acceptable behavior of the wakeup
> it is necessary with this approach to open one descriptor _per thread_
> for a futex.  Otherwise all threads get woken upon FUTEX_WAKE.
> 
> This also means you need individual epoll sets for each thread.  You
> cannot share them anymore among all the threads in the process.

I'm not sure if futexes are the best approach to do that, but a way for 
the user to signal an event into a main event loop is needed.



> > On top of that, those fds are very cheap in terms of memory
> 
> They might be when they are counted in dozens.  But here we are
> talking about the possible need to use thousands of additional file
> descriptors.  If they are so cheap to allow thousands of descriptors
> with ease, why would the rlimit for files default to a small number
> (1024 on Fedora right now)?

Right now, ppl do that using pipes. That costs 2 file descriptors and at 
least 4KB of kernel data (plus an inode, a dentry and a file). This just 
to have a way to signal to an event loop dispatcher. The patches I posted 
a few weeks ago introduce an eventfd, that reduces the amount of kernel 
memory to basically a dentry and a file (plus uses only one file 
descriptor, and its 2-3 times faster than pipes. Add to that cost, about 
200 lines of code in fs/eventfd.c.



> > And this approach is not bound to a completely new and monolitic interface.
> 
> So?  It's stil additional, new code for an approach which will have to
> be superceded real soon.  That's just pure overhead to me.

IMO it is better to leave futexes alone. They are great for syncronizing 
MT apps, but do not properly fit an fd-based solution. For that, something 
like eventfd is enough.



- Davide


