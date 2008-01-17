Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYAQWtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYAQWtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbYAQWh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36571 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbYAQWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:37:05 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>
Subject: [PATCH 26/30] ocfs2/dlm: Clear joining_node on hearbeat node down
Date: Thu, 17 Jan 2008 14:35:52 -0800
Message-Id: <1200609356-17788-27-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

Currently the process of dlm join contains 2 steps: query join and assert join.
After query join, the joined node will set its joining_node. So if the joining
node happens to panic before the 2nd step, the joined node will fail to clear
its joining_node flag because that node isn't in the domain map. It at least
cause 2 problems.
1. All the new join request will fail. So no new node can mount the volume.
2. The joined node can't umount the volume since during the umount process it
   has to wait for the joining_node to be unknown. So the umount will be hanged.

The solution is to clear the joining_node before we check the domain map.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index b10f3e3..91f747b 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2270,6 +2270,12 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
 		}
 	}
 
+	/* Clean up join state on node death. */
+	if (dlm->joining_node == idx) {
+		mlog(0, "Clearing join state for node %u\n", idx);
+		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
+	}
+
 	/* check to see if the node is already considered dead */
 	if (!test_bit(idx, dlm->live_nodes_map)) {
 		mlog(0, "for domain %s, node %d is already dead. "
@@ -2288,12 +2294,6 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
 
 	clear_bit(idx, dlm->live_nodes_map);
 
-	/* Clean up join state on node death. */
-	if (dlm->joining_node == idx) {
-		mlog(0, "Clearing join state for node %u\n", idx);
-		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
-	}
-
 	/* make sure local cleanup occurs before the heartbeat events */
 	if (!test_bit(idx, dlm->recovery_map))
 		dlm_do_local_recovery_cleanup(dlm, idx);
-- 
1.5.3.6

