Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIYEYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIYEYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYIYEYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:24:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53193 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYIYEYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:24:09 -0400
Date: Thu, 25 Sep 2008 09:53:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: sched: Maintain only task entities in cfs_rq->tasks list.
Message-ID: <20080925042354.GB3663@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080925042108.GA3663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925042108.GA3663@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed the subject line in the last post :(

[repost]

sched: Maintain only task entities in cfs_rq->tasks list.

cfs_rq->tasks list is used by the load balancer to iterate
over all the tasks. Currently it holds all the entities
(both task and group entities) because of which there is
a need to check for group entities explicitly during load
balancing. This patch changes the cfs_rq->tasks list to
hold only task entities.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -586,11 +586,12 @@ account_entity_enqueue(struct cfs_rq *cf
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
+		list_add(&se->group_node, &cfs_rq->tasks);
+	}
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
-	list_add(&se->group_node, &cfs_rq->tasks);
 }
 
 static void
@@ -599,11 +600,12 @@ account_entity_dequeue(struct cfs_rq *cf
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, -se->load.weight);
+		list_del_init(&se->group_node);
+	}
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
-	list_del_init(&se->group_node);
 }
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1445,19 +1447,9 @@ __load_balance_iterator(struct cfs_rq *c
 	if (next == &cfs_rq->tasks)
 		return NULL;
 
-	/* Skip over entities that are not tasks */
-	do {
-		se = list_entry(next, struct sched_entity, group_node);
-		next = next->next;
-	} while (next != &cfs_rq->tasks && !entity_is_task(se));
-
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	cfs_rq->balance_iterator = next;
-
-	if (entity_is_task(se))
-		p = task_of(se);
+	se = list_entry(next, struct sched_entity, group_node);
+	p = task_of(se);
+	cfs_rq->balance_iterator = next->next;
 
 	return p;
 }
