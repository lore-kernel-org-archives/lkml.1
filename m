Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXBZVWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXBZVWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030523AbXBZVWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:22:39 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1396 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXBZVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:22:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 13:22:34 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
In-Reply-To: <20070226104507.GA18470@elte.hu>
Message-ID: <Pine.LNX.4.64.0702261205440.1881@alien.or.mcafeemobile.com>
References: <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu>
 <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu>
 <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu>
 <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu>
 <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com>
 <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Ingo Molnar wrote:

> 
> update:
> 
> > i have tried the one Evgeniy provided in the URL:
> > 
> >   http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
> > 
> > and 'ab -k -c8000 -n80000' almost always aborts with:
> > 
> >   apr_socket_recv: Connection reset by peer (104)
> > 
> > in the few cases it finishes, i got the following epoll result, over 
> > gigabit ethernet, on an UP Athlon64 box:
> > 
> >    eserver_epoll:     7800 reqs/sec
> 
> eserver_epoll.c had a number of bugs. The most serious one was the 
> apparently buggy use of "EPOLLET" (edge-triggered events). Removing that 
> and moving epoll to level-triggered (which is slower but does not result 
> in missed events) gives:
> 
>    eserver_epoll:       9400 reqs/sec
> 
> > the same with the most naive implementation of the same, using 
> > threadlets:
> > 
> >    eserver_threadlet: 5800 reqs/sec
> 
>    eserver_epoll_threadlet:   9400 reqs/sec
> 
> as expected, the level of extra blocking triggered by this is low - even 
> if the full request function runs without nonblock assumptions.

That looks pretty good. I started (spare time allowing) laying down the 
based for a more realistic test as far webserver-like benchmarking.
I want to compare three solutions, that uses the same internal code (as 
far as request parsing and content delivery).

1) A fully thread classical web "server". This does the trivial 
   accept+pthread_create and in there does open+fstat+sendhdrs+sendfile. 
   This is already done:

   http://www.xmailserver.org/thrhttp.c

   Do a `gcc -o thrhttp thrhttp.c -lpthread` and you're done.

2) A coronet (coroutine+epoll library) handling for network 
   events/dispatch, plus GUASI (Generic Userspace Asyncronous Syscall
   Interface) to handle generic IO.

   libpcl:   http://www.xmailserver.org/libpcl.html
   coronet:  http://www.xmailserver.org/coronet-lib.html
   GUASI:    http://www.xmailserver.org/guasi-lib.html

   cghttpd:  http://www.xmailserver.org/cghttpd-home.html

   All these are configure+make+make_install installable.
   The cghttpd server has the same parsing/content-delivery features of 
   thrhttp, but it uses coroutine+epoll to handle network events, and 
   GUASI (an old pthread-based userspace implementation of async execution)
   to give open/fstat/sendfile an async behaviour. It implements the 
   epoll_wait() (conet_events_wait() acutally, but that maps directly to 
   epoll_wait()) hosted inside an async GUASI request, and the GUASI 
   dispatch loop handle the case with:

   if (cookie == conet_events_wait_cookie)
       handle_network_events();

3) Finally, a very similar to cghttpd implementation, but this time using 
   the *syslets* to handle async requests. That should be a prety easy 
   change to cghttpd, by the mean of replacing the CGHTTPD_SYSCALL() macro 
   with proper syslet code. The big advantage of the syslets here, is that 
   they do have the cachehit optimization, while GUASI always have to 
   trigger a queueing.
   Of course, since the only machine I have with enough RAM to keep many 
   thousands of session active is a dual Opteron, I'd need to have an 
   x86-64 version of the patch. That shouldn't be a big problem though.


This hopefully may prove two points. First, a fully threaded solution does 
not scale well when dealing with thousands and thousands of sessions. 
Second, the cachehit syslet trick is The Man in the syslet code, and kicks 
userspace solution #2 ass.
In the meantime, I think Jens tests are more meaningfull, as far of usage 
field goes, than any network based test.




- Davide


