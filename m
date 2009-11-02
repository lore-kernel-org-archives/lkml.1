Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZKBKKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZKBKKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZKBKHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 13/27] BKL: Remove BKL from configfs
Date: Mon,  2 Nov 2009 11:04:53 +0100
Message-Id: <1257156307-24175-14-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Since this filesystem uses get_sb_single(), fill_super is only called once.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/configfs/mount.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 5b2e06e..8421cea 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -71,8 +71,6 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
-	lock_kernel();
-
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = CONFIGFS_MAGIC;
@@ -89,7 +87,6 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 		inc_nlink(inode);
 	} else {
 		pr_debug("configfs: could not get root inode\n");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -97,14 +94,12 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	config_group_init(&configfs_root_group);
 	configfs_root_group.cg_item.ci_dentry = root;
 	root->d_fsdata = &configfs_root;
 	sb->s_root = root;
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.4.2

