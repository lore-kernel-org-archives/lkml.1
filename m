Return-Path: <linux-kernel-owner+w=401wt.eu-S964927AbZKYN2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbZKYN2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbZKYN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879AbZKYN2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/30] GFS2: Add get_xquota support
Date: Wed, 25 Nov 2009 14:22:43 +0000
Message-Id: <1259158975-28499-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-18-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-13-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-14-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-15-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-16-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-17-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-18-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for viewing the current GFS2 quota settings
via the XFS quota API. The setting of quotas will be addressed
in a later patch. Fields which are not supported here are left
set to zero.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/gfs2/quota.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 33e369f..6c5d6aa 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1367,8 +1367,51 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
 	return 0;
 }
 
+static int gfs2_xquota_get(struct super_block *sb, int type, qid_t id,
+			   struct fs_disk_quota *fdq)
+{
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+	struct gfs2_quota_lvb *qlvb;
+	struct gfs2_quota_data *qd;
+	struct gfs2_holder q_gh;
+	int error;
+
+	memset(fdq, 0, sizeof(struct fs_disk_quota));
+
+	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
+		return -ESRCH; /* Crazy XFS error code */
+
+	if (type == USRQUOTA)
+		type = QUOTA_USER;
+	else if (type == GRPQUOTA)
+		type = QUOTA_GROUP;
+	else
+		return -EINVAL;
+
+	error = qd_get(sdp, type, id, &qd);
+	if (error)
+		return error;
+	error = do_glock(qd, FORCE, &q_gh);
+	if (error)
+		goto out;
+
+	qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
+	fdq->d_version = FS_DQUOT_VERSION;
+	fdq->d_flags = (type == QUOTA_USER) ? XFS_USER_QUOTA : XFS_GROUP_QUOTA;
+	fdq->d_id = id;
+	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit);
+	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn);
+	fdq->d_bcount = be64_to_cpu(qlvb->qb_value);
+
+	gfs2_glock_dq_uninit(&q_gh);
+out:
+	qd_put(qd);
+	return error;
+}
+
 const struct quotactl_ops gfs2_quotactl_ops = {
 	.quota_sync     = gfs2_quota_sync,
 	.get_xstate     = gfs2_quota_get_xstate,
+	.get_xquota	= gfs2_xquota_get,
 };
 
-- 
1.6.2.5

