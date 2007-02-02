Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXBBKuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXBBKuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXBBKuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:50:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXBBKut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:50:49 -0500
Date: Fri, 2 Feb 2007 11:49:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202104900.GA13941@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4569]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So stop blathering about scheduling costs, RT kernels and interrupts. 
> Interrupts generally happen a few thousand times a second. This is 
> soemthing you want to do a *million* times a second, without any IO 
> happening at all except for when it has to.

we might be talking past each other.

i never suggested every aio op should create/destroy a kernel thread!

My only suggestion was to have a couple of transparent kernel threads 
(not fibrils) attached to a user context that does asynchronous 
syscalls! Those kernel threads would be 'switched in' if the current 
user-space thread blocks - so instead of having to 'create' any of them 
- the fast path would be to /switch/ them to under the current 
user-space, so that user-space processing can continue under that other 
thread!

That means that in the 'switch kernel context' fastpath it simply needs 
to copy the blocked threads' user-space ptregs (~64 bytes) to its own 
kernel stack, and then it can do a return-from-syscall without 
user-space noticing the switch! Never would we really see the cost of 
kernel thread creation. We would never see that cost in the fully cached 
case (no other thread is needed then), nor would we see it in the 
blocking-IO case, due to pooling. (there are some other details related 
to things like the FPU context, but you get the idea.)

Let me quote Zach's reply to my suggestions:

| It'd certainly be doable to throw together a credible attempt to 
| service "asys" system call submission with full-on kernel threads. 
| That seems like reasonable due diligence to me.  If full-on threads 
| are almost as cheap, great. If fibrils are so much cheaper that they 
| seem to warrant investing in, great.

that's all i wanted to see being considered!

Please ignore my points about scheduling costs - i only talked about 
them at length because the only fundamental difference between kernel 
threads and fibrils is their /scheduling/ properties. /Not/ the 
setup/teardown costs - those are not relevant /precisely/ because they 
can be pooled and because they happen relatively rarely, compared to the 
cached case. The 'switch to the blocked thread's ptregs' operation also 
involves a context-switch under this design. That's why i was talking 
about scheduling so much: the /only/ true difference between fibrils and 
kernel threads is their /scheduling/.

I believe this is the point where your argument fails:

> - setup/teardown costs. Both memory and CPU. This is where the current
>   threads simply don't work. The setup cost of doing a clone/exit is 
>   actually much higher than the cost of doing the whole operation, 
>   most of the time.

you are comparing apples to oranges - i never said we should 
create/destroy a kernel thread for every async op. That would be insane!

what we need to support asynchronous system-calls is the ability to pick 
up an /already created/ kernel thread from a pool of per-task kernel 
threads and to switch it to under the current user-space and return to 
the user-space stack with that new kernel thread running. (The other, 
blocked kernel thread stays blocked and is returned into the pool of 
'pending' AIO kernel threads.) And this only needs to happen in the 
'cachemiss' case anyway. In the 'cached' case no other kernel thread 
would be involved at all, the current one just falls straight through 
the system-call.

my argument is that the whole notion of cutting this at the kernel stack 
and thread info level and making fibrils in essence a separate 
scheduling entitity is wrong, wrong, wrong. Why not use plain kernel 
threads for this?

[ finally, i think you totally ignored my main argument, state machines.
  The networking stack is a full and very nice state machine. It's
  kicked from user-space, and zillions of small contexts (sockets) are
  living on without any of the originating tasks having to be involved.
  So i'm still holding to the fundamental notion that within the kernel
  this form of AIO is a nice but /secondary/ mechanism. If a subsystem
  is able to pull it off, it can implement asynchronity via a state
  machine - and it will outperform any thread based AIO. Or not. We'll
  see. For something like the VFS i doubt we'll see (and i doubt we
  /want/ to see) a 'native' state-machine implementation.

  this is btw. quite close to the Tux model of doing asynchronous block
  IO and asynchronous VFS events such as asynchronous open(). Tux uses a
  pool of kernel threads to pass blocking work to, while not holding up
  the 'main' thread. But the main Tux speedup comes from having a native
  state machine for all the networking IO. ]

	Ingo
