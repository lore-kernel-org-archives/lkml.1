Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYABRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYABRiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYABRir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:38:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYABRir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:38:47 -0500
Message-ID: <477BCC1F.5@redhat.com>
Date: Wed, 02 Jan 2008 11:38:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] UPDATED2: hfs: handle more on-disk corruptions without oopsing
References: <47699C29.4010706@redhat.com> <476A8F36.2050007@redhat.com> <200712240316.43308.zippel@linux-m68k.org>
In-Reply-To: <200712240316.43308.zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman, with this on top does it look better to you?
I'll get hfsplus done in a bit.

Thanks,
-Eric

-----------------

Fix up previous hfs fsfuzzer patch to address Roman's comments.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

diff -u linux-2.6.24-rc3/fs/hfs/brec.c linux-2.6.24-rc3/fs/hfs/brec.c
--- linux-2.6.24-rc3/fs/hfs/brec.c
+++ linux-2.6.24-rc3/fs/hfs/brec.c
@@ -49,14 +49,14 @@
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
diff -u linux-2.6.24-rc3/fs/hfs/bfind.c linux-2.6.24-rc3/fs/hfs/bfind.c
--- linux-2.6.24-rc3/fs/hfs/bfind.c
+++ linux-2.6.24-rc3/fs/hfs/bfind.c
@@ -52,7 +52,7 @@
 		rec = (e + b) / 2;
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
 			goto fail;
 		}
@@ -71,7 +71,7 @@
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
 			goto fail;
 		}
@@ -207,7 +207,7 @@
 
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
-	if (keylen == HFS_BAD_KEYLEN) {
+	if (keylen == 0) {
 		res = -EINVAL;
 		goto out;
 	}
diff -u linux-2.6.24-rc3/fs/hfs/hfs.h linux-2.6.24-rc3/fs/hfs/hfs.h
--- linux-2.6.24-rc3/fs/hfs/hfs.h
+++ linux-2.6.24-rc3/fs/hfs/hfs.h
@@ -28,8 +28,6 @@
 #define HFS_MAX_NAMELEN		128
 #define HFS_MAX_VALENCE		32767U
 
-#define HFS_BAD_KEYLEN		0xFF
-
 /* Meanings of the drAtrb field of the MDB,
  * Reference: _Inside Macintosh: Files_ p. 2-61
  */
diff -u linux-2.6.24-rc3/fs/hfs/btree.c linux-2.6.24-rc3/fs/hfs/btree.c
--- linux-2.6.24-rc3/fs/hfs/btree.c
+++ linux-2.6.24-rc3/fs/hfs/btree.c
@@ -81,15 +81,23 @@
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
 


