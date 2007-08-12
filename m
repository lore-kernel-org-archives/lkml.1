Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbXHLJVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbXHLJVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbXHLJVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:13 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37043 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755327AbXHLJVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:12 -0400
Message-ID: <386910467.08391@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812092053.242474484@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:26 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/6] track redirty_tail() calls
Content-Disposition: inline; filename=redirty-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It helps a lot to know how redirty_tail() are called.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -210,6 +210,11 @@ static int write_inode(struct inode *ino
 	return 0;
 }
 
+#define redirty_tail(inode)						\
+	do {								\
+		__redirty_tail(inode, __LINE__);			\
+	} while (0)
+
 /*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
@@ -219,11 +224,14 @@ static int write_inode(struct inode *ino
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct inode *inode)
+static void __redirty_tail(struct inode *inode, int line)
 {
 	struct super_block *sb = inode->i_sb;
 
 	check_dirty_inode(inode);
+	if (unlikely(sysctl_inode_debug))
+		printk(KERN_DEBUG "redirtied inode %lu line %d\n",
+				inode->i_ino, line);
 	inode->dirtied_when = jiffies;
 	list_move(&inode->i_list, &sb->s_dirty);
 	check_dirty_inode(inode);

-- 
