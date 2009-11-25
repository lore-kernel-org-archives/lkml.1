Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbZKYNaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbZKYNaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbZKYN20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934542AbZKYN2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:24 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/30] GFS2: Add get_xstate quota function
Date: Wed, 25 Nov 2009 14:22:38 +0000
Message-Id: <1259158975-28499-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-13-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows querying of the quota state via the XFS quota
API.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6aaa6c5..e7114be 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -47,6 +47,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/dqblk_xfs.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1375,7 +1376,29 @@ int gfs2_quotad(void *data)
 	return 0;
 }
 
+static int gfs2_quota_get_xstate(struct super_block *sb,
+				 struct fs_quota_stat *fqs)
+{
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+
+	memset(fqs, 0, sizeof(struct fs_quota_stat));
+	fqs->qs_version = FS_QSTAT_VERSION;
+	if (sdp->sd_args.ar_quota == GFS2_QUOTA_ON)
+		fqs->qs_flags = (XFS_QUOTA_UDQ_ENFD | XFS_QUOTA_GDQ_ENFD);
+	else if (sdp->sd_args.ar_quota == GFS2_QUOTA_ACCOUNT)
+		fqs->qs_flags = (XFS_QUOTA_UDQ_ACCT | XFS_QUOTA_GDQ_ACCT);
+	if (sdp->sd_quota_inode) {
+		fqs->qs_uquota.qfs_ino = GFS2_I(sdp->sd_quota_inode)->i_no_addr;
+		fqs->qs_uquota.qfs_nblks = sdp->sd_quota_inode->i_blocks;
+	}
+	fqs->qs_uquota.qfs_nextents = 1; /* unsupported */
+	fqs->qs_gquota = fqs->qs_uquota; /* its the same inode in both cases */
+	fqs->qs_incoredqs = atomic_read(&qd_lru_count);
+	return 0;
+}
+
 const struct quotactl_ops gfs2_quotactl_ops = {
 	.quota_sync     = gfs2_quota_sync,
+	.get_xstate     = gfs2_quota_get_xstate,
 };
 
-- 
1.6.2.5

