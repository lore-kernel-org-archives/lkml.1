Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYGMJlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYGMJlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYGMJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:41:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYGMJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:41:45 -0400
Date: Sun, 13 Jul 2008 11:41:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080713094116.GA23378@elte.hu>
References: <1215859526.5405.3.camel@earth> <1215861285.5405.6.camel@earth> <1215907829.8998.23.camel@earth> <19f34abd0807130150y581abe07j29765a9424cdb02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807130150y581abe07j29765a9424cdb02@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Sun, Jul 13, 2008 at 2:10 AM, Dmitry Adamushko
> <dmitry.adamushko@gmail.com> wrote:
> > Subject: fix cpuset_handle_cpuhp()
> >
> > The following commit
> >
> > ---
> > commit f18f982abf183e91f435990d337164c7a43d1e6d
> > Author: Max Krasnyansky <maxk@qualcomm.com>
> > Date:   Thu May 29 11:17:01 2008 -0700
> >
> > sched: CPU hotplug events must not destroy scheduler domains created by
> > the cpusets
> > ---
> >
> > [ Note, with this commit arch_update_cpu_topology is not called any more for CPUSETS. But it's just a nop.
> > The whole scheme should be probably reworked later. ]
> >
> >
> > introduced a hotplug-related problem as described below:
> >
> > [ Basically the fix below just emulates the 'old' behavior of update_sched_domains().
> > We call rebuild_sched_domains() for the same hotplug-events as it was called (and is still called
> > for !CPUSETS case) in update_sched_domains(). ]
> >
> >
> > Upon CPU_DOWN_PREPARE, update_sched_domains() -> detach_destroy_domains(&cpu_online_map)
> > does the following:
> >
> > /*
> >  * Force a reinitialization of the sched domains hierarchy. The domains
> >  * and groups cannot be updated in place without racing with the
> > balancing
> >  * code, so we temporarily attach all running cpus to the NULL domain
> >  * which will prevent rebalancing while the sched domains are
> > recalculated.
> >  */
> >
> > The sched-domains should be rebuilt when a CPU_DOWN ops. has been
> > completed, effectively either upon CPU_DEAD{_FROZEN} (upon success) or
> > CPU_DOWN_FAILED{_FROZEN} (upon failure -- restore the things to their
> > initial state). That's what update_sched_domains() also does but only
> > for !CPUSETS case.
> >
> > With Max's patch, sched-domains' reinitialization is delegated to
> > CPUSETS code:
> >
> > cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
> > rebuild_sched_domains()
> >
> > Being called for CPU_UP_PREPARE and if its callback is called after
> > update_sched_domains()), it just negates all the work done by
> > update_sched_domains() -- i.e. a soon-to-be-offline cpu is included in
> > the sched-domains and that makes it visible for the load-balancer
> > while the CPU_DOWN ops. is in progress.
> >
> > __migrate_live_tasks() moves the tasks off a 'dead' cpu (it's already
> > "offline" when this function is called).
> >
> > try_to_wake_up() is called for one of these tasks from another CPU ->
> > the load-balancer (wake_idle()) picks up a "dead" CPU and places the
> > task on it. Then e.g. BUG_ON(rq->nr_running) detects this a bit later
> > -> oops.
> >
> >
> > Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
> 
> Works :-)

thanks! I've tidied up the changelog and queued it up into 
tip/sched/urgent. I'd prefer this more conservative patch so late in the 
cycle, but i'll also queue up the more intrusive real fix from Linus and 
Dmitry in sched/devel.

Linus, if you've not applied it already, you can pull Dmitry's fix from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

shortlog, diffstat and diff below.

Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      cpusets, hotplug, scheduler: fix scheduler domain breakage


 kernel/cpuset.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..798b3ab 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1882,7 +1882,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
  * in order to minimize text size.
  */
 
-static void common_cpu_mem_hotplug_unplug(void)
+static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
 {
 	cgroup_lock();
 
@@ -1894,7 +1894,8 @@ static void common_cpu_mem_hotplug_unplug(void)
 	 * Scheduler destroys domains on hotplug events.
 	 * Rebuild them based on the current settings.
 	 */
-	rebuild_sched_domains();
+	if (rebuild_sd)
+		rebuild_sched_domains();
 
 	cgroup_unlock();
 }
@@ -1912,11 +1913,22 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
-	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+	switch (phase) {
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		common_cpu_mem_hotplug_unplug(1);
+		break;
+	default:
 		return NOTIFY_DONE;
+	}
 
-	common_cpu_mem_hotplug_unplug();
-	return 0;
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -1929,7 +1941,7 @@ static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 
 void cpuset_track_online_nodes(void)
 {
-	common_cpu_mem_hotplug_unplug();
+	common_cpu_mem_hotplug_unplug(0);
 }
 #endif
 
