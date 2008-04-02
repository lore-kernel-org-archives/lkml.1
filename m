Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbYDBUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbYDBUYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761583AbYDBURR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:17:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:33027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760696AbYDBURP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:17:15 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       David Teigland <teigland@redhat.com>
Subject: [PATCH 17/62] ocfs2: handle async EAGAIN from NOQUEUE request
Date: Wed,  2 Apr 2008 13:14:27 -0700
Message-Id: <12071673543752-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12071673511262-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
 <1207167318479-git-send-email-mfasheh@suse.com>
 <12071673203909-git-send-email-mfasheh@suse.com>
 <12071673232465-git-send-email-mfasheh@suse.com>
 <12071673263948-git-send-email-mfasheh@suse.com>
 <12071673282579-git-send-email-mfasheh@suse.com>
 <1207167330482-git-send-email-mfasheh@suse.com>
 <12071673321172-git-send-email-mfasheh@suse.com>
 <12071673341888-git-send-email-mfasheh@suse.com>
 <12071673362069-git-send-email-mfasheh@suse.com>
 <12071673391031-git-send-email-mfasheh@suse.com>
 <12071673413492-git-send-email-mfasheh@suse.com>
 <1207167343926-git-send-email-mfasheh@suse.com>
 <12071673461268-git-send-email-mfasheh@suse.com>
 <12071673481928-git-send-email-mfasheh@suse.com>
 <12071673492775-git-send-email-mfasheh@suse.com>
 <12071673511262-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

When using fsdlm, -EAGAIN is returned in the async callback for NOQUEUE
requests. Fix up dlmglue to expect this.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 295c47f..b640423 100644
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
1.5.4.1

