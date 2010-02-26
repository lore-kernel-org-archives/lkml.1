Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab0BZTRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829Ab0BZTRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:17:51 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] dlm: use bastmode in debugfs output
Date: Fri, 26 Feb 2010 13:17:44 -0600
Message-Id: <1267211864-5474-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bast mode that appears in the debugfs output should be
useful on both master and process nodes.  lkb_highbast is
currently printed, and is only useful on the master node.
lkb_bastmode is only useful on the process node.  This
patch sets lkb_bastmode on the master node as well, and
uses that value in the debugfs print.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/debug_fs.c |    2 +-
 fs/dlm/lock.c     |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 375a235..29d6139 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -256,7 +256,7 @@ static int print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
 			lkb->lkb_status,
 			lkb->lkb_grmode,
 			lkb->lkb_rqmode,
-			lkb->lkb_highbast,
+			lkb->lkb_bastmode,
 			rsb_lookup,
 			lkb->lkb_wait_type,
 			lkb->lkb_lvbseq,
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d0e43a3..46ffd3e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -320,10 +320,12 @@ static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
 {
 	lkb->lkb_time_bast = ktime_get();
 
-	if (is_master_copy(lkb))
+	if (is_master_copy(lkb)) {
+		lkb->lkb_bastmode = rqmode; /* printed by debugfs */
 		send_bast(r, lkb, rqmode);
-	else
+	} else {
 		dlm_add_ast(lkb, AST_BAST, rqmode);
+	}
 }
 
 /*
-- 
1.6.6

