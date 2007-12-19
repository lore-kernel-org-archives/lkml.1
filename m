Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbXLSXor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbXLSXor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbXLSXog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:44:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52971 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXLSXod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:44:33 -0500
Date: Wed, 19 Dec 2007 17:43:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071219234352.GA20461@sergelap.austin.ibm.com>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> A brief description about SYAORAN:
> 
>  SYAORAN stands for "Simple Yet All-important Object Realizing Abiding
>  Nexus". SYAORAN is a filesystem for /dev with Mandatory Access Control.

I apologize if I'm commiting a faux pas by asking this, but any chance
of renaming this to something like strictdev or sdev, or at least with
'dev' in it somewhere?

Maybe the fs will sell like hotcakes and everyone will know what SYAORAN
means by next year, but just in case that doesn't happen, there is
absolutely nothing in the name that would tell me I should bother to
look at it...

>  /dev needs to be writable, but this means that files on /dev might be
>  tampered with. SYAORAN can restrict combinations of (pathname, attribute)
>  that the system can create. The attribute is one of directory, regular
>  file, FIFO, UNIX domain socket, symbolic link, character or block device
>  file with major/minor device numbers.
> 
>  SYAORAN can ensure /dev/null is a character device file with major=1 minor=3.
> 
>  Policy specifications for this filesystem is at
>  http://tomoyo.sourceforge.jp/en/1.5.x/policy-syaoran.html
> 
> Why not use FUSE?
> 
>  Because /dev has to be available through the lifetime of the kernel.
>  It is not acceptable if /dev stops working due to SIGKILL or OOM-killer.
> 
> Why not use SELinux?
> 
>  Because SELinux doesn't guarantee filename and its attribute.
>  The purpose of this filesystem is to ensure filename and its attribute
>  (e.g. /dev/null is guaranteed to be a character device file
>  with major=1 and minor=3).
> 
> Signed-off-by:  Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/syaoran/syaoran.c |  338 +++++++++++++++++
>  fs/syaoran/syaoran.h |  964 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 1302 insertions(+)
> 
> --- /dev/null
> +++ linux-2.6.24-rc5/fs/syaoran/syaoran.c
> @@ -0,0 +1,338 @@
> +/*
> + * fs/syaoran/syaoran.c
> + *
> + * Implementation of the Tamper-Proof Device Filesystem.
> + *
> + * Portions Copyright (C) 2005-2007  NTT DATA CORPORATION
> + *
> + * Version: 1.5.3-pre   2007/12/16
> + *
> + * This filesystem is developed using the ramfs implementation.
> + *
> + */
> +/*
> + * Resizable simple ram filesystem for Linux.
> + *
> + * Copyright (C) 2000 Linus Torvalds.
> + *               2000 Transmeta Corp.
> + *
> + * Usage limits added by David Gibson, Linuxcare Australia.
> + * This file is released under the GPL.
> + */
> +
> +/*
> + * NOTE! This filesystem is probably most useful
> + * not as a real filesystem, but as an example of
> + * how virtual filesystems can be written.
> + *
> + * It doesn't get much simpler than this. Consider
> + * that this file implements the full semantics of
> + * a POSIX-compliant read-write filesystem.
> + *
> + * Note in particular how the filesystem does not
> + * need to implement any data structures of its own
> + * to keep track of the virtual data: using the VFS
> + * caches is sufficient.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/pagemap.h>
> +#include <linux/highmem.h>
> +#include <linux/time.h>
> +#include <linux/init.h>
> +#include <linux/string.h>
> +#include <linux/backing-dev.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +
> +static struct super_operations syaoran_ops;
> +static struct address_space_operations syaoran_aops;
> +static struct inode_operations syaoran_file_inode_operations;
> +static struct inode_operations syaoran_dir_inode_operations;
> +static struct inode_operations syaoran_symlink_inode_operations;
> +static struct file_operations syaoran_file_operations;
> +
> +static struct backing_dev_info syaoran_backing_dev_info = {
> +	.ra_pages     = 0,        /* No readahead */
> +	.capabilities = BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK |
> +			BDI_CAP_MAP_DIRECT | BDI_CAP_MAP_COPY |
> +			BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP,
> +};
> +
> +#include "syaoran.h"
> +
> +static struct inode *syaoran_get_inode(struct super_block *sb, int mode,
> +				       dev_t dev)
> +{
> +	struct inode *inode = new_inode(sb);
> +
> +	if (inode) {
> +		struct timespec now = CURRENT_TIME;
> +		inode->i_mode = mode;
> +		inode->i_uid = current->fsuid;
> +		inode->i_gid = current->fsgid;
> +		inode->i_blocks = 0;
> +		inode->i_mapping->a_ops = &syaoran_aops;
> +		inode->i_mapping->backing_dev_info = &syaoran_backing_dev_info;
> +		inode->i_atime = now;
> +		inode->i_mtime = now;
> +		inode->i_ctime = now;
> +		switch (mode & S_IFMT) {
> +		default:
> +			init_special_inode(inode, mode, dev);
> +			if (S_ISBLK(mode))
> +				inode->i_fop = &wrapped_def_blk_fops;
> +			else if (S_ISCHR(mode))
> +				inode->i_fop = &wrapped_def_chr_fops;
> +			inode->i_op = &syaoran_file_inode_operations;
> +			break;
> +		case S_IFREG:
> +			inode->i_op = &syaoran_file_inode_operations;
> +			inode->i_fop = &syaoran_file_operations;
> +			break;
> +		case S_IFDIR:
> +			inode->i_op = &syaoran_dir_inode_operations;
> +			inode->i_fop = &simple_dir_operations;
> +			/*
> +			 * directory inodes start off with i_nlink == 2
> +			 *  (for "." entry)
> +			 */
> +			inode->i_nlink++;
> +			break;
> +		case S_IFLNK:
> +			inode->i_op = &syaoran_symlink_inode_operations;
> +			break;
> +		}
> +	}
> +	return inode;
> +}
> +
> +/*
> + * File creation. Allocate an inode, and we're done..
> + */
> +/* SMP-safe */
> +static int syaoran_mknod(struct inode *dir, struct dentry *dentry, int mode,
> +			 dev_t dev)
> +{
> +	struct inode *inode;
> +	int error = -ENOSPC;
> +	if (MayCreateNode(dentry, mode, dev) < 0)
> +		return -EPERM;
> +	inode = syaoran_get_inode(dir->i_sb, mode, dev);
> +	if (inode) {
> +		if (dir->i_mode & S_ISGID) {
> +			inode->i_gid = dir->i_gid;
> +			if (S_ISDIR(mode))
> +				inode->i_mode |= S_ISGID;
> +		}
> +		d_instantiate(dentry, inode);
> +		dget(dentry); /* Extra count - pin the dentry in core */
> +		error = 0;
> +	}
> +	return error;
> +}
> +
> +static int syaoran_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> +{
> +	int retval = syaoran_mknod(dir, dentry, mode | S_IFDIR, 0);
> +	if (!retval)
> +		dir->i_nlink++;
> +	return retval;
> +}
> +
> +static int syaoran_create(struct inode *dir, struct dentry *dentry, int mode,
> +			  struct nameidata *nd)
> +{
> +	return syaoran_mknod(dir, dentry, mode | S_IFREG, 0);
> +}
> +
> +static int syaoran_symlink(struct inode *dir, struct dentry *dentry,
> +			   const char *symname)
> +{
> +	struct inode *inode;
> +	int error = -ENOSPC;
> +	if (MayCreateNode(dentry, S_IFLNK, 0) < 0)
> +		return -EPERM;
> +	inode = syaoran_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
> +	if (inode) {
> +		int l = strlen(symname)+1;
> +		error = page_symlink(inode, symname, l);
> +		if (!error) {
> +			if (dir->i_mode & S_ISGID)
> +				inode->i_gid = dir->i_gid;
> +			d_instantiate(dentry, inode);
> +			dget(dentry);
> +		} else
> +			iput(inode);
> +	}
> +	return error;
> +}
> +
> +static int syaoran_link(struct dentry *old_dentry, struct inode *dir,
> +			struct dentry *dentry)
> +{
> +	struct inode *inode = old_dentry->d_inode;
> +	if (!inode || MayCreateNode(dentry, inode->i_mode, inode->i_rdev) < 0)
> +		return -EPERM;
> +	return simple_link(old_dentry, dir, dentry);
> +}
> +
> +static int syaoran_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	if (MayModifyNode(dentry, MAY_DELETE) < 0)
> +		return -EPERM;
> +	return simple_unlink(dir, dentry);
> +}
> +
> +static int syaoran_rename(struct inode *old_dir, struct dentry *old_dentry,
> +			  struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	struct inode *inode = old_dentry->d_inode;
> +	if (!inode || MayModifyNode(old_dentry, MAY_DELETE) < 0 ||
> +	    MayCreateNode(new_dentry, inode->i_mode, inode->i_rdev) < 0)
> +		return -EPERM;
> +	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
> +}
> +
> +static int syaoran_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	if (MayModifyNode(dentry, MAY_DELETE) < 0)
> +		return -EPERM;
> +	return simple_rmdir(dir, dentry);
> +}
> +
> +static int syaoran_setattr(struct dentry *dentry, struct iattr *attr)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	int error = inode_change_ok(inode, attr);
> +	if (!error) {
> +		unsigned int ia_valid = attr->ia_valid;
> +		unsigned int flags = 0;
> +		if (ia_valid & (ATTR_UID | ATTR_GID))
> +			flags |= MAY_CHOWN;
> +		if (ia_valid & ATTR_MODE)
> +			flags |= MAY_CHMOD;
> +		if (MayModifyNode(dentry, flags) < 0)
> +			return -EPERM;
> +		if (!error)
> +			error = inode_setattr(inode, attr);
> +	}
> +	return error;
> +}
> +
> +/*
> + * Copied from mm/page-writeback.c since
> + * __set_page_dirty_no_writeback() is not exported.
> + */
> +static int syaoran_set_page_dirty_no_writeback(struct page *page)
> +{
> +	if (!PageDirty(page))
> +		SetPageDirty(page);
> +	return 0;
> +}
> +
> +static struct address_space_operations syaoran_aops = {
> +	.readpage       = simple_readpage,
> +	.write_begin    = simple_write_begin,
> +	.write_end      = simple_write_end,
> +	.set_page_dirty = syaoran_set_page_dirty_no_writeback,
> +};
> +
> +static struct file_operations syaoran_file_operations = {
> +	.aio_read    = generic_file_aio_read,
> +	.read        = do_sync_read,
> +	.aio_write   = generic_file_aio_write,
> +	.write       = do_sync_write,
> +	.mmap        = generic_file_mmap,
> +	.fsync       = simple_sync_file,
> +	.splice_read = generic_file_splice_read,
> +	.llseek      = generic_file_llseek,
> +};
> +
> +static struct inode_operations syaoran_file_inode_operations = {
> +	.getattr    = simple_getattr,
> +	.setattr    = syaoran_setattr,
> +};
> +
> +static struct inode_operations syaoran_dir_inode_operations = {
> +	.create     = syaoran_create,
> +	.lookup     = simple_lookup,
> +	.link       = syaoran_link,
> +	.unlink     = syaoran_unlink,
> +	.symlink    = syaoran_symlink,
> +	.mkdir      = syaoran_mkdir,
> +	.rmdir      = syaoran_rmdir,
> +	.mknod      = syaoran_mknod,
> +	.rename     = syaoran_rename,
> +	.setattr    = syaoran_setattr,
> +};
> +
> +static struct inode_operations syaoran_symlink_inode_operations = {
> +	.readlink       = generic_readlink,
> +	.follow_link    = page_follow_link_light,
> +	.put_link       = page_put_link,
> +	.setattr        = syaoran_setattr,
> +};
> +
> +static struct super_operations syaoran_ops = {
> +	.statfs     = simple_statfs,
> +	.drop_inode = generic_delete_inode,
> +	.put_super  = syaoran_put_super,
> +};
> +
> +static int syaoran_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct inode *inode;
> +	struct dentry *root;
> +	int error;
> +
> +	sb->s_maxbytes = MAX_LFS_FILESIZE;
> +	sb->s_blocksize = PAGE_CACHE_SIZE;
> +	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
> +	sb->s_magic = SYAORAN_MAGIC;
> +	sb->s_op = &syaoran_ops;
> +	sb->s_time_gran = 1;
> +	error = Syaoran_Initialize(sb, data);
> +	if (error < 0)
> +		return error;
> +	inode = syaoran_get_inode(sb, S_IFDIR | 0755, 0);
> +	if (!inode)
> +		return -ENOMEM;
> +
> +	root = d_alloc_root(inode);
> +	if (!root) {
> +		iput(inode);
> +		return -ENOMEM;
> +	}
> +	sb->s_root = root;
> +	MakeInitialNodes(sb);
> +	return 0;
> +}
> +
> +static int syaoran_get_sb(struct file_system_type *fs_type,
> +	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +	return get_sb_nodev(fs_type, flags, data, syaoran_fill_super, mnt);
> +}
> +
> +static struct file_system_type syaoran_fs_type = {
> +	.owner      = THIS_MODULE,
> +	.name       = "syaoran",
> +	.get_sb     = syaoran_get_sb,
> +	.kill_sb    = kill_litter_super,
> +};
> +
> +static int __init init_syaoran_fs(void)
> +{
> +	return register_filesystem(&syaoran_fs_type);
> +}
> +
> +static void __exit exit_syaoran_fs(void)
> +{
> +	unregister_filesystem(&syaoran_fs_type);
> +}
> +module_init(init_syaoran_fs);
> +module_exit(exit_syaoran_fs);
> +
> +MODULE_LICENSE("GPL");
> --- /dev/null
> +++ linux-2.6.24-rc5/fs/syaoran/syaoran.h
> @@ -0,0 +1,964 @@
> +/*
> + * fs/syaoran/internal.h

That's not what the diff says it's called :)

Also much of this .h file could really stand to be in other
files like syaoran/read_config.c, syaoran/super.c, and
syaoran/debug.c.

> + *
> + * Implementation of the Tamper-Proof Device Filesystem.
> + *
> + * Copyright (C) 2005-2007  NTT DATA CORPORATION
> + *
> + * Version: 1.5.3-pre   2007/12/16
> + *
> + * A brief description about SYAORAN:
> + *
> + *  SYAORAN stands for "Simple Yet All-important Object Realizing Abiding
> + *  Nexus". SYAORAN is a filesystem for /dev with Mandatory Access Control.
> + *
> + *  /dev needs to be writable, but this means that files on /dev might be
> + *  tampered with. SYAORAN can restrict combinations of (pathname, attribute)
> + *  that the system can create. The attribute is one of directory, regular
> + *  file, FIFO, UNIX domain socket, symbolic link, character or block device
> + *  file with major/minor device numbers.
> + *
> + * Why not use FUSE?
> + *
> + *  Because /dev has to be available through the lifetime of the kernel.
> + *  It is not acceptable if /dev stops working due to SIGKILL or OOM-killer .
> + */
> +
> +#ifndef _LINUX_SYAORAN_H
> +#define _LINUX_SYAORAN_H
> +
> +#include <linux/namei.h>
> +#include <linux/mm.h>
> +
> +/***** SYAORAN start. *****/
> +
> +#define list_for_each_cookie(pos, cookie, head) \
> +	for ((cookie) || ((cookie) = (head)), pos = (cookie)->next; \
> +		prefetch(pos->next), pos != (head) || ((cookie) = NULL); \
> +		(cookie) = pos, pos = pos->next)
> +
> +/* The following constants are used to restrict operations.*/
> +
> +#define MAY_CREATE          1 /* This file is allowed to mknod()              */
> +#define MAY_DELETE          2 /* This file is allowed to unlink()             */
> +#define MAY_CHMOD           4 /* This file is allowed to chmod()              */
> +#define MAY_CHOWN           8 /* This file is allowed to chown()              */
> +#define DEVICE_USED        16 /* This block or character device file is used. */
> +#define NO_CREATE_AT_MOUNT 32 /* Don't create this file at mount().           */
> +
> +/* some random number */
> +#define SYAORAN_MAGIC    0x2F646576 /* = '/dev' */
> +
> +static void syaoran_put_super(struct super_block *sb);
> +static int Syaoran_Initialize(struct super_block *sb, void *data);
> +static void MakeInitialNodes(struct super_block *sb);
> +static int MayCreateNode(struct dentry *dentry, int mode, int dev);
> +static int MayModifyNode(struct dentry *dentry, unsigned int flags);
> +static int syaoran_create_tracelog(struct super_block *sb,
> +				   const char *filename);
> +
> +/* Wraps blkdev_open() to trace open operation for block devices. */
> +static int (*org_blkdev_open) (struct inode *inode, struct file *filp);
> +static struct file_operations wrapped_def_blk_fops;
> +
> +static int wrapped_blkdev_open(struct inode *inode, struct file *filp)
> +{
> +	int error = org_blkdev_open(inode, filp);
> +	if (error != -ENXIO)
> +		MayModifyNode(filp->f_dentry, DEVICE_USED);
> +	return error;
> +}
> +
> +/* Wraps chrdev_open() to trace open operation for character devices. */
> +static int (*org_chrdev_open) (struct inode *inode, struct file *filp);
> +static struct file_operations wrapped_def_chr_fops;
> +
> +static int wrapped_chrdev_open(struct inode *inode, struct file *filp)
> +{
> +	int error = org_chrdev_open(inode, filp);
> +	if (error != -ENXIO)
> +		MayModifyNode(filp->f_dentry, DEVICE_USED);
> +	return error;
> +}
> +
> +/* lookup_create() without nameidata. Called only while initialization. */
> +static struct dentry *lookup_create2(const char *name, struct dentry *base,
> +				     const bool is_dir)
> +{
> +	struct dentry *dentry;
> +	const int len = name ? strlen(name) : 0;
> +	mutex_lock(&base->d_inode->i_mutex);
> +	dentry = lookup_one_len(name, base, len);
> +	if (IS_ERR(dentry))
> +		goto fail;
> +	if (!is_dir && name[len] && !dentry->d_inode)
> +		goto enoent;
> +	return dentry;
> +enoent:
> +	dput(dentry);
> +	dentry = ERR_PTR(-ENOENT);
> +fail:
> +	return dentry;
> +}
> +
> +/* mkdir(). Called only while initialization. */
> +static int fs_mkdir(const char *pathname, struct dentry *base, int mode,
> +		    uid_t user, gid_t group)
> +{
> +	struct dentry *dentry = lookup_create2(pathname, base, 1);
> +	int error = PTR_ERR(dentry);
> +	if (!IS_ERR(dentry)) {
> +		error = vfs_mkdir(base->d_inode, dentry, mode);
> +		if (!error) {
> +			lock_kernel();

lock_kernel()?  Why is that necessary?

> +			dentry->d_inode->i_uid = user;
> +			dentry->d_inode->i_gid = group;
> +			unlock_kernel();
> +		}
> +		dput(dentry);
> +	}
> +	mutex_unlock(&base->d_inode->i_mutex);
> +	return error;
> +}
> +
> +/* mknod(). Called only while initialization. */
> +static int fs_mknod(const char *filename, struct dentry *base, int mode,
> +		    dev_t dev, uid_t user, gid_t group)
> +{
> +	struct dentry *dentry;
> +	int error;
> +	switch (mode & S_IFMT) {
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFIFO:
> +	case S_IFSOCK:
> +	case S_IFREG:
> +		break;
> +	default:
> +		return -EPERM;
> +	}
> +	dentry = lookup_create2(filename, base, 0);
> +	error = PTR_ERR(dentry);
> +	if (!IS_ERR(dentry)) {
> +		error = vfs_mknod(base->d_inode, dentry, mode, dev);
> +		if (!error) {
> +			lock_kernel();
> +			dentry->d_inode->i_uid = user;
> +			dentry->d_inode->i_gid = group;
> +			unlock_kernel();
> +		}
> +		dput(dentry);
> +	}
> +	mutex_unlock(&base->d_inode->i_mutex);
> +	return error;
> +}
> +
> +/* symlink(). Called only while initialization. */
> +static int fs_symlink(const char *pathname, struct dentry *base,
> +		      char *oldname, int mode, uid_t user, gid_t group)
> +{
> +	struct dentry *dentry = lookup_create2(pathname, base, 0);
> +	int error = PTR_ERR(dentry);
> +	if (!IS_ERR(dentry)) {
> +		error = vfs_symlink(base->d_inode, dentry, oldname, S_IALLUGO);
> +		if (!error) {
> +			lock_kernel();
> +			dentry->d_inode->i_mode = mode;
> +			dentry->d_inode->i_uid = user;
> +			dentry->d_inode->i_gid = group;
> +			unlock_kernel();
> +		}
> +		dput(dentry);
> +	}
> +	mutex_unlock(&base->d_inode->i_mutex);
> +	return error;
> +}
> +
> +/*
> + * Format string.
> + * Leading and trailing whitespaces are removed.
> + * Multiple whitespaces are packed into single space.
> + */
> +static void NormalizeLine(unsigned char *buffer)
> +{
> +	unsigned char *sp = buffer;
> +	unsigned char *dp = buffer;
> +	bool first = 1;
> +	while (*sp && (*sp <= ' ' || *sp >= 127))
> +		sp++;
> +	while (*sp) {
> +		if (!first)
> +			*dp++ = ' ';
> +		first = 0;
> +		while (*sp > ' ' && *sp < 127)
> +			*dp++ = *sp++;
> +		while (*sp && (*sp <= ' ' || *sp >= 127))
> +			sp++;
> +	}
> +	*dp = '\0';
> +}
> +
> +/* Convert text form of filename into binary form. */
> +static void UnEscape(char *filename)
> +{
> +	char *cp = filename;
> +	char c, d, e;
> +	if (!cp)
> +		return;
> +	while ((c = *filename++) != '\0') {
> +		if (c != '\\') {
> +			*cp++ = c;
> +			continue;
> +		}
> +		if ((c = *filename++) == '\\') {
> +			*cp++ = c;
> +			continue;
> +		}
> +		if (c < '0' || c > '3')
> +			break;
> +		d = *filename++;
> +		if (d < '0' || d > '7')
> +			break;
> +		e = *filename++;
> +		if (e < '0' || e > '7')
> +			break;
> +		*(unsigned char *) cp++ = (unsigned char)
> +			(((unsigned char) (c - '0') << 6) +
> +			 ((unsigned char) (d - '0') << 3) +
> +			 (unsigned char) (e - '0'));
> +	}
> +	*cp = '\0';
> +}
> +
> +struct dev_entry {
> +	struct list_head list;
> +	/* Binary form of pathname under mount point. Never NULL. */
> +	char *name;
> +	/*
> +	 * Mode and permissions. setuid/setgid/sticky bits are not supported.
> +	 */
> +	mode_t mode;
> +	uid_t uid;
> +	gid_t gid;
> +	dev_t kdev;
> +	/*
> +	 * Binary form of initial contents for the symlink.
> +	 *  NULL if not symlink.
> +	 */
> +	char *symlink_data;
> +	/* File access control flags. */
> +	unsigned int flags;
> +	/* Text form of pathname under mount point. Never NULL. */
> +	const char *printable_name;
> +	/*
> +	 * Text form of initial contents for the symlink.
> +	 * NULL if not symlink.
> +	 */
> +	const char *printable_symlink_data;
> +};
> +
> +struct syaoran_sb_info {
> +	struct list_head list;
> +	bool initialize_done;  /* False if initialization is in progress. */
> +	bool is_permissive_mode; /* True if permissive mode. */
> +};
> +
> +static inline char *strdup(const char *data)
> +{
> +	return kstrdup(data, GFP_KERNEL);
> +}
> +
> +static int RegisterNodeInfo(char *buffer, struct super_block *sb)
> +{
> +	enum {
> +		ARG_FILENAME     = 0,
> +		ARG_PERMISSION   = 1,
> +		ARG_UID          = 2,
> +		ARG_GID          = 3,
> +		ARG_FLAGS        = 4,
> +		ARG_DEV_TYPE     = 5,
> +		ARG_SYMLINK_DATA = 6,
> +		ARG_DEV_MAJOR    = 6,
> +		ARG_DEV_MINOR    = 7,
> +		MAX_ARG          = 8
> +	};
> +	char *args[MAX_ARG];
> +	int i;
> +	int error = -EINVAL;
> +	unsigned int perm, uid, gid, flags, major = 0, minor = 0;
> +	struct syaoran_sb_info *info = (struct syaoran_sb_info *) sb->s_fs_info;
> +	struct dev_entry *entry;
> +	memset(args, 0, sizeof(args));
> +	args[0] = buffer;
> +	for (i = 1; i < MAX_ARG; i++) {
> +		args[i] = strchr(args[i - 1] + 1, ' ');
> +		if (!args[i])
> +			break;
> +		*args[i]++ = '\0';
> +	}
> +	/*
> +	  printk("<%s> <%s> <%s> <%s> <%s> <%s> <%s> <%s>\n",
> +	  args[0], args[1], args[2], args[3], args[4], args[5],
> +	  args[6], args[7]);
> +	*/
> +	if (!args[ARG_FILENAME] || !args[ARG_PERMISSION] || !args[ARG_UID] ||
> +	    !args[ARG_GID] || !args[ARG_DEV_TYPE] || !args[ARG_FLAGS])
> +		goto out;
> +	if (sscanf(args[ARG_PERMISSION], "%o", &perm) != 1 || !(perm <= 0777)
> +	    || sscanf(args[ARG_UID], "%u", &uid) != 1
> +	    || sscanf(args[ARG_GID], "%u", &gid) != 1
> +	    || sscanf(args[ARG_FLAGS], "%u", &flags) != 1
> +	    || *(args[ARG_DEV_TYPE] + 1))
> +		goto out;
> +	switch (*args[ARG_DEV_TYPE]) {
> +	case 'c':
> +		perm |= S_IFCHR;
> +		if (!args[ARG_DEV_MAJOR]
> +		    || sscanf(args[ARG_DEV_MAJOR], "%u", &major) != 1
> +		    || !args[ARG_DEV_MINOR]
> +		    || sscanf(args[ARG_DEV_MINOR], "%u", &minor) != 1)
> +			goto out;
> +		break;
> +	case 'b':
> +		perm |= S_IFBLK;
> +		if (!args[ARG_DEV_MAJOR]
> +		    || sscanf(args[ARG_DEV_MAJOR], "%u", &major) != 1
> +		    || !args[ARG_DEV_MINOR]
> +		    || sscanf(args[ARG_DEV_MINOR], "%u", &minor) != 1)
> +			goto out;
> +		break;
> +	case 'l':
> +		perm |= S_IFLNK;
> +		if (!args[ARG_SYMLINK_DATA])
> +			goto out;
> +		break;
> +	case 'd':
> +		perm |= S_IFDIR;
> +		break;
> +	case 's':
> +		perm |= S_IFSOCK;
> +		break;
> +	case 'p':
> +		perm |= S_IFIFO;
> +		break;
> +	case 'f':
> +		perm |= S_IFREG;
> +		break;
> +	default:
> +		goto out;
> +	}
> +	error = -ENOMEM;
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		goto out;
> +	if (S_ISLNK(perm)) {
> +		entry->printable_symlink_data = strdup(args[ARG_SYMLINK_DATA]);
> +		if (!entry->printable_symlink_data)
> +			goto out_freemem;
> +	}
> +	entry->printable_name = strdup(args[ARG_FILENAME]);
> +	if (!entry->printable_name)
> +		goto out_freemem;
> +	if (S_ISLNK(perm)) {
> +		entry->symlink_data = strdup(entry->printable_symlink_data);
> +		if (!entry->symlink_data)
> +			goto out_freemem;
> +		UnEscape(entry->symlink_data);
> +	}
> +	entry->name = strdup(entry->printable_name);
> +	if (!entry->name)
> +		goto out_freemem;
> +	UnEscape(entry->name);
> +	/*
> +	 * Drop trailing '/', for GetLocalAbsolutePath() doesn't append
> +	 *  trailing '/'.
> +	 */
> +	i = strlen(entry->name);
> +	if (i && entry->name[i - 1] == '/')
> +		entry->name[i - 1] = '\0';
> +	entry->mode = perm;
> +	entry->uid = uid;
> +	entry->gid = gid;
> +	entry->kdev = S_ISCHR(perm) || S_ISBLK(perm) ? MKDEV(major, minor) : 0;
> +	entry->flags = flags;
> +	list_add_tail(&entry->list, &info->list);
> +	/* printk("Entry added.\n"); */
> +	error = 0;
> +out:
> +	return error;
> +out_freemem:
> +	kfree(entry->printable_symlink_data);
> +	kfree(entry->printable_name);
> +	kfree(entry->symlink_data);
> +	kfree(entry);
> +	goto out;
> +}
> +
> +static void syaoran_put_super(struct super_block *sb)
> +{
> +	struct syaoran_sb_info *info;
> +	struct dev_entry *entry;
> +	struct dev_entry *tmp;
> +	if (!sb)
> +		return;
> +	info = (struct syaoran_sb_info *) sb->s_fs_info;
> +	if (!info)
> +		return;
> +	list_for_each_entry_safe(entry, tmp, &info->list, list) {
> +		kfree(entry->name);
> +		kfree(entry->symlink_data);
> +		kfree(entry->printable_name);
> +		kfree(entry->printable_symlink_data);
> +		list_del(&entry->list);
> +		/* printk("Entry removed.\n"); */
> +		kfree(entry);
> +	}
> +	kfree(info);
> +	sb->s_fs_info = NULL;
> +	printk(KERN_DEBUG "%s: Unused memory freed.\n", __FUNCTION__);
> +}
> +
> +static int ReadConfigFile(struct file *file, struct super_block *sb)
> +{
> +	char *buffer;
> +	int error = -ENOMEM;
> +	if (!file)
> +		return -EINVAL;
> +	buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (buffer) {
> +		int len;
> +		char *cp;
> +		unsigned long offset = 0;
> +		while ((len = kernel_read(file, offset, buffer, PAGE_SIZE)) > 0
> +		       && (cp = memchr(buffer, '\n', len)) != NULL) {
> +			*cp = '\0';
> +			offset += cp - buffer + 1;
> +			NormalizeLine(buffer);
> +			if (RegisterNodeInfo(buffer, sb) == -ENOMEM)
> +				goto out;
> +		}
> +		error = 0;
> +	}
> +out:
> +	kfree(buffer);
> +	return error;
> +}
> +
> +static void MakeNode(struct dev_entry *entry, struct dentry *root)
> +{
> +	struct dentry *base = dget(root);
> +	char *filename = entry->name;
> +	char *name = filename;
> +	unsigned int c;
> +	const mode_t perm = entry->mode;
> +	const uid_t uid = entry->uid;
> +	const gid_t gid = entry->gid;
> +	goto start;
> +	while ((c = *(unsigned char *) filename) != '\0') {
> +		if (c == '/') {
> +			struct dentry *new_base;
> +			const int len = filename - name;
> +			*filename = '\0';
> +			mutex_lock(&base->d_inode->i_mutex);
> +			new_base = lookup_one_len(name, base, len);
> +			mutex_unlock(&base->d_inode->i_mutex);
> +			dput(base);
> +			*filename = '/';
> +			filename++;
> +			if (IS_ERR(new_base))
> +				return;
> +			if (!new_base->d_inode ||
> +			    !S_ISDIR(new_base->d_inode->i_mode)) {
> +				dput(new_base);
> +				return;
> +			}
> +			base = new_base;
> +start:
> +			name = filename;
> +		} else {
> +			filename++;
> +		}
> +	}
> +	filename = (char *) name;
> +	if (S_ISLNK(perm)) {
> +		fs_symlink(filename, base, entry->symlink_data, perm, uid, gid);
> +	} else if (S_ISDIR(perm)) {
> +		fs_mkdir(filename, base, perm ^ S_IFDIR, uid, gid);
> +	} else if (S_ISSOCK(perm) || S_ISFIFO(perm) || S_ISREG(perm)) {
> +		fs_mknod(filename, base, perm, 0, uid, gid);
> +	} else if (S_ISCHR(perm) || S_ISBLK(perm)) {
> +		fs_mknod(filename, base, perm, entry->kdev, uid, gid);
> +	}
> +	dput(base);
> +}
> +
> +/* Create files according to the policy file. */
> +static void MakeInitialNodes(struct super_block *sb)
> +{
> +	struct syaoran_sb_info *info;
> +	struct dev_entry *entry;
> +	if (!sb)
> +		return;
> +	info = (struct syaoran_sb_info *) sb->s_fs_info;
> +	if (!info)
> +		return;
> +	if (info->is_permissive_mode) {
> +		syaoran_create_tracelog(sb, ".syaoran");
> +		syaoran_create_tracelog(sb, ".syaoran_all");
> +	}
> +	list_for_each_entry(entry, &info->list, list) {
> +		if ((entry->flags & NO_CREATE_AT_MOUNT) == 0)
> +			MakeNode(entry, sb->s_root);
> +	}
> +	info->initialize_done = 1;
> +}
> +
> +/* Read policy file. */
> +static int Syaoran_Initialize(struct super_block *sb, void *data)
> +{
> +	int error = -EINVAL;
> +	static bool first = 1;
> +	if (first) {
> +		first = 0;
> +		printk(KERN_INFO "SYAORAN: 1.5.3-pre   2007/12/16\n");
> +	}

This fn should probably be split into several smaller functions...

> +	{
> +		struct inode *inode = new_inode(sb);
> +		if (!inode)
> +			return -EINVAL;
> +		/* Create /dev/ram0 to get the value of blkdev_open(). */

Since you're submitting your code for inclusion, this shouldn't be
necessary.  If you need a pointer to blkdev_open and chrdev_open, then
get the actual values from fs/char_dev.c and fs/block_dev.c.

> +		init_special_inode(inode, S_IFBLK | 0666, MKDEV(1, 0));
> +		wrapped_def_blk_fops = *inode->i_fop;
> +		iput(inode);
> +		org_blkdev_open = wrapped_def_blk_fops.open;
> +		wrapped_def_blk_fops.open = wrapped_blkdev_open;
> +	}
> +	{
> +		struct inode *inode = new_inode(sb);
> +		if (!inode)
> +			return -EINVAL;
> +		/* Create /dev/null to get the value of chrdev_open(). */
> +		init_special_inode(inode, S_IFCHR | 0666, MKDEV(1, 3));
> +		wrapped_def_chr_fops = *inode->i_fop;
> +		iput(inode);
> +		org_chrdev_open = wrapped_def_chr_fops.open;
> +		wrapped_def_chr_fops.open = wrapped_chrdev_open;
> +	}
> +	if (data) {

Passing a filename as a mount option and having the kernel parse
that as a config file is probably not acceptable.

Any reason not to create /dev/config, /dev/enforce, and /dev/start
files, so early userspace can just mount this fs, cat policy >
/dev/config, echo 1 > /dev/enforce cat 1 > /dev/start, and then your
fs starts enforcing?

> +		struct file *f;
> +		char *filename = (char *) data;
> +		bool is_permissive_mode = 0;
> +		if (strncmp(filename, "accept=", 7) == 0) {
> +			filename += 7;
> +			is_permissive_mode = 1;
> +		} else if (strncmp(filename, "enforce=", 8) == 0) {
> +			filename += 8;
> +			is_permissive_mode = 0;
> +		} else {
> +			printk(KERN_INFO
> +			       "SYAORAN: Missing 'accept=' or 'enforce='.\n");
> +			return -EINVAL;
> +		}
> +		f = filp_open(filename, O_RDONLY, 0600);
> +		if (!IS_ERR(f)) {
> +			struct syaoran_sb_info *p;
> +			if (!S_ISREG(f->f_dentry->d_inode->i_mode))
> +				goto out;
> +			p = kzalloc(sizeof(*p), GFP_KERNEL);
> +			if (!p)
> +				goto out;
> +			p->is_permissive_mode = is_permissive_mode;
> +			sb->s_fs_info = p;
> +			INIT_LIST_HEAD(&((struct syaoran_sb_info *)
> +					 sb->s_fs_info)->list);
> +			printk(KERN_INFO "SYAORAN: Reading '%s'\n", filename);
> +			error = ReadConfigFile(f, sb);
> +out:
> +			if (error)
> +				printk(KERN_INFO "SYAORAN: Can't read '%s'\n",
> +				       filename);
> +			filp_close(f, NULL);
> +		} else {
> +			printk(KERN_INFO "SYAORAN: Can't open '%s'\n",
> +			       filename);
> +		}
> +	} else {
> +		printk(KERN_INFO "SYAORAN: Missing config-file path.\n");
> +	}
> +	return error;
> +}
> +
> +/* Get absolute pathname from mount point. */
> +static int GetLocalAbsolutePath(struct dentry *dentry, char *buffer, int buflen)
> +{
> +	char *start = buffer;
> +	char *end = buffer + buflen;
> +	int namelen;
> +
> +	if (buflen < 256)
> +		goto out;
> +
> +	*--end = '\0';
> +	buflen--;
> +	for (;;) {
> +		struct dentry *parent;
> +		if (IS_ROOT(dentry))
> +			break;
> +		parent = dentry->d_parent;
> +		namelen = dentry->d_name.len;
> +		buflen -= namelen + 1;
> +		if (buflen < 0)
> +			goto out;
> +		end -= namelen;
> +		memcpy(end, dentry->d_name.name, namelen);
> +		*--end = '/';
> +		dentry = parent;
> +	}
> +	if (*end == '/') {
> +		buflen++;
> +		end++;
> +	}
> +	namelen = dentry->d_name.len;
> +	buflen -= namelen;
> +	if (buflen < 0)
> +		goto out;
> +	end -= namelen;
> +	memcpy(end, dentry->d_name.name, namelen);
> +	memmove(start, end, strlen(end) + 1);
> +	return 0;
> +out:
> +	return -ENOMEM;
> +}
> +
> +/* Get absolute pathname of the given dentry from mount point. */
> +static int local_realpath_from_dentry(struct dentry *dentry, char *newname,
> +				      int newname_len)
> +{
> +	int error;
> +	struct dentry *d_dentry;
> +	if (!dentry || !newname || newname_len <= 0)
> +		return -EINVAL;
> +	d_dentry = dget(dentry);
> +	/***** CRITICAL SECTION START *****/
> +	spin_lock(&dcache_lock);
> +	error = GetLocalAbsolutePath(d_dentry, newname, newname_len);
> +	spin_unlock(&dcache_lock);
> +	/***** CRITICAL SECTION END *****/
> +	dput(d_dentry);
> +	return error;
> +}
> +
> +static int CheckFlags(struct syaoran_sb_info *info, struct dentry *dentry,
> +		      int mode, int dev, unsigned int flags)
> +{

This reaally could be made much more readable...

> +	int error = -EPERM;
> +	/*
> +	 * I use static buffer, for local_realpath_from_dentry() needs
> +	 * dcache_lock.
> +	 */
> +	static char filename[PAGE_SIZE];
> +	static DEFINE_SPINLOCK(lock);
> +	spin_lock(&lock);
> +	memset(filename, 0, sizeof(filename));
> +	if (local_realpath_from_dentry(dentry, filename, sizeof(filename) - 1)
> +	    == 0) {

	Since the fn name doesn't help one has to follow several
	functions to make sure that ==0 in fact means there was
	no error copying the name...

> +		struct dev_entry *entry;
> +		list_for_each_entry(entry, &info->list, list) {

	walking through a list of info for devices which are allowed to exist,
	attached to the sb?  How about a helper fn?

> +			if ((mode & S_IFMT) != (entry->mode & S_IFMT))
> +				continue;
> +			if ((S_ISBLK(mode) || S_ISCHR(mode)) &&
> +			    dev != entry->kdev)
> +				continue;
> +			if (strcmp(entry->name, filename + 1))
> +				continue;
> +			if (info->is_permissive_mode) {
> +				entry->flags |= flags;
> +				error = 0;
> +			} else {
> +				if ((entry->flags & flags) == flags)
> +					error = 0;
> +			}
> +			break;
> +		}
> +	}
> +	if (error && strlen(filename) < (sizeof(filename) / 4) - 16) {

	Seems like this whole block should be a separate error/debug
	helper function...

> +		const char *name;
> +		const uid_t uid = current->fsuid;
> +		const gid_t gid = current->fsgid;
> +		const mode_t perm = mode & 0777;
> +		flags &= ~DEVICE_USED;
> +		{
> +			char *end = filename + sizeof(filename) - 1;
> +			const char *cp = strchr(filename, '\0') - 1;
> +			while (cp > filename) {
> +				const unsigned char c = *cp--;
> +				if (c == '\\') {
> +					*--end = '\\';
> +					*--end = '\\';
> +				} else if (c > ' ' && c < 127) {
> +					*--end = c;
> +				} else {
> +					*--end = (c & 7) + '0';
> +					*--end = ((c >> 3) & 7) + '0';
> +					*--end = (c >> 6) + '0';
> +					*--end = '\\';
> +				}
> +			}
> +			name = end;
> +		}
> +		switch (mode & S_IFMT) {
> +		case S_IFCHR:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c %3u %3u\n",
> +			       name, perm, uid, gid, flags, 'c',
> +			       MAJOR(dev), MINOR(dev));
> +			break;
> +		case S_IFBLK:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c %3u %3u\n",
> +			       name, perm, uid, gid, flags, 'b',
> +			       MAJOR(dev), MINOR(dev));
> +			break;
> +		case S_IFIFO:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c\n",
> +			       name, perm, uid, gid, flags, 'p');
> +			break;
> +		case S_IFSOCK:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c\n",
> +			       name, perm, uid, gid, flags, 's');
> +			break;
> +		case S_IFDIR:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c\n",
> +			       name, perm, uid, gid, flags, 'd');
> +			break;
> +		case S_IFLNK:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c %s\n",
> +			       name, perm, uid, gid, flags, 'l', "unknown");
> +			break;
> +		case S_IFREG:
> +			printk(KERN_DEBUG
> +			       "SYAORAN-ERROR: %s %3o %3u %3u %2u %c\n",
> +			       name, perm, uid, gid, flags, 'f');
> +			break;
> +		}
> +	}
> +	spin_unlock(&lock);
> +	return error;
> +}
> +
> +/* Check whether the given dentry is allowed to mknod. */
> +static int MayCreateNode(struct dentry *dentry, int mode, int dev)
> +{
> +	struct syaoran_sb_info *info =
> +		(struct syaoran_sb_info *) dentry->d_sb->s_fs_info;
> +	if (!info) {
> +		printk(KERN_DEBUG "%s: dentry->d_sb->s_fs_info == NULL\n",
> +		       __FUNCTION__);
> +		return -EPERM;
> +	}
> +	if (!info->initialize_done)
> +		return 0;
> +	return CheckFlags(info, dentry, mode, dev, MAY_CREATE);
> +}
> +
> +/* Check whether the given dentry is allowed to chmod/chown/unlink. */
> +static int MayModifyNode(struct dentry *dentry, unsigned int flags)
> +{
> +	struct syaoran_sb_info *info =
> +		(struct syaoran_sb_info *) dentry->d_sb->s_fs_info;
> +	if (!info) {
> +		printk(KERN_DEBUG "%s: dentry->d_sb->s_fs_info == NULL\n",
> +		       __FUNCTION__);
> +		return -EPERM;
> +	}
> +	if (flags == DEVICE_USED && !info->is_permissive_mode)
> +		return 0;
> +	if (!dentry->d_inode)
> +		return -ENOENT;
> +	return CheckFlags(info, dentry, dentry->d_inode->i_mode,
> +			  dentry->d_inode->i_rdev, flags);
> +}
> +
> +/*
> + * The following structure and codes are used for transferring data
> + * to interfaces files.

And should probably be in a separate file.

> + */
> +
> +struct syaoran_read_struct {
> +	char *buf;               /* Buffer for reading.                */
> +	int avail;               /* Bytes available for reading.       */
> +	struct super_block *sb;  /* The super_block of this partition. */
> +	struct dev_entry *entry; /* The entry currently reading from.  */
> +	_Bool read_all;          /* Dump all entries?                  */
> +	struct list_head *pos;   /* Current position.                  */
> +};
> +
> +static void ReadTable(struct syaoran_read_struct *head, char *buf, int count)
> +{
> +	struct super_block *sb = head->sb;
> +	struct syaoran_sb_info *info =
> +		(struct syaoran_sb_info *) sb->s_fs_info;
> +	struct list_head *pos;
> +	const _Bool read_all = head->read_all;
> +	if (!info)
> +		return;
> +	if (!head->pos)
> +		return;
> +	list_for_each_cookie(pos, head->pos, &info->list) {
> +		struct dev_entry *entry =
> +			list_entry(pos, struct dev_entry, list);
> +		const unsigned int flags =
> +			read_all ? entry->flags : entry->flags & ~DEVICE_USED;
> +		const char *name = entry->printable_name;
> +		const uid_t uid = entry->uid;
> +		const gid_t gid = entry->gid;
> +		const mode_t perm = entry->mode & 0777;
> +		int len = 0;
> +		switch (entry->mode & S_IFMT) {
> +		case S_IFCHR:
> +			if (!head->read_all && !(entry->flags & DEVICE_USED))
> +				break;
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c %3u %3u\n",
> +				       name, perm, uid, gid, flags, 'c',
> +				       MAJOR(entry->kdev), MINOR(entry->kdev));
> +			break;
> +		case S_IFBLK:
> +			if (!head->read_all && !(entry->flags & DEVICE_USED))
> +				break;
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c %3u %3u\n",
> +				       name, perm, uid, gid, flags, 'b',
> +				       MAJOR(entry->kdev), MINOR(entry->kdev));
> +			break;
> +		case S_IFIFO:
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c\n",
> +				       name, perm, uid, gid, flags, 'p');
> +			break;
> +		case S_IFSOCK:
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c\n",
> +				       name, perm, uid, gid, flags, 's');
> +			break;
> +		case S_IFDIR:
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c\n",
> +				       name, perm, uid, gid, flags, 'd');
> +			break;
> +		case S_IFLNK:
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c %s\n",
> +				       name, perm, uid, gid, flags, 'l',
> +				       entry->printable_symlink_data);
> +			break;
> +		case S_IFREG:
> +			len = snprintf(buf, count,
> +				       "%-20s %3o %3u %3u %2u %c\n",
> +				       name, perm, uid, gid, flags, 'f');
> +			break;
> +		}
> +		if (len < 0 || count <= len)
> +			break;
> +		count -= len;
> +		buf += len;
> +		head->avail += len;
> +	}
> +}
> +
> +static int syaoran_trace_open(struct inode *inode, struct file *file)
> +{
> +	struct syaoran_read_struct *head =
> +		kzalloc(sizeof(*head), GFP_KERNEL);
> +	if (!head)
> +		return -ENOMEM;
> +	head->sb = inode->i_sb;
> +	head->read_all =
> +		(strcmp(file->f_dentry->d_name.name, ".syaoran_all") == 0);
> +	head->pos = &((struct syaoran_sb_info *) head->sb->s_fs_info)->list;
> +	head->buf = kzalloc(PAGE_SIZE * 2, GFP_KERNEL);
> +	if (!head->buf) {
> +		kfree(head);
> +		return -ENOMEM;
> +	}
> +	file->private_data = head;
> +	return 0;
> +}
> +
> +static int syaoran_trace_release(struct inode *inode, struct file *file)
> +{
> +	struct syaoran_read_struct *head = file->private_data;
> +	kfree(head->buf);
> +	kfree(head);
> +	file->private_data = NULL;
> +	return 0;
> +}
> +
> +static ssize_t syaoran_trace_read(struct file *file, char __user *buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct syaoran_read_struct *head =
> +		(struct syaoran_read_struct *) file->private_data;
> +	int len = head->avail;
> +	char *cp = head->buf;
> +	if (!access_ok(VERIFY_WRITE, buf, count))
> +		return -EFAULT;
> +	ReadTable(head, cp + len, PAGE_SIZE * 2 - len);
> +	len = head->avail;
> +	if (len > count)
> +		len = count;
> +	if (len > 0) {
> +		if (copy_to_user(buf, cp, len))
> +			return -EFAULT;
> +		head->avail -= len;
> +		memmove(cp, cp + len, head->avail);
> +	}
> +	return len;
> +}
> +
> +static struct file_operations syaoran_trace_operations = {
> +	.open    = syaoran_trace_open,
> +	.release = syaoran_trace_release,
> +	.read    = syaoran_trace_read,
> +};
> +
> +/* Create interface files for reading status. */
> +static int syaoran_create_tracelog(struct super_block *sb,
> +				   const char *filename)
> +{
> +	struct dentry *base = dget(sb->s_root);
> +	struct dentry *dentry = lookup_create2(filename, base, 0);
> +	int error = PTR_ERR(dentry);
> +	if (!IS_ERR(dentry)) {
> +		struct inode *inode = new_inode(sb);
> +		if (inode) {
> +			struct timespec now = CURRENT_TIME;
> +			inode->i_mode = S_IFREG | 0400;
> +			inode->i_uid = 0;
> +			inode->i_gid = 0;
> +			inode->i_blocks = 0;
> +			inode->i_mapping->a_ops = &syaoran_aops;
> +			inode->i_mapping->backing_dev_info =
> +				&syaoran_backing_dev_info;
> +			inode->i_op = &syaoran_file_inode_operations;
> +			inode->i_atime = now;
> +			inode->i_mtime = now;
> +			inode->i_ctime = now;
> +			inode->i_fop = &syaoran_trace_operations;
> +			d_instantiate(dentry, inode);
> +			dget(dentry); /* Extra count - pin the dentry in core */
> +			error = 0;
> +		}
> +		dput(dentry);
> +	}
> +	mutex_unlock(&base->d_inode->i_mutex);
> +	dput(base);
> +	return error;
> +}
> +
> +/***** SYAORAN end. *****/
> +#endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
