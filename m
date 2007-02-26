Return-Path: <linux-kernel-owner+w=401wt.eu-S965243AbXBZM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243AbXBZM5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965256AbXBZM5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:57:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965243AbXBZM5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:57:16 -0500
Date: Mon, 26 Feb 2007 13:50:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070226125054.GA6997@elte.hu>
References: <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226122521.GA19039@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > yet another performance update - with the fixed 'heaps of stupid 
> > threads' evserver_threadlet.c code attached below i got:
> > 
> > >    evserver_epoll:             9400 reqs/sec
> > >    evserver_epoll_threadlet:   9400 reqs/sec
> > 
> >      evserver_threadlet:         9000 reqs/sec
> > 
> > so the overhead, instead of the 10x slowdown Evgeniy 
> > predicted/feared, is 4% for this particular, very event-centric 
> > workload.
> > 
> > why? because Evgeniy still overlooks what i've mentioned so many 
> > times: that there is lots of inherent 'caching' possible even in 
> > this particular '8000 clients' workload, which even the most stupid 
> > threadlet queueing model is able to take advantage of. The maximum 
> > level of parallelism that i've measured during this test was 161 
> > threads.
> 
> :)
> 
> I feared _ONLY_ situation when thousands of thereads are eating my 
> brain - so case when 161 threads are running simultanesoulsy is not 
> that bad compared to what micro-design can do (of its best/worst) at 
> all!

even with ten thousand threads it is still pretty fast. Certainly not 
'10 times slower' as you claimed. And it takes only a single, trivial 
outer event loop to lift it up to the performance levels of a pure event 
based server.

conclusion: currently i dont see a compelling need for the kevents 
subsystem. epoll is a pretty nice API and it covers most of the event 
sources and nicely builds upon our existing poll() infrastructure.

furthermore, i very much contest your claim that a high-performance, 
highly scalable webserver needs a kevent+nonblock design. Even if i 
ignore all the obvious usability and maintainance-cost advantages of 
threadlets.

> So, caching is good - threadlets do not spawn a new thread, kevent 
> returns immediately, but in case of things are not that shine - 
> threadlets spawnd a new thread, while kevent process next request or 
> waits for all completed.

no. Please read the evserver_threadlet.c code. There's no kevent in 
there. There's no epoll() in there. All that you can see there is the 
natural behavior of pure threadlets. And it's not a workload /I/ picked 
for threadlets - it is a workload, filesize, parallelism level and 
request handling function /you/ picked for "event-servers".

	Ingo
