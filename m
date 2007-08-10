Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXHJGfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXHJGfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbXHJGe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:34:28 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53349 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753604AbXHJGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:34:25 -0400
Message-ID: <386727659.45705@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070810063419.454829766@mail.ustc.edu.cn>
References: <20070810063412.238042387@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 14:34:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4] writeback: check time-ordering of s_io and s_more_io
Content-Disposition: inline; filename=io-dirty-check.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It helps catch bugs like this:

[  738.645689] fs/fs-writeback.c:535: s_dirty got screwed up
[  738.646114] ffff8100028532b0:4295082249
[  738.646255] ffff810002856858:4295082259
[  738.646388] ffff810002831b58:4295082667
[  738.646520] ffff81000281b1b0:4295082671
[  738.646651] ffff81000281d798:4295083507
========================================== s_dirty/s_io
[  738.646783] ffff81000287e998:4295081393
[  738.646916] ffff81000287e430:4295081403
[  738.647068] ffff8100028789d8:4295081409
[  738.647212] ffff810002878470:4295081415
[  738.647358] ffff810002884a18:4295081421
[  738.647503] ffff8100028844b0:4295081427
[  738.647648] ffff810002890a58:4295081433
[  738.647782] ffff8100028904f0:4295081441
[  738.647894] ffff81000288da98:4295081449
[  738.648011] ffff81000288d530:4295081455
[  738.648123] ffff810002897ad8:4295081461
[  738.648235] ffff810002897570:4295081469
[  738.648347] ffff810002894b18:4295081477
[  738.648459] ffff8100028945b0:4295081483

The buggy line 534 is
 			list_splice_init(&sb->s_io, sb->s_dirty.prev);

This is not the only time-ordering bug in linux-2.6.23-rc1-mm2.
Let's fix them all.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc1-mm2/fs/fs-writeback.c
@@ -26,12 +26,12 @@
 
 int sysctl_inode_debug __read_mostly;
 
-static int __check(struct super_block *sb, int print_stuff)
+static int __check(struct list_head *head, int print_stuff)
 {
-	struct list_head *cursor = &sb->s_dirty;
+	struct list_head *cursor = head;
 	unsigned long dirtied_when = 0;
 
-	while ((cursor = cursor->prev) != &sb->s_dirty) {
+	while ((cursor = cursor->prev) != head) {
 		struct inode *inode = list_entry(cursor, struct inode, i_list);
 		if (print_stuff) {
 			printk("%p:%lu\n", inode, inode->dirtied_when);
@@ -51,14 +51,32 @@ static void __check_dirty_inode_list(str
 	if (!sysctl_inode_debug)
 		return;
 
-	if (__check(sb, 0)) {
+	if (__check(&sb->s_dirty, 0)) {
 		sysctl_inode_debug = 0;
 		if (inode)
 			printk("%s:%d: s_dirty got screwed up.  inode=%p:%lu\n",
 					file, line, inode, inode->dirtied_when);
 		else
 			printk("%s:%d: s_dirty got screwed up\n", file, line);
-		__check(sb, 1);
+		__check(&sb->s_dirty, 1);
+	}
+	if (__check(&sb->s_io, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_io got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_io got screwed up\n", file, line);
+		__check(&sb->s_io, 1);
+	}
+	if (__check(&sb->s_more_io, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_more_io got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_more_io got screwed up\n", file, line);
+		__check(&sb->s_more_io, 1);
 	}
 }
 
@@ -223,7 +241,9 @@ static void redirty_tail(struct inode *i
  */
 static void requeue_io(struct inode *inode)
 {
+	check_dirty_inode(inode);
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	check_dirty_inode(inode);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -483,7 +503,9 @@ int generic_sync_sb_inodes(struct super_
 		/* Was this inode dirtied too recently? */
 		if (wbc->older_than_this && time_after(inode->dirtied_when,
 						*wbc->older_than_this)) {
+			check_dirty_inode_list(sb);
 			list_splice_init(&sb->s_io, sb->s_dirty.prev);
+			check_dirty_inode_list(sb);
 			break;
 		}
 
@@ -520,8 +542,11 @@ int generic_sync_sb_inodes(struct super_
 			break;
 	}
 
-	if (list_empty(&sb->s_io))
+	if (list_empty(&sb->s_io)) {
+		check_dirty_inode_list(sb);
 		list_splice_init(&sb->s_more_io, &sb->s_io);
+		check_dirty_inode_list(sb);
+	}
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }

-- 
