Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZJ2FcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZJ2FcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZJ2FcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:32:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50198 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbZJ2FcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:32:02 -0400
Date: Thu, 29 Oct 2009 00:32:08 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 02/25] LSM: Add security_path_chroot().
Message-ID: <20091029053208.GD11558@us.ibm.com>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.457898741@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004125327.457898741@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> This patch allows pathname based LSM modules to check chroot() operations.
> 
> This hook is used by TOMOYO.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/open.c                |    3 +++
>  include/linux/security.h |   11 +++++++++++
>  security/capability.c    |    6 ++++++
>  security/security.c      |    5 +++++
>  4 files changed, 25 insertions(+)
> 
> --- security-testing-2.6.orig/fs/open.c
> +++ security-testing-2.6/fs/open.c
> @@ -587,6 +587,9 @@ SYSCALL_DEFINE1(chroot, const char __use
>  	error = -EPERM;
>  	if (!capable(CAP_SYS_CHROOT))
>  		goto dput_and_out;
> +	error = security_path_chroot(&path);
> +	if (error)
> +		goto dput_and_out;
> 
>  	set_fs_root(current->fs, &path);
>  	error = 0;
> --- security-testing-2.6.orig/include/linux/security.h
> +++ security-testing-2.6/include/linux/security.h
> @@ -459,6 +459,10 @@ static inline void security_free_mnt_opt
>   *	@uid contains new owner's ID.
>   *	@gid contains new group's ID.
>   *	Return 0 if permission is granted.
> + * @path_chroot:
> + *	Check for permission to change root directory.
> + *	@path contains the path structure.
> + *	Return 0 if permission is granted.
>   * @inode_readlink:
>   *	Check the permission to read the symbolic link.
>   *	@dentry contains the dentry structure for the file link.
> @@ -1503,6 +1507,7 @@ struct security_operations {
>  	int (*path_chmod) (struct dentry *dentry, struct vfsmount *mnt,
>  			   mode_t mode);
>  	int (*path_chown) (struct path *path, uid_t uid, gid_t gid);
> +	int (*path_chroot) (struct path *path);
>  #endif
> 
>  	int (*inode_alloc_security) (struct inode *inode);
> @@ -2970,6 +2975,7 @@ int security_path_rename(struct path *ol
>  int security_path_chmod(struct dentry *dentry, struct vfsmount *mnt,
>  			mode_t mode);
>  int security_path_chown(struct path *path, uid_t uid, gid_t gid);
> +int security_path_chroot(struct path *path);
>  #else	/* CONFIG_SECURITY_PATH */
>  static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
>  {
> @@ -3031,6 +3037,11 @@ static inline int security_path_chown(st
>  {
>  	return 0;
>  }
> +
> +static inline int security_path_chroot(struct path *path)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_SECURITY_PATH */
> 
>  #ifdef CONFIG_KEYS
> --- security-testing-2.6.orig/security/capability.c
> +++ security-testing-2.6/security/capability.c
> @@ -319,6 +319,11 @@ static int cap_path_chown(struct path *p
>  {
>  	return 0;
>  }
> +
> +static int cap_path_chroot(struct path *root)
> +{
> +	return 0;
> +}
>  #endif
> 
>  static int cap_file_permission(struct file *file, int mask)
> @@ -990,6 +995,7 @@ void security_fixup_ops(struct security_
>  	set_to_cap_if_null(ops, path_truncate);
>  	set_to_cap_if_null(ops, path_chmod);
>  	set_to_cap_if_null(ops, path_chown);
> +	set_to_cap_if_null(ops, path_chroot);
>  #endif
>  	set_to_cap_if_null(ops, file_permission);
>  	set_to_cap_if_null(ops, file_alloc_security);
> --- security-testing-2.6.orig/security/security.c
> +++ security-testing-2.6/security/security.c
> @@ -449,6 +449,11 @@ int security_path_chown(struct path *pat
>  		return 0;
>  	return security_ops->path_chown(path, uid, gid);
>  }
> +
> +int security_path_chroot(struct path *path)
> +{
> +	return security_ops->path_chroot(path);
> +}
>  #endif
> 
>  int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
