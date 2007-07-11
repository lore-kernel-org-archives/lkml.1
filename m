Return-Path: <linux-kernel-owner+w=401wt.eu-S1764221AbXGKMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764221AbXGKMxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbXGKMxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:53:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4244 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054AbXGKMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:53:24 -0400
Date: Wed, 11 Jul 2007 14:53:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] debugfs: remove rmdir() non-empty complaint
Message-ID: <20070711125328.GW4587@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch kills the pointless debugfs rmdir() printk() when called on a
non-empty directory. blktrace will sometimes have to call it a few times
when forcefully ending a trace, which polutes the log with pointless
warnings.

Rationale:

- It's more code to work-around this "problem" in the debugfs users, and
  you would have to add code to check for empty directories to do so (or
  assume that debugfs is using simple_ helpers, but that would be a
  layering violation).

- Other rmdir() implementations don't complain about something this
  silly.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index ec8896b..8f3c999 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -345,11 +345,6 @@ void debugfs_remove(struct dentry *dentry)
 			switch (dentry->d_inode->i_mode & S_IFMT) {
 			case S_IFDIR:
 				ret = simple_rmdir(parent->d_inode, dentry);
-				if (ret)
-					printk(KERN_ERR
-						"DebugFS rmdir on %s failed : "
-						"directory not empty.\n",
-						dentry->d_name.name);
 				break;
 			case S_IFLNK:
 				kfree(dentry->d_inode->i_private);

-- 
Jens Axboe

