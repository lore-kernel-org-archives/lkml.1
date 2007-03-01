Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXCAN2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXCAN2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbXCAN2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:28:11 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41601 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXCAN2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:28:09 -0500
Date: Thu, 1 Mar 2007 16:26:27 +0300
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
Message-ID: <20070301132626.GA30177@2ka.mipt.ru>
References: <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301123423.GA10738@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301123423.GA10738@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 16:26:42 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 01:34:23PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > Document Length:        3521 bytes
> 
> > Concurrency Level:      8000
> > Time taken for tests:   16.686737 seconds
> > Complete requests:      80000
> > Failed requests:        0
> > Write errors:           0
> > Total transferred:      309760000 bytes
> > HTML transferred:       281680000 bytes
> > Requests per second:    4794.23 [#/sec] (mean)
> 
> > Concurrency Level:      8000
> > Time taken for tests:   12.366775 seconds
> > Complete requests:      80000
> > Failed requests:        0
> > Write errors:           0
> > Total transferred:      317047104 bytes
> > HTML transferred:       288306522 bytes
> > Requests per second:    6468.95 [#/sec] (mean)
> 
> i'm wondering - how can the 'Total transferred' and 'HTML transferred' 
> numbers be different?
>
> Since document length is 3521, and the number of requests is 80000, the 
> correct 'HTML transferred' is 281680000 - which is the epoll result. The 
> kevent result shows more bytes transferred, which suggests that the 
> kevent loop is probably incorrect somewhere.
> 
> this might be some benign thing, but the /first/ thing you /have to/ do 
> before claiming that 'kevent is 25% faster than epoll' is to make sure 
> the results are totally reliable.

Kevent sent additional 525 pages ((311792800-309760000)/3872) - that is why 
number for kevent is higher - it uses edge-triggered handler (which you 
asked to remove from epoll), which can produce false-positives, for 
absolute result in that case ret_data must be checked where poll flags 
were stored (before). 'ab' does not count additional data as new requests 
and does not count them in 'requests per second'.
Even if it could do so, additional 500 requests can not provide 35%
higher rate.

For example, lighttpd results are the same for kevent and epoll and
'Total transferred' and 'HTML transferred' numbers change between runs both 
for epoll and kevent.

> 	Ingo

-- 
	Evgeniy Polyakov
