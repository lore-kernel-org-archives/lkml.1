Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZKPTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZKPTtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKPTtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:49:19 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48504 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKPTtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UJC1+mn+U/FHdIbEbfETdBetqK1gWzcYu4DFjZcOJLNrVzX+9r25JS771HGLRs5Rrn
         Iz/aks9AKzOaG9uGBe0mvQaU2urn3x1llRnMm54ZEjfKgZj0tWOg/8fmVCsJQNFzHl0S
         kHpncaObIq0MmLYYeIzNUtt07lbmjMiUwEEGc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
	 <20091116083521.GC20672@elte.hu>
	 <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
Date: Mon, 16 Nov 2009 20:49:23 +0100
Message-ID: <c76f371a0911161149p5416c992o64e926890b8b32c0@mail.gmail.com>
Subject: Re: [RFC] observe and act upon workload parallelism: 
	PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked 
	threads)
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Think of it like a classic user-level threading package, where one process
> implements multiple threads entirely in user space, and switches between
> them. Except we'd do the exact reverse: create multiple threads in the
> kernel, but only run _one_ of them at a time. So as far as the scheduler
> is concerned, it acts as just a single thread - except it's a single
> thread that has multiple instances associated with it.
>
> And every time the "currently active" thread in that group runs out of CPU
> time - or any time it sleeps - we'd just go on to the next thread in the
> group.

It almost makes me think of, excuse me, fibers ;)
One of the problems with the original approach is that the waiting threads
are woken even if the CPU load is high enough to keep the CPU going.
I had been thinking of inheriting the timeslice for the woken thread, but
this approach does way more than that. I also suspect the original approach
of introducing unfairness.

> No "observe CPU parallelism" or anything fancy at all. Just a "don't
> consider these X threads to be parallel" flag to clone (or a separate
> system call).

I wouldn't rule it out completely as in a sense, it's comparable to a JVM
monitoring performance counters to see if it needs to run the JIT optimizer.

> Imagine doing async system calls with the equivalent of
>
>  - create such an "affine" thread in kernel space
>  - run the IO in that affine thread - if it runs to completion without
>   blocking and in a timeslice, never schedule at all.
>
> where these "affine" threads would be even more lightweight than regular
> threads, because they don't even act as real scheduling entities, they are
> grouped together with the original one.
>
>                        Linus
>

One extra catch, I didn't even think of in the original approach is
that you still need a way of saying to the kernel: no more work here.

My original approach fails bluntly and I will happily take credit for that ;)
The perf-approach perfectly allows for this, by waking up the "controller"
thread which does exactly nothing as there's no work left.
The grouped thread approach can end up with all threads blocked to
indicate no more work, but I wonder how the lightweight threads will
end up being scheduled; When a threadpool-thread runs, you'll want
to try and run as much work as possible. This would mean that when
one thread blocks and another takes over, the latter will want to run
to completion (empty thread pool queue) starving the blocked thread.

Unless sched_yield is (ab?)used by these extra-threads to let the
scheduler consider the blocked thread again? With the risk that
the scheduler will schedule to the next extra-thread of the same group.

Basically, you're right about what I envisioned: threadpools are meant
to always have some extra work handy, so why not continue work when
one work item is blocked.

Stijn
