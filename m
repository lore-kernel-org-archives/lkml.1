Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475Ab0ARAzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0ARAzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423Ab0ARAyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:54:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:54506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0ARAyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:54:13 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 39/40] gfs2: use workqueue instead of slow-work
Date: Mon, 18 Jan 2010 09:57:51 +0900
Message-Id: <1263776272-382-40-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Use system_long_wq instead
of slow-work.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/Kconfig      |    1 -
 fs/gfs2/incore.h     |    3 +-
 fs/gfs2/main.c       |    9 +-------
 fs/gfs2/ops_fstype.c |    8 +++---
 fs/gfs2/recovery.c   |   52 ++++++++++++++++++-------------------------------
 fs/gfs2/recovery.h   |    4 +-
 fs/gfs2/sys.c        |    3 +-
 7 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 4dcddf8..f51f1bb 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -7,7 +7,6 @@ config GFS2_FS
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
-	select SLOW_WORK
 	select QUOTA
 	select QUOTACTL
 	help
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4792200..b99d5be 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -12,7 +12,6 @@
 
 #include <linux/fs.h>
 #include <linux/workqueue.h>
-#include <linux/slow-work.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
 
@@ -383,7 +382,7 @@ struct gfs2_journal_extent {
 struct gfs2_jdesc {
 	struct list_head jd_list;
 	struct list_head extent_list;
-	struct slow_work jd_work;
+	struct work_struct jd_work;
 	struct inode *jd_inode;
 	unsigned long jd_flags;
 #define JDF_RECOVERY 1
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 5b31f77..f809842 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
 #include <asm/atomic.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -114,18 +113,12 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		goto fail_unregister;
 
-	error = slow_work_register_user(THIS_MODULE);
-	if (error)
-		goto fail_slow;
-
 	gfs2_register_debugfs();
 
 	printk("GFS2 (built %s %s) installed\n", __DATE__, __TIME__);
 
 	return 0;
 
-fail_slow:
-	unregister_filesystem(&gfs2meta_fs_type);
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
 fail:
@@ -163,7 +156,7 @@ static void __exit exit_gfs2_fs(void)
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
-	slow_work_unregister_user(THIS_MODULE);
+	flush_workqueue(system_long_wq);
 
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index edfee24..58e130e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/slow-work.h>
 #include <linux/quotaops.h>
 
 #include "gfs2.h"
@@ -673,7 +672,7 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 			break;
 
 		INIT_LIST_HEAD(&jd->extent_list);
-		slow_work_init(&jd->jd_work, &gfs2_recover_ops);
+		INIT_WORK(&jd->jd_work, gfs2_recover_func);
 		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
 		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
 			if (!jd->jd_inode)
@@ -778,7 +777,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
 		for (x = 0; x < sdp->sd_journals; x++) {
-			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x));
+			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x),
+						     true);
 			if (error) {
 				fs_err(sdp, "error recovering journal %u: %d\n",
 				       x, error);
@@ -788,7 +788,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 
 		gfs2_others_may_mount(sdp);
 	} else if (!sdp->sd_args.ar_spectator) {
-		error = gfs2_recover_journal(sdp->sd_jdesc);
+		error = gfs2_recover_journal(sdp->sd_jdesc, true);
 		if (error) {
 			fs_err(sdp, "error recovering my journal: %d\n", error);
 			goto fail_jinode_gh;
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 4b9bece..906f1ee 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -14,7 +14,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -443,23 +442,7 @@ static void gfs2_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
         kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
-static int gfs2_recover_get_ref(struct slow_work *work)
-{
-	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
-	if (test_and_set_bit(JDF_RECOVERY, &jd->jd_flags))
-		return -EBUSY;
-	return 0;
-}
-
-static void gfs2_recover_put_ref(struct slow_work *work)
-{
-	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
-	clear_bit(JDF_RECOVERY, &jd->jd_flags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
-}
-
-static void gfs2_recover_work(struct slow_work *work)
+void gfs2_recover_func(struct work_struct *work)
 {
 	struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
@@ -578,7 +561,7 @@ static void gfs2_recover_work(struct slow_work *work)
 		gfs2_glock_dq_uninit(&j_gh);
 
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
-	return;
+	goto done;
 
 fail_gunlock_tr:
 	gfs2_glock_dq_uninit(&t_gh);
@@ -590,32 +573,35 @@ fail_gunlock_j:
 	}
 
 	fs_info(sdp, "jid=%u: %s\n", jd->jd_jid, (error) ? "Failed" : "Done");
-
 fail:
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
+done:
+	clear_bit(JDF_RECOVERY, &jd->jd_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
 }
 
-struct slow_work_ops gfs2_recover_ops = {
-	.owner	 = THIS_MODULE,
-	.get_ref = gfs2_recover_get_ref,
-	.put_ref = gfs2_recover_put_ref,
-	.execute = gfs2_recover_work,
-};
-
-
 static int gfs2_recovery_wait(void *word)
 {
 	schedule();
 	return 0;
 }
 
-int gfs2_recover_journal(struct gfs2_jdesc *jd)
+int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
 {
 	int rv;
-	rv = slow_work_enqueue(&jd->jd_work);
-	if (rv)
-		return rv;
-	wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait, TASK_UNINTERRUPTIBLE);
+
+	if (test_and_set_bit(JDF_RECOVERY, &jd->jd_flags))
+		return -EBUSY;
+
+	/* we have JDF_RECOVERY, queue should always succeed */
+	rv = queue_work(system_long_wq, &jd->jd_work);
+	BUG_ON(!rv);
+
+	if (wait)
+		wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait,
+			    TASK_UNINTERRUPTIBLE);
+
 	return 0;
 }
 
diff --git a/fs/gfs2/recovery.h b/fs/gfs2/recovery.h
index 1616ac2..78abd50 100644
--- a/fs/gfs2/recovery.h
+++ b/fs/gfs2/recovery.h
@@ -27,8 +27,8 @@ extern void gfs2_revoke_clean(struct gfs2_sbd *sdp);
 
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
-extern struct slow_work_ops gfs2_recover_ops;
+extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd, bool wait);
+extern void gfs2_recover_func(struct work_struct *work);
 
 #endif /* __RECOVERY_DOT_H__ */
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 0dc3462..ee0f3cd 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -26,6 +26,7 @@
 #include "quota.h"
 #include "util.h"
 #include "glops.h"
+#include "recovery.h"
 
 struct gfs2_attr {
 	struct attribute attr;
@@ -351,7 +352,7 @@ static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		if (jd->jd_jid != jid)
 			continue;
-		rv = slow_work_enqueue(&jd->jd_work);
+		rv = gfs2_recover_journal(jd, false);
 		break;
 	}
 out:
-- 
1.6.4.2

