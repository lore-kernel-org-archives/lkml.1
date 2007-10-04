Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXJDJ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXJDJ3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbXJDJSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419AbXJDJSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:13 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 32/51] [GFS2] Correct lock ordering in unlink
Date: Thu,  4 Oct 2007 09:49:25 +0100
Message-Id: <11914878492645-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878472056-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch corrects the lock ordering in unlink to be the same as
that in the rest of GFS2, i.e. parent -> child -> rgrp.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 5b8b994..2cbe5a3 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -278,17 +278,25 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 
-	error = gfs2_glock_nq_m(3, ghs);
+	error = gfs2_glock_nq(ghs); /* parent */
 	if (error)
-		goto out;
+		goto out_parent;
+
+	error = gfs2_glock_nq(ghs + 1); /* child */
+	if (error)
+		goto out_child;
+
+	error = gfs2_glock_nq(ghs + 2); /* rgrp */
+	if (error)
+		goto out_rgrp;
 
 	error = gfs2_unlink_ok(dip, &dentry->d_name, ip);
 	if (error)
-		goto out_gunlock;
+		goto out_rgrp;
 
 	error = gfs2_trans_begin(sdp, 2*RES_DINODE + RES_LEAF + RES_RG_BIT, 0);
 	if (error)
-		goto out_gunlock;
+		goto out_rgrp;
 
 	error = gfs2_dir_del(dip, &dentry->d_name);
         if (error)
@@ -298,12 +306,15 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 
 out_end_trans:
 	gfs2_trans_end(sdp);
-out_gunlock:
-	gfs2_glock_dq_m(3, ghs);
-out:
-	gfs2_holder_uninit(ghs);
-	gfs2_holder_uninit(ghs + 1);
+	gfs2_glock_dq(ghs + 2);
+out_rgrp:
 	gfs2_holder_uninit(ghs + 2);
+	gfs2_glock_dq(ghs + 1);
+out_child:
+	gfs2_holder_uninit(ghs + 1);
+	gfs2_glock_dq(ghs);
+out_parent:
+	gfs2_holder_uninit(ghs);
 	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
-- 
1.5.1.2

