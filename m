Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYGLUMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYGLUMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGLUL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:11:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYGLUL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:11:58 -0400
Date: Sat, 12 Jul 2008 13:10:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Dmitry Adamushko wrote:
> 
> With Max's patch, sched-domains' reinitialization is delegated to CPUSETS code:
> 
> cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
> rebuild_sched_domains()
> 
> which as you've said "called pretty randomly anyway", e.g. for CPU_UP_PREPARE.
> 
> [ ah, then rebuild_sched_domains() should not be there. It should be
> nop for MEMPLUG events I presume - should make another patch. ]

That whole notion of doing the same thing for UP/DOWN/SIDEWAYS looks 
pretty damn odd to me, but whatever.

> Being called for CPU_UP_PREPARE (and if its callback is called after
> update_sched_domains()), it just negates all the work done by
> update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
> the sched-domains and that makes it visible for the load-balancer
> while the CPU_DOWN ops. is in progress.

This sounds like it could trigger various other problems too, but happily 
hit the BUG_ON() first.

> __migrate_live_tasks() moves the tasks off a 'dead' cpu (it's already
> "offline" when this function is called).
> 
> try_to_wake_up() is called for one of these tasks from another CPU ->
> the load-balancer (wake_idle()) picks up a "dead" CPU and places the
> task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later
> -> oops.

Grr. 

Ok, can you re-send the (fixed-up) patch with the explanation and the 
tested-by: from Vegard. It seems that not calling rebuild_sched_domains() 
(by not calling common_cpu_mem_hotplug_unplug()) for CPU_UP_PREPARE was 
the minimal fix.

IOW, the "switch()" statement was just another way of adding 
CPU_UP_PREPARE to the list of things that we don't do anything for, and 
your patch was really just equivalent to the following patch?

Anyway, I'd just like a patch that (a) has been tested and (b) comes with 
a nice subject line and targeted explanation of this issue, so I can 
commit it for 2.6.26.

The patch below is not meant for beign used, it's just to verify that I am 
on the same page with you explanation.

		Linus

---
 kernel/cpuset.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..24f34ce 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1912,7 +1912,8 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
-	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN ||
+	    phase == CPU_UP_PREPARE || phase == CPU_UP_PREPARE_FROZEN)
 		return NOTIFY_DONE;
 
 	common_cpu_mem_hotplug_unplug();
