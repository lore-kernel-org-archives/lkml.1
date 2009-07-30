Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZG3MrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZG3MrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZG3Mqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZG3Mqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 7/7] GFS2: remove dcache entries for remote deleted inodes
Date: Thu, 30 Jul 2009 14:45:24 +0100
Message-Id: <1248961524-30913-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-7-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-5-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-6-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When a file is deleted from a gfs2 filesystem on one node, a dcache
entry for it may still exist on other nodes in the cluster. If this
happens, gfs2 will be unable to free this file on disk. Because of this,
it's possible to have a gfs2 filesystem with no files on it and no free
space. With this patch, when a node receives a callback notifying it
that the file is being deleted on another node, it schedules a new
workqueue thread to remove the file's dcache entry.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c  |   43 ++++++++++++++++++++++++++++++++++++++-----
 fs/gfs2/glock.h  |    3 +++
 fs/gfs2/glops.c  |   21 +++++++++++++++++++++
 fs/gfs2/incore.h |    2 ++
 fs/gfs2/super.c  |    1 +
 5 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f041a89..8b674b1 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -63,6 +63,7 @@ static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
+struct workqueue_struct *gfs2_delete_workqueue;
 static LIST_HEAD(lru_list);
 static atomic_t lru_count = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(lru_lock);
@@ -167,7 +168,7 @@ static void glock_free(struct gfs2_glock *gl)
  *
  */
 
-static void gfs2_glock_hold(struct gfs2_glock *gl)
+void gfs2_glock_hold(struct gfs2_glock *gl)
 {
 	GLOCK_BUG_ON(gl, atomic_read(&gl->gl_ref) == 0);
 	atomic_inc(&gl->gl_ref);
@@ -222,7 +223,7 @@ static void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
  * to the glock, in addition to the one it is dropping.
  */
 
-static void gfs2_glock_put_nolock(struct gfs2_glock *gl)
+void gfs2_glock_put_nolock(struct gfs2_glock *gl)
 {
 	if (atomic_dec_and_test(&gl->gl_ref))
 		GLOCK_BUG_ON(gl, 1);
@@ -679,6 +680,29 @@ out_unlock:
 	goto out;
 }
 
+static void delete_work_func(struct work_struct *work)
+{
+	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_delete);
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_inode *ip = NULL;
+	struct inode *inode;
+	u64 no_addr = 0;
+
+	spin_lock(&gl->gl_spin);
+	ip = (struct gfs2_inode *)gl->gl_object;
+	if (ip)
+		no_addr = ip->i_no_addr;
+	spin_unlock(&gl->gl_spin);
+	if (ip) {
+		inode = gfs2_ilookup(sdp->sd_vfs, no_addr);
+		if (inode) {
+			d_prune_aliases(inode);
+			iput(inode);
+		}
+	}
+	gfs2_glock_put(gl);
+}
+
 static void glock_work_func(struct work_struct *work)
 {
 	unsigned long delay = 0;
@@ -757,6 +781,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_sbd = sdp;
 	gl->gl_aspace = NULL;
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
+	INIT_WORK(&gl->gl_delete, delete_work_func);
 
 	/* If this glock protects actual on-disk data or metadata blocks,
 	   create a VFS inode to manage the pages/buffers holding them. */
@@ -898,6 +923,8 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 			gl->gl_demote_state != state) {
 		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
+	if (gl->gl_ops->go_callback)
+		gl->gl_ops->go_callback(gl);
 	trace_gfs2_demote_rq(gl);
 }
 
@@ -1344,14 +1371,14 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 			spin_unlock(&lru_lock);
 			spin_lock(&gl->gl_spin);
 			may_demote = demote_ok(gl);
-			spin_unlock(&gl->gl_spin);
-			clear_bit(GLF_LOCK, &gl->gl_flags);
 			if (may_demote) {
 				handle_callback(gl, LM_ST_UNLOCKED, 0);
 				nr--;
 			}
 			if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-				gfs2_glock_put(gl);
+				gfs2_glock_put_nolock(gl);
+			spin_unlock(&gl->gl_spin);
+			clear_bit(GLF_LOCK, &gl->gl_flags);
 			spin_lock(&lru_lock);
 			continue;
 		}
@@ -1738,6 +1765,11 @@ int __init gfs2_glock_init(void)
 	glock_workqueue = create_workqueue("glock_workqueue");
 	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
+	gfs2_delete_workqueue = create_workqueue("delete_workqueue");
+	if (IS_ERR(gfs2_delete_workqueue)) {
+		destroy_workqueue(glock_workqueue);
+		return PTR_ERR(gfs2_delete_workqueue);
+	}
 
 	register_shrinker(&glock_shrinker);
 
@@ -1748,6 +1780,7 @@ void gfs2_glock_exit(void)
 {
 	unregister_shrinker(&glock_shrinker);
 	destroy_workqueue(glock_workqueue);
+	destroy_workqueue(gfs2_delete_workqueue);
 }
 
 static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index a602a28..c609894 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -143,6 +143,7 @@ struct lm_lockops {
 
 #define GLR_TRYFAILED		13
 
+extern struct workqueue_struct *gfs2_delete_workqueue;
 static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
 {
 	struct gfs2_holder *gh;
@@ -191,6 +192,8 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
 int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   u64 number, const struct gfs2_glock_operations *glops,
 		   int create, struct gfs2_glock **glp);
+void gfs2_glock_hold(struct gfs2_glock *gl);
+void gfs2_glock_put_nolock(struct gfs2_glock *gl);
 int gfs2_glock_put(struct gfs2_glock *gl);
 void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 		      struct gfs2_holder *gh);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index d5e4ab1..6985eef 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -323,6 +323,7 @@ static void trans_go_sync(struct gfs2_glock *gl)
 
 	if (gl->gl_state != LM_ST_UNLOCKED &&
 	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
+		flush_workqueue(gfs2_delete_workqueue);
 		gfs2_meta_syncfs(sdp);
 		gfs2_log_shutdown(sdp);
 	}
@@ -372,6 +373,25 @@ static int trans_go_demote_ok(const struct gfs2_glock *gl)
 	return 0;
 }
 
+/**
+ * iopen_go_callback - schedule the dcache entry for the inode to be deleted
+ * @gl: the glock
+ *
+ * gl_spin lock is held while calling this
+ */
+static void iopen_go_callback(struct gfs2_glock *gl)
+{
+	struct gfs2_inode *ip = (struct gfs2_inode *)gl->gl_object;
+
+	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
+	    gl->gl_state == LM_ST_SHARED &&
+	    ip && test_bit(GIF_USER, &ip->i_flags)) {
+		gfs2_glock_hold(gl);
+		if (queue_work(gfs2_delete_workqueue, &gl->gl_delete) == 0)
+			gfs2_glock_put_nolock(gl);
+	}
+}
+
 const struct gfs2_glock_operations gfs2_meta_glops = {
 	.go_type = LM_TYPE_META,
 };
@@ -406,6 +426,7 @@ const struct gfs2_glock_operations gfs2_trans_glops = {
 
 const struct gfs2_glock_operations gfs2_iopen_glops = {
 	.go_type = LM_TYPE_IOPEN,
+	.go_callback = iopen_go_callback,
 };
 
 const struct gfs2_glock_operations gfs2_flock_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 225347f..61801ad 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -159,6 +159,7 @@ struct gfs2_glock_operations {
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
 	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
+	void (*go_callback) (struct gfs2_glock *gl);
 	const int go_type;
 	const unsigned long go_min_hold_time;
 };
@@ -228,6 +229,7 @@ struct gfs2_glock {
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
 	struct delayed_work gl_work;
+	struct work_struct gl_delete;
 };
 
 #define GFS2_MIN_LVB_SIZE 32	/* Min size of LVB that gfs2 supports */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 552e321..f522bb0 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -691,6 +691,7 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	struct gfs2_holder t_gh;
 	int error;
 
+	flush_workqueue(gfs2_delete_workqueue);
 	gfs2_quota_sync(sdp);
 	gfs2_statfs_sync(sdp);
 
-- 
1.6.2.2

