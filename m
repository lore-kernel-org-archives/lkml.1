Return-Path: <linux-kernel-owner+w=401wt.eu-S1030220AbXBZNUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220AbXBZNUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXBZNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:20:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030220AbXBZNUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:20:03 -0500
Date: Mon, 26 Feb 2007 14:11:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226131133.GA11777@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > My tests show that with 4k connections per second (8k concurrency) 
> > more than 20k connections of 80k total block in tcp_sendmsg() over 
> > gigabit lan between quite fast machines.
> 
> Why do people *keep* taking this up as an issue?
> 
> Use select/poll/epoll/kevent/whatever for event mechanisms. STOP 
> CLAIMING that you'd use threadlets/syslets/aio for that. It's been 
> pointed out over and over and over again, and yet you continue to make 
> the same mistake, Evgeniy.
> 
> So please read that sentence ten times, and then don't continue to 
> make that same mistake. PLEASE.
> 
> Event mechanisms are *superior* for events. But they *suck* for things 
> that aren't events, but are actual code execution with random places 
> that can block. THE TWO THINGS ARE TOTALLY AND UTTERLY INDEPENDENT!

Note that even for something tasks are supposed to suck at, and even if 
used in extremely stupid ways, they perform reasonably well in practice 
;-)

And i fully agree: specialization based on knowledge about frequency of 
blocking will always be useful - if not /forced/ on the workflow 
architecture and if not overdone. On the other hand, fully event-driven 
servers based on 'nonblocking' calls, which Evgeniy is advocating and 
which the kevent model is forcing upon userspace, is pure madness.

We very much can and should use things like epoll for events that we 
expect to happen asynchronously 100% of the time - it just makes no 
sense for those events to take up 4-5K of RAM apiece, when they could 
also be only using up the 32 bytes that say a pending timer takes. I've 
posted the code for that, how to do an 'outer' epoll loop around an 
internal threadlep iterator. But those will always be very narrow event 
sources, and likely wont (and shouldnt) cover 'request-internal' 
processing.

but otherwise, there is no real difference between a task that is 
scheduled and a request that is queued, 'other' than the size of the 
request (the task takes 4-5K of RAM), and the register context (64-128 
bytes on most CPUs, the loading of which is optimized to death).

Which difference can still be significant for certain workloads, so we 
certainly dont want to prohibit specialized event interfaces and force 
generic threads on everything. But for anything that isnt a raw and 
natural external event source (time, network, disk, user-generated) 
there shouldnt be much of an event queueing abstraction i believe (other 
than what we get 'for free' within epoll, from having poll()-able files) 
- and even for those event sources threadlets offer a pretty good run 
for the money.

one can always find the point and workload where say 40,000 threads 
start trashing the L2 cache, but where 40,000 queued special requests 
are still fully in cache, and produce spectacular numbers.

	Ingo
