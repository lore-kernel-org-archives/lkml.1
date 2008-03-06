Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbYCFAje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbYCFAje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761081AbYCFA3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:29:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:35278 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761074AbYCFA3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:29:07 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, David Teigland <teigland@redhat.com>
Subject: [PATCH 10/18] ocfs2: handle async EAGAIN from NOQUEUE request
Date: Wed,  5 Mar 2008 16:27:33 -0800
Message-Id: <1204763261-28025-11-git-send-email-joel.becker@oracle.com>
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

From: David Teigland <teigland@redhat.com>

This is the stack-glue equivalent of what I had on the dlm_eviction_cb
branch.  When using fsdlm, -EAGAIN is returned in the async callback for
NOQUEUE requests.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 99f3de1..d48163f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -880,13 +880,20 @@ static void ocfs2_locking_ast(void *opaque)
 	struct ocfs2_lock_res *lockres = opaque;
 	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
 	unsigned long flags;
+	int status;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 
-	if (ocfs2_dlm_lock_status(&lockres->l_lksb)) {
+	status = ocfs2_dlm_lock_status(&lockres->l_lksb);
+
+	if (status == -EAGAIN) {
+		lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
+		goto out;
+	}
+
+	if (status) {
 		mlog(ML_ERROR, "lockres %s: lksb status value of %d!\n",
-		     lockres->l_name,
-		     ocfs2_dlm_lock_status(&lockres->l_lksb));
+		     lockres->l_name, status);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 		return;
 	}
@@ -909,7 +916,7 @@ static void ocfs2_locking_ast(void *opaque)
 		     lockres->l_unlock_action);
 		BUG();
 	}
-
+out:
 	/* set it to something invalid so if we get called again we
 	 * can catch it. */
 	lockres->l_action = OCFS2_AST_INVALID;
@@ -1113,6 +1120,7 @@ static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 	int ret = 0; /* gcc doesn't realize wait = 1 guarantees ret is set */
 	unsigned long flags;
 	unsigned int gen;
+	int noqueue_attempted = 0;
 
 	mlog_entry_void();
 
@@ -1157,6 +1165,13 @@ again:
 	}
 
 	if (level > lockres->l_level) {
+		if (noqueue_attempted > 0) {
+			ret = -EAGAIN;
+			goto unlock;
+		}
+		if (lkm_flags & DLM_LKF_NOQUEUE)
+			noqueue_attempted = 1;
+
 		if (lockres->l_action != OCFS2_AST_INVALID)
 			mlog(ML_ERROR, "lockres %s has action %u pending\n",
 			     lockres->l_name, lockres->l_action);
@@ -1621,6 +1636,10 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 		 * to just bubble sucess back up to the user.
 		 */
 		ret = ocfs2_flock_handle_signal(lockres, level);
+	} else if (!ret && (level > lockres->l_level)) {
+		/* Trylock failed asynchronously */
+		BUG_ON(!trylock);
+		ret = -EAGAIN;
 	}
 
 out:
-- 
1.5.3.8

