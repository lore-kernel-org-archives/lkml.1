Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbYAUKHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbYAUKHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYAUKCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbYAUKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:11 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/58] [GFS2] Remove "reclaim limit"
Date: Mon, 21 Jan 2008 09:21:31 +0000
Message-Id: <12009073642512-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907362266-git-send-email-swhiteho@redhat.com>
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
Message-Id: <e3723cd69be7f7d85b27127cf92380faa55258f4.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This call to reclaim glocks is not needed, and in particular we don't want it
in the fast path for locking glocks. The limit was entirely arbitrary anyway
and we can't expect users to adjust things like this, the remaining code will
do the right thing on its own.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 104e83f..159a547 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -507,21 +507,12 @@ static int rq_mutex(struct gfs2_holder *gh)
 static int rq_promote(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	if (!relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
 		if (list_empty(&gl->gl_holders)) {
 			gl->gl_req_gh = gh;
 			set_bit(GLF_LOCK, &gl->gl_flags);
 			spin_unlock(&gl->gl_spin);
-
-			if (atomic_read(&sdp->sd_reclaim_count) >
-			    gfs2_tune_get(sdp, gt_reclaim_limit) &&
-			    !(gh->gh_flags & LM_FLAG_PRIORITY)) {
-				gfs2_reclaim_glock(sdp);
-				gfs2_reclaim_glock(sdp);
-			}
-
 			gfs2_glock_xmote_th(gh->gh_gl, gh);
 			spin_lock(&gl->gl_spin);
 		}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f7a50fe..089dba4 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -433,7 +433,6 @@ struct gfs2_tune {
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
 	unsigned int gt_stall_secs; /* Detects trouble! */
 	unsigned int gt_complain_secs;
-	unsigned int gt_reclaim_limit; /* Max num of glocks in reclaim list */
 	unsigned int gt_statfs_quantum;
 	unsigned int gt_statfs_slow;
 };
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 26edb7f..548cc8b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -70,7 +70,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_max_readahead = 1 << 18;
 	gt->gt_stall_secs = 600;
 	gt->gt_complain_secs = 10;
-	gt->gt_reclaim_limit = 5000;
 	gt->gt_statfs_quantum = 30;
 	gt->gt_statfs_slow = 0;
 }
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 06e0b77..1359198 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -433,7 +433,6 @@ TUNE_ATTR(quota_quantum, 0);
 TUNE_ATTR(atime_quantum, 0);
 TUNE_ATTR(max_readahead, 0);
 TUNE_ATTR(complain_secs, 0);
-TUNE_ATTR(reclaim_limit, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(new_files_directio, 0);
@@ -456,7 +455,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_atime_quantum.attr,
 	&tune_attr_max_readahead.attr,
 	&tune_attr_complain_secs.attr,
-	&tune_attr_reclaim_limit.attr,
 	&tune_attr_statfs_slow.attr,
 	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_quota_cache_secs.attr,
-- 
1.5.1.2

