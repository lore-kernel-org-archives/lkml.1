Return-Path: <linux-kernel-owner+w=401wt.eu-S935821AbXFGTlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821AbXFGTlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762770AbXFGTlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:41:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbXFGTlC (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:41:02 -0400
Date: Thu, 7 Jun 2007 20:40:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070607194054.GC17144@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com> <20070607193707.GA17144@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607193707.GA17144@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:37:07PM +0100, Christoph Hellwig wrote:
> The code is at http://verein.lst.de/~hch/cramfs-xip.tar.gz.

And for thus just wanting to take a quick glance, this is the
diff vs an out of tree cramfs where uncompress.c and cramfs_fs_sb.h
are merged into inode.c:


--- ./inode.c	2007/06/07 11:52:32	1.1
+++ ./inode.c	2007/06/07 14:06:04
@@ -36,6 +36,7 @@
 	unsigned long blocks;
 	unsigned long files;
 	unsigned long flags;
+	void __iomem *linear_virt_addr;
 };
 
 static inline struct cramfs_sb_info *CRAMFS_SB(struct super_block *sb)
@@ -43,12 +44,20 @@
 	return sb->s_fs_info;
 }
 
+#define CRAMFS_INODE_IS_XIP(x) \
+	((x)->i_mode & S_ISVTX)
+
+static const struct file_operations cramfs_xip_fops;
 static const struct super_operations cramfs_ops;
 static const struct inode_operations cramfs_dir_inode_operations;
 static const struct file_operations cramfs_directory_operations;
 static const struct address_space_operations cramfs_aops;
+static const struct address_space_operations cramfs_xip_aops;
+
+static struct backing_dev_info cramfs_backing_dev_info = {
+	.ra_pages		= 0,	/* No readahead */
+};
 
-static DEFINE_MUTEX(read_mutex);
 static z_stream stream;
 
 
@@ -94,19 +103,31 @@
 	/* Struct copy intentional */
 	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
 	inode->i_ino = CRAMINO(cramfs_inode);
+
+	if (CRAMFS_INODE_IS_XIP(inode))
+		inode->i_mapping->backing_dev_info = &cramfs_backing_dev_info;
+
 	/* inode->i_nlink is left 1 - arguably wrong for directories,
 	   but it's the best we can do without reading the directory
            contents.  1 yields the right result in GNU find, even
 	   without -noleaf option. */
 	if (S_ISREG(inode->i_mode)) {
-		inode->i_fop = &generic_ro_fops;
-		inode->i_data.a_ops = &cramfs_aops;
+		if (CRAMFS_INODE_IS_XIP(inode)) {
+			inode->i_fop = &cramfs_xip_fops;
+			inode->i_data.a_ops = &cramfs_xip_aops;
+		} else { 
+			inode->i_fop = &generic_ro_fops;
+			inode->i_data.a_ops = &cramfs_aops;
+		}
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &cramfs_dir_inode_operations;
 		inode->i_fop = &cramfs_directory_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		inode->i_op = &page_symlink_inode_operations;
-		inode->i_data.a_ops = &cramfs_aops;
+		if (CRAMFS_INODE_IS_XIP(inode))
+			inode->i_data.a_ops = &cramfs_xip_aops;
+		else
+			inode->i_data.a_ops = &cramfs_aops;
 	} else {
 		inode->i_size = 0;
 		inode->i_blocks = 0;
@@ -122,42 +143,11 @@
 	struct inode *inode = iget5_locked(sb, CRAMINO(cramfs_inode),
 					    cramfs_iget5_test, cramfs_iget5_set,
 					    cramfs_inode);
-	if (inode && (inode->i_state & I_NEW)) {
+	if (inode && (inode->i_state & I_NEW))
 		unlock_new_inode(inode);
-	}
 	return inode;
 }
 
-/*
- * We have our own block cache: don't fill up the buffer cache
- * with the rom-image, because the way the filesystem is set
- * up the accesses should be fairly regular and cached in the
- * page cache and dentry tree anyway..
- *
- * This also acts as a way to guarantee contiguous areas of up to
- * BLKS_PER_BUF*PAGE_CACHE_SIZE, so that the caller doesn't need to
- * worry about end-of-buffer issues even when decompressing a full
- * page cache.
- */
-#define READ_BUFFERS (2)
-/* NEXT_BUFFER(): Loop over [0..(READ_BUFFERS-1)]. */
-#define NEXT_BUFFER(_ix) ((_ix) ^ 1)
-
-/*
- * BLKS_PER_BUF_SHIFT should be at least 2 to allow for "compressed"
- * data that takes up more space than the original and with unlucky
- * alignment.
- */
-#define BLKS_PER_BUF_SHIFT	(2)
-#define BLKS_PER_BUF		(1 << BLKS_PER_BUF_SHIFT)
-#define BUFFER_SIZE		(BLKS_PER_BUF*PAGE_CACHE_SIZE)
-
-static unsigned char read_buffers[READ_BUFFERS][BUFFER_SIZE];
-static unsigned buffer_blocknr[READ_BUFFERS];
-static struct super_block * buffer_dev[READ_BUFFERS];
-static int next_buffer;
-
-
 /* Returns length of decompressed data. */
 static int cramfs_uncompress_block(void *dst, int dstlen, void *src,
 		int srclen)
@@ -194,78 +184,11 @@
  */
 static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned int len)
 {
-	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
-	struct page *pages[BLKS_PER_BUF];
-	unsigned i, blocknr, buffer, unread;
-	unsigned long devsize;
-	char *data;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
 
 	if (!len)
 		return NULL;
-	blocknr = offset >> PAGE_CACHE_SHIFT;
-	offset &= PAGE_CACHE_SIZE - 1;
-
-	/* Check if an existing buffer already has the data.. */
-	for (i = 0; i < READ_BUFFERS; i++) {
-		unsigned int blk_offset;
-
-		if (buffer_dev[i] != sb)
-			continue;
-		if (blocknr < buffer_blocknr[i])
-			continue;
-		blk_offset = (blocknr - buffer_blocknr[i]) << PAGE_CACHE_SHIFT;
-		blk_offset += offset;
-		if (blk_offset + len > BUFFER_SIZE)
-			continue;
-		return read_buffers[i] + blk_offset;
-	}
-
-	devsize = mapping->host->i_size >> PAGE_CACHE_SHIFT;
-
-	/* Ok, read in BLKS_PER_BUF pages completely first. */
-	unread = 0;
-	for (i = 0; i < BLKS_PER_BUF; i++) {
-		struct page *page = NULL;
-
-		if (blocknr + i < devsize) {
-			page = read_mapping_page_async(mapping, blocknr + i,
-									NULL);
-			/* synchronous error? */
-			if (IS_ERR(page))
-				page = NULL;
-		}
-		pages[i] = page;
-	}
-
-	for (i = 0; i < BLKS_PER_BUF; i++) {
-		struct page *page = pages[i];
-		if (page) {
-			wait_on_page_locked(page);
-			if (!PageUptodate(page)) {
-				/* asynchronous error */
-				page_cache_release(page);
-				pages[i] = NULL;
-			}
-		}
-	}
-
-	buffer = next_buffer;
-	next_buffer = NEXT_BUFFER(buffer);
-	buffer_blocknr[buffer] = blocknr;
-	buffer_dev[buffer] = sb;
-
-	data = read_buffers[buffer];
-	for (i = 0; i < BLKS_PER_BUF; i++) {
-		struct page *page = pages[i];
-		if (page) {
-			memcpy(data, kmap(page), PAGE_CACHE_SIZE);
-			kunmap(page);
-			page_cache_release(page);
-		} else
-			memset(data, 0, PAGE_CACHE_SIZE);
-		data += PAGE_CACHE_SIZE;
-	}
-	return read_buffers[buffer] + offset;
+	return sbi->linear_virt_addr + offset;
 }
 
 static void cramfs_put_super(struct super_block *sb)
@@ -282,11 +205,12 @@
 
 static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 {
-	int i;
 	struct cramfs_super super;
 	unsigned long root_offset;
 	struct cramfs_sb_info *sbi;
 	struct inode *root;
+	unsigned long phys_addr;
+	char *p;
 
 	sb->s_flags |= MS_RDONLY;
 
@@ -295,38 +219,59 @@
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
 
-	/* Invalidate the read buffers on mount: think disk change.. */
-	mutex_lock(&read_mutex);
-	for (i = 0; i < READ_BUFFERS; i++)
-		buffer_blocknr[i] = -1;
+	p = strstr(data, "physaddr=");
+	if (!p)
+               goto out_kfree;
+
+	phys_addr = simple_strtoul(p + 9, NULL, 0);
+	if (phys_addr & (PAGE_SIZE-1)) {
+		printk(KERN_ERR "cramfs: physical address 0x%lx for linear"
+				"cramfs isn't aligned to a page boundary\n",
+				phys_addr);
+		goto out_kfree;
+	}
+
+	if (phys_addr == 0) {
+		printk(KERN_ERR "cramfs: physical address for linear cramfs"
+				"image can't be 0\n");
+		goto out_kfree;
+	}
+
+	printk(KERN_INFO "cramfs: checking physical address 0x%lx for linear"
+			 "cramfs image\n", phys_addr);
+
+	/* Map only one page for now.  Will remap it when fs size is known. */
+	sbi->linear_virt_addr = ioremap(phys_addr, PAGE_SIZE);
+	if (!sbi->linear_virt_addr) {
+		printk(KERN_ERR "cramfs: ioremap of the linear cramfs image"
+				"failed\n");
+		goto out_kfree;
+	}
 
 	/* Read the first block and get the superblock from it */
 	memcpy(&super, cramfs_read(sb, 0, sizeof(super)), sizeof(super));
-	mutex_unlock(&read_mutex);
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
 		/* check at 512 byte offset */
-		mutex_lock(&read_mutex);
 		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
-		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (!silent)
 				printk(KERN_ERR "cramfs: wrong magic\n");
-			goto out;
+			goto out_iounmap;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
 		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
-		goto out;
+		goto out_iounmap;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
 		printk(KERN_ERR "cramfs: root is not a directory\n");
-		goto out;
+		goto out_iounmap;
 	}
 	root_offset = super.root.offset << 2;
 	if (super.flags & CRAMFS_FLAG_FSID_VERSION_2) {
@@ -347,21 +292,34 @@
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
 		printk(KERN_ERR "cramfs: bad root offset %lu\n", root_offset);
-		goto out;
+		goto out_iounmap;
 	}
 
 	/* Set it all up.. */
 	sb->s_op = &cramfs_ops;
 	root = get_cramfs_inode(sb, &super.root);
 	if (!root)
-		goto out;
+		goto out_iounmap;
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		iput(root);
-		goto out;
+		goto out_iounmap;
 	}
+
+	/* Remap the whole filesystem now */
+	iounmap(sbi->linear_virt_addr);
+	sbi->linear_virt_addr = ioremap(phys_addr, sbi->size);
+	if (!sbi->linear_virt_addr) {
+		printk(KERN_ERR "cramfs: ioremap of the linear cramfs image"
+				" failed\n");
+		goto out_iounmap;
+	}
+
 	return 0;
-out:
+
+ out_iounmap:
+	iounmap(sbi->linear_virt_addr);
+ out_kfree:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	return -EINVAL;
@@ -382,6 +340,13 @@
 	return 0;
 }
 
+static int cramfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+		return -EINVAL;
+	return xip_file_mmap(file, vma);
+}
+
 /*
  * Read a cramfs directory entry.
  */
@@ -414,7 +379,6 @@
 		mode_t mode;
 		int namelen, error;
 
-		mutex_lock(&read_mutex);
 		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+256);
 		name = (char *)(de+1);
 
@@ -427,7 +391,6 @@
 		memcpy(buf, name, namelen);
 		ino = CRAMINO(de);
 		mode = de->mode;
-		mutex_unlock(&read_mutex);
 		nextoffset = offset + sizeof(*de) + namelen;
 		for (;;) {
 			if (!namelen) {
@@ -458,7 +421,6 @@
 	unsigned int offset = 0;
 	int sorted;
 
-	mutex_lock(&read_mutex);
 	sorted = CRAMFS_SB(dir->i_sb)->flags & CRAMFS_FLAG_SORTED_DIRS;
 	while (offset < dir->i_size) {
 		struct cramfs_inode *de;
@@ -481,7 +443,6 @@
 
 		for (;;) {
 			if (!namelen) {
-				mutex_unlock(&read_mutex);
 				return ERR_PTR(-EIO);
 			}
 			if (name[namelen-1])
@@ -495,7 +456,6 @@
 			continue;
 		if (!retval) {
 			struct cramfs_inode entry = *de;
-			mutex_unlock(&read_mutex);
 			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry));
 			return NULL;
 		}
@@ -503,7 +463,6 @@
 		if (sorted)
 			break;
 	}
-	mutex_unlock(&read_mutex);
 	d_add(dentry, NULL);
 	return NULL;
 }
@@ -522,23 +481,19 @@
 		u32 start_offset, compr_len;
 
 		start_offset = OFFSET(inode) + maxblock*4;
-		mutex_lock(&read_mutex);
 		if (page->index)
 			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
 		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
-		mutex_unlock(&read_mutex);
 		pgdata = kmap(page);
 		if (compr_len == 0)
 			; /* hole */
 		else if (compr_len > (PAGE_CACHE_SIZE << 1))
 			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
 		else {
-			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
 				 PAGE_CACHE_SIZE,
 				 cramfs_read(sb, start_offset, compr_len),
 				 compr_len);
-			mutex_unlock(&read_mutex);
 		}
 	} else
 		pgdata = kmap(page);
@@ -550,13 +505,34 @@
 	return 0;
 }
 
+static struct page *cramfs_get_xip_page(struct address_space *mapping,
+		sector_t offset, int create)
+{
+	struct inode *inode = mapping->host;
+	struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
+	unsigned long address;
+
+	address = PAGE_ALIGN((unsigned long)
+				(sbi->linear_virt_addr + OFFSET(inode)));
+
+	/* FIXME -- This shouldn't be hard coded */
+	address += (offset * 512);
+
+	return virt_to_page(address);
+}
+
 static const struct address_space_operations cramfs_aops = {
-	.readpage = cramfs_readpage
+	.readpage	= cramfs_readpage,
 };
 
-/*
- * Our operations:
- */
+static const struct address_space_operations cramfs_xip_aops = {
+	.get_xip_page	= cramfs_get_xip_page,
+};
+
+static const struct file_operations cramfs_xip_fops = {
+	.read		= xip_file_read,
+	.mmap		= cramfs_mmap,
+};
 
 /*
  * A directory can only readdir
@@ -580,16 +556,14 @@
 static int cramfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, cramfs_fill_super,
-			   mnt);
+	return get_sb_nodev(fs_type, flags, data, cramfs_fill_super, mnt);
 }
 
 static struct file_system_type cramfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "cramfs",
 	.get_sb		= cramfs_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.kill_sb	= kill_anon_super,
 };
 
 static int __init init_cramfs_fs(void)
