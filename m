Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZBBX6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZBBX6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZBBX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:57:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:9854 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZBBX56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:57:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,368,1231142400"; 
   d="scan'208";a="106331797"
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <200902021323.44015.borntraeger@de.ibm.com>
References: <200901301729.30284.borntraeger@de.ibm.com>
	 <200902021058.45230.borntraeger@de.ibm.com>
	 <200902021323.44015.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 02 Feb 2009 15:57:03 -0800
Message-Id: <1233619023.16238.12.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 04:23 -0800, Christian Borntraeger wrote:
> After some testing, I think this patch is better:
> [PATCH] NOHZ: fix nohz on cpu unplug
> 
> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> After using cpu unplug I have seen one cpu with full ticks, even
> on a idle systems. It turns out that nohz.cpu_mask is not updated on
> cpu unplug. 
> In select_nohz_load_balancer we check if the system is completely
> idle to turn of load balancing. We compare cpu_online_map with
> nohz.cpu_mask.
> Since cpu_online_map is updated on cpu unplug, but nohz.cpu_mask is
> not, the check fails and the scheduler believes that we need an 
> "idle load balancer" even on a fully idle system. Since the ilb 
> cpu does not deactivate the timer tick this breaks NOHZ.
> 
> This patch clear the nohz bits in the migration_call, a function that
> is already called by the cpu hotplug notifier.
> 
> Opinions?

Hi,

select_nohz_load_balancer() already takes care of one cpu offline
scenario. It missed one more scenario leading to the issue you
explained. We should take care of this in select_nohz_load_balancer().

Does this patch fix the issue? Thanks.

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 96439a4..8a0419b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4026,19 +4026,24 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
-		/*
-		 * If we are going offline and still the leader, give up!
-		 */
-		if (!cpu_active(cpu) &&
-		    atomic_read(&nohz.load_balancer) == cpu) {
+		if (!cpu_active(cpu) {
+			if (atomic_read(&nohz.load_balancer) != cpu)
+				return 0;
+
+			/*
+			 * If we are going offline and still the leader,
+			 * give up!
+			 */
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
+
 			return 0;
 		}
 
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
+
 		/* time for ilb owner also to sleep */
 		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)


