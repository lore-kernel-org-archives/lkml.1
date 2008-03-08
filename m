Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYCHFkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYCHFkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 00:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYCHFkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 00:40:42 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49323
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751796AbYCHFkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 00:40:41 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] adjust root-domain->online span in response to hotplug event
To: suresh.b.siddha@intel.com
Cc: rjw@sisk.pl, akpm@linux-foundation.org, dmitry.adamushko@gmail.com,
       ego@in.ibm.com, mingo@elte.hu, oleg@sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ghaskins@novell.com
Date: Sat, 08 Mar 2008 00:10:15 -0500
Message-ID: <20080308050627.4831.87630.stgit@novell1.haskins.net>
In-Reply-To: <20080308015045.GB15909@linux-os.sc.intel.com>
References: <20080308015045.GB15909@linux-os.sc.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
 > On Sat, Mar 08, 2008 at 12:43:15AM +0100, Rafael J. Wysocki wrote:
 >> On Saturday, 8 of March 2008, Andrew Morton wrote:
 >>> On Fri, 7 Mar 2008 15:01:26 -0800
 >>> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
 >>>
 >>>> Andrew, Please check if the appended patch fixes your power-off 
problem aswell.
 >>>> ...
 >>>>
 >>>> --- a/kernel/sched.c
 >>>> +++ b/kernel/sched.c
 >>>> @@ -5882,6 +5882,7 @@ migration_call(struct notifier_block *nfb, 
unsigned long action, void *hcpu)
 >>>>  		break;
 >>>>
 >>>>  	case CPU_DOWN_PREPARE:
 >>>> +	case CPU_DOWN_PREPARE_FROZEN:
 >>>>  		/* Update our root-domain */
 >>>>  		rq = cpu_rq(cpu);
 >>>>  		spin_lock_irqsave(&rq->lock, flags);
 >>> No, it does not.
 >> Well, this is a bug nevertheless.
 >>
 >
 > Well, my previous root cause needs some small changes.
 >
 > During the notifier call chain for CPU_DOWN(till 'update_sched_domains'
 > is called atleast), all the cpu's are attached to 'def_root_domain', 
for whom
 > online mask still has the offline cpu.
 >
 > This is because, during CPU_DOWN_PREPARE, migration_call() first clears
 > the root_domain->online, and later during the DOWN_PREPARE call chain
 > detach_destroy_domains() attach to def_root_domain with 
cpu_online_map(which
 > still has the just about to die 'cpu' set).
 >
 > So essentially, during the notifier call chain of CPU_DOWN (before
 > 'update_sched_domains' is called atleast), any one doing RT process
 > wakeup's (for example: kthread_stop()) can still end up on the dead cpu.
 >
 > Andrew, Can you please try one more patch(appended) to see if it helps?
 >
 > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
 > ---
 >
 > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
 > index 0a6d2e5..8cb707c 100644
 > --- a/kernel/sched_rt.c
 > +++ b/kernel/sched_rt.c
 > @@ -597,7 +597,7 @@ static int find_lowest_cpus(struct task_struct 
*task, cpumask_t *lowest_mask)
 >  	int       count       = 0;
 >  	int       cpu;
 >
 > -	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
 > +	cpus_and(*lowest_mask, task->cpus_allowed, cpu_online_map);
 >
 >  	/*

Hi Suresh,
   Unfortunately, this patch will introduce its own set of bugs. 
However, your analysis was spot-on.  I think I see the problem now.  It 
was introduced when I put a hack in to "fix" s2ram problems in -mm as a 
result of the new root-domain logic.  I think the following patch will 
fix both issues:

(I verified that I could take a cpu offline/online, but I don't have an
s2ram compatible machine handy.  Andrew, I believe you could reproduce
the s2ram problem a few months ago when that issue popped up.  So if you
could, please verify that s2ram also works with this patch applied, in
addition to the hotplug problem.

Regards,
-Greg

-------------------------------------------------

adjust root-domain->online span in response to hotplug event

We currently set the root-domain online span automatically when the domain
is added to the cpu if the cpu is already a member of cpu_online_map.
This was done as a hack/bug-fix for s2ram, but it also causes a problem
with hotplug CPU_DOWN transitioning.  The right way to fix the original
problem is to actually respond to CPU_UP events, instead of CPU_ONLINE,
which is already too late.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 52b9867..b02e4fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5813,6 +5813,13 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
+
+		/* Update our root-domain */
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+
 		task_rq_unlock(rq, &flags);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
@@ -5821,15 +5828,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
-
-		/* Update our root-domain */
-		rq = cpu_rq(cpu);
-		spin_lock_irqsave(&rq->lock, flags);
-		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
-		}
-		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -6105,8 +6103,6 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpu_set(rq->cpu, rd->span);
-	if (cpu_isset(rq->cpu, cpu_online_map))
-		cpu_set(rq->cpu, rd->online);
 
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)

