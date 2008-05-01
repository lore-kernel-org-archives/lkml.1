Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYEAIC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYEAIC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 04:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYEAICC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 04:02:02 -0400
Received: from sous-sol.org ([216.99.217.87]:44266 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYEAICA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 04:02:00 -0400
Date: Thu, 1 May 2008 01:01:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: akpm@linux-foundation.org, chrisw@sous-sol.org, viro@ZenIV.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #8 (2.6.25-mm1) 1/7] Introduce new LSM hooks.
Message-ID: <20080501080144.GJ30511@sequoia.sous-sol.org>
References: <20080501055405.024390000@nttdata.co.jp> <20080501055543.269648000@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501055543.269648000@nttdata.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Toshiharu Harada (haradats@nttdata.co.jp) wrote:
> This patch allows LSM to check permission using "struct vfsmount"
> without passing "struct vfsmount" to VFS helper functions.

This is simply duplicating many of the existing checks.
I don't see how this is an improvement.

> --- mm.orig/fs/namei.c
> +++ mm/fs/namei.c
> @@ -1595,6 +1595,9 @@ int vfs_create(struct inode *dir, struct
>  	error = security_inode_create(dir, dentry, mode);
>  	if (error)
>  		return error;
> +	error = security_path_create(dir, dentry, mode, nd);
> +	if (error)
> +		return error;

Pure duplication (of course adding nameidata, although I think you just
want path).

>  	DQUOT_INIT(dir);
>  	error = dir->i_op->create(dir, dentry, mode, nd);
>  	if (!error)
> @@ -1650,6 +1653,17 @@ int may_open(struct nameidata *nd, int a
	...
	error = vfs_permission(nd, acc_mode);
	if (error)
		return error;
	...
>  			return -EPERM;
>  
>  	/*
> +	 * security_inode_permission() called from vfs_permission()
> +	 * can't know that the file is going to be truncated when
> +	 * open(filename, O_WRONLY | O_TRUNC | O_APPEND) is used.
> +	 * So, this hook checks O_APPEND and O_TRUNC flags as well
> +	 * as MAY_READ and MAY_WRITE flags.
> +	 */
> +	error = security_path_open(nd->path.dentry, nd->path.mnt, flag);
> +	if (error)
> +		return error;

Also duplication.  And why the unique flag handling, you don't seem to
ever check?

> +
> +	/*
>  	 * Ensure there are no outstanding leases on the file.
>  	 */
>  	error = break_lease(inode, flag);
> @@ -2021,7 +2035,12 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(lookup_create);
>  
> -int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> +/*
> + * These pre_vfs_*() functions are separated from vfs_*() functions so that
> + * LSM's security_path_*() functions can do DAC checks before MAC checks
> + * without duplicating may_create()/may_delete() functions.
> + */
> +int pre_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode)
>  {
>  	int error = may_create(dir, dentry, NULL);
>  
> @@ -2033,6 +2052,14 @@ int vfs_mknod(struct inode *dir, struct 
>  
>  	if (!dir->i_op || !dir->i_op->mknod)
>  		return -EPERM;
> +	return 0;
> +}
> +
> +int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> +{
> +	int error = pre_vfs_mknod(dir, dentry, mode);
> +	if (error)
> +		return error;

More duplication, you'll get a call chain like:

sys_mknod
  security_path_mknod
    pre_vfs_mknod
  vfs_mknod
   pre_vfs_mknod
   security_inode_mknod


