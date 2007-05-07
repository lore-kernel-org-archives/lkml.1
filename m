Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbXEGPrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbXEGPrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbXEGPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:46:59 -0400
Received: from lotis.site5.com ([70.47.36.45]:59139 "EHLO lotis.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934363AbXEGPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:46:58 -0400
Date: Mon, 7 May 2007 10:46:35 -0500 (CDT)
From: Chase Venters <chase.venters@clientec.com>
X-X-Sender: root@turbotaz.ourhouse
To: Davide Libenzi <davidel@xmailserver.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0705071038560.1227@turbotaz.ourhouse>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
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

On Sat, 5 May 2007, Davide Libenzi wrote:

> On Fri, 4 May 2007, Davi Arnaut wrote:
>
>> Hi,
>>
>> If multiple threads are parked on epoll_wait (on a single epoll fd) and
>> events become available, epoll performs a wake up of all threads of the
>> poll wait list, causing a thundering herd of processes trying to grab
>> the eventpoll lock.
>>
>> This patch addresses this by using exclusive waiters (wake one). Once
>> the exclusive thread finishes transferring it's events, a new thread
>> is woken if there are more events available.
>>
>> Makes sense?
>
> Theorically, make sense. I said theorically because all the use
> epoll_wait MT use cases I've heard of, use a single thread that does the
> epoll_wait, and then dispatch to worker threads. So thundering herd is not
> in the picture. OTOH, it does not hurt either.
> But, that code is completely changed with the new single-pass epoll delivery
> code that is in -mm. So, I'd either wait for that code to go in, or I
> (or you, if you like) can make a patch against -mm.
>

*raises hand*

I'm working on event handling code for multiple projects right now, and my 
method of calling epoll_wait() is to do so from several threads. I've 
glanced at the epoll code but obviously haven't noticed the wake-all 
behavior... good to know. I suppose I'm going to have to hack around this 
problem by wrapping epoll_wait() calls in a mutex. That sucks - it means 
other threads won't be able to 'get ahead' by preparing their wait before 
it is their turn to dequeue events.

In any case, I think having multiple threads blocking on epoll_wait() is a 
much saner idea than one thread which then passes out events, so I must 
voice my support for fixing this case. Why this is the exception instead 
of the norm is a little baffling, but I've seen so many perverse things in 
multi-threaded code...

>
> - Davide
>

Thanks,
Chase
