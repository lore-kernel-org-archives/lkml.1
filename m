Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbXFFLNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbXFFLNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXFFLNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:13:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:5869 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXFFLNQ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XGREwrmy3lh09nCuF2zZbS498m25QRKdHJaH38QSbpfInKabzz24iJlYBiTHfH+Zn27Tbqf35Gl169znaXZfCkBbX2EPLbG+RndLVzLO3n15SRXdUvjdI4nXqFfn5jiWCwgKHalubTTHNyIgRYA8EB7y49xPB3SVdkVCFRFJeMI=
Message-ID: <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
Date: Wed, 6 Jun 2007 04:13:14 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com, "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <46641472.3080802@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Carsten Otte <cotte@de.ibm.com> wrote:
> Nick Piggin wrote:
> > The question is, why is that not enough (I haven't looked at these
> > patches enough to work out if there is anything more they provide).
> I think, it just takes trying things out. From reading the code, I
> think this should work well for the filemap_xip code with no struct page.
> Also, we need eliminate nopage() to get rid of the struct page.
> Unfortunately I don't find time to try this out for now, and on 390 we
> can live with struct page for the time being. In contrast to the
> embedded platforms, the mem_mep array gets swapped out to disk by our
> hypervisor.
>
> so long,
> Carsten

Okay, so here is a patch that implements the filemap_xip.c among other
things such as coexistence of block and linear addressing mounts and
enabling reading of XIP binaries from block.  I've been messing with
those patches for a long time and I couldn't stand all the #ifdefs any
longer :)

I have two system:
(1) UML which populates cramfs_sb_info.linear_virt_addr with find_iomem().
(2) PXA270 which populates cramfs_sb_info.linear_virt_addr is
populated with ioremap()

I run two test:
(A) 'cmp /mnt/cramfs/bin/busybox /bin/busybox'
(B) execute '/mnt/cramfs/bin/busybox'

On both systems (A) works fine.  (B) works on (1) but not on (2).

(2) failed with the following messages.  (This wasn't really busybox.
It was xxd, not statically link, hence the issue with ld.so)

Inconsistency detected by ld.so: rtld.cBad pte = a4c6d05f, process =
???, vm_flags = 1875, vaddr = 8000: 1202: dl_main: Assertion
`_rtld_local._dl_rtld_map.l_libname' [<c0024ca8>] failed!
(dump_stack+0x0/0x14) from [<c0066b28>] (print_bad_pte+0x54/0x64)
[<c0066ad4>] (print_bad_pte+0x0/0x64) from [<c0066ba0>]
(vm_normal_page+0x68/0xb4)
 r4 = 00008000
[<c0066b38>] (vm_normal_page+0x0/0xb4) from [<c0067498>]
(unmap_vmas+0x4bc/0x660)
 r5 = 00008000  r4 = C3806820
[<c0066fdc>] (unmap_vmas+0x0/0x660) from [<c006c9a0>] (exit_mmap+0x68/0x124)
[<c006c938>] (exit_mmap+0x0/0x124) from [<c0034320>] (mmput+0x40/0xc0)
 r8 = 00007F00  r7 = C0336040  r6 = C3ECB3D4  r5 = C0336040
 r4 = C3ECB3A0
[<c00342e0>] (mmput+0x0/0xc0) from [<c0038998>] (exit_mm+0x80/0xe0)
 r4 = C3ECB3A0
[<c0038918>] (exit_mm+0x0/0xe0) from [<c0038f10>] (do_exit+0xf4/0x82c)
 r6 = 00000001  r5 = 40021910  r4 = 00007F00
[<c0038e1c>] (do_exit+0x0/0x82c) from [<c00396fc>] (do_group_exit+0x78/0x9c)
[<c0039684>] (do_group_exit+0x0/0x9c) from [<c0039738>]
(sys_exit_group+0x18/0x1c)
 r4 = 40016F70
[<c0039720>] (sys_exit_group+0x0/0x1c) from [<c0020c00>]
(ret_fast_syscall+0x0/0x2c)


So what's going on?


diff -r 5114d0f3b003 -r 83e92f97054c fs/Kconfig
--- a/fs/Kconfig	Tue Jun 05 11:37:21 2007 -0700
+++ b/fs/Kconfig	Wed Jun 06 03:27:31 2007 -0700
@@ -65,7 +65,6 @@ config FS_XIP
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
 	default y

 config EXT3_FS
@@ -1368,6 +1367,40 @@ config CRAMFS
 	  To compile this as a module, choose M here: the module will be called
 	  cramfs.  Note that the root file system (the one containing the
 	  directory /) cannot be compiled as a module.
+
+	  The CramFs driver can load data directly from a linear addressed memory
+	  range (usually non volatile memory like flash) instead of going through
+	  the block device layer.  This saves some memory since no intermediate
+	  buffering is necessary.
+
+	  The location of the CramFs image in memory is board dependent.
+	  Therefore you must know the proper physical address where to store
+	  the CramFs image and specify it using the physaddr=0x******** mount
+	  option.  With UML kernels iomem=***** can be used instead after
+	  having passed the kernel a parameter such as 'iomem=bob,cramfs'.
+	  (for example: "mount -t cramfs -o physaddr=0x100000 none /mnt" or
+	   "mount -t cramfs -o iomem=bob none /mnt")
+	
+	  To mount as the root pass the command line parameter
+	  "root=/dev/null rootflags=physaddr=0x********" or
+	  "root=/dev/null rootflags=iomem=*****" to the kernel
+	
+	  Replace 0x******** with the physical address location of the linear
+	  CramFs image to boot with.
+
+config CRAMFS_XIP
+	bool "Support XIP on cramfs"
+	depends on FS_XIP
+	help
+	  You must say Y to this option if you want to be able to run
+	  applications directly from non-volatile memory.  XIP
+	  applications are marked by setting the sticky bit (ie, "chmod
+	  +t <app name>").  A CramFs file system then needs to be
+	  created using mkcramfs (with XIP cramfs support in
+	  it). Applications marked for XIP execution will not be
+	  compressed since they have to run directly from flash.
+
+	  This will also allow mounting an XIP binary on a block device.

 	  If unsure, say N.

diff -r 5114d0f3b003 -r 83e92f97054c fs/cramfs/inode.c
--- a/fs/cramfs/inode.c	Tue Jun 05 11:37:21 2007 -0700
+++ b/fs/cramfs/inode.c	Wed Jun 06 03:27:31 2007 -0700
@@ -9,6 +9,46 @@
 /*
  * These are the VFS interfaces to the compressed rom filesystem.
  * The actual compression is based on zlib, see the other files.
+ */
+
+/* Linear Addressing code
+ *
+ * Copyright (C) 2000 Shane Nay.
+ *
+ * Allows you to have a linearly addressed cramfs filesystem.
+ * Saves the need for buffer, and the munging of the buffer.
+ * Savings a bit over 32k with default PAGE_SIZE, BUFFER_SIZE
+ * etc.  Usefull on embedded platform with ROM :-).
+ *
+ * Downsides- Currently linear addressed cramfs partitions
+ * don't co-exist with block cramfs partitions.
+ *
+ */
+
+/*
+ * 28-Dec-2000: XIP mode for linear cramfs
+ * Copyright (C) 2000 Robert Leslie <rob@mars.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/* filemap_xip.c interfaces - Jared Hulbert 2007
+ * linear + block coexisting - Jared Hulbert 2007
+ *  (inspired by patches from Kyungmin Park of Samsung and others at
+ *   Motorola from the EZX phones)
+ *
  */

 #include <linux/module.h>
@@ -24,22 +64,25 @@
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 #include <asm/semaphore.h>
+#include <linux/vmalloc.h>

 #include <asm/uaccess.h>
-
-static const struct super_operations cramfs_ops;
-static const struct inode_operations cramfs_dir_inode_operations;
+#include <asm/tlbflush.h>
+#ifdef CONFIG_UML
+#include <mem_user.h>
+#endif
+
+static struct super_operations cramfs_ops;
+static struct inode_operations cramfs_dir_inode_operations;
 static const struct file_operations cramfs_directory_operations;
 static const struct address_space_operations cramfs_aops;

 static DEFINE_MUTEX(read_mutex);
-

 /* These two macros may change in future, to provide better st_ino
    semantics. */
 #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
 #define OFFSET(x)	((x)->i_ino)
-

 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
@@ -99,13 +142,77 @@ static int cramfs_iget5_set(struct inode
 	return 0;
 }

+static int cramfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
+	
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+		return -EINVAL;
+
+	if ((CRAMFS_INODE_IS_XIP(inode)) && !(vma->vm_flags & VM_WRITE) &&
+	  (LINEAR_CRAMFS(sbi)))
+		return xip_file_mmap(file, vma);
+
+	return generic_file_mmap(file, vma);
+}
+
+struct page *cramfs_get_xip_page(struct address_space *mapping,
sector_t offset,
+			       int create)
+{
+ 	unsigned long address;
+	unsigned long offs = offset;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
+	address  = PAGE_ALIGN((unsigned long)(sbi->linear_virt_addr
+		+ OFFSET(inode)));
+	offs *= 512; /* FIXME -- This shouldn't be hard coded */
+	address += offs;
+
+	return virt_to_page(address);
+}
+
+ssize_t cramfs_file_read(struct file *file, char __user * buf, size_t len,
+		       loff_t * ppos)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
+	
+	if ((CRAMFS_INODE_IS_XIP(inode)) && (LINEAR_CRAMFS(sbi)))
+		return xip_file_read(file, buf, len, ppos);
+		
+	return do_sync_read(file, buf, len, ppos);
+}
+
+static struct file_operations cramfs_linear_xip_fops = {
+	aio_read:	generic_file_aio_read,
+	read:		cramfs_file_read,
+	mmap:		cramfs_mmap,
+};
+
+static struct backing_dev_info cramfs_backing_dev_info = {
+	.ra_pages	= 0,	/* No readahead */
+};
+
 static struct inode *get_cramfs_inode(struct super_block *sb,
 				struct cramfs_inode * cramfs_inode)
 {
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
 	struct inode *inode = iget5_locked(sb, CRAMINO(cramfs_inode),
 					    cramfs_iget5_test, cramfs_iget5_set,
 					    cramfs_inode);
 	if (inode && (inode->i_state & I_NEW)) {
+		if (LINEAR_CRAMFS(sbi))
+			inode->i_mapping->backing_dev_info =
+				&cramfs_backing_dev_info;
+
+#ifdef CONFIG_CRAMFS_XIP
+		if(S_ISREG(inode->i_mode))
+			inode->i_fop = CRAMFS_INODE_IS_XIP(inode) ?
+				&cramfs_linear_xip_fops : &generic_ro_fops;
+#endif
 		unlock_new_inode(inode);
 	}
 	return inode;
@@ -135,16 +242,18 @@ static struct inode *get_cramfs_inode(st
 #define BLKS_PER_BUF		(1 << BLKS_PER_BUF_SHIFT)
 #define BUFFER_SIZE		(BLKS_PER_BUF*PAGE_CACHE_SIZE)

-static unsigned char read_buffers[READ_BUFFERS][BUFFER_SIZE];
-static unsigned buffer_blocknr[READ_BUFFERS];
-static struct super_block * buffer_dev[READ_BUFFERS];
+static unsigned char **read_buffers = NULL;
+static unsigned *buffer_blocknr = NULL;
+static struct super_block **buffer_dev = NULL;
 static int next_buffer;
+static int block_filesystems = 0;

 /*
  * Returns a pointer to a buffer containing at least LEN bytes of
  * filesystem starting at byte offset OFFSET into the filesystem.
  */
-static void *cramfs_read(struct super_block *sb, unsigned int offset,
unsigned int len)
+static void *cramfs_read_block(struct super_block *sb, unsigned int offset,
+	    unsigned int len)
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 	struct page *pages[BLKS_PER_BUF];
@@ -219,8 +328,37 @@ static void *cramfs_read(struct super_bl
 	return read_buffers[buffer] + offset;
 }

+static void *cramfs_read(struct super_block *sb, unsigned int offset,
+	    unsigned int len)
+{
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
+	if (LINEAR_CRAMFS(sbi)) {
+		if (!len)
+			return NULL;
+		return (void*)(sbi->linear_virt_addr + offset);
+	}
+
+	return cramfs_read_block(sb, offset, len);
+}
+
 static void cramfs_put_super(struct super_block *sb)
 {
+	int i;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
+	if (!LINEAR_CRAMFS(sbi)) {
+		if (!--block_filesystems) {
+			for (i = 0; i < READ_BUFFERS; i++) {
+				if (read_buffers[i])
+					vfree(read_buffers[i]);
+			}
+			vfree(read_buffers);
+			vfree(buffer_blocknr);
+			vfree(buffer_dev);
+		}
+	}
+
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -231,26 +369,13 @@ static int cramfs_remount(struct super_b
 	return 0;
 }

-static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
-{
-	int i;
+static int cramfs_check_super(struct super_block *sb, int silent)
+{
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
 	struct cramfs_super super;
 	unsigned long root_offset;
-	struct cramfs_sb_info *sbi;
 	struct inode *root;
-
-	sb->s_flags |= MS_RDONLY;
-
-	sbi = kzalloc(sizeof(struct cramfs_sb_info), GFP_KERNEL);
-	if (!sbi)
-		return -ENOMEM;
-	sb->s_fs_info = sbi;
-
-	/* Invalidate the read buffers on mount: think disk change.. */
-	mutex_lock(&read_mutex);
-	for (i = 0; i < READ_BUFFERS; i++)
-		buffer_blocknr[i] = -1;
-
+	
 	/* Read the first block and get the superblock from it */
 	memcpy(&super, cramfs_read(sb, 0, sizeof(super)), sizeof(super));
 	mutex_unlock(&read_mutex);
@@ -259,7 +384,8 @@ static int cramfs_fill_super(struct supe
 	if (super.magic != CRAMFS_MAGIC) {
 		/* check at 512 byte offset */
 		mutex_lock(&read_mutex);
-		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
+		memcpy(&super, cramfs_read(sb, 512, sizeof(super)),
+		    sizeof(super));
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (!silent)
@@ -311,11 +437,170 @@ static int cramfs_fill_super(struct supe
 		iput(root);
 		goto out;
 	}
+
+	printk(KERN_INFO "cramfs: cramfs image appears to be %lu KB in size\n",
+		sbi->size/1024);
+	
+	return 0;
+out:
+	return -EINVAL;
+}
+
+static int cramfs_fill_super_physaddr(struct super_block *sb, void *data,
+	    int silent)
+{
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+	char *p;
+	int ret = -EINVAL;
+
+	if (!(p = strstr((char *)data, "physaddr=")))
+		goto out;
+
+	sbi->linear_phys_addr = simple_strtoul(p + 9, NULL, 0);
+	if (sbi->linear_phys_addr & (PAGE_SIZE-1)) {
+		printk(KERN_ERR "cramfs: physical address 0x%lx for linear"
+		    "cramfs isn't aligned to a page boundary\n",
+		    sbi->linear_phys_addr);
+			goto out;
+	}
+	if (sbi->linear_phys_addr == 0) {
+		printk(KERN_ERR "cramfs: physical address for linear cramfs"
+		    "image can't be 0\n");
+		goto out;
+	}
+	printk(KERN_INFO "cramfs: checking physical address 0x%lx for linear"
+	    "cramfs image\n", sbi->linear_phys_addr);
+
+	/* Map only one page for now.  Will remap it when fs size is known. */
+	sbi->linear_virt_addr =
+	    ioremap(sbi->linear_phys_addr, PAGE_SIZE);
+	if (!sbi->linear_virt_addr) {
+		printk(KERN_ERR "cramfs: ioremap of the linear cramfs image"
+		    "failed\n");
+		goto out;
+	}
+	mutex_lock(&read_mutex);
+	ret = cramfs_check_super(sb, silent);
+	if (ret != 0)
+		goto out;
+
+	/* Remap the whole filesystem now */
+	iounmap(sbi->linear_virt_addr);
+	sbi->linear_virt_addr =
+		CRAMFS_REMAP(sbi->linear_phys_addr, sbi->size);
+
+	if (!sbi->linear_virt_addr) {
+		printk(KERN_ERR "cramfs: ioremap of the linear cramfs image"
+		    " failed\n");
+		goto out;
+	}
+	
+	return 0;
+out:
+	if (sbi->linear_virt_addr)
+		iounmap(sbi->linear_virt_addr);
+	return ret;
+}
+
+static int cramfs_fill_super_iomem(struct super_block *sb, void *data,
+	    int silent)
+{
+#ifdef CONFIG_UML
+	/* this allows users to mount with a -o iomem=bob from UML kernels */
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+	char *p;
+	int ret = -EINVAL;
+	unsigned long len, virtaddr;
+	
+	if (!(p = strstr((char *)data, "iomem=")))
+		goto out;
+	
+	sbi->linear_phys_addr = 0;
+	virtaddr = find_iomem(p + 6, &len);
+	sbi->linear_virt_addr = (void *)virtaddr;
+	
+	if ((unsigned long)(sbi->linear_virt_addr) & (PAGE_SIZE-1)) {
+		printk(KERN_ERR "cramfs: virtual address 0x%lx for linear"
+		    " cramfs isn't aligned to a page boundary\n",
+		    sbi->linear_phys_addr);
+		goto out;
+	}
+	if ((unsigned long)(sbi->linear_virt_addr) == 0) {
+		printk(KERN_ERR "cramfs: virtual address for linear cramfs"
+		    " image can't be 0\n");
+		goto out;
+	}
+	printk(KERN_INFO "cramfs: checking virtual address 0x%lx for"
+	    " linear cramfs image\n",
+	    (unsigned long)sbi->linear_virt_addr);
+	mutex_lock(&read_mutex);
+	ret = cramfs_check_super(sb, silent);
+	if (ret != 0)
+		goto out;
+
+	return 0;
+out:
+	return ret;
+#else
+	return -EINVAL;
+#endif
+}
+
+static int cramfs_fill_super_block(struct super_block *sb, int silent)
+{
+	int i;
+	int ret = -EINVAL;
+	
+	printk("fill_super_block\n");
+	mutex_lock(&read_mutex);
+	if (!block_filesystems++) {
+		read_buffers = vmalloc(sizeof(*read_buffers) * READ_BUFFERS);
+		for (i = 0; i < READ_BUFFERS; i++) {
+			read_buffers[i] = vmalloc(sizeof(**read_buffers)
+			    * BUFFER_SIZE);
+		}
+		buffer_blocknr = vmalloc(sizeof(*buffer_blocknr)
+		    * READ_BUFFERS);
+		buffer_dev = vmalloc(sizeof(*buffer_dev) * READ_BUFFERS);
+	}
+	/* Invalidate the read buffers on mount: think disk change.. */
+	for (i = 0; i < READ_BUFFERS; i++)
+		buffer_blocknr[i] = -1;
+	ret = cramfs_check_super(sb, silent);
+	if (ret != 0)
+		goto out;
+
+	return 0;
+out:
+	return ret;
+}
+
+static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	int ret = 0;
+	struct cramfs_sb_info *sbi;
+
+	sb->s_flags |= MS_RDONLY;
+
+	sbi = kzalloc(sizeof(struct cramfs_sb_info), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sb->s_fs_info = sbi;
+
+	ret = cramfs_fill_super_physaddr(sb, data, silent);
+	ret = cramfs_fill_super_iomem(sb, data, silent);
+
+	if (!LINEAR_CRAMFS(sbi))
+		ret = cramfs_fill_super_block(sb, silent);
+
+	if (ret)
+		goto out;
+
 	return 0;
 out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }

 static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -404,7 +689,8 @@ static int cramfs_readdir(struct file *f
 /*
  * Lookup and fill in the inode data..
  */
-static struct dentry * cramfs_lookup(struct inode *dir, struct dentry
*dentry, struct nameidata *nd)
+static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry,
+    struct nameidata *nd)
 {
 	unsigned int offset = 0;
 	int sorted;
@@ -416,7 +702,8 @@ static struct dentry * cramfs_lookup(str
 		char *name;
 		int namelen, retval;

-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+256);
+		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset,
+		    sizeof(*de)+256);
 		name = (char *)(de+1);

 		/* Try to take advantage of sorted directories */
@@ -469,28 +756,47 @@ static int cramfs_readpage(struct file *
 	bytes_filled = 0;
 	if (page->index < maxblock) {
 		struct super_block *sb = inode->i_sb;
-		u32 blkptr_offset = OFFSET(inode) + page->index*4;
-		u32 start_offset, compr_len;
-
-		start_offset = OFFSET(inode) + maxblock*4;
+		u32 blkptr_off = OFFSET(inode) + page->index*4;
+		u32 start_off, compr_len;
+
+#ifdef CONFIG_CRAMFS_XIP
+		if(CRAMFS_INODE_IS_XIP(inode)) {
+			blkptr_off =
+				PAGE_ALIGN(OFFSET(inode)) +
+				page->index * PAGE_CACHE_SIZE;
+			mutex_lock(&read_mutex);
+			memcpy(page_address(page),
+				cramfs_read(sb, blkptr_off, PAGE_CACHE_SIZE),
+				PAGE_CACHE_SIZE);
+			mutex_unlock(&read_mutex);
+			bytes_filled = PAGE_CACHE_SIZE;
+			pgdata = kmap(page);
+		} else {
+#endif /* CONFIG_CRAMFS_XIP */
+		start_off = OFFSET(inode) + maxblock*4;
 		mutex_lock(&read_mutex);
 		if (page->index)
-			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
-		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
+			start_off = *(u32 *) cramfs_read(sb, blkptr_off-4, 4);
+		compr_len = (*(u32 *) cramfs_read(sb, blkptr_off, 4)
+		    - start_off);
 		mutex_unlock(&read_mutex);
 		pgdata = kmap(page);
 		if (compr_len == 0)
 			; /* hole */
 		else if (compr_len > (PAGE_CACHE_SIZE << 1))
-			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
+			printk(KERN_ERR "cramfs: bad compressed blocksize"
+			    " %u\n", compr_len);
 		else {
 			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
 				 PAGE_CACHE_SIZE,
-				 cramfs_read(sb, start_offset, compr_len),
+				 cramfs_read(sb, start_off, compr_len),
 				 compr_len);
 			mutex_unlock(&read_mutex);
 		}
+#ifdef CONFIG_CRAMFS_XIP
+		}
+#endif /* CONFIG_CRAMFS_XIP */
 	} else
 		pgdata = kmap(page);
 	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
@@ -502,7 +808,8 @@ static int cramfs_readpage(struct file *
 }

 static const struct address_space_operations cramfs_aops = {
-	.readpage = cramfs_readpage
+	.readpage = cramfs_readpage,
+	.get_xip_page = cramfs_get_xip_page,
 };

 /*
@@ -518,11 +825,11 @@ static const struct file_operations cram
 	.readdir	= cramfs_readdir,
 };

-static const struct inode_operations cramfs_dir_inode_operations = {
+static struct inode_operations cramfs_dir_inode_operations = {
 	.lookup		= cramfs_lookup,
 };

-static const struct super_operations cramfs_ops = {
+static struct super_operations cramfs_ops = {
 	.put_super	= cramfs_put_super,
 	.remount_fs	= cramfs_remount,
 	.statfs		= cramfs_statfs,
@@ -531,16 +838,31 @@ static int cramfs_get_sb(struct file_sys
 static int cramfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
+	if ((strstr((char *)data, "iomem=")) ||
+	    (strstr((char *)data, "physaddr=")))
+		return get_sb_nodev(fs_type, flags, data, cramfs_fill_super,
+		    mnt);
+
 	return get_sb_bdev(fs_type, flags, dev_name, data, cramfs_fill_super,
-			   mnt);
+	    mnt);
+}
+
+void cramfs_kill_super(struct super_block *sb)
+{
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
+	if (LINEAR_CRAMFS(sbi)) {
+		kill_anon_super(sb);
+	} else {
+		kill_block_super(sb);
+	}
 }

 static struct file_system_type cramfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "cramfs",
 	.get_sb		= cramfs_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.kill_sb	= cramfs_kill_super,
 };

 static int __init init_cramfs_fs(void)
@@ -550,6 +872,7 @@ static int __init init_cramfs_fs(void)
 	rv = cramfs_uncompress_init();
 	if (rv < 0)
 		return rv;
+
 	rv = register_filesystem(&cramfs_fs_type);
 	if (rv < 0)
 		cramfs_uncompress_exit();
diff -r 5114d0f3b003 -r 83e92f97054c include/linux/cramfs_fs.h
--- a/include/linux/cramfs_fs.h	Tue Jun 05 11:37:21 2007 -0700
+++ b/include/linux/cramfs_fs.h	Wed Jun 06 03:27:31 2007 -0700
@@ -84,6 +84,16 @@ struct cramfs_super {
 				| CRAMFS_FLAG_WRONG_SIGNATURE \
 				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )

+#define LINEAR_CRAMFS(x) \
+(((x)->linear_phys_addr != 0) || ((x)->linear_virt_addr))
+#define CRAMFS_INODE_IS_XIP(x)	((x)->i_mode & S_ISVTX)
+
+#ifdef ioremap_cached
+#define CRAMFS_REMAP ioremap_cached
+#else
+#define CRAMFS_REMAP ioremap
+#endif
+
 /* Uncompression interfaces to the underlying zlib */
 int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
 int cramfs_uncompress_init(void);
diff -r 5114d0f3b003 -r 83e92f97054c include/linux/cramfs_fs_sb.h
--- a/include/linux/cramfs_fs_sb.h	Tue Jun 05 11:37:21 2007 -0700
+++ b/include/linux/cramfs_fs_sb.h	Wed Jun 06 03:27:31 2007 -0700
@@ -10,6 +10,8 @@ struct cramfs_sb_info {
 			unsigned long blocks;
 			unsigned long files;
 			unsigned long flags;
+			unsigned long linear_phys_addr;
+			void __iomem *linear_virt_addr;
 };

 static inline struct cramfs_sb_info *CRAMFS_SB(struct super_block *sb)
@@ -17,4 +19,16 @@ static inline struct cramfs_sb_info *CRA
 	return sb->s_fs_info;
 }

+#ifdef CONFIG_UML
+/* These are just to help the UML version build */
+static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
+{
+	return 0;
+}
+
+static inline void iounmap(volatile void __iomem *addr)
+{
+}
 #endif
+
+#endif
diff -r 5114d0f3b003 -r 83e92f97054c init/do_mounts.c
--- a/init/do_mounts.c	Tue Jun 05 11:37:21 2007 -0700
+++ b/init/do_mounts.c	Wed Jun 06 03:27:31 2007 -0700
@@ -343,6 +343,15 @@ static int __init mount_nfs_root(void)
 }
 #endif

+static int __init mount_cramfs_linear_root(void)
+{
+	create_dev("/dev/root", ROOT_DEV);
+	if (do_mount_root("/dev/root","cramfs",root_mountflags,
+	    root_mount_data) == 0)
+		return 1;
+	return 0;
+}
+
 #if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
 void __init change_floppy(char *fmt, ...)
 {
@@ -375,6 +384,11 @@ void __init change_floppy(char *fmt, ...

 void __init mount_root(void)
 {
+	if (ROOT_DEV == MKDEV(0, 0)) {
+		if (mount_cramfs_linear_root())
+			return;
+		printk (KERN_ERR "VFS: Unable to mount linear cramfs root.\n");
+	}
 #ifdef CONFIG_ROOT_NFS
 	if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
 		if (mount_nfs_root())
