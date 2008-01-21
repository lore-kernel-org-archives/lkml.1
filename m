Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbYAUKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbYAUKJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbYAUKCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759584AbYAUKCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:24 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/58] [GFS2] Move gfs2_logd into log.c
Date: Mon, 21 Jan 2008 09:21:39 +0000
Message-Id: <12009073771883-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073753723-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
Message-Id: <3072834a761178bb7edcecc00c9b5aa1b439de51.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This means that we can mark gfs2_ail1_empty static and prepares
the way for further changes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
index 3731ab0..e519919 100644
--- a/fs/gfs2/daemon.c
+++ b/fs/gfs2/daemon.c
@@ -83,56 +83,6 @@ int gfs2_recoverd(void *data)
 }
 
 /**
- * gfs2_logd - Update log tail as Active Items get flushed to in-place blocks
- * @sdp: Pointer to GFS2 superblock
- *
- * Also, periodically check to make sure that we're using the most recent
- * journal index.
- */
-
-int gfs2_logd(void *data)
-{
-	struct gfs2_sbd *sdp = data;
-	struct gfs2_holder ji_gh;
-	unsigned long t;
-	int need_flush;
-
-	while (!kthread_should_stop()) {
-		/* Advance the log tail */
-
-		t = sdp->sd_log_flush_time +
-		    gfs2_tune_get(sdp, gt_log_flush_secs) * HZ;
-
-		gfs2_ail1_empty(sdp, DIO_ALL);
-		gfs2_log_lock(sdp);
-		need_flush = sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks);
-		gfs2_log_unlock(sdp);
-		if (need_flush || time_after_eq(jiffies, t)) {
-			gfs2_log_flush(sdp, NULL);
-			sdp->sd_log_flush_time = jiffies;
-		}
-
-		/* Check for latest journal index */
-
-		t = sdp->sd_jindex_refresh_time +
-		    gfs2_tune_get(sdp, gt_jindex_refresh_secs) * HZ;
-
-		if (time_after_eq(jiffies, t)) {
-			if (!gfs2_jindex_hold(sdp, &ji_gh))
-				gfs2_glock_dq_uninit(&ji_gh);
-			sdp->sd_jindex_refresh_time = jiffies;
-		}
-
-		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
-		schedule_timeout_interruptible(t);
-	}
-
-	return 0;
-}
-
-/**
  * gfs2_quotad - Write cached quota changes into the quota file
  * @sdp: Pointer to GFS2 superblock
  *
diff --git a/fs/gfs2/daemon.h b/fs/gfs2/daemon.h
index 0de9b35..4be084f 100644
--- a/fs/gfs2/daemon.h
+++ b/fs/gfs2/daemon.h
@@ -12,7 +12,6 @@
 
 int gfs2_glockd(void *data);
 int gfs2_recoverd(void *data);
-int gfs2_logd(void *data);
 int gfs2_quotad(void *data);
 
 #endif /* __DAEMON_DOT_H__ */
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 9192398..e88a684 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -16,6 +16,8 @@
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -26,6 +28,7 @@
 #include "meta_io.h"
 #include "util.h"
 #include "dir.h"
+#include "super.h"
 
 #define PULL 1
 
@@ -208,7 +211,7 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
 	gfs2_log_unlock(sdp);
 }
 
-int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
+static int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags)
 {
 	struct gfs2_ail *ai, *s;
 	int ret;
@@ -859,3 +862,54 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 	}
 }
 
+
+/**
+ * gfs2_logd - Update log tail as Active Items get flushed to in-place blocks
+ * @sdp: Pointer to GFS2 superblock
+ *
+ * Also, periodically check to make sure that we're using the most recent
+ * journal index.
+ */
+
+int gfs2_logd(void *data)
+{
+	struct gfs2_sbd *sdp = data;
+	struct gfs2_holder ji_gh;
+	unsigned long t;
+	int need_flush;
+
+	while (!kthread_should_stop()) {
+		/* Advance the log tail */
+
+		t = sdp->sd_log_flush_time +
+		    gfs2_tune_get(sdp, gt_log_flush_secs) * HZ;
+
+		gfs2_ail1_empty(sdp, DIO_ALL);
+		gfs2_log_lock(sdp);
+		need_flush = sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks);
+		gfs2_log_unlock(sdp);
+		if (need_flush || time_after_eq(jiffies, t)) {
+			gfs2_log_flush(sdp, NULL);
+			sdp->sd_log_flush_time = jiffies;
+		}
+
+		/* Check for latest journal index */
+
+		t = sdp->sd_jindex_refresh_time +
+		    gfs2_tune_get(sdp, gt_jindex_refresh_secs) * HZ;
+
+		if (time_after_eq(jiffies, t)) {
+			if (!gfs2_jindex_hold(sdp, &ji_gh))
+				gfs2_glock_dq_uninit(&ji_gh);
+			sdp->sd_jindex_refresh_time = jiffies;
+		}
+
+		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
+		schedule_timeout_interruptible(t);
+	}
+
+	return 0;
+}
+
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 4babd43..7711528 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -48,8 +48,6 @@ static inline void gfs2_log_pointers_init(struct gfs2_sbd *sdp,
 unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
-int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags);
-
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
 void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks);
 void gfs2_log_incr_head(struct gfs2_sbd *sdp);
@@ -70,5 +68,6 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
 
 void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
+int gfs2_logd(void *data);
 
 #endif /* __LOG_DOT_H__ */
-- 
1.5.1.2

