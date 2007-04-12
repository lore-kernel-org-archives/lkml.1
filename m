Return-Path: <linux-kernel-owner+w=401wt.eu-S1161538AbXDLCys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161538AbXDLCys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161540AbXDLCyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:46 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161532AbXDLCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=lI/rxesCc2Q4Oep8rdu54a71BNa2VC0MnI9J1Kj6N7v/XbUzyqiVWQRdiA9sUyoOOTujwf1AZwNQ8Hw6/KzBD1dCFztxkTUEJ/11awYjFjr/cJBEKq51iaPpAkFW1UnEouSrlUH9luUZDWUbsgldyIYq4wDInWi18hD29xZ/Chw=
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
Message-Id: <20070412024938.27380.99703.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 16/17] ufs: convert ufs_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ufs_get_page()/ufs_get_locked_page() and
ufs_put_page()/ufs_put_locked_page() using the new read_kmap_page() and
put_kmapped_page() calls and their locking variants.  Also, change the
ufs_check_page() call to return the page's error status, and update the
call sites accordingly.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ufs/balloc.c linux-2.6.21-rc5-mm4-test/fs/ufs/balloc.c
--- linux-2.6.21-rc5-mm4/fs/ufs/balloc.c	2007-04-05 17:13:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ufs/balloc.c	2007-04-06 12:46:02.000000000 -0700
@@ -272,7 +272,7 @@ static void ufs_change_blocknr(struct in
 		index = i >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
-			page = ufs_get_locked_page(mapping, index);
+			page = __read_mapping_page(mapping, index, NULL);
 			if (!page)/* it was truncated */
 				continue;
 			if (IS_ERR(page)) {/* or EIO */
@@ -325,8 +325,10 @@ static void ufs_change_blocknr(struct in
 			bh = bh->b_this_page;
 		} while (bh != head);
 
-		if (likely(cur_index != index))
-			ufs_put_locked_page(page);
+		if (likely(cur_index != index)) {
+			unlock_page(page);
+			page_cache_release(page);
+		}
  	}
 	UFSD("EXIT\n");
 }
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ufs/truncate.c linux-2.6.21-rc5-mm4-test/fs/ufs/truncate.c
--- linux-2.6.21-rc5-mm4/fs/ufs/truncate.c	2007-04-05 17:13:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ufs/truncate.c	2007-04-06 12:46:14.000000000 -0700
@@ -395,8 +395,9 @@ static int ufs_alloc_lastblock(struct in
 
 	lastfrag--;
 
-	lastpage = ufs_get_locked_page(mapping, lastfrag >>
-				       (PAGE_CACHE_SHIFT - inode->i_blkbits));
+	lastpage = __read_mapping_page(mapping, lastfrag >>
+				       (PAGE_CACHE_SHIFT - inode->i_blkbits),
+				       NULL);
        if (IS_ERR(lastpage)) {
                err = -EIO;
                goto out;
@@ -441,7 +442,8 @@ static int ufs_alloc_lastblock(struct in
 	       }
        }
 out_unlock:
-       ufs_put_locked_page(lastpage);
+       unlock_page(lastpage);
+       page_cache_release(lastpage);
 out:
        return err;
 }
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ufs/util.c linux-2.6.21-rc5-mm4-test/fs/ufs/util.c
--- linux-2.6.21-rc5-mm4/fs/ufs/util.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ufs/util.c	2007-04-06 12:40:53.000000000 -0700
@@ -232,55 +232,3 @@ ufs_set_inode_dev(struct super_block *sb
 		ufsi->i_u1.i_data[0] = cpu_to_fs32(sb, fs32);
 }
 
-/**
- * ufs_get_locked_page() - locate, pin and lock a pagecache page, if not exist
- * read it from disk.
- * @mapping: the address_space to search
- * @index: the page index
- *
- * Locates the desired pagecache page, if not exist we'll read it,
- * locks it, increments its reference
- * count and returns its address.
- *
- */
-
-struct page *ufs_get_locked_page(struct address_space *mapping,
-				 pgoff_t index)
-{
-	struct page *page;
-
-	page = find_lock_page(mapping, index);
-	if (!page) {
-		page = read_mapping_page(mapping, index, NULL);
-
-		if (IS_ERR(page)) {
-			printk(KERN_ERR "ufs_change_blocknr: "
-			       "read_mapping_page error: ino %lu, index: %lu\n",
-			       mapping->host->i_ino, index);
-			goto out;
-		}
-
-		lock_page(page);
-
-		if (unlikely(page->mapping == NULL)) {
-			/* Truncate got there first */
-			unlock_page(page);
-			page_cache_release(page);
-			page = NULL;
-			goto out;
-		}
-
-		if (!PageUptodate(page) || PageError(page)) {
-			unlock_page(page);
-			page_cache_release(page);
-
-			printk(KERN_ERR "ufs_change_blocknr: "
-			       "can not read page: ino %lu, index: %lu\n",
-			       mapping->host->i_ino, index);
-
-			page = ERR_PTR(-EIO);
-		}
-	}
-out:
-	return page;
-}
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ufs/util.h linux-2.6.21-rc5-mm4-test/fs/ufs/util.h
--- linux-2.6.21-rc5-mm4/fs/ufs/util.h	2007-04-05 17:13:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ufs/util.h	2007-04-06 12:46:36.000000000 -0700
@@ -251,16 +251,6 @@ extern void _ubh_ubhcpymem_(struct ufs_s
 #define ubh_memcpyubh(ubh,mem,size) _ubh_memcpyubh_(uspi,ubh,mem,size)
 extern void _ubh_memcpyubh_(struct ufs_sb_private_info *, struct ufs_buffer_head *, unsigned char *, unsigned);
 
-/* This functions works with cache pages*/
-extern struct page *ufs_get_locked_page(struct address_space *mapping,
-					pgoff_t index);
-static inline void ufs_put_locked_page(struct page *page)
-{
-       unlock_page(page);
-       page_cache_release(page);
-}
-
-
 /*
  * macros and inline function to get important structures from ufs_sb_private_info
  */
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ufs/dir.c linux-2.6.21-rc5-mm4-test/fs/ufs/dir.c
--- linux-2.6.21-rc5-mm4/fs/ufs/dir.c	2007-04-06 12:27:03.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ufs/dir.c	2007-04-06 14:43:23.000000000 -0700
@@ -51,12 +51,6 @@ static int ufs_commit_chunk(struct page 
 	return err;
 }
 
-static inline void ufs_put_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-}
-
 static inline unsigned long ufs_dir_pages(struct inode *inode)
 {
 	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
@@ -71,7 +65,7 @@ ino_t ufs_inode_by_name(struct inode *di
 	de = ufs_find_entry(dir, dentry, &page);
 	if (de) {
 		res = fs32_to_cpu(dir->i_sb, de->d_ino);
-		ufs_put_page(page);
+		put_kmapped_page(page);
 	}
 	return res;
 }
@@ -91,13 +85,13 @@ void ufs_set_link(struct inode *dir, str
 	de->d_ino = cpu_to_fs32(dir->i_sb, inode->i_ino);
 	ufs_set_de_type(dir->i_sb, de, inode->i_mode);
 	err = ufs_commit_chunk(page, from, to);
-	ufs_put_page(page);
+	put_kmapped_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
 }
 
 
-static void ufs_check_page(struct page *page)
+static int ufs_check_page(struct page *page)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
@@ -108,6 +102,14 @@ static void ufs_check_page(struct page *
 	struct ufs_dir_entry *p;
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
 		if (limit & chunk_mask)
@@ -135,7 +137,7 @@ static void ufs_check_page(struct page *
 		goto Eend;
 out:
 	SetPageChecked(page);
-	return;
+	return 0;
 
 	/* Too bad, we had an error */
 
@@ -174,24 +176,8 @@ Eend:
 fail:
 	SetPageChecked(page);
 	SetPageError(page);
-}
-
-static struct page *ufs_get_page(struct inode *dir, unsigned long n)
-{
-	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (!PageChecked(page))
-			ufs_check_page(page);
-		if (PageError(page))
-			goto fail;
-	}
-	return page;
-
-fail:
-	ufs_put_page(page);
-	return ERR_PTR(-EIO);
+	put_kmapped_page(page);
+	return -EIO;
 }
 
 /*
@@ -218,10 +204,10 @@ ufs_next_entry(struct super_block *sb, s
 
 struct ufs_dir_entry *ufs_dotdot(struct inode *dir, struct page **p)
 {
-	struct page *page = ufs_get_page(dir, 0);
+	struct page *page = read_kmap_page(dir->i_mapping, 0);
 	struct ufs_dir_entry *de = NULL;
 
-	if (!IS_ERR(page)) {
+	if (!IS_ERR(page) && !ufs_check_page(page)) {
 		de = ufs_next_entry(dir->i_sb,
 				    (struct ufs_dir_entry *)page_address(page));
 		*p = page;
@@ -265,8 +251,8 @@ struct ufs_dir_entry *ufs_find_entry(str
 	n = start;
 	do {
 		char *kaddr;
-		page = ufs_get_page(dir, n);
-		if (!IS_ERR(page)) {
+		page = read_kmap_page(dir->i_mapping, n);
+		if (!IS_ERR(page) && !ufs_check_page(page)) {
 			kaddr = page_address(page);
 			de = (struct ufs_dir_entry *) kaddr;
 			kaddr += ufs_last_byte(dir, n) - reclen;
@@ -274,14 +260,14 @@ struct ufs_dir_entry *ufs_find_entry(str
 				if (de->d_reclen == 0) {
 					ufs_error(dir->i_sb, __FUNCTION__,
 						  "zero-length directory entry");
-					ufs_put_page(page);
+					put_kmapped_page(page);
 					goto out;
 				}
 				if (ufs_match(sb, namelen, name, de))
 					goto found;
 				de = ufs_next_entry(sb, de);
 			}
-			ufs_put_page(page);
+			put_kmapped_page(page);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -325,11 +311,13 @@ int ufs_add_link(struct dentry *dentry, 
 	for (n = 0; n <= npages; n++) {
 		char *dir_end;
 
-		page = ufs_get_page(dir, n);
+		page = __read_kmap_page(dir->i_mapping, n);
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto out;
-		lock_page(page);
+		err = ufs_check_page(page);
+		if (err)
+			goto out_unlock;
 		kaddr = page_address(page);
 		dir_end = kaddr + ufs_last_byte(dir, n);
 		de = (struct ufs_dir_entry *)kaddr;
@@ -360,8 +348,7 @@ int ufs_add_link(struct dentry *dentry, 
 				goto got_it;
 			de = (struct ufs_dir_entry *) ((char *) de + rec_len);
 		}
-		unlock_page(page);
-		ufs_put_page(page);
+		put_locked_page(page);
 	}
 	BUG();
 	return -EINVAL;
@@ -391,13 +378,12 @@ got_it:
 
 	mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
-out_put:
-	ufs_put_page(page);
+	put_kmapped_page(page);
 out:
 	return err;
 out_unlock:
-	unlock_page(page);
-	goto out_put;
+	put_locked_page(page);
+	return err;
 }
 
 static inline unsigned
@@ -440,9 +426,9 @@ ufs_readdir(struct file *filp, void *dir
 		char *kaddr, *limit;
 		struct ufs_dir_entry *de;
 
-		struct page *page = ufs_get_page(inode, n);
+		struct page *page = read_kmap_page(inode->i_mapping, n);
 
-		if (IS_ERR(page)) {
+		if (IS_ERR(page) || ufs_check_page(page)) {
 			ufs_error(sb, __FUNCTION__,
 				  "bad page in #%lu",
 				  inode->i_ino);
@@ -464,7 +450,7 @@ ufs_readdir(struct file *filp, void *dir
 			if (de->d_reclen == 0) {
 				ufs_error(sb, __FUNCTION__,
 					"zero-length directory entry");
-				ufs_put_page(page);
+				put_kmapped_page(page);
 				return -EIO;
 			}
 			if (de->d_ino) {
@@ -485,13 +471,13 @@ ufs_readdir(struct file *filp, void *dir
 						(n<<PAGE_CACHE_SHIFT) | offset,
 					       fs32_to_cpu(sb, de->d_ino), d_type);
 				if (over) {
-					ufs_put_page(page);
+					put_kmapped_page(page);
 					return 0;
 				}
 			}
 			filp->f_pos += fs16_to_cpu(sb, de->d_reclen);
 		}
-		ufs_put_page(page);
+		put_kmapped_page(page);
 	}
 	return 0;
 }
@@ -542,7 +528,7 @@ int ufs_delete_entry(struct inode *inode
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 out:
-	ufs_put_page(page);
+	put_kmapped_page(page);
 	UFSD("EXIT\n");
 	return err;
 }
@@ -604,9 +590,9 @@ int ufs_empty_dir(struct inode * inode)
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		struct ufs_dir_entry *de;
-		page = ufs_get_page(inode, i);
+		page = read_kmap_page(inode->i_mapping, i);
 
-		if (IS_ERR(page))
+		if (IS_ERR(page) || ufs_check_page(page))
 			continue;
 
 		kaddr = page_address(page);
@@ -636,12 +622,12 @@ int ufs_empty_dir(struct inode * inode)
 			}
 			de = ufs_next_entry(sb, de);
 		}
-		ufs_put_page(page);
+		put_kmapped_page(page);
 	}
 	return 1;
 
 not_empty:
-	ufs_put_page(page);
+	put_kmapped_page(page);
 	return 0;
 }
 
