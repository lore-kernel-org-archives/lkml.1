Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbXBYTLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbXBYTLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXBYTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:11:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbXBYTLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:11:11 -0500
Date: Sun, 25 Feb 2007 20:04:15 +0100
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
Message-ID: <20070225190414.GB6460@elte.hu>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225180910.GA29821@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Kevent is a _very_ small entity and there is _no_ cost of requeueing 
> (well, there is list_add guarded by lock) - after it is done, process 
> can start real work. With rescheduling there are _too_ many things to 
> be done before we can start new work. [...]

actually, no. For example a wakeup too is fundamentally a list_add 
guarded by a lock. Take a look at try_to_wake_up(). The rest you see 
there is just extra frills that relate to things like 'load-balancing 
the requests over multiple CPUs [which i'm sure kevent users would 
request in the future too]'.

> [...] We have to change registers, change address space, various tlb 
> bits and so on - we have to do it, since task describes very heavy 
> entity - the whole process. [...]

but ... 'threadlets' are called thread-lets because they are not full 
processes, they are threads. There's no TLB state in that case. There's 
indeed register state associated with them, and currently there can 
certainly be quite a bit of overhead in a context switch - but not in 
register saving. We do user-space register saving not in the scheduler 
but upon /every system call/. Fundamentally a kernel thread is just its 
EIP/ESP [on x86, similar on other architectures] - which can be 
saved/restored in near zero time. All the rest is something we added for 
good /work queueing/ reasons - and those same extras should either be 
eliminated if they turn out to be not so good reasons after all, or they 
will be wanted for kevents too eventually, once it matures as a work 
queueing solution.

> I think it is _too_ heavy to have such a monster structure like 
> task(thread/process) and related overhead just to do an IO.

i think you are really, really mistaken if you believe that the fact 
that whole tasks/threads or processes can be 'monster structures', 
somehow has any relevance to scheduling/task-queueing performance and 
scalability. It does not matter how large a task's address space is - 
scheduling only relates to the minimal context that is in the CPU. And 
most of that context we save upon /every system call entry/, and restore 
it upon every system call return. If it's so expensive to manipulate, 
why can the Linux kernel do a full system call in ~150 cycles? That's 
cheaper than the access latency to a single DRAM page.

for the same reason has it no relevance that the full kevent-based 
webserver is a 'monster structure' - still a single request's basic 
queueing operation is cheap. The same is true to tasks/threads.

Really, you dont even have to know or assume anything about the 
scheduler, just lets do some elementary math here:

the reqs/sec your sendfile+kevent based webserver can do is 7900 per 
sec. Lets assume you will write further great kevent code which will 
optimize it further and it goes up to 10,100 reqs per sec (100 usecs per 
request), ok? Then also try how many reschedules/sec can your Athon64 
3500 box do. My guess is: about a million per second (1 usec per 
reschedule), perhaps a bit more.

Now lets assume that a threadlet based server would have to 
context-switch for /every single/ request served. That's totally 
over-estimating it, even with lots of slow clients, but lets assume it, 
to judge the worst-case impact.

So if you had to schedule once per every request served, you'd have to 
add 1 usec to your 100 usecs cost, making it 101 usecs. That would bring 
your 10,100 requests per sec to 10,000 requests/sec, under a threadlet 
model of operation. Put differently: it will cost you only 1% in 
performance to schedule once for every request. Or lets assume the task 
is totally cache-cold and you'd have to add 4 usecs for its scheduling - 
that'd still only be 4%. So where is the fat?

	Ingo
