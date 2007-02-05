Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbXBEOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbXBEOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXBEOZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:25:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbXBEOZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:25:30 -0500
Subject: [GFS2] Remove the "greedy" function from glock.[ch] [30/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:33:32 +0000
Message-Id: <1170686012.11001.331.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 66089b47e0042bc5fc432017e2fd4abb519bec98 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 18 Jan 2007 17:44:20 +0000
Subject: [PATCH] [GFS2] Remove the "greedy" function from glock.[ch]

The "greedy" code was an attempt to retain glocks for a minimum length
of time when they relate to mmap()ed files. The current implementation
of this feature is not, however, ideal in that it required allocating
memory in order to do this and its overly complicated.

It also misses the mark by ignoring the other I/O operations which are
just as likely to suffer from the same problem. So the plan is to remove
this now and then add the functionality back as part of the glock state
machine at a later date (and thus take into account all the possible
users of this feature)

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5341e03..90847e0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -34,11 +34,6 @@
 #include "super.h"
 #include "util.h"
 
-struct greedy {
-	struct gfs2_holder gr_gh;
-	struct delayed_work gr_work;
-};
-
 struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
 };
@@ -618,30 +613,6 @@ static int rq_demote(struct gfs2_holder *gh)
 }
 
 /**
- * rq_greedy - process a queued request to drop greedy status
- * @gh: the glock holder
- *
- * Returns: 1 if the queue is blocked
- */
-
-static int rq_greedy(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-
-	list_del_init(&gh->gh_list);
-	/*  gh->gh_error never examined.  */
-	clear_bit(GLF_GREEDY, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
-
-	gfs2_holder_uninit(gh);
-	kfree(container_of(gh, struct greedy, gr_gh));
-
-	spin_lock(&gl->gl_spin);
-
-	return 0;
-}
-
-/**
  * run_queue - process holder structures on a glock
  * @gl: the glock
  *
@@ -671,8 +642,6 @@ static void run_queue(struct gfs2_glock *gl)
 
 			if (test_bit(HIF_DEMOTE, &gh->gh_iflags))
 				blocked = rq_demote(gh);
-			else if (test_bit(HIF_GREEDY, &gh->gh_iflags))
-				blocked = rq_greedy(gh);
 			else
 				gfs2_assert_warn(gl->gl_sbd, 0);
 
@@ -1336,68 +1305,6 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	spin_unlock(&gl->gl_spin);
 }
 
-static void greedy_work(struct work_struct *work)
-{
-	struct greedy *gr = container_of(work, struct greedy, gr_work.work);
-	struct gfs2_holder *gh = &gr->gr_gh;
-	struct gfs2_glock *gl = gh->gh_gl;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-
-	clear_bit(GLF_SKIP_WAITERS2, &gl->gl_flags);
-
-	if (glops->go_greedy)
-		glops->go_greedy(gl);
-
-	spin_lock(&gl->gl_spin);
-
-	if (list_empty(&gl->gl_waiters2)) {
-		clear_bit(GLF_GREEDY, &gl->gl_flags);
-		spin_unlock(&gl->gl_spin);
-		gfs2_holder_uninit(gh);
-		kfree(gr);
-	} else {
-		gfs2_glock_hold(gl);
-		list_add_tail(&gh->gh_list, &gl->gl_waiters2);
-		run_queue(gl);
-		spin_unlock(&gl->gl_spin);
-		gfs2_glock_put(gl);
-	}
-}
-
-/**
- * gfs2_glock_be_greedy -
- * @gl:
- * @time:
- *
- * Returns: 0 if go_greedy will be called, 1 otherwise
- */
-
-int gfs2_glock_be_greedy(struct gfs2_glock *gl, unsigned int time)
-{
-	struct greedy *gr;
-	struct gfs2_holder *gh;
-
-	if (!time || gl->gl_sbd->sd_args.ar_localcaching ||
-	    test_and_set_bit(GLF_GREEDY, &gl->gl_flags))
-		return 1;
-
-	gr = kmalloc(sizeof(struct greedy), GFP_KERNEL);
-	if (!gr) {
-		clear_bit(GLF_GREEDY, &gl->gl_flags);
-		return 1;
-	}
-	gh = &gr->gr_gh;
-
-	gfs2_holder_init(gl, 0, 0, gh);
-	set_bit(HIF_GREEDY, &gh->gh_iflags);
-	INIT_DELAYED_WORK(&gr->gr_work, greedy_work);
-
-	set_bit(GLF_SKIP_WAITERS2, &gl->gl_flags);
-	schedule_delayed_work(&gr->gr_work, time);
-
-	return 0;
-}
-
 /**
  * gfs2_glock_dq_uninit - dequeue a holder from a glock and initialize it
  * @gh: the holder structure
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index bde02a7..ddc56dc 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -92,8 +92,6 @@ int gfs2_glock_poll(struct gfs2_holder *gh);
 int gfs2_glock_wait(struct gfs2_holder *gh);
 void gfs2_glock_dq(struct gfs2_holder *gh);
 
-int gfs2_glock_be_greedy(struct gfs2_glock *gl, unsigned int time);
-
 void gfs2_glock_dq_uninit(struct gfs2_holder *gh);
 int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
 		      u64 number, const struct gfs2_glock_operations *glops,
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index b068d10..e4da26f 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -319,39 +319,6 @@ static void inode_go_unlock(struct gfs2_holder *gh)
 }
 
 /**
- * inode_greedy -
- * @gl: the glock
- *
- */
-
-static void inode_greedy(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct gfs2_inode *ip = gl->gl_object;
-	unsigned int quantum = gfs2_tune_get(sdp, gt_greedy_quantum);
-	unsigned int max = gfs2_tune_get(sdp, gt_greedy_max);
-	unsigned int new_time;
-
-	spin_lock(&ip->i_spin);
-
-	if (time_after(ip->i_last_pfault + quantum, jiffies)) {
-		new_time = ip->i_greedy + quantum;
-		if (new_time > max)
-			new_time = max;
-	} else {
-		new_time = ip->i_greedy - quantum;
-		if (!new_time || new_time > max)
-			new_time = 1;
-	}
-
-	ip->i_greedy = new_time;
-
-	spin_unlock(&ip->i_spin);
-
-	iput(&ip->i_inode);
-}
-
-/**
  * rgrp_go_demote_ok - Check to see if it's ok to unlock a RG's glock
  * @gl: the glock
  *
@@ -492,7 +459,6 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
 	.go_unlock = inode_go_unlock,
-	.go_greedy = inode_greedy,
 	.go_type = LM_TYPE_INODE,
 };
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a24c4af..dc024b1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -111,7 +111,6 @@ struct gfs2_glock_operations {
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
 	void (*go_callback) (struct gfs2_glock *gl, unsigned int state);
-	void (*go_greedy) (struct gfs2_glock *gl);
 	const int go_type;
 };
 
@@ -120,7 +119,6 @@ enum {
 	HIF_MUTEX		= 0,
 	HIF_PROMOTE		= 1,
 	HIF_DEMOTE		= 2,
-	HIF_GREEDY		= 3,
 
 	/* States */
 	HIF_ALLOCED		= 4,
@@ -149,7 +147,6 @@ enum {
 	GLF_STICKY		= 2,
 	GLF_DIRTY		= 5,
 	GLF_SKIP_WAITERS2	= 6,
-	GLF_GREEDY		= 7,
 };
 
 struct gfs2_glock {
@@ -166,7 +163,7 @@ struct gfs2_glock {
 	unsigned long gl_ip;
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
-	struct list_head gl_waiters2;	/* HIF_DEMOTE, HIF_GREEDY */
+	struct list_head gl_waiters2;	/* HIF_DEMOTE */
 	struct list_head gl_waiters3;	/* HIF_PROMOTE */
 
 	const struct gfs2_glock_operations *gl_ops;
@@ -235,7 +232,6 @@ struct gfs2_inode {
 
 	spinlock_t i_spin;
 	struct rw_semaphore i_rw_mutex;
-	unsigned int i_greedy;
 	unsigned long i_last_pfault;
 
 	struct buffer_head *i_cache[GFS2_MAX_META_HEIGHT];
@@ -423,9 +419,6 @@ struct gfs2_tune {
 	unsigned int gt_complain_secs;
 	unsigned int gt_reclaim_limit; /* Max num of glocks in reclaim list */
 	unsigned int gt_entries_per_readdir;
-	unsigned int gt_greedy_default;
-	unsigned int gt_greedy_quantum;
-	unsigned int gt_greedy_max;
 	unsigned int gt_statfs_quantum;
 	unsigned int gt_statfs_slow;
 };
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index c22738c..47369d0 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -452,14 +452,12 @@ out:
 
 static struct inode *gfs2_alloc_inode(struct super_block *sb)
 {
-	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_inode *ip;
 
 	ip = kmem_cache_alloc(gfs2_inode_cachep, GFP_KERNEL);
 	if (ip) {
 		ip->i_flags = 0;
 		ip->i_gl = NULL;
-		ip->i_greedy = gfs2_tune_get(sdp, gt_greedy_default);
 		ip->i_last_pfault = jiffies;
 	}
 	return &ip->i_inode;
diff --git a/fs/gfs2/ops_vm.c b/fs/gfs2/ops_vm.c
index 45a5f11..14b380f 100644
--- a/fs/gfs2/ops_vm.c
+++ b/fs/gfs2/ops_vm.c
@@ -28,34 +28,13 @@
 #include "trans.h"
 #include "util.h"
 
-static void pfault_be_greedy(struct gfs2_inode *ip)
-{
-	unsigned int time;
-
-	spin_lock(&ip->i_spin);
-	time = ip->i_greedy;
-	ip->i_last_pfault = jiffies;
-	spin_unlock(&ip->i_spin);
-
-	igrab(&ip->i_inode);
-	if (gfs2_glock_be_greedy(ip->i_gl, time))
-		iput(&ip->i_inode);
-}
-
 static struct page *gfs2_private_nopage(struct vm_area_struct *area,
 					unsigned long address, int *type)
 {
 	struct gfs2_inode *ip = GFS2_I(area->vm_file->f_mapping->host);
-	struct page *result;
 
 	set_bit(GIF_PAGED, &ip->i_flags);
-
-	result = filemap_nopage(area, address, type);
-
-	if (result && result != NOPAGE_OOM)
-		pfault_be_greedy(ip);
-
-	return result;
+	return filemap_nopage(area, address, type);
 }
 
 static int alloc_page_backing(struct gfs2_inode *ip, struct page *page)
@@ -167,7 +146,6 @@ static struct page *gfs2_sharewrite_nopage(struct vm_area_struct *area,
 		set_page_dirty(result);
 	}
 
-	pfault_be_greedy(ip);
 out:
 	gfs2_glock_dq_uninit(&i_gh);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3e17dcf..ce5353a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -77,9 +77,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_complain_secs = 10;
 	gt->gt_reclaim_limit = 5000;
 	gt->gt_entries_per_readdir = 32;
-	gt->gt_greedy_default = HZ / 10;
-	gt->gt_greedy_quantum = HZ / 40;
-	gt->gt_greedy_max = HZ / 4;
 	gt->gt_statfs_quantum = 30;
 	gt->gt_statfs_slow = 0;
 }
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 1120611..d01f9f0 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -442,9 +442,6 @@ TUNE_ATTR(new_files_directio, 0);
 TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(quota_cache_secs, 1);
 TUNE_ATTR(stall_secs, 1);
-TUNE_ATTR(greedy_default, 1);
-TUNE_ATTR(greedy_quantum, 1);
-TUNE_ATTR(greedy_max, 1);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_DAEMON(scand_secs, scand_process);
 TUNE_ATTR_DAEMON(recoverd_secs, recoverd_process);
@@ -467,9 +464,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_quota_cache_secs.attr,
 	&tune_attr_stall_secs.attr,
-	&tune_attr_greedy_default.attr,
-	&tune_attr_greedy_quantum.attr,
-	&tune_attr_greedy_max.attr,
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_scand_secs.attr,
 	&tune_attr_recoverd_secs.attr,
-- 
1.4.4.2



