Return-Path: <linux-kernel-owner+w=401wt.eu-S1765009AbXIMTJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765009AbXIMTJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXIMTJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:09:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXIMTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:09:16 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
In-Reply-To: <D1C6ACC2-FD90-4813-84C9-A23531684B86@mac.com>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709120242040.1817@scrub.home>
	 <20070913075258.GA9173@elte.hu>
	 <Pine.LNX.4.64.0709131419170.1817@scrub.home>
	 <20070913142842.GA26016@elte.hu>
	 <Pine.LNX.4.64.0709131706100.1817@scrub.home>
	 <D1C6ACC2-FD90-4813-84C9-A23531684B86@mac.com>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 21:08:50 +0200
Message-Id: <1189710530.5643.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 14:28 -0400, Kyle Moffett wrote:

>  with the exception of one patch that's missing a changelog entry.

Ah, that would have been one of mine.

---
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Handle vruntime overflow by centering the key space around min_vruntime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
     kernel/sched_fair.c |   15 +++++++++++----
     1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a306f05..b8e2a0d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -116,11 +116,18 @@ set_leftmost(struct cfs_rq *cfs_rq, struct rb_node *leftmost)
 	cfs_rq->rb_leftmost = leftmost;
 	if (leftmost) {
 		se = rb_entry(leftmost, struct sched_entity, run_node);
-		cfs_rq->min_vruntime = max(se->vruntime,
-						cfs_rq->min_vruntime);
+		if ((se->vruntime > cfs_rq->min_vruntime) ||
+		    (cfs_rq->min_vruntime > (1ULL << 61) &&
+		     se->vruntime < (1ULL << 50)))
+			cfs_rq->min_vruntime = se->vruntime;
 	}
 }
 
+s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	return se->fair_key - cfs_rq->min_vruntime;
+}
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -130,7 +137,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = se->fair_key;
+	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
 	/*
@@ -143,7 +150,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key - entry->fair_key < 0) {
+		if (key < entity_key(cfs_rq, entry)) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;


