Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYDBJFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYDBJFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 05:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYDBJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 05:04:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:58215 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706AbYDBJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:04:54 -0400
Date: Wed, 2 Apr 2008 11:04:51 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Payphone LIOU <lioupayphone@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: [PATCH] ext3: Fix hang on umount with quotas when journal is
	aborted
Message-ID: <20080402090451.GC2716@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call dquot_drop() from ext3_dquot_drop() even if we fail to start a
transaction. Otherwise we never get to dropping references to
quota structures from the inode and umount will hang indefinitely.
Thanks to Payphone LIOU for spotting the problem.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Payphone LIOU <lioupayphone@gmail.com>

---
 fs/ext3/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index ad53606..77e9702 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2639,8 +2639,14 @@ static int ext3_dquot_drop(struct inode *inode)
 
 	/* We may delete quota structure so we need to reserve enough blocks */
 	handle = ext3_journal_start(inode, 2*EXT3_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/*
+		 * We call dquot_drop() anyway to at least release references
+		 * to quota structures so that umount does not hang.
+		 */
+		dquot_drop(inode);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_drop(inode);
 	err = ext3_journal_stop(handle);
 	if (!ret)
-- 
1.5.2.4

