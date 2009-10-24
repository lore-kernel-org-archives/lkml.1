Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZJXUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZJXUD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZJXUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:03:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:35610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZJXUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:03:26 -0400
Date: Sat, 24 Oct 2009 13:04:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sched: Add aggressive load balancing for certain
 situations
Message-ID: <20091024130432.0c46ef27@infradead.org>
In-Reply-To: <20091024125853.35143117@infradead.org>
References: <20091024125853.35143117@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Add aggressive load balancing for certain situations
From: Arjan van de Ven <arjan@linux.intel.com>

The scheduler, in it's "find idlest group" function currently has an unconditional
threshold for an imbalance, before it will consider moving a task.

However, there are situations where this is undesireable, and we want to opt in to a
more aggressive load balancing algorithm to minimize latencies.

This patch adds the infrastructure for this and also adds two cases for which
we select the aggressive approach
1) From interrupt context. Events that happen in irq context are very likely,
   as a heuristic, to show latency sensitive behavior
2) When doing a wake_up() and the scheduler domain we're investigating has the
   flag set that opts in to load balancing during wake_up()
   (for example the SMT/HT domain)


Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..fe9b95b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1246,7 +1246,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  */
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int load_idx)
+		  int this_cpu, int load_idx, int agressive)
 {
 	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
@@ -1290,7 +1290,9 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (!idlest || 100*this_load < imbalance*min_load)
+	if (!idlest)
+		return NULL;
+	if (!agressive &&  100*this_load < imbalance*min_load)
 		return NULL;
 	return idlest;
 }
@@ -1412,6 +1414,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
+		int agressive;
 
 		if (!(sd->flags & sd_flag)) {
 			sd = sd->child;
@@ -1421,7 +1424,13 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
 
-		group = find_idlest_group(sd, p, cpu, load_idx);
+		agressive = 0;
+		if (in_irq())
+			agressive = 1;
+		if (sd_flag & SD_BALANCE_WAKE)
+			agressive = 1;
+
+		group = find_idlest_group(sd, p, cpu, load_idx, agressive);
 		if (!group) {
 			sd = sd->child;
 			continue;



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
