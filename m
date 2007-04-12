Return-Path: <linux-kernel-owner+w=401wt.eu-S1161510AbXDLCvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510AbXDLCvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161513AbXDLCvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161509AbXDLCvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=PzBiGrNuGYvigjbJPE/mttPyTAq2DoJ3SvueExs6iMHivglPthvsmtsdVdfFBYXGfD0AucMZb2vSGuu52CTdbwBvvq7Ua1UXcBfeNmHppBmsWXWne7gJefW8g41bw5L3SMA5P5UgrxDPcV398Drm4fjT4pPqaLqEWgcoSGrsFG4=
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
Message-Id: <20070412024938.27380.44677.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace afs_dir_get_page() and afs_dir_put_page() using the new
read_kmap_page() and put_kmapped_page() calls, and eliminate unnecessary
PageError checks.  Also, change the afs_dir_check_page() call to return
the page's error status, and update the call site accordingly.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/afs/dir.c linux-2.6.21-rc5-mm4-test/fs/afs/dir.c
--- linux-2.6.21-rc5-mm4/fs/afs/dir.c	2007-04-06 12:27:03.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/afs/dir.c	2007-04-06 14:30:22.000000000 -0700
@@ -115,12 +115,15 @@ struct afs_dir_lookup_cookie {
 /*
  * check that a directory page is valid
  */
-static inline void afs_dir_check_page(struct inode *dir, struct page *page)
+static inline int afs_dir_check_page(struct inode *dir, struct page *page)
 {
 	struct afs_dir_page *dbuf;
 	loff_t latter;
 	int tmp, qty;
 
+	if (likely(PageChecked(page)))
+		return PageError(page);
+
 #if 0
 	/* check the page count */
 	qty = desc.size / sizeof(dbuf->blocks[0]);
@@ -154,52 +157,16 @@ static inline void afs_dir_check_page(st
 	}
 
 	SetPageChecked(page);
-	return;
+	return 0;
 
  error:
 	SetPageChecked(page);
 	SetPageError(page);
-
+	return 1;
 } /* end afs_dir_check_page() */
 
 /*****************************************************************************/
 /*
- * discard a page cached in the pagecache
- */
-static inline void afs_dir_put_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-
-} /* end afs_dir_put_page() */
-
-/*****************************************************************************/
-/*
- * get a page into the pagecache
- */
-static struct page *afs_dir_get_page(struct inode *dir, unsigned long index)
-{
-	struct page *page;
-
-	_enter("{%lu},%lu", dir->i_ino, index);
-
-	page = read_mapping_page(dir->i_mapping, index, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (!PageChecked(page))
-			afs_dir_check_page(dir, page);
-		if (PageError(page))
-			goto fail;
-	}
-	return page;
-
- fail:
-	afs_dir_put_page(page);
-	return ERR_PTR(-EIO);
-} /* end afs_dir_get_page() */
-
-/*****************************************************************************/
-/*
  * open an AFS directory file
  */
 static int afs_dir_open(struct inode *inode, struct file *file)
@@ -344,11 +311,16 @@ static int afs_dir_iterate(struct inode 
 		blkoff = *fpos & ~(sizeof(union afs_dir_block) - 1);
 
 		/* fetch the appropriate page from the directory */
-		page = afs_dir_get_page(dir, blkoff / PAGE_SIZE);
+		page = read_kmap_page(dir->i_mapping, blkoff / PAGE_SIZE);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			break;
 		}
+		if (afs_check_page(dir, page)) {
+			err = -EIO;
+			put_kmapped_page(page);
+			break;
+		}
 
 		limit = blkoff & ~(PAGE_SIZE - 1);
 
@@ -361,7 +333,7 @@ static int afs_dir_iterate(struct inode 
 			ret = afs_dir_iterate_block(fpos, dblock, blkoff,
 						    cookie, filldir);
 			if (ret != 1) {
-				afs_dir_put_page(page);
+				put_kmapped_page(page);
 				goto out;
 			}
 
@@ -369,7 +341,7 @@ static int afs_dir_iterate(struct inode 
 
 		} while (*fpos < dir->i_size && blkoff < limit);
 
-		afs_dir_put_page(page);
+		put_kmapped_page(page);
 		ret = 0;
 	}
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/afs/mntpt.c linux-2.6.21-rc6-mm1-test/fs/afs/mntpt.c
--- linux-2.6.21-rc6-mm1/fs/afs/mntpt.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/afs/mntpt.c	2007-04-10 21:22:07.000000000 -0700
@@ -74,11 +74,6 @@ int afs_mntpt_check_symlink(struct afs_v
 		ret = PTR_ERR(page);
 		goto out;
 	}
-
-	ret = -EIO;
-	if (PageError(page))
-		goto out_free;
-
 	buf = kmap(page);
 
 	/* examine the symlink's contents */
@@ -98,7 +93,6 @@ int afs_mntpt_check_symlink(struct afs_v
 	ret = 0;
 
 	kunmap(page);
- out_free:
 	page_cache_release(page);
  out:
 	_leave(" = %d", ret);
@@ -180,10 +174,6 @@ static struct vfsmount *afs_mntpt_do_aut
 		goto error;
 	}
 
-	ret = -EIO;
-	if (PageError(page))
-		goto error;
-
 	buf = kmap(page);
 	memcpy(devname, buf, size);
 	kunmap(page);
