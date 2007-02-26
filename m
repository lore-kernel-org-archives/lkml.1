Return-Path: <linux-kernel-owner+w=401wt.eu-S1030230AbXBZOGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbXBZOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXBZOGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:06:24 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53765 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030230AbXBZOGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:06:23 -0500
Date: Mon, 26 Feb 2007 17:05:00 +0300
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
Message-ID: <20070226140500.GA31629@2ka.mipt.ru>
References: <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226123922.GA1370@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 17:05:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 01:39:23PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > > Kevent is a _very_ small entity and there is _no_ cost of 
> > > > requeueing (well, there is list_add guarded by lock) - after it is 
> > > > done, process can start real work. With rescheduling there are 
> > > > _too_ many things to be done before we can start new work. [...]
> > > 
> > > actually, no. For example a wakeup too is fundamentally a list_add 
> > > guarded by a lock. Take a look at try_to_wake_up(). The rest you see 
> > > there is just extra frills that relate to things like 
> > > 'load-balancing the requests over multiple CPUs [which i'm sure 
> > > kevent users would request in the future too]'.
> > 
> > wake_up() as a call is pretty simple and fast, but its result - it is 
> > slow. [...]
> 
> You are still very much wrong, and now you refuse to even /read/ what i 
> wrote. Your only reply to my detailed analysis is: "it is slow, because 
> it is slow and heavy". I told you how fast it is, i told you what 
> happens on a context switch and why, i told you that you can measure if 
> you want.

Ingo, you likely will not believe, but your mails are ones of the
several which I always read several times to get every bit of it :)

I clearly understand your point of view, it is absoutely clear and shine
for me. But... I can not agree with it.

Because of theoretical point of view and practical one concerned my
measurements. It is not pure speculation, which one can expect, but real
life comparison of kernel/user scheduling with pure userspace one (like
in own M:N threading lib or concurrent prgramming language like erlang).
For me (and probably _only_ for me), it is enough to show that some lib
shows 10 times faster rescheduling to start developing own, so I pointed
to it in a discussion.

> > [...] I did not run reschedulingtests with kernel thread, but posix 
> > threads (they do look like a kernel thread) have significant overhead 
> > there.
> 
> You are wrong. Let me show you some more numbers. This is a 
> hackbench_pth.c run:
> 
>   $ ./hackbench_pth 500
>   Time: 14.371
> 
> this uses 20,000 real threads and during this test the runqueue length 
> is extreme - up to over a ten thousand threads. (hackbench_pth.c was 
> posted to lkml recently.
> 
> The same run with hackbench.c (20,000 forked processes):
> 
>   $ ./hackbench 500
>   Time: 14.632
> 
> so the TLB overhead from using processes is 1.8%.
> 
> > [...] In early developemnt days of M:N threading library I tested 
> > rescheduling performance of the POSIX threads - I created pool of 
> > threads and 'sent' a message using futex wait/wake - such performance 
> > of the userspace threading library (I tested erlang) was 10 times 
> > slower.
> 
> how much would it take for you to actually re-measure it and interpet 
> the results you are seeing? You've apparently built a whole mental house 
> of cards on the flawed proposition that tasks are 'super-heavy' and that 
> context-switching them is 'slow'. You are unwilling to explain /how/ 
> they are slow, and all the numbers i post are contrary to that 
> proposition of yours.
> 
> your whole reasoning seems to be faith-based:
> 
> [...] Anyway, kevents are very small, threads are very big, [...]
> 
> How about following the scientific method instead?

That are only rethorical words as you have understood I bet, I meant that the
whole process of getting readiness notification from kevent is way tooo
much faster than resheduling of the new process/thread to handle that IO.

The whole process of switching from one process to another can be as fast
as bloody hell, but all other details just kill the thing.

I do not know, what exact line ends up with problem, but having thousands
of threads, rescheduling itself, results in slower performance than
userspace rescheduling. Then I interpolate it to our IO test case.

> > [...] and both are the way they are exactly on purpose - threads serve 
> > for processing of any generic code, kevents are used for event waiting 
> > - IO is such an event, it does not require a lot of infrastructure to 
> > handle, it only nees some simple bits, so it can be optimized to be 
> > extremely fast, with huge infrastructure behind each IO (like in case 
> > when it is a separated thread) it can not be done effectively.
> 
> you are wrong, and i have pointed it out to you in my previous replies 
> why you are wrong. Your only coherent specific thought on this topic was 
> your incorrect assumption is that the scheduler somehow saves registers 
> and that this makes it heavy. I pointed it out to you in the mail you 
> reply to that /every/ system call that saves user registers. You've not 
> even replied to that point of mine, you are ignoring it completely and 
> you are still repeating your same old, incorrect argument. If it is 
> heavy, /why/ do you think it is heavy? Where is that magic pixie dust 
> piece of scheduler code that miraculously turns the runqueue into a 
> molass slow, heavy piece of thing?

I do not arue that I'm absolutely right.
I just point that I tested some cases and that tests ends up with
completely broken behaviour for micro-thread design (even besides the
case of thousand of new thread creation/reuse per second, which itself
does not look perfect).

I do not even ever try to say that threadlets suck (although I do believe
that it is in some cases, at leat for now :) ), I just point that
rescheduling overhead happens to be tooo big when it comes to
benchmarks I ran (where you never replied too, but that does not matter
after all :).

It can end up with (handwaving) broken syscall wrapper implementation,
or with anything else. Absolutely.

I never ever tried to say that scheduler's code is broken - I just show
my own tests which resulted in the situation, when many working threads
can end up with timings worse than some other case.

Register/tlb/whatever is just a speculation about _possible _ root of
the problem. I did not investigate problem enough - I just decided to
implement different library. Shame on me for that, since I never showed 
what exactly is a root of the problem, but for _me_ it is enough, so I'm
trying to share it with you and other developers.

> Or put in another way: your test-code does ~6 syscalls per every event. 
> So if what you said would be true (which it isnt), a kevent based 
> request would have be just as slow as thread based request ...

I can neither confirm nor object against this sentence.

> > > i think you are really, really mistaken if you believe that the fact 
> > > that whole tasks/threads or processes can be 'monster structures', 
> > > somehow has any relevance to scheduling/task-queueing performance 
> > > and scalability. It does not matter how large a task's address space 
> > > is - scheduling only relates to the minimal context that is in the 
> > > CPU. And most of that context we save upon /every system call 
> > > entry/, and restore it upon every system call return. If it's so 
> > > expensive to manipulate, why can the Linux kernel do a full system 
> > > call in ~150 cycles? That's cheaper than the access latency to a 
> > > single DRAM page.
> > 
> > I meant not its size, but the whole infrastructure, which surrounds 
> > task. [...]
> 
> /what/ infrastructure do you mean? sched.c? Most of that never runs in 
> the scheduler hotpath.
>
> > [...] If it is that lightweight, why don't we have posix thread per 
> > IO? [...]
> 
> because it would be pretty stupid to do that?
> 
> But more importantly: because many people still believe 'the scheduler 
> is slow and context-switching is evil'? The FIO AIO syslet code from 
> Jens is an intelligent mix of queueing combined with async execution. I 
> expect that model to prevail.

Suparna showed its problems - although on an older version. 
Let's see another tests.

> > [...] One question is that mmap/allocation of the stack is too slow 
> > (and it is very slow indeed, that is why glibc and M:N threading lib 
> > caches allocated stacks), another one is kernel/userspace boundary 
> > crossing, next one are tlb flushes, then copies.
> 
> now you come up again with creation overhead but nobody is talking about 
> context creation overhead. (btw., you are also wrong if you think that 
> mmap() is all that slow - try measuring it one day) We were talking 
> about context /switching/.

Ugh, Ingo, do not think absolutely...
I did it. And it is slow.
http://tservice.net.ru/~s0mbre/blog/2007/01/15#2007_01_15

> > Why userspace rescheduling is in order of tens times faster than 
> > kernel/user?
> 
> what on earth does this have to do with the topic of whether context 
> switches are fast enough? Or if you like random info, just let me throw 
> in a random piece of information as well:
> 
> user-space function calls are more than /two/ orders of magnitude faster 
> than system calls. Still you are using 6 ... SIX system calls in the 
> sample kevent request handling hotpath.

I can only laugh on that, Ingo :)
If you will be in Moscow, I will buy you a beer, just drop me a mail.

What we are talking about, Ingo, kevent and IO in thread contexts, 
or userspace vs. kernelspace scheduling?

Kevent can be broken as hell, it can be stupid application, which does
not work at all - it is one of the possible theories.
Practice however shows that it is not true.

Anyway, if we are talking about kevents and micro-threads, that is one
point, if we are talking about possible overhead of rescheduling - it is
another topic.

> > > for the same reason has it no relevance that the full kevent-based 
> > > webserver is a 'monster structure' - still a single request's basic 
> > > queueing operation is cheap. The same is true to tasks/threads.
> > 
> > To move that tasks there must be done too may steps, and although each 
> > one can be quite fast, the whole process of rescheduling in the case 
> > of thousands running threads creates too big overhead per task to drop 
> > performance.
> 
> again, please come up with specifics! I certainly came up with enough 
> specifics.

I thought I showed it several times already.
Anyway: http://tservice.net.ru/~s0mbre/blog/2006/11/09#2006_11_09

That is an initial step, which shows that rescheduling of threads (
I DO NOT say about problems in sched.c, Ingo, that would be somehow
stupid, althogh can be right) has some overhead comapred to userspace
rescheduling. If so, it can be eliminated or reduced.

Second (COMPELTELY DIFFERENT STARTING POINT).
If rescheduling has some overhead, is it possible to reduce it using
different model for IO? So I created kevent (as you likely do not know,
original idea was a bit differnet - network AIO, but results is quite good).

> 	Ingo

-- 
	Evgeniy Polyakov
