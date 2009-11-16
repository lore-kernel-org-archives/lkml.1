Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZKPSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZKPSD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZKPSD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:03:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZKPSD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:03:58 -0500
Date: Mon, 16 Nov 2009 10:02:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Stijn Devriendt <highguy@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] observe and act upon workload parallelism: PERF_TYPE_PARALLELISM
 (Was: [RFC][PATCH] sched_wait_block: wait for blocked threads)
In-Reply-To: <20091116083521.GC20672@elte.hu>
Message-ID: <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com> <20091116083521.GC20672@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Nov 2009, Ingo Molnar wrote:
> 
> Regarding the API and your patch, i think we can and should do something 
> different and more capable - while still keeping your basic idea:

Actually, I'd suggest exactly the reverse.

Yes, do something different, but _less_ capable, and much simpler: 
introduce the notion of "grouped thread scheduling", where a _group_ of 
threads gets scheduled as one thread.

Think of it like a classic user-level threading package, where one process 
implements multiple threads entirely in user space, and switches between 
them. Except we'd do the exact reverse: create multiple threads in the 
kernel, but only run _one_ of them at a time. So as far as the scheduler 
is concerned, it acts as just a single thread - except it's a single 
thread that has multiple instances associated with it.

And every time the "currently active" thread in that group runs out of CPU 
time - or any time it sleeps - we'd just go on to the next thread in the 
group.

There are potentially lots of cases where you want to use multiple threads 
not because you want multiple CPU's, but because you want to have "another 
thread ready" for when one thread sleeps on IO. Or you may use threads as 
a container - again, you may not need a lot of CPU, but you split your 
single load up into multiple execution contexts just because you had some 
independent things going on (think UI threads).

As far as I can tell, that is pretty much what Stijn Devriendt wanted: he 
may have lots of threads, but he effectively really just wants "one CPU" 
worth of processing.

It's also what we often want with AIO-like threads: it's not that we want 
CPU parallelism, and if the data is in caches, we'd like to run the IO 
thread immediately and not switch CPU's at all, and actually do it all 
synchronously. It's just that _if_ the AIO thread blocks, we'd like to 
resume the original thread that may have better things to do. 

No "observe CPU parallelism" or anything fancy at all. Just a "don't 
consider these X threads to be parallel" flag to clone (or a separate 
system call).

Imagine doing async system calls with the equivalent of

 - create such an "affine" thread in kernel space
 - run the IO in that affine thread - if it runs to completion without 
   blocking and in a timeslice, never schedule at all.

where these "affine" threads would be even more lightweight than regular 
threads, because they don't even act as real scheduling entities, they are 
grouped together with the original one.

			Linus
