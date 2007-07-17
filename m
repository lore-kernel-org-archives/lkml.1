Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbXGQPfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbXGQPfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXGQPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:35:24 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44649 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753362AbXGQPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:35:23 -0400
X-YMail-OSG: FXFxD_UVM1nzdps6HGy5a5Jk4qKHAGk62ExsxfQBUGA40BAycZMRBOhDQw9C8YWpFNB8.OHBB9YZ7TWLICtATP7vprSGYGnc6w0POLbfA_G17Gq9Uw--
Date: Tue, 17 Jul 2007 10:35:10 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid check
Message-ID: <20070717153510.GA8464@vino.hallyn.com>
References: <20070717093008.14653.75384.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717093008.14653.75384.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Satyam Sharma (ssatyam@cse.iitk.ac.in):
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [PATCH] Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid check
> 
> Introduce is_owner_or_cap() macro in fs.h, and convert over relevant
> users to it. This is done because we want to avoid bugs in the future

I like the idea - it will make future user namespace/per-container
capability patches much cleaner by localizing a lot of the changes.

(haven't tested the patch yet, but it looks trivial enough, and I will
test later today)

thanks,
-serge

> where we check for only effective fsuid of the current task against a
> file's owning uid, without simultaneously checking for CAP_FOWNER as
> well, thus violating its semantics.
> [ XFS uses special macros and structures, and in general looked ...
> untouchable, so we leave it alone -- but it has been looked over. ]
> 
> The (current->fsuid != inode->i_uid) check in generic_permission() and
> exec_permission_lite() is left alone, because those operations are
> covered by CAP_DAC_OVERRIDE and CAP_DAC_READ_SEARCH. Similarly operations
> falling under the purview of CAP_CHOWN and CAP_LEASE are also left alone.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> ---
> 
>  fs/attr.c                |    4 ++--
>  fs/ext2/acl.c            |    2 +-
>  fs/ext2/ioctl.c          |    4 ++--
>  fs/ext3/acl.c            |    2 +-
>  fs/ext3/ioctl.c          |    6 +++---
>  fs/ext4/acl.c            |    2 +-
>  fs/ext4/ioctl.c          |    6 +++---
>  fs/fcntl.c               |    2 +-
>  fs/generic_acl.c         |    2 +-
>  fs/gfs2/acl.c            |    2 +-
>  fs/hfsplus/ioctl.c       |    2 +-
>  fs/jffs2/acl.c           |    2 +-
>  fs/jfs/ioctl.c           |    2 +-
>  fs/jfs/xattr.c           |    2 +-
>  fs/namei.c               |    2 +-
>  fs/ocfs2/ioctl.c         |    2 +-
>  fs/reiserfs/ioctl.c      |    5 ++---
>  fs/reiserfs/xattr_acl.c  |    2 +-
>  fs/utimes.c              |    2 +-
>  fs/xattr.c               |    3 +--
>  include/linux/fs.h       |    4 ++++
>  security/selinux/hooks.c |    2 +-
>  22 files changed, 32 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index a0a0c7b..f8dfc22 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -42,7 +42,7 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
>  
>  	/* Make sure a caller can chmod. */
>  	if (ia_valid & ATTR_MODE) {
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			goto error;
>  		/* Also check the setgid bit! */
>  		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
> @@ -52,7 +52,7 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
>  
>  	/* Check for setting the inode time. */
>  	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
> -		if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			goto error;
>  	}
>  fine:
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index 7c420b8..e58669e 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -464,7 +464,7 @@ ext2_xattr_set_acl(struct inode *inode, int type, const void *value,
>  
>  	if (!test_opt(inode->i_sb, POSIX_ACL))
>  		return -EOPNOTSUPP;
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	if (value) {
> diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
> index e85c482..3bcd254 100644
> --- a/fs/ext2/ioctl.c
> +++ b/fs/ext2/ioctl.c
> @@ -36,7 +36,7 @@ int ext2_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(flags, (int __user *) arg))
> @@ -74,7 +74,7 @@ int ext2_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
>  	case EXT2_IOC_GETVERSION:
>  		return put_user(inode->i_generation, (int __user *) arg);
>  	case EXT2_IOC_SETVERSION:
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
> diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
> index 1e5038d..d34e996 100644
> --- a/fs/ext3/acl.c
> +++ b/fs/ext3/acl.c
> @@ -489,7 +489,7 @@ ext3_xattr_set_acl(struct inode *inode, int type, const void *value,
>  
>  	if (!test_opt(inode->i_sb, POSIX_ACL))
>  		return -EOPNOTSUPP;
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	if (value) {
> diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
> index 965006d..4a2a02c 100644
> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -41,7 +41,7 @@ int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(flags, (int __user *) arg))
> @@ -122,7 +122,7 @@ flags_err:
>  		__u32 generation;
>  		int err;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
> @@ -181,7 +181,7 @@ flags_err:
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(rsv_window_size, (int __user *)arg))
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 9e88254..a8bae8c 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -489,7 +489,7 @@ ext4_xattr_set_acl(struct inode *inode, int type, const void *value,
>  
>  	if (!test_opt(inode->i_sb, POSIX_ACL))
>  		return -EOPNOTSUPP;
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	if (value) {
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 500567d..7b4aa45 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -40,7 +40,7 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(flags, (int __user *) arg))
> @@ -121,7 +121,7 @@ flags_err:
>  		__u32 generation;
>  		int err;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
> @@ -180,7 +180,7 @@ flags_err:
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(rsv_window_size, (int __user *)arg))
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 8e382a5..3f22e9f 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -215,7 +215,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  
>  	/* O_NOATIME can only be set by the owner or superuser */
>  	if ((arg & O_NOATIME) && !(filp->f_flags & O_NOATIME))
> -		if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  
>  	/* required for strict SunOS emulation */
> diff --git a/fs/generic_acl.c b/fs/generic_acl.c
> index 9ccb789..995d63b 100644
> --- a/fs/generic_acl.c
> +++ b/fs/generic_acl.c
> @@ -78,7 +78,7 @@ generic_acl_set(struct inode *inode, struct generic_acl_operations *ops,
>  
>  	if (S_ISLNK(inode->i_mode))
>  		return -EOPNOTSUPP;
> -	if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  	if (value) {
>  		acl = posix_acl_from_xattr(value, size);
> diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
> index 6e80844..1047a8c 100644
> --- a/fs/gfs2/acl.c
> +++ b/fs/gfs2/acl.c
> @@ -74,7 +74,7 @@ int gfs2_acl_validate_remove(struct gfs2_inode *ip, int access)
>  {
>  	if (!GFS2_SB(&ip->i_inode)->sd_args.ar_posix_acl)
>  		return -EOPNOTSUPP;
> -	if (current->fsuid != ip->i_inode.i_uid && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(&ip->i_inode))
>  		return -EPERM;
>  	if (S_ISLNK(ip->i_inode.i_mode))
>  		return -EOPNOTSUPP;
> diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
> index 79fd104..b60c0af 100644
> --- a/fs/hfsplus/ioctl.c
> +++ b/fs/hfsplus/ioctl.c
> @@ -38,7 +38,7 @@ int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(flags, (int __user *)arg))
> diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> index a46101e..65b3a1b 100644
> --- a/fs/jffs2/acl.c
> +++ b/fs/jffs2/acl.c
> @@ -435,7 +435,7 @@ static int jffs2_acl_setxattr(struct inode *inode, int type, const void *value,
>  	struct posix_acl *acl;
>  	int rc;
>  
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	if (value) {
> diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
> index fe063af..3c8663b 100644
> --- a/fs/jfs/ioctl.c
> +++ b/fs/jfs/ioctl.c
> @@ -69,7 +69,7 @@ int jfs_ioctl(struct inode * inode, struct file * filp, unsigned int cmd,
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EACCES;
>  
>  		if (get_user(flags, (int __user *) arg))
> diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
> index b2375f0..9b7f2cd 100644
> --- a/fs/jfs/xattr.c
> +++ b/fs/jfs/xattr.c
> @@ -697,7 +697,7 @@ static int can_set_system_xattr(struct inode *inode, const char *name,
>  	struct posix_acl *acl;
>  	int rc;
>  
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	/*
> diff --git a/fs/namei.c b/fs/namei.c
> index 5e2d98d..defaa47 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1576,7 +1576,7 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
>  
>  	/* O_NOATIME can only be set by the owner or superuser */
>  	if (flag & O_NOATIME)
> -		if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  
>  	/*
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index bd68c3f..87dcece 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -63,7 +63,7 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>  		goto bail_unlock;
>  
>  	status = -EACCES;
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		goto bail_unlock;
>  
>  	if (!S_ISDIR(inode->i_mode))
> diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> index b484d29..11a0fcc 100644
> --- a/fs/reiserfs/ioctl.c
> +++ b/fs/reiserfs/ioctl.c
> @@ -51,8 +51,7 @@ int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
>  			if (IS_RDONLY(inode))
>  				return -EROFS;
>  
> -			if ((current->fsuid != inode->i_uid)
> -			    && !capable(CAP_FOWNER))
> +			if (!is_owner_or_cap(inode))
>  				return -EPERM;
>  
>  			if (get_user(flags, (int __user *)arg))
> @@ -81,7 +80,7 @@ int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
>  	case REISERFS_IOC_GETVERSION:
>  		return put_user(inode->i_generation, (int __user *)arg);
>  	case REISERFS_IOC_SETVERSION:
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +		if (!is_owner_or_cap(inode))
>  			return -EPERM;
>  		if (IS_RDONLY(inode))
>  			return -EROFS;
> diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
> index 5296a29..b7e4fa4 100644
> --- a/fs/reiserfs/xattr_acl.c
> +++ b/fs/reiserfs/xattr_acl.c
> @@ -21,7 +21,7 @@ xattr_set_acl(struct inode *inode, int type, const void *value, size_t size)
>  
>  	if (!reiserfs_posixacl(inode->i_sb))
>  		return -EOPNOTSUPP;
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	if (value) {
> diff --git a/fs/utimes.c b/fs/utimes.c
> index 83a7e69..682eb63 100644
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -106,7 +106,7 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
>                  if (IS_IMMUTABLE(inode))
>                          goto dput_and_out;
>  
> -		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
> +		if (!is_owner_or_cap(inode)) {
>  			if (f) {
>  				if (!(f->f_mode & FMODE_WRITE))
>  					goto dput_and_out;
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 4523aca..a44fd92 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -60,8 +60,7 @@ xattr_permission(struct inode *inode, const char *name, int mask)
>  		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>  			return -EPERM;
>  		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
> -		    (mask & MAY_WRITE) && (current->fsuid != inode->i_uid) &&
> -		    !capable(CAP_FOWNER))
> +		    (mask & MAY_WRITE) && !is_owner_or_cap(inode))
>  			return -EPERM;
>  	}
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e687808..aa33a3f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -283,6 +283,7 @@ extern int dir_notify_enable;
>  #include <linux/init.h>
>  #include <linux/pid.h>
>  #include <linux/mutex.h>
> +#include <linux/capability.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/semaphore.h>
> @@ -988,6 +989,9 @@ enum {
>  #define put_fs_excl() atomic_dec(&current->fs_excl)
>  #define has_fs_excl() atomic_read(&current->fs_excl)
>  
> +#define is_owner_or_cap(inode)	\
> +	((current->fsuid == (inode)->i_uid) || capable(CAP_FOWNER))
> +
>  /* not quite ready to be deprecated, but... */
>  extern void lock_super(struct super_block *);
>  extern void unlock_super(struct super_block *);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 78c3f98..520b999 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2318,7 +2318,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
>  	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
>  		return -EOPNOTSUPP;
>  
> -	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!is_owner_or_cap(inode))
>  		return -EPERM;
>  
>  	AVC_AUDIT_DATA_INIT(&ad,FS);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
