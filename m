Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXBZOWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXBZOWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030276AbXBZOWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:22:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030275AbXBZOWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:22:16 -0500
Date: Mon, 26 Feb 2007 15:15:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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
Message-ID: <20070226141518.GA24683@elte.hu>
References: <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226140500.GA31629@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > your whole reasoning seems to be faith-based:
> > 
> > [...] Anyway, kevents are very small, threads are very big, [...]
> > 
> > How about following the scientific method instead?
> 
> That are only rethorical words as you have understood I bet, I meant 
> that the whole process of getting readiness notification from kevent 
> is way tooo much faster than resheduling of the new process/thread to 
> handle that IO.
> 
> The whole process of switching from one process to another can be as 
> fast as bloody hell, but all other details just kill the thing.

for our primary abstractions there /IS NO OTHER DETAIL/ but wakeup and 
context-switching! The "event notification" of a sys_read() /IS/ the 
wakeup and context-switching that we do - or the epoll/kevent enqueueing 
as an alternative.

yes, the two are still different in a number of ways, and yes, it's 
still stupid to do a pool of thousands of threads and thus we can always 
optimize queuing, RAM and cache footprint via specialization, but your 
whole foundation seems to be constructed around the false notion that 
queueing and scheduling a task by the scheduler is somehow magically 
expensive and different from queueing and scheduling other type of 
requests. Please reconsider that foundation and open up a bit more to a 
slightly different world view: scheduling is really just another, more 
generic (and thus certainly more expensive) type of 'request queueing', 
and user-space, most of the time, is much better off if it handles its 
'requests' and 'events' via tasks. (Especially if many of those 'events' 
turn out to be non-events at all, so to speak.)

	Ingo
