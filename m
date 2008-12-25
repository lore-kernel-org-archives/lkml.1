Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYLYSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYLYSOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYLYSFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:33757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYLYSFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:37 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 25/35] ocfs2/dlm: Fix a race between migrate request and exit domain
Date: Thu, 25 Dec 2008 10:04:40 -0800
Message-Id: <1230228290-22803-26-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

Patch address a racing migrate request message and an exit domain message.
Instead of blocking exit domains for the duration of the migrate, we ignore
failure to deliver that message. This is because an exiting domain should
not have any active locks and thus has no role to play in the migration.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 44f87ca..92fd1d7 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2949,7 +2949,7 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 				  struct dlm_node_iter *iter)
 {
 	struct dlm_migrate_request migrate;
-	int ret, status = 0;
+	int ret, skip, status = 0;
 	int nodenum;
 
 	memset(&migrate, 0, sizeof(migrate));
@@ -2966,12 +2966,27 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 		    nodenum == new_master)
 			continue;
 
+		/* We could race exit domain. If exited, skip. */
+		spin_lock(&dlm->spinlock);
+		skip = (!test_bit(nodenum, dlm->domain_map));
+		spin_unlock(&dlm->spinlock);
+		if (skip) {
+			clear_bit(nodenum, iter->node_map);
+			continue;
+		}
+
 		ret = o2net_send_message(DLM_MIGRATE_REQUEST_MSG, dlm->key,
 					 &migrate, sizeof(migrate), nodenum,
 					 &status);
-		if (ret < 0)
-			mlog_errno(ret);
-		else if (status < 0) {
+		if (ret < 0) {
+			mlog(0, "migrate_request returned %d!\n", ret);
+			if (!dlm_is_host_down(ret)) {
+				mlog(ML_ERROR, "unhandled error=%d!\n", ret);
+				BUG();
+			}
+			clear_bit(nodenum, iter->node_map);
+			ret = 0;
+		} else if (status < 0) {
 			mlog(0, "migrate request (node %u) returned %d!\n",
 			     nodenum, status);
 			ret = status;
-- 
1.5.6

