Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYBNIbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYBNIbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYBNIbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:31:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34994 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYBNIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:31:06 -0500
To: menage@google.com
CC: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <47B283EB.8070209@google.com> (message from Paul Menage on Tue,
	12 Feb 2008 21:45:15 -0800)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
Message-Id: <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 09:30:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please always CC linux-fsdevel on VFS patches!

> From: Paul Menage <menage@google.com>
> 
> Add a new mount() flag, MS_BIND_FLAGS.
> 
> MS_BIND_FLAGS indicates that a bind mount should take its per-mount flags
> from the arguments passed to mount() rather than from the source
> mountpoint.

This is useful, but...

> This flag allows you to create a bind mount with the desired per-mount
> flags in a single operation, rather than having to do a bind mount
> followed by a remount, which is fiddly and can block for non-trivial
> periods of time (on sb->s_umount?).
> 
> For recursive bind mounts, only the root of the tree being bound
> inherits the per-mount flags from the mount() arguments; sub-mounts
> inherit their per-mount flags from the source tree as usual.

This is rather strange behavior.  I think it would be much better, if
setting mount flags would work for recursive operations as well.  Also
what we really need is not resetting all the mount flags to some
predetermined values, but to be able to set or clear each flag
individually.

For example, with the per-mount-read-only thing the most useful
application would be to just set the read-only flag and leave the
others alone.

And this is where we usually conclude, that a new userspace mount API
is long overdue.  So for starters, how about a new syscall for bind
mounts:

int mount_bind(const char *src, const char *dst, unsigned flags,
		 unsigned mnt_flags);

or something?

Miklos

> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> 
> ---
>  fs/namespace.c     |   36 +++++++++++++++++++++++++-----------
>  include/linux/fs.h |    2 ++
>  2 files changed, 27 insertions(+), 11 deletions(-)
> 
> Index: 2.6.24-mm1-bindflags/fs/namespace.c
> ===================================================================
> --- 2.6.24-mm1-bindflags.orig/fs/namespace.c
> +++ 2.6.24-mm1-bindflags/fs/namespace.c
> @@ -512,13 +512,13 @@ static struct vfsmount *skip_mnt_tree(st
>  }
>  
>  static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
> -					int flag)
> +				  int flag, int mnt_flags)
>  {
>  	struct super_block *sb = old->mnt_sb;
>  	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
>  
>  	if (mnt) {
> -		mnt->mnt_flags = old->mnt_flags;
> +		mnt->mnt_flags = mnt_flags;
>  		atomic_inc(&sb->s_active);
>  		mnt->mnt_sb = sb;
>  		mnt->mnt_root = dget(root);
> @@ -1095,8 +1095,9 @@ static int lives_below_in_same_fs(struct
>  	}
>  }
>  
> -struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> -					int flag)
> +static struct vfsmount *
> +__copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> +	    int flag, int mnt_flags)
>  {
>  	struct vfsmount *res, *p, *q, *r, *s;
>  	struct nameidata nd;
> @@ -1104,7 +1105,7 @@ struct vfsmount *copy_tree(struct vfsmou
>  	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
>  		return NULL;
>  
> -	res = q = clone_mnt(mnt, dentry, flag);
> +	res = q = clone_mnt(mnt, dentry, flag, mnt_flags);
>  	if (!q)
>  		goto Enomem;
>  	q->mnt_mountpoint = mnt->mnt_mountpoint;
> @@ -1126,7 +1127,7 @@ struct vfsmount *copy_tree(struct vfsmou
>  			p = s;
>  			nd.path.mnt = q;
>  			nd.path.dentry = p->mnt_mountpoint;
> -			q = clone_mnt(p, p->mnt_root, flag);
> +			q = clone_mnt(p, p->mnt_root, flag, p->mnt_flags);
>  			if (!q)
>  				goto Enomem;
>  			spin_lock(&vfsmount_lock);
> @@ -1146,6 +1147,11 @@ Enomem:
>  	}
>  	return NULL;
>  }
> +struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> +			   int flag)
> +{
> +	return __copy_tree(mnt, dentry, flag, mnt->mnt_flags);
> +}
>  
>  struct vfsmount *collect_mounts(struct vfsmount *mnt, struct dentry *dentry)
>  {
> @@ -1320,7 +1326,8 @@ static int do_change_type(struct nameida
>  /*
>   * do loopback mount.
>   */
> -static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
> +static int do_loopback(struct nameidata *nd, char *old_name, int flags,
> +		       int mnt_flags)
>  {
>  	struct nameidata old_nd;
>  	struct vfsmount *mnt = NULL;
> @@ -1342,10 +1349,15 @@ static int do_loopback(struct nameidata 
>  		goto out;
>  
>  	err = -ENOMEM;
> -	if (recurse)
> -		mnt = copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0);
> +	/* Use the source mount flags unless the user passed MS_BIND_FLAGS */
> +	if (!(flags & MS_BIND_FLAGS))
> +		mnt_flags = old_nd.path.mnt->mnt_flags;
> +	if (flags & MS_REC)
> +		mnt = __copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0,
> +				  mnt_flags);
>  	else
> -		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0);
> +		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0,
> +				mnt_flags);
>  
>  	if (!mnt)
>  		goto out;
> @@ -1874,7 +1886,9 @@ long do_mount(char *dev_name, char *dir_
>  		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
>  				    data_page);
>  	else if (flags & MS_BIND)
> -		retval = do_loopback(&nd, dev_name, flags & MS_REC);
> +		retval = do_loopback(&nd, dev_name,
> +				     flags & (MS_REC | MS_BIND_FLAGS),
> +				     mnt_flags);
>  	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>  		retval = do_change_type(&nd, flags);
>  	else if (flags & MS_MOVE)
> Index: 2.6.24-mm1-bindflags/include/linux/fs.h
> ===================================================================
> --- 2.6.24-mm1-bindflags.orig/include/linux/fs.h
> +++ 2.6.24-mm1-bindflags/include/linux/fs.h
> @@ -125,6 +125,8 @@ extern int dir_notify_enable;
>  #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
>  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> +#define MS_BIND_FLAGS	(1<<24) /* For MS_BIND, take mnt_flags from
> +				 * args, not from source mountpoint */
>  #define MS_ACTIVE	(1<<30)
>  #define MS_NOUSER	(1<<31)
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
