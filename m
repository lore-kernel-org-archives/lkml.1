Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYD0MWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYD0MWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYD0MWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:22:15 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42247 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYD0MWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:22:14 -0400
Date: Sun, 27 Apr 2008 14:22:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: get_online_cpus() && workqueues
Message-ID: <20080427122209.GB6754@osiris.boeblingen.de.ibm.com>
References: <20080422123304.GA777@osiris.boeblingen.de.ibm.com> <1208868236.7115.249.camel@twins> <20080423035802.GA8895@in.ibm.com> <20080424150714.GA8273@osiris.boeblingen.de.ibm.com> <1209052984.7115.369.camel@twins> <20080424155946.GA11160@tv-sign.ru> <20080424194810.GA4821@osiris.boeblingen.de.ibm.com> <20080424192706.GA165@tv-sign.ru> <20080425064044.GA10817@osiris.boeblingen.de.ibm.com> <20080426144330.GA6150@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426144330.GA6150@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 06:43:30PM +0400, Oleg Nesterov wrote:
> Gautham, Srivatsa, seriously, can't we uglify cpu.c a little bit to solve
> the problem. Please see the illustration patch below. It looks complicated,
> but in fact it is quite trivial.
> 
> In short: work_struct can't use get_online_cpus() due to deadlock with the
> CPU_DEAD phase.
> 
> Can't we add another nested lock which is dropped right after __cpu_die()?
> (in fact I think it could be dropped after __stop_machine_run).
> 
> The new read-lock is get_online_map() (just a random name for now). The only
> difference wrt get_online_cpus() is that it doesn't protect against CPU_DEAD,
> but most users of get_online_cpus() doesn't need this, they only need a
> stable cpu_online_map and sometimes they need to be sure that some per-cpu
> object (say, cpu_workqueue_struct->thread) can't be destroyed under this
> lock.
> 
> get_online_map() seem to fit for this, and can be used from work->func().
> (actually, I think most users of use get_online_cpus() could use the new
> helper instead, but this doen't matter).
> 
> Heiko, what do you think? Is it suitable for arch_reinit_sched_domains()?

Uhm, no. For arch_reinit_sched_domains that would allow for concurrent
callers for arch_init_sched_domains since sched.c calls that function in
quite a lot of the CPU_* phases (including CPU_DEAD) in update_sched_domains.
Not sure why it does that however.

But on the other hand there can be already concurrent callers via
sched_power_savings_store().

And with s390 calling arch_reinit_sched_domais() from outside there can be
yet another concurrent caller. Looks like the locking is broken anyway.
Sigh.

Looks like we need a new lock in arch_reinit_sched_domains() to prevent
concurrent callers to arch_init_sched_domains().
The calls from update_sched_domains() are implicitly prevented by the
cpu hotplug lock _and_ the fact that arch_reinit_sched_domains does
the get/put_online_cpus thing.

So conclusion is: the new get_online_map() wouldn't solve the deadlock
here, but we have a bug anyway :) Will see, if I can come up with a
tested patch tomorrow.

For the "don't call get_online_cpus() from within a work_struct" I have
the patch below. Even though I think it sucks. But at least it should
work.

 arch/s390/kernel/topology.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/topology.c linux-2.6-patched/arch/s390/kernel/topology.c
--- linux-2.6/arch/s390/kernel/topology.c	2008-04-25 14:16:25.000000000 +0200
+++ linux-2.6-patched/arch/s390/kernel/topology.c	2008-04-25 14:16:25.000000000 +0200
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/bootmem.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
@@ -229,9 +230,20 @@ void arch_update_cpu_topology(void)
 	}
 }
 
-static void topology_work_fn(struct work_struct *work)
+static int topology_kthread(void *data)
 {
 	arch_reinit_sched_domains();
+	return 0;
+}
+
+static void topology_work_fn(struct work_struct *work)
+{
+	/* We can't call arch_reinit_sched_domains() from a multi-threaded
+	 * workqueue context since it may deadlock in case of cpu hotplug.
+	 * So we have to create a kernel thread in order to call
+	 * arch_reinit_sched_domains().
+	 */
+	kthread_run(topology_kthread, NULL, "topology_update");
 }
 
 void topology_schedule_update(void)
