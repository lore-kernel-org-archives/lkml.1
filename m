Return-Path: <linux-kernel-owner+w=401wt.eu-S966180AbXEGSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966180AbXEGSS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966172AbXEGSSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:18:24 -0400
Received: from lotis.site5.com ([70.47.36.45]:40971 "EHLO lotis.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966122AbXEGSSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:18:23 -0400
Date: Mon, 7 May 2007 13:17:49 -0500 (CDT)
From: Chase Venters <chase.venters@clientec.com>
X-X-Sender: root@turbotaz.ourhouse
To: Davide Libenzi <davidel@xmailserver.org>
cc: Chase Venters <chase.venters@clientec.com>,
       Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <Pine.LNX.4.64.0705071009020.29173@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0705071259580.1227@turbotaz.ourhouse>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705071038560.1227@turbotaz.ourhouse>
 <Pine.LNX.4.64.0705071009020.29173@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Antivirus-Scanner: This message has been scanned by ClamAV.
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - lotis.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - clientec.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Davide Libenzi wrote:

> On Mon, 7 May 2007, Chase Venters wrote:
>
>> I'm working on event handling code for multiple projects right now, and my
>> method of calling epoll_wait() is to do so from several threads. I've glanced
>> at the epoll code but obviously haven't noticed the wake-all behavior... good
>> to know. I suppose I'm going to have to hack around this problem by wrapping
>> epoll_wait() calls in a mutex. That sucks - it means other threads won't be
>> able to 'get ahead' by preparing their wait before it is their turn to dequeue
>> events.
>>
>> In any case, I think having multiple threads blocking on epoll_wait() is a
>> much saner idea than one thread which then passes out events, so I must voice
>> my support for fixing this case. Why this is the exception instead of the norm
>> is a little baffling, but I've seen so many perverse things in multi-threaded
>> code...
>
> The problem that you can have with multiple threads calling epoll_wait()
> on an SMP system, is that if you sweep 100 events in one thread, and this
> thread goes alone in processing those, you may have other CPUs idle while
> the other thread is handling those. Either you call epoll_wait() from
> multiple thread by keeping the event buffer passed to epoll_wait() farily
> limited, on you use a single epoll_wait() fetcher with a queue(s) from
> which worker threads pull from.

Working with smaller quantums is indeed the right thing to do.

In any case, let's consider why you're getting 100 events from one 
epoll_wait():

1. You have a single thread doing the dequeue, and it is taking a long 
time (perhaps due to the time it is taking to requeue the work in other 
threads).

2. Your load is so high that you are taking lots and lots of events, in 
which case the other epoll_wait() threads are going to be woken up very 
soon with work anyway. In this scenario you will be "scheduling" work at 
"odd" times based on its arrival, but that's just another argument to use 
smaller quantums.

I'm referring specifically to edge-triggered behavior, btw. I find 
edge-triggered development far easier and saner in a multi-threaded 
environment, and doing level-triggered and multi-threaded at the same time 
certainly seems like the wrong thing to do.

In any case, I see little point in a thread whose job is simply to move 
something from queue A (epoll ready list) to queue B (thread work list). 
My latest code basically uses epoll_wait() as a load balancing mechanism 
to pass out work. The quantums are fairly small. There may be situations 
where you get a burst of traffic that one thread handles while others are 
momentarily idle, but handling that traffic is a very quick operation (and 
everything is non-blocking). You really only need the other threads to 
participate when the load starts to get to the point where the 
epoll_wait() calls will be constantly returning anyway.

> Davi's patch will be re-factored against 22-rc1 and submitted in any case
> though.

Great. I'm just glad I saw this mail -- I probably would have burned quite 
some time in the coming weeks trying to figure out why my epoll code 
wasn't running quite smoothly.

>
> - Davide
>

Thanks,
Chase
