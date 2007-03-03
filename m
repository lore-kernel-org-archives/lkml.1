Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXCCV5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXCCV5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030484AbXCCV5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:57:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33026 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbXCCV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:57:09 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Mar 2007 13:57:06 -0800 (PST)
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
In-Reply-To: <20070303203140.GA756@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
References: <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru>
 <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
 <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
 <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
 <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
 <20070303203140.GA756@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, Evgeniy Polyakov wrote:

> > I was referring to dropping an event directly to a userspace buffer, from 
> > the poll callback. If pages are not there, you might sleep, and you can't 
> > since the wakeup function holds a spinlock on the waitqueue head while 
> > looping through the waiters to issue the wakeup. Also, you don't know from 
> > where the poll wakeup is called.
> 
> Ugh, no, that is very limited solution - memory must be either pinned
> (which leads to dos and limited ring buffer), or callback must sleep.
> Actually in any way there _must_ exist a queue - if ring buffer is full
> event is not allowed to be dropped - it must be stored in some other
> place, for example in queue from where entries will be read (copied)
> which ring buffer will have entries (that is how it is implemented in
> kevent at least).

I was not advocating for that, if you read carefully. The fact that epoll 
does not do that, should be a clear hint. The old /dev/epoll IIRC was only 
10% faster than the current epoll under an *heavy* event frequency 
micro-bench like pipetest (and that version of epoll did not have the 
single pass over the ready set optimization). And /dev/epoll was 
delivering events *directly* on userspace visible (mmaped) memory in a 
zero-copy fashion.




> > BTW, Linus made a signalfd sketch code time ago, to deliver signals to an 
> > fd. Code remained there and nobody cared. Question: Was it because
> > 1) it had file bindings or 2) because nobody really cared to deliver 
> > signals to an event collector?
> > And *if* later requirements come, you don't need to change the API by 
> > adding an XXEVENT_SIGNAL_ADD or XXEVENT_TIMER_ADD, or creating a new 
> > XXEVENT-only submission structure. You create an API that automatically 
> > makes that new abstraction work with POSIX poll/select, and you get epoll 
> > support for free. Without even changing a bit in the epoll API.
> 
> Well, we get epoll support for free, but we need to create tons of other
> interfaces and infrastructure for kernel users, and we need to change 
> userspace anyway.

Those *other* (tons?!?) interfaces can be created *when* the need comes 
(see Linus signalfd [1] example to show how urgent that was). *When* 
the need comes, they will work with existing POSIX interfaces, without 
requiring your own just-another event interface. Those other interfaces 
could also be more easily adopted by other Unix cousins, because of 
the fact that they rely on existing POSIX interfaces. One of the reason 
about the Unix file abstraction interfaces, is that you do *not* have to 
plan and bloat interfaces before. As long as your new abstraction behave 
in a file-fashion, it can be automatically used with existing interfaces. 
And you create them *when* the need comes.




[1] That was like 100 lines of code or so. See here:

    http://tinyurl.com/3yuna5



- Davide


