Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZK3DEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZK3DEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZK3DEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:04:47 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:59923 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZK3DEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:04:45 -0500
Date: Sun, 29 Nov 2009 22:04:16 -0500
Message-Id: <200911300304.nAU34G18007753@agora.fsl.cs.sunysb.edu>
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
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 10/41] whiteout: Add vfs_whiteout() and whiteout inode operation 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:08 PDT."
             <1256152779-10054-11-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-11-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Simply white-out a given directory entry. This functionality is usually used
> in the sense of unlink. Therefore the given dentry can still be in-use and
> contains an in-use inode. The filesystems inode operation has to do what
> unlink or rmdir would in that case. Since the dentry still might be in-use
> we have to provide a fresh unhashed dentry that is used as the whiteout
> dentry instead. The given dentry is dropped and the whiteout dentry is
> rehashed instead.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c            |    4 +-
>  fs/namei.c             |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |    6 +++
>  include/linux/fs.h     |    3 +
>  4 files changed, 116 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 3415e9e..0fcae4b 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1076,8 +1076,10 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
>  /* the caller must hold dcache_lock */
>  static void __d_instantiate(struct dentry *dentry, struct inode *inode)
>  {
> -	if (inode)
> +	if (inode) {
> +		dentry->d_flags &= ~DCACHE_WHITEOUT;
>  		list_add(&dentry->d_alias, &inode->i_dentry);
> +	}
>  	dentry->d_inode = inode;
>  	fsnotify_d_instantiate(dentry, inode);
>  }
> diff --git a/fs/namei.c b/fs/namei.c
> index 46cf1cb..d2fc8c9 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2169,6 +2169,110 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
>  	return sys_mkdirat(AT_FDCWD, pathname, mode);
>  }
>  
> +
> +/* Checks on the victim for whiteout */
> +static inline int may_whiteout(struct inode *dir, struct dentry *victim,
> +			       int isdir)

Why not make 'isdir' a boolean?

I'd prefer to see more documentation above this function: explain what each
arg does, return value, etc.

> +{
> +	int err;
> +
> +	/* from may_create() */
> +	if (IS_DEADDIR(dir))
> +		return -ENOENT;
> +	err = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	if (err)
> +		return err;
> +
> +	/* from may_delete() */
> +	if (IS_APPEND(dir))
> +		return -EPERM;
> +	if (!victim->d_inode)
> +		return 0;
> +	if (check_sticky(dir, victim->d_inode) ||
> +	    IS_APPEND(victim->d_inode) ||
> +	    IS_IMMUTABLE(victim->d_inode))
> +		return -EPERM;
> +	if (isdir) {
> +		if (!S_ISDIR(victim->d_inode->i_mode))
> +			return -ENOTDIR;
> +		if (IS_ROOT(victim))
> +			return -EBUSY;
> +	} else if (S_ISDIR(victim->d_inode->i_mode))
> +		return -EISDIR;
> +	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
> +		return -EBUSY;
> +	return 0;
> +}
> +
> +/**
> + * vfs_whiteout: creates a white-out for the given directory entry
> + * @dir: parent inode
> + * @dentry: directory entry to white-out

Nit: is it 'white-out' or 'whiteout'?  Whatever you choose is fine, but
please use consistent hypenation/spelling everywhere (code, comments, and
documentation).

> + *
> + * Simply white-out a given directory entry. This functionality is usually used
> + * in the sense of unlink. Therefore the given dentry can still be in-use and
> + * contains an in-use inode. The filesystem has to do what unlink or rmdir

Nit: other than the line of comment just above, the other two instances of
"in-use" in this comment (and the patch header) should be changed to "in
use" (no hyphen).

> + * would in that case. Since the dentry still might be in-use we have to
> + * provide a fresh unhashed dentry that whiteout can fill the new inode into.
> + * In that case the given dentry is dropped and the fresh dentry containing the
> + * whiteout is rehashed instead. If the given dentry is unused, the whiteout
> + * inode is instantiated into it instead.
> + *
> + * After this returns with success, don't make any assumptions about the inode.

What kinds of assumptions one should not make?  Perhaps it'd be better to
document what you can/should assume, instead of what you shouldn't (or
both?)

> + * Just dput() it dentry.

The last line is awkward: do you mean "its dentry"?

> + */
> +int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
> +{
> +	int err;
> +	struct inode *old_inode = dentry->d_inode;
> +	struct dentry *parent, *whiteout;
> +
> +	err = may_whiteout(dir, dentry, isdir);
> +	if (err)
> +		return err;
> +
> +	BUG_ON(dentry->d_parent->d_inode != dir);
> +
> +	if (!dir->i_op || !dir->i_op->whiteout)
> +		return -EOPNOTSUPP;
> +
> +	if (old_inode) {
> +		vfs_dq_init(dir);
> +
> +		mutex_lock(&old_inode->i_mutex);
> +		if (isdir)
> +			dentry_unhash(dentry);
> +		if (d_mountpoint(dentry))
> +			err = -EBUSY;
> +		else {
> +			if (isdir)
> +				err = security_inode_rmdir(dir, dentry);
> +			else
> +				err = security_inode_unlink(dir, dentry);
> +		}
> +	}
> +
> +	parent = dget_parent(dentry);
> +	whiteout = d_alloc_name(parent, dentry->d_name.name);
> +
> +	if (!err)
> +		err = dir->i_op->whiteout(dir, dentry, whiteout);
> +
> +	if (old_inode) {
> +		mutex_unlock(&old_inode->i_mutex);
> +		if (!err) {
> +			fsnotify_link_count(old_inode);
> +			d_delete(dentry);
> +		}
> +		if (isdir)
> +			dput(dentry);
> +	}
> +
> +	dput(whiteout);
> +	dput(parent);
> +	return err;
> +}
> +
>  /*
>   * We try to drop the dentry early: we should have
>   * a usage count of 2 if we're the only user of this
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 30b93b2..7648b49 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -183,6 +183,7 @@ d_iput:		no		no		no       yes
>  #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
>  
>  #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
> +#define DCACHE_WHITEOUT		0x0080	/* This negative dentry is a whiteout */
>  
>  #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
>  
> @@ -358,6 +359,11 @@ static inline int d_unlinked(struct dentry *dentry)
>  	return d_unhashed(dentry) && !IS_ROOT(dentry);
>  }
>  
> +static inline int d_is_whiteout(struct dentry *dentry)
> +{
> +	return (dentry->d_flags & DCACHE_WHITEOUT);
> +}
> +
>  static inline struct dentry *dget_parent(struct dentry *dentry)
>  {
>  	struct dentry *ret;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 5fb7343..04a9870 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -205,6 +205,7 @@ struct inodes_stat_t {
>  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
>  #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
> +#define MS_WHITEOUT	(1<<26) /* fs does support white-out filetype */
>  #define MS_ACTIVE	(1<<30)
>  #define MS_NOUSER	(1<<31)
>  
> @@ -1422,6 +1423,7 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
>  extern int vfs_rmdir(struct inode *, struct dentry *);
>  extern int vfs_unlink(struct inode *, struct dentry *);
>  extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
> +extern int vfs_whiteout(struct inode *, struct dentry *, int);
>  
>  /*
>   * VFS dentry helper functions.
> @@ -1526,6 +1528,7 @@ struct inode_operations {
>  	int (*mkdir) (struct inode *,struct dentry *,int);
>  	int (*rmdir) (struct inode *,struct dentry *);
>  	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
> +	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
>  	int (*rename) (struct inode *, struct dentry *,
>  			struct inode *, struct dentry *);
>  	int (*readlink) (struct dentry *, char __user *,int);

Nit: I'm curious why you decided to add the function proto for (*whiteout)
where you did?  inode_operations isn't sorted alphabetically, so why not
just append it to the end of the op list?

> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
