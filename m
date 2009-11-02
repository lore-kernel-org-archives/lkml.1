Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZKBKL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZKBKL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZKBKHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbZKBKHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:05 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH 25/27] BKL: Remove BKL from sysfs
Date: Mon,  2 Nov 2009 11:05:05 +0100
Message-Id: <1257156307-24175-26-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super and get_sb_single() is used. It is safe to
remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/sysfs/mount.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 2e5a870..9487575 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -10,7 +10,7 @@
  * Please see Documentation/filesystems/sysfs.txt for more information.
  */
 
-#define DEBUG 
+#define DEBUG
 
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/magic.h>
-#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include "sysfs.h"
 
@@ -46,8 +45,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
-	lock_kernel();
-
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = SYSFS_MAGIC;
@@ -61,7 +58,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -70,12 +66,10 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.4.2

