Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXBZKvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXBZKvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030193AbXBZKvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:51:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188AbXBZKvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:51:24 -0500
Date: Mon, 26 Feb 2007 11:45:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
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
Message-ID: <20070226104507.GA18470@elte.hu>
References: <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225213420.GA10195@elte.hu>
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


update:

> i have tried the one Evgeniy provided in the URL:
> 
>   http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
> 
> and 'ab -k -c8000 -n80000' almost always aborts with:
> 
>   apr_socket_recv: Connection reset by peer (104)
> 
> in the few cases it finishes, i got the following epoll result, over 
> gigabit ethernet, on an UP Athlon64 box:
> 
>    eserver_epoll:     7800 reqs/sec

eserver_epoll.c had a number of bugs. The most serious one was the 
apparently buggy use of "EPOLLET" (edge-triggered events). Removing that 
and moving epoll to level-triggered (which is slower but does not result 
in missed events) gives:

   eserver_epoll:       9400 reqs/sec

> the same with the most naive implementation of the same, using 
> threadlets:
> 
>    eserver_threadlet: 5800 reqs/sec

   eserver_epoll_threadlet:   9400 reqs/sec

as expected, the level of extra blocking triggered by this is low - even 
if the full request function runs without nonblock assumptions.

	Ingo
