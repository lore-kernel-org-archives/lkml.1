Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbXJZLaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbXJZLaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJZL3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:29:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:50447 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753551AbXJZL3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:29:51 -0400
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on
	file descriptors from operations on pathnames
From: Miklos Szeredi <mszeredi@suse.cz>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <20071026064051.393728475@suse.de>
References: <20071026064024.243943043@suse.de>
	 <20071026064051.393728475@suse.de>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 13:30:52 +0200
Message-Id: <1193398252.4721.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 23:40 -0700, jjohansen@suse.de wrote:
> plain text document attachment (file-handle-ops.diff)
> Struct iattr already contains ia_file since commit cc4e69de from 
> Miklos (which is related to commit befc649c). Use this to pass
> struct file down the setattr hooks. This allows LSMs to distinguish
> operations on file descriptors from operations on paths.

There's a slight problem (other than HCH not liking it) with this
approach of passing the open file in iattr:  for special files, the
struct file pointer makes no sense to the filesystem, since it is always
opened by the generic functions.

This wasn't a problem with ftruncate(), because that one only works on
regular files, but fchmod/fchown/futimes will work on special files as
well, and the filesystem interpreting file->private_data could cause
nasty bugs. 

So I think the correct solution (which was suggested by Trond and
others) is to define an f_op->fsetattr() method, which interested
filesystems can define.

Miklos

> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: John Johansen <jjohansen@suse.de>
> Cc: Miklos Szeredi <mszeredi@suse.cz>
> 
> ---
>  fs/nfsd/vfs.c      |   12 +++++++-----
>  fs/open.c          |   16 +++++++++++-----
>  include/linux/fs.h |    3 +++
>  3 files changed, 21 insertions(+), 10 deletions(-)
> 
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -413,7 +413,7 @@ static ssize_t nfsd_getxattr(struct dent
>  {
>  	ssize_t buflen;
>  
> -	buflen = vfs_getxattr(dentry, mnt, key, NULL, 0);
> +	buflen = vfs_getxattr(dentry, mnt, key, NULL, 0, NULL);
>  	if (buflen <= 0)
>  		return buflen;
>  
> @@ -421,7 +421,7 @@ static ssize_t nfsd_getxattr(struct dent
>  	if (!*buf)
>  		return -ENOMEM;
>  
> -	return vfs_getxattr(dentry, mnt, key, *buf, buflen);
> +	return vfs_getxattr(dentry, mnt, key, *buf, buflen, NULL);
>  }
>  #endif
>  
> @@ -447,7 +447,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
>  		goto out;
>  	}
>  
> -	error = vfs_setxattr(dentry, mnt, key, buf, len, 0);
> +	error = vfs_setxattr(dentry, mnt, key, buf, len, 0, NULL);
>  out:
>  	kfree(buf);
>  	return error;
> @@ -2062,12 +2062,14 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
>  
>  	mnt = fhp->fh_export->ex_mnt;
>  	if (size)
> -		error = vfs_setxattr(fhp->fh_dentry, mnt, name, value, size,0);
> +		error = vfs_setxattr(fhp->fh_dentry, mnt, name, value, size, 0,
> +				     NULL);
>  	else {
>  		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
>  			error = 0;
>  		else {
> -			error = vfs_removexattr(fhp->fh_dentry, mnt, name);
> +			error = vfs_removexattr(fhp->fh_dentry, mnt, name,
> +						NULL);
>  			if (error == -ENODATA)
>  				error = 0;
>  		}
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -594,6 +594,8 @@ asmlinkage long sys_fchmod(unsigned int 
>  		mode = inode->i_mode;
>  	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
>  	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
> +	newattrs.ia_valid |= ATTR_FILE;
> +	newattrs.ia_file = file;
>  	err = notify_change(dentry, file->f_path.mnt, &newattrs);
>  	mutex_unlock(&inode->i_mutex);
>  
> @@ -648,7 +650,7 @@ asmlinkage long sys_chmod(const char __u
>  }
>  
>  static int chown_common(struct dentry * dentry, struct vfsmount *mnt,
> -			uid_t user, gid_t group)
> +			uid_t user, gid_t group, struct file *file)
>  {
>  	struct inode * inode;
>  	int error;
> @@ -674,6 +676,10 @@ static int chown_common(struct dentry * 
>  	if (!S_ISDIR(inode->i_mode))
>  		newattrs.ia_valid |=
>  			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
> +	if (file) {
> +		newattrs.ia_file = file;
> +		newattrs.ia_valid |= ATTR_FILE;
> +	}
>  	mutex_lock(&inode->i_mutex);
>  	error = notify_change(dentry, mnt, &newattrs);
>  	mutex_unlock(&inode->i_mutex);
> @@ -692,7 +698,7 @@ asmlinkage long sys_chown(const char __u
>  	error = mnt_want_write(nd.mnt);
>  	if (error)
>  		goto out_release;
> -	error = chown_common(nd.dentry, nd.mnt, user, group);
> +	error = chown_common(nd.dentry, nd.mnt, user, group, NULL);
>  	mnt_drop_write(nd.mnt);
>  out_release:
>  	path_release(&nd);
> @@ -717,7 +723,7 @@ asmlinkage long sys_fchownat(int dfd, co
>  	error = mnt_want_write(nd.mnt);
>  	if (error)
>  		goto out_release;
> -	error = chown_common(nd.dentry, nd.mnt, user, group);
> +	error = chown_common(nd.dentry, nd.mnt, user, group, NULL);
>  	mnt_drop_write(nd.mnt);
>  out_release:
>  	path_release(&nd);
> @@ -736,7 +742,7 @@ asmlinkage long sys_lchown(const char __
>  	error = mnt_want_write(nd.mnt);
>  	if (error)
>  		goto out_release;
> -	error = chown_common(nd.dentry, nd.mnt, user, group);
> +	error = chown_common(nd.dentry, nd.mnt, user, group, NULL);
>  	mnt_drop_write(nd.mnt);
>  out_release:
>  	path_release(&nd);
> @@ -760,7 +766,7 @@ asmlinkage long sys_fchown(unsigned int 
>  		goto out_fput;
>  	dentry = file->f_path.dentry;
>  	audit_inode(NULL, dentry);
> -	error = chown_common(dentry, file->f_path.mnt, user, group);
> +	error = chown_common(dentry, file->f_path.mnt, user, group, file);
>  	mnt_drop_write(file->f_vfsmnt);
>  out_fput:
>  	fput(file);
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -362,6 +362,9 @@ struct iattr {
>  	 * Not an attribute, but an auxilary info for filesystems wanting to
>  	 * implement an ftruncate() like method.  NOTE: filesystem should
>  	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
> +	 *
> +	 * The LSM hooks also use this to distinguish operations on a file
> +	 * descriptors from operations on pathnames.
>  	 */
>  	struct file	*ia_file;
>  };
> 

