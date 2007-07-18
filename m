Return-Path: <linux-kernel-owner+w=401wt.eu-S936329AbXGRX0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936329AbXGRX0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXGRX00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936207AbXGRX0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/14] debugfs: remove rmdir() non-empty complaint
Date: Wed, 18 Jul 2007 16:25:37 -0700
Message-Id: <11848011502972-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <20070718232400.GC4620@kroah.com>
References: <20070718232400.GC4620@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 1d533a2..11be8a3 100644
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
1.5.2.2

