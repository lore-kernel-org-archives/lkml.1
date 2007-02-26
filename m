Return-Path: <linux-kernel-owner+w=401wt.eu-S1030372AbXBZRpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030372AbXBZRpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXBZRpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:45:34 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42613 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030372AbXBZRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:45:33 -0500
Date: Mon, 26 Feb 2007 20:37:01 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20070226173701.GD22454@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226131133.GA11777@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226131133.GA11777@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 20:38:51 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 02:11:33PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > My tests show that with 4k connections per second (8k concurrency) 
> > > more than 20k connections of 80k total block in tcp_sendmsg() over 
> > > gigabit lan between quite fast machines.
> > 
> > Why do people *keep* taking this up as an issue?
> > 
> > Use select/poll/epoll/kevent/whatever for event mechanisms. STOP 
> > CLAIMING that you'd use threadlets/syslets/aio for that. It's been 
> > pointed out over and over and over again, and yet you continue to make 
> > the same mistake, Evgeniy.
> > 
> > So please read that sentence ten times, and then don't continue to 
> > make that same mistake. PLEASE.
> > 
> > Event mechanisms are *superior* for events. But they *suck* for things 
> > that aren't events, but are actual code execution with random places 
> > that can block. THE TWO THINGS ARE TOTALLY AND UTTERLY INDEPENDENT!
> 
> Note that even for something tasks are supposed to suck at, and even if 
> used in extremely stupid ways, they perform reasonably well in practice 
> ;-)
> 
> And i fully agree: specialization based on knowledge about frequency of 
> blocking will always be useful - if not /forced/ on the workflow 
> architecture and if not overdone. On the other hand, fully event-driven 
> servers based on 'nonblocking' calls, which Evgeniy is advocating and 
> which the kevent model is forcing upon userspace, is pure madness.
> 
> We very much can and should use things like epoll for events that we 
> expect to happen asynchronously 100% of the time - it just makes no 
> sense for those events to take up 4-5K of RAM apiece, when they could 
> also be only using up the 32 bytes that say a pending timer takes. I've 
> posted the code for that, how to do an 'outer' epoll loop around an 
> internal threadlep iterator. But those will always be very narrow event 
> sources, and likely wont (and shouldnt) cover 'request-internal' 
> processing.
> 
> but otherwise, there is no real difference between a task that is 
> scheduled and a request that is queued, 'other' than the size of the 
> request (the task takes 4-5K of RAM), and the register context (64-128 
> bytes on most CPUs, the loading of which is optimized to death).
> 
> Which difference can still be significant for certain workloads, so we 
> certainly dont want to prohibit specialized event interfaces and force 
> generic threads on everything. But for anything that isnt a raw and 
> natural external event source (time, network, disk, user-generated) 
> there shouldnt be much of an event queueing abstraction i believe (other 
> than what we get 'for free' within epoll, from having poll()-able files) 
> - and even for those event sources threadlets offer a pretty good run 
> for the money.

I tend to agree.
Yes, some loads require event driven model, other can be done using
threads. The only reason kevent was created is to allow to process any
type of events in exaclty the same way in the same processing loop,
it was optimized to have event register structure less than a cache
line.

What I can not agree with, is that IO is a thread based stuff.

> one can always find the point and workload where say 40,000 threads 
> start trashing the L2 cache, but where 40,000 queued special requests 
> are still fully in cache, and produce spectacular numbers.
> 
> 	Ingo

-- 
	Evgeniy Polyakov
