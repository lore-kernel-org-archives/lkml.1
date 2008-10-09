Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbYJIMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbYJIMFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYJIMFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:05:07 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56480 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYJIMFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:05:05 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2008 17:39:14 +0530
Message-ID: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been building tunable sched_mc=N patches on top of existing
sched_mc_power_savings code and adding more stuff to
find_busiest_group().

Reference:

[1]Making power policy just work
http://lwn.net/Articles/287924/ 

[2][RFC v1] Tunable sched_mc_power_savings=n
http://lwn.net/Articles/287882/

[3][RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
http://lwn.net/Articles/297306/

Peter Zijlstra had suggested that it is a good idea to cleanup the
current code in find_busiest_group() before building on the existing
power saving balance infrastructure [4]. This becomes even more
important from the fact that there have been recent bugs in the power
savings code that was hard to detect and fix [5][6].

[4] http://lkml.org/lkml/2008/9/8/103

Reference to bugs:

[5] sched: Fix __load_balance_iterator() for cfq with only one task
http://lkml.org/lkml/2008/9/5/135

[6]sched: arch_reinit_sched_domains() must destroy domains to force rebuild
http://lkml.org/lkml/2008/8/29/191
http://lkml.org/lkml/2008/8/29/343

In an attempt to modularize the find_busiest_group() function and make
it extensible to more complex load balance decision, I have defined
new data structures and functions and make the find_busiest_group()
function small and readable.

** This is RFC patch, with limited testing ***

ChangeLog:
---------

v2: Fixed most coding errors, able to run kernbench on 32-bit intel
    SMP system. Fixed errors in comments.

v1: Initial post http://lkml.org/lkml/2008/9/24/201

Please let me know if the approach is correct. I will test further and
ensure expected functional.

Thanks,
Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

After applying the patch series, the function will look like this:

/*
 * find_busiest_group finds and returns the busiest CPU group within the
 * domain. It calculates and returns the amount of weighted load which
 * should be moved to restore balance via the imbalance parameter.
 */
static struct sched_group *
find_busiest_group(struct sched_domain *sd, int this_cpu,
		   unsigned long *imbalance, enum cpu_idle_type idle,
		   int *sd_idle, const cpumask_t *cpus, int *balance)
{
	struct sched_group *group = sd->groups;
	unsigned long max_pull;
	int load_idx;
	struct group_loads gl;
	struct sd_loads sdl;

	memset(&sdl, 0, sizeof(sdl));
	sdl.sd = sd;

	/* Get the load index corresponding to cpu idle state */
	load_idx = get_load_idx(sd, idle);

	do {
		int need_balance;

		need_balance = get_group_loads(group, this_cpu, cpus, idle,
					       load_idx, &gl);

		if (*sd_idle && gl.nr_running)
			*sd_idle = 0;

		if (!need_balance && balance) {
			*balance = 0;
			*imbalance = 0;
			return NULL;
		}

		/* Compare groups and find busiest non-local group */
		update_sd_loads(&sdl, &gl);
		/* Compare groups and find power saving candidates */
		update_powersavings_group_loads(&sdl, &gl, idle);

		group = group->next;
	} while (group != sd->groups);

	if (!sdl.busiest.group ||
	     sdl.local.load_per_cpu >= sdl.max_load ||
	     sdl.busiest.nr_running == 0)
		goto out_balanced;

	sdl.load_per_cpu = (SCHED_LOAD_SCALE * sdl.load) / sdl.cpu_power;

	if (sdl.local.load_per_cpu >= sdl.load_per_cpu ||
			100*sdl.busiest.load_per_cpu <=
			sd->imbalance_pct*sdl.local.load_per_cpu)
		goto out_balanced;

	if (sdl.busiest.group_imbalance)
		sdl.busiest.avg_load_per_task =
			min(sdl.busiest.avg_load_per_task, sdl.load_per_cpu);

	/*
	 * We're trying to get all the cpus to the average_load, so we don't
	 * want to push ourselves above the average load, nor do we wish to
	 * reduce the max loaded cpu below the average load, as either of these
	 * actions would just result in more rebalancing later, and ping-pong
	 * tasks around. Thus we look for the minimum possible imbalance.
	 * Negative imbalances (*we* are more loaded than anyone else) will
	 * be counted as no imbalance for these purposes -- we can't fix that
	 * by pulling tasks to us. Be careful of negative numbers as they'll
	 * appear as very large values with unsigned longs.
	 */
	if (sdl.busiest.load_per_cpu <= sdl.busiest.avg_load_per_task)
		goto out_balanced;

	/*
	 * In the presence of smp nice balancing, certain scenarios can have
	 * max load less than avg load(as we skip the groups at or below
	 * its cpu_power, while calculating max_load..)
	 * In this condition attempt to adjust the imbalance parameter
	 * in the small_imbalance functions.
	 *
	 * Now if max_load is more than avg load, balancing is needed,
	 * find the exact number of tasks to be moved.
	 */
	if (sdl.busiest.load_per_cpu >= sdl.load_per_cpu) {

		/* Don't want to pull so many tasks that
		 * a group would go idle
		 */
		max_pull = min(sdl.busiest.load_per_cpu - sdl.load_per_cpu,
				sdl.busiest.load_per_cpu -
				sdl.busiest.avg_load_per_task);

		/* How much load to actually move to equalise the imbalance */
		*imbalance = min(max_pull * sdl.busiest.group->__cpu_power,
				(sdl.load_per_cpu - sdl.local.load_per_cpu) *
				 sdl.local.group->__cpu_power) /
				 SCHED_LOAD_SCALE;

		/* If we have adjusted the required imbalance, then return */
		if (*imbalance >= sdl.busiest.avg_load_per_task)
			return sdl.busiest.group;

	}

	/*
	 * if *imbalance is less than the average load per runnable task
	 * there is no guarantee that any tasks will be moved so we'll have
	 * a think about bumping its value to force at least one task to be
	 * moved
	 */
	*imbalance = 0;  /* Will be adjusted below */

	if (small_imbalance_one_task(&sdl, imbalance))
		return sdl.busiest.group;

	/* Further look for effective cpu power utilisation */
	small_imbalance_optimize_cpu_power(&sdl, imbalance);

	/*
	 * Unconditional return, we have tries all possible means to adjust
	 * the imbalance for effective task move
	 */
	return sdl.busiest.group;

out_balanced:
	/* Try opportunity for power save balance */
	return powersavings_balance_group(&sdl, &gl, idle, imbalance);
}

---

Vaidyanathan Srinivasan (5):
      sched: split find_busiest_group()
      sched: small imbalance corrections
      sched: collect statistics required for powersave balance
      sched: calculate statistics for current load balance domain
      sched: load calculation for each group in sched domain


 kernel/sched.c |  627 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 384 insertions(+), 243 deletions(-)

-- 
