Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXLSWdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXLSWdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 17:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXLSWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 17:33:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXLSWdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 17:33:23 -0500
Message-ID: <47699C29.4010706@redhat.com>
Date: Wed, 19 Dec 2007 16:33:13 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] hfs: handle more on-disk corruptions without oopsing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfs seems prone to bad things when it encounters on disk corruption.
Many values are read from disk, and used as lengths to memcpy, as an
example.  This patch fixes up several of these problematic cases.

o sanity check the on-disk maximum key lengths on mount
  (these are set to a defined value at mkfs time and shouldn't differ)
o check on-disk node keylens against the maximum key length for each tree
o fix hfs_btree_open so that going out via free_tree: doesn't wind
  up in hfs_releasepage, which wants to follow the very pointer
  we were trying to set up:
	HFS_SB(sb)->cat_tree = hfs_btree_open()
		...
		failure gets to hfs_releasepage and tries
		to follow HFS_SB(sb)->cat_tree

Tested with the fsfuzzer; it survives more than it used to.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24-rc3/fs/hfs/brec.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/hfs/brec.c
+++ linux-2.6.24-rc3/fs/hfs/brec.c
@@ -44,10 +44,21 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 		recoff = hfs_bnode_read_u16(node, node->tree->node_size - (rec + 1) * 2);
 		if (!recoff)
 			return 0;
-		if (node->tree->attributes & HFS_TREE_BIGKEYS)
+		if (node->tree->attributes & HFS_TREE_BIGKEYS) {
 			retval = hfs_bnode_read_u16(node, recoff) + 2;
-		else
+			if (retval > node->tree->max_key_len + 2) {
+				printk(KERN_ERR "hfs: keylen %d too large\n",
+					retval);
+				retval = HFS_BAD_KEYLEN;
+			}
+		} else {
 			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
+			if (retval > node->tree->max_key_len + 1) {
+				printk(KERN_ERR "hfs: keylen %d too large\n",
+					retval);
+				retval = HFS_BAD_KEYLEN;
+			}
+		}
 	}
 	return retval;
 }
Index: linux-2.6.24-rc3/fs/hfs/bfind.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/hfs/bfind.c
+++ linux-2.6.24-rc3/fs/hfs/bfind.c
@@ -52,6 +52,11 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		rec = (e + b) / 2;
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
+		if (keylen == HFS_BAD_KEYLEN) {
+			printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
+			res = -EINVAL;
+			goto done;
+		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 		cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
 		if (!cmpval) {
@@ -67,6 +72,11 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
+		if (keylen == HFS_BAD_KEYLEN) {
+			printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
+			res = -EINVAL;
+			goto done;
+		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 	}
 done:
@@ -198,6 +208,11 @@ int hfs_brec_goto(struct hfs_find_data *
 
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
+	if (keylen == HFS_BAD_KEYLEN) {
+		printk(KERN_ERR "hfs: keylen %d too long\n", keylen);
+		res = -EINVAL;
+		goto out;
+	}
 	fd->keyoffset = off;
 	fd->keylength = keylen;
 	fd->entryoffset = off + keylen;
Index: linux-2.6.24-rc3/fs/hfs/hfs.h
===================================================================
--- linux-2.6.24-rc3.orig/fs/hfs/hfs.h
+++ linux-2.6.24-rc3/fs/hfs/hfs.h
@@ -28,6 +28,8 @@
 #define HFS_MAX_NAMELEN		128
 #define HFS_MAX_VALENCE		32767U
 
+#define HFS_BAD_KEYLEN		0xFF
+
 /* Meanings of the drAtrb field of the MDB,
  * Reference: _Inside Macintosh: Files_ p. 2-61
  */
@@ -167,6 +169,9 @@ typedef union hfs_btree_key {
 	struct hfs_ext_key ext;
 } hfs_btree_key;
 
+#define HFS_MAX_CAT_KEYLEN	(sizeof(struct hfs_cat_key) - sizeof(u8))
+#define HFS_MAX_EXT_KEYLEN	(sizeof(struct hfs_ext_key) - sizeof(u8))
+
 typedef union hfs_btree_key btree_key;
 
 struct hfs_extent {
Index: linux-2.6.24-rc3/fs/hfs/btree.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/hfs/btree.c
+++ linux-2.6.24-rc3/fs/hfs/btree.c
@@ -81,6 +81,17 @@ struct hfs_btree *hfs_btree_open(struct 
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
+	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
+		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
+			tree->max_key_len);
+		goto fail_page;
+	}
+	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
+		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
+			tree->max_key_len);
+		goto fail_page;
+	}
+
 	tree->node_size_shift = ffs(size) - 1;
 	tree->pages_per_bnode = (tree->node_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
@@ -89,9 +100,9 @@ struct hfs_btree *hfs_btree_open(struct 
 	return tree;
 
  fail_page:
-	tree->inode->i_mapping->a_ops = &hfs_aops;
 	page_cache_release(page);
  free_tree:
+	tree->inode->i_mapping->a_ops = &hfs_aops;
 	iput(tree->inode);
 	kfree(tree);
 	return NULL;


