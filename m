Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbXJYPqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbXJYPqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbXJYPqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:46:22 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:35516 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758872AbXJYPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:46:17 -0400
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory
	Access Control Kernel
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4720118C.5020906@schaufler-ca.com>
References: <4720118C.5020906@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 25 Oct 2007 11:07:14 -0400
Message-Id: <1193324834.2683.113.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 20:46 -0700, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Smack is the Simplified Mandatory Access Control Kernel.
> 
> Smack implements mandatory access control (MAC) using labels
> attached to tasks and data containers, including files, SVIPC,
> and other tasks. Smack is a kernel based scheme that requires
> an absolute minimum of application support and a very small
> amount of configuration data.
> 
> Smack uses extended attributes and
> provides a set of general mount options, borrowing technics used
> elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
> a pseudo-filesystem smackfs that is used for manipulation of
> system Smack attributes.
> 
> The patch, patches for ls and sshd, a README, a startup script,
> and x86 binaries for ls and sshd are also available on
> 
>     http://www.schaufler-ca.com
> 
> This version has been tested with 2.6.23, various 2.6.23-gits
> and 2.6.24-rc1. Development has been done using Fedora Core 7
> in a virtual machine environment and on an old Sony laptop.
> 
> Smack provides mandatory access controls based on the label attached
> to a task and the label attached to the object it is attempting to
> access. Smack labels are deliberately short (1-23 characters) text
> strings. Single character labels using special characters are reserved
> for system use. The only operation applied to Smack labels is equality
> comparison. No wildcards or expressions, regular or otherwise, are
> used. Smack labels are composed of printable characters and may not
> include "/".
> 
> A file always gets the Smack label of the task that created it.
> 
> Smack defines and uses these labels:
> 
>     "*" - pronounced "star"
>     "_" - pronounced "floor"
>     "^" - pronounced "hat"
>     "?" - pronounced "huh"
> 
> The access rules enforced by Smack are, in order:
> 
> 1. Any access requested by a task labeled "*" is denied.
> 2. A read or execute access requested by a task labeled "^"
>    is permitted.
> 3. A read or execute access requested on an object labeled "_"
>    is permitted.
> 4. Any access requested on an object labeled "*" is permitted.
> 5. Any access requested by a task on an object with the same
>    label is permitted.
> 6. Any access requested that is explicitly defined in the loaded
>    rule set is permitted.
> 7. Any other access is denied.
> 
> Rules may be explicitly defined by writing subject,object,access
> triples to /smack/load.
> 
> Smack rule sets can be easily defined that describe Bell&LaPadula
> sensitivity, Biba integrity, and a variety of interesting
> configurations. Smack rule sets can be modified on the fly to
> accomodate changes in the operating environment or even the time
> of day.
> 
> Some practical use cases:
> 
> Hierarchical levels. The less common of the two usual uses
> for MLS systems is to define hierarchical levels, often
> unclassified, confidential, secret, and so on. To set up smack
> to support this, these rules could be defined:
> 
>    C        Unclass rx
>    S        C       rx
>    S        Unclass rx
>    TS       S       rx
>    TS       C       rx
>    TS       Unclass rx
> 
> A TS process can read S, C, and Unclass data, but cannot write it.
> An S process can read C and Unclass. Note that specifying that
> TS can read S and S can read C does not imply TS can read C, it
> has to be explicitly stated.
> 
> Non-hierarchical categories. This is the more common of the
> usual uses for an MLS system. Since the default rule is that a
> subject cannot access an object with a different label no
> access rules are required to implement compartmentalization.
> 
> A case that the Bell & LaPadula policy does not allow is demonstrated
> with this Smack access rule:
> 
> A case that Bell&LaPadula does not allow that Smack does:
> 
>     ESPN    ABC   r
>     ABC     ESPN  r
> 
> On my portable video device I have two applications, one that
> shows ABC programming and the other ESPN programming. ESPN wants
> to show me sport stories that show up as news, and ABC will
> only provide minimal information about a sports story if ESPN
> is covering it. Each side can look at the other's info, neither
> can change the other. Neither can see what FOX is up to, which
> is just as well all things considered.
> 
> Another case that I especially like:
> 
>     SatData Guard   w
>     Guard   Publish w
> 
> A program running with the Guard label opens a UDP socket and
> accepts messages sent by a program running with a SatData label.
> The Guard program inspects the message to ensure it is wholesome
> and if it is sends it to a program running with the Publish label.
> This program then puts the information passed in an appropriate
> place. Note that the Guard program cannot write to a Publish
> file system object because file system semanitic require read as
> well as write.
> 
> The four cases (categories, levels, mutual read, guardbox) here
> are all quite real, and problems I've been asked to solve over
> the years. The first two are easy to do with traditonal MLS systems
> while the last two you can't without invoking privilege, at least
> for a while.
> 
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> ---
>  
> This patch depends on the netlabel interface patch by Paul Moore
> <paul.moore@hp.com> in support of a more comfortable interface to
> initialize the CIPSO code from within the kernel. This patch was
> titled "[NetLabel] Introduce a new kernel configuration API for
> NetLabel".
> 
> This version is again aimed at addressing Al Viro's issues in
> smackfs. Ahmed Darwish has again contributed in the repair of the
> locking issues there. The move to 2.6.24 was also an important
> release incentive.
> 
> 
> Thank you.
> 
>  Documentation/Smack.txt       |  483 +++++
>  security/Kconfig              |    1 
>  security/Makefile             |    2 
>  security/smack/Kconfig        |   10 
>  security/smack/Makefile       |    7 
>  security/smack/smack.h        |  222 ++
>  security/smack/smack_access.c |  353 ++++
>  security/smack/smack_lsm.c    | 2664 ++++++++++++++++++++++++++++++++
>  security/smack/smackfs.c      |  929 +++++++++++
>  9 files changed, 4671 insertions(+)
> 
> diff -uprN -X linux-2.6.24-rc1-base/Documentation/dontdiff linux-2.6.24-rc1-base/Documentation/Smack.txt linux-2.6.24-rc1-smack/Documentation/Smack.txt
> --- linux-2.6.24-rc1-base/Documentation/Smack.txt	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.24-rc1-smack/Documentation/Smack.txt	2007-10-23 16:45:06.000000000 -0700
> @@ -0,0 +1,483 @@
> +
> +
> +    "Good for you, you've decided to clean the elevator!"
> +    - The Elevator, from Dark Star
> +
> +Smack is the the Simplified Mandatory Access Control Kernel.
> +Smack is a kernel based implementation of mandatory access
> +control that includes simplicity in its primary design goals.
> +
> +Smack does not implement Domain Type Enforcement (DTE). If
> +you want DTE Linux has an implementation called SELinux.
> +Those who really want DTE are encouraged to use SELinux.
> +Those who don't know what DTE is are encouraged to compare
> +SELinux with Smack to determine which mechanisms are best
> +suited to the problem at hand.

Nit: SELinux does not implement DTE.  DTE was a scheme introduced by Lee
Badger et al to apply implicit typing based on pathname as a variant of
the original type enforcement model.  SELinux is an implementation of
the Flask security architecture for flexible MAC, along with an example
security server that implements RBAC, TE, and MLS models, but not
limited to them.

> diff -uprN -X linux-2.6.24-rc1-base/Documentation/dontdiff linux-2.6.24-rc1-base/security/smack/smack_lsm.c linux-2.6.24-rc1-smack/security/smack/smack_lsm.c
> --- linux-2.6.24-rc1-base/security/smack/smack_lsm.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.24-rc1-smack/security/smack/smack_lsm.c	2007-10-23 16:45:06.000000000 -0700
> @@ -0,0 +1,2664 @@
> +/*
> + *  Simplified MAC Kernel (smack) security module
> + *
> + *  This file contains the smack hook function implementations.
> + *
> + *  Author:
> + *	Casey Schaufler <casey@schaufler-ca.com>
> + *
> + *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
> + *
> + *	This program is free software; you can redistribute it and/or modify
> + *	it under the terms of the GNU General Public License version 2,
> + *      as published by the Free Software Foundation.
> + */
> +
> +#include <linux/xattr.h>
> +#include <linux/pagemap.h>
> +#include <linux/mount.h>
> +#include <linux/stat.h>
> +#include <linux/ext2_fs.h>
> +#include <linux/kd.h>
> +#include <asm/ioctls.h>
> +#include <linux/tcp.h>
> +#include <linux/udp.h>
> +#include <linux/mutex.h>
> +#include <net/netlabel.h>
> +#include <net/cipso_ipv4.h>
> +
> +#include "smack.h"
> +
> +/*
> + * I hope these are the hokeyist lines of code in the module. Casey.
> + */
> +#define DEVPTS_SUPER_MAGIC	0x1cd1
> +#define SOCKFS_MAGIC		0x534F434B
> +#define PIPEFS_MAGIC		0x50495045
> +#define TMPFS_MAGIC		0x01021994

They are certainly hokey.  Move them to magic.h and include it.

> +/**
> + * smack_task_kill - Samck check on signal delivery
> + * @p: the task object
> + * @info: unused
> + * @sig: unused
> + * @secid: identifies the smack to use in lieu of current's
> + *
> + * Return 0 if write access is permitted
> + *
> + * The secid behavior is an artifact of an SELinux hack
> + * in the USB code. Someday it may go away.
> + */
> +static int smack_task_kill(struct task_struct *p, struct siginfo *info,
> +			   int sig, u32 secid)
> +{
> +	/*
> +	 * Sending a signal requires that the sender
> +	 * can write the receiver.
> +	 */
> +	if (secid == 0)
> +		return smk_curacc(p->security, MAY_WRITE);
> +	/*
> +	 * If the secid isn't 0 we're dealing with some USB IO
> +	 * specific behavior. This is not clean. For one thing
> +	 * we can't take privilege into account.
> +	 */
> +	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
> +}

Doesn't account for forced signals or signals from the kernel - see
selinux_task_kill() and check_kill_permission().    Or that could
possibly be handled once for all in check_kill_permission() and never
call the hook in that case.

> +/**
> + * smack_sb_kern_mount - Smack specific mount processing
> + * @sb: the file system superblock
> + * @data: the smack mount options
> + *
> + * Returns 0 on success, an error code on failure
> + */
> +static int smack_sb_kern_mount(struct super_block *sb, void *data)
> +{
> +	int rc;
> +	struct dentry *root = sb->s_root;
> +	struct inode *inode = root->d_inode;
> +	struct superblock_smack *sp = sb->s_security;
> +	struct inode_smack *isp;
> +	char *op;
> +	char *commap;
> +	char *nsp;
> +
> +	if (sp == NULL) {

Bug?  Under what conditions does this happen?
Don't try to silently hide real bugs.

> +		rc = smack_sb_alloc_security(sb);

Racy if it ever does happen.  Allocation should always happen from the
alloc hook.

> +		if (rc != 0)
> +			return rc;
> +	}
> +	if (sp->smk_initialized != 0)
> +		return 0;

Racy?

> +	if (inode == NULL)
> +		return 0;

Bug?

> +
> +	sp->smk_initialized = 1;

Hmm...set before state is fully initialized, and no locking?

> +
> +	for (op = data; op != NULL; op = commap) {
> +		commap = strchr(op, ',');
> +		if (commap != NULL)
> +			*commap++ = '\0';
> +
> +		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
> +			op += strlen(SMK_FSHAT);
> +			nsp = smk_import(op, 0);
> +			if (nsp != NULL)
> +				sp->smk_hat = nsp;
> +		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
> +			op += strlen(SMK_FSFLOOR);
> +			nsp = smk_import(op, 0);
> +			if (nsp != NULL)
> +				sp->smk_floor = nsp;
> +		} else if (strncmp(op, SMK_FSDEFAULT,
> +				   strlen(SMK_FSDEFAULT)) == 0) {
> +			op += strlen(SMK_FSDEFAULT);
> +			nsp = smk_import(op, 0);
> +			if (nsp != NULL)
> +				sp->smk_default = nsp;
> +		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
> +			op += strlen(SMK_FSROOT);
> +			nsp = smk_import(op, 0);
> +			if (nsp != NULL)
> +				sp->smk_root = nsp;
> +		}
> +	}
> +
> +	/*
> +	 * Initialize the root inode.
> +	 */
> +	isp = inode->i_security;
> +	if (isp == NULL)
> +		inode->i_security = new_inode_smack(sp->smk_root);
> +	else
> +		isp->smk_inode = sp->smk_root;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_sb_statfs - Smack check on statfs
> + * @dentry: identifies the file system in question
> + *
> + * Returns 0 if current can read the floor of the filesystem,
> + * and error code otherwise
> + */
> +static int smack_sb_statfs(struct dentry *dentry)
> +{
> +	struct superblock_smack *sbp;
> +
> +	if (dentry == NULL || dentry->d_sb == NULL ||
> +	    dentry->d_sb->s_security == NULL)

Bug?

> +		return 0;
> +
> +	sbp = dentry->d_sb->s_security;
> +
> +	return smk_curacc(sbp->smk_floor, MAY_READ);
> +}
> +
> +/**
> + * smack_sb_mount - Smack check for mounting
> + * @dev_name: unused
> + * @nd: mount point
> + * @type: unused
> + * @flags: unused
> + * @data: unused
> + *
> + * Returns 0 if current can write the floor of the filesystem
> + * being mounted on, an error code otherwise.
> + */
> +static int smack_sb_mount(char *dev_name, struct nameidata *nd,
> +			  char *type, unsigned long flags, void *data)
> +{
> +	struct superblock_smack *sbp;
> +
> +	if (nd == NULL || nd->mnt == NULL || nd->mnt->mnt_sb == NULL ||
> +	    nd->mnt->mnt_sb->s_security == NULL)
> +		return 0;

Bug?

> +
> +	sbp = nd->mnt->mnt_sb->s_security;
> +
> +	return smk_curacc(sbp->smk_floor, MAY_WRITE);
> +}
> +
> +/**
> + * smack_sb_umount - Smack check for unmounting
> + * @mnt: file system to unmount
> + * @flags: unused
> + *
> + * Returns 0 if current can write the floor of the filesystem
> + * being unmounted, an error code otherwise.
> + */
> +static int smack_sb_umount(struct vfsmount *mnt, int flags)
> +{
> +	struct superblock_smack *sbp;
> +
> +	sbp = mnt->mnt_sb->s_security;
> +
> +	return smk_curacc(sbp->smk_floor, MAY_WRITE);
> +}
> +
> +/*
> + * Inode hooks
> + */
> +
> +/**
> + * smack_inode_alloc_security - allocate an inode blob
> + * @inode - the inode in need of a blob
> + *
> + * Returns 0 if it gets a blob, -ENOMEM otherwise
> + */
> +static int smack_inode_alloc_security(struct inode *inode)
> +{
> +	inode->i_security = new_inode_smack(current->security);
> +	if (inode->i_security == NULL)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +/**
> + * smack_inode_free_security - free an inode blob
> + * @inode - the inode with a blob
> + *
> + * Clears the blob pointer in inode
> + */
> +static void smack_inode_free_security(struct inode *inode)
> +{
> +	kfree(inode->i_security);
> +	inode->i_security = NULL;
> +}
> +
> +/**
> + * smack_inode_init_security - copy out the smack from an inode
> + * @inode: the inode
> + * @dir: unused
> + * @name: where to put the attribute name
> + * @value: where to put the attribute value
> + * @len: where to put the length of the attribute
> + *
> + * Returns 0 if it all works out, -ENOMEM if there's no memory
> + */
> +static int smack_inode_init_security(struct inode *inode, struct inode *dir,
> +				     char **name, void **value, size_t *len)
> +{
> +	char *isp = smk_of_inode(inode);
> +
> +	if (name) {
> +		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL);
> +		if (*name == NULL)
> +			return -ENOMEM;
> +	}
> +
> +	if (value) {
> +		*value = kstrdup(isp, GFP_KERNEL);
> +		if (*value == NULL)
> +			return -ENOMEM;
> +	}
> +
> +	if (len)
> +		*len = strlen(isp) + 1;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_inode_link - Smack check on link
> + * @old_dentry: unused
> + * @dir: the directory with the entry to change
> + * @new_dentry: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
> +			    struct dentry *new_dentry)
> +{
> +	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +}

Hmmm...no check on the file itself, even though creating a hard link
changes the state of the inode?  If you only care about the directory,
then that should already have been handled by vfs_ functions calling
fs/namei.c:may_create() and checking both write and search to the
directory.  In which case you don't need to implement this hook at all.

> +
> +/**
> + * smack_inode_symlink - Smack check on symlink
> + * @dir: the directory to add the entry to
> + * @dentry: unused
> + * @name: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_symlink(struct inode *dir, struct dentry *dentry,
> +				const char *name)
> +{
> +	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +}

Ditto.

> +
> +/**
> + * smack_inode_mknod - Smack check on mknod
> + * @dir: the directory to add the entry to
> + * @dentry: unused
> + * @mode: unused
> + * @dev: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_mknod(struct inode *dir, struct dentry *dentry,
> +			     int mode, dev_t dev)
> +{
> +	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +}

And again.

> +
> +/**
> + * smack_inode_rename - Smack check on rename
> + * @old_inode: the old directory
> + * @old_dentry: unused
> + * @new_inode: the new directory
> + * @new_dentry: unused
> + *
> + * Read and write access is required on both the old and
> + * new directories.
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_rename(struct inode *old_inode,
> +			      struct dentry *old_dentry,
> +			      struct inode *new_inode,
> +			      struct dentry *new_dentry)
> +{
> +	int rc;
> +
> +	rc = smk_curacc(smk_of_inode(old_inode), MAY_READWRITE);
> +	if (rc == 0)
> +		rc = smk_curacc(smk_of_inode(new_inode), MAY_READWRITE);
> +	return rc;
> +}

vfs_rename() calls may_delete() on the old pair and either 1)
may_create() on the new pair if the target does not exist or 2)
may_delete() on the new pair if the target does exist.  For your
purposes, that means checking write and search on both directories
already before it reaches this hook.

> +
> +/**
> + * smack_inode_readlink - Smack check on readlink
> + * @dentry: the symlink
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_readlink(struct dentry *dentry)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +}
> +
> +/**
> + * smack_inode_follow_link - Smack check on following a symlink
> + * @dentry: the symlink
> + * @nameidata: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_follow_link(struct dentry *dentry,
> +				   struct nameidata *nameidata)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +}
> +
> +/**
> + * smack_inode_permission - Smack version of permission()
> + * @inode: the inode in question
> + * @mask: the access requested
> + * @nd: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_permission(struct inode *inode, int mask,
> +				  struct nameidata *nd)
> +{
> +	/*
> +	 * No permission to check. Existence test. Yup, it's there.
> +	 */
> +	if (mask == 0)
> +		return 0;
> +
> +	return smk_curacc(smk_of_inode(inode), mask);
> +}
> +
> +/**
> + * smack_inode_setattr - Smack check for setting attributes
> + * @dentry: the object
> + * @iattr: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +}

You need an exception for iattr->ia_valid & ATTR_FORCE or you'll prevent
proper clearing of suid upon successful writes.  See
selinux_inode_setattr.

> +
> +/**
> + * smack_inode_getattr - Smack check for getting attributes
> + * @mnt: unused
> + * @dentry: the object
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +}
> +
> +/**
> + * smack_inode_setxattr - Smack check for setting xattrs
> + * @dentry: the object
> + * @name: passed to the cap call
> + * @value: passed to the cap call
> + * @size: passed to the cap call
> + * @flags: passed to the cap call
> + *
> + * Check with cap_inode_setxattr to see if the capability
> + * scheme approves, then check the Smack access
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_setxattr(struct dentry *dentry, char *name,
> +				void *value, size_t size, int flags)
> +{
> +	int rc;
> +
> +	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
> +		!__capable(current, CAP_MAC_OVERRIDE))
> +		return -EPERM;
> +
> +	rc = cap_inode_setxattr(dentry, name, value, size, flags);

You don't want to invoke cap_inode_setxattr if the attribute was the
smack attribute; otherwise, it will end up checking CAP_SYS_ADMIN (for
anything in the security namespace).

> +	if (rc == 0)
> +		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_inode_post_setxattr - Apply the Smack update approved above
> + * @dentry: object
> + * @name: attribute name
> + * @value: attribute value
> + * @size: attribute size
> + * @flags: unused
> + *
> + * Set the pointer in the inode blob to the entry found
> + * in the master label list.
> + */
> +static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
> +				      void *value, size_t size, int flags)
> +{
> +	struct inode_smack *isp;
> +	char *nsp;
> +
> +	/*
> +	 * Not SMACK
> +	 */
> +	if (strcmp(name, XATTR_NAME_SMACK))
> +		return;
> +
> +	if (size >= SMK_LABELLEN)
> +		return;
> +
> +	isp = dentry->d_inode->i_security;
> +
> +	/*
> +	 * No locking is done here. This is a pointer
> +	 * assignment.
> +	 */
> +	nsp = smk_import(value, size);
> +	if (nsp != NULL)
> +		isp->smk_inode = nsp;
> +	else
> +		isp->smk_inode = smack_known_invalid.smk_known;
> +
> +	return;
> +}
> +
> +/*
> + * smack_inode_getxattr - Smack check on getxattr
> + * @dentry: the object
> + * @name: unused
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_getxattr(struct dentry *dentry, char *name)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +}
> +
> +/*
> + * smack_inode_listxattr - Smack check on listxattr
> + * @dentry: the object
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_listxattr(struct dentry *dentry)
> +{
> +	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> +}
> +
> +/*
> + * smack_inode_removexattr - Smack check on removexattr
> + * @dentry: the object
> + * @name: name of the attribute
> + *
> + * Removing the Smack attribute requires CAP_MAC_OVERRIDE
> + *
> + * Returns 0 if access is permitted, an error code otherwise
> + */
> +static int smack_inode_removexattr(struct dentry *dentry, char *name)
> +{
> +	int rc;
> +
> +	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
> +		!__capable(current, CAP_MAC_OVERRIDE))
> +		return -EPERM;
> +
> +	rc = cap_inode_removexattr(dentry, name);

Same as for setxattr.

> +	if (rc == 0)
> +		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_inode_getsecurity - get smack xattrs
> + * @inode: the object
> + * @name: attribute name
> + * @buffer: where to put the result
> + * @size: size of the buffer
> + * @err: unused
> + *
> + * Returns the size of the attribute or an error code
> + */
> +static int smack_inode_getsecurity(const struct inode *inode,
> +				   const char *name, void *buffer,
> +				   size_t size, int err)
> +{
> +	struct socket_smack *ssp;
> +	struct socket *sock;
> +	struct super_block *sbp;
> +	struct inode *ip = (struct inode *)inode;
> +	char *bsp = buffer;
> +	char *isp;
> +
> +	if (size < SMK_LABELLEN || name == NULL || bsp == NULL ||
> +	    inode == NULL || inode->i_security == NULL)
> +		return 0;

At least some of those tests might hide a real bug elsewhere.

> +
> +	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> +		isp = smk_of_inode(inode);
> +		strncpy(buffer, isp, SMK_LABELLEN);
> +		return strlen(isp) + 1;
> +	}
> +
> +	/*
> +	 * The rest of the Smack xattrs are only on sockets.
> +	 */
> +	sbp = ip->i_sb;
> +	if (sbp->s_magic != SOCKFS_MAGIC)
> +		return -EOPNOTSUPP;
> +
> +	sock = SOCKET_I(ip);
> +	if (sock == NULL)
> +		return -EOPNOTSUPP;
> +
> +	ssp = sock->sk->sk_security;
> +
> +	/*
> +	 * Should the packet attribute be unavailable return the error.
> +	 * This can happen if packets come in too fast.
> +	 */
> +	if (strcmp(name, XATTR_SMACK_PACKET) == 0) {
> +		if (ssp->smk_packet[0] == '\0')
> +			return -ENODATA;
> +		isp = ssp->smk_packet;
> +	} else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
> +		isp = ssp->smk_in;
> +	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
> +		isp = ssp->smk_out;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	strncpy(buffer, isp, SMK_LABELLEN);
> +	return strlen(isp) + 1;
> +}
> +
> +/**
> + * smack_inode_setsecurity - set smack xattrs
> + * @inode: the object
> + * @name: attribute name
> + * @value: attribute value
> + * @size: size of the attribute
> + * @flags: unused
> + *
> + * Sets the named attribute in the appropriate blob
> + *
> + * Returns 0 on success, or an error code
> + */
> +static int smack_inode_setsecurity(struct inode *inode, const char *name,
> +				   const void *value, size_t size, int flags)
> +{
> +	char *sp;
> +	struct inode_smack *nsp = (struct inode_smack *)inode->i_security;
> +	struct socket_smack *ssp;
> +	struct socket *sock;
> +
> +	if (value == NULL || size > SMK_LABELLEN)
> +		return -EACCES;
> +
> +	sp = smk_import(value, size);
> +	if (sp == NULL)
> +		return -EINVAL;
> +
> +	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> +		mutex_lock(&nsp->smk_lock);
> +		nsp->smk_inode = sp;
> +		mutex_unlock(&nsp->smk_lock);
> +		return 0;
> +	}
> +	/*
> +	 * The rest of the Smack xattrs are only on sockets.
> +	 */
> +	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
> +		return -EOPNOTSUPP;
> +
> +	sock = SOCKET_I(inode);
> +	if (sock == NULL)
> +		return -EOPNOTSUPP;
> +
> +	ssp = sock->sk->sk_security;
> +
> +	if (strcmp(name, XATTR_SMACK_PACKET) == 0) {
> +		memset(ssp->smk_packet, '\0', SMK_LABELLEN);
> +		strncpy(ssp->smk_packet, sp, SMK_LABELLEN);
> +	} else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
> +		ssp->smk_in = sp;
> +	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
> +		ssp->smk_out = sp;
> +	else
> +		return -EOPNOTSUPP;
> +	return 0;
> +}
> +
> +/**
> + * smack_inode_listsecurity - list the Smack attributes
> + * @inode: the object
> + * @buffer: where they go
> + * @buffer_size: size of buffer
> + *
> + * Returns 0 on success, -EINVAL otherwise
> + */
> +static int smack_inode_listsecurity(struct inode *inode, char *buffer,
> +				    size_t buffer_size)
> +{
> +	int len = strlen(XATTR_NAME_SMACK);
> +
> +	if (buffer != NULL && len <= buffer_size) {
> +		memcpy(buffer, XATTR_NAME_SMACK, len);
> +		return len;
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * smack_d_instantiate - Make sure the blob is correct on an inode
> + * @opt_dentry: unused
> + * @inode: the object
> + *
> + * Set the inode's security blob if it hasn't been done already.
> + */
> +static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
> +{
> +	struct super_block *sbp;
> +	struct superblock_smack *sbsp;
> +	struct inode_smack *isp;
> +	char *csp = current->security;
> +	char *fetched;
> +	char *final;
> +	struct dentry *dp;
> +
> +	if (inode == NULL)
> +		return;
> +
> +	if (inode->i_security == NULL)
> +		inode->i_security =
> +			new_inode_smack(smack_known_unset.smk_known);

Race - allocation has to happen from the alloc hook.

> +
> +	isp = inode->i_security;
> +
> +	mutex_lock(&isp->smk_lock);
> +	/*
> +	 * If the inode is already instantiated
> +	 * take the quick way out
> +	 */
> +	if (isp->smk_flags & SMK_INODE_INSTANT)
> +		goto unlockandout;
> +
> +	sbp = inode->i_sb;
> +	sbsp = sbp->s_security;
> +	/*
> +	 * We're going to use the superblock default label
> +	 * if there's no label on the file.
> +	 */
> +	final = sbsp->smk_default;
> +
> +	/*
> +	 * This is pretty hackish.
> +	 * Casey says that we shouldn't have to do
> +	 * file system specific code, but it does help
> +	 * with keeping it simple.
> +	 */
> +	switch (sbp->s_magic) {
> +	case SMACK_MAGIC:
> +		/*
> +		 * Casey says that it's a little embarassing
> +		 * that the smack file system doesn't do
> +		 * extended attributes.
> +		 */
> +		final = smack_known_star.smk_known;
> +		break;
> +	case PIPEFS_MAGIC:
> +		/*
> +		 * Casey says pipes are easy (?)
> +		 */
> +		final = smack_known_star.smk_known;
> +		break;
> +	case DEVPTS_SUPER_MAGIC:
> +		/*
> +		 * devpts seems content with the label of the task.
> +		 * Programs that change smack have to treat the
> +		 * pty with respect.
> +		 */
> +		final = csp;
> +		break;
> +	case SOCKFS_MAGIC:
> +		/*
> +		 * Casey says sockets get the smack of the task.
> +		 */
> +		final = csp;
> +		break;
> +	case PROC_SUPER_MAGIC:
> +		/*
> +		 * Casey says procfs appears not to care.
> +		 * The superblock default suffices.
> +		 */
> +		break;
> +	case TMPFS_MAGIC:
> +		/*
> +		 * Device labels should come from the filesystem,
> +		 * but watch out, because they're volitile,
> +		 * getting recreated on every reboot.
> +		 */
> +		final = smack_known_star.smk_known;
> +		/*
> +		 * No break.
> +		 *
> +		 * If a smack value has been set we want to use it,
> +		 * but since tmpfs isn't giving us the opportunity
> +		 * to set mount options simulate setting the
> +		 * superblock default.
> +		 */
> +	default:
> +		/*
> +		 * This isn't an understood special case.
> +		 * Get the value from the xattr.
> +		 *
> +		 * No xattr support means, alas, no SMACK label.
> +		 * Use the aforeapplied default.
> +		 * It would be curious if the label of the task
> +		 * does not match that assigned.
> +		 */
> +		if (inode->i_op->getxattr == NULL)
> +			break;
> +		/*
> +		 * Get the dentry for xattr.
> +		 */
> +		if (opt_dentry == NULL) {
> +			dp = d_find_alias(inode);
> +			if (dp == NULL)
> +				break;
> +		} else {
> +			dp = dget(opt_dentry);
> +			if (dp == NULL)
> +				break;
> +		}
> +
> +		fetched = smk_fetch(inode, dp);
> +		if (fetched != NULL)
> +			final = fetched;
> +
> +		dput(dp);
> +		break;
> +	}
> +
> +	if (final == NULL)
> +		isp->smk_inode = csp;
> +	else
> +		isp->smk_inode = final;
> +
> +	isp->smk_flags |= SMK_INODE_INSTANT;
> +
> +unlockandout:
> +	mutex_unlock(&isp->smk_lock);
> +	return;
> +}
> +
> +/*
> + * File Hooks
> + */
> +
> +/**
> + * smack_file_alloc_security - assign a file security blob
> + * @file: the object
> + *
> + * The security blob for a file is a pointer to the master
> + * label list, so no allocation is done.
> + *
> + * Returns 0
> + */
> +static int smack_file_alloc_security(struct file *file)
> +{
> +	file->f_security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_file_free_security - clear a file security blob
> + * @file: the object
> + *
> + * The security blob for a file is a pointer to the master
> + * label list, so no memory is freed.
> + */
> +static void smack_file_free_security(struct file *file)
> +{
> +	file->f_security = NULL;
> +}
> +
> +/**
> + * smack_file_permission - Smack check on file operations
> + * @file: unused
> + * @mask: unused
> + *
> + * Returns 0
> + *
> + * Should access checks be done on each read or write?
> + * UNICOS and SELinux say yes.
> + * Trusted Solaris, Trusted Irix, and just about everyone else says no.
> + *
> + * I'll say no for now. Smack does not do the frequent
> + * label changing that SELinux does.
> + */
> +static int smack_file_permission(struct file *file, int mask)
> +{
> +	return 0;
> +}
> +
> +/**
> + * smack_file_ioctl - Smack check on ioctls
> + * @file: the object
> + * @cmd: what to do
> + * @arg: unused
> + *
> + * Relies heavily on the correct use of the ioctl command conventions.
> + *
> + * Returns 0 if allowed, error code otherwise
> + */
> +static int smack_file_ioctl(struct file *file, unsigned int cmd,
> +			    unsigned long arg)
> +{
> +	int rc = 0;
> +
> +	if (_IOC_DIR(cmd) & _IOC_WRITE)
> +		rc = smk_curacc(file->f_security, MAY_WRITE);
> +
> +	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
> +		rc = smk_curacc(file->f_security, MAY_READ);
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_file_lock - Smack check on file locking
> + * @file: the object
> + * @cmd unused
> + *
> + * Returns 0 if current has write access, error code otherwise
> + */
> +static int smack_file_lock(struct file *file, unsigned int cmd)
> +{
> +	return smk_curacc(file->f_security, MAY_WRITE);
> +}
> +
> +/**
> + * smack_file_fcntl - Smack check on fcntl
> + * @file: the object
> + * @cmd: what action to check
> + * @arg: unused
> + *
> + * Returns 0 if current has access, error code otherwise
> + */
> +static int smack_file_fcntl(struct file *file, unsigned int cmd,
> +			    unsigned long arg)
> +{
> +	int rc;
> +
> +	switch (cmd) {
> +	case F_DUPFD:
> +	case F_GETFD:
> +	case F_GETFL:
> +	case F_GETLK:
> +	case F_GETOWN:
> +	case F_GETSIG:
> +		rc = smk_curacc(file->f_security, MAY_READ);
> +		break;
> +	case F_SETFD:
> +	case F_SETFL:
> +	case F_SETLK:
> +	case F_SETLKW:
> +	case F_SETOWN:
> +	case F_SETSIG:
> +		rc = smk_curacc(file->f_security, MAY_WRITE);
> +		break;
> +	default:
> +		rc = smk_curacc(file->f_security, MAY_READWRITE);
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_file_send_sigiotask - Smack on sigio
> + * @tsk: The target task
> + * @fown: the object the signal come from
> + * @signum: unused
> + *
> + * Allow a privileged task to get signals even if it shouldn't
> + *
> + * Returns 0 if a subject with the object's smack could
> + * write to the task, an error code otherwise.
> + */
> +static int smack_file_send_sigiotask(struct task_struct *tsk,
> +				     struct fown_struct *fown, int signum)
> +{
> +	struct file *file;
> +	int rc;
> +
> +	/*
> +	 * struct fown_struct is never outside the context of a struct file
> +	 */
> +	file = (struct file *)((long)fown - offsetof(struct file, f_owner));
> +	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
> +	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
> +		return 0;
> +	return rc;
> +}
> +
> +/**
> + * smack_file_receive - Smack file receive check
> + * @file: the object
> + *
> + * Returns 0 if current has access, error code otherwise
> + */
> +static int smack_file_receive(struct file *file)
> +{
> +	int may = 0;
> +
> +	/*
> +	 * This code relies on bitmasks.
> +	 */
> +	if (file->f_mode & FMODE_READ)
> +		may = MAY_READ;
> +	if (file->f_mode & FMODE_WRITE)
> +		may |= MAY_WRITE;
> +
> +	return smk_curacc(file->f_security, may);
> +}
> +
> +/*
> + * Socket hooks.
> + */
> +
> +/**
> + * smack_sk_alloc_security - Allocate a socket blob
> + * @sk: the socket
> + * @family: unused
> + * @priority: memory allocation priority
> + *
> + * Assign Smack pointers to current except for smk_packet which
> + * is not a pointer but the real thing.
> + *
> + * Returns 0 on success, -ENOMEM is there's no memory
> + */
> +static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
> +{
> +	char *csp = current->security;
> +	struct socket_smack *ssp;
> +
> +	ssp = kzalloc(sizeof(struct socket_smack), priority);
> +	if (ssp == NULL)
> +		return -ENOMEM;
> +
> +	ssp->smk_in = csp;
> +	ssp->smk_out = csp;
> +	memset(ssp->smk_packet, '\0', SMK_LABELLEN);
> +	strcpy(ssp->smk_packet, smack_known_invalid.smk_known);
> +	ssp->smk_depth = 0;
> +
> +	sk->sk_security = ssp;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_sk_free_security - Free a socket blob
> + * @sk: the socket
> + *
> + * Clears the blob pointer
> + */
> +static void smack_sk_free_security(struct sock *sk)
> +{
> +	kfree(sk->sk_security);
> +	sk->sk_security = NULL;
> +}
> +
> +/**
> + * smack_set_catset - convert a capset to netlabel mls categories
> + * @catset: the Smack categories
> + * @sap: where to put the netlabel categories
> + *
> + * Allocates and fills mls_cat
> + */
> +static void smack_set_catset(char *catset, struct netlbl_lsm_secattr *sap)
> +{
> +	unsigned char *cp;
> +	unsigned char m;
> +	int cat;
> +	int rc;
> +
> +	if (catset == 0)
> +		return;
> +
> +	sap->flags |= NETLBL_SECATTR_MLS_CAT;
> +	sap->mls_cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
> +	sap->mls_cat->startbit = 0;
> +
> +	for (cat = 1, cp = catset; *cp != 0; cp++)
> +		for (m = 0x80; m != 0; m >>= 1, cat++) {
> +			if ((m & *cp) == 0)
> +				continue;
> +			rc = netlbl_secattr_catmap_setbit(sap->mls_cat, cat,
> +							  GFP_ATOMIC);
> +		}
> +}
> +
> +/**
> + * smack_to_secattr - fill a secattr from a smack value
> + * @smack: the smack value
> + * @nlsp: where the result goes
> + *
> + * Casey says that CIPSO is good enough for now.
> + * It can be used to effect.
> + * It can also be abused to effect when necessary.
> + * Appologies to the TSIG group in general and GW in particular.
> + */
> +static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
> +{
> +	struct smack_cipso cipso;
> +	int rc;
> +
> +	switch (smack_net_nltype) {
> +	case NETLBL_NLTYPE_CIPSOV4:
> +		nlsp->domain = NULL;
> +		nlsp->flags = NETLBL_SECATTR_DOMAIN;
> +		nlsp->flags |= NETLBL_SECATTR_MLS_LVL;
> +
> +		rc = smack_to_cipso(smack, &cipso);
> +		if (rc == 0) {
> +			nlsp->mls_lvl = cipso.smk_level;
> +			smack_set_catset(cipso.smk_catset, nlsp);
> +		} else {
> +			nlsp->mls_lvl = smack_cipso_direct;
> +			smack_set_catset(smack, nlsp);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/**
> + * smack_netlabel - Set the secattr on a socket
> + * @sk: the socket
> + *
> + * Convert the outbound smack value (smk_out) to a
> + * secattr and attach it to the socket.
> + *
> + * Returns 0 on success or an error code
> + */
> +static int smack_netlabel(struct sock *sk)
> +{
> +	struct socket_smack *ssp = sk->sk_security;
> +	struct netlbl_lsm_secattr secattr;
> +	int rc = 0;
> +
> +	netlbl_secattr_init(&secattr);
> +	smack_to_secattr(ssp->smk_out, &secattr);
> +	if (secattr.flags != NETLBL_SECATTR_NONE)
> +		rc = netlbl_sock_setattr(sk, &secattr);
> +
> +	netlbl_secattr_destroy(&secattr);
> +	return rc;
> +}
> +
> +/**
> + * smack_socket_post_create - finish socket setup
> + * @sock: the socket
> + * @family: protocol family
> + * @type: unused
> + * @protocol: unused
> + * @kern: indicates kern vs task socket
> + *
> + * Sets the security blob on the socket's inode.
> + * Sets the secattr value for outgoing packets.
> + *
> + * Returns 0 on success, and error code otherwise
> + */
> +static int smack_socket_post_create(struct socket *sock, int family,
> +				    int type, int protocol, int kern)
> +{
> +	struct inode_smack *isp;
> +
> +	isp = SOCK_INODE(sock)->i_security;
> +
> +	if (isp == NULL) {

Bug.

> +		if (kern)
> +			isp = new_inode_smack(smack_known_floor.smk_known);
> +		else
> +			isp = new_inode_smack(current->security);
> +		SOCK_INODE(sock)->i_security = isp;
> +	}
> +
> +	if (family != PF_INET)
> +		return 0;
> +
> +	/*
> +	 * Set the outbound netlbl.
> +	 */
> +	return smack_netlabel(sock->sk);
> +}
> +
> +/**
> + * smack_inode_create - Smack check on inode creation
> + * @dir: containing directory object
> + * @dentry: unused
> + * @mode: unused
> + *
> + * Returns 0 if current can write the containing directory,
> + * error code otherwise
> + */
> +static int smack_inode_create(struct inode *dir, struct dentry *dentry,
> +			      int mode)
> +{
> +	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +}

Hmmm...ordering of hooks is random?
Anyway, same comment here as for the earlier inode hooks - if you only
care about directory checks, that happens before they are reached.

> +
> +/**
> + * smack_inode_unlink - Smack check on inode deletion
> + * @dir: containing directory object
> + * @dentry: file to unlink
> + *
> + * Returns 0 if current can write the containing directory
> + * and the object, error code otherwise
> + */
> +static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *ip = dentry->d_inode;
> +	int rc;
> +
> +	/*
> +	 * You need write access to the thing you're unlinking
> +	 */
> +	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
> +	if (rc == 0)
> +		/*
> +		 * You also need write access to the containing directory
> +		 */
> +		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_inode_mkdir - Smack check on directory creation
> + * @dir: containing directory object
> + * @dentry: unused
> + * @mode: unused
> + *
> + * Returns 0 if current can write the containing directory,
> + * error code otherwise
> + */
> +static int smack_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> +{
> +	return smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +}

And again.

> +
> +/**
> + * smack_inode_rmdir - Smack check on directory deletion
> + * @dir: containing directory object
> + * @dentry: directory to unlink
> + *
> + * Returns 0 if current can write the containing directory
> + * and the directory, error code otherwise
> + */
> +static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *ip = dentry->d_inode;
> +	int rc;
> +
> +	/*
> +	 * You need write access to the thing you're removing
> +	 */
> +	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
> +	if (rc == 0)
> +		/*
> +		 * You also need write access to the containing directory
> +		 */
> +		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
> +
> +	return rc;
> +}
> +
> +/**
> + * smack_file_set_fowner - set the file security blob value
> + * @file: object in question
> + *
> + * Returns 0
> + * Further research may be required on this one.
> + */
> +static int smack_file_set_fowner(struct file *file)
> +{
> +	file->f_security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_task_getpgid - Smack access check for getpgid
> + * @p: the object task
> + *
> + * Returns 0 if current can read the object task, error code otherwise
> + */
> +static int smack_task_getpgid(struct task_struct *p)
> +{
> +	return smk_curacc(p->security, MAY_READ);
> +}
> +
> +/**
> + * smack_task_getsid - Smack access check for getsid
> + * @p: the object task
> + *
> + * Returns 0 if current can read the object task, error code otherwise
> + */
> +static int smack_task_getsid(struct task_struct *p)
> +{
> +	return smk_curacc(p->security, MAY_READ);
> +}
> +
> +/**
> + * smack_task_getsecid - get the secid of the task
> + * @p: the object task
> + * @secid: where to put the result
> + *
> + * Sets the secid to contain a u32 version of the smack label.
> + */
> +static void smack_task_getsecid(struct task_struct *p, u32 *secid)
> +{
> +	*secid = smack_to_secid(p->security);
> +}
> +
> +/**
> + * smack_flags_to_may - convert S_ to MAY_ values
> + * @flags: the S_ value
> + *
> + * Returns the equivalent MAY_ value
> + */
> +static int smack_flags_to_may(int flags)
> +{
> +	int may = 0;
> +
> +	if (flags & S_IRUGO)
> +		may |= MAY_READ;
> +	if (flags & S_IWUGO)
> +		may |= MAY_WRITE;
> +	if (flags & S_IXUGO)
> +		may |= MAY_EXEC;
> +
> +	return may;
> +}
> +
> +/**
> + * smack_msg_msg_alloc_security - Set the security blob for msg_msg
> + * @msg: the object
> + *
> + * Returns 0
> + */
> +static int smack_msg_msg_alloc_security(struct msg_msg *msg)
> +{
> +	msg->security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_msg_msg_free_security - Clear the security blob for msg_msg
> + * @msg: the object
> + *
> + * Clears the blob pointer
> + */
> +static void smack_msg_msg_free_security(struct msg_msg *msg)
> +{
> +	msg->security = NULL;
> +}
> +
> +/**
> + * smack_of_shm - the smack pointer for the shm
> + * @shp: the object
> + *
> + * Returns a pointer to the smack value
> + */
> +static char *smack_of_shm(struct shmid_kernel *shp)
> +{
> +	if (shp == NULL)
> +		return NULL;
> +
> +	return (char *)shp->shm_perm.security;
> +}
> +
> +/**
> + * smack_shm_alloc_security - Set the security blob for shm
> + * @shp: the object
> + *
> + * Returns 0
> + */
> +static int smack_shm_alloc_security(struct shmid_kernel *shp)
> +{
> +	struct kern_ipc_perm *isp = &shp->shm_perm;
> +
> +	isp->security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_shm_free_security - Clear the security blob for shm
> + * @shp: the object
> + *
> + * Clears the blob pointer
> + */
> +static void smack_shm_free_security(struct shmid_kernel *shp)
> +{
> +	struct kern_ipc_perm *isp = &shp->shm_perm;
> +
> +	isp->security = NULL;
> +}
> +
> +/**
> + * smack_shm_associate - Smack access check for shm
> + * @shp: the object
> + * @shmflg: access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
> +{
> +	char *ssp = smack_of_shm(shp);
> +	int may;
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	may = smack_flags_to_may(shmflg);
> +	return smk_curacc(ssp, may);
> +}
> +
> +/**
> + * smack_shm_shmctl - Smack access check for shm
> + * @shp: the object
> + * @cmd: what it wants to do
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
> +{
> +	char *ssp = smack_of_shm(shp);
> +	int may;
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	switch (cmd) {
> +	case IPC_STAT:
> +	case SHM_STAT:
> +		may = MAY_READ;
> +		break;
> +	case IPC_SET:
> +	case SHM_LOCK:
> +	case SHM_UNLOCK:
> +	case IPC_RMID:
> +		may = MAY_READWRITE;
> +		break;
> +	case IPC_INFO:
> +	case SHM_INFO:
> +		/*
> +		 * System level information.
> +		 */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return smk_curacc(ssp, may);
> +}
> +
> +/**
> + * smack_shm_shmat - Smack access for shmat
> + * @shp: the object
> + * @shmaddr: unused
> + * @shmflg: access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
> +			   int shmflg)
> +{
> +	char *ssp = smack_of_shm(shp);
> +	int may;
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	may = smack_flags_to_may(shmflg);
> +	return smk_curacc(ssp, may);
> +}
> +
> +/**
> + * smack_of_sem - the smack pointer for the sem
> + * @sma: the object
> + *
> + * Returns a pointer to the smack value
> + */
> +static char *smack_of_sem(struct sem_array *sma)
> +{
> +	if (sma == NULL)
> +		return NULL;
> +
> +	return (char *)sma->sem_perm.security;
> +}
> +
> +/**
> + * smack_sem_alloc_security - Set the security blob for sem
> + * @sma: the object
> + *
> + * Returns 0
> + */
> +static int smack_sem_alloc_security(struct sem_array *sma)
> +{
> +	struct kern_ipc_perm *isp = &sma->sem_perm;
> +
> +	isp->security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_sem_free_security - Clear the security blob for sem
> + * @sma: the object
> + *
> + * Clears the blob pointer
> + */
> +static void smack_sem_free_security(struct sem_array *sma)
> +{
> +	struct kern_ipc_perm *isp = &sma->sem_perm;
> +
> +	isp->security = NULL;
> +}
> +
> +/**
> + * smack_sem_associate - Smack access check for sem
> + * @sma: the object
> + * @semflg: access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_sem_associate(struct sem_array *sma, int semflg)
> +{
> +	char *ssp = smack_of_sem(sma);
> +	int may;
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	may = smack_flags_to_may(semflg);
> +	return smk_curacc(ssp, may);
> +}
> +
> +/**
> + * smack_sem_shmctl - Smack access check for sem
> + * @sma: the object
> + * @cmd: what it wants to do
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_sem_semctl(struct sem_array *sma, int cmd)
> +{
> +	char *ssp = smack_of_sem(sma);
> +	int may;
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	switch (cmd) {
> +	case GETPID:
> +	case GETNCNT:
> +	case GETZCNT:
> +	case GETVAL:
> +	case GETALL:
> +	case IPC_STAT:
> +	case SEM_STAT:
> +		may = MAY_READ;
> +		break;
> +	case SETVAL:
> +	case SETALL:
> +	case IPC_RMID:
> +	case IPC_SET:
> +		may = MAY_READWRITE;
> +		break;
> +	case IPC_INFO:
> +	case SEM_INFO:
> +		/*
> +		 * System level information
> +		 */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return smk_curacc(ssp, may);
> +}
> +
> +/**
> + * smack_sem_semop - Smack checks of semaphore operations
> + * @sma: the object
> + * @sops: unused
> + * @nsops: unused
> + * @alter: unused
> + *
> + * Treated as read and write in all cases.
> + *
> + * Returns 0 if access is allowed, error code otherwise
> + */
> +static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
> +			   unsigned nsops, int alter)
> +{
> +	char *ssp = smack_of_sem(sma);
> +
> +	if (ssp == NULL)
> +		return 0;

Bug?

> +
> +	return smk_curacc(ssp, MAY_READWRITE);
> +}
> +
> +/**
> + * smack_msg_alloc_security - Set the security blob for msg
> + * @msq: the object
> + *
> + * Returns 0
> + */
> +static int smack_msg_queue_alloc_security(struct msg_queue *msq)
> +{
> +	struct kern_ipc_perm *kisp = &msq->q_perm;
> +
> +	kisp->security = current->security;
> +	return 0;
> +}
> +
> +/**
> + * smack_msg_free_security - Clear the security blob for msg
> + * @msq: the object
> + *
> + * Clears the blob pointer
> + */
> +static void smack_msg_queue_free_security(struct msg_queue *msq)
> +{
> +	struct kern_ipc_perm *kisp = &msq->q_perm;
> +
> +	kisp->security = NULL;
> +}
> +
> +/**
> + * smack_of_msq - the smack pointer for the msq
> + * @msq: the object
> + *
> + * Returns a pointer to the smack value
> + */
> +static char *smack_of_msq(struct msg_queue *msq)
> +{
> +	if (msq == NULL)
> +		return NULL;
> +
> +	return (char *)msq->q_perm.security;
> +}
> +
> +/**
> + * smack_msg_queue_associate - Smack access check for msg_queue
> + * @msq: the object
> + * @msqflg: access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
> +{
> +	char *msp = smack_of_msq(msq);
> +	int may;
> +
> +	if (msp == NULL)
> +		return 0;

You get the idea.

> +
> +	may = smack_flags_to_may(msqflg);
> +	return smk_curacc(msp, may);
> +}
> +
> +/**
> + * smack_msg_queue_msgctl - Smack access check for msg_queue
> + * @msq: the object
> + * @cmd: what it wants to do
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
> +{
> +	char *msp = smack_of_msq(msq);
> +	int may;
> +
> +	if (msp == NULL)
> +		return 0;
> +
> +	switch (cmd) {
> +	case IPC_STAT:
> +	case MSG_STAT:
> +		may = MAY_READ;
> +		break;
> +	case IPC_SET:
> +	case IPC_RMID:
> +		may = MAY_READWRITE;
> +		break;
> +	case IPC_INFO:
> +	case MSG_INFO:
> +		/*
> +		 * System level information
> +		 */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return smk_curacc(msp, may);
> +}
> +
> +/**
> + * smack_msg_queue_msgsnd - Smack access check for msg_queue
> + * @msq: the object
> + * @msg: unused
> + * @msqflg: access requested
> + *
> + * Returns 0 if current has the requested access, error code otherwise
> + */
> +static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
> +				  int msqflg)
> +{
> +	char *msp = smack_of_msq(msq);
> +	int rc;
> +
> +	if (msp == NULL)
> +		return 0;
> +
> +	rc = smack_flags_to_may(msqflg);
> +	return smk_curacc(msp, rc);
> +}
> +
> +/**
> + * smack_msg_queue_msgsnd - Smack access check for msg_queue
> + * @msq: the object
> + * @msg: unused
> + * @target: unused
> + * @type: unused
> + * @mode: unused
> + *
> + * Returns 0 if current has read and write access, error code otherwise
> + */
> +static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
> +			struct task_struct *target, long type, int mode)
> +{
> +	char *msp = smack_of_msq(msq);
> +
> +	if (msp == NULL)
> +		return 0;
> +
> +	return smk_curacc(msp, MAY_READWRITE);
> +}
> +
> +/**
> + * smack_ipc_permission - Smack access for ipc_permission()
> + * @ipp: the object permissions
> + * @flag: access requested
> + *
> + * Returns 0 if current has read and write access, error code otherwise
> + */
> +static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
> +{
> +	char *isp = ipp->security;
> +	int may;
> +
> +	may = smack_flags_to_may(flag);
> +	return smk_curacc(isp, may);
> +}
> +
> +/**
> + * smack_task_to_inode - copy task smack into the inode blob
> + * @p: task to copy from
> + * inode: inode to copy to
> + *
> + * Sets the smack pointer in the inode security blob
> + */
> +static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
> +{
> +	struct inode_smack *isp = inode->i_security;
> +	isp->smk_inode = p->security;
> +}
> +
> +/**
> + * smack_task_wait - Smack access check for waiting
> + * @p: task to wait for
> + *
> + * Returns 0 if current can wait for p, error code otherwise
> + */
> +static int smack_task_wait(struct task_struct *p)
> +{
> +	int rc;
> +
> +	rc = smk_access(current->security, p->security, MAY_WRITE);
> +	if (rc == 0)
> +		return 0;

wait() is a write flow?  Parent is receiving status from child.

> +
> +	/*
> +	 * Allow the operation to succeed if either task
> +	 * has privilege to perform operations that might
> +	 * account for the smack labels having gotten to
> +	 * be different in the first place.
> +	 *
> +	 * This breaks the strict subjet/object access
> +	 * control ideal, taking the object's privilege
> +	 * state into account in the decision as well as
> +	 * the smack value.
> +	 */
> +	if (__capable(current, CAP_MAC_OVERRIDE) ||
> +		__capable(p, CAP_MAC_OVERRIDE))
> +		return 0;
> +
> +	return rc;
> +}

I'm a little surprised you do anything on wait at all, given that you
don't permit label changes on exec and your privilege model is
orthogonal to your MAC model.

wait hook is a bit questionable anyway as something has to ultimately
reap the child.

-- 
Stephen Smalley
National Security Agency

