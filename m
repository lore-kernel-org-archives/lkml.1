Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbXB0MlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbXB0MlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXB0MlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:41:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048AbXB0MlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:41:07 -0500
Date: Tue, 27 Feb 2007 13:34:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
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
Message-ID: <20070227123421.GA21616@elte.hu>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227115221.GJ8154@thunk.org>
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


* Theodore Tso <tytso@mit.edu> wrote:

> I think what you are not hearing, and what everyone else is saying 
> (INCLUDING Linus), is that for most programmers, state machines are 
> much, much harder to program, understand, and debug compared to 
> multi-threaded code. [...]

btw., another crutial thing that i think Evgeniy is missing is that 
threadlets /enable/ event loops to be used in practice! Right now the 
epoll/kevent programming model requires a total 100% avoidance of all 
context-switching in the 'main' event handler context while handling a 
request. If just 1% of all requests happen to block it might cause a 
/complete/ breakdown of an event loop's performance - it can easily 
cause a 10x drop in performance or worse!

So context-switching has to be avoided in 100% of the code that runs 
while handling requests, file descriptors have to be set to nonblocking 
(causing extra system calls), and all the syscalls that might return 
incomplete with either -EINVAL or with a short read/write have to be 
converted into a state machine. (or in the alternative, user-space 
threading has to be used, which opens up another hornet's nest)

/That/ is the main inhibiting factor of the measured use of event loops 
within Linux! It has zero integration capabilities with 'usual' coding 
techniques - driving the costs of its application up in the sky, and 
pushing event based servers into niches.

With threadlets the picture changes dramatically: all we have to 
concentrate on to get the performance of "100% event based servers" is 
to handle 'most' rescheduling events in the event loop. A 10-20% context 
switching ratio does not hurt at all. (it causes ~1% of throughput 
loss.)

Furthermore, even if a particular configuration or module of the server 
(say Apache) happens to trigger a high rate of scheduling, the 
performance breakdown model of threadlets is /vastly/ superior to event 
based servers. The measurements so far have shown that the absolute 
worst-case threading server performance is at around 60% of that of 
non-context-switching servers - and even that level is reached 
gradually, leaving time for action for the server owner. While with 
fully event based servers there are mostly only two modes of 
performance: 100% performance and near-0% performance: total breakdown.

	Ingo
