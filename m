Return-Path: <linux-kernel-owner+w=401wt.eu-S1945928AbXBVHpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928AbXBVHpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXBVHpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:45:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945928AbXBVHpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:45:43 -0500
Date: Thu, 22 Feb 2007 08:40:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222074044.GA4158@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DCD9E5.2010106@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> Ingo Molnar wrote:
> > in terms of AIO, the best queueing model is i think what the kernel uses 
> > internally: freely ordered, with barrier support.
> 
> Speaking of AIO, how do you imagine lio_listio is implemented?  If 
> there is no asynchronous syscall it would mean creating a threadlet 
> for each request but this means either waiting or creating 
> several/many threads.

my current thinking is that special-purpose (non-programmable, static) 
APIs like aio_*() and lio_*(), where every last cycle of performance 
matters, should be implemented using syslets - even if it is quite 
tricky to write syslets (which they no doubt are - just compare the size 
of syslet-test.c to threadlet-test.c). So i'd move syslets into the same 
category as raw syscalls: pieces of the raw infrastructure between the 
kernel and glibc, not an exposed API to apps. [and even if we keep them 
in that category they still need quite a bit of API work, to clean up 
the 32/64-bit issues, etc.]

The size of the async thread pool can be kept in check either from 
user-space (by starting to queue up requests after a certain point of 
saturation without submitting them) or from kernel-space which involves 
waiting (the latter was present in v2 but i temporarily removed it from 
v3). "You have to wait" is the eventual final answer in every 
well-behaved queueing system anyway.

How things work out with a large number of outstanding threads in real 
apps is still an open question (until someone tries it) but i'm 
cautiously optimistic: in my own (FIO based) measurements syslets beat 
the native KAIO interfaces both in the cached and in the non-cached [== 
many threads] case. I did not expect the latter at all: the non-cached 
syslet codepath is not optimized at all yet, so i expected it to have 
(much) higher CPU overhead than KAIO.

This means that KAIO is in worse shape than i thought - there's just way 
too much context KAIO has to build up to submit parallel IO contexts. 
Many years of optimizations went into KAIO already, so it's probably at 
its outer edge of performance capabilities. Furthermore, what KAIO has 
to compete against in the syslet case are the synchronous syscalls 
turned async, and more than a decade of optimizations went into all the 
synchronous syscalls. Plus the 'threading overhead of syslets' really 
boils down to 'scheduling overhead' in the end - and we can do over a 
million context-switches a second, per CPU. What killed user-space 
thread-based AIO performance many moons ago wasnt really the threading 
concept itself or scheduling overhead, it was the (then) fragile 
threading implementation of Linux, combined with the resulting 
signal-based AIO code. Catching and handling a single signal is more 
expensive than a context-switch - and signals have legacies attached to 
them that make them hard to scale within the kernel. Plus with syslets 
the 'threading overhead' is optional, it only happens when it has to.

Plus there's the fundamental killer that KAIO is a /lot/ harder to 
implement (and to maintain) on the kernel side: it has to be implemented 
for every IO discipline, and even for the IO disciplines it supports at 
the moment, it is not truly asynchronous for things like metadata 
blocking or VFS blocking. To handle things like metadata blocking it has 
to resort to non-statemachine techniques like retries - which are bad 
for performance.

Syslets/threadlets on the other hand, once the core is implemented, have 
near zero ongoing maintainance cost (compared to KAIO pushed into every 
IO subsystem) and cover all IO disciplines and API variants immediately, 
and they are as perfectly asynchronous as it gets.

So all in one, i used to think that AIO state-machines have a long-term 
place within the kernel, but with syslets i think i've proven myself 
embarrasingly wrong =B-)

	Ingo
