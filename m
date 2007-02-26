Return-Path: <linux-kernel-owner+w=401wt.eu-S965235AbXBZMrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbXBZMrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965256AbXBZMrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:47:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37284 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965235AbXBZMq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:46:58 -0500
Date: Mon, 26 Feb 2007 13:39:23 +0100
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
Message-ID: <20070226123922.GA1370@elte.hu>
References: <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225194250.GA1353@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0536]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> > > Kevent is a _very_ small entity and there is _no_ cost of 
> > > requeueing (well, there is list_add guarded by lock) - after it is 
> > > done, process can start real work. With rescheduling there are 
> > > _too_ many things to be done before we can start new work. [...]
> > 
> > actually, no. For example a wakeup too is fundamentally a list_add 
> > guarded by a lock. Take a look at try_to_wake_up(). The rest you see 
> > there is just extra frills that relate to things like 
> > 'load-balancing the requests over multiple CPUs [which i'm sure 
> > kevent users would request in the future too]'.
> 
> wake_up() as a call is pretty simple and fast, but its result - it is 
> slow. [...]

You are still very much wrong, and now you refuse to even /read/ what i 
wrote. Your only reply to my detailed analysis is: "it is slow, because 
it is slow and heavy". I told you how fast it is, i told you what 
happens on a context switch and why, i told you that you can measure if 
you want.

> [...] I did not run reschedulingtests with kernel thread, but posix 
> threads (they do look like a kernel thread) have significant overhead 
> there.

You are wrong. Let me show you some more numbers. This is a 
hackbench_pth.c run:

  $ ./hackbench_pth 500
  Time: 14.371

this uses 20,000 real threads and during this test the runqueue length 
is extreme - up to over a ten thousand threads. (hackbench_pth.c was 
posted to lkml recently.

The same run with hackbench.c (20,000 forked processes):

  $ ./hackbench 500
  Time: 14.632

so the TLB overhead from using processes is 1.8%.

> [...] In early developemnt days of M:N threading library I tested 
> rescheduling performance of the POSIX threads - I created pool of 
> threads and 'sent' a message using futex wait/wake - such performance 
> of the userspace threading library (I tested erlang) was 10 times 
> slower.

how much would it take for you to actually re-measure it and interpet 
the results you are seeing? You've apparently built a whole mental house 
of cards on the flawed proposition that tasks are 'super-heavy' and that 
context-switching them is 'slow'. You are unwilling to explain /how/ 
they are slow, and all the numbers i post are contrary to that 
proposition of yours.

your whole reasoning seems to be faith-based:

[...] Anyway, kevents are very small, threads are very big, [...]

How about following the scientific method instead?

> [...] and both are the way they are exactly on purpose - threads serve 
> for processing of any generic code, kevents are used for event waiting 
> - IO is such an event, it does not require a lot of infrastructure to 
> handle, it only nees some simple bits, so it can be optimized to be 
> extremely fast, with huge infrastructure behind each IO (like in case 
> when it is a separated thread) it can not be done effectively.

you are wrong, and i have pointed it out to you in my previous replies 
why you are wrong. Your only coherent specific thought on this topic was 
your incorrect assumption is that the scheduler somehow saves registers 
and that this makes it heavy. I pointed it out to you in the mail you 
reply to that /every/ system call that saves user registers. You've not 
even replied to that point of mine, you are ignoring it completely and 
you are still repeating your same old, incorrect argument. If it is 
heavy, /why/ do you think it is heavy? Where is that magic pixie dust 
piece of scheduler code that miraculously turns the runqueue into a 
molass slow, heavy piece of thing?

Or put in another way: your test-code does ~6 syscalls per every event. 
So if what you said would be true (which it isnt), a kevent based 
request would have be just as slow as thread based request ...

> > i think you are really, really mistaken if you believe that the fact 
> > that whole tasks/threads or processes can be 'monster structures', 
> > somehow has any relevance to scheduling/task-queueing performance 
> > and scalability. It does not matter how large a task's address space 
> > is - scheduling only relates to the minimal context that is in the 
> > CPU. And most of that context we save upon /every system call 
> > entry/, and restore it upon every system call return. If it's so 
> > expensive to manipulate, why can the Linux kernel do a full system 
> > call in ~150 cycles? That's cheaper than the access latency to a 
> > single DRAM page.
> 
> I meant not its size, but the whole infrastructure, which surrounds 
> task. [...]

/what/ infrastructure do you mean? sched.c? Most of that never runs in 
the scheduler hotpath.

> [...] If it is that lightweight, why don't we have posix thread per 
> IO? [...]

because it would be pretty stupid to do that?

But more importantly: because many people still believe 'the scheduler 
is slow and context-switching is evil'? The FIO AIO syslet code from 
Jens is an intelligent mix of queueing combined with async execution. I 
expect that model to prevail.

> [...] One question is that mmap/allocation of the stack is too slow 
> (and it is very slow indeed, that is why glibc and M:N threading lib 
> caches allocated stacks), another one is kernel/userspace boundary 
> crossing, next one are tlb flushes, then copies.

now you come up again with creation overhead but nobody is talking about 
context creation overhead. (btw., you are also wrong if you think that 
mmap() is all that slow - try measuring it one day) We were talking 
about context /switching/.

> Why userspace rescheduling is in order of tens times faster than 
> kernel/user?

what on earth does this have to do with the topic of whether context 
switches are fast enough? Or if you like random info, just let me throw 
in a random piece of information as well:

user-space function calls are more than /two/ orders of magnitude faster 
than system calls. Still you are using 6 ... SIX system calls in the 
sample kevent request handling hotpath.

> > for the same reason has it no relevance that the full kevent-based 
> > webserver is a 'monster structure' - still a single request's basic 
> > queueing operation is cheap. The same is true to tasks/threads.
> 
> To move that tasks there must be done too may steps, and although each 
> one can be quite fast, the whole process of rescheduling in the case 
> of thousands running threads creates too big overhead per task to drop 
> performance.

again, please come up with specifics! I certainly came up with enough 
specifics.

	Ingo
