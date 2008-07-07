Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYGGPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYGGPmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYGGPmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:42:25 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:48158 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYGGPmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:42:22 -0400
Date: Mon, 7 Jul 2008 17:42:30 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: azfs: initial submit of azfs, a non-buffered filesystem
Message-ID: <20080707174230.63bc68cf@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <200807011659.33413.arnd@arndb.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	<200807011659.33413.arnd@arndb.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AZFS is a file system which keeps all files on memory mapped random
access storage. It was designed to work on the axonram device driver
for IBM QS2x blade servers, but can operate on any block device
that exports a direct_access method.

Signed-off-by: Maxim Shchetynin <maxim@de.ibm.com>
---

diff -Nuar linux-2.6.26-rc9/Documentation/filesystems/azfs.txt linux-2.6.26-rc9-azfs/Documentation/filesystems/azfs.txt
--- linux-2.6.26-rc9/Documentation/filesystems/azfs.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.26-rc9-azfs/Documentation/filesystems/azfs.txt	2008-07-07 13:43:45.235739896 +0200
@@ -0,0 +1,22 @@
+AZFS is a file system which keeps all files on memory mapped random
+access storage. It was designed to work on the axonram device driver
+for IBM QS2x blade servers, but can operate on any block device
+that exports a direct_access method.
+
+Everything in AZFS is temporary in the sense that all the data stored
+therein is lost when you switch off or reboot a system. If you unmount
+an AZFS instance, all the data will be kept on device as long your system
+is not shut down or rebooted. You can later mount AZFS on from device again
+to get access to your files.
+
+AZFS uses a block device only for data but not for file information.
+All inodes (file and directory information) is kept in RAM.
+
+When you mount AZFS you are able to specify a file system block size with
+'-o bs=<size in bytes>' option. There are no software limitations for
+a block size but you would not be able to mmap files on AZFS if block size
+is less than a system page size. If no '-o bs' option is specified on mount
+a block size of the used block device is used as a default block size for AZFS.
+
+Other available mount options for AZFS are '-o uid=<id>' and '-o gid=<id>',
+which allow you to set the owner and group of the root of the file system.
diff -Nuar linux-2.6.26-rc9/arch/powerpc/configs/cell_defconfig linux-2.6.26-rc9-azfs/arch/powerpc/configs/cell_defconfig
--- linux-2.6.26-rc9/arch/powerpc/configs/cell_defconfig	2008-07-06 00:53:22.000000000 +0200
+++ linux-2.6.26-rc9-azfs/arch/powerpc/configs/cell_defconfig	2008-07-07 13:43:45.244738607 +0200
@@ -240,6 +240,7 @@
 # CPU Frequency drivers
 #
 CONFIG_AXON_RAM=m
+CONFIG_AZ_FS=m
 # CONFIG_FSL_ULI1575 is not set
 
 #
diff -Nuar linux-2.6.26-rc9/fs/Kconfig linux-2.6.26-rc9-azfs/fs/Kconfig
--- linux-2.6.26-rc9/fs/Kconfig	2008-07-06 00:53:22.000000000 +0200
+++ linux-2.6.26-rc9-azfs/fs/Kconfig	2008-07-07 13:45:29.397644341 +0200
@@ -1017,6 +1017,22 @@
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+config AZ_FS
+	tristate "AZFS filesystem support"
+	depends on PPC
+	help
+	  azfs is a file system for I/O attached memory backing. It requires
+	  a block device with direct_access capability, e.g. axonram.
+	  Mounting such device with azfs gives memory mapped access to the
+	  underlying memory to user space.
+
+	  Read <file:Documentation/filesystems/azfs.txt> for details.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called azfs.
+
+	  If unsure, say N.
+
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem"
 	depends on SYSFS
diff -Nuar linux-2.6.26-rc9/fs/Makefile linux-2.6.26-rc9-azfs/fs/Makefile
--- linux-2.6.26-rc9/fs/Makefile	2008-07-06 00:53:22.000000000 +0200
+++ linux-2.6.26-rc9-azfs/fs/Makefile	2008-07-07 13:45:49.436832234 +0200
@@ -119,3 +119,4 @@
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_AZ_FS)		+= azfs/
diff -Nuar linux-2.6.26-rc9/fs/azfs/Makefile linux-2.6.26-rc9-azfs/fs/azfs/Makefile
--- linux-2.6.26-rc9/fs/azfs/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.26-rc9-azfs/fs/azfs/Makefile	2008-07-07 13:46:38.413264402 +0200
@@ -0,0 +1,7 @@
+#
+# Makefile for azfs routines
+#
+
+obj-$(CONFIG_AZ_FS) += azfs.o
+
+azfs-y := inode.o
diff -Nuar linux-2.6.26-rc9/fs/azfs/inode.c linux-2.6.26-rc9-azfs/fs/azfs/inode.c
--- linux-2.6.26-rc9/fs/azfs/inode.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.26-rc9-azfs/fs/azfs/inode.c	2008-07-07 17:31:06.183098986 +0200
@@ -0,0 +1,1176 @@
+/*
+ * (C) Copyright IBM Deutschland Entwicklung GmbH 2007
+ *
+ * Author: Maxim Shchetynin <maxim@de.ibm.com>
+ *
+ * Non-buffered filesystem driver.
+ * It registers a filesystem which may be used for all kind of block devices
+ * which have a direct_access() method in block_device_operations.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/backing-dev.h>
+#include <linux/blkdev.h>
+#include <linux/cache.h>
+#include <linux/dcache.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/pagemap.h>
+#include <linux/parser.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/stat.h>
+#include <linux/statfs.h>
+#include <linux/string.h>
+#include <linux/time.h>
+#include <linux/types.h>
+#include <linux/aio.h>
+#include <linux/uio.h>
+#include <asm/bug.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/string.h>
+
+#define AZFS_FILESYSTEM_NAME		"azfs"
+#define AZFS_FILESYSTEM_FLAGS		FS_REQUIRES_DEV
+
+#define AZFS_SUPERBLOCK_MAGIC		0xABBA1972
+#define AZFS_SUPERBLOCK_FLAGS		MS_SYNCHRONOUS | \
+					MS_DIRSYNC | \
+					MS_ACTIVE
+
+#define AZFS_BDI_CAPABILITIES		BDI_CAP_NO_ACCT_DIRTY | \
+					BDI_CAP_NO_WRITEBACK | \
+					BDI_CAP_MAP_COPY | \
+					BDI_CAP_MAP_DIRECT | \
+					BDI_CAP_VMFLAGS
+
+#define AZFS_CACHE_FLAGS		SLAB_HWCACHE_ALIGN | \
+					SLAB_RECLAIM_ACCOUNT | \
+					SLAB_MEM_SPREAD
+
+struct azfs_super {
+	struct list_head		list;
+	unsigned long			media_size;
+	unsigned long			block_size;
+	unsigned short			block_shift;
+	unsigned long			sector_size;
+	unsigned short			sector_shift;
+	uid_t				uid;
+	gid_t				gid;
+	unsigned long			ph_addr;
+	unsigned long			io_addr;
+	struct block_device		*blkdev;
+	struct dentry			*root;
+	struct list_head		block_list;
+	rwlock_t			lock;
+};
+
+struct azfs_super_list {
+	struct list_head		head;
+	spinlock_t			lock;
+};
+
+struct azfs_block {
+	struct list_head		list;
+	unsigned long			id;
+	unsigned long			count;
+};
+
+struct azfs_znode {
+	struct list_head		block_list;
+	rwlock_t			lock;
+	loff_t				size;
+	struct inode			vfs_inode;
+};
+
+static struct azfs_super_list		super_list;
+static struct kmem_cache		*azfs_znode_cache __read_mostly = NULL;
+static struct kmem_cache		*azfs_block_cache __read_mostly = NULL;
+
+#define I2S(inode) \
+	inode->i_sb->s_fs_info
+#define I2Z(inode) \
+	container_of(inode, struct azfs_znode, vfs_inode)
+
+#define for_each_block(block, block_list) \
+	list_for_each_entry(block, block_list, list)
+#define for_each_block_reverse(block, block_list) \
+	list_for_each_entry_reverse(block, block_list, list)
+#define for_each_block_safe(block, temp, block_list) \
+	list_for_each_entry_safe(block, temp, block_list, list)
+#define for_each_block_safe_reverse(block, temp, block_list) \
+	list_for_each_entry_safe_reverse(block, temp, block_list, list)
+
+/**
+ * azfs_block_init - create and initialise a new block in a list
+ * @block_list: destination list
+ * @id: block id
+ * @count: size of a block
+ */
+static inline struct azfs_block*
+azfs_block_init(struct list_head *block_list,
+		unsigned long id, unsigned long count)
+{
+	struct azfs_block *block;
+
+	block = kmem_cache_alloc(azfs_block_cache, GFP_KERNEL);
+	if (!block)
+		return NULL;
+
+	block->id = id;
+	block->count = count;
+
+	INIT_LIST_HEAD(&block->list);
+	list_add_tail(&block->list, block_list);
+
+	return block;
+}
+
+/**
+ * azfs_block_free - remove block from a list and free it back in cache
+ * @block: block to be removed
+ */
+static inline void
+azfs_block_free(struct azfs_block *block)
+{
+	list_del(&block->list);
+	kmem_cache_free(azfs_block_cache, block);
+}
+
+/**
+ * azfs_block_move - move block to another list
+ * @block: block to be moved
+ * @block_list: destination list
+ */
+static inline void
+azfs_block_move(struct azfs_block *block, struct list_head *block_list)
+{
+	list_move_tail(&block->list, block_list);
+}
+
+/**
+ * azfs_block_find - get a block id of a part of a file
+ * @inode: inode
+ * @from: offset for read/write operation
+ * @size: pointer to a value of the amount of data to be read/written
+ */
+static unsigned long
+azfs_block_find(struct inode *inode, unsigned long from, unsigned long *size)
+{
+	struct azfs_super *super;
+	struct azfs_znode *znode;
+	struct azfs_block *block;
+	unsigned long block_id, west, east;
+
+	super = I2S(inode);
+	znode = I2Z(inode);
+
+	read_lock(&znode->lock);
+
+	while (from + *size > znode->size) {
+		read_unlock(&znode->lock);
+		i_size_write(inode, from + *size);
+		inode->i_op->truncate(inode);
+		read_lock(&znode->lock);
+	}
+
+	if (list_empty(&znode->block_list)) {
+		read_unlock(&znode->lock);
+		*size = 0;
+		return 0;
+	}
+
+	block_id = from >> super->block_shift;
+
+	for_each_block(block, &znode->block_list) {
+		if (block->count > block_id)
+			break;
+		block_id -= block->count;
+	}
+
+	west = from % super->block_size;
+	east = ((block->count - block_id) << super->block_shift) - west;
+
+	if (*size > east)
+		*size = east;
+
+	block_id = ((block->id + block_id) << super->block_shift) + west;
+
+	read_unlock(&znode->lock);
+
+	return block_id;
+}
+
+static struct inode*
+azfs_new_inode(struct super_block *, struct inode *, int, dev_t);
+
+/**
+ * azfs_mknod - mknod() method for inode_operations
+ * @dir, @dentry, @mode, @dev: see inode_operations methods
+ */
+static int
+azfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+{
+	struct inode *inode;
+
+	inode = azfs_new_inode(dir->i_sb, dir, mode, dev);
+	if (!inode)
+		return -ENOSPC;
+
+	if (S_ISREG(mode))
+		I2Z(inode)->size = 0;
+
+	dget(dentry);
+	d_instantiate(dentry, inode);
+
+	return 0;
+}
+
+/**
+ * azfs_create - create() method for inode_operations
+ * @dir, @dentry, @mode, @nd: see inode_operations methods
+ */
+static int
+azfs_create(struct inode *dir, struct dentry *dentry, int mode,
+	    struct nameidata *nd)
+{
+	return azfs_mknod(dir, dentry, mode | S_IFREG, 0);
+}
+
+/**
+ * azfs_mkdir - mkdir() method for inode_operations
+ * @dir, @dentry, @mode: see inode_operations methods
+ */
+static int
+azfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int rc;
+
+	rc = azfs_mknod(dir, dentry, mode | S_IFDIR, 0);
+	if (!rc)
+		inc_nlink(dir);
+
+	return rc;
+}
+
+/**
+ * azfs_symlink - symlink() method for inode_operations
+ * @dir, @dentry, @name: see inode_operations methods
+ */
+static int
+azfs_symlink(struct inode *dir, struct dentry *dentry, const char *name)
+{
+	struct inode *inode;
+	int rc;
+
+	inode = azfs_new_inode(dir->i_sb, dir, S_IFLNK | S_IRWXUGO, 0);
+	if (!inode)
+		return -ENOSPC;
+
+	rc = page_symlink(inode, name, strlen(name) + 1);
+	if (rc) {
+		iput(inode);
+		return rc;
+	}
+
+	dget(dentry);
+	d_instantiate(dentry, inode);
+
+	return 0;
+}
+
+/**
+ * azfs_aio_read - aio_read() method for file_operations
+ * @iocb, @iov, @nr_segs, @pos: see file_operations methods
+ */
+static ssize_t
+azfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
+	      unsigned long nr_segs, loff_t pos)
+{
+	struct azfs_super *super;
+	struct inode *inode;
+	void *target;
+	unsigned long pin;
+	unsigned long size, todo, step;
+	ssize_t rc;
+
+	inode = iocb->ki_filp->f_mapping->host;
+	super = I2S(inode);
+
+	mutex_lock(&inode->i_mutex);
+
+	if (pos >= i_size_read(inode)) {
+		rc = 0;
+		goto out;
+	}
+
+	target = iov->iov_base;
+	todo = min((loff_t) iov->iov_len, i_size_read(inode) - pos);
+
+	for (step = todo; step; step -= size) {
+		size = step;
+		pin = azfs_block_find(inode, pos, &size);
+		if (!size) {
+			rc = -ENOSPC;
+			goto out;
+		}
+		pin += super->io_addr;
+		if (copy_to_user(target, (void*) pin, size)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		iocb->ki_pos += size;
+		pos += size;
+		target += size;
+	}
+
+	rc = todo;
+
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return rc;
+}
+
+/**
+ * azfs_aio_write - aio_write() method for file_operations
+ * @iocb, @iov, @nr_segs, @pos: see file_operations methods
+ */
+static ssize_t
+azfs_aio_write(struct kiocb *iocb, const struct iovec *iov,
+	       unsigned long nr_segs, loff_t pos)
+{
+	struct azfs_super *super;
+	struct inode *inode;
+	void *source;
+	unsigned long pin;
+	unsigned long size, todo, step;
+	ssize_t rc;
+
+	inode = iocb->ki_filp->f_mapping->host;
+	super = I2S(inode);
+
+	source = iov->iov_base;
+	todo = iov->iov_len;
+
+	mutex_lock(&inode->i_mutex);
+
+	for (step = todo; step; step -= size) {
+		size = step;
+		pin = azfs_block_find(inode, pos, &size);
+		if (!size) {
+			rc = -ENOSPC;
+			goto out;
+		}
+		pin += super->io_addr;
+		if (copy_from_user((void*) pin, source, size)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		iocb->ki_pos += size;
+		pos += size;
+		source += size;
+	}
+
+	rc = todo;
+
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return rc;
+}
+
+/**
+ * azfs_open - open() method for file_operations
+ * @inode, @file: see file_operations methods
+ */
+static int
+azfs_open(struct inode *inode, struct file *file)
+{
+	if (file->f_flags & O_TRUNC) {
+		i_size_write(inode, 0);
+		inode->i_op->truncate(inode);
+	}
+	if (file->f_flags & O_APPEND)
+		inode->i_fop->llseek(file, 0, SEEK_END);
+
+	return 0;
+}
+
+/**
+ * azfs_mmap - mmap() method for file_operations
+ * @file, @vm: see file_operations methods
+ */
+static int
+azfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct azfs_super *super;
+	struct azfs_znode *znode;
+	struct inode *inode;
+	unsigned long cursor, pin;
+	unsigned long todo, size, vm_start;
+	pgprot_t page_prot;
+
+	inode = file->f_dentry->d_inode;
+	znode = I2Z(inode);
+	super = I2S(inode);
+
+	if (super->block_size < PAGE_SIZE)
+		return -EINVAL;
+
+	cursor = vma->vm_pgoff << super->block_shift;
+	todo = vma->vm_end - vma->vm_start;
+
+	if (cursor + todo > i_size_read(inode))
+		return -EINVAL;
+
+	page_prot = pgprot_val(vma->vm_page_prot);
+#ifdef CONFIG_PPC
+	page_prot |= (_PAGE_NO_CACHE | _PAGE_RW);
+	page_prot &= ~_PAGE_GUARDED;
+#else
+#warning You need to set in pgprot the PAGE_* flags specific to you architecture
+#endif
+	vma->vm_page_prot = __pgprot(page_prot);
+
+	vm_start = vma->vm_start;
+	for (size = todo; todo; todo -= size, size = todo) {
+		pin = azfs_block_find(inode, cursor, &size);
+		if (!size)
+			return -EAGAIN;
+		pin += super->ph_addr;
+		pin >>= PAGE_SHIFT;
+		if (remap_pfn_range(vma, vm_start, pin, size, vma->vm_page_prot))
+			return -EAGAIN;
+
+		vm_start += size;
+		cursor += size;
+	}
+
+	return 0;
+}
+
+/**
+ * azfs_truncate - truncate() method for inode_operations
+ * @inode: see inode_operations methods
+ */
+static void
+azfs_truncate(struct inode *inode)
+{
+	struct azfs_super *super;
+	struct azfs_znode *znode;
+	struct azfs_block *block, *tmp_block, *temp, *west, *east;
+	unsigned long id, count;
+	signed long delta;
+
+	super = I2S(inode);
+	znode = I2Z(inode);
+
+	delta = i_size_read(inode) + (super->block_size - 1);
+	delta >>= super->block_shift;
+	delta -= inode->i_blocks;
+
+	if (delta == 0) {
+		znode->size = i_size_read(inode);
+		return;
+	}
+
+	write_lock(&znode->lock);
+
+	while (delta > 0) {
+		west = east = NULL;
+
+		write_lock(&super->lock);
+
+		if (list_empty(&super->block_list)) {
+			write_unlock(&super->lock);
+			break;
+		}
+
+		for (count = delta; count; count--) {
+			for_each_block(block, &super->block_list)
+				if (block->count >= count) {
+					east = block;
+					break;
+				}
+			if (east)
+				break;
+		}
+
+		for_each_block_reverse(block, &znode->block_list) {
+			if (block->id + block->count == east->id)
+				west = block;
+			break;
+		}
+
+		if (east->count == count) {
+			if (west) {
+				west->count += east->count;
+				azfs_block_free(east);
+			} else {
+				azfs_block_move(east, &znode->block_list);
+			}
+		} else {
+			if (west) {
+				west->count += count;
+			} else {
+				if (!azfs_block_init(&znode->block_list,
+						east->id, count)) {
+					write_unlock(&super->lock);
+					break;
+				}
+			}
+
+			east->id += count;
+			east->count -= count;
+		}
+
+		write_unlock(&super->lock);
+
+		inode->i_blocks += count;
+
+		delta -= count;
+	}
+
+	while (delta < 0) {
+		for_each_block_safe_reverse(block, tmp_block, &znode->block_list) {
+			id = block->id;
+			count = block->count;
+			if ((signed long) count + delta > 0) {
+				block->count += delta;
+				id += block->count;
+				count -= block->count;
+				block = NULL;
+			}
+
+			west = east = NULL;
+
+			write_lock(&super->lock);
+
+			for_each_block(temp, &super->block_list) {
+				if (!west && (temp->id + temp->count == id))
+					west = temp;
+				else if (!east && (id + count == temp->id))
+					east = temp;
+				if (west && east)
+					break;
+			}
+
+			if (west && east) {
+				west->count += count + east->count;
+				azfs_block_free(east);
+				if (block)
+					azfs_block_free(block);
+			} else if (west) {
+				west->count += count;
+				if (block)
+					azfs_block_free(block);
+			} else if (east) {
+				east->id -= count;
+				east->count += count;
+				if (block)
+					azfs_block_free(block);
+			} else {
+				if (!block) {
+					if (!azfs_block_init(&super->block_list,
+							id, count)) {
+						write_unlock(&super->lock);
+						break;
+					}
+				} else {
+					azfs_block_move(block, &super->block_list);
+				}
+			}
+
+			write_unlock(&super->lock);
+
+			inode->i_blocks -= count;
+
+			delta += count;
+
+			break;
+		}
+	}
+
+	write_unlock(&znode->lock);
+
+	znode->size = min(i_size_read(inode),
+			(loff_t) inode->i_blocks << super->block_shift);
+}
+
+/**
+ * azfs_getattr - getattr() method for inode_operations
+ * @mnt, @dentry, @stat: see inode_operations methods
+ */
+static int
+azfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	struct azfs_super *super;
+	struct inode *inode;
+	unsigned short shift;
+
+	inode = dentry->d_inode;
+	super = I2S(inode);
+
+	generic_fillattr(inode, stat);
+	stat->blocks = inode->i_blocks;
+	shift = super->block_shift - super->sector_shift;
+	if (shift)
+		stat->blocks <<= shift;
+
+	return 0;
+}
+
+static const struct address_space_operations azfs_aops = {
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end
+};
+
+static struct backing_dev_info azfs_bdi = {
+	.ra_pages	= 0,
+	.capabilities	= AZFS_BDI_CAPABILITIES
+};
+
+static struct inode_operations azfs_dir_iops = {
+	.create		= azfs_create,
+	.lookup		= simple_lookup,
+	.link		= simple_link,
+	.unlink		= simple_unlink,
+	.symlink	= azfs_symlink,
+	.mkdir		= azfs_mkdir,
+	.rmdir		= simple_rmdir,
+	.mknod		= azfs_mknod,
+	.rename		= simple_rename
+};
+
+static const struct file_operations azfs_reg_fops = {
+	.llseek		= generic_file_llseek,
+	.aio_read	= azfs_aio_read,
+	.aio_write	= azfs_aio_write,
+	.open		= azfs_open,
+	.mmap		= azfs_mmap,
+	.fsync		= simple_sync_file,
+};
+
+static struct inode_operations azfs_reg_iops = {
+	.truncate	= azfs_truncate,
+	.getattr	= azfs_getattr
+};
+
+/**
+ * azfs_new_inode - cook a new inode
+ * @sb: super-block
+ * @dir: parent directory
+ * @mode: file mode
+ * @dev: to be forwarded to init_special_inode()
+ */
+static struct inode*
+azfs_new_inode(struct super_block *sb, struct inode *dir, int mode, dev_t dev)
+{
+	struct azfs_super *super;
+	struct inode *inode;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return NULL;
+
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	inode->i_mode = mode;
+	if (dir) {
+		dir->i_mtime = dir->i_ctime = inode->i_mtime;
+		inode->i_uid = current->fsuid;
+		if (dir->i_mode & S_ISGID) {
+			if (S_ISDIR(mode))
+				inode->i_mode |= S_ISGID;
+			inode->i_gid = dir->i_gid;
+		} else {
+			inode->i_gid = current->fsgid;
+		}
+	} else {
+		super = sb->s_fs_info;
+		inode->i_uid = super->uid;
+		inode->i_gid = super->gid;
+	}
+
+	inode->i_blocks = 0;
+	inode->i_mapping->a_ops = &azfs_aops;
+	inode->i_mapping->backing_dev_info = &azfs_bdi;
+
+	switch (mode & S_IFMT) {
+	case S_IFDIR:
+		inode->i_op = &azfs_dir_iops;
+		inode->i_fop = &simple_dir_operations;
+		inc_nlink(inode);
+		break;
+
+	case S_IFREG:
+		inode->i_op = &azfs_reg_iops;
+		inode->i_fop = &azfs_reg_fops;
+		break;
+
+	case S_IFLNK:
+		inode->i_op = &page_symlink_inode_operations;
+		break;
+
+	default:
+		init_special_inode(inode, mode, dev);
+		break;
+	}
+
+	return inode;
+}
+
+/**
+ * azfs_alloc_inode - alloc_inode() method for super_operations
+ * @sb: see super_operations methods
+ */
+static struct inode*
+azfs_alloc_inode(struct super_block *sb)
+{
+	struct azfs_znode *znode;
+
+	znode = kmem_cache_alloc(azfs_znode_cache, GFP_KERNEL);
+	if (znode) {
+		INIT_LIST_HEAD(&znode->block_list);
+		rwlock_init(&znode->lock);
+
+		inode_init_once(&znode->vfs_inode);
+
+		return &znode->vfs_inode;
+	}
+
+	return NULL;
+}
+
+/**
+ * azfs_destroy_inode - destroy_inode() method for super_operations
+ * @inode: see super_operations methods
+ */
+static void
+azfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(azfs_znode_cache, I2Z(inode));
+}
+
+/**
+ * azfs_delete_inode - delete_inode() method for super_operations
+ * @inode: see super_operations methods
+ */
+static void
+azfs_delete_inode(struct inode *inode)
+{
+	if (S_ISREG(inode->i_mode)) {
+		i_size_write(inode, 0);
+		azfs_truncate(inode);
+	}
+	truncate_inode_pages(&inode->i_data, 0);
+	clear_inode(inode);
+}
+
+/**
+ * azfs_statfs - statfs() method for super_operations
+ * @dentry, @stat: see super_operations methods
+ */
+static int
+azfs_statfs(struct dentry *dentry, struct kstatfs *stat)
+{
+	struct super_block *sb;
+	struct azfs_super *super;
+	struct inode *inode;
+	unsigned long inodes, blocks;
+
+	sb = dentry->d_sb;
+	super = sb->s_fs_info;
+
+	inodes = blocks = 0;
+	mutex_lock(&sb->s_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		inodes++;
+		blocks += inode->i_blocks;
+	}
+	mutex_unlock(&sb->s_lock);
+
+	stat->f_type = AZFS_SUPERBLOCK_MAGIC;
+	stat->f_bsize = super->block_size;
+	stat->f_blocks = super->media_size >> super->block_shift;
+	stat->f_bfree = stat->f_blocks - blocks;
+	stat->f_bavail = stat->f_blocks - blocks;
+	stat->f_files = inodes + blocks;
+	stat->f_ffree = blocks + 1;
+	stat->f_namelen = NAME_MAX;
+
+	return 0;
+}
+
+static struct super_operations azfs_ops = {
+	.alloc_inode	= azfs_alloc_inode,
+	.destroy_inode	= azfs_destroy_inode,
+	.drop_inode	= generic_delete_inode,
+	.delete_inode	= azfs_delete_inode,
+	.statfs		= azfs_statfs
+};
+
+enum {
+	Opt_blocksize_short,
+	Opt_blocksize_long,
+	Opt_uid,
+	Opt_gid,
+	Opt_err
+};
+
+static match_table_t tokens = {
+	{Opt_blocksize_short, "bs=%u"},
+	{Opt_blocksize_long, "blocksize=%u"},
+	{Opt_uid, "uid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_err, NULL}
+};
+
+/**
+ * azfs_parse_mount_parameters - parse options given to mount with -o
+ * @super: azfs super block extension
+ * @options: comma separated options
+ */
+static int
+azfs_parse_mount_parameters(struct azfs_super *super, char *options)
+{
+	char *option;
+	int token, value;
+	substring_t args[MAX_OPT_ARGS];
+
+	if (!options)
+		return 1;
+
+	while ((option = strsep(&options, ",")) != NULL) {
+		if (!*option)
+			continue;
+
+		token = match_token(option, tokens, args);
+		switch (token) {
+		case Opt_blocksize_short:
+		case Opt_blocksize_long:
+			if (match_int(&args[0], &value))
+				goto syntax_error;
+			super->block_size = value;
+			break;
+
+		case Opt_uid:
+			if (match_int(&args[0], &value))
+				goto syntax_error;
+			super->uid = value;
+			break;
+
+		case Opt_gid:
+			if (match_int(&args[0], &value))
+				goto syntax_error;
+			super->gid = value;
+			break;
+
+		default:
+			goto syntax_error;
+		}
+	}
+
+	return 1;
+
+syntax_error:
+	printk(KERN_ERR "%s: invalid mount option\n",
+			AZFS_FILESYSTEM_NAME);
+
+	return 0;
+}
+
+/**
+ * azfs_fill_super - fill_super routine for get_sb
+ * @sb, @data, @silent: see file_system_type methods
+ */
+static int
+azfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct gendisk *disk;
+	struct azfs_super *super = NULL, *tmp_super;
+	struct azfs_block *block = NULL;
+	struct inode *inode = NULL;
+	void *kaddr;
+	unsigned long pfn;
+	int rc;
+
+	BUG_ON(!sb->s_bdev);
+
+	disk = sb->s_bdev->bd_disk;
+
+	BUG_ON(!disk || !disk->queue);
+
+	if (!disk->fops->direct_access) {
+		printk(KERN_ERR "%s needs a block device with a "
+				"direct_access() method\n",
+				AZFS_FILESYSTEM_NAME);
+		return -ENOSYS;
+	}
+
+	get_device(disk->driverfs_dev);
+
+	sb->s_magic = AZFS_SUPERBLOCK_MAGIC;
+	sb->s_flags = AZFS_SUPERBLOCK_FLAGS;
+	sb->s_op = &azfs_ops;
+	sb->s_maxbytes = get_capacity(disk) * disk->queue->hardsect_size;
+	sb->s_time_gran = 1;
+
+	spin_lock(&super_list.lock);
+	list_for_each_entry(tmp_super, &super_list.head, list)
+		if (tmp_super->blkdev == sb->s_bdev) {
+			super = tmp_super;
+			break;
+		}
+	spin_unlock(&super_list.lock);
+
+	if (super) {
+		if (data && strlen((char*) data))
+			printk(KERN_WARNING "/dev/%s was already mounted with "
+					"%s before, it will be mounted with "
+					"mount options used last time, "
+					"options just given would be ignored\n",
+					disk->disk_name, AZFS_FILESYSTEM_NAME);
+		sb->s_fs_info = super;
+	} else {
+		super = kzalloc(sizeof(struct azfs_super), GFP_KERNEL);
+		if (!super) {
+			rc = -ENOMEM;
+			goto failed;
+		}
+		sb->s_fs_info = super;
+
+		if (!azfs_parse_mount_parameters(super, (char*) data)) {
+			rc = -EINVAL;
+			goto failed;
+		}
+
+		inode = azfs_new_inode(sb, NULL, S_IFDIR | S_IRWXUGO, 0);
+		if (!inode) {
+			rc = -ENOMEM;
+			goto failed;
+		}
+
+		super->root = d_alloc_root(inode);
+		if (!super->root) {
+			rc = -ENOMEM;
+			goto failed;
+		}
+		dget(super->root);
+
+		INIT_LIST_HEAD(&super->list);
+		INIT_LIST_HEAD(&super->block_list);
+		rwlock_init(&super->lock);
+
+		super->media_size = sb->s_maxbytes;
+
+		if (!super->block_size)
+			super->block_size = sb->s_blocksize;
+		super->block_shift = blksize_bits(super->block_size);
+
+		super->sector_size = disk->queue->hardsect_size;
+		super->sector_shift = blksize_bits(super->sector_size);
+
+		super->blkdev = sb->s_bdev;
+
+		block = azfs_block_init(&super->block_list,
+				0, super->media_size >> super->block_shift);
+		if (!block) {
+			rc = -ENOMEM;
+			goto failed;
+		}
+
+		rc = disk->fops->direct_access(super->blkdev, 0, &kaddr, &pfn);
+		if (rc < 0) {
+			rc = -EFAULT;
+			goto failed;
+		}
+		super->ph_addr = (unsigned long) kaddr;
+
+		super->io_addr = (unsigned long) ioremap_flags(
+				super->ph_addr, super->media_size, _PAGE_NO_CACHE);
+		if (!super->io_addr) {
+			rc = -EFAULT;
+			goto failed;
+		}
+
+		spin_lock(&super_list.lock);
+		list_add(&super->list, &super_list.head);
+		spin_unlock(&super_list.lock);
+	}
+
+	sb->s_root = super->root;
+	disk->driverfs_dev->driver_data = super;
+	disk->driverfs_dev->platform_data = sb;
+
+	if (super->block_size < PAGE_SIZE)
+		printk(KERN_INFO "Block size on %s is smaller then system "
+				"page size: mmap() would not be supported\n",
+				disk->disk_name);
+
+	return 0;
+
+failed:
+	if (super) {
+		sb->s_root = NULL;
+		sb->s_fs_info = NULL;
+		if (block)
+			azfs_block_free(block);
+		if (super->root)
+			dput(super->root);
+		if (inode)
+			iput(inode);
+		disk->driverfs_dev->driver_data = NULL;
+		kfree(super);
+		disk->driverfs_dev->platform_data = NULL;
+		put_device(disk->driverfs_dev);
+	}
+
+	return rc;
+}
+
+/**
+ * azfs_get_sb - get_sb() method for file_system_type
+ * @fs_type, @flags, @dev_name, @data, @mount: see file_system_type methods
+ */
+static int
+azfs_get_sb(struct file_system_type *fs_type, int flags,
+	    const char *dev_name, void *data, struct vfsmount *mount)
+{
+	return get_sb_bdev(fs_type, flags,
+			dev_name, data, azfs_fill_super, mount);
+}
+
+/**
+ * azfs_kill_sb - kill_sb() method for file_system_type
+ * @sb: see file_system_type methods
+ */
+static void
+azfs_kill_sb(struct super_block *sb)
+{
+	sb->s_root = NULL;
+	kill_block_super(sb);
+}
+
+static struct file_system_type azfs_fs = {
+	.owner		= THIS_MODULE,
+	.name		= AZFS_FILESYSTEM_NAME,
+	.get_sb		= azfs_get_sb,
+	.kill_sb	= azfs_kill_sb,
+	.fs_flags	= AZFS_FILESYSTEM_FLAGS
+};
+
+/**
+ * azfs_init
+ */
+static int __init
+azfs_init(void)
+{
+	int rc;
+
+	INIT_LIST_HEAD(&super_list.head);
+	spin_lock_init(&super_list.lock);
+
+	azfs_znode_cache = kmem_cache_create("azfs_znode_cache",
+			sizeof(struct azfs_znode), 0, AZFS_CACHE_FLAGS, NULL);
+	if (!azfs_znode_cache) {
+		printk(KERN_ERR "Could not allocate inode cache for %s\n",
+				AZFS_FILESYSTEM_NAME);
+		rc = -ENOMEM;
+		goto failed;
+	}
+
+	azfs_block_cache = kmem_cache_create("azfs_block_cache",
+			sizeof(struct azfs_block), 0, AZFS_CACHE_FLAGS, NULL);
+	if (!azfs_block_cache) {
+		printk(KERN_ERR "Could not allocate block cache for %s\n",
+				AZFS_FILESYSTEM_NAME);
+		rc = -ENOMEM;
+		goto failed;
+	}
+
+	rc = register_filesystem(&azfs_fs);
+	if (rc != 0) {
+		printk(KERN_ERR "Could not register %s\n",
+				AZFS_FILESYSTEM_NAME);
+		goto failed;
+	}
+
+	return 0;
+
+failed:
+	if (azfs_block_cache)
+		kmem_cache_destroy(azfs_block_cache);
+
+	if (azfs_znode_cache)
+		kmem_cache_destroy(azfs_znode_cache);
+
+	return rc;
+}
+
+/**
+ * azfs_exit
+ */
+static void __exit
+azfs_exit(void)
+{
+	struct azfs_super *super, *tmp_super;
+	struct azfs_block *block, *tmp_block;
+	struct gendisk *disk;
+
+	spin_lock(&super_list.lock);
+	list_for_each_entry_safe(super, tmp_super, &super_list.head, list) {
+		disk = super->blkdev->bd_disk;
+		list_del(&super->list);
+		iounmap((void*) super->io_addr);
+		write_lock(&super->lock);
+		for_each_block_safe(block, tmp_block, &super->block_list)
+			azfs_block_free(block);
+		write_unlock(&super->lock);
+		disk->driverfs_dev->driver_data = NULL;
+		disk->driverfs_dev->platform_data = NULL;
+		kfree(super);
+		put_device(disk->driverfs_dev);
+	}
+	spin_unlock(&super_list.lock);
+
+	unregister_filesystem(&azfs_fs);
+
+	kmem_cache_destroy(azfs_block_cache);
+	kmem_cache_destroy(azfs_znode_cache);
+}
+
+module_init(azfs_init);
+module_exit(azfs_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Maxim Shchetynin <maxim@de.ibm.com>");
+MODULE_DESCRIPTION("Non-buffered file system for IO devices");

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
