Return-Path: <linux-kernel-owner+w=401wt.eu-S1161540AbXDLCzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161540AbXDLCzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161528AbXDLCyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161538AbXDLCyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=nU4R6kxWJXwB3Ibj3rPCfTSfV9dVT3JYRmjXhqprQ7Q+M/wqZhyDvbGri6jWuhj4WJLvyqHV64MY4vBgDcfElBnMqCr+712YCPClXSxRwUk3uOgUmgVNbL5h4XKokwo4jXAgcV/KWT0WMH6CBvSU1kUYQRnfEem+9pVOUoMgrbc=
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
Message-Id: <20070412024938.27380.62718.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 17/17] vxfs: convert vxfs_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace vxfs_get_page() with the new read_kmap_page().

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_extern.h linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_extern.h
--- linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_extern.h	2007-04-05 17:13:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_extern.h	2007-04-06 01:59:19.000000000 -0700
@@ -69,7 +69,6 @@ extern const struct file_operations	vxfs
 extern int			vxfs_read_olt(struct super_block *, u_long);
 
 /* vxfs_subr.c */
-extern struct page *		vxfs_get_page(struct address_space *, u_long);
 extern void			vxfs_put_page(struct page *);
 extern struct buffer_head *	vxfs_bread(struct inode *, int);
 
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_inode.c linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_inode.c
--- linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_inode.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_inode.c	2007-04-06 01:59:19.000000000 -0700
@@ -138,7 +138,7 @@ __vxfs_iget(ino_t ino, struct inode *ili
 	u_long				offset;
 
 	offset = (ino % (PAGE_SIZE / VXFS_ISIZE)) * VXFS_ISIZE;
-	pp = vxfs_get_page(ilistp->i_mapping, ino * VXFS_ISIZE / PAGE_SIZE);
+	pp = read_kmap_page(ilistp->i_mapping, ino * VXFS_ISIZE / PAGE_SIZE);
 
 	if (!IS_ERR(pp)) {
 		struct vxfs_inode_info	*vip;
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_lookup.c linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_lookup.c
--- linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_lookup.c	2007-04-05 17:13:29.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_lookup.c	2007-04-06 01:59:19.000000000 -0700
@@ -125,7 +125,7 @@ vxfs_find_entry(struct inode *ip, struct
 		caddr_t			kaddr;
 		struct page		*pp;
 
-		pp = vxfs_get_page(ip->i_mapping, page);
+		pp = read_kmap_page(ip->i_mapping, page);
 		if (IS_ERR(pp))
 			continue;
 		kaddr = (caddr_t)page_address(pp);
@@ -280,7 +280,7 @@ vxfs_readdir(struct file *fp, void *retp
 		caddr_t			kaddr;
 		struct page		*pp;
 
-		pp = vxfs_get_page(ip->i_mapping, page);
+		pp = read_kmap_page(ip->i_mapping, page);
 		if (IS_ERR(pp))
 			continue;
 		kaddr = (caddr_t)page_address(pp);
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_subr.c linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_subr.c
--- linux-2.6.21-rc5-mm4/fs/freevxfs/vxfs_subr.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/freevxfs/vxfs_subr.c	2007-04-06 01:59:19.000000000 -0700
@@ -56,39 +56,6 @@ vxfs_put_page(struct page *pp)
 }
 
 /**
- * vxfs_get_page - read a page into memory.
- * @ip:		inode to read from
- * @n:		page number
- *
- * Description:
- *   vxfs_get_page reads the @n th page of @ip into the pagecache.
- *
- * Returns:
- *   The wanted page on success, else a NULL pointer.
- */
-struct page *
-vxfs_get_page(struct address_space *mapping, u_long n)
-{
-	struct page *			pp;
-
-	pp = read_mapping_page(mapping, n, NULL);
-
-	if (!IS_ERR(pp)) {
-		kmap(pp);
-		/** if (!PageChecked(pp)) **/
-			/** vxfs_check_page(pp); **/
-		if (PageError(pp))
-			goto fail;
-	}
-	
-	return (pp);
-		 
-fail:
-	vxfs_put_page(pp);
-	return ERR_PTR(-EIO);
-}
-
-/**
  * vxfs_bread - read buffer for a give inode,block tuple
  * @ip:		inode
  * @block:	logical block
