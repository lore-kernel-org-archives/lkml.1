Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXB0KOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXB0KOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXB0KOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:14:23 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36238 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030576AbXB0KOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:14:22 -0500
Date: Tue, 27 Feb 2007 13:09:09 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227100909.GA23170@2ka.mipt.ru>
References: <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru> <20070226203543.GB23357@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226203543.GB23357@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 13:09:28 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:35:43PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > If kernelspace rescheduling is that fast, then please explain me why 
> > userspace one always beats kernel/userspace?
> 
> because 'user space scheduling' makes no sense? I explained my thinking 
> about that in a past mail:
> 
> -------------------------->
> One often repeated (because pretty much only) performance advantage of 
> 'light threads' is context-switch performance between user-space 
> threads. But reality is, nobody /cares/ about being able to 
> context-switch between "light user-space threads"! Why? Because there 
> are only two reasons why such a high-performance context-switch would 
> occur:
> 
>  1) there's contention between those two tasks. Wonderful: now two
>     artificial threads are running on the /same/ CPU and they are even
>     contending each other. Why not run a single context on a single CPU
>     instead and only get contended if /another/ CPU runs a conflicting
>     context?? While this makes for nice "pthread locking benchmarks",
>     it is not really useful for anything real.

Obviously there must be several real threads, each of them can reschedule 
userspace threads, because it is fast and scalable.
So, one CPU - one real thread.

>  2) there has been an IO event. The thing is, for IO events we enter the
>     kernel no matter what - and we'll do so for the next 10 years at
>     minimum. We want to abstract away the hardware, we want to do
>     reliable resource accounting, we want to share hardware resources,
>     we want to rate-limit, etc., etc. While in /theory/ you could handle
>     IO purely from user-space, in practice you dont want to do that. And
>     if we accept the premise that we'll enter the kernel anyway, there's
>     zero performance difference between scheduling right there in the
>     kernel, or returning back to user-space to schedule there. (in fact
>     i submit that the former is faster). Or if we accept the theoretical
>     possibility of 'perfect IO hardware' that implements /all/ the
>     features that the kernel wants (in a secure and generic way, and
>     mind you, such IO hardware does not exist yet), then /at most/ the
>     performance advantage of user-space doing the scheduling is the
>     overhead of a null syscall entry. Which is a whopping 100 nsecs on
>     modern CPUs! That's roughly the latency of a /single/ DRAM access!
> ....

And here were start our discussion again from the begining :)
We entered kernel, of course, but then kernel decides to move thread
away and put another one on its place under hardware sun - so kernel
starts to move registers, change some states and so on.

While in case of userspace threads we arelady returned back to userspace
(on behalf of written above overhead) and start doing new task - move
registers, change some states and so one.

And somehow it happens that doing it in userspace (for example with
setjmp/longjmp) is faster than in kernel. I do not know why - I never
investigated that case, but that is it.

> <-----------
> 
> (see http://lwn.net/Articles/219958/)
> 
> btw., the words that follow that section are quite interesting in 
> retrospect:
> 
> | Furthermore, 'light thread' concepts can no way approach the 
> | performance of #2 state-machines: if you /know/ what the structure of 
> | your context is, and you can program it in a specialized state-machine 
> | way, there's just so many shortcuts possible that it's not even funny.
> 
> [ oops! ;-) ]
> 
> i severely under-estimated the kind of performance one can reach even 
> with pure procedural concepts. Btw., when i wrote this mail was when i 
> started thinking about "is it really true that the only way to get good 
> performance are 100% event-based servers and nonblocking designs?", and 
> started coding syslets and then threadlets.

:-)

Threads happen to be really fast, and easy to programm, but the maximum
performance still can not be achieved with them just because event
handling is faster - read one cacheline from the ring or queue, or
reschedule threads?

Anyway, what we are talking about, Ingo?
I understand your point, I also understand that you are not going to
change it (yes, that's it, but I need to confirm that I'm guilty too - I
doubtly will think that thousands of threads doing IO is a win), so we
can close the discussion at this point.

My main point in participating in it was kevent introduction - although
I created kevent AIO as a state machine, I never wanted to promote
kevent as AIO - kevent is event processing mechanism, one of its usage
models is AIO, another ones are signals, file events, timers, whatever...
You drawn a line - kevent is not needed - that is your point.
I wanted to hear definitive wordsa half a year ago, but community kept
silence. Eventually things are done.

Thanks.

> 	Ingo

-- 
	Evgeniy Polyakov
