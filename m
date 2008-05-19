Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYESN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYESN7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbYESN7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:59:02 -0400
Received: from mx2.netapp.com ([216.240.18.37]:23593 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760115AbYESN6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.27,509,1204531200"; 
   d="scan'208";a="67185189"
Subject: Re: [PATCH] [1/11] Remove BKL from remote_llseek
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: swhiteho@redhat.com, sfrench@samba.org, vandrove@vc.cvut.cz,
       corbet@lwn.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080519123110.930491B41FF@basil.firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
	 <20080519123110.930491B41FF@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Mon, 19 May 2008 09:58:44 -0400
Message-Id: <1211205524.7911.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-OriginalArrivalTime: 19 May 2008 13:58:47.0205 (UTC) FILETIME=[753C0D50:01C8B9B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 14:31 +0200, Andi Kleen wrote:
> - Replace remote_llseek with remote_llseek_unlocked (to force compilation 
> failures in all users)
> - Change all users to either use remote_llseek directly or take the
> BKL around. I changed the file systems who don't use the BKL
> for anything (CIFS, GFS) to call it directly. NCPFS and SMBFS and NFS
> take the BKL, but explicitely in their own source now.
> 
> I moved them all over in a single patch to avoid unbisectable sections.
> 
> Open problem: 32bit kernels can corrupt fpos because its modification
> is not atomic, but they can do that anyways because there's other paths who 
> modify it without BKL.
> 
> Cc: Trond.Myklebust@netapp.com
> Cc: swhiteho@redhat.com
> Cc: sfrench@samba.org
> Cc: vandrove@vc.cvut.cz
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/cifs/cifsfs.c   |    2 +-
>  fs/gfs2/ops_file.c |    4 ++--
>  fs/ncpfs/file.c    |   12 +++++++++++-
>  fs/nfs/file.c      |    6 +++++-
>  fs/read_write.c    |    7 +++----
>  fs/smbfs/file.c    |   11 ++++++++++-
>  include/linux/fs.h |    3 ++-
>  7 files changed, 34 insertions(+), 11 deletions(-)
> 
> Index: linux/fs/cifs/cifsfs.c
> ===================================================================
> --- linux.orig/fs/cifs/cifsfs.c
> +++ linux/fs/cifs/cifsfs.c
> @@ -581,7 +581,7 @@ static loff_t cifs_llseek(struct file *f
>  		if (retval < 0)
>  			return (loff_t)retval;
>  	}
> -	return remote_llseek(file, offset, origin);
> +	return remote_llseek_unlocked(file, offset, origin);
>  }
>  
>  struct file_system_type cifs_fs_type = {
> Index: linux/fs/gfs2/ops_file.c
> ===================================================================
> --- linux.orig/fs/gfs2/ops_file.c
> +++ linux/fs/gfs2/ops_file.c
> @@ -62,11 +62,11 @@ static loff_t gfs2_llseek(struct file *f
>  		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
>  					   &i_gh);
>  		if (!error) {
> -			error = remote_llseek(file, offset, origin);
> +			error = remote_llseek_unlocked(file, offset, origin);
>  			gfs2_glock_dq_uninit(&i_gh);
>  		}
>  	} else
> -		error = remote_llseek(file, offset, origin);
> +		error = remote_llseek_unlocked(file, offset, origin);
>  
>  	return error;
>  }
> Index: linux/fs/ncpfs/file.c
> ===================================================================
> --- linux.orig/fs/ncpfs/file.c
> +++ linux/fs/ncpfs/file.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched.h>
> +#include <linux/smp_lock.h>
>  
>  #include <linux/ncp_fs.h>
>  #include "ncplib_kernel.h"
> @@ -281,9 +282,18 @@ static int ncp_release(struct inode *ino
>  	return 0;
>  }
>  
> +static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	loff_t ret;
> +	lock_kernel();
> +	ret = remote_llseek_unlocked(file, offset, origin);
> +	unlock_kernel();
> +	return ret;
> +}
> +
>  const struct file_operations ncp_file_operations =
>  {
> -	.llseek		= remote_llseek,
> +	.llseek 	= ncp_remote_llseek,
>  	.read		= ncp_file_read,
>  	.write		= ncp_file_write,
>  	.ioctl		= ncp_ioctl,
> Index: linux/fs/read_write.c
> ===================================================================
> --- linux.orig/fs/read_write.c
> +++ linux/fs/read_write.c
> @@ -58,11 +58,10 @@ loff_t generic_file_llseek(struct file *
>  
>  EXPORT_SYMBOL(generic_file_llseek);
>  
> -loff_t remote_llseek(struct file *file, loff_t offset, int origin)
> +loff_t remote_llseek_unlocked(struct file *file, loff_t offset, int origin)
>  {
>  	loff_t retval;
>  
> -	lock_kernel();
>  	switch (origin) {
>  		case SEEK_END:
>  			offset += i_size_read(file->f_path.dentry->d_inode);
> @@ -73,15 +72,15 @@ loff_t remote_llseek(struct file *file, 
>  	retval = -EINVAL;
>  	if (offset>=0 && offset<=file->f_path.dentry->d_inode->i_sb->s_maxbytes) {
>  		if (offset != file->f_pos) {
> +			/* AK: do we need a lock for those? */
>  			file->f_pos = offset;
>  			file->f_version = 0;
>  		}
>  		retval = offset;
>  	}
> -	unlock_kernel();
>  	return retval;
>  }
> -EXPORT_SYMBOL(remote_llseek);
> +EXPORT_SYMBOL(remote_llseek_unlocked);
>  
>  loff_t no_llseek(struct file *file, loff_t offset, int origin)
>  {
> Index: linux/fs/smbfs/file.c
> ===================================================================
> --- linux.orig/fs/smbfs/file.c
> +++ linux/fs/smbfs/file.c
> @@ -422,9 +422,18 @@ smb_file_permission(struct inode *inode,
>  	return error;
>  }
>  
> +static loff_t smb_remote_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	loff_t ret;
> +	lock_kernel();
> +	ret = remote_llseek_unlocked(file, offset, origin);
> +	unlock_kernel();
> +	return ret;
> +}
> +
>  const struct file_operations smb_file_operations =
>  {
> -	.llseek		= remote_llseek,
> +	.llseek 	= smb_remote_llseek,
>  	.read		= do_sync_read,
>  	.aio_read	= smb_file_aio_read,
>  	.write		= do_sync_write,
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h
> +++ linux/include/linux/fs.h
> @@ -1871,7 +1871,8 @@ extern void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
>  extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
> -extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
> +extern loff_t remote_llseek_unlocked(struct file *file, loff_t offset,
> +			int origin);
>  extern int generic_file_open(struct inode * inode, struct file * filp);
>  extern int nonseekable_open(struct inode * inode, struct file * filp);
>  
> Index: linux/fs/nfs/file.c
> ===================================================================
> --- linux.orig/fs/nfs/file.c
> +++ linux/fs/nfs/file.c
> @@ -170,6 +170,7 @@ force_reval:
>  
>  static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
>  {
> +	loff_t loff;
>  	/* origin == SEEK_END => we must revalidate the cached file length */
>  	if (origin == SEEK_END) {
>  		struct inode *inode = filp->f_mapping->host;
> @@ -177,7 +178,10 @@ static loff_t nfs_file_llseek(struct fil
>  		if (retval < 0)
>  			return (loff_t)retval;
>  	}
> -	return remote_llseek(filp, offset, origin);
> +	lock_kernel();	/* BKL needed? */
> +	loff = remote_llseek_unlocked(filp, offset, origin);
> +	unlock_kernel();
> +	return loff;

The NFS client shouldn't need any special locking around remote_llseek()
beyond whatever is required at the VFS level.

The one case in nfs_file_llseek() where we might care is the call to
nfs_revalidate_file_size() ﻿('cos I still haven't finished auditing BKL
dependencies in the inode attributes). However that case should already
be covered without introducing any new lock_kernel/unlock_kernel calls
since __nfs_revalidate_inode() already grabs the BKL.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
