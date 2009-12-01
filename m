Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZLAEf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZLAEf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZLAEfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:35:24 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51049 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZLAEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:35:23 -0500
Date: Mon, 30 Nov 2009 23:34:57 -0500
Message-Id: <200912010434.nB14YvOE030711@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 39/41] union-mount: Ignore read-only file system in permission checks 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:37 PDT."
             <1256152779-10054-40-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-40-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> In certain cases, we check a file for write access before it has been
> copied up to the top-level fs.  We don't want to fail because the
> bottom layer is read-only - of course it is - so skip that check in
> those cases.
> 
> Thanks to Felix Fietkau <nbd@openwrt.org> for a bug fix.
> 
> XXX - Document when to call union_permission() vs. inode_permission()
> XXX - Kinda gross.  Probably a simpler solution.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c            |   21 +++++++++++++++++----
>  fs/open.c             |    8 ++++++--
>  fs/union.c            |   32 ++++++++++++++++++++++++++++++--
>  include/linux/fs.h    |    1 +
>  include/linux/union.h |    2 ++
>  5 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 61e94aa..a8d3acf 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -230,16 +230,17 @@ int generic_permission(struct inode *inode, int mask,
>  }
>  
>  /**
> - * inode_permission  -  check for access rights to a given inode
> + * __inode_permission  -  check for access rights to a given inode
>   * @inode:	inode to check permission on
>   * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
> + * @rofs:	check for read-only fs
>   *
>   * Used to check for read/write/execute permissions on an inode.
>   * We use "fsuid" for this, letting us set arbitrary permissions
>   * for filesystem access without changing the "normal" uids which
>   * are used for other things.
>   */
> -int inode_permission(struct inode *inode, int mask)
> +int __inode_permission(struct inode *inode, int mask, int rofs)
>  {
>  	int retval;

rofs can be a boolean.

While I normally prefer to avoid magic flags passed to a function to change
its behavior, in this case it's a small and obvious change.  I could use
your __inode_permission as is in Unionfs today, if it was upstream; in
Unionfs I had to copy inode_permission to my code, and remove the EROFS
test.

>  
> @@ -249,7 +250,7 @@ int inode_permission(struct inode *inode, int mask)
>  		/*
>  		 * Nobody gets write access to a read-only fs.
>  		 */
> -		if (IS_RDONLY(inode) &&
> +		if ((rofs & IS_RDONLY(inode)) &&
>  		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
>  			return -EROFS;
>  
> @@ -277,6 +278,18 @@ int inode_permission(struct inode *inode, int mask)
>  }
>  
>  /**
> + * inode_permission  -  check for access rights to a given inode
> + * @inode:	inode to check permission on
> + * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
> + *
> + * This version pays attention to the MS_RDONLY flag on the fs.
> + */
> +int inode_permission(struct inode *inode, int mask)
> +{
> +	return __inode_permission(inode, mask, 1);
> +}
> +
> +/**
>   * file_permission  -  check for additional access rights to a given file
>   * @file:	file to check access rights for
>   * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
> @@ -2129,7 +2142,7 @@ int may_open(struct path *path, int acc_mode, int flag)
>  		break;
>  	}
>  
> -	error = inode_permission(inode, acc_mode);
> +	error = union_permission(path, acc_mode);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/open.c b/fs/open.c
> index dd98e80..3df5a1b 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -30,6 +30,7 @@
>  #include <linux/audit.h>
>  #include <linux/falloc.h>
>  #include <linux/fs_struct.h>
> +#include <linux/union.h>
>  
>  int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> @@ -333,6 +334,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
>  		error = security_path_truncate(&file->f_path, length,
>  					       ATTR_MTIME|ATTR_CTIME);
>  	if (!error)
> +		/* Already copied up for union, opened with write */
>  		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
>  out_putf:
>  	fput(file);
> @@ -493,7 +495,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
>  			goto out_path_release;
>  	}
>  
> -	res = inode_permission(inode, mode | MAY_ACCESS);
> +	res = union_permission(&path, mode | MAY_ACCESS);
> +
>  	/* SuS v2 requires we report a read only fs too */
>  	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
>  		goto out_path_release;
> @@ -507,7 +510,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
>  	 * inherently racy and know that the fs may change
>  	 * state before we even see this result.
>  	 */
> -	if (__mnt_is_readonly(path.mnt))
> +	if ((!is_unionized(path.dentry, path.mnt) &&
> +	     (__mnt_is_readonly(path.mnt))))
>  		res = -EROFS;
>  
>  out_path_release:
> diff --git a/fs/union.c b/fs/union.c
> index d56b829..8d94b22 100644
> --- a/fs/union.c
> +++ b/fs/union.c
> @@ -390,6 +390,30 @@ static int union_relookup_topmost(struct nameidata *nd, int flags)
>  	return err;
>  }
>  
> +
> +/**
> + * union_permission  -  check for access rights to a given inode
> + * @inode:	inode to check permission on
> + * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
> + *
> + * In a union mount, the top layer is always read-write and the bottom
> + * is always read-only.  Ignore the read-only flag on the lower fs.
> + *
> + * Only need for certain activities, like checking to see if write
> + * access is ok.
> + */
> +
> +int union_permission(struct path *path, int mask)
> +{
> +	struct inode *inode = path->dentry->d_inode;
> +
> +	if (!is_unionized(path->dentry, path->mnt))
> +		return inode_permission(inode, mask);
> +
> +	/* Tell __inode_permission to ignore MS_RDONLY */
> +	return __inode_permission(inode, mask, 0);
> +}
> +
>  /*
>   * union_create_topmost - create the topmost path component
>   * @nd: pointer to nameidata of the base directory
> @@ -489,6 +513,9 @@ static int union_copy_file(struct dentry *old_dentry, struct vfsmount *old_mnt,
>  	if (IS_ERR(new_file))
>  		goto fput_old;
>  
> +	/* XXX be smart by using a length param, which indicates max
> +	 * data we'll want (e.g., we are about to truncate to 0 or 10
> +	 * bytes or something */

Useful comment, but not here: I'd put it right in the very first
copyup-related patch.  And add it as "todo" to the design doc.

>  	size = i_size_read(old_file->f_path.dentry->d_inode);
>  	if (((size_t)size != size) || ((ssize_t)size != size)) {
>  		ret = -EFBIG;
> @@ -516,7 +543,8 @@ static int union_copy_file(struct dentry *old_dentry, struct vfsmount *old_mnt,
>   * The topmost directory @new_nd must already be locked. Creates the topmost
>   * file if it doesn't exist yet.
>   */
> -int __union_copyup(struct path *old, struct nameidata *new_nd, struct path *new)
> +int __union_copyup(struct path *old, struct nameidata *new_nd,
> +		   struct path *new)
>  {
>  	struct dentry *dentry;
>  	int error;
> @@ -581,7 +609,7 @@ out_dput:
>   * @nd: nameidata pointer to the file
>   * @flags: flags given to open_namei
>   */
> -int union_copyup(struct nameidata *nd, int flags)
> +int union_copyup(struct nameidata *nd, int flags /* XXX not used */)

If not used, then why not remove it?

>  {
>  	struct qstr this;
>  	char *name;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 57690ab..38fb113 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2106,6 +2106,7 @@ extern void emergency_remount(void);
>  extern sector_t bmap(struct inode *, sector_t);
>  #endif
>  extern int notify_change(struct dentry *, struct iattr *);
> +extern int __inode_permission(struct inode *inode, int mask, int rofs);
>  extern int inode_permission(struct inode *, int);
>  extern int generic_permission(struct inode *, int,
>  		int (*check_acl)(struct inode *, int));
> diff --git a/include/linux/union.h b/include/linux/union.h
> index a0656b3..92654e0 100644
> --- a/include/linux/union.h
> +++ b/include/linux/union.h
> @@ -58,6 +58,7 @@ extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
>  extern int __union_copyup(struct path *, struct nameidata *, struct path *);
>  extern int union_copyup(struct nameidata *, int);
>  extern int union_copyup_dir(struct path *path);
> +extern int union_permission(struct path *, int);
>  
>  #else /* CONFIG_UNION_MOUNT */
>  
> @@ -76,6 +77,7 @@ extern int union_copyup_dir(struct path *path);
>  #define __union_copyup(x, y, z)		({ BUG(); (0); })
>  #define union_copyup(x, y)		({ (0); })
>  #define union_copyup_dir(x)		({ BUG(); (0); })
> +#define union_permission(x, y)		inode_permission((x)->dentry->d_inode, y)
>  
>  #endif	/* CONFIG_UNION_MOUNT */
>  #endif	/* __KERNEL__ */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
