Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXB0Knw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXB0Knw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXB0Knw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:43:52 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48440 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbXB0Knv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:43:51 -0500
Date: Tue, 27 Feb 2007 13:41:24 +0300
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
Message-ID: <20070227104123.GE23170@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu> <20070226103319.GA24284@2ka.mipt.ru> <20070226103517.GA17195@elte.hu> <20070226104748.GC24284@2ka.mipt.ru> <20070226125123.GA31357@elte.hu> <20070226164618.GA22454@2ka.mipt.ru> <20070227062419.GB1259@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070227062419.GB1259@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 13:42:29 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 07:24:19AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > On Mon, Feb 26, 2007 at 01:51:23PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > > 
> > > > Even having main dispatcher as epoll/kevent loop, the _whole_ 
> > > > threadlet model is absolutely micro-thread in nature and not state 
> > > > machine/event.
> > > 
> > > Evgeniy, i'm not sure how many different ways to tell this to you, but 
> > > you are not listening, you are not learning and you are still not 
> > > getting it at all.
> > > 
> > > The scheduler /IS/ a generic work/event queue. And it's pretty damn 
> > > fast. No amount of badmouthing will change that basic fact. Not exactly 
> > > as fast as a special-purpose queueing system (for all the reasons i 
> > > outlined to you, and which you ignored), but it gets pretty damn close 
> > > even for the web workload /you/ identified, and offers a user-space 
> > > programming model that is about 1000 times more useful than 
> > > state-machines.
> > 
> > Meanwhile on practiceal side:
> > via epia kevent/epoll/threadlet:
> > 
> > client: ab -c500 -n5000 $url
> > 
> > kevent:		849.72
> > epoll:		538.16
> > threadlet:
> >  gcc ./evserver_epoll_threadlet.c -o ./evserver_epoll_threadlet
> >  In file included from ./evserver_epoll_threadlet.c:30:
> >  ./threadlet.h: In function ‘threadlet_exec’:
> >  ./threadlet.h:46: error: can't find a register in class ‘GENERAL_REGS’
> >  while reloading ‘asm’
> > 
> > That particular asm optimization fails to compile.
> 
> it's not really an asm optimization but an API glue. I'm using:
> 
>  gcc -O2 -g -Wall -o evserver_epoll_threadlet evserver_epoll_threadlet.c -fomit-frame-pointer
> 
> does that work for you?

Yes, -fomit-frame-point make the deal.

In average, threadlet runs as fast as epoll. 
Just because there are _no_ rescheduling in that case.

I added a printk into __async_schedule() and started
ab -c7000 -n20000 http://192.168.4.80/ 
against slow via epia, and got only one of them.
Client is latest
../async-test-v4/evserver_epoll_threadlet


Btw, I need to admit, that I have totally broken kevent tree there - it
does not work on that machine on higher loads, so I'm investigating that
problem now.

> 	Ingo

-- 
	Evgeniy Polyakov
