Return-Path: <linux-kernel-owner+w=401wt.eu-S1764722AbYCFAaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764722AbYCFAaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYCFA2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:28:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34875 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbYCFA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:28:14 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com
Subject: [PATCH 11/18] ocfs2: Abstract out a debugging function for underlying dlms.
Date: Wed,  5 Mar 2008 16:27:34 -0800
Message-Id: <1204763261-28025-12-git-send-email-joel.becker@oracle.com>
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

dlmglue.c was still referencing a raw o2dlm lksb in one instance.  Let's
create a generic ocfs2_dlm_dump_lksb() function.  This allows underlying
DLMs to print whatever they want about their lock.

We then move the o2dlm dump into stackglue.c where it belongs.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c   |    3 +--
 fs/ocfs2/stackglue.c |    5 +++++
 fs/ocfs2/stackglue.h |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index d48163f..58a34df 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2803,8 +2803,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
-		/* XXX Need to abstract this */
-		dlm_print_one_lock(lockres->l_lksb.lksb_o2dlm.lockid);
+		ocfs2_dlm_dump_lksb(&lockres->l_lksb);
 		BUG();
 	}
 	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index abdb9f6..bd80541 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -252,6 +252,11 @@ void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 	return (void *)(lksb->lksb_o2dlm.lvb);
 }
 
+void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+{
+	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
+}
+
 /*
  * Called from the dlm when it's about to evict a node. This is how the
  * classic stack signals node death.
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 22af77b..01e3c9b 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -91,6 +91,7 @@ int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
+void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
 
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto);
 void o2cb_put_stack(void);
-- 
1.5.3.8

