Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZIDPbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZIDPbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbZIDPbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:31:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54668 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbZIDPbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:31:38 -0400
Date: Fri, 4 Sep 2009 10:31:35 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
       gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] VFS: Factor out part of vfs_setxattr so it can be
	called from the SELinux hook for inode_setsecctx.
Message-ID: <20090904153135.GA15342@us.ibm.com>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-2-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252002358-6612-2-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
> This factors out the part of the vfs_setxattr function that performs the
> setting of the xattr and its notification. This is needed so the SELinux
> implementation of inode_setsecctx can handle the setting of the xattr while
> maintaining the proper separation of layers.
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/xattr.c            |   55 +++++++++++++++++++++++++++++++++++++-----------
>  include/linux/xattr.h |    1 +
>  2 files changed, 43 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 1c3d0af..6d4f6d3 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -66,22 +66,28 @@ xattr_permission(struct inode *inode, const char *name, int mask)
>  	return inode_permission(inode, mask);
>  }
> 
> -int
> -vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> -		size_t size, int flags)
> +/**
> + *  __vfs_setxattr_noperm - perform setxattr operation without performing
> + *  permission checks.
> + *
> + *  @dentry - object to perform setxattr on
> + *  @name - xattr name to set
> + *  @value - value to set @name to
> + *  @size - size of @value
> + *  @flags - flags to pass into filesystem operations
> + *
> + *  returns the result of the internal setxattr or setsecurity operations.
> + *
> + *  This function requires the caller to lock the inode's i_mutex before it
> + *  is executed. It also assumes that the caller will make the appropriate
> + *  permission checks.
> + */
> +int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> +		const void *value, size_t size, int flags)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	int error;
> -
> -	error = xattr_permission(inode, name, MAY_WRITE);
> -	if (error)
> -		return error;
> +	int error = -EOPNOTSUPP;
> 
> -	mutex_lock(&inode->i_mutex);
> -	error = security_inode_setxattr(dentry, name, value, size, flags);
> -	if (error)
> -		goto out;
> -	error = -EOPNOTSUPP;
>  	if (inode->i_op->setxattr) {
>  		error = inode->i_op->setxattr(dentry, name, value, size, flags);
>  		if (!error) {
> @@ -97,6 +103,29 @@ vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
>  		if (!error)
>  			fsnotify_xattr(dentry);
>  	}
> +
> +	return error;
> +}
> +
> +
> +int
> +vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> +		size_t size, int flags)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	int error;
> +
> +	error = xattr_permission(inode, name, MAY_WRITE);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&inode->i_mutex);
> +	error = security_inode_setxattr(dentry, name, value, size, flags);
> +	if (error)
> +		goto out;
> +
> +	error = __vfs_setxattr_noperm(dentry, name, value, size, flags);
> +
>  out:
>  	mutex_unlock(&inode->i_mutex);
>  	return error;
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index d131e35..5c84af8 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -49,6 +49,7 @@ struct xattr_handler {
>  ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
>  ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
>  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> +int __vfs_setxattr_noperm(struct dentry *, const char *, const void *, size_t, int);
>  int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
>  int vfs_removexattr(struct dentry *, const char *);
> 
> -- 
> 1.5.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
