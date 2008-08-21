Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYHUFqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYHUFqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYHUFpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:45:14 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:6219 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbYHUFpJ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=v+iIAkdutuFG0LNJDVnC2aGDiSGYc1mCtT6I0+erNiguwQF9ZNpy7NGxPEp/IKz3AQ
         TGZ5rgVKdrfkxL+id266378+94zlkOiSnVx5Cm2wPqTT4fUkoEkdPepbGiBD+z0qF7l9
         LwQdIWXBR4yNuj74Ng62ktSpjLbD4W0FuUA3c=
Message-ID: <48AD00F0.5030403@gmail.com>
Date: Wed, 20 Aug 2008 22:45:20 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 04/10] AXFS: axfs_inode.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the main filesystem logic.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
diff --git a/fs/axfs/axfs_inode.c b/fs/axfs/axfs_inode.c
new file mode 100644
index 0000000..cbf3dd1
--- /dev/null
+++ b/fs/axfs/axfs_inode.c
@@ -0,0 +1,488 @@
+/*
+ * Advanced XIP File System for Linux - AXFS
+ *   Readonly, compressed, and XIP filesystem for Linux systems big and small
+ *
+ * Copyright(c) 2008 Numonyx
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * Authors:
+ *  Eric Anderson
+ *  Jared Hulbert <jaredeh@gmail.com>
+ *  Sujaya Srinivasan
+ *  Justin Treon
+ *
+ * Project url: http://axfs.sourceforge.net
+ *
+ * Borrowed heavily from fs/cramfs/inode.c by Linus Torvalds
+ *
+ * axfs_inode.c -
+ *   Contains the most of the filesystem logic with the major exception of the
+ *   mounting infrastructure.
+ *
+ */
+
+#include <linux/axfs.h>
+#include <linux/pagemap.h>
+
+/***************** functions in other axfs files ******************************/
+int axfs_get_sb(struct file_system_type *, int, const char *, void *,
+		struct vfsmount *);
+void axfs_kill_super(struct super_block *);
+void axfs_profiling_add(struct axfs_super *, unsigned long, unsigned int);
+int axfs_copy_mtd(struct super_block *, void *, u64, u64);
+int axfs_copy_block(struct super_block *, void *, u64, u64);
+/******************************************************************************/
+static int axfs_readdir(struct file *, void *, filldir_t);
+static int axfs_mmap(struct file *, struct vm_area_struct *);
+static ssize_t axfs_file_read(struct file *, char __user *, size_t, loff_t *);
+static int axfs_readpage(struct file *, struct page *);
+static int axfs_fault(struct vm_area_struct *, struct vm_fault *);
+static struct dentry *axfs_lookup(struct inode *, struct dentry *,
+				  struct nameidata *);
+static int axfs_get_xip_mem(struct address_space *, pgoff_t, int, void **,
+			    unsigned long *);
+
+/******************************************************************************/
+
+static struct file_operations axfs_directory_operations = {
+	.llseek = generic_file_llseek,
+	.read = generic_read_dir,
+	.readdir = axfs_readdir,
+};
+
+static struct file_operations axfs_fops = {
+	.read = axfs_file_read,
+	.aio_read = generic_file_aio_read,
+	.mmap = axfs_mmap,
+};
+
+static struct address_space_operations axfs_aops = {
+	.readpage = axfs_readpage,
+	.get_xip_mem = axfs_get_xip_mem,
+};
+
+static struct inode_operations axfs_dir_inode_operations = {
+	.lookup = axfs_lookup,
+};
+
+static struct vm_operations_struct axfs_vm_ops = {
+	.fault = axfs_fault,
+};
+
+static int axfs_copy_data(struct super_block *sb, void *dst,
+			  struct axfs_region_desc *region, u64 offset, u64 len)
+{
+	u64 mmapped = 0;
+	u64 end = region->fsoffset + offset + len;
+	u64 begin = region->fsoffset + offset;
+	u64 left;
+	void *addr;
+	void *newdst;
+	struct axfs_super *sbi = AXFS_SB(sb);
+
+	if (len == 0)
+		return 0;
+
+	if (region->virt_addr) {
+		if (sbi->mmap_size >= end) {
+			mmapped = len;
+		} else if (sbi->mmap_size > begin) {
+			mmapped = sbi->mmap_size - begin;
+		}
+	}
+
+	if (mmapped) {
+		addr = (void *)(region->virt_addr + offset);
+		memcpy(dst, addr, mmapped);
+	}
+
+	newdst = (void *)(dst + mmapped);
+	left = len - mmapped;
+
+	if (left == 0)
+		return len;
+
+	if (AXFS_HAS_BDEV(sb)) {
+		return axfs_copy_block(sb, newdst, begin + mmapped, left);
+	} else if (AXFS_HAS_MTD(sb)) {
+		return axfs_copy_mtd(sb, newdst, begin + mmapped, left);
+	} else {
+		return 0;
+	}
+}
+
+static int axfs_iget5_test(struct inode *inode, void *opaque)
+{
+	u64 *inode_number = (u64 *) opaque;
+
+	if (inode->i_sb == NULL) {
+		printk(KERN_ERR "axfs_iget5_test:"
+		       " the super block is set to null\n");
+	}
+	if (inode->i_ino == *inode_number)
+		return 1;	/* matches */
+	else
+		return 0;	/* does not match */
+}
+
+static int axfs_iget5_set(struct inode *inode, void *opaque)
+{
+	u64 *inode_number = (u64 *) opaque;
+
+	if (inode->i_sb == NULL) {
+		printk(KERN_ERR "axfs_iget5_set:"
+		       " the super block is set to null \n");
+	}
+	inode->i_ino = *inode_number;
+	return 0;
+}
+
+struct inode *axfs_create_vfs_inode(struct super_block *sb, int ino)
+{
+	struct axfs_super *sbi = AXFS_SB(sb);
+	struct inode *inode;
+	u64 size;
+
+	inode = iget5_locked(sb, ino, axfs_iget5_test, axfs_iget5_set, &ino);
+
+	if (!(inode && (inode->i_state & I_NEW)))
+		return inode;
+
+	inode->i_mode = AXFS_GET_MODE(sbi, ino);
+	inode->i_uid = AXFS_GET_UID(sbi, ino);
+	size = AXFS_GET_INODE_FILE_SIZE(sbi, ino);
+	inode->i_size = size;
+	inode->i_blocks = AXFS_GET_INODE_NUM_ENTRIES(sbi, ino);
+	inode->i_blkbits = PAGE_CACHE_SIZE * 8;
+	inode->i_gid = AXFS_GET_GID(sbi, ino);
+
+	inode->i_mtime = inode->i_atime = inode->i_ctime = sbi->timestamp;
+	inode->i_ino = ino;
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_fop = &axfs_fops;
+		inode->i_data.a_ops = &axfs_aops;
+		inode->i_mapping->a_ops = &axfs_aops;
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_op = &axfs_dir_inode_operations;
+		inode->i_fop = &axfs_directory_operations;
+	} else if (S_ISLNK(inode->i_mode)) {
+		inode->i_op = &page_symlink_inode_operations;
+		inode->i_data.a_ops = &axfs_aops;
+	} else {
+		inode->i_size = 0;
+		inode->i_blocks = 0;
+		init_special_inode(inode, inode->i_mode, old_decode_dev(size));
+	}
+	unlock_new_inode(inode);
+
+	return inode;
+}
+
+
+static int axfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+
+	file_accessed(file);
+
+	vma->vm_ops = &axfs_vm_ops;
+
+	vma->vm_flags |= VM_CAN_NONLINEAR | VM_MIXEDMAP;
+
+	return 0;
+}
+
+static struct dentry *axfs_lookup(struct inode *dir, struct dentry *dentry,
+				  struct nameidata *nd)
+{
+	struct super_block *sb = dir->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 ino_number = dir->i_ino;
+	u64 dir_index = 0;
+	u64 entry;
+	char *name;
+	int namelen, err;
+
+	while (dir_index < AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number)) {
+		entry = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
+		entry += dir_index;
+
+		name = AXFS_GET_INODE_NAME(sbi, entry);
+		namelen = strlen(name);
+
+		/* fast test, the entries are sorted alphabetically and the
+		 * first letter is smaller than the first letter in the search
+		 * name then it isn't in this directory.  Keeps this loop from
+		 * needing to scan through always.
+		 */
+		if (dentry->d_name.name[0] < name[0])
+			break;
+
+		dir_index++;
+
+		/* Quick check that the name is roughly the right length */
+		if (dentry->d_name.len != namelen)
+			continue;
+
+		err = memcmp(dentry->d_name.name, name, namelen);
+		if (err > 0)
+			continue;
+
+		/* The file name isn't present in the directory. */
+		if (err < 0)
+			break;
+
+		d_add(dentry, axfs_create_vfs_inode(dir->i_sb, entry));
+		goto out;
+
+	}
+	d_add(dentry, NULL);
+
+out:
+	return NULL;
+}
+
+static int axfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 ino_number = inode->i_ino;
+	u64 entry;
+	loff_t dir_index;
+	char *name;
+	int namelen, mode;
+	int err = 0;
+
+	/* Get the current index into the directory and verify it is not beyond
+	   the end of the list */
+	dir_index = filp->f_pos;
+	if (dir_index >= AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number))
+		goto out;
+
+	/* Verify the inode is for a directory */
+	if (!(S_ISDIR(inode->i_mode))) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	while (dir_index < AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number)) {
+		entry = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number) + dir_index;
+
+		name = (char *)AXFS_GET_INODE_NAME(sbi, entry);
+		namelen = strlen(name);
+
+		mode = (int)AXFS_GET_MODE(sbi, entry);
+		err = filldir(dirent, name, namelen, dir_index, entry, mode);
+
+		if (err)
+			break;
+
+		dir_index++;
+		filp->f_pos = dir_index;
+	}
+
+out:
+	return 0;
+}
+
+/******************************************************************************
+ *
+ * axfs_fault
+ *
+ * Description: This function is mapped into the VMA operations vector, and
+ *              gets called on a page fault. Depending on whether the page
+ *              is XIP or compressed, xip_file_fault or filemap_fault is
+ *              called.  This function also logs when a fault occurs when
+ *              profiling is on.
+ *
+ * Parameters:
+ *    (IN) vma  - The virtual memory area corresponding to a file
+ *
+ *    (IN) vmf  - The fault info pass in by the fault handler
+ *
+ * Returns:
+ *    0 or error number
+ *
+ *****************************************************************************/
+static int axfs_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 ino_number = inode->i_ino;
+	u64 array_index;
+
+	array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number) + vmf->pgoff;
+
+	/* if that pages are marked for write they will probably end up in RAM
+	   therefore we don't want their counts for being XIP'd */
+	if (!(vma->vm_flags & VM_WRITE))
+		axfs_profiling_add(sbi, array_index, ino_number);
+
+	/* figure out if the node is XIP or compressed and call the
+	   appropriate function
+	 */
+	if (AXFS_IS_NODE_XIP(sbi, array_index))
+		return xip_file_fault(vma, vmf);
+	return filemap_fault(vma, vmf);
+
+}
+
+
+/******************************************************************************
+ *
+ * axfs_file_read
+ *
+ * Description: axfs_file_read is mapped into the file_operations vector for
+ *              all axfs files. It loops through the pages to be read and calls
+ *              either do_sync_read (if the page is a compressed one) or
+ *              xip_file_read (if the page is XIP).
+ *
+ * Parameters:
+ *    (IN) filp -  file to be read
+ *
+ *    (OUT) buf - user buffer that is filled with the data that we read.
+ *
+ *    (IN) len - length of file to be read
+ *
+ *    (IN) ppos - offset within the file to read from
+ *
+ * Returns:
+ *    actual size of data read.
+ *
+ *****************************************************************************/
+static ssize_t axfs_file_read(struct file *filp, char __user *buf, size_t len,
+			      loff_t *ppos)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	size_t read = 0, total_read = 0;
+	size_t readlength, actual_size, file_size, remaining;
+	u64 ino_number = inode->i_ino;
+	u64 size, array_index;
+
+	file_size = AXFS_GET_INODE_FILE_SIZE(sbi, ino_number);
+	remaining = file_size - *ppos;
+	actual_size = len > remaining ? remaining : len;
+	readlength = actual_size < PAGE_SIZE ? actual_size : PAGE_SIZE;
+
+	for (size = actual_size; size > 0; size -= read) {
+		array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
+		array_index += *ppos >> PAGE_SHIFT;
+
+		if (AXFS_IS_NODE_XIP(sbi, array_index)) {
+			read = xip_file_read(filp, buf, readlength, ppos);
+		} else {
+			read = do_sync_read(filp, buf, readlength, ppos);
+		}
+		buf += read;
+		total_read += read;
+
+		if ((len - total_read < PAGE_SIZE) && (total_read != len))
+			readlength = len - total_read;
+	}
+
+	return total_read;
+}
+
+static int axfs_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 array_index, node_index, cnode_index, maxblock, ofs;
+	u64 ino_number = inode->i_ino;
+	u32 max_len, cnode_offset;
+	u32 cblk_size = sbi->cblock_size;
+	u32 len = 0;
+	u8 node_type;
+	void *pgdata;
+	void *src;
+	void *cblk0 = sbi->cblock_buffer[0];
+	void *cblk1 = sbi->cblock_buffer[1];
+
+	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	pgdata = kmap(page);
+
+	if (page->index >= maxblock)
+		goto out;
+
+	array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
+	array_index += page->index;
+
+	node_index = AXFS_GET_NODE_INDEX(sbi, array_index);
+	node_type = AXFS_GET_NODE_TYPE(sbi, array_index);
+
+	if (node_type == Compressed) {
+		/* node is in compessed region */
+		cnode_offset = AXFS_GET_CNODE_OFFSET(sbi, node_index);
+		cnode_index = AXFS_GET_CNODE_INDEX(sbi, node_index);
+		down_write(&sbi->lock);
+		if (cnode_index != sbi->current_cnode_index) {
+			/* uncompress only necessary if different cblock */
+			ofs = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index);
+			len = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index + 1);
+			len -= ofs;
+			axfs_copy_data(sb, cblk1, &(sbi->compressed), ofs, len);
+			axfs_uncompress_block(cblk0, cblk_size, cblk1, len);
+			sbi->current_cnode_index = cnode_index;
+		}
+		downgrade_write(&sbi->lock);
+		max_len = cblk_size - cnode_offset;
+		len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : max_len;
+		src = (void *)((unsigned long)cblk0 + cnode_offset);
+		memcpy(pgdata, src, len);
+		up_read(&sbi->lock);
+	} else if (node_type == Byte_Aligned) {
+		/* node is in BA region */
+		ofs = AXFS_GET_BANODE_OFFSET(sbi, node_index);
+		max_len = sbi->byte_aligned.size - ofs;
+		len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : max_len;
+		axfs_copy_data(sb, pgdata, &(sbi->byte_aligned), ofs, len);
+	} else {
+		/* node is XIP */
+		ofs = node_index << PAGE_SHIFT;
+		len = PAGE_CACHE_SIZE;
+		axfs_copy_data(sb, pgdata, &(sbi->xip), ofs, len);
+	}
+
+out:
+	memset(pgdata + len, 0, PAGE_CACHE_SIZE - len);
+	kunmap(page);
+	flush_dcache_page(page);
+	SetPageUptodate(page);
+	unlock_page(page);
+	return 0;
+}
+
+static int axfs_get_xip_mem(struct address_space *mapping, pgoff_t offset,
+			    int create, void **kaddr, unsigned long *pfn)
+{
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 ino_number = inode->i_ino;
+	u64 ino_index, node_index;
+
+	ino_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
+	ino_index += offset;
+
+	node_index = AXFS_GET_NODE_INDEX(sbi, ino_index);
+
+	*kaddr = (void *)(sbi->xip.virt_addr + (node_index << PAGE_SHIFT));
+	if (AXFS_PHYSADDR_IS_VALID(sbi)) {
+		*pfn = (AXFS_GET_XIP_REGION_PHYSADDR(sbi) >> PAGE_SHIFT);
+		*pfn += node_index;
+	} else {
+		*pfn = page_to_pfn(virt_to_page((unsigned long)*kaddr));
+	}
+
+	return 0;
+}
+


