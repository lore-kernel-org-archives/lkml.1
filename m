Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXLJQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXLJQsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXLJQsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:48:22 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:40727 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXLJQsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:48:18 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Dec 2007 11:46:13 -0500
Message-Id: <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 19:38 +0000, David Howells wrote:
> Allow kernel services to override LSM settings appropriate to the actions
> performed by a task by duplicating a security record, modifying it and then
> using task_struct::act_as to point to it when performing operations on behalf
> of a task.
> 
> This is used, for example, by CacheFiles which has to transparently access the
> cache on behalf of a process that thinks it is doing, say, NFS accesses with a
> potentially inappropriate (with respect to accessing the cache) set of
> security data.
> 
> This patch provides two LSM hooks for modifying a task security record:
> 
>  (*) security_kernel_act_as() which allows modification of the security datum
>      with which a task acts on other objects (most notably files).
> 
>  (*) security_create_files_as() which allows modification of the security
>      datum that is used to initialise the security data on a file that a task
>      creates.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/cred.h     |   22 ++++++++++++
>  include/linux/security.h |   35 +++++++++++++++++++
>  kernel/cred.c            |   86 ++++++++++++++++++++++++++++++++++++++++++++++
>  security/dummy.c         |   15 ++++++++
>  security/security.c      |   13 +++++++
>  security/selinux/hooks.c |   45 ++++++++++++++++++++++++
>  6 files changed, 216 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> new file mode 100644
> index 0000000..c9f8906
> --- /dev/null
> +++ b/include/linux/cred.h
> @@ -0,0 +1,22 @@
> +/* Credential management
> + *
> + * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#ifndef _LINUX_CRED_H
> +#define _LINUX_CRED_H
> +
> +struct task_security;
> +struct inode;
> +
> +extern struct task_security *get_kernel_security(const char *,
> +						 struct task_struct *);
> +extern int change_create_files_as(struct task_security *, struct inode *);
> +
> +#endif /* _LINUX_CRED_H */
> diff --git a/include/linux/security.h b/include/linux/security.h
> index b7ba073..f0dce11 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -557,6 +557,18 @@ struct request_sock;
>   *	Duplicate and attach the security structure currently attached to the
>   *	p->security field.
>   *	Return 0 if operation was successful.
> + * @task_kernel_act_as:
> + *	Set the credentials for a kernel service to act as (subjective context).
> + *	@sec points to the task security record to be modified.
> + *	@service names the service making the request.
> + *	@daemon: A userspace daemon to be used as a reference.
> + *	Return 0 if successful.
> + * @task_create_files_as:
> + *	Set the file creation context in a task security record to be the same
> + *	as the objective context of the specified inode.
> + *	@sec points to the task security record to be modified.
> + *	@inode points to the inode to use as a reference.
> + *	Return 0 if successful.
>   * @task_setuid:
>   *	Check permission before setting one or more of the user identity
>   *	attributes of the current process.  The @flags parameter indicates
> @@ -1321,6 +1333,11 @@ struct security_operations {
>  	int (*task_alloc_security) (struct task_struct *p);
>  	void (*task_free_security) (struct task_security *p);
>  	int (*task_dup_security) (struct task_security *p);
> +	int (*task_kernel_act_as)(struct task_security *sec,
> +				  const char *service,
> +				  struct task_struct *daemon);
> +	int (*task_create_files_as)(struct task_security *sec,
> +				    struct inode *inode);
>  	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
>  	int (*task_post_setuid) (uid_t old_ruid /* or fsuid */ ,
>  				 uid_t old_euid, uid_t old_suid, int flags);
> @@ -1571,6 +1588,11 @@ int security_task_create(unsigned long clone_flags);
>  int security_task_alloc(struct task_struct *p);
>  void security_task_free(struct task_security *p);
>  int security_task_dup(struct task_security *p);
> +int security_task_kernel_act_as(struct task_security *sec,
> +				const char *service,
> +				struct task_struct *daemon);
> +int security_task_create_files_as(struct task_security *sec,
> +				  struct inode *inode);
>  int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
>  int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
>  			       uid_t old_suid, int flags);
> @@ -2054,6 +2076,19 @@ static inline int security_task_dup(struct task_security *p)
>  	return 0;
>  }
>  
> +static inline int security_task_kernel_act_as(struct task_security *sec,
> +					      const char *service,
> +					      struct task_struct *daemon)
> +{
> +	return 0;
> +}
> +
> +static inline int security_task_create_files_as(struct task_security *sec,
> +						struct inode *inode)
> +{
> +	return 0;
> +}
> +
>  static inline int security_task_setuid (uid_t id0, uid_t id1, uid_t id2,
>  					int flags)
>  {
> diff --git a/kernel/cred.c b/kernel/cred.c
> index ddf98c6..eac1d0c 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -11,6 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/key.h>
> +#include <linux/keyctl.h>
>  #include <linux/init_task.h>
>  #include <linux/security.h>
>  
> @@ -137,3 +138,88 @@ void put_task_security(struct task_security *sec)
>  	}
>  }
>  EXPORT_SYMBOL(put_task_security);
> +
> +/**
> + * get_kernel_security - Get a task security record for a named kernel service
> + * @service: The name of the service
> + * @daemon: A userspace daemon to be used as a reference
> + *
> + * Get a task security record for a specific kernel service.  This can then be
> + * used to override a task's own security so that work can be done on behalf of
> + * that task that requires a different security context.
> + *
> + * @daemon is used to provide a base for the security record, but can be NULL.
> + * If @daemon is supplied, then the security data will be derived from that;
> + * otherwise they'll be set to 0 and no groups, full capabilities and no keys.
> + *
> + * @daemon is also passd to the LSM module as a base from which to initialise
> + * any MAC controls.
> + *
> + * The caller may change these controls afterwards if desired.
> + */
> +struct task_security *get_kernel_security(const char *service,
> +					  struct task_struct *daemon)
> +{
> +	const struct task_security *dsec;
> +	struct task_security *sec;
> +	int ret;
> +
> +	sec = kzalloc(sizeof *sec, GFP_KERNEL);
> +	if (!sec)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (daemon) {
> +		rcu_read_lock();
> +		dsec = rcu_dereference(daemon->sec);
> +		*sec = *dsec;
> +		get_group_info(sec->group_info);
> +		get_uid(sec->user);
> +		rcu_read_unlock();
> +#ifdef CONFIG_KEYS
> +		sec->request_key_auth = NULL;
> +		sec->thread_keyring = NULL;
> +		sec->tgsec = NULL;
> +#endif
> +	} else {
> +		sec->keep_capabilities = 0;
> +		sec->cap_inheritable = CAP_INIT_INH_SET;
> +		sec->cap_permitted = CAP_FULL_SET;
> +		sec->cap_effective = CAP_INIT_EFF_SET;
> +		sec->user = &root_user;
> +		get_uid(sec->user);
> +		sec->group_info = &init_groups;
> +		get_group_info(sec->group_info);
> +	}
> +
> +	atomic_set(&sec->usage, 1);
> +	spin_lock_init(&sec->lock);
> +#ifdef CONFIG_KEYS
> +	sec->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
> +#endif
> +
> +	ret = security_task_kernel_act_as(sec, service, daemon);
> +	if (ret < 0) {
> +		put_task_security(sec);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return sec;
> +}
> +EXPORT_SYMBOL(get_kernel_security);
> +
> +/**
> + * change_create_files_as - Change the file create context in a security record
> + * @sec: The security record to alter
> + * @inode: The inode to take the context from
> + *
> + * Change the file creation context in a security record to be the same as the
> + * object context of the specified inode, so that the new inodes have the same
> + * MAC context as that inode.
> + */
> +int change_create_files_as(struct task_security *sec, struct inode *inode)
> +{
> +	sec->fsuid = inode->i_uid;
> +	sec->fsgid = inode->i_gid;
> +	return security_task_create_files_as(sec, inode);
> +}
> +EXPORT_SYMBOL(change_create_files_as);
> diff --git a/security/dummy.c b/security/dummy.c
> index 526549d..1c8bad6 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -495,6 +495,19 @@ static int dummy_task_dup_security(struct task_security *p)
>  	return 0;
>  }
>  
> +static int dummy_task_kernel_act_as(struct task_security *sec,
> +				    const char *service,
> +				    struct task_struct *daemon)
> +{
> +	return 0;
> +}
> +
> +static int dummy_task_create_files_as(struct task_security *sec,
> +				      struct inode *inode)
> +{
> +	return 0;
> +}
> +
>  static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
>  {
>  	return 0;
> @@ -1063,6 +1076,8 @@ void security_fixup_ops (struct security_operations *ops)
>  	set_to_dummy_if_null(ops, task_alloc_security);
>  	set_to_dummy_if_null(ops, task_free_security);
>  	set_to_dummy_if_null(ops, task_dup_security);
> +	set_to_dummy_if_null(ops, task_kernel_act_as);
> +	set_to_dummy_if_null(ops, task_create_files_as);
>  	set_to_dummy_if_null(ops, task_setuid);
>  	set_to_dummy_if_null(ops, task_post_setuid);
>  	set_to_dummy_if_null(ops, task_setgid);
> diff --git a/security/security.c b/security/security.c
> index 92d66d6..86d94e5 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -583,6 +583,19 @@ int security_task_dup(struct task_security *sec)
>  	return security_ops->task_dup_security(sec);
>  }
>  
> +int security_task_kernel_act_as(struct task_security *sec,
> +				const char *service,
> +				struct task_struct *daemon)
> +{
> +	return security_ops->task_kernel_act_as(sec, service, daemon);
> +}
> +
> +int security_task_create_files_as(struct task_security *sec,
> +				  struct inode *inode)
> +{
> +	return security_ops->task_create_files_as(sec, inode);
> +}
> +
>  int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
>  {
>  	return security_ops->task_setuid(id0, id1, id2, flags);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 20a6b55..2416f54 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2846,6 +2846,49 @@ static int selinux_task_dup_security(struct task_security *sec)
>  	return 0;
>  }
>  
> +/*
> + * get the security data for a kernel service, deriving the subjective context
> + * from the security data of a userspace daemon if one supplied
> + * - all the creation contexts are set to unlabelled
> + */
> +static int selinux_task_kernel_act_as(struct task_security *sec,
> +				      const char *service,
> +				      struct task_struct *daemon)
> +{
> +	struct task_security_struct *tsec, *dtsec;
> +	u32 ksid;
> +	int ret;
> +
> +	tsec = sec->security;
> +	dtsec = daemon ? daemon->sec->security : init_task.sec->security;
> +
> +	ret = security_transition_sid(dtsec->sid, SECINITSID_KERNEL,
> +				      SECCLASS_PROCESS, &ksid);
> +	if (ret < 0)
> +		return ret;
> +
> +	tsec->sid = ksid;
> +	tsec->create_sid = SECINITSID_UNLABELED;
> +	tsec->keycreate_sid = SECINITSID_UNLABELED;
> +	tsec->sockcreate_sid = SECINITSID_UNLABELED;

These SIDs need to be cleared rather than set to SECINITSID_UNLABELED.

> +	sec->security = tsec;
> +	return 0;
> +}
> +
> +/*
> + * set the file creation context in a security record to the same as the
> + * objective context of the specified inode
> + */
> +static int selinux_task_create_files_as(struct task_security *sec,
> +					struct inode *inode)
> +{
> +	struct task_security_struct *tsec = sec->security;
> +	struct inode_security_struct *isec = inode->i_security;
> +
> +	tsec->create_sid = isec->sid;
> +	return 0;
> +}
> +
>  static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
>  {
>  	/* Since setuid only affects the current process, and
> @@ -4884,6 +4927,8 @@ static struct security_operations selinux_ops = {
>  	.task_alloc_security =		selinux_task_alloc_security,
>  	.task_free_security =		selinux_task_free_security,
>  	.task_dup_security =		selinux_task_dup_security,
> +	.task_kernel_act_as =		selinux_task_kernel_act_as,
> +	.task_create_files_as =		selinux_task_create_files_as,
>  	.task_setuid =			selinux_task_setuid,
>  	.task_post_setuid =		selinux_task_post_setuid,
>  	.task_setgid =			selinux_task_setgid,
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
-- 
Stephen Smalley
National Security Agency

