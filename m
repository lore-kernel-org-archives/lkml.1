Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYIHNOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYIHNOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYIHNOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:14:47 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:37390 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751504AbYIHNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:14:47 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 2/7] sched: Fix __load_balance_iterator() for cfq with
	only one task.
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
Date: Mon, 08 Sep 2008 18:47:40 +0530
Message-ID: <20080908131740.3221.99223.stgit@drishya.in.ibm.com>
In-Reply-To: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

The __load_balance_iterator() returns a NULL when there's only one
sched_entity which is a task. It is caused by the following code-path.


	/* Skip over entities that are not tasks */
	do {
		se = list_entry(next, struct sched_entity, group_node);
		next = next->next;
	} while (next != &cfs_rq->tasks && !entity_is_task(se));

	if (next == &cfs_rq->tasks)
		return NULL;
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      This will return NULL even when se is a task.

As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
since iter_move_one_task() when it calls load_balance_start_fair(),
would not get any tasks to move!

Fix this by checking if the last entity was a task or not.

Reference:
http://lkml.org/lkml/2008/9/5/135

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..f1c96e3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1451,7 +1451,7 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 		next = next->next;
 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
+	if (next == &cfs_rq->tasks && !entity_is_task(se))
 		return NULL;
 
 	cfs_rq->balance_iterator = next;

