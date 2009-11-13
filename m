Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZKMQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZKMQPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZKMQP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:15:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbZKMQP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:15:27 -0500
Date: Fri, 13 Nov 2009 11:15:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 05/16] blkio: Implement per cfq group latency target
	and busy queue avg
Message-ID: <20091113161506.GF17076@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com> <1258068756-10766-6-git-send-email-vgoyal@redhat.com> <4e5e476b0911130246m372eb8e8x7b98f13278515a95@mail.gmail.com> <20091113151815.GC17076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091113151815.GC17076@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:18:15AM -0500, Vivek Goyal wrote:
> On Fri, Nov 13, 2009 at 11:46:49AM +0100, Corrado Zoccolo wrote:
> > On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >  static inline void
> > > @@ -441,10 +445,13 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >        if (cfqd->cfq_latency) {
> > >                /* interested queues (we consider only the ones with the same
> > >                 * priority class) */
> > This comment needs to be updated
> 
> Sure. Will do. Now the interested queues are the one with same priority
> class with-in group.
> 
> > >                 * priority class) */
> > > -               unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
> > > +               unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
> > > +                                               cfq_class_rt(cfqq));
> > >                unsigned sync_slice = cfqd->cfq_slice[1];
> > >                unsigned expect_latency = sync_slice * iq;
> > > -               if (expect_latency > cfq_target_latency) {
> > > +               unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
> > 
> > I'm not sure that we should divide the target latency evenly among groups.
> > Groups with different weights will have different percentage of time
> > in each 300ms round, so probably we should consider it here.
> > 
> 
> Taking group weight into account will be more precise thing. So may be
> I can keep track of total weight on the service tree and determine
> group target latency as proportion of total weight.
> 
>  group_target_lat = group_weight * cfq_target_latency/total_weight_of_groups
> 

Here is the patch I generated on top of all the patches in series.

o Determine group target latency in proportion to group weight instead of
  just number of groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: linux7/block/cfq-iosched.c
===================================================================
--- linux7.orig/block/cfq-iosched.c	2009-11-13 09:48:38.000000000 -0500
+++ linux7/block/cfq-iosched.c	2009-11-13 11:06:22.000000000 -0500
@@ -81,6 +81,7 @@ struct cfq_rb_root {
 	unsigned count;
 	u64 min_vdisktime;
 	struct rb_node *active;
+	unsigned total_weight;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
 
@@ -521,18 +522,28 @@ static inline unsigned cfq_group_get_avg
 	return cfqg->busy_queues_avg[rt];
 }
 
+static inline unsigned
+cfq_group_latency(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+
+	return cfq_target_latency * cfqg->weight / st->total_weight;
+}
+
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
 	if (cfqd->cfq_latency) {
-		/* interested queues (we consider only the ones with the same
-		 * priority class) */
+		/*
+		 * interested queues (we consider only the ones with the same
+		 * priority class in the cfq group)
+		 */
 		unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
 						cfq_class_rt(cfqq));
 		unsigned sync_slice = cfqd->cfq_slice[1];
 		unsigned expect_latency = sync_slice * iq;
-		unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
+		unsigned group_target_lat = cfq_group_latency(cfqd, cfqq->cfqg);
 
 		if (expect_latency > group_target_lat) {
 			unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
@@ -799,6 +810,7 @@ cfq_group_service_tree_add(struct cfq_da
 	__cfq_group_service_tree_add(st, cfqg);
 	cfqg->on_st = true;
 	cfqd->nr_groups++;
+	st->total_weight += cfqg->weight;
 }
 
 static void
@@ -819,6 +831,7 @@ cfq_group_service_tree_del(struct cfq_da
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfqg->on_st = false;
 	cfqd->nr_groups--;
+	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
@@ -2033,7 +2046,7 @@ static void choose_service_tree(struct c
 	 * proportional to the number of queues in that workload, over
 	 * all the queues in the same priority class
 	 */
-	group_target_latency = cfq_target_latency/cfqd->nr_groups;
+	group_target_latency = cfq_group_latency(cfqd, cfqg);
 
 	slice = group_target_latency * count /
 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
