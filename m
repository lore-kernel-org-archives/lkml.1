Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXBCADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXBCADi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933394AbXBCADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:03:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbXBCADh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:03:37 -0500
Date: Sat, 3 Feb 2007 00:55:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202235531.GA18904@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> THAT'S THE POINT. That's what makes fibrils cooperative. The "only if 
> you block" is really what makes a fibril be something else than a 
> regular thread.

Well, in my picture, 'only if you block' is a pure thread utilization 
decision: bounce a piece of work to another thread if this thread cannot 
complete it. (if the kernel is lucky enough that the user context told 
it "it's fine to do that".)

it is 'incidental parallelism' instead of 'intentional parallelism', but 
the random and unpredictable nature of it doesnt change anything about 
the fundamental fact: we start a new thread of execution in essence.

Typically it will be rare in a workload as it will be driven by 
cachemisses, but for example in DB workloads the 'cachemiss' will be the 
/common case/ - because the DB manages the cache itself.

And how to run a thread of execution is a fundamental /scheduling/ 
decision: it is the acceptance of and the adoption to the cost of work 
migration - if no forced wait happens then often it's cheaper to execute 
all work locally and serially.

[ in fact, such a mechanism doesnt even always have to be driven from
  the scheduler itself: such a 'bounce current work to another thread'
  event could occur when we detect that a pagecache page is missing and
  that we have to do a ->readpage, etc. Tux does that since 1999: the
  cutoff for 'bounce work' was when a soft cache (the pagecache or the
  dentry cache) was missed - not when we went into the IO path. This has
  the advantage that the Tux cachemiss threads could do /all/ the IO
  preparation and IO completion on the same CPU and in one go - while
  the user context was able to continue executing. ]

But this is also a function of hardware: for example on a Transputer i'd 
bounce off all such work immediately (even if it's a sys_time() 
syscall), all the time, even if fully cached, no exceptions, because the 
hardware is such that another CPU can pick it up in the next cycle.

while we definitely dont want to bounce short-lived cached syscalls to 
another thread, for longer ones or ones which we /expect/ to block we 
might want to do it like that straight away. [Especially on a multi-core 
CPU that has a shared L2 cache (and doubly so on a HT/SMT CPU that has a 
shared L1 cache).]

i dont see anything here that mandates (or even strongly supports) the 
notion of cooperative scheduling. The moment a context sees a 'cache 
miss', it is totally fair to potentially distribute it to other CPUs. It 
wont run for a long time and it will be totally cache-cold when the 'IO 
done' event occurs - hence we should schedule it where the IO event 
occured. Which might easily be the same CPU where the user context is 
running right now (we prefer last-run CPUs on wakeups), but not 
necessarily - it's a general scheduling decision.

> > Note: such a 'flip' would only occur when the original context 
> > blocks, /not/ on every async syscall.
> 
> Right.
> 
> So can you take a look at Zach's fibril idea again? Because that's 
> exactly what it does. It basically sets a flag, saying "flip to this 
> when you block or yield". Of course, it's a bit bigger than just a 
> flag, since it needs to describe what to flip to, but that's the basic 
> idea.

i know Zach's code ... i really do. Even if i didnt look at the code 
(which i did), Jonathon Corbet did a very nice writeup about fibrils on 
LWN.net two days ago, which i've read as well:

  http://lwn.net/Articles/219954/

So there's no misunderstanding on my side i think.

> Now, if you want to make fibrils *also* then actually use a separate 
> thread, that's an extension.

oh please, Linus. I /did/ suggest this as an extension to Zach's idea! 
Look at the Subject line - i'm reacting to the specific fibril code of 
Zach. I wrote this:

| as per my other email, i dont really like this concept. This is the 
| killer:
|
| > [...]  There can be multiple of them in the process of executing for 
| > a given task_struct, but only one can every be actively running at a 
| > time. [...]
|
| there's almost no scheduling cost from being able to arbitrarily 
| schedule a kernel thread - but there are /huge/ benefits in it.
|
| would it be hard to redo your AIO patches based on a pool of plain 
| simple kernel threads?

see http://lkml.org/lkml/2007/2/1/40.

	Ingo
