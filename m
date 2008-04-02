Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYDBJLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYDBJLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 05:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYDBJLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 05:11:44 -0400
Received: from styx.suse.cz ([82.119.242.94]:58744 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbYDBJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:11:44 -0400
Date: Wed, 2 Apr 2008 11:11:43 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] reiserfs: Fix hang on umount with quotas when journal is
	aborted
Message-ID: <20080402091142.GE2716@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call dquot_drop() from reiserfs_dquot_drop() even if we fail to start a
transaction. Otherwise we never get to dropping references to quota structures
from the inode and umount will hang indefinitely.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 fs/reiserfs/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 393cc22..65e17e1 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1890,8 +1890,14 @@ static int reiserfs_dquot_drop(struct inode *inode)
 	ret =
 	    journal_begin(&th, inode->i_sb,
 			  2 * REISERFS_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (ret)
+	if (ret) {
+		/*
+		 * We call dquot_drop() anyway to at least release references
+		 * to quota structures so that umount does not hang.
+		 */
+		dquot_drop(inode);
 		goto out;
+	}
 	ret = dquot_drop(inode);
 	err =
 	    journal_end(&th, inode->i_sb,
-- 
1.5.2.4

