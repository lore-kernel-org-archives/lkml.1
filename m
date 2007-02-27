Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXB0MNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXB0MNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbXB0MNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:13:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56839 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbXB0MNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:13:38 -0500
Date: Tue, 27 Feb 2007 15:11:16 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070227121116.GA31597@2ka.mipt.ru>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070227115221.GJ8154@thunk.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 15:12:00 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 06:52:22AM -0500, Theodore Tso (tytso@mit.edu) wrote:
> On Tue, Feb 27, 2007 at 01:28:32PM +0300, Evgeniy Polyakov wrote:
> > Obviously there are bugs, it is simply how things work.
> > And debugging state machine code has exactly the same complexity as
> > debugging multi-threading code - if not less...
> 
> Evgeniy,

Hi Ted.

> I think what you are not hearing, and what everyone else is saying
> (INCLUDING Linus), is that for most programmers, state machines are
> much, much harder to program, understand, and debug compared to
> multi-threaded code.  You may disagree (were you a MacOS 9 programmer
> in another life?), and it may not even be true for you if you happen
> to be one of those folks more at home with Scheme continuations, for
> example.  But it is true that for most kernel programmers, threaded
> programming is much easier to understand, and we need to engineer the
> kernel for what will be maintainable for the majority of the kernel
> development community.

I understand that - and I totally agree.
But when more complex, more bug-prone code results in higher performance
- that must be used. We have linked lists and binary trees - the latter
are quite complex structures, but they allow to have higher performance
in searching operatins, so we use them.

The same applies to state machines - yes, in some cases it is hard to
program, but when things are already implemented and are wrapped into
nice (no posix) aio_read(), there is absolutely no usage complexity.

Even if it is up to programmer to programm state machine based on
generated events, that higher-layer state machines are not complex.

Let's get simple case of (aio_)read() from file descriptor - if page is in the
cache, no readpage() method will be called, so we do not need to create
some kind of events - just copy data, if there is no page or page is not
uptodate, we allocate a bio and do not wait until buffers are read - we
return to userspace and start another reading, when bio is completed and
its end_io callback is called, we mark pages as uptodate, copy data to userspace,
and mark event bound to above (aio_)read() as completed.
(that is how kevent aio works, btw).
Userspace programmer just calls 
cookie = aio_read();
aio_wait(cookie);
or something like that.

It is simple, it is straightforward, especially if data read must then
be used somewhere else - in that case processing thread will need to operate
with main one, which is simple in event model, since there is a place,
where events of _all_ types are gathered.

> Regards,
> 
> 						- Ted

-- 
	Evgeniy Polyakov
