Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZIRTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZIRTvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZIRTvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:51:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47850 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZIRTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:51:36 -0400
X-SpamScore: 10
X-BigFish: VPS10(z5c5ozzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ6N5O-02-BNT-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Prevent immediate process rescheduling
Date: Fri, 18 Sep 2009 14:49:12 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200909181449.12311.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 18 Sep 2009 19:51:28.0549 (UTC) FILETIME=[698D2550:01CA3899]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent the scheduler from immediately rescheduling a process
that just yielded if there is another process available.

Originally suggested by Mike Galbraith (efault@gmx.de).

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 kernel/sched_fair.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 652e8bd..4fad08f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -353,11 +353,25 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
+	struct sched_entity *se, *curr;
 
 	if (!left)
 		return NULL;
 
-	return rb_entry(left, struct sched_entity, run_node);
+	se = rb_entry(left, struct sched_entity, run_node);
+	curr = &current->se;
+
+	/* 
+	 * Don't select the entity who just tried to schedule away
+	 * if there's another entity available.
+	 */
+	if (unlikely(se == curr && cfs_rq->nr_running > 1)) {
+		struct rb_node *next_node = rb_next(&curr->run_node);
+		if (next_node)
+			se = rb_entry(next_node, struct sched_entity, run_node);
+	}
+
+	return se;
 }
 
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
-- 
1.6.0.2

