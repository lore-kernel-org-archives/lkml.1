Return-Path: <linux-kernel-owner+w=401wt.eu-S1946127AbXBBW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946127AbXBBW1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946129AbXBBW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:27:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946127AbXBBW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:27:37 -0500
Date: Fri, 2 Feb 2007 23:21:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202222110.GA1212@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0467]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 2 Feb 2007, Ingo Molnar wrote:
> > 
> > My only suggestion was to have a couple of transparent kernel threads 
> > (not fibrils) attached to a user context that does asynchronous 
> > syscalls! Those kernel threads would be 'switched in' if the current 
> > user-space thread blocks - so instead of having to 'create' any of them 
> > - the fast path would be to /switch/ them to under the current 
> > user-space, so that user-space processing can continue under that other 
> > thread!
> 
> But in that case, you really do end up with "fibrils" anyway.
> 
> Because those fibrils are what would be the state for the blocked 
> system calls when they aren't scheduled.
> 
> We may have a few hundred thousand system calls a second (maybe that's 
> not actually reasonable, but it should be what we *aim* for), and 99% 
> of them will hopefully hit the cache and never need any separate IO, 
> but even if it's just 1%, we're talking about thousands of threads.
> 
> I do _not_ think that it's reasonable to have thousands of threads 
> state around just "in case". Especially if all those threadlets are 
> then involved in signals etc - something that they are totally 
> uninterested in.
> 
> I think it's a lot more reasonable to have just the kernel stack page 
> for "this was where I was when I blocked". IOW, a fibril-like thing. 

ok, i think i noticed another misunderstanding. The kernel thread based 
scheme i'm suggesting would /not/ 'switch' to another kernel thread in 
the cached case, by default. It would just execute in the original 
context (as if it were a synchronous syscall), and the switch to a 
kernel thread from the pool would only occur /if/ the context is about 
to block. (this 'switch' thing would be done by the scheduler) 
User-space gets back an -EAIO error code immediately and transparently - 
but already running under the new kernel thread.

i.e. in the fully cached case there would be no scheduling at all - in 
fact no thread pool is needed at all.

regarding cost:

the biggest memory resource cost of a kernel thread (assuming it has no 
real user-space context) /is/ its kernel stack page, which is 4K or 8K. 
The task struct takes ~1.5K. Once we have a ready kernel thread around, 
it's quite cheap to 'flip' it to under any arbitrary user-space context: 
change its thread_info->task pointer to the user-space context's task 
struct, copy the mm pointer, the fs pointer to the "worker thread", 
switch the thread_info, update ptregs - done. Hm?

Note: such a 'flip' would only occur when the original context blocks, 
/not/ on every async syscall.

regarding CPU resource costs, i dont think there should be significant 
signal overhead, because the original task is still only one instance, 
and the kernel thread that is now running with the blocked kernel stack 
is not part of the signal set. (Although it might make sense to make 
such async syscalls interruptible, just like any syscall.)

The 'pool' of kernel threads doesnt even have to be per-task, it can be 
a natural per-CPU thing - and its size will grow/shrink [with a low 
update frequency] depending on how much AIO parallelism there is in the 
workload. (But it can also be strictly per-user-context - to make sure 
that a proper ->mm ->fs, etc. is set up and that when the async system 
calls execute they have all the right context info.)

and note the immediate scheduling benefits: if an app (say like 
OpenOffice) is single-threaded but has certain common ops coded as async 
syscalls, then if any of those syscalls blocks then it could utilize 
/more than one/ CPU. I.e. we could 'spread' a single-threaded app's 
processing to multiple cores/hardware-threads /without/ having to 
multi-thread the app in an intrusive way. I.e. this would be a 
finegrained threading of syscalls, executed as coroutines in essence. 
With fibrils all sorts of scheduling limitations occur and no 
parallelism is possible.

in fact an app could also /trigger/ the execution of a syscall in a 
different context - to create parallelism artificially - without any 
blocking event. So we could do:

  cookie1 = sys_async(sys_read, params);
  cookie2 = sys_async(sys_write, params);

  [ ... calculation loop ... ]

  wait_on_async_syscall(cookie1);
  wait_on_async_syscall(cookie2);

or something like that. Without user-space having to create threads 
itself, etc. So basically, we'd make kernel threads more useful, and 
we'd make threading safer - by only letting syscalls thread.

> What I like about fibrils is that they should be able to handle the 
> cached case well: the case where no "real" scheduling (just the fibril 
> stack switches) takes place.

the cached case (when a system call would not block at all) would not 
necessiate any switch to another kernel thread at all - the task just 
executes its system call as if it were synchronous!

that's the nice thing: we can do this switch-to-another-kernel-thread 
magic thing right in the scheduler when we block - and the switched-to 
thread will magically return to user-space (with a -EAIO return code) as 
if nothing happened (while the original task blocks). I.e. under this 
scheme i'm suggesting we have /zero/ setup cost in the cached case. The 
optimistic case just falls through and switches to nothing else. Any 
switching cost only occurs in the slowpath - and even that cost is very 
low.

once a kernel thread that ran off with the original stack finishes the 
async syscall and wants to return the return code, this can be gathered 
via a special return-code ringbuffer that notifies finished syscalls. (A 
magic cookie is associated to every async syscall.)

> So the state machine argument is totally bogus - it results in a 
> programming model that simply doesn't match the *normal* setup. You 
> want the kernel programming model to appear "linear" even when it 
> isn't, because it's too damn hard to think nonlinearly.
>
> Yes, we could do pathname lookup with that kind of insane setup too. 
> But it would be HORRID!

yeah, but i guess not nearly as horrid as writing a new OS from scratch 
;-)

seriously, i very much think and agree that programming state machines 
is hard and not desired in most of the kernel. But it can be done, and 
sometimes (definitely not in the common case) it's /cleaner/ than 
functional programming. I've programmed an HTTP and an FTP in-kernel 
server via a state machine and it worked better than i initially 
expected. It needs different thinking but there /are/ people around with 
that kind of thinking, so we just cannot exclude the possibility. [ It's 
just that such people usually dedicate their brain to mental 
fantasies^H^H^Hexcercises called 'Higher Mathematics' :-) ]

> [...] The fact that networking (and TCP in particular) has state 
> machines is because it is a packetized environment.

rough ballpark figures: for things like webserving or fileserving (or 
mailserving), networking sockets are the reason for context-blocking 
events in 90% of the cases (mostly due to networking latency). 9% of the 
blocking happens due to plain block IO, and 1% happens due to VFS 
metadata (inode, directory, etc.) blocking.

( in Tux i had to handle /all/ of these sources of blocking because even
  1% kills your performance if you do a hundred thousand requests per
  second - but in terms of design weight, networking is pretty damn
  important. )

and interestingly, modern IO frameworks tend to gravitate towards a 
packetized environment as well. I.e. i dont think state machines are 
/that/ unimportant.

	Ingo
