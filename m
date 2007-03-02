Return-Path: <linux-kernel-owner+w=401wt.eu-S2992586AbXCBRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992586AbXCBRNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCBRNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:13:52 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3036 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992586AbXCBRNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:13:51 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 09:13:40 -0800 (PST)
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
In-Reply-To: <20070302081047.GA27122@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
 <20070302081047.GA27122@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Evgeniy Polyakov wrote:

> On Thu, Mar 01, 2007 at 11:31:14AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:
> > 
> > > Ingo, do you really think I will send mails with faked benchmarks? :))
> > 
> > I don't think he ever implied that. He was only suggesting that when you 
> > post benchmarks, and even more when you make claims based on benchmarks, 
> > you need to be extra carefull about what you measure. Otherwise the 
> > external view that you give to others does not look good.
> > Kevent can be really faster than epoll, but if you post broken benchmarks 
> > (that can be, unrealiable HTTP loaders, broken server implemenations, 
> > etc..) and make claims based on that, the only effect that you have is to 
> > lose your point.
>  
> So, I only talked that kevent is superior compared to epoll because (and
> it is _main_ issue) of its ability to handle essentially any kind of
> events with very small overhead (the same as epoll has in struct file -
> list and spinlock) and without significant price of struct file binding
> to event.

You've to excuse me if my memory is bad, but IIRC the whole discussion 
and loong benchmark feast born with you throwing a benchmark at Ingo 
(with kevent showing a 1.9x performance boost WRT epoll), not with you 
making any other point.
As far as epoll not being able to handle other events. Said who? Of 
course, with zero modifications, you can handle zero additional events. 
With modifications, you can handle other events. But lets talk about those 
other events. The *only* kind of event that ppl (and being the epoll 
maintainer I tend to receive those requests) missed in epoll, was AIO 
events, That's the *only* thing that was missed by real life application 
developers. And if something like threadlets/syslets will prove effective, 
the gap is closed WRT that requirement.
Epoll handle already the whole class of pollable devices inside the 
kernel, and if you exclude block AIO, that's a pretty wide class already. 
The *existing* f_op->poll subsystem can be used to deliver events at the 
poll-head wakeup time (by using the "key" member of the poll callback), so 
that you don't even need the extra f_op->poll call to fetch events.
And if you really feel raw about the single O(nready) loop that epoll 
currently does, a new epoll_wait2 (or whatever) API could be used to 
deliver the event directly into a userspace buffer [1], directly from the 
poll callback, w/out extra delivery loops (IRQ/event->epoll_callback->event_buffer).


[1] From the epoll callback, we cannot sleep, so it's gonna be either an 
    mlocked userspace buffer, or some kernel pages mapped to userspace.


- Davide


