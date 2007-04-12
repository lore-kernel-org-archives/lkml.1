Return-Path: <linux-kernel-owner+w=401wt.eu-S1161509AbXDLCv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509AbXDLCv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161515AbXDLCvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:55 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161514AbXDLCvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=jYaNuVfNYqnQ7a7Vp5EmV7XijxlMtmNv53XrdOdinpsUY3d3Mqt3z7PcunTA8+ILjzktdaoN985qaBTXiMLZJ1KfOpRUc5ljOyrbQtpc0nW/nNX7O/0aoTSdMniiApdmc1thlyHjWoAD1GkRByVdojiTq/NVBWspq6YoZAh3d2g=
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
Message-Id: <20070412024938.27380.7486.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 4/17] ext2: convert ext2_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ext2_get_page() and ext2_put_page() using the new read_kmap_page()
and put_kmapped_page() calls.  Also, change the ext2_check_page() call to
return the page's error status, and update the call sites accordingly.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ext2/dir.c linux-2.6.21-rc5-mm4-test/fs/ext2/dir.c
--- linux-2.6.21-rc5-mm4/fs/ext2/dir.c	2007-04-06 12:27:03.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ext2/dir.c	2007-04-06 14:34:23.000000000 -0700
@@ -35,12 +35,6 @@ static inline unsigned ext2_chunk_size(s
 	return inode->i_sb->s_blocksize;
 }
 
-static inline void ext2_put_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-}
-
 static inline unsigned long dir_pages(struct inode *inode)
 {
 	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
@@ -74,7 +68,7 @@ static int ext2_commit_chunk(struct page
 	return err;
 }
 
-static void ext2_check_page(struct page *page)
+static int ext2_check_page(struct page *page)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
@@ -86,6 +80,14 @@ static void ext2_check_page(struct page 
 	ext2_dirent *p;
 	char *error;
 
+	if (likely(PageChecked(page))) {
+		if (likely(!PageError(page)))
+			return 0;
+
+		put_kmapped_page(page);
+		return -EIO;
+	}
+
 	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
 		limit = dir->i_size & ~PAGE_CACHE_MASK;
 		if (limit & (chunk_size - 1))
@@ -112,7 +114,7 @@ static void ext2_check_page(struct page 
 		goto Eend;
 out:
 	SetPageChecked(page);
-	return;
+	return 0;
 
 	/* Too bad, we had an error */
 
@@ -153,24 +155,8 @@ Eend:
 fail:
 	SetPageChecked(page);
 	SetPageError(page);
-}
-
-static struct page * ext2_get_page(struct inode *dir, unsigned long n)
-{
-	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (!PageChecked(page))
-			ext2_check_page(page);
-		if (PageError(page))
-			goto fail;
-	}
-	return page;
-
-fail:
-	ext2_put_page(page);
-	return ERR_PTR(-EIO);
+	put_kmapped_page(page);
+	return -EIO;
 }
 
 /*
@@ -262,9 +248,9 @@ ext2_readdir (struct file * filp, void *
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
 		ext2_dirent *de;
-		struct page *page = ext2_get_page(inode, n);
+		struct page *page = read_kmap_page(inode->i_mapping, n);
 
-		if (IS_ERR(page)) {
+		if (IS_ERR(page) || ext2_check_page(page)) {
 			ext2_error(sb, __FUNCTION__,
 				   "bad page in #%lu",
 				   inode->i_ino);
@@ -286,7 +272,7 @@ ext2_readdir (struct file * filp, void *
 			if (de->rec_len == 0) {
 				ext2_error(sb, __FUNCTION__,
 					"zero-length directory entry");
-				ext2_put_page(page);
+				put_kmapped_page(page);
 				return -EIO;
 			}
 			if (de->inode) {
@@ -301,13 +287,13 @@ ext2_readdir (struct file * filp, void *
 						(n<<PAGE_CACHE_SHIFT) | offset,
 						le32_to_cpu(de->inode), d_type);
 				if (over) {
-					ext2_put_page(page);
+					put_kmapped_page(page);
 					return 0;
 				}
 			}
 			filp->f_pos += le16_to_cpu(de->rec_len);
 		}
-		ext2_put_page(page);
+		put_kmapped_page(page);
 	}
 	return 0;
 }
@@ -344,8 +330,8 @@ struct ext2_dir_entry_2 * ext2_find_entr
 	n = start;
 	do {
 		char *kaddr;
-		page = ext2_get_page(dir, n);
-		if (!IS_ERR(page)) {
+		page = read_kmap_page(dir->i_mapping, n);
+		if (!IS_ERR(page) && !ext2_check_page(page)) {
 			kaddr = page_address(page);
 			de = (ext2_dirent *) kaddr;
 			kaddr += ext2_last_byte(dir, n) - reclen;
@@ -353,14 +339,14 @@ struct ext2_dir_entry_2 * ext2_find_entr
 				if (de->rec_len == 0) {
 					ext2_error(dir->i_sb, __FUNCTION__,
 						"zero-length directory entry");
-					ext2_put_page(page);
+					put_kmapped_page(page);
 					goto out;
 				}
 				if (ext2_match (namelen, name, de))
 					goto found;
 				de = ext2_next_entry(de);
 			}
-			ext2_put_page(page);
+			put_kmapped_page(page);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -384,10 +370,10 @@ found:
 
 struct ext2_dir_entry_2 * ext2_dotdot (struct inode *dir, struct page **p)
 {
-	struct page *page = ext2_get_page(dir, 0);
+	struct page *page = read_kmap_page(dir->i_mapping, 0);
 	ext2_dirent *de = NULL;
 
-	if (!IS_ERR(page)) {
+	if (!IS_ERR(page) && !ext2_check_page(page)) {
 		de = ext2_next_entry((ext2_dirent *) page_address(page));
 		*p = page;
 	}
@@ -403,7 +389,7 @@ ino_t ext2_inode_by_name(struct inode * 
 	de = ext2_find_entry (dir, dentry, &page);
 	if (de) {
 		res = le32_to_cpu(de->inode);
-		ext2_put_page(page);
+		put_kmapped_page(page);
 	}
 	return res;
 }
@@ -422,7 +408,7 @@ void ext2_set_link(struct inode *dir, st
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
 	err = ext2_commit_chunk(page, from, to);
-	ext2_put_page(page);
+	put_kmapped_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
@@ -455,9 +441,9 @@ int ext2_add_link (struct dentry *dentry
 	for (n = 0; n <= npages; n++) {
 		char *dir_end;
 
-		page = ext2_get_page(dir, n);
+		page = read_kmap_page(dir->i_mapping, n);
 		err = PTR_ERR(page);
-		if (IS_ERR(page))
+		if (IS_ERR(page) || (err = ext2_check_page(page)))
 			goto out;
 		lock_page(page);
 		kaddr = page_address(page);
@@ -491,7 +477,7 @@ int ext2_add_link (struct dentry *dentry
 			de = (ext2_dirent *) ((char *) de + rec_len);
 		}
 		unlock_page(page);
-		ext2_put_page(page);
+		put_kmapped_page(page);
 	}
 	BUG();
 	return -EINVAL;
@@ -518,7 +504,7 @@ got_it:
 	mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	ext2_put_page(page);
+	put_kmapped_page(page);
 out:
 	return err;
 out_unlock:
@@ -564,7 +550,7 @@ int ext2_delete_entry (struct ext2_dir_e
 	EXT2_I(inode)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(inode);
 out:
-	ext2_put_page(page);
+	put_kmapped_page(page);
 	return err;
 }
 
@@ -620,9 +606,9 @@ int ext2_empty_dir (struct inode * inode
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		ext2_dirent * de;
-		page = ext2_get_page(inode, i);
+		page = read_kmap_page(inode->i_mapping, i);
 
-		if (IS_ERR(page))
+		if (IS_ERR(page) || ext2_check_page(page))
 			continue;
 
 		kaddr = page_address(page);
@@ -651,12 +637,12 @@ int ext2_empty_dir (struct inode * inode
 			}
 			de = ext2_next_entry(de);
 		}
-		ext2_put_page(page);
+		put_kmapped_page(page);
 	}
 	return 1;
 
 not_empty:
-	ext2_put_page(page);
+	put_kmapped_page(page);
 	return 0;
 }
 
