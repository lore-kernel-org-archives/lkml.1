Return-Path: <linux-kernel-owner+w=401wt.eu-S934646AbZKYNgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbZKYNgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934412AbZKYNgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934064AbZKYNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:13 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/30] GFS2: Use dquot_send_warning()
Date: Wed, 25 Nov 2009 14:30:53 +0000
Message-Id: <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support to GFS2 to send quota warnings via netlink.
Also it removes a stray \r which was left over from when the
code used to print warnings on the console.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e8db534..1d4fc04 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -47,6 +47,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/quota.h>
 #include <linux/dqblk_xfs.h>
 
 #include "gfs2.h"
@@ -1001,7 +1002,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\r\n",
+	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\n",
 	       sdp->sd_fsname, type,
 	       (test_bit(QDF_USER, &qd->qd_flags)) ? "user" : "group",
 	       qd->qd_id);
@@ -1038,6 +1039,10 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
+			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
+					   USRQUOTA : GRPQUOTA, qd->qd_id,
+					   sdp->sd_vfs->s_dev, QUOTA_NL_BHARDWARN);
+
 			error = -EDQUOT;
 			break;
 		} else if (be64_to_cpu(qd->qd_qb.qb_warn) &&
@@ -1045,6 +1050,9 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 			   time_after_eq(jiffies, qd->qd_last_warn +
 					 gfs2_tune_get(sdp,
 						gt_quota_warn_period) * HZ)) {
+			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
+					   USRQUOTA : GRPQUOTA, qd->qd_id,
+					   sdp->sd_vfs->s_dev, QUOTA_NL_BSOFTWARN);
 			error = print_message(qd, "warning");
 			qd->qd_last_warn = jiffies;
 		}
-- 
1.6.2.5

