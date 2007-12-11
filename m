Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXLKNn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXLKNn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXLKNnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:43:22 -0500
Received: from styx.suse.cz ([82.119.242.94]:46087 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228AbXLKNnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:43:21 -0500
Date: Tue, 11 Dec 2007 14:43:19 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gentuu@gmail.com
Subject: [PATCH] Improve inode list scanning in add_dquot_ref()
Message-ID: <20071211134319.GB8153@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  attached patch makes add_dquot_ref() quite faster if used on a life
filesystem. It has survived some testing on my machine but there could be
some subtle races I've missed so please leave it in -mm for a while (not
that I'd think that people use quotas with -mm kernels but at least it
should go into vanilla in -rc1...). Thanks.

								Honza

---
We restarted scan of sb->s_inodes list whenever we had to drop inode_lock in
add_dquot_ref(). This leads to overall quadratic running time and thus
add_dquot_ref() can take several minutes when called on a life filesystem.  We
fix the problem by using the fact that inode cannot be removed from s_inodes
list while we hold a reference to it and thus we can safely restart the scan if
we don't drop the reference. Here we use the fact that inodes freshly added to
s_inodes list are already guaranteed to have quotas properly initialized and
the ordering of inodes on s_inodes list does not change so we cannot skip any
inode.  Thanks goes to Nick <gentuu@gmail.com> for analyzing the problem and
testing the fix.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Nick <gentuu@gmail.com>

diff --git a/fs/dquot.c b/fs/dquot.c
index 2809768..ecea4be 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -696,9 +696,8 @@ static int dqinit_needed(struct inode *inode, int type)
 /* This routine is guarded by dqonoff_mutex mutex */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
-	struct inode *inode;
+	struct inode *inode, *old_inode = NULL;
 
-restart:
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (!atomic_read(&inode->i_writecount))
@@ -711,12 +710,20 @@ restart:
 		__iget(inode);
 		spin_unlock(&inode_lock);
 
+		if (old_inode)
+			iput(old_inode);
 		sb->dq_op->initialize(inode, type);
-		iput(inode);
-		/* As we may have blocked we had better restart... */
-		goto restart;
+		/* We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the inode_lock.
+		 * We cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under inode_lock. So we
+		 * keep the reference and iput it later. */
+		old_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	if (old_inode)
+		iput(old_inode);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */
