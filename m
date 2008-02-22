Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbYBVIAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbYBVIAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 03:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYBVIAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 03:00:32 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:40970 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbYBVIAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 03:00:31 -0500
Date: Fri, 22 Feb 2008 13:25:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Remove duplicate code from sched_fair.c
Message-ID: <20080222075553.GA3691@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peter@programming.kicks-ass.net>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield_task_fair has some duplicate code, that can be replaced with
rb_last(). This code reuses rb_next and removes the duplicate code.
As a side effect, we don't do an rb_entry for each node as we walk
along the path.

Comments, flames?

Description
-----------

pick_task_entity() duplicates existing code. This functionality can be easily
obtained using rb_last(). Avoid code duplication by using rb_last()

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched_fair.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/sched_fair.c~use-existing-code-in-sched-yield kernel/sched_fair.c
--- linux-2.6.25-rc2/kernel/sched_fair.c~use-existing-code-in-sched-yield	2008-02-22 11:35:35.000000000 +0530
+++ linux-2.6.25-rc2-balbir/kernel/sched_fair.c	2008-02-22 11:50:03.000000000 +0530
@@ -301,16 +301,13 @@ static struct sched_entity *__pick_next_
 
 static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct sched_entity *se = NULL;
-	struct rb_node *parent;
-
-	while (*link) {
-		parent = *link;
-		se = rb_entry(parent, struct sched_entity, run_node);
-		link = &parent->rb_right;
-	}
+	struct rb_node *last;
+	struct sched_entity *se;
 
+	last = rb_last(&cfs_rq->tasks_timeline);
+	if (!last)
+		return NULL;
+	se = rb_entry(last, struct sched_entity, run_node);
 	return se;
 }
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
