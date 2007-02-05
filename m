Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXBELtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXBELtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXBELtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:49:53 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:5315 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932107AbXBELtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:49:51 -0500
Date: Mon, 5 Feb 2007 14:56:02 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Bailey <dsbailey@pacbell.net>
Subject: [PATCH]: ufs: restore back support of openstep
Message-ID: <20070205115602.GA16493@rain>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Bailey <dsbailey@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix of regression, which triggered by ~2.6.16.

Patch with name ufs-directory-and-page-cache-from-blocks-to-pages.patch:
in additional to conversation from block to page cache
mechanism added new checks of directory integrity,
one of them that directory entry do not across directory chunks.

But some kinds of UFS: OpenStep UFS and Apple UFS (looks like these
are the same filesystems) have different directory chunk size,
then common UFSes(BSD and Solaris UFS).

So this patch adds ability to works with variable size of directory chunks,
and set it for ufstype=openstep to right size.

Tested on darwin ufs.

This patch designed to be on top of UFS patches which are situated 
in -mm branch, after applying it, other 3 patches(UFS2 write support)
will produce warnings like: HUNK succeeded, but I tested,
they works as expected,
should I resend them?

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.20-rc7/fs/ufs/dir.c
===================================================================
--- linux-2.6.20-rc7.orig/fs/ufs/dir.c
+++ linux-2.6.20-rc7/fs/ufs/dir.c
@@ -106,12 +106,13 @@ static void ufs_check_page(struct page *
 	char *kaddr = page_address(page);
 	unsigned offs, rec_len;
 	unsigned limit = PAGE_CACHE_SIZE;
+	const unsigned chunk_mask = UFS_SB(sb)->s_uspi->s_dirblksize - 1;
 	struct ufs_dir_entry *p;
 	char *error;
 
 	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
 		limit = dir->i_size & ~PAGE_CACHE_MASK;
-		if (limit & (UFS_SECTOR_SIZE - 1))
+		if (limit & chunk_mask)
 			goto Ebadsize;
 		if (!limit)
 			goto out;
@@ -126,7 +127,7 @@ static void ufs_check_page(struct page *
 			goto Ealign;
 		if (rec_len < UFS_DIR_REC_LEN(ufs_get_de_namlen(sb, p)))
 			goto Enamelen;
-		if (((offs + rec_len - 1) ^ offs) & ~(UFS_SECTOR_SIZE-1))
+		if (((offs + rec_len - 1) ^ offs) & ~chunk_mask)
 			goto Espan;
 		if (fs32_to_cpu(sb, p->d_ino) > (UFS_SB(sb)->s_uspi->s_ipg *
 						  UFS_SB(sb)->s_uspi->s_ncg))
@@ -310,6 +311,7 @@ int ufs_add_link(struct dentry *dentry, 
 	int namelen = dentry->d_name.len;
 	struct super_block *sb = dir->i_sb;
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
+	const unsigned int chunk_size = UFS_SB(sb)->s_uspi->s_dirblksize;
 	unsigned short rec_len, name_len;
 	struct page *page = NULL;
 	struct ufs_dir_entry *de;
@@ -342,8 +344,8 @@ int ufs_add_link(struct dentry *dentry, 
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
 				name_len = 0;
-				rec_len = UFS_SECTOR_SIZE;
-				de->d_reclen = cpu_to_fs16(sb, UFS_SECTOR_SIZE);
+				rec_len = chunk_size;
+				de->d_reclen = cpu_to_fs16(sb, chunk_size);
 				de->d_ino = 0;
 				goto got_it;
 			}
@@ -431,7 +433,7 @@ ufs_readdir(struct file *filp, void *dir
 	unsigned int offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
 	unsigned long npages = ufs_dir_pages(inode);
-	unsigned chunk_mask = ~(UFS_SECTOR_SIZE - 1);
+	unsigned chunk_mask = ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	int need_revalidate = filp->f_version != inode->i_version;
 	unsigned flags = UFS_SB(sb)->s_flags;
 
@@ -511,7 +513,7 @@ int ufs_delete_entry(struct inode *inode
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = page->mapping;
 	char *kaddr = page_address(page);
-	unsigned from = ((char*)dir - kaddr) & ~(UFS_SECTOR_SIZE - 1);
+	unsigned from = ((char*)dir - kaddr) & ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	unsigned to = ((char*)dir - kaddr) + fs16_to_cpu(sb, dir->d_reclen);
 	struct ufs_dir_entry *pde = NULL;
 	struct ufs_dir_entry *de = (struct ufs_dir_entry *) (kaddr + from);
@@ -556,6 +558,7 @@ int ufs_make_empty(struct inode * inode,
 	struct super_block * sb = dir->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page = grab_cache_page(mapping, 0);
+	const unsigned int chunk_size = UFS_SB(sb)->s_uspi->s_dirblksize;
 	struct ufs_dir_entry * de;
 	char *base;
 	int err;
@@ -563,7 +566,7 @@ int ufs_make_empty(struct inode * inode,
 	if (!page)
 		return -ENOMEM;
 	kmap(page);
-	err = mapping->a_ops->prepare_write(NULL, page, 0, UFS_SECTOR_SIZE);
+	err = mapping->a_ops->prepare_write(NULL, page, 0, chunk_size);
 	if (err) {
 		unlock_page(page);
 		goto fail;
@@ -584,11 +587,11 @@ int ufs_make_empty(struct inode * inode,
 		((char *)de + fs16_to_cpu(sb, de->d_reclen));
 	de->d_ino = cpu_to_fs32(sb, dir->i_ino);
 	ufs_set_de_type(sb, de, dir->i_mode);
-	de->d_reclen = cpu_to_fs16(sb, UFS_SECTOR_SIZE - UFS_DIR_REC_LEN(1));
+	de->d_reclen = cpu_to_fs16(sb, chunk_size - UFS_DIR_REC_LEN(1));
 	ufs_set_de_namlen(sb, de, 2);
 	strcpy (de->d_name, "..");
 
-	err = ufs_commit_chunk(page, 0, UFS_SECTOR_SIZE);
+	err = ufs_commit_chunk(page, 0, chunk_size);
 fail:
 	kunmap(page);
 	page_cache_release(page);
Index: linux-2.6.20-rc7/fs/ufs/super.c
===================================================================
--- linux-2.6.20-rc7.orig/fs/ufs/super.c
+++ linux-2.6.20-rc7/fs/ufs/super.c
@@ -649,7 +649,7 @@ static int ufs_fill_super(struct super_b
 		kmalloc (sizeof(struct ufs_sb_private_info), GFP_KERNEL);
 	if (!uspi)
 		goto failed;
-
+	uspi->s_dirblksize = UFS_SECTOR_SIZE;
 	super_block_offset=UFS_SBLOCK;
 
 	/* Keep 2Gig file limit. Some UFS variants need to override 
@@ -718,6 +718,7 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP:
+		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
@@ -733,6 +734,7 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP_CD:
+		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep-cd\n");
 		uspi->s_fsize = block_size = 2048;
 		uspi->s_fmask = ~(2048 - 1);
@@ -754,6 +756,7 @@ static int ufs_fill_super(struct super_b
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
Index: linux-2.6.20-rc7/include/linux/ufs_fs.h
===================================================================
--- linux-2.6.20-rc7.orig/include/linux/ufs_fs.h
+++ linux-2.6.20-rc7/include/linux/ufs_fs.h
@@ -789,6 +789,7 @@ struct ufs_sb_private_info {
 
 	__u32	s_maxsymlinklen;/* upper limit on fast symlinks' size */
 	__s32	fs_magic;       /* filesystem magic */
+	unsigned int s_dirblksize;
 };
 
 /*
-- 
/Evgeniy

