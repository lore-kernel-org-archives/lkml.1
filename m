Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXB0K5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXB0K5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbXB0K5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:57:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXB0K5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:57:18 -0500
Date: Tue, 27 Feb 2007 11:49:57 +0100
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
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227104957.GA20927@elte.hu>
References: <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu> <20070226103319.GA24284@2ka.mipt.ru> <20070226103517.GA17195@elte.hu> <20070226104748.GC24284@2ka.mipt.ru> <20070226125123.GA31357@elte.hu> <20070226164618.GA22454@2ka.mipt.ru> <20070227062419.GB1259@elte.hu> <20070227104123.GE23170@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227104123.GE23170@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > does that work for you?
> 
> Yes, -fomit-frame-point make the deal.
> 
> In average, threadlet runs as fast as epoll.

yeah.

> Just because there are _no_ rescheduling in that case.

in my test it was 'little', not 'no'. But yes, that's exactly my point: 
we can remove the nonblock hackeries from event loops and just 
concentrate on making it schedule in less than 10-20% of the cases. Even 
a relatively high 10-20% rescheduling rate is hardly measurable with 
threadlets, while it gives a 10%-20% regression (and possibly bad 
latencies) for the pure epoll/kevent server.

and such a mixed technique is simply not possible with ordinary 
user-space threads, because there it's an all-or-nothing affair: either 
you go fully to threads (at which point we are again back to a fully 
threaded design, now also saddled with event loop overhead), or you try 
to do user-space threads, which Just Make Little Sense (tm).

so threadlets remove the biggest headache from event loops: they dont 
have to be '100% nonblocking' anymore. No O_NONBLOCK overhead, no 
complex state machines - just handle the most common event type via an 
outer event loop and keep the other 99% of server complexity in plain 
procedural programming. 1% of state-machine code is perfectly 
acceptable.

	Ingo
