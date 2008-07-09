Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYGIRav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYGIRav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYGIRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:30:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:41080 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbYGIRam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:30:42 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Fix possible infinite loop in quota code
Date: Wed,  9 Jul 2008 19:30:41 +0200
Message-Id: <12156246412443-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When quota structure is going to be dropped and it is dirty, quota code
tries to write it. If the write fails for some reason (e. g. transaction
cannot be started because the journal is aborted), we try writing again
and again and again... Fix the problem by clearing the dirty bit even if
the write failed.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: dingdinghua <dingdinghua85@gmail.com>
---
 fs/dquot.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 5ac77da..ad88cf6 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -562,6 +562,8 @@ static struct shrinker dqcache_shrinker = {
  */
 static void dqput(struct dquot *dquot)
 {
+	int ret;
+
 	if (!dquot)
 		return;
 #ifdef __DQUOT_PARANOIA
@@ -594,7 +596,19 @@ we_slept:
 	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags) && dquot_dirty(dquot)) {
 		spin_unlock(&dq_list_lock);
 		/* Commit dquot before releasing */
-		dquot->dq_sb->dq_op->write_dquot(dquot);
+		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
+		if (ret < 0) {
+			printk(KERN_ERR "VFS: cannot write quota structure on "
+				"device %s (error %d). Quota may get out of "
+				"sync!\n", dquot->dq_sb->s_id, ret);
+			/*
+			 * We clear dirty bit anyway, so that we avoid
+			 * infinite loop here
+			 */
+			spin_lock(&dq_list_lock);
+			clear_dquot_dirty(dquot);
+			spin_unlock(&dq_list_lock);
+		}
 		goto we_slept;
 	}
 	/* Clear flag in case dquot was inactive (something bad happened) */
-- 
1.5.2.4

