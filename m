Return-Path: <linux-kernel-owner+w=401wt.eu-S1030626AbXBZUHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626AbXBZUHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXBZUHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:07:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030626AbXBZUHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:07:30 -0500
Date: Mon, 26 Feb 2007 20:54:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
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
Message-ID: <20070226195416.GA11188@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Reading from the disk is _exactly_ the same - the same waiting for 
> > buffer_heads/pages, and (since it is bigger) it can be easily 
> > transferred to event driven model. Ugh, wait, it not only _can_ be 
> > transferred, it is already done in kevent AIO, and it shows faster 
> > speeds (though I only tested sending them over the net).
> 
> It would be absolutely horrible to program for. Try anything more 
> complex than read/write (which is the simplest case, but even that is 
> nasty).

note that even for something as 'simple and straightforward' as TCP 
sockets, the 25-50 lines of evserver code i worked on today had 3 
separate bugs, is known to be fundamentally incorrect and one of the 
bugs (the lost event problem) showed up as a subtle epoll performance 
problem and it took me more than an hour to track down. And that matches 
my Tux experience as well: event based models are horribly hard to debug 
BECAUSE there is /no procedural state associated with requests/. Hence 
there is no real /proof of progress/. Not much to use for debugging - 
except huge logs of execution, which, if one is unlucky (which i often 
was with Tux) would just make the problem go away.

Furthermore, with a 'retry' model, who guarantees that the retry wont be 
an infinite retry where none of the retries ever progresses the state of 
the system enough to return the data we are interested in? The moment we 
have to /retry/, depending on the 'depth' of how deep the retry kicked 
in, we've got to reach that 'depth' of code again and execute it.

plus, 'there is not much state' is not even completely true to begin 
with, even in the most simple, TCP socket case! There /is/ quite a bit 
of state constructed on the kernel stack: user parameters have been 
evaluated/converted, the socket has been looked up, its state has been 
validated, etc. With a 'retry' model - but even with a pure 'event 
queueing' model we redo all those things /both/ at request submission 
and at event generation time, again and again - while with a synchronous 
syscall you do it just once and upon event completion a piece of that 
data is already on the kernel stack. I'd much rather spend time and 
effort on simplifying the scheduler and reducing the cache footprint of 
the kernel thread context switch path, etc., to make it more useful even 
in more extreme, highly prallel '100% context-switching' case, because i 
have first-hand experience about how fragile and inflexible event based 
servers are. I do think that event interfaces for raw, external physical 
events make sense in some circumstances, but for any more complex 
'derived' event type it's less and less clear whether we want a direct 
interface to it. For something like the VFS it's outright horrible to 
even think about.

	Ingo
