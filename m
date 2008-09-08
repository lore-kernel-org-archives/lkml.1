Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYIHNRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYIHNRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYIHNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:17:24 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39902 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751719AbYIHNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:17:23 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 4/7] sched: favour lower logical cpu number for
	sched_mc balance
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 08 Sep 2008 18:50:18 +0530
Message-ID: <20080908132018.3221.58500.stgit@drishya.in.ibm.com>
In-Reply-To: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in case two groups have identical load, prefer to move load to lower
logical cpu number rather than the present logic of moving to higher logical
number.

find_busiest_group() tries to look for a group_leader that has spare capacity
to take more tasks and freeup an appropriate least loaded group.  Just in case
there is a tie and the load is equal, then the group with higher logical number
is favoured.  This conflicts with user space irqbalance daemon that will move
interrupts to lower logical number if the system utilisation is very low.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e535f98..569fc8d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3237,7 +3237,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
+		     first_cpu(group->cpumask) >
 		     first_cpu(group_min->cpumask))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
@@ -3253,7 +3253,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
+			     first_cpu(group->cpumask) <
 			      first_cpu(group_leader->cpumask))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;

