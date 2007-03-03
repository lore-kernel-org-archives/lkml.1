Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXCCKJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXCCKJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXCCKJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:09:23 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41393 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXCCKJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:09:22 -0500
Date: Sat, 3 Mar 2007 13:06:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070303100625.GA22557@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com> <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 03 Mar 2007 13:07:29 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 09:13:40AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Fri, 2 Mar 2007, Evgeniy Polyakov wrote:
> 
> > On Thu, Mar 01, 2007 at 11:31:14AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > > On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:
> > > 
> > > > Ingo, do you really think I will send mails with faked benchmarks? :))
> > > 
> > > I don't think he ever implied that. He was only suggesting that when you 
> > > post benchmarks, and even more when you make claims based on benchmarks, 
> > > you need to be extra carefull about what you measure. Otherwise the 
> > > external view that you give to others does not look good.
> > > Kevent can be really faster than epoll, but if you post broken benchmarks 
> > > (that can be, unrealiable HTTP loaders, broken server implemenations, 
> > > etc..) and make claims based on that, the only effect that you have is to 
> > > lose your point.
> >  
> > So, I only talked that kevent is superior compared to epoll because (and
> > it is _main_ issue) of its ability to handle essentially any kind of
> > events with very small overhead (the same as epoll has in struct file -
> > list and spinlock) and without significant price of struct file binding
> > to event.
> 
> You've to excuse me if my memory is bad, but IIRC the whole discussion 
> and loong benchmark feast born with you throwing a benchmark at Ingo 
> (with kevent showing a 1.9x performance boost WRT epoll), not with you 
> making any other point.

So, how does it sound?
"Threadlets are bad for IO because kevent is 2 times faster than epoll?"

I said threadlets are bad for IO (and we agreed that both approaches
shouldbe usedfor the maximum performance) because of rescheduling overhead -
tasks are quite heavy structuresa to move around - even pt_regs copy
takes more than event structure, but not because there is something in other
galaxy which might work faster than another something in another galaxy.
That was stupid even to think about that.

> As far as epoll not being able to handle other events. Said who? Of 
> course, with zero modifications, you can handle zero additional events. 
> With modifications, you can handle other events. But lets talk about those 
> other events. The *only* kind of event that ppl (and being the epoll 
> maintainer I tend to receive those requests) missed in epoll, was AIO 
> events, That's the *only* thing that was missed by real life application 
> developers. And if something like threadlets/syslets will prove effective, 
> the gap is closed WRT that requirement.
> Epoll handle already the whole class of pollable devices inside the 
> kernel, and if you exclude block AIO, that's a pretty wide class already. 
> The *existing* f_op->poll subsystem can be used to deliver events at the 
> poll-head wakeup time (by using the "key" member of the poll callback), so 
> that you don't even need the extra f_op->poll call to fetch events.
> And if you really feel raw about the single O(nready) loop that epoll 
> currently does, a new epoll_wait2 (or whatever) API could be used to 
> deliver the event directly into a userspace buffer [1], directly from the 
> poll callback, w/out extra delivery loops (IRQ/event->epoll_callback->event_buffer).

Signals, futexes, timers and userspace events I was requested to add into 
kevent, so far only futexes are missed because I was asked to freeze
development so other hackers could check the project.

> 
> [1] From the epoll callback, we cannot sleep, so it's gonna be either an 
>     mlocked userspace buffer, or some kernel pages mapped to userspace.

Callbacks never sleep - they add event into list just like current
implementation (maybe some lock must be changed from mutex to spinlock,
I do not rememeber), main problem is binding to the file structure,
which is heavy.

> - Davide
> 

-- 
	Evgeniy Polyakov
