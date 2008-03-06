Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbYCFAgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbYCFAgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762907AbYCFA27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:28:59 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34991 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761074AbYCFA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:28:25 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com
Subject: [PATCH 08/18] ocfs2: Fill node number during cluster stack init
Date: Wed,  5 Mar 2008 16:27:31 -0800
Message-Id: <1204763261-28025-9-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Fasheh <mark.fasheh@oracle.com>

It doesn't make sense to query for a node number before connecting to the
cluster stack. This should be safe to do because node_num is only just
printed,
and we're actually only moving the setting of node num a small amount
further in the mount process.

[ Disconnect when node query fails -- Joel ]

Reviewed-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |   13 ++++++++++++-
 fs/ocfs2/super.c   |   33 ---------------------------------
 2 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index aa13d15..9876857 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2459,8 +2459,10 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb)) {
+		osb->node_num = 0;
 		goto local;
+	}
 
 	status = ocfs2_dlm_init_debug(osb);
 	if (status < 0) {
@@ -2487,6 +2489,15 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto bail;
 	}
 
+	status = ocfs2_cluster_this_node(&osb->node_num);
+	if (status < 0) {
+		mlog_errno(status);
+		mlog(ML_ERROR,
+		     "could not find this host's node number\n");
+		ocfs2_cluster_disconnect(conn);
+		goto bail;
+	}
+
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8f536b3..fa9c46e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -108,7 +108,6 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait);
 static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb);
 static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb);
 static void ocfs2_release_system_inodes(struct ocfs2_super *osb);
-static int ocfs2_fill_local_node_info(struct ocfs2_super *osb);
 static int ocfs2_check_volume(struct ocfs2_super *osb);
 static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			       struct buffer_head *bh,
@@ -1126,32 +1125,6 @@ static int ocfs2_get_sector(struct super_block *sb,
 	return 0;
 }
 
-/* ocfs2 1.0 only allows one cluster and node identity per kernel image. */
-static int ocfs2_fill_local_node_info(struct ocfs2_super *osb)
-{
-	int status;
-
-	/* XXX hold a ref on the node while mounte?  easy enough, if
-	 * desirable. */
-	if (ocfs2_mount_local(osb))
-		osb->node_num = 0;
-	else {
-		status = ocfs2_cluster_this_node(&osb->node_num);
-		if (status < 0) {
-			mlog_errno(status);
-			mlog(ML_ERROR,
-			     "could not find this host's node number\n");
-			goto bail;
-		}
-	}
-
-	mlog(0, "I am node %u\n", osb->node_num);
-
-	status = 0;
-bail:
-	return status;
-}
-
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
@@ -1163,12 +1136,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	if (ocfs2_is_hard_readonly(osb))
 		goto leave;
 
-	status = ocfs2_fill_local_node_info(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.3.8

