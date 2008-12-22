Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYLVQHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYLVQHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 11:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYLVQH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 11:07:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2275 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754822AbYLVQH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 11:07:27 -0500
Date: Mon, 22 Dec 2008 11:07:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Christoph Hellwig <hch@lst.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] add a vfs_fsync helper
In-Reply-To: <200812220143.29375.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0812221102190.18968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Christoph Hellwig wrote:

> Fsync currently has a fdatawrite/fdatawait pair around the method call,
> and a mutex_lock/unlock of the inode mutex.  All callers of fsync have
> to duplicate this, but we have a few and most of them don't quite get
> it right.  This patch adds a new vfs_fsync that takes care of this.
> It's a little more complicated as usual as ->fsync might get a NULL file
> pointer and just a dentry from nfsd, but otherwise gets afile and we
> want to take the mapping and file operations from it when it is there.

> Index: xfs/fs/sync.c
> ===================================================================
> --- xfs.orig/fs/sync.c	2008-12-19 15:02:53.942907780 +0100
> +++ xfs/fs/sync.c	2008-12-21 12:22:17.180896085 +0100
> @@ -75,14 +75,39 @@
>  	return ret;
>  }
>  
> -long do_fsync(struct file *file, int datasync)
> +/**
> + * vfs_fsync - perform a fsync or fdatasync on a file
> + * @file:		file to sync
> + * @dentry:		dentry of @file
> + * @data:		only perform a fdatasync operation
> + *
> + * Write back data and metadata for @file to disk.  If @datasync is
> + * set only metadata needed to access modified file data is written.
> + *
> + * In case this function is called from nfsd @file may be %NULL and
> + * only @dentry is set.  This can only happen when the filesystem
> + * implements the export_operations API.
> + */
> +int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
>  {
> -	int ret;
> -	int err;
> -	struct address_space *mapping = file->f_mapping;
> +	struct file_operations *fop;
> +	struct address_space *mapping;
> +	int err, ret;
> +
> +	/*
> +	 * Get mapping and operations from the file in case we have
> +	 * as file, or get the default values for them in case we
> +	 * don't have a struct file available.  Damn nfsd..
> +	 */
> +	if (file) {
> +		mapping = file->f_mapping;
> +		fop = file->f_op;
> +	} else {
> +		mapping = dentry->d_inode->i_mapping;
> +		fop = dentry->d_inode->i_fop;
> +	}
>  
> -	if (!file->f_op || !file->f_op->fsync) {
> -		/* Why?  We can still call filemap_fdatawrite */
> +	if (!fop || !fop->fsync) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -94,7 +119,7 @@
>  	 * livelocks in fsync_buffers_list().
>  	 */
>  	mutex_lock(&mapping->host->i_mutex);
> -	err = file->f_op->fsync(file, file->f_path.dentry, datasync);
> +	err = fop->fsync(file, dentry, datasync);
>  	if (!ret)
>  		ret = err;
>  	mutex_unlock(&mapping->host->i_mutex);
> @@ -105,14 +130,14 @@
>  	return ret;
>  }
>  
> -static long __do_fsync(unsigned int fd, int datasync)
> +static int do_fsync(unsigned int fd, int datasync)
>  {
>  	struct file *file;
>  	int ret = -EBADF;
>  
>  	file = fget(fd);
>  	if (file) {
> -		ret = do_fsync(file, datasync);
> +		ret = vfs_fsync(file, file->f_path.dentry, datasync);
>  		fput(file);
>  	}
>  	return ret;
> @@ -120,12 +145,12 @@
>  
>  asmlinkage long sys_fsync(unsigned int fd)
>  {
> -	return __do_fsync(fd, 0);
> +	return do_fsync(fd, 0);
>  }
>  
>  asmlinkage long sys_fdatasync(unsigned int fd)
>  {
> -	return __do_fsync(fd, 1);
> +	return do_fsync(fd, 1);
>  }
>  
>  /*

> Index: xfs/drivers/usb/gadget/file_storage.c
> ===================================================================
> --- xfs.orig/drivers/usb/gadget/file_storage.c	2008-12-21 12:26:53.254894542 +0100
> +++ xfs/drivers/usb/gadget/file_storage.c	2008-12-21 12:28:08.914896191 +0100
> @@ -1863,26 +1863,10 @@
>  static int fsync_sub(struct lun *curlun)
>  {
>  	struct file	*filp = curlun->filp;
> -	struct inode	*inode;
> -	int		rc, err;
>  
>  	if (curlun->ro || !filp)
>  		return 0;
> -	if (!filp->f_op->fsync)
> -		return -EINVAL;
> -
> -	inode = filp->f_path.dentry->d_inode;
> -	mutex_lock(&inode->i_mutex);
> -	rc = filemap_fdatawrite(inode->i_mapping);
> -	err = filp->f_op->fsync(filp, filp->f_path.dentry, 1);
> -	if (!rc)
> -		rc = err;
> -	err = filemap_fdatawait(inode->i_mapping);
> -	if (!rc)
> -		rc = err;
> -	mutex_unlock(&inode->i_mutex);
> -	VLDBG(curlun, "fdatasync -> %d\n", rc);
> -	return rc;
> +	return vfs_fsync(filp, filp->f_path.dentry->d_inode, 1);
>  }

This won't work unless vfs_fsync() is EXPORTed.

Alan Stern

