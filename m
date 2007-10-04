Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXJDJ3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXJDJ3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbXJDJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbXJDJSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:10 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 30/51] [GFS2] delay glock demote for a minimum hold time
Date: Thu,  4 Oct 2007 09:49:23 +0100
Message-Id: <1191487846406-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487844772-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When a lot of IO, with some distributed mmap IO, is run on a GFS2 filesystem in
a cluster, it will deadlock. The reason is that do_no_page() will repeatedly
call gfs2_sharewrite_nopage(), because each node keeps giving up the glock
too early, and is forced to call unmap_mapping_range(). This bumps the
mapping->truncate_count sequence count, forcing do_no_page() to retry. This
patch institutes a minimum glock hold time a tenth a second.  This insures
that even in heavy contention cases, the node has enough time to get some
useful work done before it gives up the glock.

A second issue is that when gfs2_glock_dq() is called from within a page fault
to demote a lock, and the associated page needs to be written out, it will
try to acqire a lock on it, but it has already been locked at a higher level.
This patch puts makes gfs2_glock_dq() use the work queue as well, to avoid this
issue. This is the same patch as Steve Whitehouse originally proposed to fix
this issue, execpt that gfs2_glock_dq() now grabs a reference to the glock
before it queues up the work on it.

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3d94918..931368a 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -27,6 +27,8 @@
 #include <linux/debugfs.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -58,10 +60,13 @@ static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
 static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl);
 static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh);
 static void gfs2_glock_drop_th(struct gfs2_glock *gl);
+static void run_queue(struct gfs2_glock *gl);
+
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
 static struct task_struct *scand_process;
 static unsigned int scand_secs = 5;
+static struct workqueue_struct *glock_workqueue;
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
@@ -277,6 +282,18 @@ static struct gfs2_glock *gfs2_glock_find(const struct gfs2_sbd *sdp,
 	return gl;
 }
 
+static void glock_work_func(struct work_struct *work)
+{
+	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_work.work);
+
+	spin_lock(&gl->gl_spin);
+	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags))
+		set_bit(GLF_DEMOTE, &gl->gl_flags);
+	run_queue(gl);
+	spin_unlock(&gl->gl_spin);
+	gfs2_glock_put(gl);
+}
+
 /**
  * gfs2_glock_get() - Get a glock, or create one if one doesn't exist
  * @sdp: The GFS2 superblock
@@ -316,6 +333,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_name = name;
 	atomic_set(&gl->gl_ref, 1);
 	gl->gl_state = LM_ST_UNLOCKED;
+	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	gl->gl_hash = hash;
 	gl->gl_owner_pid = 0;
 	gl->gl_ip = 0;
@@ -324,10 +342,12 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_req_bh = NULL;
 	gl->gl_vn = 0;
 	gl->gl_stamp = jiffies;
+	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
 	gl->gl_sbd = sdp;
 	gl->gl_aspace = NULL;
 	lops_init_le(&gl->gl_le, &gfs2_glock_lops);
+	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
 
 	/* If this glock protects actual on-disk data or metadata blocks,
 	   create a VFS inode to manage the pages/buffers holding them. */
@@ -441,6 +461,8 @@ static void wait_on_holder(struct gfs2_holder *gh)
 
 static void gfs2_demote_wake(struct gfs2_glock *gl)
 {
+	BUG_ON(!spin_is_locked(&gl->gl_spin));
+	gl->gl_demote_state = LM_ST_EXCLUSIVE;
         clear_bit(GLF_DEMOTE, &gl->gl_flags);
         smp_mb__after_clear_bit();
         wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
@@ -682,10 +704,14 @@ static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
  * practise: LM_ST_SHARED and LM_ST_UNLOCKED
  */
 
-static void handle_callback(struct gfs2_glock *gl, unsigned int state, int remote)
+static void handle_callback(struct gfs2_glock *gl, unsigned int state,
+			    int remote, unsigned long delay)
 {
+	int bit = delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE;
+
 	spin_lock(&gl->gl_spin);
-	if (test_and_set_bit(GLF_DEMOTE, &gl->gl_flags) == 0) {
+	set_bit(bit, &gl->gl_flags);
+	if (gl->gl_demote_state == LM_ST_EXCLUSIVE) {
 		gl->gl_demote_state = state;
 		gl->gl_demote_time = jiffies;
 		if (remote && gl->gl_ops->go_type == LM_TYPE_IOPEN &&
@@ -727,6 +753,7 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 	}
 
 	gl->gl_state = new_state;
+	gl->gl_tchange = jiffies;
 }
 
 /**
@@ -813,7 +840,6 @@ out:
 		gl->gl_req_gh = NULL;
 		gl->gl_req_bh = NULL;
 		clear_bit(GLF_LOCK, &gl->gl_flags);
-		run_queue(gl);
 		spin_unlock(&gl->gl_spin);
 	}
 
@@ -885,7 +911,6 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	gfs2_assert_warn(sdp, !ret);
 
 	state_change(gl, LM_ST_UNLOCKED);
-	gfs2_demote_wake(gl);
 
 	if (glops->go_inval)
 		glops->go_inval(gl, DIO_METADATA);
@@ -898,10 +923,10 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	}
 
 	spin_lock(&gl->gl_spin);
+	gfs2_demote_wake(gl);
 	gl->gl_req_gh = NULL;
 	gl->gl_req_bh = NULL;
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	run_queue(gl);
 	spin_unlock(&gl->gl_spin);
 
 	gfs2_glock_put(gl);
@@ -1209,9 +1234,10 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	unsigned delay = 0;
 
 	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0);
+		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
 
 	gfs2_glmutex_lock(gl);
 
@@ -1229,8 +1255,14 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	}
 
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	run_queue(gl);
 	spin_unlock(&gl->gl_spin);
+
+	gfs2_glock_hold(gl);
+	if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
+	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
+		delay = gl->gl_ops->go_min_hold_time;
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
+		gfs2_glock_put(gl);
 }
 
 void gfs2_glock_dq_wait(struct gfs2_holder *gh)
@@ -1457,18 +1489,21 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 			unsigned int state)
 {
 	struct gfs2_glock *gl;
+	unsigned long delay = 0;
+	unsigned long holdtime;
+	unsigned long now = jiffies;
 
 	gl = gfs2_glock_find(sdp, name);
 	if (!gl)
 		return;
 
-	handle_callback(gl, state, 1);
-
-	spin_lock(&gl->gl_spin);
-	run_queue(gl);
-	spin_unlock(&gl->gl_spin);
+	holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
+	if (time_before(now, holdtime))
+		delay = holdtime - now;
 
-	gfs2_glock_put(gl);
+	handle_callback(gl, state, 1, delay);
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
+		gfs2_glock_put(gl);
 }
 
 /**
@@ -1509,7 +1544,8 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 			return;
 		if (!gfs2_assert_warn(sdp, gl->gl_req_bh))
 			gl->gl_req_bh(gl, async->lc_ret);
-		gfs2_glock_put(gl);
+		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+			gfs2_glock_put(gl);
 		up_read(&gfs2_umount_flush_sem);
 		return;
 	}
@@ -1602,7 +1638,7 @@ void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
 	if (gfs2_glmutex_trylock(gl)) {
 		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
-			handle_callback(gl, LM_ST_UNLOCKED, 0);
+			handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
 		gfs2_glmutex_unlock(gl);
 	}
 
@@ -1702,7 +1738,7 @@ static void clear_glock(struct gfs2_glock *gl)
 	if (gfs2_glmutex_trylock(gl)) {
 		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED)
-			handle_callback(gl, LM_ST_UNLOCKED, 0);
+			handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
 		gfs2_glmutex_unlock(gl);
 	}
 }
@@ -2009,11 +2045,18 @@ int __init gfs2_glock_init(void)
 	if (IS_ERR(scand_process))
 		return PTR_ERR(scand_process);
 
+	glock_workqueue = create_workqueue("glock_workqueue");
+	if (IS_ERR(glock_workqueue)) {
+		kthread_stop(scand_process);
+		return PTR_ERR(glock_workqueue);
+	}
+
 	return 0;
 }
 
 void gfs2_glock_exit(void)
 {
+	destroy_workqueue(glock_workqueue);
 	kthread_stop(scand_process);
 }
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 88342e0..7ef6b23 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -454,6 +454,7 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_lock = inode_go_lock,
 	.go_unlock = inode_go_unlock,
 	.go_type = LM_TYPE_INODE,
+	.go_min_hold_time = HZ / 10,
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
@@ -464,6 +465,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_lock = rgrp_go_lock,
 	.go_unlock = rgrp_go_unlock,
 	.go_type = LM_TYPE_RGRP,
+	.go_min_hold_time = HZ / 10,
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 1390b30..23b611a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -11,6 +11,7 @@
 #define __INCORE_DOT_H__
 
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -130,6 +131,7 @@ struct gfs2_glock_operations {
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
 	const int go_type;
+	const unsigned long go_min_hold_time;
 };
 
 enum {
@@ -161,6 +163,7 @@ enum {
 	GLF_LOCK		= 1,
 	GLF_STICKY		= 2,
 	GLF_DEMOTE		= 3,
+	GLF_PENDING_DEMOTE	= 4,
 	GLF_DIRTY		= 5,
 };
 
@@ -193,6 +196,7 @@ struct gfs2_glock {
 
 	u64 gl_vn;
 	unsigned long gl_stamp;
+	unsigned long gl_tchange;
 	void *gl_object;
 
 	struct list_head gl_reclaim;
@@ -203,6 +207,7 @@ struct gfs2_glock {
 	struct gfs2_log_element gl_le;
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
+	struct delayed_work gl_work;
 };
 
 struct gfs2_alloc {
-- 
1.5.1.2

