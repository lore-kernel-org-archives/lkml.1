Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXJYQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXJYQnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXJYQgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:36:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbXJYQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:36:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/31] IGET: Stop HFSPLUS from using iget() and read_inode()
	[try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:35:30 +0100
Message-ID: <20071025163530.5057.28106.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the HFSPLUS filesystem from using iget() and read_inode().  Replace
hfsplus_read_inode() with hfsplus_iget(), and call that instead of iget().
hfsplus_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

hfsplus_fill_super() returns any error incurred when getting the root inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/hfsplus/btree.c      |    6 ++++--
 fs/hfsplus/dir.c        |    6 +++---
 fs/hfsplus/hfsplus_fs.h |    3 +++
 fs/hfsplus/super.c      |   47 +++++++++++++++++++++++++++++++++--------------
 4 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index 050d29c..bb54336 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -22,6 +22,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	struct hfs_btree *tree;
 	struct hfs_btree_header_rec *head;
 	struct address_space *mapping;
+	struct inode *inode;
 	struct page *page;
 	unsigned int size;
 
@@ -33,9 +34,10 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	spin_lock_init(&tree->hash_lock);
 	tree->sb = sb;
 	tree->cnid = id;
-	tree->inode = iget(sb, id);
-	if (!tree->inode)
+	inode = hfsplus_iget(sb, id);
+	if (IS_ERR(inode))
 		goto free_tree;
+	tree->inode = inode;
 
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 1955ee6..2968364 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -97,9 +97,9 @@ again:
 		goto fail;
 	}
 	hfs_find_exit(&fd);
-	inode = iget(dir->i_sb, cnid);
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	inode = hfsplus_iget(dir->i_sb, cnid);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	if (S_ISREG(inode->i_mode))
 		HFSPLUS_I(inode).dev = linkid;
 out:
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index d9f5eda..d72d0a8 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -345,6 +345,9 @@ int hfsplus_parse_options(char *, struct hfsplus_sb_info *);
 void hfsplus_fill_defaults(struct hfsplus_sb_info *);
 int hfsplus_show_options(struct seq_file *, struct vfsmount *);
 
+/* super.c */
+struct inode *hfsplus_iget(struct super_block *, unsigned long);
+
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
 extern u16 hfsplus_decompose_table[];
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ecf70da..b0f9ad3 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -20,11 +20,18 @@ static void hfsplus_destroy_inode(struct inode *inode);
 
 #include "hfsplus_fs.h"
 
-static void hfsplus_read_inode(struct inode *inode)
+struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 {
 	struct hfs_find_data fd;
 	struct hfsplus_vh *vhdr;
-	int err;
+	struct inode *inode;
+	long err = -EIO;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
 	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
@@ -41,7 +48,7 @@ static void hfsplus_read_inode(struct inode *inode)
 		hfs_find_exit(&fd);
 		if (err)
 			goto bad_inode;
-		return;
+		goto done;
 	}
 	vhdr = HFSPLUS_SB(inode->i_sb).s_vhdr;
 	switch(inode->i_ino) {
@@ -70,10 +77,13 @@ static void hfsplus_read_inode(struct inode *inode)
 		goto bad_inode;
 	}
 
-	return;
+done:
+	unlock_new_inode(inode);
+	return inode;
 
- bad_inode:
-	make_bad_inode(inode);
+bad_inode:
+	iget_failed(inode);
+	return ERR_PTR(err);
 }
 
 static int hfsplus_write_inode(struct inode *inode, int unused)
@@ -262,7 +272,6 @@ static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations hfsplus_sops = {
 	.alloc_inode	= hfsplus_alloc_inode,
 	.destroy_inode	= hfsplus_destroy_inode,
-	.read_inode	= hfsplus_read_inode,
 	.write_inode	= hfsplus_write_inode,
 	.clear_inode	= hfsplus_clear_inode,
 	.put_super	= hfsplus_put_super,
@@ -278,7 +287,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	struct hfsplus_sb_info *sbi;
 	hfsplus_cat_entry entry;
 	struct hfs_find_data fd;
-	struct inode *root;
+	struct inode *root, *inode;
 	struct qstr str;
 	struct nls_table *nls = NULL;
 	int err = -EINVAL;
@@ -366,18 +375,25 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 		goto cleanup;
 	}
 
-	HFSPLUS_SB(sb).alloc_file = iget(sb, HFSPLUS_ALLOC_CNID);
-	if (!HFSPLUS_SB(sb).alloc_file) {
+	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
+	if (IS_ERR(inode)) {
 		printk(KERN_ERR "hfs: failed to load allocation file\n");
+		err = PTR_ERR(inode);
 		goto cleanup;
 	}
+	HFSPLUS_SB(sb).alloc_file = inode;
 
 	/* Load the root directory */
-	root = iget(sb, HFSPLUS_ROOT_CNID);
+	root = hfsplus_iget(sb, HFSPLUS_ROOT_CNID);
+	if (IS_ERR(root)) {
+		printk(KERN_ERR "hfs: failed to load root directory\n");
+		err = PTR_ERR(root);
+		goto cleanup;
+	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
-		printk(KERN_ERR "hfs: failed to load root directory\n");
 		iput(root);
+		err = -ENOMEM;
 		goto cleanup;
 	}
 	sb->s_root->d_op = &hfsplus_dentry_operations;
@@ -390,9 +406,12 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER))
 			goto cleanup;
-		HFSPLUS_SB(sb).hidden_dir = iget(sb, be32_to_cpu(entry.folder.id));
-		if (!HFSPLUS_SB(sb).hidden_dir)
+		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
 			goto cleanup;
+		}
+		HFSPLUS_SB(sb).hidden_dir = inode;
 	} else
 		hfs_find_exit(&fd);
 

