Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXCAPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXCAPjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXCAPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:39:20 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49517 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbXCAPjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:39:19 -0500
Date: Thu, 1 Mar 2007 18:36:55 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301153655.GB8217@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301150942.GA26025@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 18:37:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:09:42PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > > I can tell you that the problem (at least on my machine) comes from :
> > > > 
> > > > gettimeofday(&tm, NULL);
> > > > 
> > > > in evserver_epoll.c
> > > 
> > > yeah, that's another difference - especially if it's something like 
> > > an Athlon64 and gettimeofday falls back to pm-timer, that could 
> > > explain the performance difference. That's why i repeatedly asked 
> > > Evgeniy to use the /very same/ client function for both the epoll 
> > > and the kevent test and redo the measurements. The numbers are still 
> > > highly suspect - and we are already down from the prior claim of 
> > > kevent being almost twice as fast to a 25% difference.
> > 
> > There is no gettimeofday() in the running code anymore, and it was 
> > placed not in common server processing code btw.
> > 
> > Ingo, do you really think I will send mails with faked benchmarks? :))
> 
> no, i'd not be in this discussion anymore if i thought that. But i do 
> think that your benchmark results are extremely sloppy, that make your 
> conclusions on them essentially useless.
>
> you were hurling quite colorful and strong assertions into this 
> discussion, backed up by these numbers, so you should expect at least 
> some minimal amount of scrutiny of those numbers.

This discussion was about event driven vs. thread driven IO models, and
threadlet only behaves like event driven because in my tests there was
exactly one threadlet rescheduling per severa thousands of clients.

Kevent is just a logical interpolation of performance of event driven
model.

My assumptions were based not on kevent performance, but on the fact,
that event delivery is much faster and simpler than thread handling.

Ugh, I'm starting that stupid talk again - let's just jump to the end -
I agree that in real-life high-performance systems both models must be
used.

Peace? :)

> > > [...] The numbers are still highly suspect - and we are already down 
> > > from the prior claim of kevent being almost twice as fast to a 25% 
> > > difference.
> >
> > Btw, there were never almost twice perfromance increase - epoll in my 
> > tests always showed 4-5 thousands requests per second, kevent - up to 
> > 7 thausands.
> 
> i'm referring to your claim in this mail of yours from 4 days ago for 
> example:
> 
>   http://lkml.org/lkml/2007/2/25/116
> 
>  "But note, that on my athlon64 3500 test machine kevent is about 7900
>   requests per second compared to 4000+ epoll, so expect a challenge."
> 
> no matter how i look at it, but 7900 is 1.9 times 4000 - which is 
> "almost twice".

After your changes epoll increased to 5k.
I can easily reproduce 6300/4300 split, but can not get more than 7k for
kevent (with oprofile/idle=poll at least).

I've completed 800k run:
kevent 4800
epoll 4450

with tons ofoverflows in 'ab':

Write errors:           0
Total transferred:      -1197367296 bytes
HTML transferred:       -1478167296 bytes
Requests per second:    4440.67 [#/sec] (mean)
Time per request:       1801.529 [ms] (mean)
Time per request:       0.225 [ms] (mean, across all concurrent
requests)
Transfer rate:          -6490.62 [Kbytes/sec] received

Any other bench?

> 	Ingo

-- 
	Evgeniy Polyakov
