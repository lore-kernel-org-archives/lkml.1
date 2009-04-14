Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZDNEz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZDNEz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZDNEzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:55:41 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56976 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZDNEzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:55:40 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 2 2/2] sched: Nominate a power-efficient ilb in
	select_nohz_balancer()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 14 Apr 2009 10:25:35 +0530
Message-ID: <20090414045535.7645.31641.stgit@sofia.in.ibm.com>
In-Reply-To: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
References: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
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
index d702be7..bbf367d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4402,8 +4402,24 @@ int select_nohz_load_balancer(int stop_tick)
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

