Return-Path: <linux-kernel-owner+w=401wt.eu-S966810AbXEHTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966810AbXEHTnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966433AbXEHTnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:43:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966406AbXEHTnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:43:15 -0400
Date: Tue, 8 May 2007 20:40:41 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, Holger Smolinski <smolinski@de.ibm.com>
Subject: [2.6.22 PATCH 02/26] dm raid1: one kmirrord per mirror
Message-ID: <20070508194041.GI24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, Holger Smolinski <smolinski@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Holger Smolinski <smolinski@de.ibm.com>

This patch replaces the single instance of kmirrord by one instance per
mirror set.  This change is required to avoid a deadlock in kmirrord when
the persistent dirty log of a mirror itself resides on a mirror. The single
instance of kmirrord then issues a sync write to the dirty log in
write_bits which gets deferred to kmirrord itself later in the call chain.
But kmirrord never does the deferred work because it is still waiting for
the sync write_bits.

_mirror_sets is removed as it no longer needed, and we always flush the
workqueue before destroying it to ensure all work is complete before
destroying it.

Signed-off-by: Holger Smolinski <smolinski@de.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-raid1.c |   81 ++++++++++++++++----------------------------------
 1 files changed, 27 insertions(+), 54 deletions(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 17:40:46.000000000 +0100
@@ -22,15 +22,8 @@
 
 #define DM_MSG_PREFIX "raid1"
 
-static struct workqueue_struct *_kmirrord_wq;
-static struct work_struct _kmirrord_work;
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
-static inline void wake(void)
-{
-	queue_work(_kmirrord_wq, &_kmirrord_work);
-}
-
 /*-----------------------------------------------------------------
  * Region hash
  *
@@ -136,6 +129,9 @@ struct mirror_set {
 
 	struct mirror *default_mirror;	/* Default mirror */
 
+	struct workqueue_struct *kmirrord_wq;
+	struct work_struct kmirrord_work;
+
 	unsigned int nr_mirrors;
 	struct mirror mirror[0];
 };
@@ -153,6 +149,11 @@ static inline sector_t region_to_sector(
 	return region << rh->region_shift;
 }
 
+static void wake(struct mirror_set *ms)
+{
+	queue_work(ms->kmirrord_wq, &ms->kmirrord_work);
+}
+
 /* FIXME move this */
 static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw);
 
@@ -471,7 +472,7 @@ static void rh_dec(struct region_hash *r
 	spin_unlock_irqrestore(&rh->region_lock, flags);
 
 	if (should_wake)
-		wake();
+		wake(rh->ms);
 }
 
 /*
@@ -558,7 +559,7 @@ static void rh_recovery_end(struct regio
 	list_add(&reg->list, &reg->rh->recovered_regions);
 	spin_unlock_irq(&rh->region_lock);
 
-	wake();
+	wake(rh->ms);
 }
 
 static void rh_flush(struct region_hash *rh)
@@ -592,7 +593,7 @@ static void rh_start_recovery(struct reg
 	for (i = 0; i < MAX_RECOVERY; i++)
 		up(&rh->recovery_count);
 
-	wake();
+	wake(rh->ms);
 }
 
 /*
@@ -870,11 +871,10 @@ static void do_writes(struct mirror_set 
 /*-----------------------------------------------------------------
  * kmirrord
  *---------------------------------------------------------------*/
-static LIST_HEAD(_mirror_sets);
-static DECLARE_RWSEM(_mirror_sets_lock);
-
-static void do_mirror(struct mirror_set *ms)
+static void do_mirror(struct work_struct *work)
 {
+	struct mirror_set *ms =container_of(work, struct mirror_set,
+					    kmirrord_work);
 	struct bio_list reads, writes;
 
 	spin_lock(&ms->lock);
@@ -890,16 +890,6 @@ static void do_mirror(struct mirror_set 
 	do_writes(ms, &writes);
 }
 
-static void do_work(struct work_struct *ignored)
-{
-	struct mirror_set *ms;
-
-	down_read(&_mirror_sets_lock);
-	list_for_each_entry (ms, &_mirror_sets, list)
-		do_mirror(ms);
-	up_read(&_mirror_sets_lock);
-}
-
 /*-----------------------------------------------------------------
  * Target functions
  *---------------------------------------------------------------*/
@@ -978,23 +968,6 @@ static int get_mirror(struct mirror_set 
 	return 0;
 }
 
-static int add_mirror_set(struct mirror_set *ms)
-{
-	down_write(&_mirror_sets_lock);
-	list_add_tail(&ms->list, &_mirror_sets);
-	up_write(&_mirror_sets_lock);
-	wake();
-
-	return 0;
-}
-
-static void del_mirror_set(struct mirror_set *ms)
-{
-	down_write(&_mirror_sets_lock);
-	list_del(&ms->list);
-	up_write(&_mirror_sets_lock);
-}
-
 /*
  * Create dirty log: log_type #log_params <log_params>
  */
@@ -1096,13 +1069,22 @@ static int mirror_ctr(struct dm_target *
 	ti->private = ms;
  	ti->split_io = ms->rh.region_size;
 
+	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
+	if (!ms->kmirrord_wq) {
+		DMERR("couldn't start kmirrord");
+		free_context(ms, ti, m);
+		return -ENOMEM;
+	}
+	INIT_WORK(&ms->kmirrord_work, do_mirror);
+
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
 	if (r) {
+		destroy_workqueue(ms->kmirrord_wq);
 		free_context(ms, ti, ms->nr_mirrors);
 		return r;
 	}
 
-	add_mirror_set(ms);
+	wake(ms);
 	return 0;
 }
 
@@ -1110,8 +1092,9 @@ static void mirror_dtr(struct dm_target 
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
-	del_mirror_set(ms);
+	flush_workqueue(ms->kmirrord_wq);
 	kcopyd_client_destroy(ms->kcopyd_client);
+	destroy_workqueue(ms->kmirrord_wq);
 	free_context(ms, ti, ms->nr_mirrors);
 }
 
@@ -1127,7 +1110,7 @@ static void queue_bio(struct mirror_set 
 	spin_unlock(&ms->lock);
 
 	if (should_wake)
-		wake();
+		wake(ms);
 }
 
 /*
@@ -1270,20 +1253,11 @@ static int __init dm_mirror_init(void)
 	if (r)
 		return r;
 
-	_kmirrord_wq = create_singlethread_workqueue("kmirrord");
-	if (!_kmirrord_wq) {
-		DMERR("couldn't start kmirrord");
-		dm_dirty_log_exit();
-		return r;
-	}
-	INIT_WORK(&_kmirrord_work, do_work);
-
 	r = dm_register_target(&mirror_target);
 	if (r < 0) {
 		DMERR("%s: Failed to register mirror target",
 		      mirror_target.name);
 		dm_dirty_log_exit();
-		destroy_workqueue(_kmirrord_wq);
 	}
 
 	return r;
@@ -1297,7 +1271,6 @@ static void __exit dm_mirror_exit(void)
 	if (r < 0)
 		DMERR("%s: unregister failed %d", mirror_target.name, r);
 
-	destroy_workqueue(_kmirrord_wq);
 	dm_dirty_log_exit();
 }
 
