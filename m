Return-Path: <linux-kernel-owner+w=401wt.eu-S1763060AbXF0Tpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763060AbXF0Tpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762345AbXF0Tno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:44 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45114 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbXF0Tni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:38 -0400
Message-Id: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 0/8] Convert all tasklets to workqueues V3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

This is Version 3 of tasklets to work queues conversion.

Changes from this and version 2:

 - Removed DECLARE_TASKLET and DECLARE_TASKLET_DISABLED macros
   Instead make all instances use tasklet_init.
   (Recommended by Arnd Bergmann)

 - Converted the net wireless nlevent_tasket into a work queue
   (there was no good way to use tasklet_init, that I know of).

 - Removed fastcall from tasklet_enable (why was that needed?)

 - Removed tasklet_kill_immediate.
   (suggested by Oleg Nesterov)

 - Removed takeover_tasklet
    (also suggested by Oleg Nesterov)

 - Removed smp_mb from tasklet_disable since the
   flush_workqueue should provide us a barrier.

 - Converted most the functions to static inline.
   (Recommended by Arjan van de Ven)

 - Removed unused tasklet state flags.

 - Put in stub for tasklet_unlock since nothing should call it
   (the only user should be fixed in 2.6.22)

 - I didn't add cleanups to make the moving of code better for
   checkpatch.pl. But I did fix the spots it flagged for added
   code.

Prologue from Version 1, you may skip if you already read this.
Added at Andrew Morton's request.  Slightly modified from V1 to
accomodate changes.


There's a very nice paper by Matthew Willcox that describes Softirqs,
Tasklets, Bottom Halves, Task Queues, Work Queues and Timers[1].
In the paper it describes the history of these items.  Softirqs and
tasklets were created to replace bottom halves after a company (Mindcraft)
showed that Microsoft on a 4x SMP box would out do Linux. It was discovered
that this was due to a bottle neck caused by the design of Bottom Halves.
So Alexey Kuznetsov and Dave Miller [1] (and I'm sure others) created
softirqs and tasklets to multithread the bottom halves.

This worked well, and for the time it shut-up Microsoft^WMindcraft from
saying Linux was slow at networking.

Time passed, and Linux developed other nifty tools, like kthreads and
work queues. These run in a process context and are not as menacing to
latencies as softirqs and tasklets are.  Specifically, a tasklet,
acts as a task by only being able to run the function on one CPU
at a time. The same tasklet can not run on multiple CPUS.  So in that
aspect it is like a task (a task can only exist on one CPU at a time).
But a tasklet is much harder on the rest of the system because it
runs in interrupt context.  This means that if a higher priority process
wants to run, it must wait for the tasklet to finish before doing so.

The most part, tasklets today are not used for time critical functions.
Running tasklets in thread context is not harmful to performance of
the overall system. But running them in interrupt context is, since
they increase the overall latency for high priority tasks.

Even in Matthew's paper, he says that work queues have replaced tasklets.
But this is not truly the case.  Tasklets are common and plentiful.
But to go and replace each driver that uses a tasklet with a work queue
would be very painful.

I've developed this way to replace all tasklets with work queues without
having to change all the drivers that use them.  I created an API that
uses the tasklet API as a wrapper to a work queue.  This API doesn't need
to be permanent. It shows 1) that work queues can replace tasklets, and
2) we can remove a duplicate functionality from the kernel.  This API
only needs to be around until we removed all uses of tasklets from
all drivers.

I just want to state that tasklets served their time well. But it's time
to give them an honorable discharge.  So lets get rid of tasklets and
given them a standing salute as they leave :-)

I've booted these patches on 6 machines, i386, x86_64, and my
PowerPC Powerbook.

I'd like to give thanks to Ingo Molnar and Oleg Nesterov for reviewing 
my initial patch series and giving me some pointers.

Also thanks go to (random order) Arjan van de Ven, Arnd Bergmann,
Christoph Hellwig, Linus Torvalds, Andrew Morton, Thomas Gleixner,
Daniel Walker, and others that have read the patches and offered
advice and criticism.


[1] www.wil.cx/matthew/lca2003/paper.pdf
