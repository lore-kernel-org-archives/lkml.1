Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZCQWBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZCQWBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZCQWB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:01:28 -0400
Received: from ns.suse.de ([195.135.220.2]:58478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZCQWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:01:28 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 26/32] ocfs2/dlm: Show the number of lockres/mles in dlm_state
Date: Tue, 17 Mar 2009 13:01:16 -0700
Message-Id: <1237320082-12921-27-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch shows the number of lockres' and mles in the debugfs file, dlm_state.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index d7decaa..bf9fa27 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -763,6 +763,8 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	int out = 0;
 	struct dlm_reco_node_data *node;
 	char *state;
+	int cur_mles = 0, tot_mles = 0;
+	int i;
 
 	spin_lock(&dlm->spinlock);
 
@@ -805,6 +807,40 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 				 db->buf + out, db->len - out);
 	out += snprintf(db->buf + out, db->len - out, "\n");
 
+	/* Lock Resources: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"Lock Resources: %d (%d)\n",
+			atomic_read(&dlm->res_cur_count),
+			atomic_read(&dlm->res_tot_count));
+
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i)
+		tot_mles += atomic_read(&dlm->mle_tot_count[i]);
+
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i)
+		cur_mles += atomic_read(&dlm->mle_cur_count[i]);
+
+	/* MLEs: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"MLEs: %d (%d)\n", cur_mles, tot_mles);
+
+	/*  Blocking: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Blocking: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_BLOCK]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_BLOCK]));
+
+	/*  Mastery: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Mastery: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_MASTER]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_MASTER]));
+
+	/*  Migration: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Migration: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_MIGRATION]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_MIGRATION]));
+
 	/* Lists: Dirty=Empty  Purge=InUse  PendingASTs=Empty  ... */
 	out += snprintf(db->buf + out, db->len - out,
 			"Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
-- 
1.5.6

