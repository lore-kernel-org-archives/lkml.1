Return-Path: <linux-kernel-owner+w=401wt.eu-S1030330AbXBZQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030330AbXBZQ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030327AbXBZQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:58:15 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51169 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030332AbXBZQ6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:58:14 -0500
Date: Mon, 26 Feb 2007 19:55:13 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226165513.GB22454@2ka.mipt.ru>
References: <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226141518.GA24683@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 19:56:54 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 03:15:18PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > > your whole reasoning seems to be faith-based:
> > > 
> > > [...] Anyway, kevents are very small, threads are very big, [...]
> > > 
> > > How about following the scientific method instead?
> > 
> > That are only rethorical words as you have understood I bet, I meant 
> > that the whole process of getting readiness notification from kevent 
> > is way tooo much faster than resheduling of the new process/thread to 
> > handle that IO.
> > 
> > The whole process of switching from one process to another can be as 
> > fast as bloody hell, but all other details just kill the thing.
> 
> for our primary abstractions there /IS NO OTHER DETAIL/ but wakeup and 
> context-switching! The "event notification" of a sys_read() /IS/ the 
> wakeup and context-switching that we do - or the epoll/kevent enqueueing 
> as an alternative.
> 
> yes, the two are still different in a number of ways, and yes, it's 
> still stupid to do a pool of thousands of threads and thus we can always 
> optimize queuing, RAM and cache footprint via specialization, but your 
> whole foundation seems to be constructed around the false notion that 
> queueing and scheduling a task by the scheduler is somehow magically 
> expensive and different from queueing and scheduling other type of 
> requests. Please reconsider that foundation and open up a bit more to a 
> slightly different world view: scheduling is really just another, more 
> generic (and thus certainly more expensive) type of 'request queueing', 
> and user-space, most of the time, is much better off if it handles its 
> 'requests' and 'events' via tasks. (Especially if many of those 'events' 
> turn out to be non-events at all, so to speak.)

If kernelspace rescheduling is that fast, then please explain me why
userspace one always beats kernel/userspace?

And you showed that threadlets without polling accept still does not
scale good - if it is the same fast queueing of events, then why doesn't
it work?

Actually it does not matter, if that narrow place exist (like
kernel/user transformation, or register copy or something else), it can
be eliminated in different model - kevent is that model - it does not
require a lot of things to be changed to get notification and start
working, so it scales better.

It is very similar to epoll, but there are at least two significant
moments:
1. it can work with _any_ type of events with minimal overhead (can not
be even remotely compared with 'file' binding which is required to be
pollable).
2. its notifications do not go through the second loop, i.e. it is O(1),
not O(ready_num), and notifications happens directly from internals of
the appropriate subsystem, which does not require special wakeup
(although it can be done too).

> 	Ingo

-- 
	Evgeniy Polyakov
