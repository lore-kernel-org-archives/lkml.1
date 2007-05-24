Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbXEXAkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbXEXAkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761486AbXEXAgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40235 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262AbXEXAge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:34 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 16/21] Unionfs: Disallow setting leftmost branch to readonly
Date: Wed, 23 May 2007 20:36:06 -0400
Message-Id: <11799669732839-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs requires the leftmost branch to be writeable for copyup to work
properly and simply.  If, through branch-management commands (add, delete,
or mode change), the leftmost branch will becomes readonly, then return an
error (and tell the user to use "remount,ro" if they want a readonly union).

[jsipek: fixed up to apply cleanly]
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 3dee863..446faf8 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -629,12 +629,20 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 out_no_change:
 
 	/******************************************************************
-	 * WE'RE ALMOST DONE: see if we need to allocate a small-sized new
-	 * vector, copy the vectors to their correct place, release the
-	 * refcnt of the older ones, and return.
-	 * Also handle invalidating any pages that will have to be re-read.
+	 * WE'RE ALMOST DONE: check if leftmost branch might be read-only,
+	 * see if we need to allocate a small-sized new vector, copy the
+	 * vectors to their correct place, release the refcnt of the older
+	 * ones, and return.  Also handle invalidating any pages that will
+	 * have to be re-read.
 	 *******************************************************************/
 
+	if (!(tmp_data[0].branchperms & MAY_WRITE)) {
+		printk("unionfs: leftmost branch cannot be read-only "
+		       "(use \"remount,ro\" to create a read-only union)\n");
+		err = -EINVAL;
+		goto out_release;
+	}
+
 	/* (re)allocate space for new pointers to hidden dentry */
 	size = new_branches * sizeof(struct unionfs_data);
 	new_data = krealloc(tmp_data, size, GFP_KERNEL);
-- 
1.5.2.rc1.165.gaf9b

