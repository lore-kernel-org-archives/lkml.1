Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXCALzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXCALzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965016AbXCALzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:55:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40875 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964976AbXCALzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:55:08 -0500
Date: Thu, 1 Mar 2007 12:47:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301114734.GA3508@elte.hu>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301114137.GB897@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I also changed client socket to nonblocking mode with the same result 
> > in epoll server. If you will find it broken, please send me corrected 
> > to test too.
> 
> this line in evserver_kevent.c looks a bit fishy:

this one in evserver_kevent.c looks problematic too:

        shutdown(s, SHUT_RDWR);
        close(s);

as evserver_epoll.c only does:

        close(s);

again, there might be TCP control flow differences due to this. [ Or the 
removal of this shutdown() call might be a small speedup for the kevent 
case ;) ]

Also, the order of fd and socket close() is different in the two cases. 
It shouldnt make any difference - but that too just makes the results 
harder to trust. Would it be so hard to introduce a single 
handle_web_request() function that is exactly the same in the two tests? 
All the queueing details (which are of course different in the epoll and 
the kevent case) should be in the client function, which calls 
handle_web_request().

	Ingo
