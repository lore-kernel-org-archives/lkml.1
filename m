Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXBWUoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXBWUoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbXBWUoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:44:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1256 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205AbXBWUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:44:13 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Feb 2007 12:43:54 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070223180139.GA5588@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702231206290.31281@alien.or.mcafeemobile.com>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru>
 <Pine.LNX.4.64.0702221139320.1356@alien.or.mcafeemobile.com>
 <20070223121521.GA5392@2ka.mipt.ru> <Pine.LNX.4.64.0702230935440.30937@alien.or.mcafeemobile.com>
 <20070223180139.GA5588@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Evgeniy Polyakov wrote:

> I was not clear - I meant why do we need to do that when we can run the
> same code in userspace? And better if we can have non-blocking dataflows
> and number of threads equal to number of processors...

I've a userspace library that does exactly that (GUASI - GPL code avail if 
you want, but no man page written yet). It uses a pool of threads and 
queue requests. I've a bench that crawl through a directory a read files. 
The sync against async performance sucks. You can't do the cachehit 
optimization in userspace. With network stuff could prolly do better 
(since network is more heavily towards async), but still. 




> I started a week of writing without russian-english dictionary, so
> expect some troubles in communications with me :)
> 
> I said that about kernel design - when we have thousand(s) of threads,
> which do the work - if number of context switches is small (i.e. when
> operations mostly do not block), then it is ok (although 'ps' output 
> with threads can scary a grandma).
> It is also ok to say - 'hey, Linux has so easy AIO model, so that
> everyone should switch and start using it and do not care about problems 
> associated with multi-threaded programming with high concurrency', 
> but, in my opinion, both that cases can not cover all (and most of) 
> the usage cases.
> 
> To eat my hat (or force others to do the same) I'm preparing a tree for 
> threadlet test - I plan to write a trivial web server
> (accept/recv/send/sendfile in one threadlet function) and give it a try
> soon.

Funny, I lazily started doing the same thing last weekend (than I had to 
stop, since real job kicked in ;). I wanted to compare a fully MT trivial 
HTTP server:

http://www.xmailserver.org/thrhttp.c

with one that is event-driven (epoll) and coroutine based. This one will 
only be compared for memory-content delivery, since it has no async vfs 
capabilities. They both support the special "/mem-XXXX" url, that allows 
an HTTP loader to request a given content size.
I also have a epoll+coroutine HTTP loader (that works around httperf 
limitations).
Then, I wanted to compare the above, with one that is epoll+GUASI+coroutine 
based (basically a userpace-only thingy).
I've the code for all the above.
Finally, with one that is epoll+syslet+coroutine based (no code for this 
yet - but it should be a easy port from the GUASI one).
Keep in mind though, that a threadlet solution doing accept/recv/send/sendfile
is becoming blazingly similar to a full MT solution.
I can only immagine the thunders and flames that Larry would throw at us 
for using all those threads :D




- Davide


