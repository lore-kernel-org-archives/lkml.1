Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbZDBMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbZDBMi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbZDBMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:38:41 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:42258 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZDBMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:38:40 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v2 2/2] sched: Nominate a power-efficient ilb in
	select_nohz_balancer()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Thu, 02 Apr 2009 18:08:34 +0530
Message-ID: <20090402123834.14569.35435.stgit@sofia.in.ibm.com>
In-Reply-To: <20090402123607.14569.33649.stgit@sofia.in.ibm.com>
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU that first goes idle becomes the idle-load-balancer and remains
that until either it picks up a task or till all the CPUs of the system
goes idle.

Optimize this further to allow it to relinquish it's post
once all it's siblings in the power-aware sched_domain go idle, thereby
allowing the whole package-core to go idle. While relinquising the post,
nominate another an idle-load balancer from a semi-idle core/package.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4fc1ec0..c249473 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4439,8 +4439,24 @@ int select_nohz_load_balancer(int stop_tick)
 			/* make me the ilb owner */
 			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
 				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu)
+		} else if (atomic_read(&nohz.load_balancer) == cpu) {
+			int new_ilb;
+
+			if (!(sched_smt_power_savings ||
+						sched_mc_power_savings))
+				return 1;
+			/*
+			 * Check to see if there is a more power-efficient
+			 * ilb.
+			 */
+			new_ilb = find_new_ilb(cpu);
+			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
+				atomic_set(&nohz.load_balancer, -1);
+				resched_cpu(new_ilb);
+				return 0;
+			}
 			return 1;
+		}
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;

