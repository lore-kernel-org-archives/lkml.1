Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXCCUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXCCUhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbXCCUhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:37:25 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59491 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbXCCUhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:37:24 -0500
Date: Sat, 3 Mar 2007 23:31:42 +0300
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
Message-ID: <20070303203140.GA756@2ka.mipt.ru>
References: <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com> <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com> <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 03 Mar 2007 23:32:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 10:46:59AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Sat, 3 Mar 2007, Evgeniy Polyakov wrote:
> 
> > > You've to excuse me if my memory is bad, but IIRC the whole discussion 
> > > and loong benchmark feast born with you throwing a benchmark at Ingo 
> > > (with kevent showing a 1.9x performance boost WRT epoll), not with you 
> > > making any other point.
> > 
> > So, how does it sound?
> > "Threadlets are bad for IO because kevent is 2 times faster than epoll?"
> > 
> > I said threadlets are bad for IO (and we agreed that both approaches
> > shouldbe usedfor the maximum performance) because of rescheduling overhead -
> > tasks are quite heavy structuresa to move around - even pt_regs copy
> > takes more than event structure, but not because there is something in other
> > galaxy which might work faster than another something in another galaxy.
> > That was stupid even to think about that.
> 
> Evgeny, other folks on this thread read what you said, so let's not drag 
> this over.
 
Sure, I was wrong to start this again, but try to get my position - I
really tired from trying to prove that I'm not a camel just because we
had some misunderstanding at the start.

I do think that threadlets are relly cool solution and are indeed very
good approach for majority of the parallel processing, but my point is
still that it is not a perfect solution for all tasks.

Just to draw a line: kevent example is extrapolation of what can be
achieved with event-driven model, but that does not mean that it must be
_only_ used for AIO model - threadlets _and_ event driven model (yes, I
accepted Ingo's point about its declining) is the best solution.
 
> > > And if you really feel raw about the single O(nready) loop that epoll
> > > currently does, a new epoll_wait2 (or whatever) API could be used to
> > > deliver the event directly into a userspace buffer [1], directly from the
> > > poll callback, w/out extra delivery loops (IRQ/event->epoll_callback->event_buffer).
> >
> > > [1] From the epoll callback, we cannot sleep, so it's gonna be either an 
> > >     mlocked userspace buffer, or some kernel pages mapped to userspace.
> > 
> > Callbacks never sleep - they add event into list just like current
> > implementation (maybe some lock must be changed from mutex to spinlock,
> > I do not rememeber), main problem is binding to the file structure,
> > which is heavy.
> 
> I was referring to dropping an event directly to a userspace buffer, from 
> the poll callback. If pages are not there, you might sleep, and you can't 
> since the wakeup function holds a spinlock on the waitqueue head while 
> looping through the waiters to issue the wakeup. Also, you don't know from 
> where the poll wakeup is called.

Ugh, no, that is very limited solution - memory must be either pinned
(which leads to dos and limited ring buffer), or callback must sleep.
Actually in any way there _must_ exist a queue - if ring buffer is full
event is not allowed to be dropped - it must be stored in some other
place, for example in queue from where entries will be read (copied)
which ring buffer will have entries (that is how it is implemented in
kevent at least).

> File binding heavy? The first, and by *far* biggest, source of events 
> inside an event collector, of someone that cares about scalability, are 
> sockets. And those are already files. Second would be AIO, and those (if 
> performance figures agrees) can be hosted inside syslets/threadlets.
> Then you fall into the no-care category, where the extra 100 bytes do not 
> make a case against the ability of using it with an existing POSIX 
> infrastructure (poll/select).

Well, sockets are the files indeed, and sockets already are perfectly
handled by epoll - but there are other users of petential interace - and
it must be designed to scale in _any_ situation very well.
Even if we right now do not have problems with some types of events, we
must scale with any new one.

> BTW, Linus made a signalfd sketch code time ago, to deliver signals to an 
> fd. Code remained there and nobody cared. Question: Was it because
> 1) it had file bindings or 2) because nobody really cared to deliver 
> signals to an event collector?
> And *if* later requirements come, you don't need to change the API by 
> adding an XXEVENT_SIGNAL_ADD or XXEVENT_TIMER_ADD, or creating a new 
> XXEVENT-only submission structure. You create an API that automatically 
> makes that new abstraction work with POSIX poll/select, and you get epoll 
> support for free. Without even changing a bit in the epoll API.

Well, we get epoll support for free, but we need to create tons of other
interfaces and infrastructure for kernel users, and we need to change 
userspace anyway.
But epoll support requires to have quite heavy bindings to file
structure, so why don't we want to design new interface (since we need
to change userspace anyway) so that it could allow to scale and be very
memory optimized from the beginning?

> - Davide
> 

-- 
	Evgeniy Polyakov
