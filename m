Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZKTOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZKTOUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZKTOUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZKTOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:20:18 -0500
Date: Fri, 20 Nov 2009 09:18:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091120141840.GA5872@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091118153227.GA5796@redhat.com> <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com> <20091118225626.GA2974@redhat.com> <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 12:35:12AM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 18, 2009 at 11:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Moving all the queues to root group is one way to solve the issue. Though
> > problem still remains if there are 7-8 sequential workload groups operating
> > with low_latency=0. In that case after every dispatch round of sync-noidle
> > workload in root group, next round might be much more than 300ms, hence
> > bumping up the max latencies of sync-noidle workload.
> 
> I think that this is the desired behaviour: low_latency=0 means that
> latency is less important than throughput, so I wouldn't worry about
> it.
> 
> >
> > I think one of the core problem seems to be that I always put the group at
> > the end of service tree. Instead I should let the group delete from
> > service tree if it does not have sufficient IO, and when it comes back
> > again, try to put it in the beginning of tree according to weight so
> > that not all is lost and it gets to dispatch IO sooner.
> 
> It is similar to how the queues are put in service tree in cfq without groups.
> If a queue had some remaining slice, it is prioritized w.r.t. ones
> that consumed their slice completely, by giving it a lower key.
> 
> > This way, the groups which have been using long slices (either because
> > they are running sync-idle workload or because they have sufficient IO
> > to keep the disk busy), will be towards later end of service tree and the
> > groups which are new or which have lost their share because they have
> > dispatched a small IO and got deleted, will be put at the front of tree.
> >
> > This way sync-noidle queues in a group will not loose out because of
> > sync-idle IO happening in other groups.
> 
> It is ok if you have group idling, but if you disable it (and end of
> tree idle), it will be similar to how CFQ was before my patch set (and
> experiments showed that the approach was inferior to grouping no-idle
> together), without the service differentiation benefit introduced by
> your idling.
> So I still prefer the binary choice: either you want fairness (by
> idling) or performance (by putting all no-idle queues together).

Hi Corrado,

I liked the idea of putting all the sync-noidle queues together in root
group to achieve better throughput and implemeted a small patch.

It works fine for random readers. But when I do multiple direct random writers
in one group vs a random reader in other group, I am getting strange
behavior. Random reader moves to root group as sync-noidle workload. But
random writers are largely sync queues in remain in other group. But many
a times also jump into root group and preempt random reader.

Anyway, with 4 random writers and 1 random reader running for 30 seconds
in root group I get following.

rw: 59,963KB/s
rr: 66KB/s

But if these are put in seprate groups test1 and test2 then

rw: 30,587KB/s
rr: 23KB/s

I can understand the drop in rw throughput as it has been put under a
group of weight 500. But rr will run in root group with weight 1000 and
should have received much higher BW, instead it ends up loosing.

Staring hard at blktrace output to figure out what's happening. One thing
noticeable so far is that without cgroup stuff we seem to be interleaving
dispatch from random reader and random writer much better as compared to
with cgroup stuff.

Thanks
Vivek


---
 block/cfq-iosched.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

Index: linux6/block/cfq-iosched.c
===================================================================
--- linux6.orig/block/cfq-iosched.c	2009-11-19 21:38:51.000000000 -0500
+++ linux6/block/cfq-iosched.c	2009-11-19 21:38:53.000000000 -0500
@@ -142,6 +142,7 @@ struct cfq_queue {
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
+	struct cfq_group *orig_cfqg;
 	/* Sectors dispatched in current dispatch round */
 	unsigned long nr_sectors;
 };
@@ -266,6 +267,7 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 	unsigned int cfq_latency;
 	unsigned int cfq_group_idle;
+	unsigned int cfq_group_isolation;
 
 	struct list_head cic_list;
 
@@ -1139,9 +1141,35 @@ static void cfq_service_tree_add(struct 
 	struct cfq_rb_root *service_tree;
 	int left;
 	int new_cfqq = 1;
+	int group_changed = 0;
+
+	if (!cfqd->cfq_group_isolation
+	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
+	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
+		/* Move this cfq to root group */
+		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
+		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+		cfqq->orig_cfqg = cfqq->cfqg;
+		cfqq->cfqg = &cfqd->root_group;
+		atomic_inc(&cfqd->root_group.ref);
+		group_changed = 1;
+	} else if (!cfqd->cfq_group_isolation
+		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
+		/* cfqq is sequential now needs to go to its original group */
+		BUG_ON(cfqq->cfqg != &cfqd->root_group);
+		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+		cfq_put_cfqg(cfqq->cfqg);
+		cfqq->cfqg = cfqq->orig_cfqg;
+		cfqq->orig_cfqg = NULL;
+		group_changed = 1;
+		cfq_log_cfqq(cfqd, cfqq, "moved to origin group");
+	}
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq), cfqd);
+
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -1209,7 +1237,7 @@ static void cfq_service_tree_add(struct 
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
-	if (add_front || !new_cfqq)
+	if ((add_front || !new_cfqq) && !group_changed)
 		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
 }
@@ -2379,6 +2407,9 @@ static void cfq_put_queue(struct cfq_que
 
 	kmem_cache_free(cfq_pool, cfqq);
 	cfq_put_cfqg(cfqg);
+
+	if (cfqq->orig_cfqg)
+		cfq_put_cfqg(cfqq->orig_cfqg);
 }
 
 /*
@@ -3661,6 +3692,7 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_idle = 1;
+	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = 1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
@@ -3732,6 +3764,7 @@ SHOW_FUNCTION(cfq_slice_async_show, cfqd
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
 SHOW_FUNCTION(cfq_group_idle_show, cfqd->cfq_group_idle, 0);
+SHOW_FUNCTION(cfq_group_isolation_show, cfqd->cfq_group_isolation, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -3765,6 +3798,7 @@ STORE_FUNCTION(cfq_slice_async_rq_store,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
 STORE_FUNCTION(cfq_group_idle_store, &cfqd->cfq_group_idle, 0, 1, 0);
+STORE_FUNCTION(cfq_group_isolation_store, &cfqd->cfq_group_isolation, 0, 1, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -3782,6 +3816,7 @@ static struct elv_fs_entry cfq_attrs[] =
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(low_latency),
 	CFQ_ATTR(group_idle),
+	CFQ_ATTR(group_isolation),
 	__ATTR_NULL
 };
 
