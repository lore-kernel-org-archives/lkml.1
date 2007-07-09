Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbXGIQ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbXGIQ0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbXGIQX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318AbXGIQXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:24 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Quotas non-functional - fix bug
Date: Mon,  9 Jul 2007 17:02:15 +0100
Message-Id: <1183997008395-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970061096-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch fixes an error in the quota code where a 'struct
gfs2_quota_lvb*' was being passed to gfs2_adjust_quota() instead of a
'struct gfs2_quota_data*'. Also moved 'struct gfs2_quota_lvb' from
fs/gfs2/incore.h to include/linux/gfs2_ondisk.h as per Steve's suggestion.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 00c3004..b2079fc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -275,14 +275,6 @@ enum {
 	QDF_LOCKED		= 2,
 };
 
-struct gfs2_quota_lvb {
-        __be32 qb_magic;
-        u32 __pad;
-        __be64 qb_limit;      /* Hard limit of # blocks to alloc */
-        __be64 qb_warn;       /* Warn user when alloc is above this # */
-        __be64 qb_value;       /* Current # blocks allocated */
-};
-
 struct gfs2_quota_data {
 	struct list_head qd_list;
 	unsigned int qd_count;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c186857..fcd3ee2 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -627,6 +627,8 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	err = 0;
 	qd->qd_qb.qb_magic = cpu_to_be32(GFS2_MAGIC);
 	qd->qd_qb.qb_value = cpu_to_be64(value);
+	((struct gfs2_quota_lvb*)(qd->qd_gl->gl_lvb))->qb_magic = cpu_to_be32(GFS2_MAGIC);
+	((struct gfs2_quota_lvb*)(qd->qd_gl->gl_lvb))->qb_value = cpu_to_be64(value);
 unlock:
 	unlock_page(page);
 	page_cache_release(page);
@@ -709,7 +711,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 		offset = qd2offset(qd);
 		error = gfs2_adjust_quota(ip, offset, qd->qd_change_sync,
 					  (struct gfs2_quota_data *)
-					  qd->qd_gl->gl_lvb);
+					  qd);
 		if (error)
 			goto out_end_trans;
 
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index a82ec8c..028f981 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -500,6 +500,14 @@ struct gfs2_quota_change_host {
 	__u32 qc_id;
 };
 
+struct gfs2_quota_lvb {
+        __be32 qb_magic;
+        u32 __pad;
+        __be64 qb_limit;      /* Hard limit of # blocks to alloc */
+        __be64 qb_warn;       /* Warn user when alloc is above this # */
+        __be64 qb_value;       /* Current # blocks allocated */
+};
+
 #ifdef __KERNEL__
 /* Translation functions */
 struct gfs2_inode;
-- 
1.5.1.2

