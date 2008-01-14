Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYANVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYANVP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYANVPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:15:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbYANVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:15:40 -0500
Message-ID: <478BD0D8.8070101@redhat.com>
Date: Mon, 14 Jan 2008 15:15:04 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
CC: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] address hfs on-disk corruption robustness review comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address Roman's review comments for the previously sent on-disk
corruption hfs robustness patch.

I still owe a patch for hfsplus.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---



Index: linux-2.6.24-rc6-mm1/fs/hfs/bfind.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/hfs/bfind.c
+++ linux-2.6.24-rc6-mm1/fs/hfs/bfind.c
@@ -52,9 +52,9 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		rec = (e + b) / 2;
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
-			goto done;
+			goto fail;
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 		cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
@@ -71,9 +71,9 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
-			goto done;
+			goto fail;
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 	}
@@ -83,6 +83,7 @@ done:
 	fd->keylength = keylen;
 	fd->entryoffset = off + keylen;
 	fd->entrylength = len - keylen;
+fail:
 	return res;
 }
 
@@ -206,7 +207,7 @@ int hfs_brec_goto(struct hfs_find_data *
 
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
-	if (keylen == HFS_BAD_KEYLEN) {
+	if (keylen == 0) {
 		res = -EINVAL;
 		goto out;
 	}
Index: linux-2.6.24-rc6-mm1/fs/hfs/brec.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/hfs/brec.c
+++ linux-2.6.24-rc6-mm1/fs/hfs/brec.c
@@ -49,14 +49,14 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 			if (retval > node->tree->max_key_len + 2) {
 				printk(KERN_ERR "hfs: keylen %d too large\n",
 					retval);
-				retval = HFS_BAD_KEYLEN;
+				retval = 0;
 			}
 		} else {
 			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
 			if (retval > node->tree->max_key_len + 1) {
 				printk(KERN_ERR "hfs: keylen %d too large\n",
 					retval);
-				retval = HFS_BAD_KEYLEN;
+				retval = 0;
 			}
 		}
 	}
Index: linux-2.6.24-rc6-mm1/fs/hfs/btree.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/hfs/btree.c
+++ linux-2.6.24-rc6-mm1/fs/hfs/btree.c
@@ -81,15 +81,23 @@ struct hfs_btree *hfs_btree_open(struct 
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
-	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
-		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
-			tree->max_key_len);
-		goto fail_page;
-	}
-	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
-		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
-			tree->max_key_len);
-		goto fail_page;
+	switch(id) {
+	case HFS_EXT_CNID:
+		if (tree->max_key_len != HFS_MAX_EXT_KEYLEN) {
+			printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
+				tree->max_key_len);
+			goto fail_page;
+		}
+		break;
+	case HFS_CAT_CNID:
+		if (tree->max_key_len != HFS_MAX_CAT_KEYLEN) {
+			printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
+				tree->max_key_len);
+			goto fail_page;
+		}
+		break;
+	default:
+		BUG();
 	}
 
 	tree->node_size_shift = ffs(size) - 1;
Index: linux-2.6.24-rc6-mm1/fs/hfs/hfs.h
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/hfs/hfs.h
+++ linux-2.6.24-rc6-mm1/fs/hfs/hfs.h
@@ -28,8 +28,6 @@
 #define HFS_MAX_NAMELEN		128
 #define HFS_MAX_VALENCE		32767U
 
-#define HFS_BAD_KEYLEN		0xFF
-
 /* Meanings of the drAtrb field of the MDB,
  * Reference: _Inside Macintosh: Files_ p. 2-61
  */

