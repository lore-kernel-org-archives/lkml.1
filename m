Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZFCWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZFCWNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZFCWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:13:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:40315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZFCWNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:13:07 -0400
Date: Thu, 4 Jun 2009 00:13:07 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, wli@holomorphy.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vfs: Split generic_forget_inode() so that hugetlbfs
	does not have to copy it
Message-ID: <20090603221307.GA14241@duck.suse.cz>
References: <1243959634-22067-1-git-send-email-jack@suse.cz> <20090603155638.GA29914@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603155638.GA29914@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-06-09 11:56:38, Christoph Hellwig wrote:
> On Tue, Jun 02, 2009 at 06:20:34PM +0200, Jan Kara wrote:
> > Hugetlbfs needs to do special things instead of truncate_inode_pages().
> > Currently, it copied generic_forget_inode() except for truncate_inode_pages()
> > call which is asking for trouble (the code there isn't trivial). So create a
> > separate function generic_detach_inode() which does all the list magic done in
> > generic_forget_inode() and call it from hugetlbfs_forget_inode().
> 
> Looks good to me, but long term I'd just prefer to have
> truncate_inode_pages do the right thing for huge pages..
  That would be nice but I don't know how to do that (being completely
ignorant of hugepages ;).

> > +/*
> > + * Remove inode from inode lists, write it if it's dirty.
> > + *
> > + * Returns 1 if inode should be completely destroyed.
> > + */
> 
> Please make this a kerneldoc comment.  And mention that this is just
> and internal helper that can go away any time.
  Fixed. Resulting patch below...

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 2dcb48492bd7f56e56a52e7b8ea867c1942a7c34 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 2 Jun 2009 18:06:24 +0200
Subject: [PATCH] vfs: Split generic_forget_inode() so that hugetlbfs does not have to copy it (V2)

Hugetlbfs needs to do special things instead of truncate_inode_pages().
Currently, it copied generic_forget_inode() except for truncate_inode_pages()
call which is asking for trouble (the code there isn't trivial). So create a
separate function generic_detach_inode() which does all the list magic done in
generic_forget_inode() and call it from hugetlbfs_forget_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c |   33 ++++-----------------------------
 fs/inode.c           |   21 +++++++++++++++++++--
 include/linux/fs.h   |    1 +
 3 files changed, 24 insertions(+), 31 deletions(-)

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
index 0571983..990bf83 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1183,7 +1183,16 @@ void generic_delete_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(generic_delete_inode);
 
-static void generic_forget_inode(struct inode *inode)
+/**
+ *	generic_detach_inode - remove inode from inode lists
+ *	@inode: inode to remove
+ *
+ *	Remove inode from inode lists, write it if it's dirty. This is just an
+ *	internal VFS helper exported for hugetlbfs. Do not use!
+ *
+ *	Returns 1 if inode should be completely destroyed.
+ */
+int generic_detach_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -1193,7 +1202,7 @@ static void generic_forget_inode(struct inode *inode)
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
-			return;
+			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
@@ -1211,6 +1220,14 @@ static void generic_forget_inode(struct inode *inode)
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(generic_detach_inode);
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

