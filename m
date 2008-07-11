Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYGKLDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYGKLDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYGKLBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbYGKLBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/18] [GFS2] Remove remote lock dropping code
Date: Fri, 11 Jul 2008 11:11:09 +0100
Message-Id: <12157711013356-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157710983282-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There are several reasons why this is undesirable:

 1. It never happens during normal operation anyway
 2. If it does happen it causes performance to be very, very poor
 3. It isn't likely to solve the original problem (memory shortage
    on remote DLM node) it was supposed to solve
 4. It uses a bunch of arbitrary constants which are unlikely to be
    correct for any particular situation and for which the tuning seems
    to be a black art.
 5. In an N node cluster, only 1/N of the dropped locked will actually
    contribute to solving the problem on average.

So all in all we are better off without it. This also makes merging
the lock_dlm module into GFS2 a bit easier.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/gfs2.h b/fs/gfs2/gfs2.h
index 3bb11c0..ef606e3 100644
--- a/fs/gfs2/gfs2.h
+++ b/fs/gfs2/gfs2.h
@@ -16,11 +16,6 @@ enum {
 };
 
 enum {
-	NO_WAIT = 0,
-	WAIT = 1,
-};
-
-enum {
 	NO_FORCE = 0,
 	FORCE = 1,
 };
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index be7ed50..8d5450f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1316,11 +1316,6 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 			wake_up_process(sdp->sd_recoverd_process);
 		return;
 
-	case LM_CB_DROPLOCKS:
-		gfs2_gl_hash_clear(sdp, NO_WAIT);
-		gfs2_quota_scan(sdp);
-		return;
-
 	default:
 		gfs2_assert_warn(sdp, 0);
 		return;
@@ -1508,11 +1503,10 @@ static void clear_glock(struct gfs2_glock *gl)
  * @sdp: the filesystem
  * @wait: wait until it's all gone
  *
- * Called when unmounting the filesystem, or when inter-node lock manager
- * requests DROPLOCKS because it is running out of capacity.
+ * Called when unmounting the filesystem.
  */
 
-void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
+void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 {
 	unsigned long t;
 	unsigned int x;
@@ -1527,7 +1521,7 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
 				cont = 1;
 		}
 
-		if (!wait || !cont)
+		if (!cont)
 			break;
 
 		if (time_after_eq(jiffies,
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 7389f8e..971d92a 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -132,7 +132,7 @@ void gfs2_lvb_unhold(struct gfs2_glock *gl);
 void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
 void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
-void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait);
+void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
 
 int __init gfs2_glock_init(void);
 void gfs2_glock_exit(void);
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index ad944c6..845a27f 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -79,9 +79,6 @@ struct gdlm_ls {
 	wait_queue_head_t	wait_control;
 	struct task_struct	*thread;
 	wait_queue_head_t	thread_wait;
-	unsigned long		drop_time;
-	int			drop_locks_count;
-	int			drop_locks_period;
 };
 
 enum {
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 0628520..fa31c54 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -22,8 +22,6 @@ static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
 	if (!ls)
 		return NULL;
 
-	ls->drop_locks_count = GDLM_DROP_COUNT;
-	ls->drop_locks_period = GDLM_DROP_PERIOD;
 	ls->fscb = cb;
 	ls->sdp = sdp;
 	ls->fsflags = flags;
@@ -33,7 +31,6 @@ static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
 	INIT_LIST_HEAD(&ls->all_locks);
 	init_waitqueue_head(&ls->thread_wait);
 	init_waitqueue_head(&ls->wait_control);
-	ls->drop_time = jiffies;
 	ls->jid = -1;
 
 	strncpy(buf, table_name, 256);
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index a4ff271..4ec571c 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -114,17 +114,6 @@ static ssize_t recover_status_show(struct gdlm_ls *ls, char *buf)
 	return sprintf(buf, "%d\n", ls->recover_jid_status);
 }
 
-static ssize_t drop_count_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->drop_locks_count);
-}
-
-static ssize_t drop_count_store(struct gdlm_ls *ls, const char *buf, size_t len)
-{
-	ls->drop_locks_count = simple_strtol(buf, NULL, 0);
-	return len;
-}
-
 struct gdlm_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct gdlm_ls *, char *);
@@ -144,7 +133,6 @@ GDLM_ATTR(first_done,     0444, first_done_show,     NULL);
 GDLM_ATTR(recover,        0644, recover_show,        recover_store);
 GDLM_ATTR(recover_done,   0444, recover_done_show,   NULL);
 GDLM_ATTR(recover_status, 0444, recover_status_show, NULL);
-GDLM_ATTR(drop_count,     0644, drop_count_show,     drop_count_store);
 
 static struct attribute *gdlm_attrs[] = {
 	&gdlm_attr_proto_name.attr,
@@ -157,7 +145,6 @@ static struct attribute *gdlm_attrs[] = {
 	&gdlm_attr_recover.attr,
 	&gdlm_attr_recover_done.attr,
 	&gdlm_attr_recover_status.attr,
-	&gdlm_attr_drop_count.attr,
 	NULL,
 };
 
diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index f30350a..38823ef 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -20,19 +20,6 @@ static inline int no_work(struct gdlm_ls *ls)
 	return ret;
 }
 
-static inline int check_drop(struct gdlm_ls *ls)
-{
-	if (!ls->drop_locks_count)
-		return 0;
-
-	if (time_after(jiffies, ls->drop_time + ls->drop_locks_period * HZ)) {
-		ls->drop_time = jiffies;
-		if (ls->all_locks_count >= ls->drop_locks_count)
-			return 1;
-	}
-	return 0;
-}
-
 static int gdlm_thread(void *data)
 {
 	struct gdlm_ls *ls = (struct gdlm_ls *) data;
@@ -52,12 +39,6 @@ static int gdlm_thread(void *data)
 			gdlm_do_lock(lp);
 			spin_lock(&ls->async_lock);
 		}
-		/* Does this ever happen these days? I hope not anyway */
-		if (check_drop(ls)) {
-			spin_unlock(&ls->async_lock);
-			ls->fscb(ls->sdp, LM_CB_DROPLOCKS, NULL);
-			spin_lock(&ls->async_lock);
-		}
 		spin_unlock(&ls->async_lock);
 	}
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9bd97c5..6ba69dd 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -874,7 +874,7 @@ fail_sb:
 fail_locking:
 	init_locking(sdp, &mount_gh, UNDO);
 fail_lm:
-	gfs2_gl_hash_clear(sdp, WAIT);
+	gfs2_gl_hash_clear(sdp);
 	gfs2_lm_unmount(sdp);
 	while (invalidate_inodes(sb))
 		yield();
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 6690792..f66ea0f 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -126,7 +126,7 @@ static void gfs2_put_super(struct super_block *sb)
 	gfs2_clear_rgrpd(sdp);
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
-	gfs2_gl_hash_clear(sdp, WAIT);
+	gfs2_gl_hash_clear(sdp);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 9ab9fc8..6f7e2e5 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -110,18 +110,6 @@ static ssize_t statfs_sync_store(struct gfs2_sbd *sdp, const char *buf,
 	return len;
 }
 
-static ssize_t shrink_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
-{
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (simple_strtol(buf, NULL, 0) != 1)
-		return -EINVAL;
-
-	gfs2_gl_hash_clear(sdp, NO_WAIT);
-	return len;
-}
-
 static ssize_t quota_sync_store(struct gfs2_sbd *sdp, const char *buf,
 				size_t len)
 {
@@ -175,7 +163,6 @@ static struct gfs2_attr gfs2_attr_##name = __ATTR(name, mode, show, store)
 GFS2_ATTR(id,                  0444, id_show,       NULL);
 GFS2_ATTR(fsname,              0444, fsname_show,   NULL);
 GFS2_ATTR(freeze,              0644, freeze_show,   freeze_store);
-GFS2_ATTR(shrink,              0200, NULL,          shrink_store);
 GFS2_ATTR(withdraw,            0644, withdraw_show, withdraw_store);
 GFS2_ATTR(statfs_sync,         0200, NULL,          statfs_sync_store);
 GFS2_ATTR(quota_sync,          0200, NULL,          quota_sync_store);
@@ -186,7 +173,6 @@ static struct attribute *gfs2_attrs[] = {
 	&gfs2_attr_id.attr,
 	&gfs2_attr_fsname.attr,
 	&gfs2_attr_freeze.attr,
-	&gfs2_attr_shrink.attr,
 	&gfs2_attr_withdraw.attr,
 	&gfs2_attr_statfs_sync.attr,
 	&gfs2_attr_quota_sync.attr,
diff --git a/include/linux/lm_interface.h b/include/linux/lm_interface.h
index f274997..d0a7112 100644
--- a/include/linux/lm_interface.h
+++ b/include/linux/lm_interface.h
@@ -138,9 +138,6 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
  * LM_CB_NEED_RECOVERY
  * The given journal needs to be recovered.
  *
- * LM_CB_DROPLOCKS
- * Reduce the number of cached locks.
- *
  * LM_CB_ASYNC
  * The given lock has been granted.
  */
@@ -149,7 +146,6 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
 #define LM_CB_NEED_D		258
 #define LM_CB_NEED_S		259
 #define LM_CB_NEED_RECOVERY	260
-#define LM_CB_DROPLOCKS		261
 #define LM_CB_ASYNC		262
 
 /*
-- 
1.5.1.2

