Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYJHM7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYJHM7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYJHM7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:59:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34158 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYJHM7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:59:46 -0400
Subject: Re: Definition of sched_clock broken
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48D959E8.4000303@goop.org>
References: <48D959E8.4000303@goop.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 07:59:33 -0500
Message-Id: <1223470773.6336.13.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 14:04 -0700, Jeremy Fitzhardinge wrote:
> kernel/sched_clock.c has the comment:
> 
>  * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
>  * consistent between cpus (never more than 2 jiffies difference).
>
> The two jiffy restriction is way too restrictive.

I won't argue whether this is a good thing or a bad thing, but I did
find a problem in the current implementation.

> Historically sched_clock() is intended to measure the amount of
> schedulable time occurring on a CPU.  On a virtual cpu, that is affected
> by the amount of physical cpu time the hypervisor schedules for a vcpu,
> and can therefore advance in a very non-continuous way, depending on the
> overall load on the host system.  It is, however, the only timebase that
> gives the kernel a reasonable hope of determining how much cpu a process
> actually got scheduled.
> 
> The net result is that the sched_clock timebase is 1) monotonic, 2)
> loses arbitrary amounts of time against a system monotonic clock, 3)
> per-cpu, with 4) arbitrary drift between different cpu's sched_clocks.
> 
> Tying the sched_clocks of different cpus together in any way loses these
> properties, and just turns it into another system wide monotonic clock,
> which seems redundant given that we already have one (I understand that
> the relatively loose synchronization allows it to be implemented more
> efficiently than a normal monotonic clock).

Currently, I've found that it is quite easy to observe scd->clock, and
therefore rq->clock, running backwards, losing the monotonic quality.

This patch demonstrates the problem.  I've found it triggers often on my
laptop (Lenovo T60p) just doing everyday work.  I'll follow up with a
patch that fixes the problem.  I'll let Peter and Ingo judge if it is
the correct fix.

diff --git a/kernel/sched.c b/kernel/sched.c
index 7ea767a..b850937 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -638,7 +638,13 @@ static inline int cpu_of(struct rq *rq)
 
 static inline void update_rq_clock(struct rq *rq)
 {
-	rq->clock = sched_clock_cpu(cpu_of(rq));
+	u64 clock = sched_clock_cpu(cpu_of(rq));
+	if (clock < rq->clock) {
+		printk(KERN_ERR "TIME TURNED BACK!\n");
+		printk(KERN_ERR "new time = %llx rq->clock = %llx\n",
+				clock, rq->clock);
+	} else
+		rq->clock = clock;
 }
 
 /*


> At the moment the x86 sched_clock is hooked through paravirt_ops so that
> the underlying hypervisor can provide precise scheduled time
> information, with the hope that the scheduler will use it to make better
> decisions.  However if the scheduler needs to be lied to then I can do
> that too, but it's a pity to throw away information that's available to it.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

