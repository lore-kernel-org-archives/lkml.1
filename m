Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0CARDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:03:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38649 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0CARDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:03:50 -0500
Date: Mon, 1 Mar 2010 10:03:49 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jon Severinsson <jon@severinsson.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [RFC PATCH] CIFS posix acl permission checking
Message-ID: <20100301170348.GB6567@parisc-linux.org>
References: <201003011615.49121.jon@severinsson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003011615.49121.jon@severinsson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 04:15:10PM +0100, Jon Severinsson wrote:
> Hello everyone
> 
> Firstly, please note that I'm new to the kernel community, so if I'm doing 
> something wrong, just please politely point it out to me and I'll try to fix 
> it, or at the very least not do it again. Also please bear in mind that 
> English isn't my native language.

Okey dokey, here's some minor mistakes you made.

 - Generally a good idea to cc the CIFS development list for CIFS patches.
   I'm sure they'll notice it here, but just to be on the safe side, I've
   added them to the cc.
 - You've included ifdefs around the check_acl entry in inode_operations,
   *and* inside the definition of cifs_check_acl.  You only need to do one
   or the other, and opinion is divided on which is better.
(further comments inline)

> Anyway, I recently realised that while the CIFS file system driver in Linux 
> does supports posix acl retrieval and modification using the getfacl and 
> setfacl command line tools, it does not use acl for client side permission 
> checking. On the server side Samba does consult the acl, but that doesn't 
> really help when cifs.ko never even asks the server, due to the users only 
> source of permission being from an acl.
> 
> I'm attaching a first attempt at implementing it. I have tested it, but only on 
> a single setup, so I can give no guarantees to its portability. Also please 
> note that this is my first kernel patch, so if I'm doing something wrong, such 
> as not following some coding standard, please enlighten me and I'll gladly fix 
> it.
> 
> I only subscribed to the linux-fsdevel list, so please include it in any 
> response you might send.
> 
> Best Regards
> Jon Severinsson

> commit fab1872fcbb8a5cdb85d7e7a88ecf0cad99d1c80
> Author: Jon Severinsson <jon@severinsson.net>
> Date:   Mon Mar 1 15:49:40 2010 +0100
> 
>     [CIFS] Adds support for permision checking vs. posix acl.
>     
>     CIFS already supports getting and setting acls through getfacl and setfacl, but
>     prior to this patch, any acls was ignored when doing permission checking.
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 29f1da7..0605e11 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -284,7 +284,7 @@ static int cifs_permission(struct inode *inode, int mask)
>  		on the client (above and beyond ACL on servers) for
>  		servers which do not support setting and viewing mode bits,
>  		so allowing client to check permissions is useful */
> -		return generic_permission(inode, mask, NULL);
> +		return generic_permission(inode, mask, inode->i_op->check_acl);
>  }
>  
>  static struct kmem_cache *cifs_inode_cachep;
> @@ -702,6 +702,9 @@ const struct inode_operations cifs_dir_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> @@ -716,6 +719,9 @@ const struct inode_operations cifs_file_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> @@ -732,6 +738,9 @@ const struct inode_operations cifs_symlink_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index ac2b24c..6409a83 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -102,11 +102,15 @@ extern int cifs_readlink(struct dentry *direntry, char __user *buffer,
>  			 int buflen);
>  extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
>  			const char *symname);
> +
> +/* Functions related to extended attributes */
>  extern int	cifs_removexattr(struct dentry *, const char *);
>  extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
>  			size_t, int);
>  extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
>  extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
> +extern int cifs_check_acl(struct inode *inode, int mask);
> +
>  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index a75afa3..a851ba1 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -374,3 +374,74 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
>  #endif
>  	return rc;
>  }
> +
> +int cifs_check_acl(struct inode *inode, int mask)
> +{
> +	int rc = -EOPNOTSUPP;
> +#ifdef CONFIG_CIFS_XATTR
> +#ifdef CONFIG_CIFS_POSIX
> +	struct dentry *dentry = NULL;
> +	size_t buf_size;
> +	void *ea_value = NULL;

I don't think you need to initialise ea_value, do you?

> +	ssize_t ea_size;
> +	struct posix_acl *acl = NULL;
> +
> +	/* CIFS gets acl from server by path, and thus needs a dentry rather than
> +	   an inode. Note that the path of each dentry will point to the same inode
> +	   on the backing fs at the server, so their acls will be the same, and it
> +	   doesn't matter which one we pick, so just pick the fist. */
> +	if (list_empty(&inode->i_dentry))
> +		dentry = list_first_entry(&inode->i_dentry, struct dentry, d_alias);
> +
> +	/* If we didn't get an dentry for the inode, something went terribly wrong.
> +	   All we can do at this point is to return an error. */
> +	if (!dentry || IS_ERR(dentry)) 
> +		return PTR_ERR(dentry);

I don't think dentry can possibly be IS_ERR here, and returning
PTR_ERR(NULL) doesn't do what you think it does.  Also, you've got the sense
of list_empty backwards.  I think what you meant to do here was:

	if (!list_empty(&inode->i_dentry))
		dentry = list_first_entry(&inode->i_dentry, struct dentry,
								d_alias);
	else
		return -EINVAL;

> +	/* Try to fit the extended attribute corresponding to the posix acl in 4k
> +	   memory. 4k was chosen because it always fits in a single page, and is
> +	   the maximum on a default ext2/3/4 backing fs. */
> +	buf_size = 4096;
> +	ea_value = kmalloc(buf_size, GFP_KERNEL);
> +	if (!ea_value) {
> +		rc = -EAGAIN;
> +		goto check_acl_exit;
> +	}
> +	ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
> +
> +	/* If 4k wasn't enough, try 64k, the maximum on any current backing fs. */
> +	if (ea_size == -ERANGE) {
> +		kfree(ea_value);
> +		buf_size = 65536;
> +		ea_value = kmalloc(buf_size, GFP_KERNEL);
> +		if (!ea_value) {
> +			rc = -EAGAIN;
> +			goto check_acl_exit;
> +		}
> +		ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
> +	}
> +
> +	/* If we didn't get any extended attribute, set the error code and exit */
> +	if (ea_size <= 0) {
> +		rc = -EAGAIN;
> +		if (ea_size == -EOPNOTSUPP || ea_size == -EIO || ea_size == -ENOTDIR || ea_size == -ENOENT || ea_size == -EFAULT || ea_size == -EACCES)
> +			rc = ea_size;
> +		goto check_acl_exit;
> +	}
> +
> +	/* Set the appropriate return value. Adapted from ext4. */
> +	acl = posix_acl_from_xattr(ea_value, ea_size);
> +	if (IS_ERR(acl))
> +		rc = PTR_ERR(acl);
> +	else if (acl)
> +		rc = posix_acl_permission(inode, acl, mask);
> +	else
> +		rc = -EAGAIN;
> +
> +check_acl_exit:
> +	posix_acl_release(acl);
> +	kfree(ea_value);
> +#endif /* CONFIG_CIFS_POSIX */
> +#endif /* CONFIG_CIFS_XATTR */
> +	return rc;
> +}




-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
