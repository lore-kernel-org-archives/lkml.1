Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYBSOZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYBSOZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYBSOZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:25:07 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:51823 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYBSOZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:25:04 -0500
Subject: Re: [PATCH] Make sysctl a separate filesystem
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <47B56BF2.4020600@openvz.org>
References: <47B56BF2.4020600@openvz.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 19 Feb 2008 09:24:16 -0500
Message-Id: <1203431056.9902.43.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 13:39 +0300, Pavel Emelyanov wrote:
> Sysctl files/inodes now have their own readdir and lookup
> methods, so there is one step left in turning this into a 
> separate filesystem.
> 
> The benefits of this are:
> 
> 1. this will allow to remove a fancy revalidation rules from
>    sysctl dentries (will be in a separate patch);
> 2. the same approach will make /proc/net implementation MUCH
>    cleaner in respect to net namespaces interaction, i.e.
>    no racy shadows and no revalidation for proc entries in 
>    this subdir;

If you apply this approach to proc net, we'll have to figure out how to
preserve the selinux checking on proc net, which presently relies on
being able to walk the proc_dir_entry tree (selinux_proc_get_sid).  In
the sysctl case, the inodes were marked with S_PRIVATE to disable the
SELinux handling and we rely on the security_sysctl() hook in
sysctl_perm() for permission checking, but that leverages the ctl_table
tree (selinux_sysctl_get_sid).

> 3. sysctl inodes are now smaller than the procfs ones.
> 
> Note: update your initscripts to mount sysctl filesystem 
> right after the proc is mounted in order not to lose your
> /etc/sysctl.conf configuration (and optionally fstab).
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
> 
> ---
> 
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 1c81c8f..47dec4b 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -11,11 +11,6 @@
>  
>  #include <linux/proc_fs.h>
>  
> -#ifdef CONFIG_PROC_SYSCTL
> -extern int proc_sys_init(void);
> -#else
> -static inline void proc_sys_init(void) { }
> -#endif
>  #ifdef CONFIG_NET
>  extern int proc_net_init(void);
>  #else
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 614c34b..1b52f43 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -1,11 +1,9 @@
>  /*
>   * /proc/sys support
>   */
> -
> +#include <linux/magic.h>
>  #include <linux/sysctl.h>
> -#include <linux/proc_fs.h>
>  #include <linux/security.h>
> -#include "internal.h"
>  
>  static struct dentry_operations proc_sys_dentry_operations;
>  static const struct file_operations proc_sys_file_operations;
> @@ -28,22 +26,26 @@ static void proc_sys_refresh_inode(struct inode *inode, struct ctl_table *table)
>  	}
>  }
>  
> +static inline long inode_depth(struct inode *ino)
> +{
> +	return (long)ino->i_private;
> +}
> +
> +static inline void set_inode_depth(struct inode *ino, long depth)
> +{
> +	ino->i_private = (void *)depth;
> +}
> +
>  static struct inode *proc_sys_make_inode(struct inode *dir, struct ctl_table *table)
>  {
>  	struct inode *inode;
> -	struct proc_inode *dir_ei, *ei;
> -	int depth;
>  
>  	inode = new_inode(dir->i_sb);
>  	if (!inode)
>  		goto out;
>  
>  	/* A directory is always one deeper than it's parent */
> -	dir_ei = PROC_I(dir);
> -	depth = dir_ei->fd + 1;
> -
> -	ei = PROC_I(inode);
> -	ei->fd = depth;
> +	set_inode_depth(inode, inode_depth(dir) + 1);
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
>  	inode->i_op = &proc_sys_inode_operations;
>  	inode->i_fop = &proc_sys_file_operations;
> @@ -56,10 +58,7 @@ out:
>  static struct dentry *proc_sys_ancestor(struct dentry *dentry, int depth)
>  {
>  	for (;;) {
> -		struct proc_inode *ei;
> -
> -		ei = PROC_I(dentry->d_inode);
> -		if (ei->fd == depth)
> +		if (inode_depth(dentry->d_inode) == depth)
>  			break; /* found */
>  
>  		dentry = dentry->d_parent;
> @@ -93,12 +92,9 @@ static struct ctl_table *proc_sys_lookup_table(struct dentry *dentry,
>  						struct ctl_table *table)
>  {
>  	struct dentry *ancestor;
> -	struct proc_inode *ei;
>  	int depth, i;
>  
> -	ei = PROC_I(dentry->d_inode);
> -	depth = ei->fd;
> -
> +	depth = inode_depth(dentry->d_inode);
>  	if (depth == 0)
>  		return table;
>  
> @@ -385,7 +381,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
>  	int error;
>  
>  	head = NULL;
> -	depth = PROC_I(inode)->fd;
> +	depth = inode_depth(inode);
>  
>  	/* First check the cached permissions, in case we don't have
>  	 * enough information to lookup the sysctl table entry.
> @@ -466,13 +462,56 @@ static struct dentry_operations proc_sys_dentry_operations = {
>  	.d_revalidate	= proc_sys_revalidate,
>  };
>  
> -static struct proc_dir_entry *proc_sys_root;
> +static const struct super_operations sysctl_ops = {
> +	.statfs		= simple_statfs,
> +	.drop_inode	= generic_delete_inode,
> +};
>  
> -int proc_sys_init(void)
> +static int sysctl_fill_super(struct super_block *sb, void *data, int flags)
>  {
> -	proc_sys_root = proc_mkdir("sys", NULL);
> -	proc_sys_root->proc_iops = &proc_sys_inode_operations;
> -	proc_sys_root->proc_fops = &proc_sys_file_operations;
> -	proc_sys_root->nlink = 0;
> +	struct inode *ino;
> +
> +	sb->s_flags |= MS_NODIRATIME | MS_NOSUID | MS_NOEXEC | MS_NODEV;
> +	sb->s_blocksize = 1024;
> +	sb->s_blocksize_bits = 10;
> +	sb->s_magic = PROC_SUPER_MAGIC;
> +	sb->s_op = &sysctl_ops;
> +	sb->s_time_gran = 1;
> +
> +	ino = new_inode(sb);
> +	if (ino == NULL)
> +		return -ENOMEM;
> +
> +	ino->i_op = &proc_sys_inode_operations;
> +	ino->i_fop = &proc_sys_file_operations;
> +	set_inode_depth(ino, 0);
> +	ino->i_uid = 0;
> +	ino->i_gid = 0;
> +	ino->i_mode = 0555 | S_IFDIR;
> +
> +	sb->s_root = d_alloc_root(ino);
> +	if (sb->s_root == NULL) {
> +		iput(ino);
> +		return -ENOMEM;
> +	}
> +
>  	return 0;
>  }
> +
> +static int sysctl_get_sb(struct file_system_type *fs_type,
> +	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +	return get_sb_single(fs_type, flags, data, sysctl_fill_super, mnt);
> +}
> +
> +static struct file_system_type sysctl_fs = {
> +	.name = "sysctl",
> +	.get_sb = sysctl_get_sb,
> +	.kill_sb = kill_anon_super,
> +};
> +
> +static int __init proc_sys_init(void)
> +{
> +	return register_filesystem(&sysctl_fs);
> +}
> +module_init(proc_sys_init);
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index ef0fb57..9035938 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -129,6 +129,7 @@ void __init proc_root_init(void)
>  	proc_root_fs = proc_mkdir("fs", NULL);
>  	proc_root_driver = proc_mkdir("driver", NULL);
>  	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
> +	proc_mkdir("sys", NULL);
>  #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
>  	/* just give it a mountpoint */
>  	proc_mkdir("openprom", NULL);
> @@ -138,7 +139,6 @@ void __init proc_root_init(void)
>  	proc_device_tree_init();
>  #endif
>  	proc_bus = proc_mkdir("bus", NULL);
> -	proc_sys_init();
>  }
>  
>  static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Stephen Smalley
National Security Agency

