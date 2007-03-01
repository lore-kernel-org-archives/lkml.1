Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXCAMMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXCAMMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXCAMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:12:48 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36893 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbXCAMMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:12:47 -0500
Date: Thu, 1 Mar 2007 15:10:22 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070301121020.GC20773@2ka.mipt.ru>
References: <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu> <20070301114734.GA3508@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301114734.GA3508@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 15:10:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:47:35PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I also changed client socket to nonblocking mode with the same result 
> > > in epoll server. If you will find it broken, please send me corrected 
> > > to test too.
> > 
> > this line in evserver_kevent.c looks a bit fishy:
> 
> this one in evserver_kevent.c looks problematic too:
> 
>         shutdown(s, SHUT_RDWR);
>         close(s);
> 
> as evserver_epoll.c only does:
> 
>         close(s);
> 
> again, there might be TCP control flow differences due to this. [ Or the 
> removal of this shutdown() call might be a small speedup for the kevent 
> case ;) ]

:)

> Also, the order of fd and socket close() is different in the two cases. 
> It shouldnt make any difference - but that too just makes the results 
> harder to trust. Would it be so hard to introduce a single 
> handle_web_request() function that is exactly the same in the two tests? 
> All the queueing details (which are of course different in the epoll and 
> the kevent case) should be in the client function, which calls 
> handle_web_request().

I've removed shutdown - things are the same.

Sometimes kevent performance drops to lower numbers and its graph of
times needed to handle events has high platoes (with and without
shutdown - it was always), like this:

Percentage of the requests served within a certain time (ms)
50%    128
66%    486
75%    505
80%    507
90%    732
95%   3087	// something is wrong at this point
98%   9058
99%   9072
100%  15562 (longest request)

it is possible that threre are some other bugs in the server though,
which prevent sockets from being quicly closed and thus its processing
time increases - I do not know for sure the root of that event.

I separated epoll and kevent servers, since originally kevent server 
included additional kevent features, but then new ones were added 
and I moved slowly to the similar to epoll case.

Current version of the server was a pre-test one for lighttpd patches,
so essentially it should be like epoll except minor details.

> 	Ingo

-- 
	Evgeniy Polyakov
