Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZKPSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZKPSTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZKPSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:19:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZKPSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:19:37 -0500
Date: Mon, 16 Nov 2009 10:18:59 -0800 (PST)
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
In-Reply-To: <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911161011130.9384@localhost.localdomain>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com> <20091116083521.GC20672@elte.hu> <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Nov 2009, Linus Torvalds wrote:
> 
> Think of it like a classic user-level threading package, where one process 
> implements multiple threads entirely in user space, and switches between 
> them. Except we'd do the exact reverse: create multiple threads in the 
> kernel, but only run _one_ of them at a time. So as far as the scheduler 
> is concerned, it acts as just a single thread - except it's a single 
> thread that has multiple instances associated with it.

Side note: before anybody asks why not do threads in user space to begin 
with, it's simple: IO, exceptions, and timers. All need kernel support. 

User-level threading works very well, and is usually efficient as hell. 
It's not that long since people constantly claimed that thread libraries 
in user space were much better, and tried to use complex NxM models to do 
them, exactly because user threads are so great.

But almost nobody does user-level threading now, except for specific 
languages that are built around threading. Why? It's not because they 
don't work, it's because they have a few very annoying problems that make 
them not work at all for enough situations that it gets very painful. And 
it's usually about IO and system calls, but sometimes it's about page 
faults, and sometimes it's about the pain of multiplexing that annoying 
timer signal and all the crap that involves.

So I'm suggesting that maybe we could look at doing kernel threads that do 
what user-level threading does. It sounds idiotic, and maybe it is - after 
all, traditionally one of the reasons for user-level threads is that you 
can avoid all the kernel overheads. But if we can make some really 
low-overhead "thread within a thread" model, maybe we could have close to 
the best of both worlds.

Some people really want threads for multi-CPU workloads and spreading 
things out. That's what we have now. But other loads want threads for 
entirely different reasons, like just hiding IO latencies.

			Linus
