Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXBZUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXBZUmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXBZUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:42:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXBZUmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:42:18 -0500
Date: Mon, 26 Feb 2007 21:35:43 +0100
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
Message-ID: <20070226203543.GB23357@elte.hu>
References: <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226165513.GB22454@2ka.mipt.ru>
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

> If kernelspace rescheduling is that fast, then please explain me why 
> userspace one always beats kernel/userspace?

because 'user space scheduling' makes no sense? I explained my thinking 
about that in a past mail:

-------------------------->
One often repeated (because pretty much only) performance advantage of 
'light threads' is context-switch performance between user-space 
threads. But reality is, nobody /cares/ about being able to 
context-switch between "light user-space threads"! Why? Because there 
are only two reasons why such a high-performance context-switch would 
occur:

 1) there's contention between those two tasks. Wonderful: now two
    artificial threads are running on the /same/ CPU and they are even
    contending each other. Why not run a single context on a single CPU
    instead and only get contended if /another/ CPU runs a conflicting
    context?? While this makes for nice "pthread locking benchmarks",
    it is not really useful for anything real.

 2) there has been an IO event. The thing is, for IO events we enter the
    kernel no matter what - and we'll do so for the next 10 years at
    minimum. We want to abstract away the hardware, we want to do
    reliable resource accounting, we want to share hardware resources,
    we want to rate-limit, etc., etc. While in /theory/ you could handle
    IO purely from user-space, in practice you dont want to do that. And
    if we accept the premise that we'll enter the kernel anyway, there's
    zero performance difference between scheduling right there in the
    kernel, or returning back to user-space to schedule there. (in fact
    i submit that the former is faster). Or if we accept the theoretical
    possibility of 'perfect IO hardware' that implements /all/ the
    features that the kernel wants (in a secure and generic way, and
    mind you, such IO hardware does not exist yet), then /at most/ the
    performance advantage of user-space doing the scheduling is the
    overhead of a null syscall entry. Which is a whopping 100 nsecs on
    modern CPUs! That's roughly the latency of a /single/ DRAM access!
....
<-----------

(see http://lwn.net/Articles/219958/)

btw., the words that follow that section are quite interesting in 
retrospect:

| Furthermore, 'light thread' concepts can no way approach the 
| performance of #2 state-machines: if you /know/ what the structure of 
| your context is, and you can program it in a specialized state-machine 
| way, there's just so many shortcuts possible that it's not even funny.

[ oops! ;-) ]

i severely under-estimated the kind of performance one can reach even 
with pure procedural concepts. Btw., when i wrote this mail was when i 
started thinking about "is it really true that the only way to get good 
performance are 100% event-based servers and nonblocking designs?", and 
started coding syslets and then threadlets.

	Ingo
