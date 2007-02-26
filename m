Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbXBZJ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbXBZJ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXBZJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:28:11 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59911 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbXBZJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:28:09 -0500
Date: Mon, 26 Feb 2007 12:25:45 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
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
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226092545.GA4110@2ka.mipt.ru>
References: <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226081655.GA25280@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 12:26:19 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:16:56AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > Also, the evtest_kevent_remove call is superfluous with epoll.
> 
> it's only used in the error path AFAICS.
> 
> but you are right about evserver_epoll/kevent.c incorrectly assuming 
> that things wont block in evtest_callback_client(), which, after 
> receiving the "there's stuff on the input socket" event does:
> 
> 	recvmsg(sock),
> 	fd = open();
> 	sendfile(sock, fd)
> 	close(fd);
> 
> while evserver_threadlet.c, even this naive implementation, does not 
> assume that we wont block in that function.
> 
> > In any case, comparing epoll/kevent with 100K active sessions, against 
> > threadlets, is not exactly a fair/appropriate test for it.
> 
> fully agreed.

Hi.

I will highlight several items in this mail:
1. evserver_epoll.c is broken in that regard, that it does not close a
socket - I tried to make it possible to work with keepalive, but failed.
So close of the socket is a must, like in evserver_kevent.c
2. keepalive is not supported - it is a hack server at the end.
3. this test does not assume that above snippet blocks or does not - it
is _typical_ case of the web server with one working thread (per cpu) -
every op can block, so there is no problem - threadlet will reschedule,
event based will block (bad for them).
4. benchmark does not cover all possible cases - initial goal of that
servers was to show how fast/slow _event_ generation/processing is in
epoll/kevent case, but not to create real-life web server.
lighttpd for example can not be used as a good bench too, since its arch
does not support some kevent extensions (which do not exist in epoll),
and, looking to the number of comments in kevent threads, I'm not motivated 
to change it at all.

So, drawing a line, evserver_* is a simple event driven server, it does
have disadvantages, but the same approach only favours threadlet model.
Having millions or thousands of connections works against threadlets,
but we compare ultimate cases, it is a one of the possible tests.

So...
I'm cooking up a git tree with kevents and threadlets, which I will test
in via epia (1ghz, 256 mb of ram, 100mbit lan) and Intel(R) Core(TM)2 CPU
6600  @ 2.40GHz (2gb of ram, 1gbit lan) later today with
kevent/epoll/threadlet if wine will not end suddenly.
I will use Ingo's evserver_threadlet server as plong as evserver_epoll
(with fixed closing) and evserver_kevent.c.
Eventually I can move all of them into one file.

Client is 'ab' on my desktop core duo 3.7 ghz. Machines are connected
over gigabit dlink dgs-1216t switch (which freezes on slightly broken 
dhcp and tftp packets btw).

Stay tuned.

P.S. Linus, if you do not mind, I will postpone scholastic masturbation 
about event vs process context in IO. One sentence only - page fault and
filename lookup both wait - they wait for new page is ready or inode is read
from the disk, eventually they wake up, thing which wakes them up _is_
an event.

> 	Ingo

-- 
	Evgeniy Polyakov
