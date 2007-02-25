Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXBYTp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXBYTp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXBYTp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:45:56 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60657 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXBYTpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:45:55 -0500
Date: Sun, 25 Feb 2007 22:42:51 +0300
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
Message-ID: <20070225194250.GA1353@2ka.mipt.ru>
References: <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225190414.GB6460@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 22:43:30 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 08:04:15PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > Kevent is a _very_ small entity and there is _no_ cost of requeueing 
> > (well, there is list_add guarded by lock) - after it is done, process 
> > can start real work. With rescheduling there are _too_ many things to 
> > be done before we can start new work. [...]
> 
> actually, no. For example a wakeup too is fundamentally a list_add 
> guarded by a lock. Take a look at try_to_wake_up(). The rest you see 
> there is just extra frills that relate to things like 'load-balancing 
> the requests over multiple CPUs [which i'm sure kevent users would 
> request in the future too]'.

wake_up() as a call is pretty simple and fast, but its result - it is
slow. I did not run reschedulingtests with kernel thread, but posix
threads (they do look like a kernel thread) have significant overhead
there. In early developemnt days of M:N threading library I tested
rescheduling performance of the POSIX threads - I created pool of
threads and 'sent' a message using futex wait/wake - such performance of
the userspace threading library (I tested erlang) was 10 times slower.

> > [...] We have to change registers, change address space, various tlb 
> > bits and so on - we have to do it, since task describes very heavy 
> > entity - the whole process. [...]
> 
> but ... 'threadlets' are called thread-lets because they are not full 
> processes, they are threads. There's no TLB state in that case. There's 
> indeed register state associated with them, and currently there can 
> certainly be quite a bit of overhead in a context switch - but not in 
> register saving. We do user-space register saving not in the scheduler 
> but upon /every system call/. Fundamentally a kernel thread is just its 
> EIP/ESP [on x86, similar on other architectures] - which can be 
> saved/restored in near zero time. All the rest is something we added for 
> good /work queueing/ reasons - and those same extras should either be 
> eliminated if they turn out to be not so good reasons after all, or they 
> will be wanted for kevents too eventually, once it matures as a work 
> queueing solution.

If things decreases performance noticebly, it is a bad things, but it is
matter of taste. Anyway, kevents are very small, threads are very big,
and both are the way they are exactly on purpose - threads serve for
processing of any generic code, kevents are used for event waiting - IO
is such an event, it does not require a lot of infrastructure to handle,
it only nees some simple bits, so it can be optimized to be extremely
fast, with huge infrastructure behind each IO (like in case when it is a
separated thread) it can not be done effectively.

> > I think it is _too_ heavy to have such a monster structure like 
> > task(thread/process) and related overhead just to do an IO.
> 
> i think you are really, really mistaken if you believe that the fact 
> that whole tasks/threads or processes can be 'monster structures', 
> somehow has any relevance to scheduling/task-queueing performance and 
> scalability. It does not matter how large a task's address space is - 
> scheduling only relates to the minimal context that is in the CPU. And 
> most of that context we save upon /every system call entry/, and restore 
> it upon every system call return. If it's so expensive to manipulate, 
> why can the Linux kernel do a full system call in ~150 cycles? That's 
> cheaper than the access latency to a single DRAM page.

I meant not its size, but the whole infrastructure, which surrounds
task. If it is that lightweight, why don't we have posix thread per IO?
One question is that mmap/allocation of the stack is too slow (and it is
very slow indeed, that is why glibc and M:N threading lib caches
allocated stacks), another one is kernel/userspace boundary crossing,
next one are tlb flushes, then copies.

Why userspace rescheduling is in order of tens times faster than
kernel/user?

> for the same reason has it no relevance that the full kevent-based 
> webserver is a 'monster structure' - still a single request's basic 
> queueing operation is cheap. The same is true to tasks/threads.

To move that tasks there must be done too may steps, and although each
one can be quite fast, the whole process of rescheduling in the case of
thousands running threads creates too big overhead per task to drop
performance.

> Really, you dont even have to know or assume anything about the 
> scheduler, just lets do some elementary math here:
> 
> the reqs/sec your sendfile+kevent based webserver can do is 7900 per 
> sec. Lets assume you will write further great kevent code which will 
> optimize it further and it goes up to 10,100 reqs per sec (100 usecs per 
> request), ok? Then also try how many reschedules/sec can your Athon64 
> 3500 box do. My guess is: about a million per second (1 usec per 
> reschedule), perhaps a bit more.

Let's calculate: disk bandwidth is about gigabytes per second (cached
case), so to transfer 10k file we need about 10 usec - 10% of it will be
spent in rescheduling (if there will be only one  if any).
Network is an order of 10 slower (1gbit for example), but there are much
more blockings, so to transfer 10k we will have let's say 5 blocks, i.e.
5 reschedulings - another 5%, so we wasted 15% of our time in
rescheduling.

Event in turn is a 30 bytes copy (plus of course own overhead, but it is
still faster - it is faster just because ukevet size is smaller than
pt_regs :).

Interesting discussion, that will be very fun if kevent will lose badly
:)

> Now lets assume that a threadlet based server would have to 
> context-switch for /every single/ request served. That's totally 
> over-estimating it, even with lots of slow clients, but lets assume it, 
> to judge the worst-case impact.
> 
> So if you had to schedule once per every request served, you'd have to 
> add 1 usec to your 100 usecs cost, making it 101 usecs. That would bring 
> your 10,100 requests per sec to 10,000 requests/sec, under a threadlet 
> model of operation. Put differently: it will cost you only 1% in 
> performance to schedule once for every request. Or lets assume the task 
> is totally cache-cold and you'd have to add 4 usecs for its scheduling - 
> that'd still only be 4%. So where is the fat?

I need to move home or I will sleep on the street, otherwise I would already
ran a test and started to eat a hat (present me a red one like Lan Cox
had), or watch how you to do it :)

Give me several hours.

> 	Ingo

-- 
	Evgeniy Polyakov
