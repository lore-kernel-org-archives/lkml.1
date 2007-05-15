Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbXEOUqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbXEOUqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXEOUqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:46:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbXEOUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:46:21 -0400
Date: Tue, 15 May 2007 13:37:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-Id: <20070515133759.9ee434a2.akpm@linux-foundation.org>
In-Reply-To: <20070515151919.GA32510@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 17:19:20 +0200
J__rn Engel <joern@lazybastard.org> wrote:

> Add LogFS, a scalable flash filesystem.
>
> ...
>
>  
> +config LOGFS
> +	tristate "Log Filesystem (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL
> +	select ZLIB_INFLATE
> +	select ZLIB_DEFLATE
> +	help
> +	  Flash filesystem aimed to scale efficiently to large devices.
> +	  In comparison to JFFS2 it offers significantly faster mount
> +	  times and potentially less RAM usage, although the latter has
> +	  not been measured yet.
> +
> +	  In its current state it is still very experimental and should
> +	  not be used for other than testing purposes.
> +
> +	  If unsure, say N.
> +
> +config LOGFS_FSCK
> +	bool "Run LogFS fsck at mount time"
> +	depends on LOGFS
> +	help
> +	  Run a full filesystem check on every mount.  If any errors are
> +	  found, mounting the filesystem will fail.  This is a debug option
> +	  for developers.
> +
> +	  If unsure, say N.
> +

No dependency on MTD,

> @@ -0,0 +1,373 @@
> +/*
> + * fs/logfs/logfs.h
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + *
> + * Private header for logfs.
> + */
> +#ifndef fs_logfs_logfs_h
> +#define fs_logfs_logfs_h
> +
> +#define __CHECK_ENDIAN__
> +
> +
> +#include <linux/crc32.h>
> +#include <linux/fs.h>
> +#include <linux/kallsyms.h>
> +#include <linux/kernel.h>
> +#include <linux/logfs.h>
> +#include <linux/pagemap.h>
> +#include <linux/statfs.h>
> +#include <linux/mtd/mtd.h>

But it includes an MTD header file.

Can this code be tested by people who don't have MTD hardware?  We used to
ahve a fake-mtd-on-a-blockdev thing, whcih was in a state of some
disrepair.  Maybe it got repaired.  Or removed.  I can't immediately locate
it...

It's strange and a bit regrettable that an fs would have dependency on MTD,
really.

> +
> +/**
> + * struct logfs_area - area management information
> + *
> + * @a_sb:			the superblock this area belongs to
> + * @a_is_open:			1 if the area is currently open, else 0
> + * @a_segno:			segment number of area
> + * @a_used_objects:		number of used objects (XXX: should get removed)
> + * @a_used_bytes:		number of used bytes
> + * @a_ops:			area operations (either journal or ostore)
> + * @a_wbuf:			write buffer
> + * @a_erase_count:		erase count
> + * @a_level:			GC level
> + */

ooh, documentation.  Quick, merge it!

> +/* memtree.c */
> +void btree_init(struct btree_head *head);
> +void *btree_lookup(struct btree_head *head, long val);
> +int btree_insert(struct btree_head *head, long val, void *ptr);
> +int btree_remove(struct btree_head *head, long val);

These names are too generic.  If we later add a btree library: blam.

> +
> +/* readwrite.c */
> +int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t _pos);
> +int logfs_inode_write(struct inode *inode, const void *buf, size_t n,
> +		loff_t pos);

It's a bit rude stealing the logfs* namespace, but I guess you got there
first ;)

> +int logfs_readpage_nolock(struct page *page);
> +int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf);
> +int logfs_delete(struct inode *inode, pgoff_t index);
> +int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level);
> +int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos);
> +void logfs_truncate(struct inode *inode);
> +u64 logfs_seek_data(struct inode *inode, u64 pos);
> +
> +int logfs_init_rw(struct logfs_super *super);
> +void logfs_cleanup_rw(struct logfs_super *super);
> +
> +/* segment.c */
> +int logfs_erase_segment(struct super_block *sb, u32 ofs);
> +int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf);
> +int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs);
> +s64 logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
> +		int alloc);
> +int logfs_segment_delete(struct inode *inode, u64 ofs, u64 pos, int level);
> +void logfs_set_blocks(struct inode *inode, u64 no);
> +void __logfs_set_blocks(struct inode *inode);
> +/* area handling */
> +int logfs_init_areas(struct super_block *sb);
> +void logfs_cleanup_areas(struct logfs_super *super);
> +int logfs_open_area(struct logfs_area *area);
> +void logfs_close_area(struct logfs_area *area);
> +
> +/* super.c */
> +int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> +int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> +int mtderase(struct super_block *sb, loff_t ofs, size_t len);
> +void logfs_crash_dump(struct super_block *sb);
> +int all_ff(void *buf, size_t len);
> +int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);

Have you checked that all of this needs global scope?

> +
> +/* progs/fsck.c */
> +#ifdef CONFIG_LOGFS_FSCK
> +int logfs_fsck(struct super_block *sb);
> +#else
> +#define logfs_fsck(sb) ({ 0; })

static inline int logfs_fsck(struct super_block *sb)
{
	return 0;
}

is better: nicer to look at, has typechecking.

> +#endif

> +
> +/* progs/mkfs.c */
> +int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds);
> +
> +
> +#define LOGFS_BUG(sb) do {		\
> +	struct super_block *__sb = sb;	\
> +	logfs_crash_dump(__sb);		\
> +	BUG();				\
> +} while(0)
> +
> +#define LOGFS_BUG_ON(condition, sb) \
> +	do { if (unlikely((condition)!=0)) LOGFS_BUG((sb)); } while(0)
> +
> +
> +static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
> +{
> +	return sb->s_fs_info;
> +}
> +
> +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> +{
> +	return container_of(inode, struct logfs_inode, vfs_inode);
> +}

Do these need to be uppercase?

> +
> +static inline __be32 logfs_crc32(void *data, size_t len, size_t skip)
> +{
> +	return cpu_to_be32(crc32(~0, data+skip, len-skip));
> +}
> +
> +
> +static inline u8 logfs_type(struct inode *inode)
> +{
> +	return (inode->i_mode >> 12) & 15;
> +}
> +
> +
> +static inline pgoff_t logfs_index(u64 pos)
> +{
> +	return pos / LOGFS_BLOCKSIZE;
> +}

If the compiler goofs up here we'll end up trying to do a 64/32 divide and
it won't link on 32-bit machines.  It would be safer to do

	return pos >> LOGFS_BLOCKSHIFT;


> --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> +++ linux-2.6.21logfs/fs/logfs/compr.c	2007-05-10 19:07:24.000000000 +0200
> @@ -0,0 +1,107 @@
> +/*
> + * fs/logfs/compr.c	- compression routines
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + */
> +#include "logfs.h"
> +#include <linux/vmalloc.h>
> +#include <linux/zlib.h>
> +
> +#define COMPR_LEVEL 3
> +
> +static DEFINE_MUTEX(compr_mutex);
> +static struct z_stream_s stream;
> +
> +
>
> ...
>
> +
> +int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen)
> +{
> +	int err, ret;
> +
> +	ret = -EIO;
> +	mutex_lock(&compr_mutex);

A per-superblock lock and stream would be nicer.

> +	err = zlib_inflateInit(&stream);
> +	if (err != Z_OK)
> +		goto error;
> +
> +	stream.next_in = in;
> +	stream.avail_in = inlen;
> +	stream.total_in = 0;
> +	stream.next_out = out;
> +	stream.avail_out = outlen;
> +	stream.total_out = 0;
> +
> +	err = zlib_inflate(&stream, Z_FINISH);
> +	if (err != Z_STREAM_END)
> +		goto error;
> +
> +	err = zlib_inflateEnd(&stream);
> +	if (err != Z_OK)
> +		goto error;
> +
> +	ret = 0;
> +error:
> +	mutex_unlock(&compr_mutex);
> +	return ret;
> +}
>
> ...
>
> --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> +++ linux-2.6.21logfs/fs/logfs/dir.c	2007-05-10 19:57:46.000000000 +0200
> @@ -0,0 +1,725 @@
> +}
> +
> +
> +static inline loff_t file_end(struct inode *inode)
> +{
> +	return (i_size_read(inode) + inode->i_sb->s_blocksize - 1)
> +		>> inode->i_sb->s_blocksize_bits;
> +}
> +static void logfs_set_name(struct logfs_disk_dentry *dd, struct qstr *name)
> +{

The code has a strange mix of two-blank-lines-between-functions and
no-blank-lines-between-functions.  One blank line is usual.


> +	BUG_ON(name->len > LOGFS_MAX_NAMELEN);
> +	dd->namelen = cpu_to_be16(name->len);
> +	memcpy(dd->name, name->name, name->len);
> +}
> +static int logfs_write_dir(struct inode *dir, struct dentry *dentry,
> +		struct inode *inode)
> +{
> +	struct logfs_disk_dentry dd;
> +	int err;
> +
> +	memset(&dd, 0, sizeof(dd));
> +	dd.ino = cpu_to_be64(inode->i_ino);
> +	dd.type = logfs_type(inode);
> +	logfs_set_name(&dd, &dentry->d_name);
> +
> +	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	/*
> +	 * FIXME: the file size should actually get aligned when writing,
> +	 * not when reading.
> +	 */
> +	err = write_dir(dir, &dd, file_end(dir));
> +	if (err)
> +		return err;
> +	d_instantiate(dentry, inode);
> +	return 0;
> +}
> +
> +
>
> ...
>
> +
> +	if (dest) {
> +		/* symlink */
> +		ret = logfs_inode_write(inode, dest, destlen, 0);
> +	} else {
> +		/* creat/mkdir/mknod */
> +		ret = __logfs_write_inode(inode);
> +	}
> +	super->s_victim_ino = 0;
> +	if (ret) {
> +		if (!dest)
> +			li->li_flags |= LOGFS_IF_STILLBORN;
> +		/* FIXME: truncate symlink */
> +		inode->i_nlink--;
> +		iput(inode);
> +		goto out;
> +	}
> +
> +	if (inode->i_mode & S_IFDIR)
> +		dir->i_nlink++;

You have helper functions for i_nlink++, which remember to do
mark_inode_dirty()?

> +	ret = logfs_write_dir(dir, dentry, inode);
> +
> +	if (ret) {
> +		if (inode->i_mode & S_IFDIR)
> +			dir->i_nlink--;
> +		logfs_remove_inode(inode);
> +		iput(inode);
> +	}
> +out:
> +	mutex_unlock(&super->s_victim_mutex);
> +	return ret;
> +}
> +
>
> ...
>
> +
> +static struct inode_operations logfs_symlink_iops = {
> +	.readlink	= generic_readlink,
> +	.follow_link	= page_follow_link_light,
> +};

Should be const.

> +static int logfs_permission(struct inode *inode, int mask, struct nameidata *nd)
> +{
> +	return generic_permission(inode, mask, NULL);
> +}

Does this need to exist?

> +
> +struct inode_operations logfs_dir_iops = {
> +	.create		= logfs_create,
> +	.link		= logfs_link,
> +	.lookup		= logfs_lookup,
> +	.mkdir		= logfs_mkdir,
> +	.mknod		= logfs_mknod,
> +	.rename		= logfs_rename,
> +	.rmdir		= logfs_rmdir,
> +	.permission	= logfs_permission,
> +	.symlink	= logfs_symlink,
> +	.unlink		= logfs_unlink,
> +};

const

> +struct file_operations logfs_dir_fops = {
> +	.readdir	= logfs_readdir,
> +	.read		= generic_read_dir,
> +};

const

> --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> +++ linux-2.6.21logfs/fs/logfs/file.c	2007-05-10 19:46:21.000000000 +0200
> @@ -0,0 +1,81 @@
> +/*
> + * fs/logfs/file.c	- prepare_write, commit_write and friends
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + */
> +#include "logfs.h"
> +
> +
> +static int logfs_prepare_write(struct file *file, struct page *page,
> +		unsigned start, unsigned end)
> +{
> +	if (PageUptodate(page))
> +		return 0;
> +
> +	if ((start == 0) && (end == PAGE_CACHE_SIZE))
> +		return 0;
> +
> +	return logfs_readpage_nolock(page);
> +}
> +
> +
> +static int logfs_commit_write(struct file *file, struct page *page,
> +		unsigned start, unsigned end)
> +{
> +	struct inode *inode = page->mapping->host;
> +	pgoff_t index = page->index;
> +	void *buf;
> +	int ret;
> +
> +	BUG_ON(PAGE_CACHE_SIZE != inode->i_sb->s_blocksize);

This check can be done once, at mount time.

> +	BUG_ON(page->index > I3_BLOCKS);
> +
> +	if (start == end)
> +		return 0; /* FIXME: do we need to update inode? */
> +
> +	if (i_size_read(inode) < (index << PAGE_CACHE_SHIFT) + end) {
> +		i_size_write(inode, (index << PAGE_CACHE_SHIFT) + end);
> +		mark_inode_dirty(inode);
> +	}
> +
> +	buf = kmap(page);
> +	ret = logfs_write_buf(inode, index, buf);
> +	kunmap(page);

kmap() is lame.  The preferred approach would be to pass the page* down to
the lower layers and to use kmap_atomic() at the lowest possible point.

> +	return ret;
> +}
> +
> +
> +static int logfs_readpage(struct file *file, struct page *page)
> +{
> +	int ret;
> +
> +	ret = logfs_readpage_nolock(page);
> +	unlock_page(page);
> +	return ret;
> +}
> +
> +
> +struct inode_operations logfs_reg_iops = {
> +	.truncate	= logfs_truncate,
> +};

const

> +
> +struct file_operations logfs_reg_fops = {
> +	.aio_read	= generic_file_aio_read,
> +	.aio_write	= generic_file_aio_write,
> +	.llseek		= generic_file_llseek,
> +	.mmap		= generic_file_readonly_mmap,
> +	.open		= generic_file_open,
> +	.read		= do_sync_read,
> +	.write		= do_sync_write,
> +};

const

> +
> +struct address_space_operations logfs_reg_aops = {
> +	.commit_write	= logfs_commit_write,
> +	.prepare_write	= logfs_prepare_write,
> +	.readpage	= logfs_readpage,
> +	.set_page_dirty	= __set_page_dirty_nobuffers,
> +};

const

> +/*
> + * cookie is set to 1 if we hand out a cached inode, 0 otherwise.
> + * this allows logfs_iput to do the right thing later
> + */
> +struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie)
> +{
> +	struct logfs_super *super = LOGFS_SUPER(sb);
> +	struct logfs_inode *li;
> +
> +	if (ino == LOGFS_INO_MASTER)
> +		return super->s_master_inode;
> +
> +	spin_lock(&inode_lock);
> +	list_for_each_entry(li, &super->s_freeing_list, li_freeing_list)
> +		if (li->vfs_inode.i_ino == ino) {
> +			spin_unlock(&inode_lock);
> +			*cookie = 1;
> +			return &li->vfs_inode;
> +		}
> +	spin_unlock(&inode_lock);
> +
> +	*cookie = 0;
> +	return __logfs_iget(sb, ino);
> +}

A filesystem playing with inode_lock: not good.  What's going on here?

As a minimum, the reasons for this should be clearly spelled out in code
comments, because this sticks out like a sore thumb.

> +
> +	li = kmem_cache_alloc(logfs_inode_cache, GFP_KERNEL);
> +	if (!li)
> +		return NULL;
> +	logfs_init_inode(&li->vfs_inode);
> +	return &li->vfs_inode;
> +}
> +
> +
> +struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino)
> +{
> +	struct inode *inode;
> +
> +	inode = logfs_alloc_inode(sb);
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
> +
> +	logfs_init_inode(inode);
> +	inode->i_mode = 0;
> +	inode->i_ino = ino;
> +	inode->i_sb = sb;
> +
> +	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
> +	 * to be nonstatic, alas. */
> +	{
> +		static const struct address_space_operations empty_aops;
> +		struct address_space * const mapping = &inode->i_data;
> +
> +		mapping->a_ops = &empty_aops;
> +		mapping->host = inode;
> +		mapping->flags = 0;
> +		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
> +		mapping->assoc_mapping = NULL;
> +		mapping->backing_dev_info = &default_backing_dev_info;
> +		inode->i_mapping = mapping;
> +	}
> +
> +	return inode;
> +}

This function would benefit from some comments.  What's it doing, and why
is it special?  I mean, new_inode() calls alloc_inode() anyway, so you're
unable to use new_inode().  The reader wonders why.


> +
> +/*
> + * We depend on the kernel to hand us proper time here.  If it has more
> + * nanoseconds than fit in a second, something's fishy.  Either the currently
> + * running kernel is confused or we read a wrong value.  The latter could be
> + * because whoever wrote the value messed up or we have undetected data
> + * corruption.
> + * Whatever the case, give a warning.
> + */
> +static struct timespec be64_to_timespec(__be64 betime)
> +{
> +	u64 time = be64_to_cpu(betime);
> +	struct timespec tsp;
> +
> +	tsp.tv_sec = time >> 32;
> +	tsp.tv_nsec = time & 0xffffffff;
> +	WARN_ON(tsp.tv_nsec > 999999999);
> +	return tsp;
> +}

Could use ns_to_timespec(be64_to_cpu(betime)) here.

Should use >= NSEC_PER_SEC here.

> +
> +static __be64 timespec_to_be64(struct timespec tsp)
> +{
> +	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
> +
> +	WARN_ON(tsp.tv_nsec > 999999999);
> +	return cpu_to_be64(time);
> +}

Dittos.

> +/* called with inode_lock held */
> +static void logfs_drop_inode(struct inode *inode)
> +{
> +	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
> +	struct logfs_inode *li = LOGFS_INODE(inode);
> +
> +	list_move(&li->li_freeing_list, &super->s_freeing_list);
> +	generic_drop_inode(inode);
> +}
> +
> +
> +static u64 logfs_get_ino(struct super_block *sb)
> +{
> +	struct logfs_super *super = LOGFS_SUPER(sb);
> +	u64 ino;
> +
> +	/*
> +	 * FIXME: ino allocation should work in two modes:
> +	 * o nonsparse - ifile is mostly occupied, just append
> +	 * o sparse - ifile has lots of holes, fill them up
> +	 *
> +	 * SEEK_HOLE would obviously help a lot here.
> +	 */
> +	spin_lock(&super->s_ino_lock);
> +	ino = super->s_last_ino;
> +	super->s_last_ino++;
> +	spin_unlock(&super->s_ino_lock);
> +	return ino;
> +}

Could use atomic64_add_return() here.

> +
> +struct inode *logfs_new_inode(struct inode *dir, int mode)
> +{
> +	struct super_block *sb = dir->i_sb;
> +	struct inode *inode;
> +
> +	inode = new_inode(sb);
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
> +
> +	logfs_init_inode(inode);
> +
> +	inode->i_mode = mode;
> +	inode->i_ino = logfs_get_ino(sb);
> +
> +	insert_inode_hash(inode);
> +
> +	return inode;
> +}
> +
> +
> +static void logfs_init_once(void *_li, struct kmem_cache *cachep,
> +		unsigned long flags)
> +{
> +	struct logfs_inode *li = _li;
> +	int i;
> +
> +	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
> +			SLAB_CTOR_CONSTRUCTOR) {

This won't compile in mainline (SLAB_CTOR_VERIFY has gone)

And it won't compile in -mm (SLAB_CTOR_CONSTRUCTOR has gone).

Just remove the test altogether.

> +		li->li_flags = 0;
> +		li->li_used_bytes = 0;
> +		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
> +			li->li_data[i] = 0;
> +		inode_init_once(&li->vfs_inode);
> +	}
> +
> +}
> +
> +
> +struct super_operations logfs_super_operations = {
> +	.alloc_inode	= logfs_alloc_inode,
> +	.delete_inode	= logfs_delete_inode,
> +	.destroy_inode	= logfs_destroy_inode,
> +	.drop_inode	= logfs_drop_inode,
> +	.read_inode	= logfs_read_inode,
> +	.write_inode	= logfs_write_inode,
> +	.statfs		= logfs_statfs,
> +};

const

> +
> +int logfs_init_inode_cache(void)
> +{
> +	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
> +			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
> +			logfs_init_once, NULL);

Use KMEM_CACHE() helper

> +	if (!logfs_inode_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +
> +void logfs_destroy_inode_cache(void)
> +{
> +	kmem_cache_destroy(logfs_inode_cache);
> +}

<attention span ran out, sorry>
