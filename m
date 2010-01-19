Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684Ab0ASIrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0ASIrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669Ab0ASIrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:47:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:47832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0ASIrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:47:19 -0500
Message-ID: <4B55715B.8070702@kernel.org>
Date: Tue, 19 Jan 2010 17:46:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: [PATCH UPDATED 39/40] gfs2: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-40-git-send-email-tj@kernel.org>	 <1263807959.2715.4.camel@localhost>  <4B5444FD.4050500@kernel.org> <1263816447.2715.45.camel@localhost> <4B550440.4040800@kernel.org>
In-Reply-To: <4B550440.4040800@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 08:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Convert gfs to use
workqueue instead of slow-work.

* Steven pointed out that recovery path might be run from allocation
  path and thus requires forward progress guarantee without memory
  allocation.  Create and use gfs_recovery_wq with rescuer.  Please
  note that forward progress wasn't guaranteed with slow-work.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
So, here's the updated version.  Only compile tested.

Thanks.

 fs/gfs2/Kconfig      |    1 
 fs/gfs2/incore.h     |    3 --
 fs/gfs2/main.c       |   14 +++++++------
 fs/gfs2/ops_fstype.c |    8 +++----
 fs/gfs2/recovery.c   |   54 +++++++++++++++++++--------------------------------
 fs/gfs2/recovery.h   |    6 +++--
 fs/gfs2/sys.c        |    3 +-
 7 files changed, 40 insertions(+), 49 deletions(-)

Index: work/fs/gfs2/incore.h
===================================================================
--- work.orig/fs/gfs2/incore.h
+++ work/fs/gfs2/incore.h
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
Index: work/fs/gfs2/main.c
===================================================================
--- work.orig/fs/gfs2/main.c
+++ work/fs/gfs2/main.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
 #include <asm/atomic.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -24,6 +23,7 @@
 #include "util.h"
 #include "glock.h"
 #include "quota.h"
+#include "recovery.h"
 
 static struct shrinker qd_shrinker = {
 	.shrink = gfs2_shrink_qd_memory,
@@ -114,9 +114,11 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		goto fail_unregister;
 
-	error = slow_work_register_user(THIS_MODULE);
-	if (error)
-		goto fail_slow;
+	error = -ENOMEM;
+	gfs_recovery_wq = __create_workqueue("gfs_recovery", WQ_RESCUER,
+					     WQ_MAX_ACTIVE);
+	if (!gfs_recovery_wq)
+		goto fail_wq;
 
 	gfs2_register_debugfs();
 
@@ -124,7 +126,7 @@ static int __init init_gfs2_fs(void)
 
 	return 0;
 
-fail_slow:
+fail_wq:
 	unregister_filesystem(&gfs2meta_fs_type);
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
@@ -163,7 +165,7 @@ static void __exit exit_gfs2_fs(void)
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
-	slow_work_unregister_user(THIS_MODULE);
+	destroy_workqueue(gfs_recovery_wq);
 
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
Index: work/fs/gfs2/ops_fstype.c
===================================================================
--- work.orig/fs/gfs2/ops_fstype.c
+++ work/fs/gfs2/ops_fstype.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/slow-work.h>
 #include <linux/quotaops.h>
 
 #include "gfs2.h"
@@ -673,7 +672,7 @@ static int gfs2_jindex_hold(struct gfs2_
 			break;
 
 		INIT_LIST_HEAD(&jd->extent_list);
-		slow_work_init(&jd->jd_work, &gfs2_recover_ops);
+		INIT_WORK(&jd->jd_work, gfs2_recover_func);
 		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
 		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
 			if (!jd->jd_inode)
@@ -778,7 +777,8 @@ static int init_journal(struct gfs2_sbd
 	if (sdp->sd_lockstruct.ls_first) {
 		unsigned int x;
 		for (x = 0; x < sdp->sd_journals; x++) {
-			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x));
+			error = gfs2_recover_journal(gfs2_jdesc_find(sdp, x),
+						     true);
 			if (error) {
 				fs_err(sdp, "error recovering journal %u: %d\n",
 				       x, error);
@@ -788,7 +788,7 @@ static int init_journal(struct gfs2_sbd
 
 		gfs2_others_may_mount(sdp);
 	} else if (!sdp->sd_args.ar_spectator) {
-		error = gfs2_recover_journal(sdp->sd_jdesc);
+		error = gfs2_recover_journal(sdp->sd_jdesc, true);
 		if (error) {
 			fs_err(sdp, "error recovering my journal: %d\n", error);
 			goto fail_jinode_gh;
Index: work/fs/gfs2/recovery.c
===================================================================
--- work.orig/fs/gfs2/recovery.c
+++ work/fs/gfs2/recovery.c
@@ -14,7 +14,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/slow-work.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -28,6 +27,8 @@
 #include "util.h"
 #include "dir.h"
 
+struct workqueue_struct *gfs_recovery_wq;
+
 int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 			   struct buffer_head **bh)
 {
@@ -443,23 +444,7 @@ static void gfs2_recovery_done(struct gf
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
@@ -578,7 +563,7 @@ static void gfs2_recover_work(struct slo
 		gfs2_glock_dq_uninit(&j_gh);
 
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
-	return;
+	goto done;
 
 fail_gunlock_tr:
 	gfs2_glock_dq_uninit(&t_gh);
@@ -590,32 +575,35 @@ fail_gunlock_j:
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
+	rv = queue_work(gfs_recovery_wq, &jd->jd_work);
+	BUG_ON(!rv);
+
+	if (wait)
+		wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait,
+			    TASK_UNINTERRUPTIBLE);
+
 	return 0;
 }
 
Index: work/fs/gfs2/recovery.h
===================================================================
--- work.orig/fs/gfs2/recovery.h
+++ work/fs/gfs2/recovery.h
@@ -12,6 +12,8 @@
 
 #include "incore.h"
 
+extern struct workqueue_struct *gfs_recovery_wq;
+
 static inline void gfs2_replay_incr_blk(struct gfs2_sbd *sdp, unsigned int *blk)
 {
 	if (++*blk == sdp->sd_jdesc->jd_blocks)
@@ -27,8 +29,8 @@ extern void gfs2_revoke_clean(struct gfs
 
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
-extern struct slow_work_ops gfs2_recover_ops;
+extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd, bool wait);
+extern void gfs2_recover_func(struct work_struct *work);
 
 #endif /* __RECOVERY_DOT_H__ */
 
Index: work/fs/gfs2/sys.c
===================================================================
--- work.orig/fs/gfs2/sys.c
+++ work/fs/gfs2/sys.c
@@ -26,6 +26,7 @@
 #include "quota.h"
 #include "util.h"
 #include "glops.h"
+#include "recovery.h"
 
 struct gfs2_attr {
 	struct attribute attr;
@@ -351,7 +352,7 @@ static ssize_t recover_store(struct gfs2
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		if (jd->jd_jid != jid)
 			continue;
-		rv = slow_work_enqueue(&jd->jd_work);
+		rv = gfs2_recover_journal(jd, false);
 		break;
 	}
 out:
Index: work/fs/gfs2/Kconfig
===================================================================
--- work.orig/fs/gfs2/Kconfig
+++ work/fs/gfs2/Kconfig
@@ -7,7 +7,6 @@ config GFS2_FS
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
-	select SLOW_WORK
 	select QUOTA
 	select QUOTACTL
 	help
