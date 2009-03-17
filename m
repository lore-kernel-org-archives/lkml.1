Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZCQVoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZCQVoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZCQVoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:44:46 -0400
Received: from mx1.suse.de ([195.135.220.2]:55217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZCQVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:44:45 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 28/32] ocfs2/dlm: Do not purge lockres that is being migrated dlm_purge_lockres()
Date: Tue, 17 Mar 2009 13:01:18 -0700
Message-Id: <1237320082-12921-29-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch attempts to fix a fine race between purging and migration.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmthread.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 4060bb3..d490b66 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -162,12 +162,28 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 
 	spin_lock(&res->spinlock);
 	if (!__dlm_lockres_unused(res)) {
-		spin_unlock(&res->spinlock);
 		mlog(0, "%s:%.*s: tried to purge but not unused\n",
 		     dlm->name, res->lockname.len, res->lockname.name);
-		return -ENOTEMPTY;
+		__dlm_print_one_lock_resource(res);
+		spin_unlock(&res->spinlock);
+		BUG();
 	}
+
+	if (res->state & DLM_LOCK_RES_MIGRATING) {
+		mlog(0, "%s:%.*s: Delay dropref as this lockres is "
+		     "being remastered\n", dlm->name, res->lockname.len,
+		     res->lockname.name);
+		/* Re-add the lockres to the end of the purge list */
+		if (!list_empty(&res->purge)) {
+			list_del_init(&res->purge);
+			list_add_tail(&res->purge, &dlm->purge_list);
+		}
+		spin_unlock(&res->spinlock);
+		return 0;
+	}
+
 	master = (res->owner == dlm->node_num);
+
 	if (!master)
 		res->state |= DLM_LOCK_RES_DROPPING_REF;
 	spin_unlock(&res->spinlock);
-- 
1.5.6

