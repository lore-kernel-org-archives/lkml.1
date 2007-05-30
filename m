Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXE3HZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXE3HZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXE3HZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:25:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2778 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbXE3HZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:25:38 -0400
Date: Wed, 30 May 2007 09:25:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tejun Heo <htejun@gmail.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
Message-ID: <20070530072528.GP943@1wt.eu>
References: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com> <465C809C.60507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C809C.60507@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 04:35:56AM +0900, Tejun Heo wrote:
> David Schwartz wrote:
> >> I want to know in detail about , what the events (epoll or /dev/poll or
> >> select ) achieve in contrast to  thread per client.
> >>
> >> i can have a thread per client and use send and recv system call directly
> >> right? Why do i go for these event mechanisms?
> >>
> >> Please help me to understand this.
> > 
> > Aside from the obvious, consider a server that needs to do a little bit of
> > work on each of 1,000 clients on a single CPU system. With a
> > thread-per-client approach, 1,000 context switches will be needed. With an
> > epoll thread pool approach, none are needed and five or six are typical.
> > 
> > Both get you the major advantages of threading. You can take full advantage
> > of multiple CPUs. You can write code that blocks occasionally without
> > bringing the whole server down. A page fault doesn't stall your whole
> > server.
> 
> It all depends on the workload but thread switching overhead can be
> negligible - after all all it does is entering kernel, schedule, swap
> processor context and return.  Maybe using separate stack has minor
> impact on cache hit ratio.  You need benchmark numbers to claim one way
> or the other.

In my experience, it's not much the context switch by itself which causes
performance degradation, but the fact that with threads, you have to put
mutexes everywhere. And frankly, walking a list with locks everywhere
is quite slower than doing it in one run at a rate of 3 or 4 cycles per
entry. Also, local storage in function returns is not possible anymore,
and some functions even need to malloc() instead of returning statically
allocated data. I believe this is the reason for openssl being twice as
slow when compiled thread-safe than in native mode.

So in fact, converting a threaded program to a pure async model should
not improve it much because of the initial architectural design. But a
program written from scratch to be purely async should perform better
simply because it has less operations to perform. And there's no magics
here : less cycles spend synchronizing and locking = more cycles available
for the real job.

> In my experience with web caches, epoll or similar for idle clients and
> thread per active client scaled and performed pretty well - it needed
> more memory but the performance wasn't worse than asynchronous design
> and doing complex server in async model is a lot of pain.

It's true that an async model is a lot of pain. But it's always where I
got the best performance. For instance, with epoll(), I can achieve
20000 HTTP reqs/s with 40000 concurrent sessions. The best performance
I have observed from threaded competitors was an order of magnitude below
on either value (sometimes both).

However, I agree that few uses really require to spend time writing and
debugging async programs.

Regards,
Willy

