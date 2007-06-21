Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbXFUQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbXFUQDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXFUQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:03:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbXFUQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:03:01 -0400
Date: Thu, 21 Jun 2007 09:01:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621073800.GA1685@ff.dom.local>
Message-ID: <alpine.LFD.0.98.0706210851570.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073800.GA1685@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Jarek Poplawski wrote:
> 
> BTW, I've looked a bit at these NMI watchdog traces, and now I'm not
> even sure it's necessarily the spinlock's problem (but I don't exclude
> this possibility yet). It seems both processors use task_rq_lock(), so
> there could be also a problem with that loop.

I agree that that is also this kind of "loop getting a lock" loop, but if 
you can see it actually happening there, we have some other (and major) 
bug.

That loop is indeed a loop, but realistically speaking it should never be 
run through more than once. The only reason it's a loop is that there's a 
small small race where we get the information at the wrong time, get the 
wrong lock, and try again.

So the loop certainly *can* trigger (or it would be pointless), but I'd 
normally expect it not to, and even if it does end up looping around it 
should happen maybe *one* more time, absolutely not "get stuck" in the 
loop for any appreciable number of iterations.

So I don't see how you could possibly having two different CPU's getting 
into some lock-step in that loop: changing "task_rq()" is a really quite 
heavy operation (it's about migrating between CPU's), and generally 
happens at a fairly low frequency (ie "a couple of times a second" kind of 
thing, not "tight CPU loop").

But bugs happen..

> Another possible problem could be a result of some wrong optimization
> or wrong propagation of change of this task_rq(p) value.

I agree, but that kind of bug would likely not cause temporary hangs, but 
actual "the machine is dead" operations. If you get the totally *wrong* 
value due to some systematic bug, you'd be waiting forever for it to 
match, not get into a loop for a half second and then it clearing up..

But I don't think we can throw the "it's another bug" theory _entirely_ 
out the window.

That said, both Ingo and me have done "fairness" testing of hardware, and 
yes, if you have a reasonably tight loop with spinlocks, existing hardware 
really *is* unfair. Not by a "small amount" either - I had this program 
that did statistics (and Ingo improved on it and had some other tests 
too), and basically if you have two CPU's that try to get the same 
spinlock, they really *can* get into situations where one of them gets it 
millions of times in a row, and the other _never_ gets it.

But it only happens with badly coded software: the rule simply is that you 
MUST NOT release and immediately re-acquire the same spinlock on the same 
core, because as far as other cores are concerned, that's basically the 
same as never releasing it in the first place.

			Linus
