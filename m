Return-Path: <linux-kernel-owner+w=401wt.eu-S936654AbXGRX3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936654AbXGRX3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936352AbXGRX0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:50 -0400
Received: from mail.suse.de ([195.135.220.2]:57434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936336AbXGRX0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/14] sysfs: fix sysfs root inode nlink accounting
Date: Wed, 18 Jul 2007 16:25:43 -0700
Message-Id: <1184801177102-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011731698-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

While making sysfs indoes hashed, sysfs root inode was left out.  Now
that nlink accounting depends on the inode being on the hash, sysfs
root inode nlink isn't adjusted properly.

Put sysfs root inode on the inode hash by allocating it using
sysfs_get_inode() like other sysfs inodes.  While at it, massage
comments a bit.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 402cc35..60714d0 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -43,19 +43,19 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sysfs_sb = sb;
 
-	inode = new_inode(sysfs_sb);
+	/* get root inode, initialize and unlock it */
+	inode = sysfs_get_inode(&sysfs_root);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
 	}
 
-	sysfs_init_inode(&sysfs_root, inode);
-
 	inode->i_op = &sysfs_dir_inode_operations;
 	inode->i_fop = &sysfs_dir_operations;
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
+	inc_nlink(inode); /* directory, account for "." */
+	unlock_new_inode(inode);
 
+	/* instantiate and link root dentry */
 	root = d_alloc_root(inode);
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
-- 
1.5.2.2

