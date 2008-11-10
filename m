Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYKJVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYKJVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKJVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:53:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYKJVxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:53:46 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>
	<20081110104423.GA26778@kernel.dk>
	<x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
	<20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua>
	<20081110173504.GL26778@kernel.dk> <49187D05.9050407@telenet.dn.ua>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 10 Nov 2008 16:51:27 -0500
In-Reply-To: <49187D05.9050407@telenet.dn.ua> (Vitaly V. Bursov's message of
	"Mon, 10 Nov 2008 20:27:17 +0200")
Message-ID: <x491vxjqmg0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vitaly V. Bursov" <vitalyb@telenet.dn.ua> writes:

> Jens Axboe wrote:
>> On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
>>> Jens Axboe wrote:
>>>> On Mon, Nov 10 2008, Jeff Moyer wrote:
>>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>>>
>>>>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
>>>>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
>>>>> you to try this patch is that nfsd may be farming off the I/O requests
>>>>> to different threads which are then performing interleaved I/O.  The
>>>>> above patch tries to detect this and allow cooperating processes to get
>>>>> disk time instead of waiting for the idle timeout.
>>>> Precisely :-)
>>>>
>>>> The only reason I haven't merged it yet is because of worry of extra
>>>> cost, but I'll throw some SSD love at it and see how it turns out.
>>>>
>>> Sorry, but I get "oops" same moment nfs read transfer starts.
>>> I can get directory list via nfs, read files locally (not
>>> carefully tested, though)
>>>
>>> Dumps captured via netconsole, so these may not be completely accurate
>>> but hopefully will give a hint.
>> 
>> Interesting, strange how that hasn't triggered here. Or perhaps the
>> version that Jeff posted isn't the one I tried. Anyway, search for:
>> 
>>         RB_CLEAR_NODE(&cfqq->rb_node);
>> 
>> and add a
>> 
>>         RB_CLEAR_NODE(&cfqq->prio_node);
>> 
>> just below that. It's in cfq_find_alloc_queue(). I think that should fix
>> it.
>> 
>
> Same problem.
>
> I did make clean; make -j3; sync; on (2 times) patched kernel and it went OK
> but It won't boot anymore with cfq with same error...
>
> Switching cfq io scheduler at runtime (booting with "as") appears to work with
> two parallel local dd reads.

Strange, I can't reproduce a failure.  I'll keep trying.  For now, these
are the results I see:

[root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
[root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 26.8128 s, 40.0 MB/s
[root@maiden ~]# umount /mnt/megadeth/
[root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
[root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 23.7025 s, 45.3 MB/s
[root@maiden ~]# umount /mnt/megadeth/

Here is the patch, with the suggestion from Jens to switch the cfqq to
the right priority tree when the priority is changed.

Cheers,

Jeff

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..dd26cba 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -83,6 +83,12 @@ struct cfq_data {
 	 * rr list of queues with requests and the count of them
 	 */
 	struct cfq_rb_root service_tree;
+	/*
+	 * Each priority tree is sorted by next_request position.  These
+	 * trees are used when determining if two or more queues are
+	 * interleaving requests (see cfq_close_cooperator).
+	 */
+	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 	unsigned int busy_queues;
 
 	int rq_in_driver;
@@ -142,6 +148,8 @@ struct cfq_queue {
 	struct rb_node rb_node;
 	/* service_tree key */
 	unsigned long rb_key;
+	/* prio tree member */
+	struct rb_node prio_node;
 	/* sorted list of pending requests */
 	struct rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
@@ -415,13 +423,17 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
+static void rb_erase_init(struct rb_node *n, struct rb_root *root)
+{
+	rb_erase(n, root);
+	RB_CLEAR_NODE(n);
+}
+
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
 	if (root->left == n)
 		root->left = NULL;
-
-	rb_erase(n, &root->rb);
-	RB_CLEAR_NODE(n);
+	rb_erase_init(n, &root->rb);
 }
 
 /*
@@ -540,6 +552,62 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
 }
 
+static struct cfq_queue *cfq_prio_tree_lookup(struct cfq_data *cfqd,
+	int ioprio, sector_t sector, struct rb_node **ret_parent,
+	struct rb_node ***rb_link)
+{
+	struct rb_root *root = &cfqd->prio_trees[ioprio];
+	struct rb_node **p, *parent;
+	struct cfq_queue *cfqq = NULL;
+
+	parent = NULL;
+	p = &root->rb_node;
+	while (*p) {
+		struct rb_node **n;
+
+		parent = *p;
+		cfqq = rb_entry(parent, struct cfq_queue, prio_node);
+
+		/*
+		 * Sort strictly based on sector.  Smallest to the left,
+		 * largest to the right.
+		 */
+		if (sector > cfqq->next_rq->sector)
+			n = &(*p)->rb_right;
+		else if (sector < cfqq->next_rq->sector)
+			n = &(*p)->rb_left;
+		else
+			break;
+		p = n;
+	}
+
+	*ret_parent = parent;
+	if (rb_link)
+		*rb_link = p;
+	return NULL;
+}
+
+static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct rb_root *root = &cfqd->prio_trees[cfqq->ioprio];
+	struct rb_node **p, *parent;
+	struct cfq_queue *__cfqq;
+
+	if (!RB_EMPTY_NODE(&cfqq->prio_node))
+		rb_erase_init(&cfqq->prio_node, root);
+
+	if (cfq_class_idle(cfqq))
+		return;
+	if (!cfqq->next_rq)
+		return;
+
+	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->ioprio, cfqq->next_rq->sector, &parent, &p);
+	BUG_ON(__cfqq);
+
+	rb_link_node(&cfqq->prio_node, parent, p);
+	rb_insert_color(&cfqq->prio_node, root);
+}
+
 /*
  * Update cfqq's position in the service tree.
  */
@@ -548,8 +616,10 @@ static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
-	if (cfq_cfqq_on_rr(cfqq))
+	if (cfq_cfqq_on_rr(cfqq)) {
 		cfq_service_tree_add(cfqd, cfqq, 0);
+		cfq_prio_tree_add(cfqd, cfqq);
+	}
 }
 
 /*
@@ -578,6 +648,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node))
 		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+	if (!RB_EMPTY_NODE(&cfqq->prio_node))
+		rb_erase_init(&cfqq->prio_node, &cfqd->prio_trees[cfqq->ioprio]);
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
@@ -623,6 +695,9 @@ static void cfq_add_rq_rb(struct request *rq)
 	 * check if this request is a better next-serve candidate
 	 */
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
+	/* this changes the position in the priority tree */
+	cfq_prio_tree_add(cfqd, cfqq);
+
 	BUG_ON(!cfqq->next_rq);
 }
 
@@ -831,11 +906,11 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 /*
  * Get and set a new active queue for service.
  */
-static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
+static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
+					      struct cfq_queue *cfqq)
 {
-	struct cfq_queue *cfqq;
-
-	cfqq = cfq_get_next_queue(cfqd);
+	if (!cfqq)
+		cfqq = cfq_get_next_queue(cfqd);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -859,15 +934,77 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 	return cfq_dist_from_last(cfqd, rq) <= cic->seek_mean;
 }
 
-static int cfq_close_cooperator(struct cfq_data *cfq_data,
-				struct cfq_queue *cfqq)
+static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
+				    struct cfq_queue *cur_cfqq)
 {
+	struct rb_root *root = &cfqd->prio_trees[cur_cfqq->ioprio];
+	struct rb_node *parent, *node;
+	struct cfq_queue *__cfqq;
+	sector_t sector = cfqd->last_position;
+
+	if (RB_EMPTY_ROOT(root))
+		return NULL;
+
+	/*
+	 * First, if we find a request starting at the end of the last
+	 * request, choose it.
+	 */
+	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
+				      sector, &parent, NULL);
+	if (__cfqq)
+		return __cfqq;
+
+	/*
+	 * If the exact sector wasn't found, the parent of the NULL leaf
+	 * will contain the closest sector.
+	 */
+	__cfqq = rb_entry(parent, struct cfq_queue, prio_node);
+	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+		return __cfqq;
+	if (__cfqq->next_rq->sector < sector)
+		node = rb_next(&__cfqq->prio_node);
+	else
+		node = rb_prev(&__cfqq->prio_node);
+	if (!node)
+		return NULL;
+	__cfqq = rb_entry(node, struct cfq_queue, prio_node);
+	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+		return __cfqq;
+
+	return NULL;
+}
+
+/*
+ * cfqd - obvious
+ * cur_cfqq - passed in so that we don't decide that the current queue is
+ * 	      closely cooperating with itself.
+ *
+ * So, basically we're assuming that that cur_cfqq has dispatched at least
+ * one request, and that cfqd->last_position reflects a position on the disk
+ * associated with the I/O issued by cur_cfqq.  I'm not sure this is a valid
+ * assumption.
+ */
+static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
+					      struct cfq_queue *cur_cfqq)
+{
+	struct cfq_queue *cfqq;
+
+	/*
+	 * A valid cfq_io_context is necessary to compare requests against
+	 * the seek_mean of the current cfqq.
+	 */
+	if (!cfqd->active_cic)
+		return NULL;
+
 	/*
 	 * We should notice if some of the queues are cooperating, eg
 	 * working closely on the same area of the disk. In that case,
 	 * we can group them together and don't waste time idling.
 	 */
-	return 0;
+	if ((cfqq = cfqq_close(cfqd, cur_cfqq)))
+		return cfqq;
+
+	return NULL;
 }
 
 #define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
@@ -908,13 +1045,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
 		return;
 
-	/*
-	 * See if this prio level has a good candidate
-	 */
-	if (cfq_close_cooperator(cfqd, cfqq) &&
-	    (sample_valid(cic->ttime_samples) && cic->ttime_mean > 2))
-		return;
-
 	cfq_mark_cfqq_must_dispatch(cfqq);
 	cfq_mark_cfqq_wait_request(cfqq);
 
@@ -992,7 +1122,7 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
-	struct cfq_queue *cfqq;
+	struct cfq_queue *cfqq, *new_cfqq = NULL;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
@@ -1012,6 +1142,15 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto keep_queue;
 
 	/*
+ 	 * If another queue has a request waiting within our mean seek
+ 	 * distance, let it run.  The expire code will check for close
+ 	 * cooperators and put the close queue at the front of the service
+ 	 * tree.
+ 	 */
+	if ((new_cfqq = cfq_close_cooperator(cfqd, cfqq)))
+		goto expire;
+
+	/*
 	 * No requests pending. If the active queue still has requests in
 	 * flight or is idling for a new request, allow either of these
 	 * conditions to happen (or time out) before selecting a new queue.
@@ -1025,7 +1164,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
-	cfqq = cfq_set_active_queue(cfqd);
+	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
 }
@@ -1466,6 +1605,7 @@ retry:
 		}
 
 		RB_CLEAR_NODE(&cfqq->rb_node);
+		RB_CLEAR_NODE(&cfqq->prio_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
 		atomic_set(&cfqq->ref, 0);
@@ -1949,7 +2089,18 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_set_prio_slice(cfqd, cfqq);
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
-		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
+		/*
+		 * If there are no requests waiting in this queue, and
+		 * there are other queues ready to issue requests, AND
+		 * those other queues are issuing requests within our
+		 * mean seek distance, give them a chance to run instead
+		 * of idling.
+		 */
+		if (RB_EMPTY_ROOT(&cfqq->sort_list) &&
+		    !RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
+			if (cfq_close_cooperator(cfqd, cfqq))
+				cfq_slice_expired(cfqd, 1);
+		} else if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
 			cfq_arm_slice_timer(cfqd);
@@ -1983,6 +2134,7 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		if (cfqq->ioprio != cfqq->org_ioprio)
 			cfqq->ioprio = cfqq->org_ioprio;
 	}
+	cfq_prio_tree_add(cfqq->cfqd, cfqq);
 }
 
 static inline int __cfq_may_queue(struct cfq_queue *cfqq)
