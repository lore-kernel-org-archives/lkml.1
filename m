Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZDVQh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZDVQh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZDVQhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:37:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46218 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZDVQhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:37:08 -0400
Date: Wed, 22 Apr 2009 18:37:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090422163705.GW4593@kernel.dk>
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422163032.GV4593@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Jens Axboe wrote:
> On Wed, Apr 22 2009, Steve Wise wrote:
> >
> >>>
> >>> No there are a few patches applied that are heading upstream, but one 
> >>> is in the NFS RDMA server which isn't loaded yet and the rest are in  
> >>> iw_cxgb3 (iwarp driver) which also hasn't loaded at the time we  
> >>> crash. NOTE:  Out of 4 power cycles, one booted up ok, 3 hit the 
> >>> crash.
> >>>
> >>>
> >>>
> >>
> >> By the way, this one looks different from the last one I saw.  So its  
> >> not consistently crashing in the same spot.  The one I hit yesterday  
> >> (which I don't have the OOPs dump for was in rb_erase().
> >>
> >> Steve.
> >
> > I'll start bisecting to isolate this.
> 
> Don't bother, I see what the bug is now. It's caused by commit
> a36e71f996e25d6213f57951f7ae1874086ec57e and it's due to ->ioprio being
> changed without the prio rb root being adjusted.
> 
> I'll provide a fix shortly.

Quick'n dirty, I think this should fix the issue.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7e13f04..79ebb4c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -594,7 +594,7 @@ cfq_prio_tree_lookup(struct cfq_data *cfqd, int ioprio, sector_t sector,
 
 static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	struct rb_root *root = &cfqd->prio_trees[cfqq->ioprio];
+	struct rb_root *root = &cfqd->prio_trees[cfqq->org_ioprio];
 	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
 
@@ -606,8 +606,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (!cfqq->next_rq)
 		return;
 
-	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->ioprio, cfqq->next_rq->sector,
-					 &parent, &p);
+	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->org_ioprio,
+					cfqq->next_rq->sector, &parent, &p);
 	BUG_ON(__cfqq);
 
 	rb_link_node(&cfqq->p_node, parent, p);
@@ -656,8 +656,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node))
 		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
-	if (!RB_EMPTY_NODE(&cfqq->p_node))
-		rb_erase_init(&cfqq->p_node, &cfqd->prio_trees[cfqq->ioprio]);
+	if (!RB_EMPTY_NODE(&cfqq->p_node)) {
+		rb_erase_init(&cfqq->p_node,
+					&cfqd->prio_trees[cfqq->org_ioprio]);
+	}
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
@@ -976,7 +978,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	 * First, if we find a request starting at the end of the last
 	 * request, choose it.
 	 */
-	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
+	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->org_ioprio,
 				      sector, &parent, NULL);
 	if (__cfqq)
 		return __cfqq;
@@ -1559,8 +1561,9 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 
 static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
+	struct cfq_data *cfqd = cfqq->cfqd;
 	struct task_struct *tsk = current;
-	int ioprio_class;
+	int ioprio_class, prio_readd = 0;
 
 	if (!cfq_cfqq_prio_changed(cfqq))
 		return;
@@ -1592,12 +1595,24 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	}
 
 	/*
+	 * Remove us from the prio_tree if we are present, since we index
+	 * by ->org_ioprio
+	 */
+	if (!RB_EMPTY_NODE(&cfqq->p_node)) {
+		rb_erase(&cfqq->p_node, &cfqd->prio_trees[cfqq->org_ioprio]);
+		prio_readd = 1;
+	}
+
+	/*
 	 * keep track of original prio settings in case we have to temporarily
 	 * elevate the priority of this queue
 	 */
 	cfqq->org_ioprio = cfqq->ioprio;
 	cfqq->org_ioprio_class = cfqq->ioprio_class;
 	cfq_clear_cfqq_prio_changed(cfqq);
+
+	if (prio_readd)
+		cfq_prio_tree_add(cfqd, cfqq);
 }
 
 static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)

-- 
Jens Axboe

