Return-Path: <linux-kernel-owner+w=401wt.eu-S1161174AbXBGKpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174AbXBGKpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161173AbXBGKpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:45:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47806 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161168AbXBGKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:45:51 -0500
Date: Wed, 7 Feb 2007 11:45:49 +0100
From: Jan Kara <jack@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Message-ID: <20070207104549.GF24590@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revokeat(2) and frevoke(2) system calls invalidate open file
> descriptors and shared mappings of an inode. After an successful
> revocation, operations on file descriptors fail with the EBADF or
> ENXIO error code for regular and device files,
> respectively. Attempting to read from or write to a revoked mapping
> causes SIGBUS.
> 
> The actual operation is done in two passes:
> 
>  1. Revoke all file descriptors that point to the given inode. We do
>     this under tasklist_lock so that after this pass, we don't need
>     to worry about racing with close(2) or dup(2).
>    
>  2. Take down shared memory mappings of each revoked file and close
>     the file pointer.
> 
> The file descriptors are kept until the owning task does close(2) and
> memory mapping ranges preserved until the owning task does munmap(2).
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
  Have you considered using similar hack as bad_inode.c instead of
revoked_inode.c?

> Index: 2.6/fs/revoked_inode.c
> ===================================================================
> --- /dev/null
> +++ 2.6/fs/revoked_inode.c
> @@ -0,0 +1,664 @@
> +/*
> + *  linux/fs/revoked_inode.c
> + *
> + *  Copyright (C) 1997, Stephen Tweedie
> + *
> + *  Provide stub functions for revoked inodes
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/module.h>
> +#include <linux/stat.h>
> +#include <linux/time.h>
> +#include <linux/smp_lock.h>
> +#include <linux/namei.h>
> +#include <linux/poll.h>
> +
> +static loff_t revoked_file_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_read(struct file *filp, char __user * buf,
> +				 size_t size, loff_t * ppos)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_write(struct file *filp, const char __user * buf,
> +				  size_t siz, loff_t * ppos)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_aio_read(struct kiocb *iocb,
> +				     const struct iovec *iov,
> +				     unsigned long nr_segs, loff_t pos)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_aio_write(struct kiocb *iocb,
> +				      const struct iovec *iov,
> +				      unsigned long nr_segs, loff_t pos)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_readdir(struct file *filp, void *dirent,
> +				filldir_t filldir)
> +{
> +	return -EBADF;
> +}
> +
> +static unsigned int revoked_file_poll(struct file *filp, poll_table * wait)
> +{
> +	return POLLERR;
> +}
> +
> +static int revoked_file_ioctl(struct inode *inode, struct file *filp,
> +			      unsigned int cmd, unsigned long arg)
> +{
> +	return -EBADF;
> +}
> +
> +static long revoked_file_unlocked_ioctl(struct file *file, unsigned cmd,
> +					unsigned long arg)
> +{
> +	return -EBADF;
> +}
> +
> +static long revoked_file_compat_ioctl(struct file *file, unsigned int cmd,
> +				      unsigned long arg)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_open(struct inode *inode, struct file *filp)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_flush(struct file *file, fl_owner_t id)
> +{
> +	return 0;
> +}
> +
> +static int revoked_file_release(struct inode *inode, struct file *filp)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_fsync(struct file *file, struct dentry *dentry,
> +			      int datasync)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_aio_fsync(struct kiocb *iocb, int datasync)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_fasync(int fd, struct file *filp, int on)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_lock(struct file *file, int cmd, struct file_lock *fl)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_sendfile(struct file *in_file, loff_t * ppos,
> +				     size_t count, read_actor_t actor,
> +				     void *target)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_sendpage(struct file *file, struct page *page,
> +				     int off, size_t len, loff_t * pos,
> +				     int more)
> +{
> +	return -EBADF;
> +}
> +
> +static unsigned long revoked_file_get_unmapped_area(struct file *file,
> +						    unsigned long addr,
> +						    unsigned long len,
> +						    unsigned long pgoff,
> +						    unsigned long flags)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_check_flags(int flags)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_dir_notify(struct file *file, unsigned long arg)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_file_flock(struct file *filp, int cmd, struct file_lock *fl)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_splice_write(struct pipe_inode_info *pipe,
> +					 struct file *out, loff_t * ppos,
> +					 size_t len, unsigned int flags)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_file_splice_read(struct file *in, loff_t * ppos,
> +					struct pipe_inode_info *pipe,
> +					size_t len, unsigned int flags)
> +{
> +	return -EBADF;
> +}
> +
> +static const struct file_operations revoked_file_ops = {
> +	.llseek = revoked_file_llseek,
> +	.read = revoked_file_read,
> +	.write = revoked_file_write,
> +	.aio_read = revoked_file_aio_read,
> +	.aio_write = revoked_file_aio_write,
> +	.readdir = revoked_file_readdir,
> +	.poll = revoked_file_poll,
> +	.ioctl = revoked_file_ioctl,
> +	.unlocked_ioctl = revoked_file_unlocked_ioctl,
> +	.compat_ioctl = revoked_file_compat_ioctl,
> +	.mmap = revoked_file_mmap,
> +	.open = revoked_file_open,
> +	.flush = revoked_file_flush,
> +	.release = revoked_file_release,
> +	.fsync = revoked_file_fsync,
> +	.aio_fsync = revoked_file_aio_fsync,
> +	.fasync = revoked_file_fasync,
> +	.lock = revoked_file_lock,
> +	.sendfile = revoked_file_sendfile,
> +	.sendpage = revoked_file_sendpage,
> +	.get_unmapped_area = revoked_file_get_unmapped_area,
> +	.check_flags = revoked_file_check_flags,
> +	.dir_notify = revoked_file_dir_notify,
> +	.flock = revoked_file_flock,
> +	.splice_write = revoked_file_splice_write,
> +	.splice_read = revoked_file_splice_read,
> +};
> +
> +static int revoked_inode_create(struct inode *dir, struct dentry *dentry,
> +				int mode, struct nameidata *nd)
> +{
> +	return -EBADF;
> +}
> +
> +static struct dentry *revoked_inode_lookup(struct inode *dir,
> +					   struct dentry *dentry,
> +					   struct nameidata *nd)
> +{
> +	return ERR_PTR(-EBADF);
> +}
> +
> +static int revoked_inode_link(struct dentry *old_dentry, struct inode *dir,
> +			      struct dentry *dentry)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_symlink(struct inode *dir, struct dentry *dentry,
> +				 const char *symname)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_mkdir(struct inode *dir, struct dentry *dentry,
> +			       int mode)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_mknod(struct inode *dir, struct dentry *dentry,
> +			       int mode, dev_t rdev)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_rename(struct inode *old_dir,
> +				struct dentry *old_dentry,
> +				struct inode *new_dir,
> +				struct dentry *new_dentry)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_readlink(struct dentry *dentry, char __user * buffer,
> +				  int buflen)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_permission(struct inode *inode, int mask,
> +				    struct nameidata *nd)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
> +				 struct kstat *stat)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_setattr(struct dentry *direntry, struct iattr *attrs)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_setxattr(struct dentry *dentry, const char *name,
> +				  const void *value, size_t size, int flags)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_inode_getxattr(struct dentry *dentry, const char *name,
> +				      void *buffer, size_t size)
> +{
> +	return -EBADF;
> +}
> +
> +static ssize_t revoked_inode_listxattr(struct dentry *dentry, char *buffer,
> +				       size_t buffer_size)
> +{
> +	return -EBADF;
> +}
> +
> +static int revoked_inode_removexattr(struct dentry *dentry, const char *name)
> +{
> +	return -EBADF;
> +}
> +
> +static struct inode_operations revoked_inode_ops = {
> +	.create = revoked_inode_create,
> +	.lookup = revoked_inode_lookup,
> +	.link = revoked_inode_link,
> +	.unlink = revoked_inode_unlink,
> +	.symlink = revoked_inode_symlink,
> +	.mkdir = revoked_inode_mkdir,
> +	.rmdir = revoked_inode_rmdir,
> +	.mknod = revoked_inode_mknod,
> +	.rename = revoked_inode_rename,
> +	.readlink = revoked_inode_readlink,
> +	/* follow_link must be no-op, otherwise unmounting this inode
> +	   won't work */
> +	/* put_link returns void */
> +	/* truncate returns void */
> +	.permission = revoked_inode_permission,
> +	.getattr = revoked_inode_getattr,
> +	.setattr = revoked_inode_setattr,
> +	.setxattr = revoked_inode_setxattr,
> +	.getxattr = revoked_inode_getxattr,
> +	.listxattr = revoked_inode_listxattr,
> +	.removexattr = revoked_inode_removexattr,
> +	/* truncate_range returns void */
> +};
> +
> +static loff_t revoked_special_file_llseek(struct file *file, loff_t offset,
> +					  int origin)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
> +					 size_t size, loff_t * ppos)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_write(struct file *filp,
> +					  const char __user * buf, size_t siz,
> +					  loff_t * ppos)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_aio_read(struct kiocb *iocb,
> +					     const struct iovec *iov,
> +					     unsigned long nr_segs, loff_t pos)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_aio_write(struct kiocb *iocb,
> +					      const struct iovec *iov,
> +					      unsigned long nr_segs, loff_t pos)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_readdir(struct file *filp, void *dirent,
> +					filldir_t filldir)
> +{
> +	return -ENXIO;
> +}
> +
> +static unsigned int revoked_special_file_poll(struct file *filp,
> +					      poll_table * wait)
> +{
> +	return POLLERR;
> +}
> +
> +static int revoked_special_file_ioctl(struct inode *inode, struct file *filp,
> +				      unsigned int cmd, unsigned long arg)
> +{
> +	return -ENXIO;
> +}
> +
> +static long revoked_special_file_unlocked_ioctl(struct file *file, unsigned cmd,
> +						unsigned long arg)
> +{
> +	return -ENXIO;
> +}
> +
> +static long revoked_special_file_compat_ioctl(struct file *file,
> +					      unsigned int cmd,
> +					      unsigned long arg)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_mmap(struct file *file,
> +				     struct vm_area_struct *vma)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_open(struct inode *inode, struct file *filp)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_flush(struct file *file, fl_owner_t id)
> +{
> +	return 0;
> +}
> +
> +static int revoked_special_file_release(struct inode *inode, struct file *filp)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_fsync(struct file *file, struct dentry *dentry,
> +				      int datasync)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_aio_fsync(struct kiocb *iocb, int datasync)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_fasync(int fd, struct file *filp, int on)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_lock(struct file *file, int cmd,
> +				     struct file_lock *fl)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_sendfile(struct file *in_file,
> +					     loff_t * ppos, size_t count,
> +					     read_actor_t actor, void *target)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_sendpage(struct file *file,
> +					     struct page *page, int off,
> +					     size_t len, loff_t * pos, int more)
> +{
> +	return -ENXIO;
> +}
> +
> +static unsigned long revoked_special_file_get_unmapped_area(struct file *file,
> +							    unsigned long addr,
> +							    unsigned long len,
> +							    unsigned long pgoff,
> +							    unsigned long flags)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_check_flags(int flags)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_dir_notify(struct file *file, unsigned long arg)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_file_flock(struct file *filp, int cmd,
> +				      struct file_lock *fl)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_splice_write(struct pipe_inode_info *pipe,
> +						 struct file *out,
> +						 loff_t * ppos, size_t len,
> +						 unsigned int flags)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_file_splice_read(struct file *in, loff_t * ppos,
> +						struct pipe_inode_info *pipe,
> +						size_t len, unsigned int flags)
> +{
> +	return -ENXIO;
> +}
> +
> +static const struct file_operations revoked_special_file_ops = {
> +	.llseek = revoked_special_file_llseek,
> +	.read = revoked_special_file_read,
> +	.write = revoked_special_file_write,
> +	.aio_read = revoked_special_file_aio_read,
> +	.aio_write = revoked_special_file_aio_write,
> +	.readdir = revoked_special_file_readdir,
> +	.poll = revoked_special_file_poll,
> +	.ioctl = revoked_special_file_ioctl,
> +	.unlocked_ioctl = revoked_special_file_unlocked_ioctl,
> +	.compat_ioctl = revoked_special_file_compat_ioctl,
> +	.mmap = revoked_special_file_mmap,
> +	.open = revoked_special_file_open,
> +	.flush = revoked_special_file_flush,
> +	.release = revoked_special_file_release,
> +	.fsync = revoked_special_file_fsync,
> +	.aio_fsync = revoked_special_file_aio_fsync,
> +	.fasync = revoked_special_file_fasync,
> +	.lock = revoked_special_file_lock,
> +	.sendfile = revoked_special_file_sendfile,
> +	.sendpage = revoked_special_file_sendpage,
> +	.get_unmapped_area = revoked_special_file_get_unmapped_area,
> +	.check_flags = revoked_special_file_check_flags,
> +	.dir_notify = revoked_special_file_dir_notify,
> +	.flock = revoked_special_file_flock,
> +	.splice_write = revoked_special_file_splice_write,
> +	.splice_read = revoked_special_file_splice_read,
> +};
> +
> +static int revoked_special_inode_create(struct inode *dir,
> +					struct dentry *dentry, int mode,
> +					struct nameidata *nd)
> +{
> +	return -ENXIO;
> +}
> +
> +static struct dentry *revoked_special_inode_lookup(struct inode *dir,
> +						   struct dentry *dentry,
> +						   struct nameidata *nd)
> +{
> +	return ERR_PTR(-ENXIO);
> +}
> +
> +static int revoked_special_inode_link(struct dentry *old_dentry,
> +				      struct inode *dir, struct dentry *dentry)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_unlink(struct inode *dir,
> +					struct dentry *dentry)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_symlink(struct inode *dir,
> +					 struct dentry *dentry,
> +					 const char *symname)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_mkdir(struct inode *dir, struct dentry *dentry,
> +				       int mode)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_mknod(struct inode *dir, struct dentry *dentry,
> +				       int mode, dev_t rdev)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_rename(struct inode *old_dir,
> +					struct dentry *old_dentry,
> +					struct inode *new_dir,
> +					struct dentry *new_dentry)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_readlink(struct dentry *dentry,
> +					  char __user * buffer, int buflen)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_permission(struct inode *inode, int mask,
> +					    struct nameidata *nd)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_getattr(struct vfsmount *mnt,
> +					 struct dentry *dentry,
> +					 struct kstat *stat)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_setattr(struct dentry *direntry,
> +					 struct iattr *attrs)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_setxattr(struct dentry *dentry,
> +					  const char *name, const void *value,
> +					  size_t size, int flags)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_inode_getxattr(struct dentry *dentry,
> +					      const char *name, void *buffer,
> +					      size_t size)
> +{
> +	return -ENXIO;
> +}
> +
> +static ssize_t revoked_special_inode_listxattr(struct dentry *dentry,
> +					       char *buffer, size_t buffer_size)
> +{
> +	return -ENXIO;
> +}
> +
> +static int revoked_special_inode_removexattr(struct dentry *dentry,
> +					     const char *name)
> +{
> +	return -ENXIO;
> +}
> +
> +static struct inode_operations revoked_special_inode_ops = {
> +	.create = revoked_special_inode_create,
> +	.lookup = revoked_special_inode_lookup,
> +	.link = revoked_special_inode_link,
> +	.unlink = revoked_special_inode_unlink,
> +	.symlink = revoked_special_inode_symlink,
> +	.mkdir = revoked_special_inode_mkdir,
> +	.rmdir = revoked_special_inode_rmdir,
> +	.mknod = revoked_special_inode_mknod,
> +	.rename = revoked_special_inode_rename,
> +	.readlink = revoked_special_inode_readlink,
> +	/* follow_link must be no-op, otherwise unmounting this inode
> +	   won't work */
> +	/* put_link returns void */
> +	/* truncate returns void */
> +	.permission = revoked_special_inode_permission,
> +	.getattr = revoked_special_inode_getattr,
> +	.setattr = revoked_special_inode_setattr,
> +	.setxattr = revoked_special_inode_setxattr,
> +	.getxattr = revoked_special_inode_getxattr,
> +	.listxattr = revoked_special_inode_listxattr,
> +	.removexattr = revoked_special_inode_removexattr,
> +	/* truncate_range returns void */
> +};
> +
> +void make_revoked_inode(struct inode *inode, int mode)
> +{
> +	remove_inode_hash(inode);
> +
> +	inode->i_mode = mode;
> +	inode->i_atime = inode->i_mtime = inode->i_ctime =
> +	    current_fs_time(inode->i_sb);
> +
> +	if (special_file(mode)) {
> +		inode->i_op = &revoked_special_inode_ops;
> +		inode->i_fop = &revoked_special_file_ops;
> +	} else {
> +		inode->i_op = &revoked_inode_ops;
> +		inode->i_fop = &revoked_file_ops;
> +	}
> +}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
