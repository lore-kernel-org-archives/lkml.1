Return-Path: <linux-kernel-owner+w=401wt.eu-S1161518AbXDLCxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161518AbXDLCxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161512AbXDLCxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:53:01 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161518AbXDLCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=M0rNIHoD3AmPyXyUx8r94C0nHqUCRVgHKqGMj6AsxTqcVROgK6z2WLnlKnU8e8a55z/Qv3utjOJYk89UpyUijhFvmXrBArreC7lS8Rn5Y/wyUxPjBgsNwJJ49XWydmnB+t1oLz5xO/FA7GLPBthyotzStA84rXzHm98U0whVlMU=
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
Message-Id: <20070412024938.27380.8778.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 9/17] minix: convert dir_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace minix dir_get_page() and dir_put_page() using the new
read_kmap_page() and put_kmapped_page()/put_locked_page() calls.  Also, use
__read_kmap_page() instead of re-taking the page_lock.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/minix/dir.c linux-2.6.21-rc5-mm4-test/fs/minix/dir.c
--- linux-2.6.21-rc5-mm4/fs/minix/dir.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/minix/dir.c	2007-04-06 02:31:55.000000000 -0700
@@ -23,12 +23,6 @@ const struct file_operations minix_dir_o
 	.fsync		= minix_sync_file,
 };
 
-static inline void dir_put_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
@@ -60,22 +54,6 @@ static int dir_commit_chunk(struct page 
 	return err;
 }
 
-static struct page * dir_get_page(struct inode *dir, unsigned long n)
-{
-	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (!PageUptodate(page))
-			goto fail;
-	}
-	return page;
-
-fail:
-	dir_put_page(page);
-	return ERR_PTR(-EIO);
-}
-
 static inline void *minix_next_entry(void *de, struct minix_sb_info *sbi)
 {
 	return (void*)((char*)de + sbi->s_dirsize);
@@ -102,7 +80,7 @@ static int minix_readdir(struct file * f
 
 	for ( ; n < npages; n++, offset = 0) {
 		char *p, *kaddr, *limit;
-		struct page *page = dir_get_page(inode, n);
+		struct page *page = read_kmap_page(inode->i_mapping, n);
 
 		if (IS_ERR(page))
 			continue;
@@ -128,12 +106,12 @@ static int minix_readdir(struct file * f
 					(n << PAGE_CACHE_SHIFT) | offset,
 					inumber, DT_UNKNOWN);
 				if (over) {
-					dir_put_page(page);
+					put_kmapped_page(page);
 					goto done;
 				}
 			}
 		}
-		dir_put_page(page);
+		put_kmapped_page(page);
 	}
 
 done:
@@ -177,7 +155,7 @@ minix_dirent *minix_find_entry(struct de
 	for (n = 0; n < npages; n++) {
 		char *kaddr, *limit;
 
-		page = dir_get_page(dir, n);
+		page = read_kmap_page(dir->i_mapping, n);
 		if (IS_ERR(page))
 			continue;
 
@@ -198,7 +176,7 @@ minix_dirent *minix_find_entry(struct de
 			if (namecompare(namelen, sbi->s_namelen, name, namx))
 				goto found;
 		}
-		dir_put_page(page);
+		put_kmapped_page(page);
 	}
 	return NULL;
 
@@ -233,11 +211,10 @@ int minix_add_link(struct dentry *dentry
 	for (n = 0; n <= npages; n++) {
 		char *limit, *dir_end;
 
-		page = dir_get_page(dir, n);
+		page = __read_kmap_page(dir->i_mapping, n);
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto out;
-		lock_page(page);
 		kaddr = (char*)page_address(page);
 		dir_end = kaddr + minix_last_byte(dir, n);
 		limit = kaddr + PAGE_CACHE_SIZE - sbi->s_dirsize;
@@ -265,8 +242,7 @@ int minix_add_link(struct dentry *dentry
 			if (namecompare(namelen, sbi->s_namelen, name, namx))
 				goto out_unlock;
 		}
-		unlock_page(page);
-		dir_put_page(page);
+		put_locked_page(page);
 	}
 	BUG();
 	return -EINVAL;
@@ -288,13 +264,12 @@ got_it:
 	err = dir_commit_chunk(page, from, to);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
-out_put:
-	dir_put_page(page);
+	put_kmapped_page(page);
 out:
 	return err;
 out_unlock:
-	unlock_page(page);
-	goto out_put;
+	put_locked_page(page);
+	return err;
 }
 
 int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
@@ -314,7 +289,7 @@ int minix_delete_entry(struct minix_dir_
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
+	put_kmapped_page(page);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	return err;
@@ -378,7 +353,7 @@ int minix_empty_dir(struct inode * inode
 	for (i = 0; i < npages; i++) {
 		char *p, *kaddr, *limit;
 
-		page = dir_get_page(inode, i);
+		page = read_kmap_page(inode->i_mapping, i);
 		if (IS_ERR(page))
 			continue;
 
@@ -408,12 +383,12 @@ int minix_empty_dir(struct inode * inode
 					goto not_empty;
 			}
 		}
-		dir_put_page(page);
+		put_kmapped_page(page);
 	}
 	return 1;
 
 not_empty:
-	dir_put_page(page);
+	put_kmapped_page(page);
 	return 0;
 }
 
@@ -435,14 +410,14 @@ void minix_set_link(struct minix_dir_ent
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
+	put_kmapped_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
 }
 
 struct minix_dir_entry * minix_dotdot (struct inode *dir, struct page **p)
 {
-	struct page *page = dir_get_page(dir, 0);
+	struct page *page = read_kmap_page(dir->i_mapping, 0);
 	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
 	struct minix_dir_entry *de = NULL;
 
@@ -461,7 +436,7 @@ ino_t minix_inode_by_name(struct dentry 
 
 	if (de) {
 		res = de->inode;
-		dir_put_page(page);
+		put_kmapped_page(page);
 	}
 	return res;
 }
