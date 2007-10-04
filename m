Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXJDWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXJDWwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759379AbXJDWwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:52:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56613 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758326AbXJDWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:52:04 -0400
Date: Thu, 4 Oct 2007 15:51:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 09/12] fuse: add list of writable files to fuse_inode
Message-Id: <20071004155128.62fc1098.akpm@linux-foundation.org>
In-Reply-To: <20071002155222.373341208@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
	<20071002155222.373341208@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 17:50:35 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Each WRITE request must carry a valid file descriptor.  When a page is
> written back from a memory mapping, the file through which the page
> was dirtied is not available, so a new mechananism is needed to find a
> suitable file in ->writepage(s).
> 
> A list of fuse_files is added to fuse_inode.  The file is removed from
> the list in fuse_release().
> 
> This patch is in preparation for writable mmap support.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/fuse/file.c
> ===================================================================
> --- linux.orig/fs/fuse/file.c	2007-10-01 22:42:26.000000000 +0200
> +++ linux/fs/fuse/file.c	2007-10-01 22:42:27.000000000 +0200
> @@ -56,6 +56,7 @@ struct fuse_file *fuse_file_alloc(void)
>  			kfree(ff);
>  			ff = NULL;
>  		}
> +		INIT_LIST_HEAD(&ff->write_entry);
>  		atomic_set(&ff->count, 0);
>  	}
>  	return ff;
> @@ -150,12 +151,18 @@ int fuse_release_common(struct inode *in
>  {
>  	struct fuse_file *ff = file->private_data;
>  	if (ff) {
> +		struct fuse_conn *fc = get_fuse_conn(inode);
> +
>  		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
>  				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
>  
>  		/* Hold vfsmount and dentry until release is finished */
>  		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
>  		ff->reserved_req->dentry = dget(file->f_path.dentry);
> +
> +		spin_lock(&fc->lock);
> +		list_del(&ff->write_entry);
> +		spin_unlock(&fc->lock);
>  		/*
>  		 * Normally this will send the RELEASE request,
>  		 * however if some asynchronous READ or WRITE requests
> Index: linux/fs/fuse/fuse_i.h
> ===================================================================
> --- linux.orig/fs/fuse/fuse_i.h	2007-10-01 22:42:24.000000000 +0200
> +++ linux/fs/fuse/fuse_i.h	2007-10-01 22:43:15.000000000 +0200
> @@ -70,6 +70,9 @@ struct fuse_inode {
>  
>  	/** Version of last attribute change */
>  	u64 attr_version;
> +
> +	/** Files usable in writepage.  Protected by fc->lock */
> +	struct list_head write_files;
>  };
>  
>  /** FUSE specific file data */
> @@ -82,6 +85,9 @@ struct fuse_file {
>  
>  	/** Refcount */
>  	atomic_t count;
> +
> +	/** Entry on inode's write_files list */
> +	struct list_head write_entry;
>  };
>  
>  /** One input argument of a request */
> Index: linux/fs/fuse/inode.c
> ===================================================================
> --- linux.orig/fs/fuse/inode.c	2007-10-01 22:42:24.000000000 +0200
> +++ linux/fs/fuse/inode.c	2007-10-01 22:42:27.000000000 +0200
> @@ -56,6 +56,7 @@ static struct inode *fuse_alloc_inode(st
>  	fi->i_time = 0;
>  	fi->nodeid = 0;
>  	fi->nlookup = 0;
> +	INIT_LIST_HEAD(&fi->write_files);
>  	fi->forget_req = fuse_request_alloc();
>  	if (!fi->forget_req) {
>  		kmem_cache_free(fuse_inode_cachep, inode);
> @@ -68,6 +69,7 @@ static struct inode *fuse_alloc_inode(st
>  static void fuse_destroy_inode(struct inode *inode)
>  {
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> +	BUG_ON(!list_empty(&fi->write_files));
>  	if (fi->forget_req)
>  		fuse_request_free(fi->forget_req);
>  	kmem_cache_free(fuse_inode_cachep, inode);

hm.  At no point in this patch series does anything actually get added to
these lists, so this patch is presently a no-op.

I'll assume that it will get used later.  But it is a bit odd to add
infrastructure in a patch series, then not use it.  Why not hold the patch
back and include it in the patch series which actually uses these lists for
something?


