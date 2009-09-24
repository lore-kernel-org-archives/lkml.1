Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZIXQZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZIXQZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZIXQZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:25:53 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:45181 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752858AbZIXQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:25:50 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: WypnxVwVM1lh8c3LKpySQGHg5NaB8d9zzrLCz4be_lLXQeNJmPuaY698M8TNxgd0PU6YIotOL7qkU7lhrez80LoKpSM66uPUTZz_dW4Y9v_ZJWXQ8sxgce6AgE7zPH0rxmK5eZyhoY4X51xjoQF0dIH8LInxYLeuZQqIRPoKNPQtNRPV_cQa2LjaqYgjoGDDqhpOM6mqFEwaD7JkET1eK2n3XPcVQxdqtdP5Ts1IAkF03gZTFTM9iZBlXihpsd1ucT8NHodipWJRFjT8ZA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4ABB9D6D.8000607@schaufler-ca.com>
Date: Thu, 24 Sep 2009 09:25:17 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: andy753421@gmail.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Privilege dropping security module
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090923213109.GA936@c.hsd1.tn.comcast.net>
In-Reply-To: <20090923213109.GA936@c.hsd1.tn.comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer wrote:
> policy.h and policy.c contain the core data types use for storing and accessing
> permission associated with tasks.
>
> dpriv.c contains the struct security_operations hooks for dpriv.
>   
Lots of mechanical comments in line.

The term "privilege" is generally applied to a broader scope
than discretionary access controls. You might want to consider
using a name that is more precisely descriptive of the feature.
It probably isn't that important, but I for one would be happier.

You're not dropping privilege, that would imply restricting
root and/or capability access. You're masking file permissions.

> fs.c contains the securityfs interface that is uses to configure and access
> policies.
>
> readme.txt contains some notes and will eventually be deleted or moved to the
> Documentation folder.
>
> The rest is used for configuring and building dpriv
>
> Signed-off-by: Andy Spencer <andy753421@gmail.com>
>
>  security/Kconfig          |    1 +
>  security/Makefile         |    2 +
>  security/dpriv/Kconfig    |    8 ++
>  security/dpriv/Makefile   |    1 +
>  security/dpriv/dpriv.c    |  124 +++++++++++++++++++++++
>  security/dpriv/fs.c       |  243 +++++++++++++++++++++++++++++++++++++++++++++
>  security/dpriv/policy.c   |  235 +++++++++++++++++++++++++++++++++++++++++++
>  security/dpriv/policy.h   |  228 ++++++++++++++++++++++++++++++++++++++++++
>  security/dpriv/readme.txt |  102 +++++++++++++++++++
>  9 files changed, 944 insertions(+), 0 deletions(-)
>
> diff --git a/security/Kconfig b/security/Kconfig
> index fb363cd..b2e310e 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -159,6 +159,7 @@ config LSM_MMAP_MIN_ADDR
>  	  this low address space will need the permission specific to the
>  	  systems running LSM.
>  
> +source security/dpriv/Kconfig
>  source security/selinux/Kconfig
>  source security/smack/Kconfig
>  source security/tomoyo/Kconfig
> diff --git a/security/Makefile b/security/Makefile
> index 95ecc06..2ca4d14 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_KEYS)			+= keys/
> +subdir-$(CONFIG_SECURITY_DPRIV)         += dpriv
>  subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
>  subdir-$(CONFIG_SECURITY_SMACK)		+= smack
>  subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
> @@ -14,6 +15,7 @@ obj-y		+= commoncap.o min_addr.o
>  obj-$(CONFIG_SECURITY)			+= security.o capability.o
>  obj-$(CONFIG_SECURITYFS)		+= inode.o
>  # Must precede capability.o in order to stack properly.
> +obj-$(CONFIG_SECURITY_DPRIV)		+= dpriv/built-in.o
>  obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
>  obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
>  obj-$(CONFIG_AUDIT)			+= lsm_audit.o
> diff --git a/security/dpriv/Kconfig b/security/dpriv/Kconfig
> new file mode 100644
> index 0000000..17bf66a
> --- /dev/null
> +++ b/security/dpriv/Kconfig
> @@ -0,0 +1,8 @@
> +config SECURITY_DPRIV
> +	bool "Privilege dropping"
> +	depends on SECURITY
> +	select SECURITYFS
> +	default n
> +	help
> +	  This enabled the DPriv privilege dropping mechanism.
> +	  If you are unsure how to answer this question, answer N.
> diff --git a/security/dpriv/Makefile b/security/dpriv/Makefile
> new file mode 100644
> index 0000000..0ff3b05
> --- /dev/null
> +++ b/security/dpriv/Makefile
> @@ -0,0 +1 @@
> +obj-y = dpriv.o policy.o fs.o
> diff --git a/security/dpriv/dpriv.c b/security/dpriv/dpriv.c
> new file mode 100644
> index 0000000..263c5d0
> --- /dev/null
> +++ b/security/dpriv/dpriv.c
> @@ -0,0 +1,124 @@
> +/**
> + * dpriv/dpriv.c -- Linux Security Module interface for privilege dropping
> + *
> + * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
> + * 
> + * This program is free software: you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation, either version 2 of the License, or (at your option)
> + * any later version.
> + * 
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + * 
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
>   

You have defined this in multiple places, which isn't good,
and it's a bit of code that obfuscates what's going on. It
may seem like a good idea, but you'll be better off if you
go ahead and put the code in where you're using it.

> +
> +#include <linux/kernel.h>
> +#include <linux/security.h>
> +#include <linux/sched.h>
> +
> +#include "policy.h"
> +
> +/* Credentials */
> +static void dpriv_cred_free(struct cred *cred)
> +{
> +	kfree(cred->security);
> +	cred->security = NULL;
> +}
> +
> +static int dpriv_cred_prepare(struct cred *new, const struct cred *old,
> +		gfp_t gfp)
> +{
> +	new->security = dpriv_task_dup(old->security);
> +	return 0;
> +}
> +
> +static int dpriv_dentry_open(struct file *file, const struct cred *cred)
> +{
> +	u16 perm, need;
> +
> +	/* Set parent link */
> +	if (file->f_dentry->d_sb->s_root != file->f_dentry &&
> +			file->f_dentry->d_parent)
> +		file->f_inode->i_security = file->f_dentry->d_parent->d_inode;
> +	else
> +		file->f_inode->i_security = NULL;
> +
> +
> +	/* Check privs */
> +	perm = dpriv_policy_get_perm(dpriv_cur_policy, file->f_inode);
> +	need = flags_to_mode(file->f_flags);
> +	need = imode_to_perm(need, file->f_inode);
> +	if (deny(perm, need)) {
> +		char path_buf[4096];
>   

I think I saw this mentioned elsewhere, but you can't put a
4k buffer on the stack.

> +		char *path = d_path(&file->f_path, path_buf, sizeof(path_buf));
> +		pr_debug("denied perm=%o:%o path=%s\n", perm, need, path);
> +		return -EACCES;
> +	}
> +	return 0;
> +}
> +
> +/* Mostly for directory walking */
> +static int dpriv_inode_permission(struct inode *inode, int mask)
> +{
> +	u16 perm = dpriv_policy_get_perm(dpriv_cur_policy, inode);
> +	u16 need = imode_to_perm(mask, inode);
> +	if (deny(perm, need)) {
> +		pr_debug("denied perm=%o:%o:%o inode=%p\n",
> +				perm, need, mask, inode);
> +		return -EACCES;
> +	}
> +	return 0;
> +}
> +
> +/* TODO: Use these to store the multiple pointers? */
> +/*
> +static int dpriv_inode_alloc_security(struct inode *inode)
> +{
> +	return 0;
> +}
> +static int dpriv_inode_init_security(struct inode *inode, struct inode *dir,
> +		char **name, void **value, size_t *len)
> +{
> +	return 0;
> +}
> +static void dpriv_inode_free_security(struct inode *inode)
> +{
> +}
> +*/
> +
> +/* Registration */
> +static struct security_operations dpriv_security_ops = {
> +	.name                 = "dpriv",
> +	.cred_prepare         = dpriv_cred_prepare,
> +	.cred_free            = dpriv_cred_free,
> +	.dentry_open          = dpriv_dentry_open,
> +	.inode_permission     = dpriv_inode_permission,
> +	//.inode_alloc_security = dpriv_inode_alloc_security,
> +	//.inode_init_security  = dpriv_inode_init_security,
> +	//.inode_free_security  = dpriv_inode_free_security,
>   

"//" comments are not used in the kernel

> +	/* TODO: add path operations and update the policies when the
> +	 * filesystem layout changes */
> +};
> +
> +static int __init dpriv_init(void)
> +{
> +	struct cred *cred = (struct cred *)current_cred();
> +
> +	if (!security_module_enable(&dpriv_security_ops))
> +		return 0;
> +	if (register_security(&dpriv_security_ops))
> +		panic("Failure registering DPriv");
> +	cred->security = dpriv_task_new();
> +	pr_info("DPriv initialized\n");
> +	return 0;
> +}
> +
> +security_initcall(dpriv_init);
> diff --git a/security/dpriv/fs.c b/security/dpriv/fs.c
> new file mode 100644
> index 0000000..c0af74d
> --- /dev/null
> +++ b/security/dpriv/fs.c
> @@ -0,0 +1,243 @@
> +/**
> + * dpriv/fs.c -- Security FS interface for privilege dropping
> + *
> + * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
> + * 
> + * This program is free software: you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation, either version 2 of the License, or (at your option)
> + * any later version.
> + * 
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + * 
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/security.h>
> +#include <linux/fs.h>
> +#include <linux/seq_file.h>
> +#include <linux/ctype.h>
> +#include <asm/uaccess.h>
> +
> +#include "policy.h"
> +
> +/* Arbitrary maximum lengths */
> +#define DPRIV_COMMAND_MAX 32
> +#define DPRIV_PATH_MAX    4000
>   

Why use a value other than PATH_MAX? If it's arbitrary,
go with the "standard" arbitrary.

> +
> +/***************************
> + * Generic policy iterator *
> + ***************************/
> +/* Use this for reading form any policy file */
> +static void *generic_seq_start(struct seq_file *sf, loff_t *pos)
> +{
> +	struct dpriv_policy *policy = sf->private;
> +	down_read(&policy->privs_lock);
> +	return seq_list_start(&policy->privs, *pos);
> +}
> +
> +static void *generic_seq_next(struct seq_file *sf, void *seq, loff_t *pos)
> +{
> +	struct dpriv_policy *policy = sf->private;
> +	return seq_list_next(seq, &policy->privs, pos);
> +}
> +
> +static void generic_seq_stop(struct seq_file *sf, void *seq)
> +{
> +	struct dpriv_policy *policy = sf->private;
> +	up_read(&policy->privs_lock);
> +}
> +
> +static int generic_seq_show(struct seq_file *sf, void *seq)
> +{
> +	struct dpriv_line *line = list_entry(seq, struct dpriv_line, list);
> +	char perm_str[DPRIV_PERM_BITS+1];
> +	perm_to_str(line->perm, perm_str);
> +	seq_printf(sf, "%*s %s\n", DPRIV_PERM_BITS, perm_str, line->path);
> +	return 0;
> +}
> +
> +static struct seq_operations generic_seq_ops = {
> +	.start = generic_seq_start,
> +	.next  = generic_seq_next,
> +	.stop  = generic_seq_stop,
> +	.show  = generic_seq_show,
> +};
> +
> +static int generic_seq_open(struct file *file, struct dpriv_policy *policy)
> +{
> +	/* From __seq_open_private
> +	 * Not sure if this is correct way to store private data */
> +	struct seq_file *sf;
> +       	if (seq_open(file, &generic_seq_ops) < 0)
> +		return -ENOMEM;
> + 	sf = file->private_data;
> +	sf->private = policy;
> +	return 0;
> +};
> +
> +
> +
> +/**************
> + * Stage file *
> + **************/
> +static int stage_open(struct inode *inode, struct file *file)
> +{
> +	return generic_seq_open(file, dpriv_cur_stage);
> +};
> +
> +/* Move a char * forward until it reaches non-whitespace */
> +#define strfwd(str) ({                 \
> +	while (*str && isspace(*str))  \
> +		str++;                 \
> +	str;                           \
> +})
> +
> +/* Move a char * forward until it reaches whitespace */
> +#define strwfwd(str) ({                \
> +	while (*str && !isspace(*str)) \
> +		str++;                 \
> +	str;                           \
> +})
>   

Function macros are discouraged. If you really want code duplication
use static inline functions. And stick with your namespace, use
dpriv_strfwd() instead of strfwd().

> +
> +/**
> + * Parse policy lines one at a time.
>   

String parsing in the kernel is considered harmful.
Simplify this.

> + * Format: /\s*([rwxsguRWXSGU\-]*)\s*(.*)(\s*)?/
> + *   \1: See str_to_perm() for discussion
> + *   \2: A file path, \3 trailing whitespace is optional
> + */
> +static ssize_t stage_write(struct file *filp, const char *buffer,
> +		size_t length, loff_t* off)
> +{
> +	/* TODO: read multiple lines */
> +	int perm;
> +	struct file *file;
> +	const int write_max = DPRIV_PERM_BITS+DPRIV_PATH_MAX+10; /* spaces */
> +	char _buf[write_max+1] = {}, *bufp = _buf, *perm_str, *path_str;
> +
> +	if (length > write_max)
> +		length = write_max;
> +	if (copy_from_user(bufp, buffer, length))
> +		return -EFAULT;
> +
> +	/* This parsing is kind of ugly, but should avoid buffer overflows */
> +	/* Parse the perm */
> +	perm_str = strfwd(bufp); /* save ptr */
> +	if (!strwfwd(bufp)[0])   /* make sure we have file */
> +		return -EINVAL;
> +	bufp++[0] = '\0';        /* terminate mdoe_str */
> +	if ((perm = str_to_perm(perm_str)) < 0)
> +		return -EINVAL;
> +
> +	/* Parse the file path */
> +	bufp = strfwd(bufp);     /* to path */
> +	if (bufp[0] == '\0')
> +		return -EINVAL;
> +	if (IS_ERR(file = filp_open(bufp, 0, 0))) {
> +		/* file not found, try trimming spaces */
> +		strstrip(bufp);
> +		if (bufp[0] == '\0')
> +			return -EINVAL;
> +		if (IS_ERR(file = filp_open(bufp, 0, 0)))
> +			return -ENOENT;
> +	}
> +	path_str = kstrdup(bufp, GFP_KERNEL);
> +
> +	dpriv_policy_set_perm(dpriv_cur_stage, file->f_inode, path_str, perm);
> +
> +	pr_debug("dpriv_task=%p pid=%d perm=%o[%s] path=%p[%s]\n",
> +		dpriv_cur_task, current->pid, perm, perm_str, file, path_str);
> +
> +	return length;
> +}
> +
> +static const struct file_operations dpriv_stage_fops = {
> +	.open    = stage_open,
> +	.write   = stage_write,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release,
> +};
> +
> +
> +
> +/***************
> + * Policy file *
> + ***************/
> +static int policy_open(struct inode *inode, struct file *file)
>   

Stick with your namespace.

> +{
> +	return generic_seq_open(file, dpriv_cur_policy);
> +};
> +
> +static const struct file_operations dpriv_policy_fops = {
> +	.open    = policy_open,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release,
> +};
> +
> +
> +
> +/****************
> + * Control file *
> + ****************/
> +/**
> + * Read various commands from the user
> + * Format: /(\w+).* /
> + * Commands:
> + *   commit: copy stage to the policy and reset stage
> + */
> +static ssize_t control_write(struct file *filp, const char *buffer,
>   

Namespace.

> +		size_t length, loff_t* off)
> +{
> +	char command[DPRIV_COMMAND_MAX+1] = {};
> +
> +	if (length > DPRIV_COMMAND_MAX)
> +		length = DPRIV_COMMAND_MAX;
> +
> +	if (copy_from_user(command, buffer, length))
> +		return -EFAULT;
> +
> +	strstrip(command);
> +
> +	if (!strcmp("commit", command)) {
> +		pr_debug("committing stage for pid=%d\n", current->pid);
> +		dpriv_policy_commit(dpriv_cur_stage, dpriv_cur_policy);
> +		dpriv_policy_reset(dpriv_cur_stage);
> +	} else {
> +		pr_debug("unimplemented control coomand `%s'\n", command);
> +	}
> +
> +	return length;
> +}
> +
> +static const struct file_operations dpriv_control_fops = {
> +	.write = control_write,
> +};
> +
> +
> +
> +/****************
> + * Registration *
> + ****************/
> +static int __init dpriv_fs_init(void)
> +{
> +	struct dentry *dpriv_dir = securityfs_create_dir("dpriv", NULL);
> +	securityfs_create_file("stage",
> +			0666, dpriv_dir, NULL, &dpriv_stage_fops);
> +	securityfs_create_file("policy",
> +			0444, dpriv_dir, NULL, &dpriv_policy_fops);
> +	securityfs_create_file("control",
> +			0222, dpriv_dir, NULL, &dpriv_control_fops);
> +	pr_info("DPriv FS initialized\n");
> +	return 0;
> +}
> +
> +fs_initcall(dpriv_fs_init);
> diff --git a/security/dpriv/policy.c b/security/dpriv/policy.c
> new file mode 100644
> index 0000000..14823a0
> --- /dev/null
> +++ b/security/dpriv/policy.c
> @@ -0,0 +1,235 @@
> +/**
> + * dpriv/policy.c -- Privilege dropping core functionality
> + *
> + * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
> + * 
> + * This program is free software: you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation, either version 2 of the License, or (at your option)
> + * any later version.
> + * 
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + * 
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/security.h>
> +#include <linux/sched.h>
> +#include <linux/ctype.h>
> +#include <linux/fs.h>
> +
> +#include "policy.h"
> +
> +/*******************
> + * Permission bits *
> + *******************/
> +static char perm_bit_list[] = "rwxsguRWXSGU";
> +static u16  perm_bit_table['z'] = {
>   

Namespace.

> +	['x'] DPRIV_EXEC,
> +	['w'] DPRIV_WRITE,
> +	['r'] DPRIV_READ,
> +	['s'] DPRIV_KEEPSWP,
> +	['g'] DPRIV_SETGID,
> +	['u'] DPRIV_SETUID,
> +	['X'] DPRIV_WALK,
> +	['W'] DPRIV_CREATE,
> +	['R'] DPRIV_LIST,
> +	['S'] DPRIV_STICKY,
> +	['G'] DPRIV_PASSGID,
> +	['U'] DPRIV_PASSUID,
> +	['-'] 0,
> +}; /* plus 0.25k .. */
> +
> +u16 flags_to_mode(unsigned int flags)
>   

Definitely namespace. Could this be static?

> +{
> +	u16 mode = 0;
> +	if (flags & FMODE_READ ) mode |= DPRIV_READ;
> +	if (flags & FMODE_WRITE) mode |= DPRIV_WRITE;
> +	if (flags & FMODE_EXEC ) mode |= DPRIV_EXEC;
> +	if (flags & O_CREAT    ) mode |= DPRIV_CREATE;
> +	return mode;
> +}
> +
> +int str_to_perm(const char *str)
>   

Definitely namespace. Could this be static?

> +{
> +	int perm = 0;
> +	for (; *str; str++) {
> +		if ((!isalpha(*str) || !perm_bit_table[(int)*str]) &&
> +				*str != '-')
> +			return -1;
> +		perm |= perm_bit_table[(int)*str];
> +	}
> +	return perm;
> +}
> +
> +void perm_to_str(u16 perm, char *str)
>   

Definitely namespace. Could this be static?

> +{
> +	char *c = perm_bit_list;
> +	for (; *c; c++,str++)
> +		*str = (perm & perm_bit_table[(int)*c]) ?  *c : '-';
> +	*str = '\0';
> +}
> +
> +
> +
> +/**************
> + * DPriv Line *
> + **************/
> +struct dpriv_line *dpriv_line_new(const struct inode *inode,
> +		const char *path, u16 perm)
> +{
> +	struct dpriv_line *line;
> +	line = kzalloc(sizeof(struct dpriv_line), GFP_KERNEL);
> +	line->inode = inode;
> +	line->path  = path;
> +	line->perm  = perm;
> +	return line;
> +}
> +
> +
> +
> +/****************
> + * DPriv Policy *
> + ****************/
> +void dpriv_policy_init(struct dpriv_policy *policy)
> +{
> +	INIT_LIST_HEAD(&policy->privs);
> +	init_rwsem(&policy->privs_lock);
> +}
> +
> +void dpriv_policy_reset(struct dpriv_policy *policy)
> +{
> +	struct list_head *pos, *n;
> +	struct dpriv_line *line;
> +	list_for_each_safe(pos, n, &policy->privs){
> +		 line = list_entry(pos, struct dpriv_line, list);
> +		 list_del(pos);
> +		 kfree(line);
> +	}
> +}
> +
> +struct dpriv_line *dpriv_policy_get_line(const struct dpriv_policy *policy,
> +		const struct inode *inode)
> +{
> +	struct dpriv_line *line;
> +	list_for_each_entry(line, &policy->privs, list)
> +		if (line->inode == inode)
> +			return line;
> +	return NULL;
> +}
> +
> +u16 dpriv_policy_get_perm(const struct dpriv_policy *policy,
> +		const struct inode *inode)
> +{
> +	/* Stop if a permissions is found for current node */
> +	struct dpriv_line *line = dpriv_policy_get_line(policy, inode);
> +	if (line)
> +		return line->perm;
> +
> +	/* Allow everything if we've reach the root without finding perms */
> +	/* TODO: recurse to parent filesystems */
> +	if (inode->i_security == NULL)
> +		return USHORT_MAX;
> +
> +	/* Check parents for recursive permissions */
> +	/* TODO: Check for multiple parents */
> +	return dpriv_policy_get_perm(policy, inode->i_security);
> +	// perm = USHORT_MAX;
> +	// foreach parent:
> +	// 	perm &= dpriv_policy_get_perm(policy, inode->d_parent);
> +	// return perm;
>   

Again on the "//" comments.

> +}
> +
> +/* We need the inode and path so we can create the line if it doesn't exist */
> +void dpriv_policy_set_perm(struct dpriv_policy *policy,
> +		const struct inode *inode, const char *path, u16 perm)
> +{
> +	struct dpriv_line *line = dpriv_policy_get_line(policy, inode);
> +	if (line) {
> +		line->perm = perm;
> +	} else {
> +		line = dpriv_line_new(inode, path, perm);
> +		list_add_tail(&line->list, &policy->privs);
> +	}
> +}
> +
> +/* Do a semi-deep copy, that is, copy enough that the policies are distinct,
> + * but without duplicating conostant data such as paths and dentries */
> +void dpriv_policy_append(struct dpriv_policy *from, struct dpriv_policy *to)
> +{
> +	struct dpriv_line *fl, *tl;
> +	list_for_each_entry(fl, &from->privs, list) {
> +		tl = dpriv_line_new(fl->inode, fl->path, fl->perm);
> +		list_add_tail(&tl->list, &to->privs);
> +	}
> +}
> +
> +void dpriv_policy_commit(struct dpriv_policy *from, struct dpriv_policy *to)
> +{
> +	u16 perm;
> +	struct dpriv_line *line, *n;
> +	struct dpriv_policy merge;
> +	dpriv_policy_init(&merge);
> +
> +	/* Merge paths from @to into merge */
> +	list_for_each_entry(line, &to->privs, list) {
> +		perm  = line->perm;
> +		perm &= dpriv_policy_get_perm(from, line->inode);
> +		dpriv_policy_set_perm(&merge, line->inode, line->path, perm);
> +	}
> +
> +	/* Merge paths from @from into merge */
> +	list_for_each_entry(line, &from->privs, list) {
> +		perm  = line->perm;
> +		perm &= dpriv_policy_get_perm(to, line->inode);
> +		dpriv_policy_set_perm(&merge, line->inode, line->path, perm);
> +	}
> +
> +	/* Free old entries */
> +	dpriv_policy_reset(to);
> +	list_for_each_entry_safe(line, n, &merge.privs, list)
> +		list_move_tail(&line->list, &to->privs);
> +}
> +
> +
> +
> +/**************
> + * DPriv Task *
> + **************/
> +struct dpriv_task *dpriv_task_new(void)
> +{
> +	struct dpriv_task *task;
> +	task = kzalloc(sizeof(struct dpriv_task), GFP_KERNEL);
> +
> +	dpriv_policy_init(&task->stage);
> +	dpriv_policy_init(&task->policy);
> +
> +	INIT_LIST_HEAD(&task->fds);
> +	init_rwsem(&task->fds_lock);
> +
> +	return task;
> +}
> +
> +struct dpriv_task *dpriv_task_dup(struct dpriv_task *task)
> +{
> +	struct dpriv_task *copy = dpriv_task_new();
> +	struct dpriv_line *tl, *cl;
> +
> +	/* Copy policies */
> +	dpriv_policy_append(&task->stage,  &copy->stage);
> +	dpriv_policy_append(&task->policy, &copy->policy);
> +
> +	/* Copy file descriptors */
> +	list_for_each_entry(tl, &task->fds, list) {
> +		cl = dpriv_line_new(tl->inode, tl->path, tl->perm);
> +		list_add_tail(&cl->list, &copy->fds);
> +	}
> +	return copy;
> +}
> diff --git a/security/dpriv/policy.h b/security/dpriv/policy.h
> new file mode 100644
> index 0000000..70c0cbb
> --- /dev/null
> +++ b/security/dpriv/policy.h
> @@ -0,0 +1,228 @@
> +/**
> + * dpriv/policy.h -- Privilege dropping core functionality
> + *
> + * Copyright (C) 2009 Andy Spencer <spenceal@rose-hulman.edu>
> + * 
> + * This program is free software: you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation, either version 2 of the License, or (at your option)
> + * any later version.
> + * 
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + * 
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __DPRIV_POLICY_H__
> +#define __DPRIV_POLICY_H__
> +
> +#define f_inode f_dentry->d_inode
> +
> +/**
> + * Terminology
> + *   mode   = `Unix' mode (u16 use for filesyste mode bits)
> + *   perm   = DPriv permission bits (see below)
> + *   privs  = List of files and associated perm
> + *   policy = Privs + whatever else
> + */
> +
> +#define dpriv_cur_task   ((struct dpriv_task *)current_security())
> +#define dpriv_cur_stage  ((struct dpriv_policy *)&dpriv_cur_task->stage)
> +#define dpriv_cur_policy ((struct dpriv_policy *)&dpriv_cur_task->policy)
>   

You may get other feedback, but I think that using macros
to hide indirections make code harder to understand.

> +
> +
> +/*******************
> + * Permission bits *
> + *******************/
> +/* File bits */
> +#define DPRIV_EXEC    (1u<<0 ) /* x */
> +#define DPRIV_WRITE   (1u<<1 ) /* w */
> +#define DPRIV_READ    (1u<<2 ) /* r */
> +#define DPRIV_KEEPSWP (1u<<3 ) /* s (ignored) */
> +#define DPRIV_SETGID  (1u<<4 ) /* g */
> +#define DPRIV_SETUID  (1u<<5 ) /* u */
> +
> +/* Directory bits */
> +#define DPRIV_WALK    (1u<<6 ) /* X */
> +#define DPRIV_CREATE  (1u<<7 ) /* W */
> +#define DPRIV_LIST    (1u<<8 ) /* R */
> +#define DPRIV_STICKY  (1u<<9 ) /* S */
> +#define DPRIV_PASSGID (1u<<10) /* G */
> +#define DPRIV_PASSUID (1u<<11) /* U (ignored) */
> +
> +/* Meta bits/masks */
> +#define DPRIV_PERM_BITS 12
> +#define DPRIV_MASK      0b111111111111
> +#define DPRIV_FILE_MASK 0b000000111111
> +#define DPRIV_DIR_MASK  0b111111000000
> +
> +/* Mode conversion functions */
> +#define deny(perm, request) \
> +	unlikely(perm >= 0 && ~perm & request)
>   

Keep to your namespace and use static inline functions.

> +
> +/* Convert from a unix directory mode to a perm */
> +#define dmode_to_perm(mode) \
> +	((mode<<6))
>   

Keep to your namespace and use static inline functions.

> +
> +/* Convert from a unix file mode to a perm */
> +#define fmode_to_perm(mode) \
> +	(mode)
>   

Keep to your namespace and use static inline functions.

> +
> +/* Convert from a unix perm to a mode based on inode type */
> +#define imode_to_perm(mode, inode)     \
> +	(S_ISDIR(inode->i_mode) ?      \
> +		 dmode_to_perm(mode) : \
> +		 fmode_to_perm(mode))
> +
>   

Keep to your namespace and use static inline functions.

> +/**
> + * Convert struct file->f_flags to a Unix mode
> + * <x>mode_to_perm should probably be called on the resulting mode
> + */
> +u16 flags_to_mode(unsigned int flags);
>   

Keep to your namespace.
> +
> +/**
> + * Parse a permission string into a perm
> + * @str:
> + *  - Format is "rwxsguRWXSGU" (see Permission bits)
> + *  - Order does not matter
> + *  - '-' is ignored, any other character is invalid
> + *  - return -1 on invalid str
> + */
> +int str_to_perm(const char *str);
>   

Keep to your namespace.

> +
> +/**
> + * Convert a perm to a string for printing
> + */
> +void perm_to_str(u16 perm, char *str);
>   

Keep to your namespace.

> +
> +
> +
> +/**************
> + * DPriv Line *
> + **************/
> +/**
> + * An entry in the policy
> + *
> + * Example:
> + *   /var/tmp (rw-)
> + *
> + * @list:  list_head for stroing in policy or fds
> + * @inode: Some point in the filesystem, topically an inode
> + * @path:  Path given when the line was created, debugging only
> + * @perm:  Permissions given to location and it's kids
> + */
> +struct dpriv_line {
> +	struct list_head    list;
> +	const struct inode *inode;
> +	const char         *path;
> +	u16                 perm;
> +};
> +
> +/**
> + * Allocate and initalize a new dpriv_line
> + * @indoe, @path, @perm: fileds to store en line
> + */
> +struct dpriv_line *dpriv_line_new(const struct inode *inode,
> +		const char *path, u16 perm);
> +
> +
> +
> +/****************
> + * DPriv Policy *
> + ****************/
> +/**
> + * Contains permisisons and operations allowed for given security policy
> + *
> + * @privs:      List of dpriv_lines for filesystem privilages
> + * @privs_lock: Used for printing (maybe other?)
> + *
> + * Example:
> + *   privs: 
> + *     /         (r--)
> + *     /bin/     (r-x)
> + *     /tmp/     (rw-)
> + */
> +struct dpriv_policy {
> +	struct list_head privs;
> +	struct rw_semaphore privs_lock;
> +	/* TODO: add other security things */
> +};
> +
> +/* Initialize a blank @policy */
> +void dpriv_policy_init(struct dpriv_policy *policy);
> +
> +/* Clear/free data from @policy */
> +void dpriv_policy_reset(struct dpriv_policy *policy);
> +
> +/* Return the line from @policy->privs that matches @inode */
> +struct dpriv_line *dpriv_policy_get_line(const struct dpriv_policy *policy,
> +		const struct inode *inode);
> +
> +/* Recursivly lookup perm for @inode in @policy */
> +u16 dpriv_policy_get_perm(const struct dpriv_policy *policy,
> +		const struct inode *inode);
> +
> +/* Set perm for @inode in @policy to @perm, create new line if necessasiary */
> +void dpriv_policy_set_perm(struct dpriv_policy *policy,
> +		const struct inode *inode, const char *path, u16 perm);
> +
> +/* Copy lines from @from to @to making sure that no additional oeratoins are
> + * allowed in @to after the commit is performed */
> +void dpriv_policy_commit(struct dpriv_policy *from, struct dpriv_policy *to);
> +
> +
> +
> +/**************
> + * DPriv Task *
> + **************/
> +/**
> + * Contains information for a given task, including the security policy, stage,
> + * and cache information.
> + *
> + * @stage:
> + *   The modifialbe policy, privilages can be allowed or denied in the stage
> + * @policy:
> + *   The effective policy, used to determines whether an action is allowed
> + * @fds:
> + *   Open file descriptors and their implied permissions based on @policy
> + *
> + * @policy can only be modified by commiting @stage to @policy. When this is
> + * done, it is insured that no additional operations will be allowed by @policy
> + * after the commit.
> + *
> + * @fds is used to cache permissions on open file descriptors. This allows
> + * permissions to be quickly passed down form parents when opening directory
> + * entries. Note that when opening a file descriptor with multiple parents
> + * (e.g. a hard link) the permissions from the parent are incomplete and the
> + * permissions form the alternate parents must be determined as well.
> + *
> + * NOTE: @fds is currently not used, we recursivly iterate up to parents
> + * whenever it's needed. This might be faster anyway?
> + *
> + * Example:
> + *   stage:  (see dpriv_policy)
> + *   policy: (see dpriv_policy)
> + *   fds:
> + *     /foo     ~(r--)
> + *     /bin/foo ~(r-x)
> + *     /tmp/foo ~(rw-)
> + */
> +struct dpriv_task {
> +	struct dpriv_policy stage;
> +	struct dpriv_policy policy;
> +
> +	struct list_head fds;
> +	struct rw_semaphore fds_lock;
> +};
> +
> +/* Allocate a blank task */
> +struct dpriv_task *dpriv_task_new(void);
> +
> +/* Create a semi-deep copy of @task, suitable for passing to a child on exec */
> +struct dpriv_task *dpriv_task_dup(struct dpriv_task *task);
> +
> +#endif
> diff --git a/security/dpriv/readme.txt b/security/dpriv/readme.txt
> new file mode 100644
> index 0000000..073d15d
> --- /dev/null
> +++ b/security/dpriv/readme.txt
> @@ -0,0 +1,102 @@
> +Source code
> +-----------
> +  policy.[ch] - policy datatypes
> +  dpriv.c     - security/credentials hooks
> +  fs.c        - securityfs hooks
> +
> +
> +TODO
> +----
> +  - Check for race conditions
> +
> +
> +Overview
> +--------
> +1. Each process keeps a list of inode -> priv mappings:
> +   - i.e. the security policy
> +
> +2. Caching possibilities (todo?)
> +   - Processes keeps a list of open fds to prevent recursing up the FS tree?
> +   - Store the most recent processes access in each inode? 
> +
> +Privs: 
> +  - read/write/exec/sticky/setuid/setgui
> +  - All permissions are recursive
> +  - Permissions for dirs and file are separate
> +    - This prevents recursion problems
> +    - e.g. you can set noexec for files without smashing directories
> +  - Notation
> +     (rwx) = specified permission (inode in policy)
> +    ~(rwx) = implied permission (parent(s) in policy)
> +
> +Things to do when:
> +  1. Setting privs
> +     - Add policy line(s) for given path?
> +     - Update privs on open inodes that are children of policy line?
> +  2. Loading inode
> +     - Cache privs from parent(s)?
> +  3. Namespace modification (mv,ln,bind,etc)
> +     - OR
> +       - Keep policy for inode the same        (policy = old      )
> +       - Merge policy for both locations       (policy = old & new)
> +       - Change policy to reflect new location (policy =       new)
> +     - If mv, and including old implied policy:
> +       - need to write new (combined) policy line
> +
> +
> +Security FS
> +-----------
> +files:
> +  -rw-rw-rw- /securityfs/dpriv/stage
> +  -r--r--r-- /securityfs/dpriv/policy
> +  --w--w--w- /securityfs/dpriv/control
> +
> +stage:
> +  read:  print staged policy
> +  write: set inode in staged policy to given perms OR
> +         add inode to staged policy with given perms
> +         > staged[inode] = perms
> +
> +  In the stage, order does not matter, adding a line simply writes or
> +  overwrites the location with no regard to the rest of the policy.
> +
> +policy:
> +  read: print active policy
> + 
> +control:
> +  write:
> +    "commit" - merge staged policy into policy
> +      > for (inode in policy, staged):
> +      >     new[inode] =
> +      >         implied_privs(policy, inode) &
> +      >         implied_privs(staged, inode) 
> +      > clear(staged)
> +
> +    When committing, privilages can only be revoked.
> +   
> +
> +Examples
> +--------
> +Example 1:
> +  set /src/     (rw-)
> +  set /dst/     (r-x)
> +  
> +  $ mv /src/foo /dst
> +  
> +  get /src/     (rw-)
> +  get /dst/     (r-x)
> +  OR:
> +    get /dst/foo  (rw-)
> +    get /dst/foo ~(r-x)
> +    get /dst/foo  (rw-) & ~(r-x) = (r--)
> +
> +Example 2:
> +  $ ln /src/foo /dst
> +  
> +  set /src/     (rw-)
> +  set /dst/     (rwx)
> +  
> +  get /src/     (rw-)
> +  get /dst/     (rwx)
> +  get /src/foo ~(rw-) & ~(rwx) = ~(rw-)
> +  get /dst/foo ~(rw-) & ~(rwx) = ~(rw-)
>   

