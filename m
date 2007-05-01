Return-Path: <linux-kernel-owner+w=401wt.eu-S1031651AbXEAKGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031651AbXEAKGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031648AbXEAKGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031650AbXEAKGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:06:38 -0400
Subject: [GFS2] Fix bz 224480 and cleanup glock demotion code [5/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:02:04 +0100
Message-Id: <1178013724.5462.136.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3b8249f6178cb2b68b9d683587797270125cc06a Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 16 Mar 2007 09:40:31 +0000
Subject: [PATCH] [GFS2] Fix bz 224480 and cleanup glock demotion code

This patch prevents the printing of a warning message in cases where
the fs is functioning normally by handing off responsibility for
unlinked, but still open inodes, to another node for eventual deallocation.
Also, there is now an improved system for ensuring that such requests
to other nodes do not get lost. The callback on the iopen lock is
only ever called when i_nlink == 0 and when a node is unable to deallocate
it due to it still being in use on another node. When a node receives
the callback therefore, it knows that i_nlink must be zero, so we mark
it as such (in gfs2_drop_inode) in order that it will then attempt
deallocation of the inode itself.

As an additional benefit, queuing a demote request no longer requires
a memory allocation. This simplifies the code for dealing with gfs2_holders
as it removes one special case.

There are two new fields in struct gfs2_glock. gl_demote_state is the
state which the remote node has requested and gl_demote_time is the
time when the request came in. Both fields are only valid when the
GLF_DEMOTE flag is set in gl_flags.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a3a24f2..e707594 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -54,7 +54,7 @@ struct glock_iter {
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
-static void gfs2_glock_xmote_th(struct gfs2_holder *gh);
+static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh);
 static void gfs2_glock_drop_th(struct gfs2_glock *gl);
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
@@ -212,7 +212,6 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 		gfs2_assert(sdp, list_empty(&gl->gl_reclaim));
 		gfs2_assert(sdp, list_empty(&gl->gl_holders));
 		gfs2_assert(sdp, list_empty(&gl->gl_waiters1));
-		gfs2_assert(sdp, list_empty(&gl->gl_waiters2));
 		gfs2_assert(sdp, list_empty(&gl->gl_waiters3));
 		glock_free(gl);
 		rv = 1;
@@ -399,7 +398,7 @@ void gfs2_holder_reinit(unsigned int state, unsigned flags, struct gfs2_holder *
 {
 	gh->gh_state = state;
 	gh->gh_flags = flags;
-	gh->gh_iflags &= 1 << HIF_ALLOCED;
+	gh->gh_iflags = 0;
 	gh->gh_ip = (unsigned long)__builtin_return_address(0);
 }
 
@@ -416,54 +415,8 @@ void gfs2_holder_uninit(struct gfs2_holder *gh)
 	gh->gh_ip = 0;
 }
 
-/**
- * gfs2_holder_get - get a struct gfs2_holder structure
- * @gl: the glock
- * @state: the state we're requesting
- * @flags: the modifier flags
- * @gfp_flags:
- *
- * Figure out how big an impact this function has.  Either:
- * 1) Replace it with a cache of structures hanging off the struct gfs2_sbd
- * 2) Leave it like it is
- *
- * Returns: the holder structure, NULL on ENOMEM
- */
-
-static struct gfs2_holder *gfs2_holder_get(struct gfs2_glock *gl,
-					   unsigned int state,
-					   int flags, gfp_t gfp_flags)
-{
-	struct gfs2_holder *gh;
-
-	gh = kmalloc(sizeof(struct gfs2_holder), gfp_flags);
-	if (!gh)
-		return NULL;
-
-	gfs2_holder_init(gl, state, flags, gh);
-	set_bit(HIF_ALLOCED, &gh->gh_iflags);
-	gh->gh_ip = (unsigned long)__builtin_return_address(0);
-	return gh;
-}
-
-/**
- * gfs2_holder_put - get rid of a struct gfs2_holder structure
- * @gh: the holder structure
- *
- */
-
-static void gfs2_holder_put(struct gfs2_holder *gh)
-{
-	gfs2_holder_uninit(gh);
-	kfree(gh);
-}
-
-static void gfs2_holder_dispose_or_wake(struct gfs2_holder *gh)
+static void gfs2_holder_wake(struct gfs2_holder *gh)
 {
-	if (test_bit(HIF_DEALLOC, &gh->gh_iflags)) {
-		gfs2_holder_put(gh);
-		return;
-	}
 	clear_bit(HIF_WAIT, &gh->gh_iflags);
 	smp_mb();
 	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
@@ -529,7 +482,7 @@ static int rq_promote(struct gfs2_holder *gh)
 				gfs2_reclaim_glock(sdp);
 			}
 
-			gfs2_glock_xmote_th(gh);
+			gfs2_glock_xmote_th(gh->gh_gl, gh);
 			spin_lock(&gl->gl_spin);
 		}
 		return 1;
@@ -552,7 +505,7 @@ static int rq_promote(struct gfs2_holder *gh)
 	gh->gh_error = 0;
 	set_bit(HIF_HOLDER, &gh->gh_iflags);
 
-	gfs2_holder_dispose_or_wake(gh);
+	gfs2_holder_wake(gh);
 
 	return 0;
 }
@@ -564,32 +517,24 @@ static int rq_promote(struct gfs2_holder *gh)
  * Returns: 1 if the queue is blocked
  */
 
-static int rq_demote(struct gfs2_holder *gh)
+static int rq_demote(struct gfs2_glock *gl)
 {
-	struct gfs2_glock *gl = gh->gh_gl;
-
 	if (!list_empty(&gl->gl_holders))
 		return 1;
 
-	if (gl->gl_state == gh->gh_state || gl->gl_state == LM_ST_UNLOCKED) {
-		list_del_init(&gh->gh_list);
-		gh->gh_error = 0;
-		spin_unlock(&gl->gl_spin);
-		gfs2_holder_dispose_or_wake(gh);
-		spin_lock(&gl->gl_spin);
-	} else {
-		gl->gl_req_gh = gh;
-		set_bit(GLF_LOCK, &gl->gl_flags);
-		spin_unlock(&gl->gl_spin);
-
-		if (gh->gh_state == LM_ST_UNLOCKED ||
-		    gl->gl_state != LM_ST_EXCLUSIVE)
-			gfs2_glock_drop_th(gl);
-		else
-			gfs2_glock_xmote_th(gh);
-
-		spin_lock(&gl->gl_spin);
+	if (gl->gl_state == gl->gl_demote_state ||
+	    gl->gl_state == LM_ST_UNLOCKED) {
+		clear_bit(GLF_DEMOTE, &gl->gl_flags);
+		return 0;
 	}
+	set_bit(GLF_LOCK, &gl->gl_flags);
+	spin_unlock(&gl->gl_spin);
+	if (gl->gl_demote_state == LM_ST_UNLOCKED ||
+	    gl->gl_state != LM_ST_EXCLUSIVE)
+		gfs2_glock_drop_th(gl);
+	else
+		gfs2_glock_xmote_th(gl, NULL);
+	spin_lock(&gl->gl_spin);
 
 	return 0;
 }
@@ -617,16 +562,8 @@ static void run_queue(struct gfs2_glock *gl)
 			else
 				gfs2_assert_warn(gl->gl_sbd, 0);
 
-		} else if (!list_empty(&gl->gl_waiters2) &&
-			   !test_bit(GLF_SKIP_WAITERS2, &gl->gl_flags)) {
-			gh = list_entry(gl->gl_waiters2.next,
-					struct gfs2_holder, gh_list);
-
-			if (test_bit(HIF_DEMOTE, &gh->gh_iflags))
-				blocked = rq_demote(gh);
-			else
-				gfs2_assert_warn(gl->gl_sbd, 0);
-
+		} else if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
+			blocked = rq_demote(gl);
 		} else if (!list_empty(&gl->gl_waiters3)) {
 			gh = list_entry(gl->gl_waiters3.next,
 					struct gfs2_holder, gh_list);
@@ -717,50 +654,24 @@ static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
 }
 
 /**
- * handle_callback - add a demote request to a lock's queue
+ * handle_callback - process a demote request
  * @gl: the glock
  * @state: the state the caller wants us to change to
  *
- * Note: This may fail sliently if we are out of memory.
+ * There are only two requests that we are going to see in actual
+ * practise: LM_ST_SHARED and LM_ST_UNLOCKED
  */
 
 static void handle_callback(struct gfs2_glock *gl, unsigned int state)
 {
-	struct gfs2_holder *gh, *new_gh = NULL;
-
-restart:
 	spin_lock(&gl->gl_spin);
-
-	list_for_each_entry(gh, &gl->gl_waiters2, gh_list) {
-		if (test_bit(HIF_DEMOTE, &gh->gh_iflags) &&
-		    gl->gl_req_gh != gh) {
-			if (gh->gh_state != state)
-				gh->gh_state = LM_ST_UNLOCKED;
-			goto out;
-		}
-	}
-
-	if (new_gh) {
-		list_add_tail(&new_gh->gh_list, &gl->gl_waiters2);
-		new_gh = NULL;
-	} else {
-		spin_unlock(&gl->gl_spin);
-
-		new_gh = gfs2_holder_get(gl, state, LM_FLAG_TRY, GFP_NOFS);
-		if (!new_gh)
-			return;
-		set_bit(HIF_DEMOTE, &new_gh->gh_iflags);
-		set_bit(HIF_DEALLOC, &new_gh->gh_iflags);
-		set_bit(HIF_WAIT, &new_gh->gh_iflags);
-
-		goto restart;
+	if (test_and_set_bit(GLF_DEMOTE, &gl->gl_flags) == 0) {
+		gl->gl_demote_state = state;
+		gl->gl_demote_time = jiffies;
+	} else if (gl->gl_demote_state != LM_ST_UNLOCKED) {
+		gl->gl_demote_state = state;
 	}
-
-out:
 	spin_unlock(&gl->gl_spin);
-
-	if (new_gh)
-		gfs2_holder_put(new_gh);
 }
 
 /**
@@ -820,56 +731,37 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	/*  Deal with each possible exit condition  */
 
-	if (!gh)
+	if (!gh) {
 		gl->gl_stamp = jiffies;
-	else if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (ret & LM_OUT_CANCELED)
+			op_done = 0;
+		else
+			clear_bit(GLF_DEMOTE, &gl->gl_flags);
+	} else {
 		spin_lock(&gl->gl_spin);
 		list_del_init(&gh->gh_list);
 		gh->gh_error = -EIO;
-		spin_unlock(&gl->gl_spin);
-	} else if (test_bit(HIF_DEMOTE, &gh->gh_iflags)) {
-		spin_lock(&gl->gl_spin);
-		list_del_init(&gh->gh_list);
-		if (gl->gl_state == gh->gh_state ||
-		    gl->gl_state == LM_ST_UNLOCKED) {
+		if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) 
+			goto out;
+		gh->gh_error = GLR_CANCELED;
+		if (ret & LM_OUT_CANCELED) 
+			goto out;
+		if (relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
+			list_add_tail(&gh->gh_list, &gl->gl_holders);
 			gh->gh_error = 0;
-		} else {
-			if (gfs2_assert_warn(sdp, gh->gh_flags &
-					(LM_FLAG_TRY | LM_FLAG_TRY_1CB)) == -1)
-				fs_warn(sdp, "ret = 0x%.8X\n", ret);
-			gh->gh_error = GLR_TRYFAILED;
+			set_bit(HIF_HOLDER, &gh->gh_iflags);
+			set_bit(HIF_FIRST, &gh->gh_iflags);
+			op_done = 0;
+			goto out;
 		}
-		spin_unlock(&gl->gl_spin);
-
-		if (ret & LM_OUT_CANCELED)
-			handle_callback(gl, LM_ST_UNLOCKED);
-
-	} else if (ret & LM_OUT_CANCELED) {
-		spin_lock(&gl->gl_spin);
-		list_del_init(&gh->gh_list);
-		gh->gh_error = GLR_CANCELED;
-		spin_unlock(&gl->gl_spin);
-
-	} else if (relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
-		spin_lock(&gl->gl_spin);
-		list_move_tail(&gh->gh_list, &gl->gl_holders);
-		gh->gh_error = 0;
-		set_bit(HIF_HOLDER, &gh->gh_iflags);
-		spin_unlock(&gl->gl_spin);
-
-		set_bit(HIF_FIRST, &gh->gh_iflags);
-
-		op_done = 0;
-
-	} else if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		spin_lock(&gl->gl_spin);
-		list_del_init(&gh->gh_list);
 		gh->gh_error = GLR_TRYFAILED;
-		spin_unlock(&gl->gl_spin);
-
-	} else {
+		if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))
+			goto out;
+		gh->gh_error = -EINVAL;
 		if (gfs2_assert_withdraw(sdp, 0) == -1)
 			fs_err(sdp, "ret = 0x%.8X\n", ret);
+out:
+		spin_unlock(&gl->gl_spin);
 	}
 
 	if (glops->go_xmote_bh)
@@ -887,7 +779,7 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 	gfs2_glock_put(gl);
 
 	if (gh)
-		gfs2_holder_dispose_or_wake(gh);
+		gfs2_holder_wake(gh);
 }
 
 /**
@@ -898,12 +790,11 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
  *
  */
 
-void gfs2_glock_xmote_th(struct gfs2_holder *gh)
+void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 {
-	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	int flags = gh->gh_flags;
-	unsigned state = gh->gh_state;
+	int flags = gh ? gh->gh_flags : 0;
+	unsigned state = gh ? gh->gh_state : gl->gl_demote_state;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	int lck_flags = flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB |
 				 LM_FLAG_NOEXP | LM_FLAG_ANY |
@@ -953,6 +844,7 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	gfs2_assert_warn(sdp, !ret);
 
 	state_change(gl, LM_ST_UNLOCKED);
+	clear_bit(GLF_DEMOTE, &gl->gl_flags);
 
 	if (glops->go_inval)
 		glops->go_inval(gl, DIO_METADATA);
@@ -974,7 +866,7 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	gfs2_glock_put(gl);
 
 	if (gh)
-		gfs2_holder_dispose_or_wake(gh);
+		gfs2_holder_wake(gh);
 }
 
 /**
@@ -1291,9 +1183,8 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		if (glops->go_unlock)
 			glops->go_unlock(gh);
 
-		gl->gl_stamp = jiffies;
-
 		spin_lock(&gl->gl_spin);
+		gl->gl_stamp = jiffies;
 	}
 
 	clear_bit(GLF_LOCK, &gl->gl_flags);
@@ -1981,16 +1872,16 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 		if (error)
 			goto out;
 	}
-	list_for_each_entry(gh, &gl->gl_waiters2, gh_list) {
-		error = dump_holder(gi, "Waiter2", gh);
-		if (error)
-			goto out;
-	}
 	list_for_each_entry(gh, &gl->gl_waiters3, gh_list) {
 		error = dump_holder(gi, "Waiter3", gh);
 		if (error)
 			goto out;
 	}
+	if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
+		print_dbg(gi, "  Demotion req to state %u (%llu uS ago)\n",
+			  gl->gl_demote_state,
+			  (u64)(jiffies - gl->gl_demote_time)*1000000/HZ);
+	}
 	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object) {
 		if (!test_bit(GLF_LOCK, &gl->gl_flags) &&
 			list_empty(&gl->gl_holders)) {
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index d7cef74..5e662ea 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -67,7 +67,7 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
 {
 	int ret;
 	spin_lock(&gl->gl_spin);
-	ret = !list_empty(&gl->gl_waiters2) || !list_empty(&gl->gl_waiters3);
+	ret = test_bit(GLF_DEMOTE, &gl->gl_flags) || !list_empty(&gl->gl_waiters3);
 	spin_unlock(&gl->gl_spin);
 	return ret;
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 7555261..9c12582 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -115,11 +115,8 @@ enum {
 	/* Actions */
 	HIF_MUTEX		= 0,
 	HIF_PROMOTE		= 1,
-	HIF_DEMOTE		= 2,
 
 	/* States */
-	HIF_ALLOCED		= 4,
-	HIF_DEALLOC		= 5,
 	HIF_HOLDER		= 6,
 	HIF_FIRST		= 7,
 	HIF_ABORTED		= 9,
@@ -142,8 +139,8 @@ struct gfs2_holder {
 enum {
 	GLF_LOCK		= 1,
 	GLF_STICKY		= 2,
+	GLF_DEMOTE		= 3,
 	GLF_DIRTY		= 5,
-	GLF_SKIP_WAITERS2	= 6,
 };
 
 struct gfs2_glock {
@@ -156,11 +153,12 @@ struct gfs2_glock {
 
 	unsigned int gl_state;
 	unsigned int gl_hash;
+	unsigned int gl_demote_state; /* state requested by remote node */
+	unsigned long gl_demote_time; /* time of first demote request */
 	struct task_struct *gl_owner;
 	unsigned long gl_ip;
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
-	struct list_head gl_waiters2;	/* HIF_DEMOTE */
 	struct list_head gl_waiters3;	/* HIF_PROMOTE */
 
 	const struct gfs2_glock_operations *gl_ops;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 2183953..c4bb374 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -45,7 +45,6 @@ static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned
 		spin_lock_init(&gl->gl_spin);
 		INIT_LIST_HEAD(&gl->gl_holders);
 		INIT_LIST_HEAD(&gl->gl_waiters1);
-		INIT_LIST_HEAD(&gl->gl_waiters2);
 		INIT_LIST_HEAD(&gl->gl_waiters3);
 		gl->gl_lvb = NULL;
 		atomic_set(&gl->gl_lvb_count, 0);
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index b89999d..485ce3d 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -284,6 +284,31 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 }
 
 /**
+ * gfs2_drop_inode - Drop an inode (test for remote unlink)
+ * @inode: The inode to drop
+ *
+ * If we've received a callback on an iopen lock then its because a
+ * remote node tried to deallocate the inode but failed due to this node
+ * still having the inode open. Here we mark the link count zero
+ * since we know that it must have reached zero if the GLF_DEMOTE flag
+ * is set on the iopen glock. If we didn't do a disk read since the
+ * remote node removed the final link then we might otherwise miss
+ * this event. This check ensures that this node will deallocate the
+ * inode's blocks, or alternatively pass the baton on to another
+ * node for later deallocation.
+ */
+static void gfs2_drop_inode(struct inode *inode)
+{
+	if (inode->i_private && inode->i_nlink) {
+		struct gfs2_inode *ip = GFS2_I(inode);
+		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
+		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
+			clear_nlink(inode);
+	}
+	generic_drop_inode(inode);
+}
+
+/**
  * gfs2_clear_inode - Deallocate an inode when VFS is done with it
  * @inode: The VFS inode
  *
@@ -441,7 +466,7 @@ out_unlock:
 out_uninit:
 	gfs2_holder_uninit(&ip->i_iopen_gh);
 	gfs2_glock_dq_uninit(&gh);
-	if (error)
+	if (error && error != GLR_TRYFAILED)
 		fs_warn(sdp, "gfs2_delete_inode: %d\n", error);
 out:
 	truncate_inode_pages(&inode->i_data, 0);
@@ -481,6 +506,7 @@ const struct super_operations gfs2_super_ops = {
 	.statfs			= gfs2_statfs,
 	.remount_fs		= gfs2_remount_fs,
 	.clear_inode		= gfs2_clear_inode,
+	.drop_inode		= gfs2_drop_inode,
 	.show_options		= gfs2_show_options,
 };
 
-- 
1.5.1.2



