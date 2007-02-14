Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbXBNKku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbXBNKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932198AbXBNKkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXBNKkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:40:04 -0500
Date: Wed, 14 Feb 2007 11:37:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070214103731.GB6801@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru> <20070213221810.GF22104@elte.hu> <20070214085939.GA4665@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214085939.GA4665@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Let me clarify what I meant. There is only limited number of threads, 
> which are supposed to execute blocking context, so when all they are 
> used, main one will block too - I asked about possibility to reuse the 
> same thread to execute queue of requests attached to it, each request 
> can block, but if blocking issue is removed, it would be possible to 
> return.

ah, ok, i understand your point. This is not quite possible: the 
cachemisses are driven from schedule(), which can be arbitraily deep 
inside arbitrary system calls. It can be in a mutex_lock() deep inside a 
driver. It can be due to a alloc_pages() call done by a kmalloc() call 
done from within ext3, which was called from the loopback block driver, 
which was called from XFS, which was called from a VFS syscall.

Even if it were possible to backtrack i'm quite sure we dont want to do 
this, for three main reasons:

Firstly, backtracking and retrying always has a cost. We construct state 
on the way in - and we destruct on the way out. The kernel stack we have 
built up has a (nontrivial) construction cost and thus a construction 
value - we should preserve that if possible.

Secondly, and this is equally important: i wanted the number of async 
kernel threads to be the natural throttling mechanism. If user-space 
wants to use less threads and overcommit the request queue then it can 
be done in user-space: by over-queueing requests into a separate list, 
and taking from that list upon completion and submitting it. User-space 
has precise knowledge of overqueueing scenarios: if the event ring is 
full then all async kernel threads are busy.

but note that there's a deeper reason as well for not wanting 
over-queueing: the main cost of a 'pending request' is the kernel stack 
of the blocked thread itself! So do we want to allow 'requests' to stay 
'pending' even if there are "no more threads available"? Nope: because 
letting them 'pend' would essentially (and implicitly) mean an increase 
of the thread pool.

In other words: with the syslet subsystem, a kernel thread /is/ the 
asynchronous request itself. So 'have more requests pending' means 'have 
more kernel threads'. And 'no kernel thread available' must thus mean 
'no queueing of this request'.

Thirdly, there is a performance advantage of this queueing property as 
well: by letting a cachemiss thread only do a single syslet all work is 
concentrated back to the 'head' task, and all queueing decisions are 
immediately known by user-space and can be acted upon.

So the work-queueing setup is not symmetric at all, there's a 
fundamental bias and tendency back towards the head task - this helps 
caching too. That's what Tux did too - it always tried to queue back to 
the 'head task' as soon as it could. Spreading out work dynamically and 
transparently is necessary and nice, but it's useless if the system has 
no automatic tendency to move back into single-threaded (fully cached) 
state if the workload becomes less parallel. Without this fundamental 
(and transparent) 'shrink parallelism' property syslets would only 
degrade into yet another threading construct.

	Ingo
