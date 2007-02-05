Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXBESFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXBESFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXBESFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:05:33 -0500
Received: from verein.lst.de ([213.95.11.210]:36587 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXBESFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:05:32 -0500
Date: Mon, 5 Feb 2007 19:05:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] move remove_dquot_ref to dqout.c
Message-ID: <20070205180527.GA26951@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove_dquot_ref can move to dqout.c instead of beeing in inode.c
under #ifdef CONFIG_QUOTA.  Also clean the resulting code up
a tiny little bit by testing sb->dq_op earlier - it's constant
over a filesystems lifetime.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/dquot.c
===================================================================
--- linux-2.6.orig/fs/dquot.c	2007-02-05 18:49:41.000000000 +0100
+++ linux-2.6/fs/dquot.c	2007-02-05 18:53:49.000000000 +0100
@@ -79,6 +79,7 @@
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
+#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
 
 #include <asm/uaccess.h>
 
@@ -756,15 +757,30 @@
 	}
 }
 
+static void remove_dquot_ref(struct super_block *sb, int type,
+		struct list_head *tofree_head)
+{
+	struct inode *inode;
+
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (!IS_NOQUOTA(inode))
+			remove_inode_dquot_ref(inode, type, tofree_head);
+	}
+	spin_unlock(&inode_lock);
+}
+
 /* Gather all references from inodes and drop them */
 static void drop_dquot_ref(struct super_block *sb, int type)
 {
 	LIST_HEAD(tofree_head);
 
-	down_write(&sb_dqopt(sb)->dqptr_sem);
-	remove_dquot_ref(sb, type, &tofree_head);
-	up_write(&sb_dqopt(sb)->dqptr_sem);
-	put_dquot_list(&tofree_head);
+	if (sb->dq_op) {
+		down_write(&sb_dqopt(sb)->dqptr_sem);
+		remove_dquot_ref(sb, type, &tofree_head);
+		up_write(&sb_dqopt(sb)->dqptr_sem);
+		put_dquot_list(&tofree_head);
+	}
 }
 
 static inline void dquot_incr_inodes(struct dquot *dquot, unsigned long number)
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2007-02-05 18:49:41.000000000 +0100
+++ linux-2.6/fs/inode.c	2007-02-05 18:49:56.000000000 +0100
@@ -1252,33 +1252,6 @@
 
 EXPORT_SYMBOL(inode_needs_sync);
 
-/*
- *	Quota functions that want to walk the inode lists..
- */
-#ifdef CONFIG_QUOTA
-
-void remove_dquot_ref(struct super_block *sb, int type,
-			struct list_head *tofree_head)
-{
-	struct inode *inode;
-
-	if (!sb->dq_op)
-		return;	/* nothing to do */
-	spin_lock(&inode_lock);	/* This lock is for inodes code */
-
-	/*
-	 * We don't have to lock against quota code - test IS_QUOTAINIT is
-	 * just for speedup...
-	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list)
-		if (!IS_NOQUOTA(inode))
-			remove_inode_dquot_ref(inode, type, tofree_head);
-
-	spin_unlock(&inode_lock);
-}
-
-#endif
-
 int inode_wait(void *word)
 {
 	schedule();
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2007-02-05 18:51:48.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2007-02-05 18:51:52.000000000 +0100
@@ -1681,7 +1681,6 @@
 extern int __remove_suid(struct dentry *, int);
 extern int should_remove_suid(struct dentry *);
 extern int remove_suid(struct dentry *);
-extern void remove_dquot_ref(struct super_block *, int, struct list_head *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
