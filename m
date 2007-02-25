Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXBYS0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXBYS0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXBYS0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:26:00 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53096 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbXBYS0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:26:00 -0500
Date: Sun, 25 Feb 2007 21:21:35 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225182135.GB29821@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225175437.GA9480@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 21:21:55 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 06:54:37PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > hm, what tree are you using as a base? The syslet patches are 
> > > against v2.6.20 at the moment. (the x86 PDA changes will probably 
> > > interfere with it on v2.6.21-rc1-ish kernels) Note that otherwise 
> > > the syslet/threadlet patches are for x86 only at the moment (as i 
> > > mentioned in the announcement), and the generic code itself contains 
> > > some occasional x86-ishms as well. (None of the concepts are 
> > > x86-specific though - multi-stack architectures should work just as 
> > > well as RISC-ish CPUs.)
> > 
> > It is rc1 - and crashes.
> 
> yeah. I'm not surprised. The PDA is not set up in create_async_thread() 
> for example.

Ok, I will roll back to vanilla 2.6.20 tomorrow.

> > > if you create a threadlet based test-webserver, could you please do 
> > > a comparable kevents implementation as well? I.e. same HTTP parser 
> > > (or non-parser, as usually the case is with prototypes ;). Best 
> > > would be something that one could trigger between threadlet and 
> > > kevent mode, using the same binary :-)
> > 
> > Ok, I will create such a monster tomorrow :)
> > 
> > I will use the same base for threadlet as for kevent/epoll - there is 
> > no parser, just sendfile() of the static file which contains http 
> > header and actual page.
> > 
> > threadlet1 {
> > 	accept() 
> > 	create threadlet2 {
> > 		send data
> > 	}
> > }
> > 
> > Is above scheme correct for threadlet scenario?
> 
> yep, this is a good first cut. Doing this after the listen() is useful:
> 
>         int one = 1;
> 
>         ret = setsockopt(listen_sock_fd, SOL_SOCKET, SO_REUSEADDR,
> 			 (char *)&one, sizeof(int));
> 
> and i'd suggest to do this after every accept()-ed socket:
> 
>         int flag = 1;
> 
>         setsockopt(sock_fd, IPPROTO_TCP, TCP_NODELAY,
>                             (char *) &flag, sizeof(int));
> 
> Do you have any link where i could check the type of HTTP parsing and 
> send transport you are (or will be) using? What type of http client are 
> you using to measure, with precisely what options?

For example this ones (essentially the same, except that epoll and
kevent are used):
http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c
http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c

> > But note, that on my athlon64 3500 test machine kevent is about 7900 
> > requests per second compared to 4000+ epoll, so expect a challenge.
> 
> single-core CPU i suspect?

Yep.

> > lighhtpd is about the same 4000 requests per second though, since it 
> > can not be easily optimized for kevents.
> 
> mean question: do you promise to post the results even if they are not 
> unfavorable to threadlets? ;-)

If they are too good, I will start searching for bugs and tune my code
first, but eventually of course yes. 
In my blog I will post them in 'real-time' even if kevent will
unbelieveably suck.

> if i want to test kevents on a v2.6.20 kernel base, do you have an URL 
> for me to try?

I have a git tree at (based on rc1 as requested by Andrew Morton):
http://tservice.net.ru/~s0mbre/archive/kevent/kevent.git/

Or patches at kevent homepage:
http://tservice.net.ru/~s0mbre/old/?section=projects&item=kevent

Direct link to the latest patchset:
http://tservice.net.ru/~s0mbre/archive/kevent/kevent-37/

(order is insignificant as far as I recall, except 'compile-fix',
whcih must be the latest).

> 	Ingo

-- 
	Evgeniy Polyakov
