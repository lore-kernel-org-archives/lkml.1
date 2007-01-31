Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbXAaIpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbXAaIpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbXAaIpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:45:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbXAaIpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:45:35 -0500
Date: Wed, 31 Jan 2007 09:43:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070131084331.GA3404@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <45C02AFA.4080501@yahoo.com.au> <Pine.LNX.4.64.0701302153520.3611@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701302153520.3611@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4969]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Of course, that used to also be the claim by all the people who 
>   thought we couldn't do native kernel threads for "normal" threading 
>   either, and should go with the n*m setup. Shows how much they knew 
>   ;^]
> 
> But I've certainly _personally_ always wanted to do AIO with threads. 
> I wanted to do it with regular threads (ie the "clone()" kind). It 
> didn't fly. But I think we can possibly lower both the setup costs and 
> the memory costs with the cooperative approach, to the point where 
> maybe this one is more palatable and workable.

as you know i've been involved in all the affected IO and scheduling 
disciplines in question: i hacked on scheduling, 1:1 threading, on Tux, 
i even optimized kaio under TPC workloads, and various other things. So 
i believe to have seen most of these things first-hand and thus i 
(pretend to) have no particular prejudice or other subjective 
preference. In the following, rather long (and boring) analysis i touch 
upon both 1:1 threading, light threads, state machines and AIO.

The first and most important thing is that i think there are only /two/ 
basic, fundamental IO approaches that matter to kernel design:

 1) the most easy to program one.

 2) the fastest one.

1), the most easily programmed model: this is tasks and synchronous IO. 
Samba (and Squid, and even Apache most of the time ...) is still using 
plain old /processes/ and is doing fine! Most of the old LWP arguments 
are not really true anymore, TLB switches are very fast meanwhile (per 
hardware improvements) and our scheduler is still pretty light. 
Furthermore, for certain specialized environments that are able isolate 
the programmer from the risks and complexities of thread programming, 
threading can be somewhat faster (such as Java or C#). But for the 
general C/C++ based server environment even threading is pure hell. (We 
know it from the kernel that programming a threaded design is /hard/,
needs alot of discipline and takes alot more resources than any of the
saner models.)

2) the fastest model: is a pure, minimal state-machine tailored to the 
task/workload we want to do. Tux does that (and i'm keeping it uptodate 
for current 2.6 kernels too), and it still beats the pants off anything 
user-space.

But reality is that most people care more about programmability: 300 
MB/sec or 500 MB/sec web throughput limit (or a serving limit 30K 
requests in parallel or 60K requests in parallel - whatever the 
performance metric you care about is) isnt really making any difference 
in all but the most specialized environments - /because/ the price to 
pay for it is much worse programmability (and hence much worse 
flexibility). [ And this is all about basic economy: if it's 10 times 
harder to program something and what takes 1 month to program in one 
model takes 10 months to program in the other model - but in 10 months 
the hardware already got another 50% faster, likely offsetting the 
advantage of that 'other' model to begin with ... ]

Note that often the speed difference between task based and state based 
designs is alot smaller. But God is the programming complexity 
difference huge. Not even huge but /HUGE/. All our programming languages 
are procedural and stack based. (Not only is there a basic lack of 
state-based programming languages, it's a product of our brain 
structure: state machines are not really what the human mind is 
structured for, but i digress.)

Now where do all these LWP, fibre, firbril, micro-thread or N:M concepts 
fit? Most of the time they are just a /weakening/ of the #1 concept. And 
that's why they will lose out, because #1 is all about programmability 
and they dont offer anything new: because they cannot. Either you go for 
programmability or you go for performance. There is /no/ middle ground 
for us in the kernel! (User-space can do the middle ground thing, but 
the kernel must only be structured around the two most fundamental 
concepts that exist. [NOTE: more about KAIO later.])

Having a 1:1 relationship between user-space and kernel-space context is 
a strong concept, and on modern CPUs we perform /process/ context 
switches in 650 nsecs, we do user thread context switches in 500 nsecs, 
and kernel<->kernel thread context switches in 350 nsecs. That's pretty 
damn fast.

The big problem is, the M:N concepts (and i consider micro-threads or 
'schedulable stacks' to be of that type) tend to operate the following 
way: they build up hype by being "faster" - but the performance 
advantage only comes from weakening #1! (for example by not making the 
contexts generally schedulable, bindable, load-balancable, suspendable, 
migratable, etc.) But then a few years later they grow (by virtue of 
basic pressure from programmers, who /want/ a clean easily programmable 
concept #1) the /very same/ features that they "optimized away" in the 
beginning. With the difference that now all that infrastructure they 
left out initially is replicated in user-space, in a poorer and 
inconsistent way, blowing up cache-size, and slowing the /sane/ things 
down in the end. (and then i havent even begun about the nightmare of 
extending the debug infrastructure to light threads, ABI dependencies, 
etc, etc...)

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

Furthermore, 'light thread' concepts can no way approach the performance 
of #2 state-machines: if you /know/ what the structure of your context 
is, and you can program it in a specialized state-machine way, there's 
just so many shortcuts possible that it's not even funny.

> And maybe it also solves some of the scalability worries (threads have 
> ID space and scheduling setup things that essentially go away by just 
> not doing them - which is what the fibrils simply wouldn't have).

our PID management is very fast - i've never seen it show up in 
profiles. (We could make it even more scalable if the need arises, for 
example right now we still maintain the luxory of having a globally 
increasing and tightly compressed PID/TID space.)

until a few days ago we even had a /global lock/ in the thread/task 
creation and destruction hotpath since 2.5.43 (when oprofile support was 
added, more than 4 years ago, the oprofile exit notifier lock) and 
nobody really noticed or cared!

so i believe there are only two directions that make sense in the long 
run:

1) improve our basic #1 design gradually. If something is a bottleneck,
   if the scheduler has grown too fat, cut some slack. If micro-threads 
   or fibrils offer anything nice for our basic thread model: integrate 
   it into the kernel. (Dont worry about having the enter the kernel for 
   that, we /want/ that isolation! Resource control /needs/ a secure and 
   trustable context. Good debuggability /needs/ a secure and trustable 
   context. Hardware makers will make damn sure that such hardware-based 
   isolation is fast as lightning. SYSENTER will continue to be very 
   fast.) In any case, unless someone can answer the issues i raised 
   above, please dont mess with the basic 1:1 task model we have. It's 
   really what we want to have.

2) enable crazy people to do IO in the #2 way. For this i think the most 
   programmable interface is KAIO - because the 'context' /only/ 
   involves the IO entity itself, which is simple enough for our brain
   to wrap itself around. (and the hardware itself has the concept of
   'in flight IO' anyway, so people are forced to learn about it and to
   deal with it anyway, even in the synchronous IO model. So there's
   quite some mindshare to build upon.) This also happens to realize
   /most/ of the performance advantages that a state-machine like Tux
   tends to have. (In that sense i dont see epoll to be conceptually
   different from KAIO, although internally within the kernel it's quite
   a bit different.)

now, KAIO 'behind the hood' (within the kernel) is like /very/ hard to 
program in a fully state-driven manner - but we are crazy folks who 
/might/ be able to pull it off. Initially we should just simulate the 
really hard bits via a pool of in-kernel synchronous threads. Some IO 
disciplines are already state-driven internally (networking most 
notably, but also timers), so there KAIO can be implemented 'natively'.

And it will be /faster/ than micro-threads based AIO!

but frankly, KAIO is the most i can see a normal, sane human programmer 
to be able to deal with. Any more exposure to state-machines will just 
drive them crazy, and they'll lynch us (or more realistically: ignore 
us) if we try anything more. And with KAIO they still have the /option/ 
to make all their user-space functionality state-driven. Also, abstract, 
fully managed programming environments like Java can hide KAIO 
complexities by implementing their synchronous primitives using KAIO.

	Ingo
