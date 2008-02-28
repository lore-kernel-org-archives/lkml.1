Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYB1FSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYB1FSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYB1FRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:17:53 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbYB1FRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:17:50 -0500
Date: Wed, 27 Feb 2008 21:17:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-Id: <20080227211723.d5d27c09.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 12:23:55 +0900 (WST) Ian Kent <raven@themaw.net> wrote:

> Hi Andrew,
> 
> Patch to add miscellaneous device to autofs4 module for
> ioctls.

Could you please document the new kernel interface which you're proposing? 
In Docmentation/ or in the changelog?

We seem to be passing some string into a miscdevice ioctl and getting some
results back.  Be aware that this won't be a terribly popular proposal, so
I'd suggest that you fully describe the problem which it's trying to solve,
and how it solves it, and why the various alternatives (sysfs, netlink,
mount options, etc) were judged unsuitable.


> ...
> 
> --- linux-2.6.25-rc2-mm1/fs/autofs4/init.c.device-node-ioctl	2008-01-25 07:58:37.000000000 +0900
> +++ linux-2.6.25-rc2-mm1/fs/autofs4/init.c	2008-02-22 11:51:41.000000000 +0900
> @@ -29,11 +29,20 @@ static struct file_system_type autofs_fs
>  
>  static int __init init_autofs4_fs(void)
>  {
> -	return register_filesystem(&autofs_fs_type);
> +	int err;
> +
> +	err = register_filesystem(&autofs_fs_type);
> +	if (err)
> +		return err;
> +
> +	err = autofs_dev_ioctl_init();
> +
> +	return err;
>  }

We should run unregister_filesystem() if autofs_dev_ioctl_init() fails.

>  static void __exit exit_autofs4_fs(void)
>  {
> +	autofs_dev_ioctl_exit();
>  	unregister_filesystem(&autofs_fs_type);
>  }
>  
> diff -up linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.device-node-ioctl linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h
> --- linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.device-node-ioctl	2008-02-22 11:51:41.000000000 +0900
> +++ linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h	2008-02-22 11:51:41.000000000 +0900
> @@ -14,6 +14,7 @@
>  /* Internal header file for autofs */
>  
>  #include <linux/auto_fs4.h>
> +#include <linux/auto_dev-ioctl.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  
> @@ -40,6 +41,16 @@
>  #define DPRINTK(fmt,args...) do {} while(0)
>  #endif
>  
> +#define WARN(fmt,args...) \
> +do {			  \
> +	printk("KERN_WARNING pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); \
> +} while(0)
> +
> +#define ERROR(fmt,args...) \
> +do {			  \
> +	printk("KERN_ERR pid %d: %s: " fmt "\n" , current->pid , __FUNCTION__ , ##args); \
> +} while(0)

Please always pass all diffs through scripts/checkpatch.pl.

>  /* Unified info structure.  This is pointed to by both the dentry and
>     inode structures.  Each file in the filesystem has an instance of this
>     structure.  It holds a reference to the dentry, so dentries are never
> @@ -172,6 +183,17 @@ int autofs4_expire_run(struct super_bloc
>  			struct autofs_packet_expire __user *);
>  int autofs4_expire_multi(struct super_block *, struct vfsmount *,
>  			struct autofs_sb_info *, int __user *);
> +struct dentry *autofs4_expire_direct(struct super_block *sb,
> +				     struct vfsmount *mnt,
> +				     struct autofs_sb_info *sbi, int how);
> +struct dentry *autofs4_expire_indirect(struct super_block *sb,
> +				       struct vfsmount *mnt,
> +				       struct autofs_sb_info *sbi, int how);
> +
> +/* Device node initialization */
> +
> +int autofs_dev_ioctl_init(void);
> +void autofs_dev_ioctl_exit(void);
>  
> ...
>
> @@ -0,0 +1,788 @@
> +/*
> + * linux/fs/autofs4/dev-ioctl.c

We prefer not to bother with the filename-in-the-file thing.  You know what
file you're reading, and these things tend to not get updated across
renames.

> + * Copyright 2008 Red Hat, Inc. All rights reserved.
> + * Copyright 2008 Ian Kent <raven@themaw.net>
> + *
> + * This file is part of the Linux kernel and is made available under
> + * the terms of the GNU General Public License, version 2, or at your
> + * option, any later version, incorporated herein by reference.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/vmalloc.h>
> +#include <linux/miscdevice.h>
> +#include <linux/init.h>
> +#include <linux/wait.h>
> +#include <linux/namei.h>
> +#include <linux/fcntl.h>
> +#include <linux/file.h>
> +#include <linux/sched.h>
> +#include <linux/compat.h>
> +#include <linux/syscalls.h>
> +#include <linux/smp_lock.h>
> +#include <linux/magic.h>
> +#include <linux/dcache.h>
> +#include <asm/uaccess.h>

Please include <linux/foo.h> rather than <asm/foo.h> if the former exists.

> +#include "autofs_i.h"
> +
> +/*
> + * This module implements an interface for routing autofs ioctl control
> + * commands via a miscellaneous device file.
> + *
> + * The alternate interface is needed because we need to be able open
> + * an ioctl file descriptor on an autofs mount that may be covered by
> + * another mount. This situation arises when starting automount(8)
> + * or other user space daemon which uses direct mounts or offset
> + * mounts (used for autofs lazy mount/umount of nested mount trees),
> + * which have been left busy at at service shutdown.
> + */
> +
> +#define AUTOFS_DEVICE_NAME	"autofs"
> +
> +#define AUTOFS_DEV_IOCTL_IOC_FIRST AUTOFS_DEV_IOCTL_VERSION
> +#define AUTOFS_DEV_IOCTL_IOC_COUNT AUTOFS_IOC_COUNT - 11

This needs parentheses.

Shouldn't these be in a header file, exported to userspace builds?

> +#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
> +
> +typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *, struct autofs_dev_ioctl *);
> +
> +static int check_name(const char *name)
> +{
> +	if (!strchr(name, '/'))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/*
> + * Check a string doesn't overrun the chunk of
> + * memory we copied from user land.
> + */
> +static int invalid_str(char *str, void *end)
> +{
> +	while ((void *) str <= end)
> +		if (!*str++)
> +			return 0;
> +	return -EINVAL;
> +}
>
> ...
>
> +/*
> + * Get the autofs super block info struct from the file opened on
> + * the autofs mount point.
> + */
> +static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
> +{
> +	struct autofs_sb_info *sbi = NULL;
> +	struct inode *inode;
> +
> +	if (f) {

`f' cannot be NULL here.

> +		inode = f->f_path.dentry->d_inode;
> +		sbi = autofs4_sbi(inode->i_sb);
> +	}
> +
> +	return sbi;
> +}
> +
> +/* Return autofs module protocol version */
> +static inline int autofs_dev_ioctl_protover(struct file *fp,
> +					    struct autofs_sb_info *sbi,
> +					    struct autofs_dev_ioctl *param)
> +{
> +	param->arg1 = sbi->version;
> +	return 0;
> +}
> +
> +/* Return autofs module protocol sub version */
> +static inline int autofs_dev_ioctl_protosubver(struct file *fp,
> +					       struct autofs_sb_info *sbi,
> +					       struct autofs_dev_ioctl *param)
> +{
> +	param->arg1 = sbi->sub_version;
> +	return 0;
> +}

Don't bother inlining things - the compiler will do it.

> +/*
> + * Walk down the mount stack looking for an autofs mount that
> + * has the requested device number (aka. new_encode_dev(sb->s_dev).
> + */
> +static int autofs_dev_ioctl_find_super(struct nameidata *nd, dev_t devno)
> +{
> +	struct dentry *dentry;
> +	struct inode *inode;
> +	struct super_block *sb;
> +	dev_t s_dev;
> +	unsigned int err;
> +
> +	err = -ENOENT;
> +
> +	/* Lookup the dentry name at the base of our mount point */
> +	dentry = d_lookup(nd->path.dentry, &nd->last);
> +	if (!dentry)
> +		goto out;
> +
> +	dput(nd->path.dentry);
> +	nd->path.dentry = dentry;
> +
> +	/* And follow the mount stack looking for our autofs mount */
> +	while (1) {
> +		inode = nd->path.dentry->d_inode;
> +		if (!inode)
> +			continue;
> +
> +		sb = inode->i_sb;
> +		s_dev = new_encode_dev(sb->s_dev);
> +		if (devno == s_dev) {
> +			if (sb->s_magic == AUTOFS_SUPER_MAGIC) {
> +				err = 0;
> +				break;
> +			}
> +		}
> +
> +		if (!follow_down(&nd->path.mnt, &nd->path.dentry))
> +			goto out;
> +	}
> +
> +out:
> +	return err;
> +}

hm.  possibly-interested parties cc'ed.

> +/*
> + * Install the file opened for autofs mount point control functions
> + * and set close on exec.
> + */
> +static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
> +{
> +	struct files_struct *files = current->files;
> +	struct fdtable *fdt;
> +
> +	spin_lock(&files->file_lock);
> +	fdt = files_fdtable(files);
> +	BUG_ON(fdt->fd[fd] != NULL);
> +	rcu_assign_pointer(fdt->fd[fd], file);
> +	FD_SET(fd, fdt->close_on_exec);
> +	spin_unlock(&files->file_lock);
> +}

That's fd_install() plus an add-on.  It's not autofs-specific.  Should be
in fs/open.c, methinks?

>
> ...
>
> +/* Close file descriptor allocated above (user can also use close(2)). */
> +static inline int autofs_dev_ioctl_closemount(struct file *fp,
> +					      struct autofs_sb_info *sbi,
> +					      struct autofs_dev_ioctl *param)
> +{
> +	return sys_close(param->ioctlfd);
> +}

hm.

>
> ...
>
> +/*
> + * Set the pipe fd for kernel communication to the daemon.
> + *
> + * Normally this is set at mount using an option but if we
> + * are reconnecting to a busy mount then we need to use this
> + * to tell the autofs mount about the new kernel pipe fd. In
> + * order to protect mounts against incorrectly setting the
> + * pipefd we also require that the autofs mount be catatonic.
> + *
> + * This also sets the process group id used to identify the
> + * controlling process (eg. the owning automount(8) daemon).
> + */
> +static int autofs_dev_ioctl_setpipefd(struct file *fp,
> +				      struct autofs_sb_info *sbi,
> +				      struct autofs_dev_ioctl *param)
> +{
> +	int pipefd;
> +	int err = 0;
> +
> +	if (param->arg1 == -1)
> +		return -EINVAL;
> +
> +	pipefd = param->arg1;
> +
> +	if (!sbi->catatonic)
> +		return -EBUSY;
> +	else {
> +		struct file *pipe = fget(pipefd);
> +		if (!pipe->f_op || !pipe->f_op->write) {
> +			err = -EPIPE;
> +			fput(pipe);
> +			goto out;
> +		}
> +		sbi->oz_pgrp = task_pgrp_nr(current);
> +		sbi->pipefd = pipefd;
> +		sbi->pipe = pipe;
> +		sbi->catatonic = 0;
> +	}
> +out:
> +	return err;
> +}

We have a new filesystem type, a misc device with a mysterious ioctl,
hand-rolled mountpoint chasing, hand-rolled fd installation and now pipes
too.

This is a complex interface.  We really need to see the overall problem
statement, design and interface description, please.

> +/*
> + * Make the autofs mount point catatonic, no longer responsive to
> + * mount requests. Also closes the kernel pipe file descriptor.
> + */
> +static inline int autofs_dev_ioctl_catatonic(struct file *fp,
> +					     struct autofs_sb_info *sbi,
> +					     struct autofs_dev_ioctl *param)
> +{
> +	if (!sbi->catatonic)
> +		autofs4_catatonic_mode(sbi);
> +	return 0;
> +}
> +
> +/* Set the autofs mount timeout */
> +static inline int autofs_dev_ioctl_timeout(struct file *fp,
> +					   struct autofs_sb_info *sbi,
> +					   struct autofs_dev_ioctl *param)
> +{
> +	unsigned long timeout;
> +
> +	timeout = param->arg1;
> +	param->arg1 = sbi->exp_timeout / HZ;
> +	sbi->exp_timeout = timeout * HZ;
> +	return 0;
> +}

uninline everything...

> +/*
> + * Return the uid and gid of the last request for the mount
> + *
> + * When reconstructing an autofs mount tree with active mounts
> + * we need to re-connect to mounts that may have used the original
> + * process uid and gid (or string variations of them) for mount
> + * lookups within the map entry.
> + */
> +static inline int autofs_dev_ioctl_requestor(struct file *fp,
> +					     struct autofs_sb_info *sbi,
> +					     struct autofs_dev_ioctl *param)

especially that - it's only ever called indirectly anwyay!

> +	struct autofs_info *ino;
> +	struct nameidata nd;
> +	const char *path;
> +	dev_t devid;
> +	int err = -ENOENT;
> +
> +	if (param->size <= sizeof(*param)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	path = param->path;
> +	devid = sbi->sb->s_dev;
> +
> +	param->arg1 = param->arg2 = -1;
> +
> +	/* Get nameidata of the parent directory */
> +	err = path_lookup(path, LOOKUP_PARENT, &nd);
> +	if (err)
> +		goto out;
> +
> +	err = autofs_dev_ioctl_find_super(&nd, devid);
> +	if (err)
> +		goto out_release;
> +	
> +	ino = autofs4_dentry_ino(nd.path.dentry);
> +	if (ino) {
> +		err = 0;
> +		param->arg1 = ino->uid;
> +		param->arg2 = ino->gid;
> +	}
> +
> +out_release:
> +	path_put(&nd.path);
> +out:
> +	return err;
> +}
> +
> +/*
> + * Call repeatedly until it returns -EAGAIN, meaning there's nothing
> + * more that can be done.
> + */
> +static int autofs_dev_ioctl_expire(struct file *fp,
> +				   struct autofs_sb_info *sbi,
> +				   struct autofs_dev_ioctl *param)
> +{
> +	struct dentry *dentry;
> +	struct vfsmount *mnt;
> +	int err = -EAGAIN;
> +	int when;
> +
> +	when = param->arg1;
> +	mnt = fp->f_path.mnt;
> +
> +	if (sbi->type & AUTOFS_TYPE_DIRECT)
> +		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, when);
> +	else
> +		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, when);
> +
> +	if (dentry) {
> +		struct autofs_info *ino = autofs4_dentry_ino(dentry);
> +
> +		/*
> +		 * This is synchronous because it makes the daemon a
> +		 * little easier
> +		*/
> +		ino->flags |= AUTOFS_INF_EXPIRING;
> +		err = autofs4_wait(sbi, dentry, NFY_EXPIRE);
> +		ino->flags &= ~AUTOFS_INF_EXPIRING;

Are there races around the modification of ino->flags here?

> +		dput(dentry);
> +	}
> +
> +	return err;
> +}
> +
> +/* Check if autofs mount point is in use */
> +static inline int autofs_dev_ioctl_askumount(struct file *fp,
> +					     struct autofs_sb_info *sbi,
> +					     struct autofs_dev_ioctl *param)
> +{
> +	param->arg1 = 0;
> +	if (may_umount(fp->f_path.mnt))
> +		param->arg1 = 1;
> +	return 0;
> +}
> +
> +/*
> + * Check if the given path is a mountpoint.
> + *
> + * If we are supplied with the file descriptor of the autofs
> + * mount we're looking for a specific mount. In this case
> + * the path is considered a mountpoint if it is itself a
> + * mountpoint or contains a mount, such as a multi-mount
> + * without a root mount.
> + *
> + * If we aren't supplied with a file descriptor then we lookup
> + * the nameidata of the path and check if is a mounted autofs
> + * filesystem or a filesystem mounted within an autofs filesystem.
> + *
> + * In both cases we return an indication of whether the path
> + * is a mount point and the super magic of the covering mount.
> + */
> +static inline int autofs_dev_ioctl_ismountpoint(struct file *fp,
> +						struct autofs_sb_info *sbi,
> +						struct autofs_dev_ioctl *param)

uninline..

> +	struct nameidata nd;
> +	const char *path;
> +	int err = -ENOENT;
> +
> +	if (param->size <= sizeof(*param)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	path = param->path;
> +
> +	param->arg1 = param->arg2 = 0;
> +
> +	if (param->ioctlfd == -1) {
> +		unsigned long magic;
> +
> +		err = path_lookup(path, LOOKUP_FOLLOW, &nd);
> +		if (err)
> +			goto out;
> +
> +		magic = nd.path.dentry->d_inode->i_sb->s_magic;
> +
> +		if (follow_up(&nd.path.mnt, &nd.path.dentry)) {
> +			struct inode *inode = nd.path.dentry->d_inode;
> +			if (magic == AUTOFS_SUPER_MAGIC ||
> +			    inode->i_sb->s_magic == AUTOFS_SUPER_MAGIC) {
> +				param->arg1 = 1;
> +				param->arg2 = magic;
> +			}
> +		}
> +	} else {
> +		dev_t devid = sbi->sb->s_dev;
> +
> +		err = path_lookup(path, LOOKUP_PARENT, &nd);
> +		if (err)
> +			goto out;
> +
> +		err = autofs_dev_ioctl_find_super(&nd, devid);
> +		if (err)
> +			goto out_release;
> +	
> +		param->arg1 = have_submounts(nd.path.dentry);
> +
> +		if (d_mountpoint(nd.path.dentry)) {
> +			if (follow_down(&nd.path.mnt, &nd.path.dentry)) {
> +				struct inode *inode = nd.path.dentry->d_inode;
> +				param->arg2 = inode->i_sb->s_magic;
> +			}
> +		}
> +	}
> +
> +out_release:
> +	path_put(&nd.path);
> +out:
> +	return err;
> +}

Have you really carefully reviewed and tested what happens when non-autofs
fds are fed into all the ioctl modes?

I hope all these ioctl entrypoints are root-only.  What determines that? 
The miscdevice permissions?

> +/*
> + * Our range of ioctl numbers isn't 0 based so we need to shift
> + * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
> + * lookup.
> + */
> +#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
> +
> +static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
> +{
> +	static struct {
> +		int cmd;
> +		ioctl_fn fn;
> +	} _ioctls[] = {
> +		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD), autofs_dev_ioctl_protover},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD), autofs_dev_ioctl_protosubver},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD), autofs_dev_ioctl_openmount},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD), autofs_dev_ioctl_closemount},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD), autofs_dev_ioctl_ready},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD), autofs_dev_ioctl_fail},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD), autofs_dev_ioctl_setpipefd},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD), autofs_dev_ioctl_catatonic},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD), autofs_dev_ioctl_timeout},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTOR_CMD), autofs_dev_ioctl_requestor},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD), autofs_dev_ioctl_expire},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD), autofs_dev_ioctl_askumount},
> +		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD), autofs_dev_ioctl_ismountpoint}
> +	};
> +	int idx = cmd_idx(cmd);

`idx' should have unsigned type.

> +	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
> +}
> +
> +/* ioctl dispatcher */
> +static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
> +{
> +	struct autofs_dev_ioctl *param;
> +	struct file *fp;
> +	struct autofs_sb_info *sbi;
> +	unsigned int cmd;
> +	ioctl_fn fn = NULL;
> +	int err = 0;
> +
> +	/* only root can play with this */
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

OK, I guess that answers my above question.

> +	cmd = _IOC_NR(command);
> +
> +	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
> +	    cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST) >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
> +		return -ENOTTY;
> +	}
> +
> +	fn = lookup_dev_ioctl(cmd);
> +	if (!fn) {
> +		WARN("unknown command 0x%08x", command);
> +		return -ENOTTY;
> +	}
> +
> +	/*
> +	 * Trying to avoid low memory issues when a device is
> +	 * suspended.
> +	 */
> +	current->flags |= PF_MEMALLOC;

whoa, what's this doing here?

> +	/* Copy the parameters into kernel space. */
> +	param = copy_dev_ioctl(user);
> +
> +	current->flags &= ~PF_MEMALLOC;
> +
> +	if (IS_ERR(param))
> +		return PTR_ERR(param);
> +
> +	err = validate_dev_ioctl(command, param);
> +	if (err)
> +		goto out;
> +
> +	/* The validate routine above always sets the version */
> +	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
> +		goto done;
> +
> +	fp = NULL;
> +	sbi = NULL;
> +
> +	/*
> +	 * For obvious reasons the openmount can't have a file
> +	 * descriptor yet. We don't take a reference to the
> +	 * file during close to allow for immediate release.
> +	 */
> +	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
> +	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
> +		fp = fget(param->ioctlfd);
> +		if (!fp) {
> +			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
> +				goto cont;
> +			err = -EBADF;
> +			goto out;
> +		}
> +
> +		if (!fp->f_op) {
> +			err = -ENOTTY;
> +			fput(fp);
> +			goto out;
> +		}
> +
> +		sbi = autofs_dev_ioctl_sbi(fp);
> +		if (!sbi) {
> +			err = -EINVAL;
> +			fput(fp);
> +			goto out;
> +		}
> +	}
> +cont:
> +	err = fn(fp, sbi, param);
> +
> +	if (fp)
> +		fput(fp);
> +done:
> +	if (!err && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
> +		err = -EFAULT;
> +out:
> +	free_dev_ioctl(param);
> +	return err;
> +}
> +
>
> ...
>
> diff -up /dev/null linux-2.6.25-rc2-mm1/include/linux/auto_dev-ioctl.h
> --- /dev/null	2008-02-22 18:55:57.149000956 +0900
> +++ linux-2.6.25-rc2-mm1/include/linux/auto_dev-ioctl.h	2008-02-22 11:51:41.000000000 +0900
> @@ -0,0 +1,114 @@
> +/*
> + * linux/include/linux/auto_dev-ioctl.h
> + *
> + * Copyright 2008 Red Hat, Inc. All rights reserved.
> + * Copyright 2008 Ian Kent <raven@themaw.net>
> + *
> + * This file is part of the Linux kernel and is made available under
> + * the terms of the GNU General Public License, version 2, or at your
> + * option, any later version, incorporated herein by reference.
> + */
> +
> +#ifndef _LINUX_AUTO_DEV_IOCTL_H
> +#define _LINUX_AUTO_DEV_IOCTL_H
> +
> +#include <linux/types.h>
> +
> +#define AUTOFS_DEV_IOCTL_VERSION_MAJOR	1
> +#define AUTOFS_DEV_IOCTL_VERSION_MINOR	0
> +
> +#define AUTOFS_DEVID_LEN		16
> +
> +/*
> + * An ioctl interface for autofs mount point control.
> + */
> +
> +/*
> + * All the ioctls use this structure.
> + * When sending a path size must account for the total length
> + * of the chunk of memory otherwise is is the size of the
> + * structure.
> + */
> +
> +struct autofs_dev_ioctl {
> +	__u32 ver_major;
> +	__u32 ver_minor;
> +	__u32 size;		/* total size of data passed in
> +				 * including this struct */
> +	__s32 ioctlfd;		/* automount command fd */
> +
> +	__u32 arg1;		/* Command parameters */
> +	__u32 arg2;
> +
> +	char path[0];
> +};
> +
> +static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
> +{
> +	in->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
> +	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
> +	in->size = sizeof(struct autofs_dev_ioctl);
> +	in->ioctlfd = -1;
> +	in->arg1 = 0;
> +	in->arg2 = 0;
> +	return;
> +}

uninline..

> +/*
> + * If you change this make sure you make the corresponding change
> + * to autofs-dev-ioctl.c:lookup_ioctl()

Can we do this automatically via preprocessor tricks, or whatever?

> + */
> +enum {
> +	/* Get various version info */
> +	AUTOFS_DEV_IOCTL_VERSION_CMD = 0x71,
> +	AUTOFS_DEV_IOCTL_PROTOVER_CMD,
> +	AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD,
> +
> +	/* Open mount ioctl fd */
> +	AUTOFS_DEV_IOCTL_OPENMOUNT_CMD,
> +
> +	/* Close mount ioctl fd */
> +	AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD,
> +
> +	/* Mount/expire status returns */
> +	AUTOFS_DEV_IOCTL_READY_CMD,
> +	AUTOFS_DEV_IOCTL_FAIL_CMD,
> +
> +	/* Activate/deactivate autofs mount */
> +	AUTOFS_DEV_IOCTL_SETPIPEFD_CMD,
> +	AUTOFS_DEV_IOCTL_CATATONIC_CMD,
> +
> +	/* Expiry timeout */
> +	AUTOFS_DEV_IOCTL_TIMEOUT_CMD,
> +
> +	/* Get mount last requesting uid and gid */
> +	AUTOFS_DEV_IOCTL_REQUESTOR_CMD,
> +
> +	/* Check for eligible expire candidates */
> +	AUTOFS_DEV_IOCTL_EXPIRE_CMD,
> +
> +	/* Request busy status */
> +	AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD,
> +
> +	/* Check if path is a mountpoint */
> +	AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD,
> +};
> +

