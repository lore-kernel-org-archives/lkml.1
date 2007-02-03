Return-Path: <linux-kernel-owner+w=401wt.eu-S1946399AbXBCIhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946399AbXBCIhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946400AbXBCIhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:37:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946399AbXBCIhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:37:51 -0500
Date: Sat, 3 Feb 2007 09:23:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203082308.GA6748@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4522]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 3 Feb 2007, Ingo Molnar wrote:
> > 
> > Well, in my picture, 'only if you block' is a pure thread 
> > utilization decision: bounce a piece of work to another thread if 
> > this thread cannot complete it. (if the kernel is lucky enough that 
> > the user context told it "it's fine to do that".)
> 
> Sure, you can do it that way too. But at that point, your argument 
> that we shouldn't do it with fibrils is wrong: you'd still need 
> basically the exact same setup that Zach does in his fibril stuff, and 
> the exact same hook in the scheduler, testing the exact same value 
> ("do we have a pending queue of work").

did i ever lose a single word of complaint about those bits? Those are 
not an issue to me. They can be applied to kernel threads just as much.

As i babbled in the very first email about this topic:

| 1) improve our basic #1 design gradually. If something is a
|    bottleneck, if the scheduler has grown too fat, cut some slack. If 
|    micro-threads or fibrils offer anything nice for our basic thread 
|    model: integrate it into the kernel.

i should have said explicitly that to flip user-space from one kernel 
thread to another one (upon blocking or per request) is a nice thing and 
we should integrate that into the kernel's thread model.

But really, being a scheduler guy i was much more concerned about the 
duplication and problems caused by the fibril concept itself - which 
duplication and complexity makes up 80% of Zach's submitted patchset.
For example this bit:

   [PATCH 3 of 4] Teach paths to wake a specific void * target

would totally go away if we used kernel threads for this. In the fibril 
approach this is where the mess starts. Either a 'normal' wakeup has to 
wake up all fibrils, or we have to make damn sure that a wakeup that in 
reality goes to a fibril is never woken via wake_up/wake_up_process.

( Furthremore, i tried to include user-space micro-threads in the 
  argument as well, which Evgeniy Polyako raised not so long ago related 
  to the kevent patchset. All these micro-thread things are of a similar 
  genre. )

i totally agree that the API /should/ be the main focus - but i didnt 
pick the topic and most of the patchset's current size is due to the IMO 
avoidable fibril concept.

regarding the API, i dont really agree with the current form and design 
of Zach's interface.

fundamentally, the basic entity of this thing should be a /system call/, 
not the artificial fibril thing:

  +struct asys_call {
  +       struct asys_result      *result;
  +       struct fibril           fibril;
  +};

i.e. the basic entity should be something that represents a system call, 
with its up to 6 arguments, the later return code, state, flags and two 
list entries:

  struct async_syscall {
	unsigned long nr;
	unsigned long args[6];
	long err;
	unsigned long state;
	unsigned long flags;
	struct list_head list;
	struct list_head wait_list;
	unsigned long __pad[2];
  };

(64 bytes on 32-bit, 128 bytes on 64-bit)

furthermore, i think this API should be fundamentally vectored and 
fundamentally async, and hence could solve another issue as well: 
submitting many little pieces of work of different IO domains in one go.

[ detail: there should be no traditional signals used at all (Zach's 
  stuff doesnt use them, and correctly so), only if the async syscall 
  that is performed generates a signal. ]

The normal and most optimal workflow should be a user-space ring-buffer 
of these constant-size struct async_syscall entries:

  struct async_syscall ringbuffer[1024];

  LIST_HEAD(submitted);
  LIST_HEAD(pending);
  LIST_HEAD(completed);

the 3 list heads are both known to the kernel and to user-space, and are 
actively managed by both. The kernel drives the execution of the async 
system calls based on the 'submitted' list head (until it empties it) 
and moves them over to the 'pending' list. User-space can complete async 
syscalls based on the 'completed' list. (but a sycall can optinally be 
marked as 'autocomplete' as well via the 'flags' field, in that case 
it's not moved to the 'completed' list but simply removed from the 
'pending' list. This can be useful for system calls that have some 
implicit notification effect.)

( Note: optionally, a helper kernel-thread, when it finishes processing 
  a syscall, could also asynchronously check the 'submitted' list and 
  pick up new work. That would allow the submission of new syscalls 
  without any entry into the kernel. So for example on an SMT system, 
  this could result in essence one CPU could running in pure user-space 
  submitting async syscalls via the ringbuffer, while another CPU would
  in essence be running pure kernel-space, executing those entries. )

another crutial bit is the waiting on pending work. But because every 
pending syscall entity is either already completed or has a real kernel 
thread associated with it, that bit is mostly trivial: user-space can 
wait on 'any' pending syscall to complete, or it could wait for a 
specific list of syscalls to complete (using the ->wait_list). It could 
also wait on 'a minimum number of N syscalls to complete' - to create 
batching of execution. And of course it can periodically check the 
'completed' list head if it has a constant and highly parallel flow of 
workload - that way the 'waiting' does not actually have to happen most 
of the time.

Looks like we can hit many birds with this single stone: AIO, vectored 
syscalls, finegrained system-call parallelism. Hm?

	Ingo
