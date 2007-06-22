Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbXFVEFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbXFVEFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXFVEEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:04:14 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:62028 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXFVEEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:04:13 -0400
Message-Id: <20070622040014.234651401@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 00:00:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 0/6] Convert all tasklets to workqueues
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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


This patch series does the following:

1) Changes the RCU tasklet into a softirq. The RCU tasklet *is* a 
performance critical function, and changing it to a softirq gives it
even more performance, and removes overhead. This has already been done
in the RT kernel, and should be applied regardless of the rest of the
patches in the series.

2) Splits out the tasklets from softirq.c.  This too should be done anyways.
Tasklets are not softirqs, and they have their own semantics that they
deserve their own file. Also it makes it a lot cleaner to replace them
with something else :-)

3/4) Add an API to the tasklets to allow a driver to see if a tasklet
is scheduled.  The DRM driver does it's own little thing with tasklets
and reads into the internals of the tasklet. These patches give the
DRM driver an API to do that a little bit cleaner.

The above patches really should go into the kernel if for any other
reason as a clean up patch set.

5) Move tasklet.h to tasklet_softirq.h and have tasklet.h include it.

6) This is the magic to make tasklets into work queues. It allows for
the kernel to be configured either with the normal tasklets, as it is
today, or with the tasklets-as-work-queues.

I've booted these patches on 5 machines, i386 and x86_64, and when
I can get my powerbook loaded with Linux, I'll try it there too.

I'd like to give thanks to Ingo Molnar and Oleg Nesterov for reviewing 
my initial patch series and giving me some pointers.


[1] www.wil.cx/matthew/lca2003/paper.pdf

-- Steve
