Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbYAUKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbYAUKJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbYAUKCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626AbYAUKC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:26 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/58] [GFS2] Don't periodically update the jindex
Date: Mon, 21 Jan 2008 09:21:40 +0000
Message-Id: <1200907378664-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073771883-git-send-email-swhiteho@redhat.com>
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
 <12009073771883-git-send-email-swhiteho@redhat.com>
Message-Id: <5b772c19c74692e7f5f3d99002aadf844130587e.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We only care about the content of the jindex in two cases,
one is when we mount the fs and the other is when we need
to recover another journal. In both cases we have to update
the jindex anyway, so there is no point in updating it
periodically between times, so this removes it to simplify
gfs2_logd.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 7ae0206..330f4c7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -411,7 +411,6 @@ struct gfs2_tune {
 	unsigned int gt_demote_secs; /* Cache retention for unheld glock */
 	unsigned int gt_incore_log_blocks;
 	unsigned int gt_log_flush_secs;
-	unsigned int gt_jindex_refresh_secs; /* Check for new journal index */
 
 	unsigned int gt_recoverd_secs;
 	unsigned int gt_logd_secs;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index e88a684..4dcc7a8 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -28,7 +28,6 @@
 #include "meta_io.h"
 #include "util.h"
 #include "dir.h"
-#include "super.h"
 
 #define PULL 1
 
@@ -874,7 +873,6 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 int gfs2_logd(void *data)
 {
 	struct gfs2_sbd *sdp = data;
-	struct gfs2_holder ji_gh;
 	unsigned long t;
 	int need_flush;
 
@@ -893,17 +891,6 @@ int gfs2_logd(void *data)
 			sdp->sd_log_flush_time = jiffies;
 		}
 
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
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
 		if (freezing(current))
 			refrigerator();
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 548cc8b..2e74792 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -54,7 +54,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_demote_secs = 300;
 	gt->gt_incore_log_blocks = 1024;
 	gt->gt_log_flush_secs = 60;
-	gt->gt_jindex_refresh_secs = 60;
 	gt->gt_recoverd_secs = 60;
 	gt->gt_logd_secs = 1;
 	gt->gt_quotad_secs = 5;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 65dd065..7f828a2 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -428,7 +428,6 @@ TUNE_ATTR_2(name, name##_store)
 TUNE_ATTR(demote_secs, 0);
 TUNE_ATTR(incore_log_blocks, 0);
 TUNE_ATTR(log_flush_secs, 0);
-TUNE_ATTR(jindex_refresh_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
 TUNE_ATTR(quota_quantum, 0);
 TUNE_ATTR(atime_quantum, 0);
@@ -450,7 +449,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_demote_secs.attr,
 	&tune_attr_incore_log_blocks.attr,
 	&tune_attr_log_flush_secs.attr,
-	&tune_attr_jindex_refresh_secs.attr,
 	&tune_attr_quota_warn_period.attr,
 	&tune_attr_quota_quantum.attr,
 	&tune_attr_atime_quantum.attr,
-- 
1.5.1.2

