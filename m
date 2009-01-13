Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZAMNR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZAMNR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZAMNRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:17:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52695 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZAMNRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:17:14 -0500
Subject: Re: [PATCH] ecryptfs: some inode attrs, and a question
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ecryptfs-devel@lists.launchpad.net
In-Reply-To: <7471.1231827621@jrobl>
References: <7471.1231827621@jrobl>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 07:17:08 -0600
Message-Id: <1231852628.6954.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing ecryptfs-devel.  mhalcrow has moved on to the dark side^W^W^W
another company.

Shaggy

On Tue, 2009-01-13 at 15:20 +0900, hooanon05@yahoo.co.jp wrote:
> Here are several fixes for linux-2.6.27/fs/ecryptfs.
> 
> - The ecryptfs inode holds a reference to the lower inode, but doesn't
>   increment the reference counter. When a user sets inotify to the
>   ecryptfs inode, it may live without the corresponding dentry. In this
>   case the referecen to the lower inode may be broken.
>   This patch maintains the reference of the lower inode.
> 
> - follow the VFS unlink sequence in ecryptfs_unlink() which is
>   inrementing and decrementing the inode->i_count and the reference
>   counter for the dentry.
> 
> - maintain the link count and ctime in ecryptfs_rmdir() because a user
>   may issue fstat(2) later.
> 
> - remove the unnecessary d_drop()s in ecryptfs_link().
> 
> And I have experienced a strange behaviour. When ecryptfs gets -ENOSPC
> from the lower fs, it converts and returns EINVAL to the userspace. Is
> this an intended behaviour?
> 
> 
> J. R. Okajima
> 
> Index: linux-2.6.27/fs/ecryptfs/inode.c
> ===================================================================
> retrieving revision 1.1
> retrieving revision 1.2
> diff -u -p -r1.1 -r1.2
> --- linux-2.6.27/fs/ecryptfs/inode.c	19 Dec 2008 03:05:27 -0000	1.1
> +++ linux-2.6.27/fs/ecryptfs/inode.c	19 Dec 2008 19:52:26 -0000	1.2
> @@ -430,9 +430,6 @@ out_lock:
>  	unlock_dir(lower_dir_dentry);
>  	dput(lower_new_dentry);
>  	dput(lower_old_dentry);
> -	d_drop(lower_old_dentry);
> -	d_drop(new_dentry);
> -	d_drop(old_dentry);
>  	return rc;
>  }
> 
> @@ -444,7 +441,10 @@ static int ecryptfs_unlink(struct inode 
>  	struct dentry *lower_dir_dentry;
> 
>  	lower_dir_dentry = lock_parent(lower_dentry);
> +	dget(lower_dentry);
> +	atomic_inc_return(&lower_dentry->d_inode->i_count);
>  	rc = vfs_unlink(lower_dir_inode, lower_dentry);
> +	dput(lower_dentry);
>  	if (rc) {
>  		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
>  		goto out_unlock;
> @@ -455,6 +455,7 @@ static int ecryptfs_unlink(struct inode 
>  	dentry->d_inode->i_ctime = dir->i_ctime;
>  	d_drop(dentry);
>  out_unlock:
> +	iput(lower_dentry->d_inode);
>  	unlock_dir(lower_dir_dentry);
>  	return rc;
>  }
> @@ -538,8 +539,12 @@ static int ecryptfs_rmdir(struct inode *
>  	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
>  	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
>  	unlock_dir(lower_dir_dentry);
> -	if (!rc)
> +	if (!rc) {
> +		struct inode *inode = dentry->d_inode;
> +		inode->i_nlink = ecryptfs_inode_to_lower(inode)->i_nlink;
> +		inode->i_ctime = dir->i_ctime;
>  		d_drop(dentry);
> +	}
>  	dput(dentry);
>  	return rc;
>  }
> Index: linux-2.6.27/fs/ecryptfs/super.c
> ===================================================================
> retrieving revision 1.1
> retrieving revision 1.2
> diff -u -p -r1.1 -r1.2
> --- linux-2.6.27/fs/ecryptfs/super.c	19 Dec 2008 04:37:43 -0000	1.1
> +++ linux-2.6.27/fs/ecryptfs/super.c	19 Dec 2008 19:52:26 -0000	1.2
> @@ -89,6 +89,7 @@ static void ecryptfs_destroy_inode(struc
>  		}
>  	}
>  	mutex_unlock(&inode_info->lower_file_mutex);
> +	iput(inode_info->wii_inode);
>  	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
>  	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
>  }
> @@ -101,6 +102,7 @@ static void ecryptfs_destroy_inode(struc
>   */
>  void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode)
>  {
> +	atomic_inc_return(&lower_inode->i_count);
>  	ecryptfs_set_inode_lower(inode, lower_inode);
>  	inode->i_ino = lower_inode->i_ino;
>  	inode->i_version++;
-- 
David Kleikamp
IBM Linux Technology Center

