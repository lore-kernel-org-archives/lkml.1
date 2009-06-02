Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZFBQUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZFBQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZFBQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:20:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZFBQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:20:33 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, wli@holomorphy.com, hch@infradead.org,
       viro@zeniv.linux.org.uk
Subject: [PATCH] vfs: Split generic_forget_inode() so that hugetlbfs does not have to copy it
Date: Tue,  2 Jun 2009 18:20:34 +0200
Message-Id: <1243959634-22067-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugetlbfs needs to do special things instead of truncate_inode_pages().
Currently, it copied generic_forget_inode() except for truncate_inode_pages()
call which is asking for trouble (the code there isn't trivial). So create a
separate function generic_detach_inode() which does all the list magic done in
generic_forget_inode() and call it from hugetlbfs_forget_inode().

CC: wli@holomorphy.com
CC: hch@infradead.org
CC: viro@zeniv.linux.org.uk
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c |   33 ++++-----------------------------
 fs/inode.c           |   17 +++++++++++++++--
 include/linux/fs.h   |    1 +
 3 files changed, 20 insertions(+), 31 deletions(-)

 Al, will you please merge the patch if everyone agrees? Thanks.

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c1462d4..ef65d9e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -380,36 +380,11 @@ static void hugetlbfs_delete_inode(struct inode *inode)
 
 static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
 {
-	struct super_block *sb = inode->i_sb;
-
-	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
-		if (!sb || (sb->s_flags & MS_ACTIVE)) {
-			spin_unlock(&inode_lock);
-			return;
-		}
-		inode->i_state |= I_WILL_FREE;
-		spin_unlock(&inode_lock);
-		/*
-		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
-		 * in our backing_dev_info.
-		 */
-		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
-		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
-		hlist_del_init(&inode->i_hash);
+	if (generic_detach_inode(inode)) {
+		truncate_hugepages(inode, 0);
+		clear_inode(inode);
+		destroy_inode(inode);
 	}
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-	truncate_hugepages(inode, 0);
-	clear_inode(inode);
-	destroy_inode(inode);
 }
 
 static void hugetlbfs_drop_inode(struct inode *inode)
diff --git a/fs/inode.c b/fs/inode.c
index 0571983..b73c2c9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1183,7 +1183,12 @@ void generic_delete_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(generic_delete_inode);
 
-static void generic_forget_inode(struct inode *inode)
+/*
+ * Remove inode from inode lists, write it if it's dirty.
+ *
+ * Returns 1 if inode should be completely destroyed.
+ */
+int generic_detach_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -1193,7 +1198,7 @@ static void generic_forget_inode(struct inode *inode)
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
-			return;
+			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
@@ -1211,6 +1216,14 @@ static void generic_forget_inode(struct inode *inode)
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
+	return 1;
+}
+EXPORT_SYMBOL(generic_detach_inode);
+
+static void generic_forget_inode(struct inode *inode)
+{
+	if (!generic_detach_inode(inode))
+		return;
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b534e5..6955c5a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2144,6 +2144,7 @@ extern ino_t iunique(struct super_block *, ino_t);
 extern int inode_needs_sync(struct inode *inode);
 extern void generic_delete_inode(struct inode *inode);
 extern void generic_drop_inode(struct inode *inode);
+extern int generic_detach_inode(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),
-- 
1.6.0.2

