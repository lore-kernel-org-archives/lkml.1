Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXLSBHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXLSBHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXLSBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:07:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXLSBHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:07:03 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] IGET: Handle errors in ISOFS correctly
To: akpm@linux-foundation.org
Cc: hidave.darkstar@gmail.com, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       hch@lst.de, jack@ucw.cz, linux-kernel@vger.kernel.org
Date: Wed, 19 Dec 2007 01:06:45 +0000
Message-ID: <20071219010645.26352.22255.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle errors in ISOFS correctly.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/isofs/inode.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a854831..4d76594 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -841,7 +841,7 @@ root_found:
 	sbi->s_joliet_level = joliet_level;
 
 	/* check the root inode */
-	if (!inode)
+	if (IS_ERR(inode))
 		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
@@ -875,11 +875,12 @@ root_found:
 	 */
 out_bad_root:
 	printk(KERN_WARNING "%s: root inode not initialized\n", __func__);
-	goto out_iput;
-out_no_root:
-	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_iput:
 	iput(inode);
+	goto out_no_inode;
+out_no_root:
+	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
+out_no_inode:
 #ifdef CONFIG_JOLIET
 	if (sbi->s_nls_iocharset)
 		unload_nls(sbi->s_nls_iocharset);
@@ -929,7 +930,7 @@ static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
 /*
  * Get a set of blocks; filling in buffer_heads if already allocated
  * or getblk() if they are not.  Returns the number of blocks inserted
- * (0 == error.)
+ * (-ve == error.)
  */
 int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 		     struct buffer_head **bh, unsigned long nblocks)
@@ -939,11 +940,12 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 	unsigned int firstext;
 	unsigned long nextblk, nextoff;
 	long iblock = (long)iblock_s;
-	int section, rv;
+	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	lock_kernel();
 
+	error = -EIO;
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
 		printk(KERN_DEBUG "%s: block number too large\n", __func__);
@@ -982,8 +984,10 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 			offset += sect_size;
 			ninode = isofs_iget(inode->i_sb, nextblk, nextoff);
-			if (!ninode)
+			if (IS_ERR(ninode)) {
+				error = PTR_ERR(ninode);
 				goto abort;
+			}
 			firstext  = ISOFS_I(ninode)->i_first_extent;
 			sect_size = ISOFS_I(ninode)->i_section_size >> ISOFS_BUFFER_BITS(ninode);
 			nextblk   = ISOFS_I(ninode)->i_next_section_block;
@@ -1016,7 +1020,7 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 abort:
 	unlock_kernel();
-	return rv;
+	return rv != 0 ? rv : error;
 }
 
 /*
@@ -1030,7 +1034,7 @@ static int isofs_get_block(struct inode *inode, sector_t iblock,
 		return -EROFS;
 	}
 
-	return isofs_get_blocks(inode, iblock, &bh_result, 1) ? 0 : -EIO;
+	return isofs_get_blocks(inode, iblock, &bh_result, 1);
 }
 
 static int isofs_bmap(struct inode *inode, sector_t block)

