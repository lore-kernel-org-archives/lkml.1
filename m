Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbXBVNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbXBVNf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXBVNf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:35:26 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42849 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXBVNfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:35:25 -0500
Date: Thu, 22 Feb 2007 16:32:03 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222133201.GB5208@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070222125931.GB25788@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 22 Feb 2007 16:33:42 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:59:31PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > It is not a TUX anymore - you had 1024 threads, and all of them will 
> > be consumed by tcp_sendmsg() for slow clients - rescheduling will kill 
> > a machine.
> 
> maybe it will, maybe it wont. Lets try? There is no true difference 
> between having a 'request structure' that represents the current state 
> of the HTTP connection plus a statemachine that moves that request 
> between various queues, and a 'kernel stack' that goes in and out of 
> runnable state and carries its processing state in its stack - other 
> than the amount of RAM they take. (the kernel stack is 4K at a minimum - 
> so with a million outstanding requests they would use up 4 GB of RAM. 
> With 20k outstanding requests it's 80 MB of RAM - that's acceptable.)

I tried already :) - I just made a allocations atomic in tcp_sendmsg() and
ended up with 1/4 of the sends blocking (I counted both allocation
failure and socket queue overflow). Those 20k blocked requests were
created in about 20 seconds, so roughly saying we have 1k of thread
creation/freeing per second - do we want this?

> > My tests show that with 4k connections per second (8k concurrency) 
> > more than 20k connections of 80k total block in tcp_sendmsg() over 
> > gigabit lan between quite fast machines.
> 
> yeah. Note that you can have a million sleeping threads if you want, the 
> scheduler wont care. What matters more is the amount of true concurrency 
> that is present at any given time. But yes, i agree that overscheduling 
> can be a problem.

Before I started M:N threading library implementation I checked some
threading perfomance of the current POSIX library - I created simple
pool of threads and 'sent' a message between them using futex wait/wake
(sema_post/wait) one-by-one, results are quite dissapointing - given
that number of sleeping threads were about hundreds, kernel rescheduling
is about 10 times slower than setjmp based (I think so) used in Erlang.

Above example is not 100% correct, I understand, but situation with
thread-like AIO is much worse - it is possible that several threads will
be ready simultaneous, so rescheduling between them will kill a
performance.

> btw., what is the measurement utility you are using with kevents ('ab' 
> perhaps, with a high -c concurrency count?), and which webserver are you 
> using? (light-httpd?)

Yes, it is ab and lighttpd, before it was httperf (unfair on high load
due to poll/select usage) and own web server (evserver_kevent.c).

> 	Ingo

-- 
	Evgeniy Polyakov
