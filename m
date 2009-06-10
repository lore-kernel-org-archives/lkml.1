Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZFJJjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZFJJjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZFJJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbZFJJiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/24] GFS2: Umount recovery race fix
Date: Wed, 10 Jun 2009 09:30:49 +0100
Message-Id: <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race condition where we can receive recovery
requests part way through processing a umount. This was causing
problems since the recovery thread had already gone away.

Looking in more detail at the recovery code, it was really trying
to implement a slight variation on a work queue, and that happens to
align nicely with the recently introduced slow-work subsystem. As a
result I've updated the code to use slow-work, rather than its own home
grown variety of work queue.

When using the wait_on_bit() function, I noticed that the wait function
that was supplied as an argument was appearing in the WCHAN field, so
I've updated the function names in order to produce more meaningful
output.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 3a981b7..cad957c 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -7,6 +7,7 @@ config GFS2_FS
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
+	select SLOW_WORK
 	help
 	  A cluster filesystem.
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ff49810..2bf62bc 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -796,22 +796,37 @@ void gfs2_holder_uninit(struct gfs2_holder *gh)
 	gh->gh_ip = 0;
 }
 
-static int just_schedule(void *word)
+/**
+ * gfs2_glock_holder_wait
+ * @word: unused
+ *
+ * This function and gfs2_glock_demote_wait both show up in the WCHAN
+ * field. Thus I've separated these otherwise identical functions in
+ * order to be more informative to the user.
+ */
+
+static int gfs2_glock_holder_wait(void *word)
 {
         schedule();
         return 0;
 }
 
+static int gfs2_glock_demote_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 static void wait_on_holder(struct gfs2_holder *gh)
 {
 	might_sleep();
-	wait_on_bit(&gh->gh_iflags, HIF_WAIT, just_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gh->gh_iflags, HIF_WAIT, gfs2_glock_holder_wait, TASK_UNINTERRUPTIBLE);
 }
 
 static void wait_on_demote(struct gfs2_glock *gl)
 {
 	might_sleep();
-	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, just_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
 }
 
 /**
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 65f438e..0060e95 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -12,6 +12,7 @@
 
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/slow-work.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
 
@@ -376,11 +377,11 @@ struct gfs2_journal_extent {
 struct gfs2_jdesc {
 	struct list_head jd_list;
 	struct list_head extent_list;
-
+	struct slow_work jd_work;
 	struct inode *jd_inode;
+	unsigned long jd_flags;
+#define JDF_RECOVERY 1
 	unsigned int jd_jid;
-	int jd_dirty;
-
 	unsigned int jd_blocks;
 };
 
@@ -390,9 +391,6 @@ struct gfs2_statfs_change_host {
 	s64 sc_dinodes;
 };
 
-#define GFS2_GLOCKD_DEFAULT	1
-#define GFS2_GLOCKD_MAX		16
-
 #define GFS2_QUOTA_DEFAULT	GFS2_QUOTA_OFF
 #define GFS2_QUOTA_OFF		0
 #define GFS2_QUOTA_ACCOUNT	1
@@ -427,7 +425,6 @@ struct gfs2_tune {
 	unsigned int gt_incore_log_blocks;
 	unsigned int gt_log_flush_secs;
 
-	unsigned int gt_recoverd_secs;
 	unsigned int gt_logd_secs;
 
 	unsigned int gt_quota_simul_sync; /* Max quotavals to sync at once */
@@ -448,6 +445,7 @@ enum {
 	SDF_JOURNAL_LIVE	= 1,
 	SDF_SHUTDOWN		= 2,
 	SDF_NOBARRIERS		= 3,
+	SDF_NORECOVERY		= 4,
 };
 
 #define GFS2_FSNAME_LEN		256
@@ -494,7 +492,6 @@ struct lm_lockstruct {
 	unsigned long ls_flags;
 	dlm_lockspace_t *ls_dlm;
 
-	int ls_recover_jid;
 	int ls_recover_jid_done;
 	int ls_recover_jid_status;
 };
@@ -583,7 +580,6 @@ struct gfs2_sbd {
 
 	/* Daemon stuff */
 
-	struct task_struct *sd_recoverd_process;
 	struct task_struct *sd_logd_process;
 	struct task_struct *sd_quotad_process;
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index a6892ed..eacd78a 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
 #include <asm/atomic.h>
+#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -113,12 +114,18 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		goto fail_unregister;
 
+	error = slow_work_register_user();
+	if (error)
+		goto fail_slow;
+
 	gfs2_register_debugfs();
 
 	printk("GFS2 (built %s %s) installed\n", __DATE__, __TIME__);
 
 	return 0;
 
+fail_slow:
+	unregister_filesystem(&gfs2meta_fs_type);
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
 fail:
@@ -156,6 +163,7 @@ static void __exit exit_gfs2_fs(void)
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
+	slow_work_unregister_user();
 
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 7981fbc..2cd1164 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -17,6 +17,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -55,7 +56,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	spin_lock_init(&gt->gt_spin);
 
 	gt->gt_incore_log_blocks = 1024;
-	gt->gt_recoverd_secs = 60;
 	gt->gt_logd_secs = 1;
 	gt->gt_quota_simul_sync = 64;
 	gt->gt_quota_warn_period = 10;
@@ -675,6 +675,7 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 			break;
 
 		INIT_LIST_HEAD(&jd->extent_list);
+		slow_work_init(&jd->jd_work, &gfs2_recover_ops);
 		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
 		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
 			if (!jd->jd_inode)
@@ -700,14 +701,13 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct inode *master = sdp->sd_master_dir->d_inode;
 	struct gfs2_holder ji_gh;
-	struct task_struct *p;
 	struct gfs2_inode *ip;
 	int jindex = 1;
 	int error = 0;
 
 	if (undo) {
 		jindex = 0;
-		goto fail_recoverd;
+		goto fail_jinode_gh;
 	}
 
 	sdp->sd_jindex = gfs2_lookup_simple(master, "jindex");
@@ -800,18 +800,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	gfs2_glock_dq_uninit(&ji_gh);
 	jindex = 0;
 
-	p = kthread_run(gfs2_recoverd, sdp, "gfs2_recoverd");
-	error = IS_ERR(p);
-	if (error) {
-		fs_err(sdp, "can't start recoverd thread: %d\n", error);
-		goto fail_jinode_gh;
-	}
-	sdp->sd_recoverd_process = p;
-
 	return 0;
 
-fail_recoverd:
-	kthread_stop(sdp->sd_recoverd_process);
 fail_jinode_gh:
 	if (!sdp->sd_args.ar_spectator)
 		gfs2_glock_dq_uninit(&sdp->sd_jinode_gh);
@@ -1172,8 +1162,10 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 		goto fail;
 	}
 
-	if (sdp->sd_args.ar_spectator)
+	if (sdp->sd_args.ar_spectator) {
                 sb->s_flags |= MS_RDONLY;
+		set_bit(SDF_NORECOVERY, &sdp->sd_flags);
+	}
 	if (sdp->sd_args.ar_posix_acl)
 		sb->s_flags |= MS_POSIXACL;
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 0677a83..a3c2272 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -121,6 +121,12 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	return error;
 }
 
+static int gfs2_umount_recovery_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 /**
  * gfs2_put_super - Unmount the filesystem
  * @sb: The VFS superblock
@@ -131,6 +137,7 @@ static void gfs2_put_super(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
+	struct gfs2_jdesc *jd;
 
 	/*  Unfreeze the filesystem, if we need to  */
 
@@ -139,9 +146,25 @@ static void gfs2_put_super(struct super_block *sb)
 		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
 	mutex_unlock(&sdp->sd_freeze_lock);
 
+	/* No more recovery requests */
+	set_bit(SDF_NORECOVERY, &sdp->sd_flags);
+	smp_mb();
+
+	/* Wait on outstanding recovery */
+restart:
+	spin_lock(&sdp->sd_jindex_spin);
+	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
+		if (!test_bit(JDF_RECOVERY, &jd->jd_flags))
+			continue;
+		spin_unlock(&sdp->sd_jindex_spin);
+		wait_on_bit(&jd->jd_flags, JDF_RECOVERY,
+			    gfs2_umount_recovery_wait, TASK_UNINTERRUPTIBLE);
+		goto restart;
+	}
+	spin_unlock(&sdp->sd_jindex_spin);
+
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
-	kthread_stop(sdp->sd_recoverd_process);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		error = gfs2_make_fs_ro(sdp);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 247e8f7..59d2695 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -13,8 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
+#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -441,18 +440,25 @@ static void gfs2_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
         kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
-/**
- * gfs2_recover_journal - recover a given journal
- * @jd: the struct gfs2_jdesc describing the journal
- *
- * Acquire the journal's lock, check to see if the journal is clean, and
- * do recovery if necessary.
- *
- * Returns: errno
- */
+static int gfs2_recover_get_ref(struct slow_work *work)
+{
+	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
+	if (test_and_set_bit(JDF_RECOVERY, &jd->jd_flags))
+		return -EBUSY;
+	return 0;
+}
 
-int gfs2_recover_journal(struct gfs2_jdesc *jd)
+static void gfs2_recover_put_ref(struct slow_work *work)
+{
+	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
+	clear_bit(JDF_RECOVERY, &jd->jd_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
+}
+
+static void gfs2_recover_work(struct slow_work *work)
 {
+	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
 	struct gfs2_log_header_host head;
@@ -569,7 +575,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 		gfs2_glock_dq_uninit(&j_gh);
 
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
-	return 0;
+	return;
 
 fail_gunlock_tr:
 	gfs2_glock_dq_uninit(&t_gh);
@@ -584,70 +590,28 @@ fail_gunlock_j:
 
 fail:
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
-	return error;
 }
 
-static struct gfs2_jdesc *gfs2_jdesc_find_dirty(struct gfs2_sbd *sdp)
-{
-	struct gfs2_jdesc *jd;
-	int found = 0;
-
-	spin_lock(&sdp->sd_jindex_spin);
+struct slow_work_ops gfs2_recover_ops = {
+	.get_ref = gfs2_recover_get_ref,
+	.put_ref = gfs2_recover_put_ref,
+	.execute = gfs2_recover_work,
+};
 
-	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
-		if (jd->jd_dirty) {
-			jd->jd_dirty = 0;
-			found = 1;
-			break;
-		}
-	}
-	spin_unlock(&sdp->sd_jindex_spin);
-
-	if (!found)
-		jd = NULL;
 
-	return jd;
-}
-
-/**
- * gfs2_check_journals - Recover any dirty journals
- * @sdp: the filesystem
- *
- */
-
-static void gfs2_check_journals(struct gfs2_sbd *sdp)
+static int gfs2_recovery_wait(void *word)
 {
-	struct gfs2_jdesc *jd;
-
-	for (;;) {
-		jd = gfs2_jdesc_find_dirty(sdp);
-		if (!jd)
-			break;
-
-		if (jd != sdp->sd_jdesc)
-			gfs2_recover_journal(jd);
-	}
+	schedule();
+	return 0;
 }
 
-/**
- * gfs2_recoverd - Recover dead machine's journals
- * @sdp: Pointer to GFS2 superblock
- *
- */
-
-int gfs2_recoverd(void *data)
+int gfs2_recover_journal(struct gfs2_jdesc *jd)
 {
-	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-
-	while (!kthread_should_stop()) {
-		gfs2_check_journals(sdp);
-		t = gfs2_tune_get(sdp,  gt_recoverd_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
-		schedule_timeout_interruptible(t);
-	}
-
+	int rv;
+	rv = slow_work_enqueue(&jd->jd_work);
+	if (rv)
+		return rv;
+	wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait, TASK_UNINTERRUPTIBLE);
 	return 0;
 }
 
diff --git a/fs/gfs2/recovery.h b/fs/gfs2/recovery.h
index a8218ea..1616ac2 100644
--- a/fs/gfs2/recovery.h
+++ b/fs/gfs2/recovery.h
@@ -28,7 +28,7 @@ extern void gfs2_revoke_clean(struct gfs2_sbd *sdp);
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
 extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
-extern int gfs2_recoverd(void *data);
+extern struct slow_work_ops gfs2_recover_ops;
 
 #endif /* __RECOVERY_DOT_H__ */
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 894bf77..9f6d48b 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -356,34 +356,33 @@ static ssize_t first_done_show(struct gfs2_sbd *sdp, char *buf)
 	return sprintf(buf, "%d\n", ls->ls_first_done);
 }
 
-static ssize_t recover_show(struct gfs2_sbd *sdp, char *buf)
-{
-	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", ls->ls_recover_jid);
-}
-
-static void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid)
+static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 {
+	unsigned jid;
 	struct gfs2_jdesc *jd;
+	int rv;
+
+	rv = sscanf(buf, "%u", &jid);
+	if (rv != 1)
+		return -EINVAL;
 
+	rv = -ESHUTDOWN;
 	spin_lock(&sdp->sd_jindex_spin);
+	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags))
+		goto out;
+	rv = -EBUSY;
+	if (sdp->sd_jdesc->jd_jid == jid)
+		goto out;
+	rv = -ENOENT;
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		if (jd->jd_jid != jid)
 			continue;
-		jd->jd_dirty = 1;
+		rv = slow_work_enqueue(&jd->jd_work);
 		break;
 	}
+out:
 	spin_unlock(&sdp->sd_jindex_spin);
-}
-
-static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
-{
-	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	ls->ls_recover_jid = simple_strtol(buf, NULL, 0);
-	gfs2_jdesc_make_dirty(sdp, ls->ls_recover_jid);
-	if (sdp->sd_recoverd_process)
-		wake_up_process(sdp->sd_recoverd_process);
-	return len;
+	return rv ? rv : len;
 }
 
 static ssize_t recover_done_show(struct gfs2_sbd *sdp, char *buf)
@@ -401,15 +400,15 @@ static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
 #define GDLM_ATTR(_name,_mode,_show,_store) \
 static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
-GDLM_ATTR(proto_name,     0444, proto_name_show,     NULL);
-GDLM_ATTR(block,          0644, block_show,          block_store);
-GDLM_ATTR(withdraw,       0644, withdraw_show,       withdraw_store);
-GDLM_ATTR(id,             0444, lkid_show,           NULL);
-GDLM_ATTR(first,          0444, lkfirst_show,        NULL);
-GDLM_ATTR(first_done,     0444, first_done_show,     NULL);
-GDLM_ATTR(recover,        0644, recover_show,        recover_store);
-GDLM_ATTR(recover_done,   0444, recover_done_show,   NULL);
-GDLM_ATTR(recover_status, 0444, recover_status_show, NULL);
+GDLM_ATTR(proto_name,     0444, proto_name_show,	NULL);
+GDLM_ATTR(block,          0644, block_show,		block_store);
+GDLM_ATTR(withdraw,       0644, withdraw_show,		withdraw_store);
+GDLM_ATTR(id,             0444, lkid_show,		NULL);
+GDLM_ATTR(first,          0444, lkfirst_show,		NULL);
+GDLM_ATTR(first_done,     0444, first_done_show,	NULL);
+GDLM_ATTR(recover,        0200, NULL,			recover_store);
+GDLM_ATTR(recover_done,   0444, recover_done_show,	NULL);
+GDLM_ATTR(recover_status, 0444, recover_status_show,	NULL);
 
 static struct attribute *lock_module_attrs[] = {
 	&gdlm_attr_proto_name.attr,
-- 
1.6.0.6

