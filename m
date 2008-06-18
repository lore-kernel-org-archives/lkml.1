Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYFRL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYFRL1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYFRL1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:27:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYFRL1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:27:18 -0400
Date: Wed, 18 Jun 2008 07:27:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080618112717.GA23081@infradead.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define AZFS_FILESYSTEM_NAME		"azfs"
> +#define AZFS_FILESYSTEM_FLAGS		FS_REQUIRES_DEV
> +
> +#define AZFS_SUPERBLOCK_MAGIC		0xABBA1972
> +#define AZFS_SUPERBLOCK_FLAGS		MS_NOEXEC | \
> +					MS_SYNCHRONOUS | \
> +					MS_DIRSYNC | \
> +					MS_ACTIVE
> +
> +#define AZFS_BDI_CAPABILITIES		BDI_CAP_NO_ACCT_DIRTY | \
> +					BDI_CAP_NO_WRITEBACK | \
> +					BDI_CAP_MAP_COPY | \
> +					BDI_CAP_MAP_DIRECT | \
> +					BDI_CAP_VMFLAGS
> +
> +#define AZFS_CACHE_FLAGS		SLAB_HWCACHE_ALIGN | \
> +					SLAB_RECLAIM_ACCOUNT | \
> +					SLAB_MEM_SPREAD
> +
> +enum azfs_direction {
> +	AZFS_MMAP,
> +	AZFS_READ,
> +	AZFS_WRITE
> +};
> +
> +struct azfs_super {
> +	struct list_head		list;
> +	unsigned long			media_size;
> +	unsigned long			block_size;
> +	unsigned short			block_shift;
> +	unsigned long			sector_size;
> +	unsigned short			sector_shift;
> +	uid_t				uid;
> +	gid_t				gid;
> +	unsigned long			ph_addr;
> +	unsigned long			io_addr;
> +	struct block_device		*blkdev;
> +	struct dentry			*root;
> +	struct list_head		block_list;
> +	rwlock_t			lock;
> +};
> +
> +struct azfs_super_list {
> +	struct list_head		head;
> +	spinlock_t			lock;
> +};
> +
> +struct azfs_block {
> +	struct list_head		list;
> +	unsigned long			id;
> +	unsigned long			count;
> +};
> +
> +struct azfs_znode {
> +	struct list_head		block_list;
> +	rwlock_t			lock;
> +	loff_t				size;
> +	struct inode			vfs_inode;
> +};
> +
> +static struct azfs_super_list		super_list;
> +static struct kmem_cache		*azfs_znode_cache __read_mostly = NULL;
> +static struct kmem_cache		*azfs_block_cache __read_mostly = NULL;

> +static unsigned long
> +azfs_recherche(struct inode *inode, enum azfs_direction direction,
> +	       unsigned long from, unsigned long *size)
> +{
> +	struct azfs_super *super;
> +	struct azfs_znode *znode;
> +	struct azfs_block *block;
> +	unsigned long block_id, west, east;
> +
> +	super = inode->i_sb->s_fs_info;
> +	znode = I2Z(inode);
> +
> +	if (from + *size > znode->size) {
> +		i_size_write(inode, from + *size);
> +		inode->i_op->truncate(inode);
> +	}
> +
> +	read_lock(&znode->lock);
> +
> +	if (list_empty(&znode->block_list)) {
> +		read_unlock(&znode->lock);
> +		return 0;
> +	}
> +
> +	block_id = from >> super->block_shift;
> +
> +	for_each_block(block, &znode->block_list) {
> +		if (block->count > block_id)
> +			break;
> +		block_id -= block->count;
> +	}
> +
> +	west = from % super->block_size;
> +	east = ((block->count - block_id) << super->block_shift) - west;
> +
> +	if (*size > east)
> +		*size = east;
> +
> +	block_id = ((block->id + block_id) << super->block_shift) + west;
> +
> +	read_unlock(&znode->lock);
> +
> +	block_id += direction == AZFS_MMAP ? super->ph_addr : super->io_addr;
> +
> +	return block_id;
> +}

> +azfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
> +	      unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	void *ziel;
> +	unsigned long pin;
> +	unsigned long size, todo, step;
> +	ssize_t rc;
> +
> +	inode = iocb->ki_filp->f_mapping->host;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	if (pos >= i_size_read(inode)) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	ziel = iov->iov_base;
> +	todo = min((loff_t) iov->iov_len, i_size_read(inode) - pos);
> +
> +	for (step = todo; step; step -= size) {
> +		size = step;
> +		pin = azfs_recherche(inode, AZFS_READ, pos, &size);
> +		if (!pin) {
> +			rc = -ENOSPC;
> +			goto out;
> +		}
> +		if (copy_to_user(ziel, (void*) pin, size)) {
> +			rc = -EFAULT;
> +			goto out;
> +		}
> +
> +		iocb->ki_pos += size;
> +		pos += size;
> +		ziel += size;
> +	}
> +
> +	rc = todo;
> +
> +out:
> +	mutex_unlock(&inode->i_mutex);
> +
> +	return rc;
> +}
> +
> +/**
> + * azfs_aio_write - aio_write() method for file_operations
> + * @iocb, @iov, @nr_segs, @pos: see file_operations methods
> + */
> +static ssize_t
> +azfs_aio_write(struct kiocb *iocb, const struct iovec *iov,
> +	       unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	void *quell;
> +	unsigned long pin;
> +	unsigned long size, todo, step;
> +	ssize_t rc;
> +
> +	inode = iocb->ki_filp->f_mapping->host;
> +
> +	quell = iov->iov_base;
> +	todo = iov->iov_len;
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	for (step = todo; step; step -= size) {
> +		size = step;
> +		pin = azfs_recherche(inode, AZFS_WRITE, pos, &size);
> +		if (!pin) {
> +			rc = -ENOSPC;
> +			goto out;
> +		}
> +		if (copy_from_user((void*) pin, quell, size)) {
> +			rc = -EFAULT;
> +			goto out;
> +		}
> +
> +		iocb->ki_pos += size;
> +		pos += size;
> +		quell += size;
> +	}
> +
> +	rc = todo;
> +
> +out:
> +	mutex_unlock(&inode->i_mutex);
> +
> +	return rc;
> +}
> +
> +/**
> + * azfs_open - open() method for file_operations
> + * @inode, @file: see file_operations methods

> +static int
> +azfs_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode;
> +
> +	if (file->f_flags & O_TRUNC) {
> +		i_size_write(inode, 0);
> +		inode->i_op->truncate(inode);
> +	}
> +	if (file->f_flags & O_APPEND)
> +		inode->i_fop->llseek(file, 0, SEEK_END);
> +
> +	return 0;

truncate and seeking are done by the VFS, not need to do it.
Also no need to stuff the inode in file->private_data because
it's always available through file->f_path.dentry->inode.

> +/**
> + * azfs_alloc_inode - alloc_inode() method for super_operations
> + * @sb: see super_operations methods
> + */
> +static struct inode*
> +azfs_alloc_inode(struct super_block *sb)
> +{
> +	struct azfs_znode *znode;
> +
> +	znode = kmem_cache_alloc(azfs_znode_cache, GFP_KERNEL);
> +
> +	INIT_LIST_HEAD(&znode->block_list);
> +	rwlock_init(&znode->lock);

You need to check for an NULL pointer from kmem_cache_alloc
here.

> +/**
> + * azfs_delete_inode - delete_inode() method for super_operations
> + * @inode: see super_operations methods
> + */
> +static void
> +azfs_delete_inode(struct inode *inode)
> +{
> +	if (S_ISREG(inode->i_mode)) {
> +		i_size_write(inode, 0);
> +		azfs_truncate(inode);
> +	}
> +	truncate_inode_pages(&inode->i_data, 0);
> +	clear_inode(inode);
> +}

> +/**
> + * azfs_fill_super - fill_super routine for get_sb
> + * @sb, @data, @silent: see file_system_type methods
> + */
> +static int
> +azfs_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct gendisk *disk;
> +	struct azfs_super *super = NULL, *knoten;
> +	struct azfs_block *block = NULL;
> +	struct inode *inode = NULL;
> +	void *kaddr;
> +	unsigned long pfn;
> +	int rc;
> +
> +	BUG_ON(!sb->s_bdev);
> +
> +	disk = sb->s_bdev->bd_disk;
> +
> +	if (!disk || !disk->queue) {

This won't ever be zero, no need to check.

> +	if (!get_device(disk->driverfs_dev)) {
> +		printk(KERN_ERR "%s cannot get reference to device driver\n",
> +				AZFS_FILESYSTEM_NAME);
> +		return -EFAULT;
> +	}

You don't need another reference, the disk won't go away while the
block device is open.

> +	spin_lock(&super_list.lock);
> +	list_for_each_entry(knoten, &super_list.head, list)
> +		if (knoten->blkdev == sb->s_bdev) {
> +			super = knoten;
> +			break;
> +		}
> +	spin_unlock(&super_list.lock);

This can't happen.  get_sb_bdev already searches for the same superblock
already existing and doesn't even call into fill_super in that case.

> +
> +/**
> + * azfs_kill_sb - kill_sb() method for file_system_type
> + * @sb: see file_system_type methods
> + */
> +static void
> +azfs_kill_sb(struct super_block *sb)
> +{
> +	sb->s_root = NULL;

Very bad idea, if you set sb->s_root to zero before calling
generic_shutdown_super it will miss a lot of the taerdown activity.

> +	spin_lock(&super_list.lock);
> +	list_for_each_entry_safe(super, SUPER, &super_list.head, list) {
> +		disk = super->blkdev->bd_disk;
> +		list_del(&super->list);
> +		iounmap((void*) super->io_addr);
> +		write_lock(&super->lock);
> +		for_each_block_safe(block, knoten, &super->block_list)
> +			azfs_block_free(block);
> +		write_unlock(&super->lock);
> +		disk->driverfs_dev->driver_data = NULL;
> +		disk->driverfs_dev->platform_data = NULL;
> +		kfree(super);
> +		put_device(disk->driverfs_dev);

All this teardown should happen in ->put_super, and with this and
the above comment there should be need for a list of all superblocks.


