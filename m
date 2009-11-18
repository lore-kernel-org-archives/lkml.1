Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZKRPeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZKRPeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZKRPeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:34:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZKRPeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:34:10 -0500
Date: Wed, 18 Nov 2009 10:32:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091118153227.GA5796@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258461527.2862.2.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 07:38:47AM -0500, Alan D. Brunelle wrote:
> On Mon, 2009-11-16 at 17:18 -0500, Vivek Goyal wrote:
> > On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:
> > 
> > [..]
> > > ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> > > 
> > > The next thing to look at is to see what the "penalty" is for the
> > > additional code: see how much bandwidth we lose for the capability
> > > added. Here we see the sum of the system's throughput for the various
> > > tests:
> > > 
> > > ---- ---- - ----------- ----------- ----------- ----------- 
> > > Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> > > ---- ---- - ----------- ----------- ----------- ----------- 
> > >  rnd   rd 2        17.3        17.1         9.4         9.1 
> > >  rnd   rd 4        27.1        27.1         8.1         8.2 
> > >  rnd   rd 8        37.1        37.1         6.8         7.1 
> > > 
> > 

Hi Alan,

I got hold of a better system where few disks are striped. On this system
I can also see the performance drop and it does come from the fact that
we idle on empty sync-noidle service tree. So with multiple groups we
increase the instances of sync-noidle trees hence more idling and hence
reduced throughput.

With this patch, I had done a little optimization where I don't idle on
a sync-noidle service tree if there are no competing sync-idle or async
queues.

What that means is that if a group is doing only random IO and it does not
have sufficient IO to keep disk busy, then we will move onto next group
and start dispatching from that. So in your tests, with this patch you 
should see better results for random reads with group_idle=0. With
group_idle=1, results will still remain same as we continue to idle on
sync-noidle service tree.

It is working for me. Can you please try it out. You can just apply this
patch on top of V3. (You don't have to apply hw_tag patch from corrodo).

Thanks
Vivek


o Now we don't remove the queue from service tree until we expire it, even if
  queue is empty. So st->count = 0 is not a valid state while we have a cfqq
  at hand. Fix it in arm_slice_timer().

o wait_busy gets set only if group is emtpy. If st->count > 1, then group is
  not empty and wait_busy will not be set. Remove that extra check.

o There is no need to idle on aysnc service tree as it is backlogged most of
  the time if writes are on. Those queues don't get deleted hence don't wait
  on async service tree. Similiarly don't wait on sync-idle service tree as
  we do idling on individual queues if need be. Fixed cfq_should_idle().

o Currently we wait on sync-noidle service tree so that sync-noidle type of
  workload does not get swamped by sync-idle or async type of workload. Don't
  do this idling if there are no sync-idle or async type of queues in the group
  and there are other groups to dispatch the requests from and user has decided
  not to wait on slow groups to achieve better throughput. (group_idle=0).

  This will make sure if some group is doing just random IO and does not
  have sufficient IO to keep the disk busy, we will move onto other groups to
  dispatch the requests from and utilize the storage better. 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

Index: linux6/block/cfq-iosched.c
===================================================================
--- linux6.orig/block/cfq-iosched.c	2009-11-17 14:44:09.000000000 -0500
+++ linux6/block/cfq-iosched.c	2009-11-18 10:09:33.000000000 -0500
@@ -899,6 +899,10 @@ static bool cfq_should_idle(struct cfq_d
 {
 	enum wl_prio_t prio = cfqq_prio(cfqq);
 	struct cfq_rb_root *service_tree = cfqq->service_tree;
+	struct cfq_group *cfqg = cfqq->cfqg;
+
+	BUG_ON(!service_tree);
+	BUG_ON(!service_tree->count);
 
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
@@ -908,18 +912,18 @@ static bool cfq_should_idle(struct cfq_d
 	if (cfq_cfqq_idle_window(cfqq))
 		return true;
 
+	/* Don't idle on async and sync-idle service trees */
+	if (cfqd->serving_type != SYNC_NOIDLE_WORKLOAD)
+		return false;
 	/*
-	 * Otherwise, we do only if they are the last ones
-	 * in their service tree.
+	 * If there are other competing groups present, don't wait on service
+	 * tree if this is last queue in the group and there are no other
+	 * competing queues (sync-idle or async) queues present
 	 */
-	if (!service_tree)
-		service_tree = service_tree_for(cfqq->cfqg, prio,
-						cfqq_type(cfqq), cfqd);
-
-	if (service_tree->count == 0)
-		return true;
-
-	return (service_tree->count == 1 && cfq_rb_first(service_tree) == cfqq);
+	if (cfqd->nr_groups > 1 && !cfqd->cfq_group_idle)
+		return (service_tree->count == 1 && cfqg->nr_cfqq > 1);
+	else
+		return service_tree->count == 1;
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1102,9 +1106,6 @@ static inline bool cfqq_should_wait_busy
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list) || cfqq->cfqg->nr_cfqq > 1)
 		return false;
 
-	if (!cfq_should_idle(cfqq->cfqd, cfqq))
-		return false;
-
 	return true;
 }
 
@@ -1801,7 +1802,10 @@ static bool cfq_arm_slice_timer(struct c
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
+	if (!cfqd->cfq_slice_idle)
+		return false;
+
+	if (!cfq_should_idle(cfqd, cfqq) && !wait_busy)
 		return false;
 
 	/*
@@ -1837,8 +1841,7 @@ static bool cfq_arm_slice_timer(struct c
 	 */
 	st = service_tree_for(cfqq->cfqg, cfqd->serving_prio,
 				SYNC_NOIDLE_WORKLOAD, cfqd);
-	if (!wait_busy && cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
-	    && st->count > 0) {
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD && st->count > 1) {
 		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
 			return false;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
