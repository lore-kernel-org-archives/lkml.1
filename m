Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYKJS3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYKJS3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYKJS3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:29:36 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48580 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYKJS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:29:35 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 2/5] sched: favour lower logical cpu number for
	sched_mc balance
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
Date: Tue, 11 Nov 2008 00:03:16 +0530
Message-ID: <20081110183316.562.88128.stgit@drishya.in.ibm.com>
In-Reply-To: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
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
index 0dd6cf6..d910496 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3251,7 +3251,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
+		     first_cpu(group->cpumask) >
 		     first_cpu(group_min->cpumask))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
@@ -3267,7 +3267,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
+			     first_cpu(group->cpumask) <
 			      first_cpu(group_leader->cpumask))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;

