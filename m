Return-Path: <linux-kernel-owner+w=401wt.eu-S1161534AbXDLCyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161534AbXDLCyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161528AbXDLCyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:04 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161540AbXDLCxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=pulXdWF9C00aWyYIrfCszUDN7aVlc7+u/Jx0OYdr2f7K1l2/pqcTv4xoUTqo1cqCEBl/bTIQ/tmMfZ/roef0nHKom+J8Kj8WBgxyO4HvdtZkf9tcf2PXssCDvTbpy8bDYn5eS+b2eyqMcCigwJIoNqMjX2M8QyZRA3VFsmNpIW4=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.14505.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 14/17] reiserfs: convert reiserfs_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace reiserfs_get_page() and reiserfs_put_page() using the new
read_kmap_page() and put_kmapped_page() calls and their locking variants. 
Also, propagate the gfp_mask() deadlock comment to callsites.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/reiserfs/xattr.c linux-2.6.21-rc5-mm4-test/fs/reiserfs/xattr.c
--- linux-2.6.21-rc5-mm4/fs/reiserfs/xattr.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/reiserfs/xattr.c	2007-04-06 14:41:34.000000000 -0700
@@ -438,33 +438,6 @@ int xattr_readdir(struct file *file, fil
 	return res;
 }
 
-/* Internal operations on file data */
-static inline void reiserfs_put_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-}
-
-static struct page *reiserfs_get_page(struct inode *dir, unsigned long n)
-{
-	struct address_space *mapping = dir->i_mapping;
-	struct page *page;
-	/* We can deadlock if we try to free dentries,
-	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (PageError(page))
-			goto fail;
-	}
-	return page;
-
-      fail:
-	reiserfs_put_page(page);
-	return ERR_PTR(-EIO);
-}
-
 static inline __u32 xattr_hash(const char *msg, int len)
 {
 	return csum_partial(msg, len, 0);
@@ -537,13 +510,15 @@ reiserfs_xattr_set(struct inode *inode, 
 		else
 			chunk = buffer_size - buffer_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		/* We can deadlock if we try to free dentries,
+		   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
+		mapping_set_gfp_mask(mapping, GFP_NOFS);
+		page = __read_kmap_page(mapping, file_pos >> PAGE_CACHE_SHIFT);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_filp;
 		}
 
-		lock_page(page);
 		data = page_address(page);
 
 		if (file_pos == 0) {
@@ -566,8 +541,7 @@ reiserfs_xattr_set(struct inode *inode, 
 							 page_offset + chunk +
 							 skip);
 		}
-		unlock_page(page);
-		reiserfs_put_page(page);
+		put_locked_page(page);
 		buffer_pos += chunk;
 		file_pos += chunk;
 		skip = 0;
@@ -646,13 +620,15 @@ reiserfs_xattr_get(const struct inode *i
 		else
 			chunk = isize - file_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		/* We can deadlock if we try to free dentries,
+		   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
+		mapping_set_gfp_mask(xinode->i_mapping, GFP_NOFS);
+		page = __read_kmap_page(xinode->i_mapping, file_pos >> PAGE_CACHE_SHIFT);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_dput;
 		}
 
-		lock_page(page);
 		data = page_address(page);
 		if (file_pos == 0) {
 			struct reiserfs_xattr_header *rxh =
@@ -661,8 +637,7 @@ reiserfs_xattr_get(const struct inode *i
 			chunk -= skip;
 			/* Magic doesn't match up.. */
 			if (rxh->h_magic != cpu_to_le32(REISERFS_XATTR_MAGIC)) {
-				unlock_page(page);
-				reiserfs_put_page(page);
+				put_locked_page(page);
 				reiserfs_warning(inode->i_sb,
 						 "Invalid magic for xattr (%s) "
 						 "associated with %k", name,
@@ -673,8 +648,7 @@ reiserfs_xattr_get(const struct inode *i
 			hash = le32_to_cpu(rxh->h_hash);
 		}
 		memcpy(buffer + buffer_pos, data + skip, chunk);
-		unlock_page(page);
-		reiserfs_put_page(page);
+		put_locked_page(page);
 		file_pos += chunk;
 		buffer_pos += chunk;
 		skip = 0;
