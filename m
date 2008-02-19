Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYBSIgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYBSIgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYBSIgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:36:38 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21315 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYBSIgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:36:37 -0500
Date: Tue, 19 Feb 2008 09:36:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1  softlockup  while bootup on powerpc
Message-ID: <20080219083633.GN23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com> <20080217192913.GO23197@kernel.dk> <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
> On Sun, 17 Feb 2008 20:29:13 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's odd stuff. Could you perhaps try and add some printks to
> > block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
> > from radix_tree_gang_lookup() and the pointer value of cics[i] in the
> > for() loop after the lookup?
> > 
> I met the same issue on ia64/NUMA box.
> seems cisc[]->key is NULL and index for radix_tree_gang_lookup() was
> always '1'.

Why does it keep repeating then? If ->key is NULL, the next lookup index
should be 1UL.

But I think the radix 'scan over entire tree' is a bit fragile. This
patch adds a parallel hlist for ease of properly browsing the members,
does that work for you? It compiles, but I haven't booted it here yet...

> Attached patch works well for me, but I don't know much about cfq.
> please confirm. 

It doesn't make a lot of sense, I'm afraid.

 block/blk-ioc.c           |   35 +++++++++++++++--------------------
 block/cfq-iosched.c       |   37 +++++++++++--------------------------
 include/linux/iocontext.h |    2 ++
 3 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 80245dc..73c7002 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -17,17 +17,13 @@ static struct kmem_cache *iocontext_cachep;
 
 static void cfq_dtor(struct io_context *ioc)
 {
-	struct cfq_io_context *cic[1];
-	int r;
+	if (!hlist_empty(&ioc->cic_list)) {
+		struct cfq_io_context *cic;
 
-	/*
-	 * We don't have a specific key to lookup with, so use the gang
-	 * lookup to just retrieve the first item stored. The cfq exit
-	 * function will iterate the full tree, so any member will do.
-	 */
-	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
-	if (r > 0)
-		cic[0]->dtor(ioc);
+		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+								cic_list);
+		cic->dtor(ioc);
+	}
 }
 
 /*
@@ -57,18 +53,16 @@ EXPORT_SYMBOL(put_io_context);
 
 static void cfq_exit(struct io_context *ioc)
 {
-	struct cfq_io_context *cic[1];
-	int r;
-
 	rcu_read_lock();
-	/*
-	 * See comment for cfq_dtor()
-	 */
-	r = radix_tree_gang_lookup(&ioc->radix_root, (void **) cic, 0, 1);
-	rcu_read_unlock();
 
-	if (r > 0)
-		cic[0]->exit(ioc);
+	if (!hlist_empty(&ioc->cic_list)) {
+		struct cfq_io_context *cic;
+
+		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+								cic_list);
+		cic->exit(ioc);
+	}
+	rcu_read_unlock();
 }
 
 /* Called by the exitting task */
@@ -105,6 +99,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		ret->nr_batch_requests = 0; /* because this is 0 */
 		ret->aic = NULL;
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
+		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
 	}
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ca198e6..62eda3f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1145,38 +1145,19 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 /*
  * Call func for each cic attached to this ioc. Returns number of cic's seen.
  */
-#define CIC_GANG_NR	16
 static unsigned int
 call_for_each_cic(struct io_context *ioc,
 		  void (*func)(struct io_context *, struct cfq_io_context *))
 {
-	struct cfq_io_context *cics[CIC_GANG_NR];
-	unsigned long index = 0;
-	unsigned int called = 0;
-	int nr;
+	struct cfq_io_context *cic;
+	struct hlist_node *n;
+	int called = 0;
 
 	rcu_read_lock();
-
-	do {
-		int i;
-
-		/*
-		 * Perhaps there's a better way - this just gang lookups from
-		 * 0 to the end, restarting after each CIC_GANG_NR from the
-		 * last key + 1.
-		 */
-		nr = radix_tree_gang_lookup(&ioc->radix_root, (void **) cics,
-						index, CIC_GANG_NR);
-		if (!nr)
-			break;
-
-		called += nr;
-		index = 1 + (unsigned long) cics[nr - 1]->key;
-
-		for (i = 0; i < nr; i++)
-			func(ioc, cics[i]);
-	} while (nr == CIC_GANG_NR);
-
+	hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list) {
+		func(ioc, cic);
+		called++;
+	}
 	rcu_read_unlock();
 
 	return called;
@@ -1190,6 +1171,7 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 
 	spin_lock_irqsave(&ioc->lock, flags);
 	radix_tree_delete(&ioc->radix_root, cic->dead_key);
+	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	kmem_cache_free(cfq_ioc_pool, cic);
@@ -1280,6 +1262,7 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (cic) {
 		cic->last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->queue_list);
+		INIT_HLIST_NODE(&cic->cic_list);
 		cic->dtor = cfq_free_io_context;
 		cic->exit = cfq_exit_io_context;
 		elv_ioc_count_inc(ioc_count);
@@ -1501,6 +1484,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 		rcu_assign_pointer(ioc->ioc_data, NULL);
 
 	radix_tree_delete(&ioc->radix_root, (unsigned long) cfqd);
+	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	cfq_cic_free(cic);
@@ -1561,6 +1545,7 @@ static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 		spin_lock_irqsave(&ioc->lock, flags);
 		ret = radix_tree_insert(&ioc->radix_root,
 						(unsigned long) cfqd, cic);
+		hlist_add_head_rcu(&cic->cic_list, &ioc->cic_list);
 		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		radix_tree_preload_end();
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 593b222..1b4ccf2 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -50,6 +50,7 @@ struct cfq_io_context {
 	sector_t seek_mean;
 
 	struct list_head queue_list;
+	struct hlist_node cic_list;
 
 	void (*dtor)(struct io_context *); /* destructor */
 	void (*exit)(struct io_context *); /* called on task exit */
@@ -77,6 +78,7 @@ struct io_context {
 
 	struct as_io_context *aic;
 	struct radix_tree_root radix_root;
+	struct hlist_head cic_list;
 	void *ioc_data;
 };
 

-- 
Jens Axboe

