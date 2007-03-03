Return-Path: <linux-kernel-owner+w=401wt.eu-S1030374AbXCCSrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374AbXCCSrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 13:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030375AbXCCSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 13:47:09 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:32974 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030374AbXCCSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 13:47:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Mar 2007 10:46:59 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
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
In-Reply-To: <20070303100625.GA22557@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
 <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
 <20070303100625.GA22557@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, Evgeniy Polyakov wrote:

> > You've to excuse me if my memory is bad, but IIRC the whole discussion 
> > and loong benchmark feast born with you throwing a benchmark at Ingo 
> > (with kevent showing a 1.9x performance boost WRT epoll), not with you 
> > making any other point.
> 
> So, how does it sound?
> "Threadlets are bad for IO because kevent is 2 times faster than epoll?"
> 
> I said threadlets are bad for IO (and we agreed that both approaches
> shouldbe usedfor the maximum performance) because of rescheduling overhead -
> tasks are quite heavy structuresa to move around - even pt_regs copy
> takes more than event structure, but not because there is something in other
> galaxy which might work faster than another something in another galaxy.
> That was stupid even to think about that.

Evgeny, other folks on this thread read what you said, so let's not drag 
this over.



> > And if you really feel raw about the single O(nready) loop that epoll
> > currently does, a new epoll_wait2 (or whatever) API could be used to
> > deliver the event directly into a userspace buffer [1], directly from the
> > poll callback, w/out extra delivery loops (IRQ/event->epoll_callback->event_buffer).
>
> > [1] From the epoll callback, we cannot sleep, so it's gonna be either an 
> >     mlocked userspace buffer, or some kernel pages mapped to userspace.
> 
> Callbacks never sleep - they add event into list just like current
> implementation (maybe some lock must be changed from mutex to spinlock,
> I do not rememeber), main problem is binding to the file structure,
> which is heavy.

I was referring to dropping an event directly to a userspace buffer, from 
the poll callback. If pages are not there, you might sleep, and you can't 
since the wakeup function holds a spinlock on the waitqueue head while 
looping through the waiters to issue the wakeup. Also, you don't know from 
where the poll wakeup is called.
File binding heavy? The first, and by *far* biggest, source of events 
inside an event collector, of someone that cares about scalability, are 
sockets. And those are already files. Second would be AIO, and those (if 
performance figures agrees) can be hosted inside syslets/threadlets.
Then you fall into the no-care category, where the extra 100 bytes do not 
make a case against the ability of using it with an existing POSIX 
infrastructure (poll/select).
BTW, Linus made a signalfd sketch code time ago, to deliver signals to an 
fd. Code remained there and nobody cared. Question: Was it because
1) it had file bindings or 2) because nobody really cared to deliver 
signals to an event collector?
And *if* later requirements come, you don't need to change the API by 
adding an XXEVENT_SIGNAL_ADD or XXEVENT_TIMER_ADD, or creating a new 
XXEVENT-only submission structure. You create an API that automatically 
makes that new abstraction work with POSIX poll/select, and you get epoll 
support for free. Without even changing a bit in the epoll API.



- Davide


