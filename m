Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760125AbYLQMe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbYLQMe0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbYLQM31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53744 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYLQM3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:22 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/24] GFS2: Fix "truncate in progress" hang
Date: Wed, 17 Dec 2008 11:30:14 +0000
Message-Id: <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Following on from the recent clean up of gfs2_quotad, this patch moves
the processing of "truncate in progress" inodes from the glock workqueue
into gfs2_quotad. This fixes a hang due to the "truncate in progress"
processing requiring glocks in order to complete.

It might seem odd to use gfs2_quotad for this particular item, but
we have to use a pre-existing thread since creating a thread implies
a GFP_KERNEL memory allocation which is not allowed from the glock
workqueue context. Of the existing threads, gfs2_logd and gfs2_recoverd
may deadlock if used for this operation. gfs2_scand and gfs2_glockd are
both scheduled for removal at some (hopefully not too distant) future
point. That leaves only gfs2_quotad whose workload is generally fairly
light and is easily adapted for this extra task.

Also, as a result of this change, it opens the way for a future patch to
make the reading of the inode's information asynchronous with respect to
the glock workqueue, which is another improvement that has been on the list
for some time now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 27cb9cc..4ddf3bd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -40,6 +40,7 @@
 #include "quota.h"
 #include "super.h"
 #include "util.h"
+#include "bmap.h"
 
 struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
@@ -289,7 +290,8 @@ static void gfs2_holder_wake(struct gfs2_holder *gh)
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
  * 
- * Returns: true if there is a blocked holder at the head of the list
+ * Returns: 1 if there is a blocked holder at the head of the list, or 2
+ *          if a type specific operation is underway.
  */
 
 static int do_promote(struct gfs2_glock *gl)
@@ -312,6 +314,8 @@ restart:
 				ret = glops->go_lock(gh);
 				spin_lock(&gl->gl_spin);
 				if (ret) {
+					if (ret == 1)
+						return 2;
 					gh->gh_error = ret;
 					list_del_init(&gh->gh_list);
 					gfs2_holder_wake(gh);
@@ -416,6 +420,7 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh;
 	unsigned state = ret & LM_OUT_ST_MASK;
+	int rv;
 
 	spin_lock(&gl->gl_spin);
 	state_change(gl, state);
@@ -470,7 +475,6 @@ retry:
 		gfs2_demote_wake(gl);
 	if (state != LM_ST_UNLOCKED) {
 		if (glops->go_xmote_bh) {
-			int rv;
 			spin_unlock(&gl->gl_spin);
 			rv = glops->go_xmote_bh(gl, gh);
 			if (rv == -EAGAIN)
@@ -481,10 +485,13 @@ retry:
 				goto out;
 			}
 		}
-		do_promote(gl);
+		rv = do_promote(gl);
+		if (rv == 2)
+			goto out_locked;
 	}
 out:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
+out_locked:
 	spin_unlock(&gl->gl_spin);
 	gfs2_glock_put(gl);
 }
@@ -584,6 +591,7 @@ __releases(&gl->gl_spin)
 __acquires(&gl->gl_spin)
 {
 	struct gfs2_holder *gh = NULL;
+	int ret;
 
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags))
 		return;
@@ -602,8 +610,11 @@ __acquires(&gl->gl_spin)
 	} else {
 		if (test_bit(GLF_DEMOTE, &gl->gl_flags))
 			gfs2_demote_wake(gl);
-		if (do_promote(gl) == 0)
+		ret = do_promote(gl);
+		if (ret == 0)
 			goto out;
+		if (ret == 2)
+			return;
 		gh = find_first_waiter(gl);
 		gl->gl_target = gh->gh_state;
 		if (!(gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
@@ -1556,6 +1567,20 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 	}
 }
 
+void gfs2_glock_finish_truncate(struct gfs2_inode *ip)
+{
+	struct gfs2_glock *gl = ip->i_gl;
+	int ret;
+
+	ret = gfs2_truncatei_resume(ip);
+	gfs2_assert_withdraw(gl->gl_sbd, ret == 0);
+
+	spin_lock(&gl->gl_spin);
+	clear_bit(GLF_LOCK, &gl->gl_flags);
+	run_queue(gl, 1);
+	spin_unlock(&gl->gl_spin);
+}
+
 static const char *state2str(unsigned state)
 {
 	switch(state) {
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 695c6b1..13a64ee 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -132,6 +132,7 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
 void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
+void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
 
 int __init gfs2_glock_init(void);
 void gfs2_glock_exit(void);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 68ee665..8ebff8e 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -227,6 +227,7 @@ static int inode_go_demote_ok(struct gfs2_glock *gl)
 static int inode_go_lock(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_inode *ip = gl->gl_object;
 	int error = 0;
 
@@ -241,8 +242,14 @@ static int inode_go_lock(struct gfs2_holder *gh)
 
 	if ((ip->i_diskflags & GFS2_DIF_TRUNC_IN_PROG) &&
 	    (gl->gl_state == LM_ST_EXCLUSIVE) &&
-	    (gh->gh_state == LM_ST_EXCLUSIVE))
-		error = gfs2_truncatei_resume(ip);
+	    (gh->gh_state == LM_ST_EXCLUSIVE)) {
+		spin_lock(&sdp->sd_trunc_lock);
+		if (list_empty(&ip->i_trunc_list))
+			list_add(&sdp->sd_trunc_list, &ip->i_trunc_list);
+		spin_unlock(&sdp->sd_trunc_lock);
+		wake_up(&sdp->sd_quota_wait);
+		return 1;
+	}
 
 	return error;
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index cfebc17..dd7d0f8 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -244,6 +244,7 @@ struct gfs2_inode {
 	struct gfs2_alloc *i_alloc;
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
+	struct list_head i_trunc_list;
 	u32 i_entries;
 	u32 i_diskflags;
 	u8 i_height;
@@ -550,6 +551,8 @@ struct gfs2_sbd {
 	spinlock_t sd_quota_spin;
 	struct mutex sd_quota_mutex;
 	wait_queue_head_t sd_quota_wait;
+	struct list_head sd_trunc_list;
+	spinlock_t sd_trunc_lock;
 
 	unsigned int sd_quota_slots;
 	unsigned int sd_quota_chunks;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index e3f6f18..cf39295 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -30,6 +30,7 @@ static void gfs2_init_inode_once(void *foo)
 
 	inode_init_once(&ip->i_inode);
 	init_rwsem(&ip->i_rw_mutex);
+	INIT_LIST_HEAD(&ip->i_trunc_list);
 	ip->i_alloc = NULL;
 }
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5d13706..a9a8380 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -107,6 +107,8 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	spin_lock_init(&sdp->sd_quota_spin);
 	mutex_init(&sdp->sd_quota_mutex);
 	init_waitqueue_head(&sdp->sd_quota_wait);
+	INIT_LIST_HEAD(&sdp->sd_trunc_list);
+	spin_lock_init(&sdp->sd_trunc_lock);
 
 	spin_lock_init(&sdp->sd_log_lock);
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 0cfe44f..b08d096 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1296,6 +1296,25 @@ static void quotad_check_timeo(struct gfs2_sbd *sdp, const char *msg,
 	}
 }
 
+static void quotad_check_trunc_list(struct gfs2_sbd *sdp)
+{
+	struct gfs2_inode *ip;
+
+	while(1) {
+		ip = NULL;
+		spin_lock(&sdp->sd_trunc_lock);
+		if (!list_empty(&sdp->sd_trunc_list)) {
+			ip = list_entry(sdp->sd_trunc_list.next,
+					struct gfs2_inode, i_trunc_list);
+			list_del_init(&ip->i_trunc_list);
+		}
+		spin_unlock(&sdp->sd_trunc_lock);
+		if (ip == NULL)
+			return;
+		gfs2_glock_finish_truncate(ip);
+	}
+}
+
 /**
  * gfs2_quotad - Write cached quota changes into the quota file
  * @sdp: Pointer to GFS2 superblock
@@ -1310,6 +1329,7 @@ int gfs2_quotad(void *data)
 	unsigned long quotad_timeo = 0;
 	unsigned long t = 0;
 	DEFINE_WAIT(wait);
+	int empty;
 
 	while (!kthread_should_stop()) {
 
@@ -1324,12 +1344,21 @@ int gfs2_quotad(void *data)
 		/* FIXME: This should be turned into a shrinker */
 		gfs2_quota_scan(sdp);
 
+		/* Check for & recover partially truncated inodes */
+		quotad_check_trunc_list(sdp);
+
 		if (freezing(current))
 			refrigerator();
 		t = min(quotad_timeo, statfs_timeo);
 
 		prepare_to_wait(&sdp->sd_quota_wait, &wait, TASK_UNINTERRUPTIBLE);
-		t -= schedule_timeout(t);
+		spin_lock(&sdp->sd_trunc_lock);
+		empty = list_empty(&sdp->sd_trunc_list);
+		spin_unlock(&sdp->sd_trunc_lock);
+		if (empty)
+			t -= schedule_timeout(t);
+		else
+			t = 0;
 		finish_wait(&sdp->sd_quota_wait, &wait);
 	}
 
-- 
1.6.0.3

