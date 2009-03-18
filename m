Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZCRSK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZCRSK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZCRSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:10:08 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:20724 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753947AbZCRSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:10:03 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/8] exofs: dir_inode and directory operations
Date: Wed, 18 Mar 2009 20:08:49 +0200
Message-Id: <1237399729-29465-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-OriginalArrivalTime: 18 Mar 2009 18:09:58.0944 (UTC) FILETIME=[BFDB2A00:01C9A7F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

implementation of directory and inode operations.

* A directory is treated as a file, and essentially contains a list
  of <file name, inode #> pairs for files that are found in that
  directory. The object IDs correspond to the files' inode numbers
  and are allocated using a 64bit incrementing global counter.
* Each file's control block (AKA on-disk inode) is stored in its
  object's attributes. This applies to both regular files and other
  types (directories, device files, symlinks, etc.).

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild  |    2 +-
 fs/exofs/dir.c   |  656 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/exofs/exofs.h |   26 +++
 fs/exofs/inode.c |  272 ++++++++++++++++++++++
 fs/exofs/namei.c |  342 ++++++++++++++++++++++++++++
 5 files changed, 1297 insertions(+), 1 deletions(-)
 create mode 100644 fs/exofs/dir.c
 create mode 100644 fs/exofs/namei.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index 42d5299..d5c8c54 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-y := osd.o inode.o file.o symlink.o
+exofs-y := osd.o inode.o file.o symlink.o namei.o dir.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
new file mode 100644
index 0000000..0ca733a
--- /dev/null
+++ b/fs/exofs/dir.c
@@ -0,0 +1,656 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "exofs.h"
+
+static inline unsigned exofs_chunk_size(struct inode *inode)
+{
+	return inode->i_sb->s_blocksize;
+}
+
+static inline void exofs_put_page(struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+static inline unsigned long dir_pages(struct inode *inode)
+{
+	return (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+}
+
+static unsigned exofs_last_byte(struct inode *inode, unsigned long page_nr)
+{
+	unsigned last_byte = inode->i_size;
+
+	last_byte -= page_nr << PAGE_CACHE_SHIFT;
+	if (last_byte > PAGE_CACHE_SIZE)
+		last_byte = PAGE_CACHE_SIZE;
+	return last_byte;
+}
+
+static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
+	int err = 0;
+
+	dir->i_version++;
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+
+	if (pos+len > dir->i_size) {
+		i_size_write(dir, pos+len);
+		mark_inode_dirty(dir);
+	}
+	set_page_dirty(page);
+
+	if (IS_DIRSYNC(dir))
+		err = write_one_page(page, 1);
+	else
+		unlock_page(page);
+
+	return err;
+}
+
+static void exofs_check_page(struct page *page)
+{
+	struct inode *dir = page->mapping->host;
+	unsigned chunk_size = exofs_chunk_size(dir);
+	char *kaddr = page_address(page);
+	unsigned offs, rec_len;
+	unsigned limit = PAGE_CACHE_SIZE;
+	struct exofs_dir_entry *p;
+	char *error;
+
+	/* if the page is the last one in the directory */
+	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
+		limit = dir->i_size & ~PAGE_CACHE_MASK;
+		if (limit & (chunk_size - 1))
+			goto Ebadsize;
+		if (!limit)
+			goto out;
+	}
+	for (offs = 0; offs <= limit - EXOFS_DIR_REC_LEN(1); offs += rec_len) {
+		p = (struct exofs_dir_entry *)(kaddr + offs);
+		rec_len = le16_to_cpu(p->rec_len);
+
+		if (rec_len < EXOFS_DIR_REC_LEN(1))
+			goto Eshort;
+		if (rec_len & 3)
+			goto Ealign;
+		if (rec_len < EXOFS_DIR_REC_LEN(p->name_len))
+			goto Enamelen;
+		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
+			goto Espan;
+	}
+	if (offs != limit)
+		goto Eend;
+out:
+	SetPageChecked(page);
+	return;
+
+Ebadsize:
+	EXOFS_ERR("ERROR [exofs_check_page]: "
+		"size of directory #%lu is not a multiple of chunk size",
+		dir->i_ino
+	);
+	goto fail;
+Eshort:
+	error = "rec_len is smaller than minimal";
+	goto bad_entry;
+Ealign:
+	error = "unaligned directory entry";
+	goto bad_entry;
+Enamelen:
+	error = "rec_len is too small for name_len";
+	goto bad_entry;
+Espan:
+	error = "directory entry across blocks";
+	goto bad_entry;
+bad_entry:
+	EXOFS_ERR(
+		"ERROR [exofs_check_page]: bad entry in directory #%lu: %s - "
+		"offset=%lu, inode=%llu, rec_len=%d, name_len=%d",
+		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		_LLU(le64_to_cpu(p->inode_no)),
+		rec_len, p->name_len);
+	goto fail;
+Eend:
+	p = (struct exofs_dir_entry *)(kaddr + offs);
+	EXOFS_ERR("ERROR [exofs_check_page]: "
+		"entry in directory #%lu spans the page boundary"
+		"offset=%lu, inode=%llu",
+		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		_LLU(le64_to_cpu(p->inode_no)));
+fail:
+	SetPageChecked(page);
+	SetPageError(page);
+}
+
+static struct page *exofs_get_page(struct inode *dir, unsigned long n)
+{
+	struct address_space *mapping = dir->i_mapping;
+	struct page *page = read_mapping_page(mapping, n, NULL);
+
+	if (!IS_ERR(page)) {
+		kmap(page);
+		if (!PageChecked(page))
+			exofs_check_page(page);
+		if (PageError(page))
+			goto fail;
+	}
+	return page;
+
+fail:
+	exofs_put_page(page);
+	return ERR_PTR(-EIO);
+}
+
+static inline int exofs_match(int len, const unsigned char *name,
+					struct exofs_dir_entry *de)
+{
+	if (len != de->name_len)
+		return 0;
+	if (!de->inode_no)
+		return 0;
+	return !memcmp(name, de->name, len);
+}
+
+static inline
+struct exofs_dir_entry *exofs_next_entry(struct exofs_dir_entry *p)
+{
+	return (struct exofs_dir_entry *)((char *)p + le16_to_cpu(p->rec_len));
+}
+
+static inline unsigned
+exofs_validate_entry(char *base, unsigned offset, unsigned mask)
+{
+	struct exofs_dir_entry *de = (struct exofs_dir_entry *)(base + offset);
+	struct exofs_dir_entry *p =
+			(struct exofs_dir_entry *)(base + (offset&mask));
+	while ((char *)p < (char *)de) {
+		if (p->rec_len == 0)
+			break;
+		p = exofs_next_entry(p);
+	}
+	return (char *)p - base;
+}
+
+static unsigned char exofs_filetype_table[EXOFS_FT_MAX] = {
+	[EXOFS_FT_UNKNOWN]	= DT_UNKNOWN,
+	[EXOFS_FT_REG_FILE]	= DT_REG,
+	[EXOFS_FT_DIR]		= DT_DIR,
+	[EXOFS_FT_CHRDEV]	= DT_CHR,
+	[EXOFS_FT_BLKDEV]	= DT_BLK,
+	[EXOFS_FT_FIFO]		= DT_FIFO,
+	[EXOFS_FT_SOCK]		= DT_SOCK,
+	[EXOFS_FT_SYMLINK]	= DT_LNK,
+};
+
+#define S_SHIFT 12
+static unsigned char exofs_type_by_mode[S_IFMT >> S_SHIFT] = {
+	[S_IFREG >> S_SHIFT]	= EXOFS_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]	= EXOFS_FT_DIR,
+	[S_IFCHR >> S_SHIFT]	= EXOFS_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]	= EXOFS_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]	= EXOFS_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]	= EXOFS_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]	= EXOFS_FT_SYMLINK,
+};
+
+static inline
+void exofs_set_de_type(struct exofs_dir_entry *de, struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+	de->file_type = exofs_type_by_mode[(mode & S_IFMT) >> S_SHIFT];
+}
+
+static int
+exofs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	loff_t pos = filp->f_pos;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	unsigned int offset = pos & ~PAGE_CACHE_MASK;
+	unsigned long n = pos >> PAGE_CACHE_SHIFT;
+	unsigned long npages = dir_pages(inode);
+	unsigned chunk_mask = ~(exofs_chunk_size(inode)-1);
+	unsigned char *types = NULL;
+	int need_revalidate = (filp->f_version != inode->i_version);
+
+	if (pos > inode->i_size - EXOFS_DIR_REC_LEN(1))
+		return 0;
+
+	types = exofs_filetype_table;
+
+	for ( ; n < npages; n++, offset = 0) {
+		char *kaddr, *limit;
+		struct exofs_dir_entry *de;
+		struct page *page = exofs_get_page(inode, n);
+
+		if (IS_ERR(page)) {
+			EXOFS_ERR("ERROR: "
+				   "bad page in #%lu",
+				   inode->i_ino);
+			filp->f_pos += PAGE_CACHE_SIZE - offset;
+			return PTR_ERR(page);
+		}
+		kaddr = page_address(page);
+		if (unlikely(need_revalidate)) {
+			if (offset) {
+				offset = exofs_validate_entry(kaddr, offset,
+								chunk_mask);
+				filp->f_pos = (n<<PAGE_CACHE_SHIFT) + offset;
+			}
+			filp->f_version = inode->i_version;
+			need_revalidate = 0;
+		}
+		de = (struct exofs_dir_entry *)(kaddr + offset);
+		limit = kaddr + exofs_last_byte(inode, n) -
+							EXOFS_DIR_REC_LEN(1);
+		for (; (char *)de <= limit; de = exofs_next_entry(de)) {
+			if (de->rec_len == 0) {
+				EXOFS_ERR("ERROR: "
+					"zero-length directory entry");
+				exofs_put_page(page);
+				return -EIO;
+			}
+			if (de->inode_no) {
+				int over;
+				unsigned char d_type = DT_UNKNOWN;
+
+				if (types && de->file_type < EXOFS_FT_MAX)
+					d_type = types[de->file_type];
+
+				offset = (char *)de - kaddr;
+				over = filldir(dirent, de->name, de->name_len,
+						(n<<PAGE_CACHE_SHIFT) | offset,
+						le64_to_cpu(de->inode_no),
+						d_type);
+				if (over) {
+					exofs_put_page(page);
+					return 0;
+				}
+			}
+			filp->f_pos += le16_to_cpu(de->rec_len);
+		}
+		exofs_put_page(page);
+	}
+
+	return 0;
+}
+
+struct exofs_dir_entry *exofs_find_entry(struct inode *dir,
+			struct dentry *dentry, struct page **res_page)
+{
+	const unsigned char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned reclen = EXOFS_DIR_REC_LEN(namelen);
+	unsigned long start, n;
+	unsigned long npages = dir_pages(dir);
+	struct page *page = NULL;
+	struct exofs_i_info *oi = exofs_i(dir);
+	struct exofs_dir_entry *de;
+
+	if (npages == 0)
+		goto out;
+
+	*res_page = NULL;
+
+	start = oi->i_dir_start_lookup;
+	if (start >= npages)
+		start = 0;
+	n = start;
+	do {
+		char *kaddr;
+		page = exofs_get_page(dir, n);
+		if (!IS_ERR(page)) {
+			kaddr = page_address(page);
+			de = (struct exofs_dir_entry *) kaddr;
+			kaddr += exofs_last_byte(dir, n) - reclen;
+			while ((char *) de <= kaddr) {
+				if (de->rec_len == 0) {
+					EXOFS_ERR(
+						"ERROR: exofs_find_entry: "
+						"zero-length directory entry");
+					exofs_put_page(page);
+					goto out;
+				}
+				if (exofs_match(namelen, name, de))
+					goto found;
+				de = exofs_next_entry(de);
+			}
+			exofs_put_page(page);
+		}
+		if (++n >= npages)
+			n = 0;
+	} while (n != start);
+out:
+	return NULL;
+
+found:
+	*res_page = page;
+	oi->i_dir_start_lookup = n;
+	return de;
+}
+
+struct exofs_dir_entry *exofs_dotdot(struct inode *dir, struct page **p)
+{
+	struct page *page = exofs_get_page(dir, 0);
+	struct exofs_dir_entry *de = NULL;
+
+	if (!IS_ERR(page)) {
+		de = exofs_next_entry(
+				(struct exofs_dir_entry *)page_address(page));
+		*p = page;
+	}
+	return de;
+}
+
+ino_t exofs_inode_by_name(struct inode *dir, struct dentry *dentry)
+{
+	ino_t res = 0;
+	struct exofs_dir_entry *de;
+	struct page *page;
+
+	de = exofs_find_entry(dir, dentry, &page);
+	if (de) {
+		res = le64_to_cpu(de->inode_no);
+		exofs_put_page(page);
+	}
+	return res;
+}
+
+int exofs_set_link(struct inode *dir, struct exofs_dir_entry *de,
+			struct page *page, struct inode *inode)
+{
+	loff_t pos = page_offset(page) +
+			(char *) de - (char *) page_address(page);
+	unsigned len = le16_to_cpu(de->rec_len);
+	int err;
+
+	lock_page(page);
+	err = exofs_write_begin(NULL, page->mapping, pos, len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+	if (err)
+		EXOFS_ERR("exofs_set_link: exofs_write_begin FAILD => %d\n",
+			  err);
+
+	de->inode_no = cpu_to_le64(inode->i_ino);
+	exofs_set_de_type(de, inode);
+	if (likely(!err))
+		err = exofs_commit_chunk(page, pos, len);
+	exofs_put_page(page);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+	return err;
+}
+
+int exofs_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	const unsigned char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned chunk_size = exofs_chunk_size(dir);
+	unsigned reclen = EXOFS_DIR_REC_LEN(namelen);
+	unsigned short rec_len, name_len;
+	struct page *page = NULL;
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	struct exofs_dir_entry *de;
+	unsigned long npages = dir_pages(dir);
+	unsigned long n;
+	char *kaddr;
+	loff_t pos;
+	int err;
+
+	for (n = 0; n <= npages; n++) {
+		char *dir_end;
+
+		page = exofs_get_page(dir, n);
+		err = PTR_ERR(page);
+		if (IS_ERR(page))
+			goto out;
+		lock_page(page);
+		kaddr = page_address(page);
+		dir_end = kaddr + exofs_last_byte(dir, n);
+		de = (struct exofs_dir_entry *)kaddr;
+		kaddr += PAGE_CACHE_SIZE - reclen;
+		while ((char *)de <= kaddr) {
+			if ((char *)de == dir_end) {
+				name_len = 0;
+				rec_len = chunk_size;
+				de->rec_len = cpu_to_le16(chunk_size);
+				de->inode_no = 0;
+				goto got_it;
+			}
+			if (de->rec_len == 0) {
+				EXOFS_ERR("ERROR: exofs_add_link: "
+					"zero-length directory entry");
+				err = -EIO;
+				goto out_unlock;
+			}
+			err = -EEXIST;
+			if (exofs_match(namelen, name, de))
+				goto out_unlock;
+			name_len = EXOFS_DIR_REC_LEN(de->name_len);
+			rec_len = le16_to_cpu(de->rec_len);
+			if (!de->inode_no && rec_len >= reclen)
+				goto got_it;
+			if (rec_len >= name_len + reclen)
+				goto got_it;
+			de = (struct exofs_dir_entry *) ((char *) de + rec_len);
+		}
+		unlock_page(page);
+		exofs_put_page(page);
+	}
+
+	EXOFS_ERR("exofs_add_link: BAD dentry=%p or inode=%p", dentry, inode);
+	return -EINVAL;
+
+got_it:
+	pos = page_offset(page) +
+		(char *)de - (char *)page_address(page);
+	err = exofs_write_begin(NULL, page->mapping, pos, rec_len, 0,
+							&page, NULL);
+	if (err)
+		goto out_unlock;
+	if (de->inode_no) {
+		struct exofs_dir_entry *de1 =
+			(struct exofs_dir_entry *)((char *)de + name_len);
+		de1->rec_len = cpu_to_le16(rec_len - name_len);
+		de->rec_len = cpu_to_le16(name_len);
+		de = de1;
+	}
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+	de->inode_no = cpu_to_le64(inode->i_ino);
+	exofs_set_de_type(de, inode);
+	err = exofs_commit_chunk(page, pos, rec_len);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+	sbi->s_numfiles++;
+
+out_put:
+	exofs_put_page(page);
+out:
+	return err;
+out_unlock:
+	unlock_page(page);
+	goto out_put;
+}
+
+int exofs_delete_entry(struct exofs_dir_entry *dir, struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	char *kaddr = page_address(page);
+	unsigned from = ((char *)dir - kaddr) & ~(exofs_chunk_size(inode)-1);
+	unsigned to = ((char *)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	loff_t pos;
+	struct exofs_dir_entry *pde = NULL;
+	struct exofs_dir_entry *de = (struct exofs_dir_entry *) (kaddr + from);
+	int err;
+
+	while (de < dir) {
+		if (de->rec_len == 0) {
+			EXOFS_ERR("ERROR: exofs_delete_entry:"
+				"zero-length directory entry");
+			err = -EIO;
+			goto out;
+		}
+		pde = de;
+		de = exofs_next_entry(de);
+	}
+	if (pde)
+		from = (char *)pde - (char *)page_address(page);
+	pos = page_offset(page) + from;
+	lock_page(page);
+	err = exofs_write_begin(NULL, page->mapping, pos, to - from, 0,
+							&page, NULL);
+	if (err)
+		EXOFS_ERR("exofs_delete_entry: exofs_write_begin FAILD => %d\n",
+			  err);
+	if (pde)
+		pde->rec_len = cpu_to_le16(to - from);
+	dir->inode_no = 0;
+	if (likely(!err))
+		err = exofs_commit_chunk(page, pos, to - from);
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+	mark_inode_dirty(inode);
+	sbi->s_numfiles--;
+out:
+	exofs_put_page(page);
+	return err;
+}
+
+/* kept aligned on 4 bytes */
+#define THIS_DIR ".\0\0"
+#define PARENT_DIR "..\0"
+
+int exofs_make_empty(struct inode *inode, struct inode *parent)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct page *page = grab_cache_page(mapping, 0);
+	unsigned chunk_size = exofs_chunk_size(inode);
+	struct exofs_dir_entry *de;
+	int err;
+	void *kaddr;
+
+	if (!page)
+		return -ENOMEM;
+
+	err = exofs_write_begin(NULL, page->mapping, 0, chunk_size, 0,
+							&page, NULL);
+	if (err) {
+		unlock_page(page);
+		goto fail;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	de = (struct exofs_dir_entry *)kaddr;
+	de->name_len = 1;
+	de->rec_len = cpu_to_le16(EXOFS_DIR_REC_LEN(1));
+	memcpy(de->name, THIS_DIR, sizeof(THIS_DIR));
+	de->inode_no = cpu_to_le64(inode->i_ino);
+	exofs_set_de_type(de, inode);
+
+	de = (struct exofs_dir_entry *)(kaddr + EXOFS_DIR_REC_LEN(1));
+	de->name_len = 2;
+	de->rec_len = cpu_to_le16(chunk_size - EXOFS_DIR_REC_LEN(1));
+	de->inode_no = cpu_to_le64(parent->i_ino);
+	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
+	exofs_set_de_type(de, inode);
+	kunmap_atomic(page, KM_USER0);
+	err = exofs_commit_chunk(page, 0, chunk_size);
+fail:
+	page_cache_release(page);
+	return err;
+}
+
+int exofs_empty_dir(struct inode *inode)
+{
+	struct page *page = NULL;
+	unsigned long i, npages = dir_pages(inode);
+
+	for (i = 0; i < npages; i++) {
+		char *kaddr;
+		struct exofs_dir_entry *de;
+		page = exofs_get_page(inode, i);
+
+		if (IS_ERR(page))
+			continue;
+
+		kaddr = page_address(page);
+		de = (struct exofs_dir_entry *)kaddr;
+		kaddr += exofs_last_byte(inode, i) - EXOFS_DIR_REC_LEN(1);
+
+		while ((char *)de <= kaddr) {
+			if (de->rec_len == 0) {
+				EXOFS_ERR("ERROR: exofs_empty_dir: "
+					  "zero-length directory entry"
+					  "kaddr=%p, de=%p\n", kaddr, de);
+				goto not_empty;
+			}
+			if (de->inode_no != 0) {
+				/* check for . and .. */
+				if (de->name[0] != '.')
+					goto not_empty;
+				if (de->name_len > 2)
+					goto not_empty;
+				if (de->name_len < 2) {
+					if (le64_to_cpu(de->inode_no) !=
+					    inode->i_ino)
+						goto not_empty;
+				} else if (de->name[1] != '.')
+					goto not_empty;
+			}
+			de = exofs_next_entry(de);
+		}
+		exofs_put_page(page);
+	}
+	return 1;
+
+not_empty:
+	exofs_put_page(page);
+	return 0;
+}
+
+const struct file_operations exofs_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.readdir	= exofs_readdir,
+};
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index f30de6e..abf66b2 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -124,6 +124,11 @@ static inline struct exofs_i_info *exofs_i(struct inode *inode)
 	return container_of(inode, struct exofs_i_info, vfs_inode);
 }
 
+/*
+ * Maximum count of links to a file
+ */
+#define EXOFS_LINK_MAX           32000
+
 /*************************
  * function declarations *
  *************************/
@@ -133,10 +138,27 @@ int exofs_setattr(struct dentry *, struct iattr *);
 int exofs_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata);
+extern struct inode *exofs_iget(struct super_block *, unsigned long);
+struct inode *exofs_new_inode(struct inode *, int);
+
+/* dir.c:                */
+int exofs_add_link(struct dentry *, struct inode *);
+ino_t exofs_inode_by_name(struct inode *, struct dentry *);
+int exofs_delete_entry(struct exofs_dir_entry *, struct page *);
+int exofs_make_empty(struct inode *, struct inode *);
+struct exofs_dir_entry *exofs_find_entry(struct inode *, struct dentry *,
+					 struct page **);
+int exofs_empty_dir(struct inode *);
+struct exofs_dir_entry *exofs_dotdot(struct inode *, struct page **);
+int exofs_set_link(struct inode *, struct exofs_dir_entry *, struct page *,
+		    struct inode *);
 
 /*********************
  * operation vectors *
  *********************/
+/* dir.c:            */
+extern const struct file_operations exofs_dir_operations;
+
 /* file.c            */
 extern const struct inode_operations exofs_file_inode_operations;
 extern const struct file_operations exofs_file_operations;
@@ -144,6 +166,10 @@ extern const struct file_operations exofs_file_operations;
 /* inode.c           */
 extern const struct address_space_operations exofs_aops;
 
+/* namei.c           */
+extern const struct inode_operations exofs_dir_inode_operations;
+extern const struct inode_operations exofs_special_inode_operations;
+
 /* symlink.c         */
 extern const struct inode_operations exofs_symlink_inode_operations;
 extern const struct inode_operations exofs_fast_symlink_inode_operations;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 175679a..7b0c696 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -836,3 +836,275 @@ int exofs_setattr(struct dentry *dentry, struct iattr *iattr)
 	error = inode_setattr(inode, iattr);
 	return error;
 }
+
+/*
+ * Read an inode from the OSD, and return it as is.  We also return the size
+ * attribute in the 'sanity' argument if we got compiled with debugging turned
+ * on.
+ */
+static int exofs_get_inode(struct super_block *sb, struct exofs_i_info *oi,
+		    struct exofs_fcb *inode, uint64_t *sanity)
+{
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	struct osd_request *or;
+	struct osd_attr attr;
+	struct osd_obj_id obj = {sbi->s_pid,
+				 oi->vfs_inode.i_ino + EXOFS_OBJ_OFF};
+	int ret;
+
+	exofs_make_credential(oi->i_cred, &obj);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("exofs_get_inode: osd_start_request failed.\n");
+		return -ENOMEM;
+	}
+	osd_req_get_attributes(or, &obj);
+
+	/* we need the inode attribute */
+	osd_req_add_get_attr_list(or, &g_attr_inode_data, 1);
+
+#ifdef EXOFS_DEBUG_OBJ_ISIZE
+	/* we get the size attributes to do a sanity check */
+	osd_req_add_get_attr_list(or, &g_attr_logical_length, 1);
+#endif
+
+	ret = exofs_sync_op(or, sbi->s_timeout, oi->i_cred);
+	if (ret)
+		goto out;
+
+	attr = g_attr_inode_data;
+	ret = extract_attr_from_req(or, &attr);
+	if (ret) {
+		EXOFS_ERR("exofs_get_inode: extract_attr_from_req failed\n");
+		goto out;
+	}
+
+	WARN_ON(attr.len != EXOFS_INO_ATTR_SIZE);
+	memcpy(inode, attr.val_ptr, EXOFS_INO_ATTR_SIZE);
+
+#ifdef EXOFS_DEBUG_OBJ_ISIZE
+	attr = g_attr_logical_length;
+	ret = extract_attr_from_req(or, &attr);
+	if (ret) {
+		EXOFS_ERR("ERROR: extract attr from or failed\n");
+		goto out;
+	}
+	*sanity = get_unaligned_be64(attr.val_ptr);
+#endif
+
+out:
+	osd_end_request(or);
+	return ret;
+}
+
+/*
+ * Fill in an inode read from the OSD and set it up for use
+ */
+struct inode *exofs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct exofs_i_info *oi;
+	struct exofs_fcb fcb;
+	struct inode *inode;
+	uint64_t uninitialized_var(sanity);
+	int ret;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	oi = exofs_i(inode);
+
+	/* read the inode from the osd */
+	ret = exofs_get_inode(sb, oi, &fcb, &sanity);
+	if (ret)
+		goto bad_inode;
+
+	init_waitqueue_head(&oi->i_wq);
+	set_obj_created(oi);
+
+	/* copy stuff from on-disk struct to in-memory struct */
+	inode->i_mode = le16_to_cpu(fcb.i_mode);
+	inode->i_uid = le32_to_cpu(fcb.i_uid);
+	inode->i_gid = le32_to_cpu(fcb.i_gid);
+	inode->i_nlink = le16_to_cpu(fcb.i_links_count);
+	inode->i_ctime.tv_sec = (signed)le32_to_cpu(fcb.i_ctime);
+	inode->i_atime.tv_sec = (signed)le32_to_cpu(fcb.i_atime);
+	inode->i_mtime.tv_sec = (signed)le32_to_cpu(fcb.i_mtime);
+	inode->i_ctime.tv_nsec =
+		inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec = 0;
+	oi->i_commit_size = le64_to_cpu(fcb.i_size);
+	i_size_write(inode, oi->i_commit_size);
+	inode->i_blkbits = EXOFS_BLKSHIFT;
+	inode->i_generation = le32_to_cpu(fcb.i_generation);
+
+#ifdef EXOFS_DEBUG_OBJ_ISIZE
+	if ((inode->i_size != sanity) &&
+		(!exofs_inode_is_fast_symlink(inode))) {
+		EXOFS_ERR("WARNING: Size of object from inode and "
+			  "attributes differ (%lld != %llu)\n",
+			  inode->i_size, _LLU(sanity));
+	}
+#endif
+
+	oi->i_dir_start_lookup = 0;
+
+	if ((inode->i_nlink == 0) && (inode->i_mode == 0)) {
+		ret = -ESTALE;
+		goto bad_inode;
+	}
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		if (fcb.i_data[0])
+			inode->i_rdev =
+				old_decode_dev(le32_to_cpu(fcb.i_data[0]));
+		else
+			inode->i_rdev =
+				new_decode_dev(le32_to_cpu(fcb.i_data[1]));
+	} else {
+		memcpy(oi->i_data, fcb.i_data, sizeof(fcb.i_data));
+	}
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_op = &exofs_file_inode_operations;
+		inode->i_fop = &exofs_file_operations;
+		inode->i_mapping->a_ops = &exofs_aops;
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_op = &exofs_dir_inode_operations;
+		inode->i_fop = &exofs_dir_operations;
+		inode->i_mapping->a_ops = &exofs_aops;
+	} else if (S_ISLNK(inode->i_mode)) {
+		if (exofs_inode_is_fast_symlink(inode))
+			inode->i_op = &exofs_fast_symlink_inode_operations;
+		else {
+			inode->i_op = &exofs_symlink_inode_operations;
+			inode->i_mapping->a_ops = &exofs_aops;
+		}
+	} else {
+		inode->i_op = &exofs_special_inode_operations;
+		if (fcb.i_data[0])
+			init_special_inode(inode, inode->i_mode,
+			   old_decode_dev(le32_to_cpu(fcb.i_data[0])));
+		else
+			init_special_inode(inode, inode->i_mode,
+			   new_decode_dev(le32_to_cpu(fcb.i_data[1])));
+	}
+
+	unlock_new_inode(inode);
+	return inode;
+
+bad_inode:
+	iget_failed(inode);
+	return ERR_PTR(ret);
+}
+
+int __exofs_wait_obj_created(struct exofs_i_info *oi)
+{
+	if (!obj_created(oi)) {
+		BUG_ON(!obj_2bcreated(oi));
+		wait_event(oi->i_wq, obj_created(oi));
+	}
+	return unlikely(is_bad_inode(&oi->vfs_inode)) ? -EIO : 0;
+}
+/*
+ * Callback function from exofs_new_inode().  The important thing is that we
+ * set the obj_created flag so that other methods know that the object exists on
+ * the OSD.
+ */
+static void create_done(struct osd_request *or, void *p)
+{
+	struct inode *inode = p;
+	struct exofs_i_info *oi = exofs_i(inode);
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	int ret;
+
+	ret = exofs_check_ok(or);
+	osd_end_request(or);
+	atomic_dec(&sbi->s_curr_pending);
+
+	if (unlikely(ret)) {
+		EXOFS_ERR("object=0x%llx creation faild in pid=0x%llx",
+			  _LLU(sbi->s_pid), _LLU(inode->i_ino + EXOFS_OBJ_OFF));
+		make_bad_inode(inode);
+	} else
+		set_obj_created(oi);
+
+	atomic_dec(&inode->i_count);
+	wake_up(&oi->i_wq);
+}
+
+/*
+ * Set up a new inode and create an object for it on the OSD
+ */
+struct inode *exofs_new_inode(struct inode *dir, int mode)
+{
+	struct super_block *sb;
+	struct inode *inode;
+	struct exofs_i_info *oi;
+	struct exofs_sb_info *sbi;
+	struct osd_request *or;
+	struct osd_obj_id obj;
+	int ret;
+
+	sb = dir->i_sb;
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	oi = exofs_i(inode);
+
+	init_waitqueue_head(&oi->i_wq);
+	set_obj_2bcreated(oi);
+
+	sbi = sb->s_fs_info;
+
+	sb->s_dirt = 1;
+	inode->i_uid = current->cred->fsuid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else {
+		inode->i_gid = current->cred->fsgid;
+	}
+	inode->i_mode = mode;
+
+	inode->i_ino = sbi->s_nextid++;
+	inode->i_blkbits = EXOFS_BLKSHIFT;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	oi->i_commit_size = inode->i_size = 0;
+	spin_lock(&sbi->s_next_gen_lock);
+	inode->i_generation = sbi->s_next_generation++;
+	spin_unlock(&sbi->s_next_gen_lock);
+	insert_inode_hash(inode);
+
+	mark_inode_dirty(inode);
+
+	obj.partition = sbi->s_pid;
+	obj.id = inode->i_ino + EXOFS_OBJ_OFF;
+	exofs_make_credential(oi->i_cred, &obj);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("exofs_new_inode: osd_start_request failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	osd_req_create_object(or, &obj);
+
+	/* increment the refcount so that the inode will still be around when we
+	 * reach the callback
+	 */
+	atomic_inc(&inode->i_count);
+
+	ret = exofs_async_op(or, create_done, inode, oi->i_cred);
+	if (ret) {
+		atomic_dec(&inode->i_count);
+		osd_end_request(or);
+		return ERR_PTR(-EIO);
+	}
+	atomic_inc(&sbi->s_curr_pending);
+
+	return inode;
+}
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
new file mode 100644
index 0000000..77fdd76
--- /dev/null
+++ b/fs/exofs/namei.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "exofs.h"
+
+static inline int exofs_add_nondir(struct dentry *dentry, struct inode *inode)
+{
+	int err = exofs_add_link(dentry, inode);
+	if (!err) {
+		d_instantiate(dentry, inode);
+		return 0;
+	}
+	inode_dec_link_count(inode);
+	iput(inode);
+	return err;
+}
+
+static struct dentry *exofs_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	struct inode *inode;
+	ino_t ino;
+
+	if (dentry->d_name.len > EXOFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	ino = exofs_inode_by_name(dir, dentry);
+	inode = NULL;
+	if (ino) {
+		inode = exofs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+	return d_splice_alias(inode, dentry);
+}
+
+static int exofs_create(struct inode *dir, struct dentry *dentry, int mode,
+			 struct nameidata *nd)
+{
+	struct inode *inode = exofs_new_inode(dir, mode);
+	int err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		inode->i_op = &exofs_file_inode_operations;
+		inode->i_fop = &exofs_file_operations;
+		inode->i_mapping->a_ops = &exofs_aops;
+		mark_inode_dirty(inode);
+		err = exofs_add_nondir(dentry, inode);
+	}
+	return err;
+}
+
+static int exofs_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		       dev_t rdev)
+{
+	struct inode *inode;
+	int err;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	inode = exofs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		init_special_inode(inode, inode->i_mode, rdev);
+		mark_inode_dirty(inode);
+		err = exofs_add_nondir(dentry, inode);
+	}
+	return err;
+}
+
+static int exofs_symlink(struct inode *dir, struct dentry *dentry,
+			  const char *symname)
+{
+	struct super_block *sb = dir->i_sb;
+	int err = -ENAMETOOLONG;
+	unsigned l = strlen(symname)+1;
+	struct inode *inode;
+	struct exofs_i_info *oi;
+
+	if (l > sb->s_blocksize)
+		goto out;
+
+	inode = exofs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	oi = exofs_i(inode);
+	if (l > sizeof(oi->i_data)) {
+		/* slow symlink */
+		inode->i_op = &exofs_symlink_inode_operations;
+		inode->i_mapping->a_ops = &exofs_aops;
+		memset(oi->i_data, 0, sizeof(oi->i_data));
+
+		err = page_symlink(inode, symname, l);
+		if (err)
+			goto out_fail;
+	} else {
+		/* fast symlink */
+		inode->i_op = &exofs_fast_symlink_inode_operations;
+		memcpy(oi->i_data, symname, l);
+		inode->i_size = l-1;
+	}
+	mark_inode_dirty(inode);
+
+	err = exofs_add_nondir(dentry, inode);
+out:
+	return err;
+
+out_fail:
+	inode_dec_link_count(inode);
+	iput(inode);
+	goto out;
+}
+
+static int exofs_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+
+	if (inode->i_nlink >= EXOFS_LINK_MAX)
+		return -EMLINK;
+
+	inode->i_ctime = CURRENT_TIME;
+	inode_inc_link_count(inode);
+	atomic_inc(&inode->i_count);
+
+	return exofs_add_nondir(dentry, inode);
+}
+
+static int exofs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+	int err = -EMLINK;
+
+	if (dir->i_nlink >= EXOFS_LINK_MAX)
+		goto out;
+
+	inode_inc_link_count(dir);
+
+	inode = exofs_new_inode(dir, S_IFDIR | mode);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out_dir;
+
+	inode->i_op = &exofs_dir_inode_operations;
+	inode->i_fop = &exofs_dir_operations;
+	inode->i_mapping->a_ops = &exofs_aops;
+
+	inode_inc_link_count(inode);
+
+	err = exofs_make_empty(inode, dir);
+	if (err)
+		goto out_fail;
+
+	err = exofs_add_link(dentry, inode);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+out:
+	return err;
+
+out_fail:
+	inode_dec_link_count(inode);
+	inode_dec_link_count(inode);
+	iput(inode);
+out_dir:
+	inode_dec_link_count(dir);
+	goto out;
+}
+
+static int exofs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct exofs_dir_entry *de;
+	struct page *page;
+	int err = -ENOENT;
+
+	de = exofs_find_entry(dir, dentry, &page);
+	if (!de)
+		goto out;
+
+	err = exofs_delete_entry(de, page);
+	if (err)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+	inode_dec_link_count(inode);
+	err = 0;
+out:
+	return err;
+}
+
+static int exofs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	int err = -ENOTEMPTY;
+
+	if (exofs_empty_dir(inode)) {
+		err = exofs_unlink(dir, dentry);
+		if (!err) {
+			inode->i_size = 0;
+			inode_dec_link_count(inode);
+			inode_dec_link_count(dir);
+		}
+	}
+	return err;
+}
+
+static int exofs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *dir_page = NULL;
+	struct exofs_dir_entry *dir_de = NULL;
+	struct page *old_page;
+	struct exofs_dir_entry *old_de;
+	int err = -ENOENT;
+
+	old_de = exofs_find_entry(old_dir, old_dentry, &old_page);
+	if (!old_de)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		err = -EIO;
+		dir_de = exofs_dotdot(old_inode, &dir_page);
+		if (!dir_de)
+			goto out_old;
+	}
+
+	if (new_inode) {
+		struct page *new_page;
+		struct exofs_dir_entry *new_de;
+
+		err = -ENOTEMPTY;
+		if (dir_de && !exofs_empty_dir(new_inode))
+			goto out_dir;
+
+		err = -ENOENT;
+		new_de = exofs_find_entry(new_dir, new_dentry, &new_page);
+		if (!new_de)
+			goto out_dir;
+		inode_inc_link_count(old_inode);
+		err = exofs_set_link(new_dir, new_de, new_page, old_inode);
+		new_inode->i_ctime = CURRENT_TIME;
+		if (dir_de)
+			drop_nlink(new_inode);
+		inode_dec_link_count(new_inode);
+		if (err)
+			goto out_dir;
+	} else {
+		if (dir_de) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= EXOFS_LINK_MAX)
+				goto out_dir;
+		}
+		inode_inc_link_count(old_inode);
+		err = exofs_add_link(new_dentry, old_inode);
+		if (err) {
+			inode_dec_link_count(old_inode);
+			goto out_dir;
+		}
+		if (dir_de)
+			inode_inc_link_count(new_dir);
+	}
+
+	old_inode->i_ctime = CURRENT_TIME;
+
+	exofs_delete_entry(old_de, old_page);
+	inode_dec_link_count(old_inode);
+
+	if (dir_de) {
+		err = exofs_set_link(old_inode, dir_de, dir_page, new_dir);
+		inode_dec_link_count(old_dir);
+		if (err)
+			goto out_dir;
+	}
+	return 0;
+
+
+out_dir:
+	if (dir_de) {
+		kunmap(dir_page);
+		page_cache_release(dir_page);
+	}
+out_old:
+	kunmap(old_page);
+	page_cache_release(old_page);
+out:
+	return err;
+}
+
+const struct inode_operations exofs_dir_inode_operations = {
+	.create 	= exofs_create,
+	.lookup 	= exofs_lookup,
+	.link   	= exofs_link,
+	.unlink 	= exofs_unlink,
+	.symlink	= exofs_symlink,
+	.mkdir  	= exofs_mkdir,
+	.rmdir  	= exofs_rmdir,
+	.mknod  	= exofs_mknod,
+	.rename 	= exofs_rename,
+	.setattr	= exofs_setattr,
+};
+
+const struct inode_operations exofs_special_inode_operations = {
+	.setattr	= exofs_setattr,
+};
-- 
1.6.2.1

