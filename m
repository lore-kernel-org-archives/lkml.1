Return-Path: <linux-kernel-owner+w=401wt.eu-S1161364AbXDQWJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364AbXDQWJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031278AbXDQWJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:09:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42005 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031272AbXDQWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:09:06 -0400
Date: Tue, 17 Apr 2007 17:08:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/15] Introduce union stack
Message-ID: <20070417220848.GA22586@sergelap.austin.ibm.com>
References: <20070417131459.GA4001@in.ibm.com> <20070417131920.GF4001@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131920.GF4001@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bharata B Rao (bharata@linux.vnet.ibm.com):
> From: Jan Blunck <j.blunck@tu-harburg.de>
> Subject: Introduce union stack.
> 
> Adds union stack infrastructure to the dentry structure and provides
> locking routines to walk the union stack.
> 
> Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  fs/Makefile                  |    2 
>  fs/dcache.c                  |    5 
>  fs/union.c                   |   53 +++++++++
>  include/linux/dcache.h       |   11 +
>  include/linux/dcache_union.h |  243 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 314 insertions(+)
> 
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -49,6 +49,8 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.
>  obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
>  obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
> 
> +obj-$(CONFIG_UNION_MOUNT)	+= union.o
> +
>  obj-$(CONFIG_QUOTA)		+= dquot.o
>  obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
>  obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -936,6 +936,11 @@ struct dentry *d_alloc(struct dentry * p
>  #ifdef CONFIG_PROFILING
>  	dentry->d_cookie = NULL;
>  #endif
> +#ifdef CONFIG_UNION_MOUNT
> +	dentry->d_overlaid = NULL;
> +	dentry->d_topmost = NULL;
> +	dentry->d_union = NULL;
> +#endif
>  	INIT_HLIST_NODE(&dentry->d_hash);
>  	INIT_LIST_HEAD(&dentry->d_lru);
>  	INIT_LIST_HEAD(&dentry->d_subdirs);
> --- /dev/null
> +++ b/fs/union.c
> @@ -0,0 +1,53 @@
> +/*
> + * VFS based union mount for Linux
> + *
> + * Copyright ? 2004-2007 IBM Corporation
> + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/fs.h>
> +
> +struct union_info * union_alloc(void)
> +{
> +	struct union_info *info;
> +
> +	info = kmalloc(sizeof(*info), GFP_ATOMIC);
> +	if (!info)
> +		return NULL;
> +
> +	mutex_init(&info->u_mutex);
> +	mutex_lock(&info->u_mutex);
> +	atomic_set(&info->u_count, 1);
> +	UM_DEBUG_LOCK("allocate union %p\n", info);
> +	return info;
> +}
> +
> +struct union_info * union_get(struct union_info *info)
> +{
> +	BUG_ON(!info);
> +	BUG_ON(!atomic_read(&info->u_count));
> +	atomic_inc(&info->u_count);
> +	UM_DEBUG_LOCK("get union %p (count=%d)\n", info,
> +		      atomic_read(&info->u_count));
> +	return info;
> +}

The locking here needs to be laid out.  It looks like union_get() needs
to be called under union_lock(), while union_get2() (horrible name)
grabs that lock itself, and returns with the lock held?

Similarly union_put clearly needs to be called under union_lock(), so
that should be commented here.

> +void union_put(struct union_info *info)
> +{
> +	BUG_ON(!info);
> +	UM_DEBUG_LOCK("put union %p (count=%d)\n", info,
> +		      atomic_read(&info->u_count));
> +	atomic_dec(&info->u_count);
> +
> +	if (!atomic_read(&info->u_count)) {
> +		UM_DEBUG_LOCK("free union %p\n", info);
> +		kfree(info);
> +	}
> +
> +	return;
> +}
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -93,6 +93,12 @@ struct dentry {
>  	struct dentry *d_parent;	/* parent directory */
>  	struct qstr d_name;
> 
> +#ifdef CONFIG_UNION_MOUNT
> +	struct dentry *d_overlaid;	/* overlaid directory */
> +	struct dentry *d_topmost;	/* topmost directory */
> +	struct union_info *d_union;	/* union directory info */
> +#endif
> +
>  	struct list_head d_lru;		/* LRU list */
>  	/*
>  	 * d_child and d_rcu can share memory
> @@ -325,6 +331,11 @@ static inline struct dentry *dget(struct
>  	return dentry;
>  }
> 
> +/*
> + * Reference counting for union mounts
> + */
> +#include <linux/dcache_union.h>
> +
>  extern struct dentry * dget_locked(struct dentry *);
> 
>  /**
> --- /dev/null
> +++ b/include/linux/dcache_union.h
> @@ -0,0 +1,243 @@
> +/*
> + * VFS based union mount for Linux
> + *
> + * Copyright ? 2004-2007 IBM Corporation
> + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#ifndef __LINUX_DCACHE_UNION_H
> +#define __LINUX_DCACHE_UNION_H
> +#ifdef __KERNEL__
> +
> +#include <linux/union_debug.h>
> +#include <linux/fs_struct.h>
> +#include <asm/atomic.h>
> +#include <asm/semaphore.h>
> +
> +#ifdef CONFIG_UNION_MOUNT
> +
> +/*
> + * This is the union info object, that describes general information about this
> + * union directory
> + *
> + * u_mutex protects the union stack against modification. You can reach it
> + * through the d_union field in struct dentry. Hold it when you are walking
> + * or modifing the union stack !
> + *
> + * NOTE: Read the remark for union_trylock() below!
> + */
> +struct union_info {
> +	atomic_t u_count;
> +	struct mutex u_mutex;
> +};
> +
> +/* allocate/de-allocate */
> +extern struct union_info *union_alloc(void);
> +extern struct union_info *union_get(struct union_info *);
> +extern void union_put(struct union_info *);
> +
> +/*
> + * These are the functions for locking a dentrys union. When one
> + * want to acquire a denties union lock, use:
> + *
> + * - union_lock() when you can sleep,
> + * - union_lock_spinlock() when you are holding a spinlock (that
> + *   you CAN savely give up and reacquire again)
> + * - union_lock_readlock() when you are holding a readlock (that
> + *   you CAN savely give up and reacquire again)
> + *
> + * Otherwise get the union lock early before you enter your
> + * "no sleeping here" code.
> + */
> +static inline void __union_lock(struct union_info *uinfo)
> +{
> +	BUG_ON(!atomic_read(&uinfo->u_count));
> +	mutex_lock(&uinfo->u_mutex);
> +}
> +
> +static inline void union_lock(struct dentry *dentry)
> +{
> +	if (unlikely(dentry && dentry->d_union)) {
> +		struct union_info *ui = dentry->d_union;
> +
> +		UM_DEBUG_LOCK("\"%s\" locking %p (count=%d)\n",
> +			      dentry->d_name.name, ui,
> +			      atomic_read(&ui->u_count));
> +		__union_lock(dentry->d_union);
> +	}
> +}
> +
> +static inline void __union_unlock(struct union_info *uinfo)
> +{
> +	BUG_ON(!atomic_read(&uinfo->u_count));
> +	mutex_unlock(&uinfo->u_mutex);
> +}
> +
> +static inline void union_unlock(struct dentry *dentry)
> +{
> +	if (unlikely(dentry && dentry->d_union)) {
> +		struct union_info *ui = dentry->d_union;
> +
> +		UM_DEBUG_LOCK("\"%s\" unlocking %p (count=%d)\n",
> +			      dentry->d_name.name, ui,
> +			      atomic_read(&ui->u_count));
> +		__union_unlock(dentry->d_union);
> +	}
> +}
> +
> +/*
> + * Two helpers for namespace.c
> + *
> + * FIXME: clean this up to get it right
> + */
> +static inline struct union_info *union_alloc2(struct dentry * dentry)
> +{
> +	struct union_info *uinfo;
> +
> +	spin_lock(&dentry->d_lock);
> +	if (!dentry->d_union) {
> +		dentry->d_union = union_alloc();
> +		uinfo = union_get(dentry->d_union);
> +		spin_unlock(&dentry->d_lock);
> +	} else {
> +		uinfo = union_get(dentry->d_union);
> +		spin_unlock(&dentry->d_lock);
> +		union_lock(dentry);
> +	}
> +
> +	return uinfo;
> +}
> +
> +static inline struct union_info *union_get2(struct dentry * dentry)
> +{
> +	struct union_info *uinfo;
> +
> +	union_lock(dentry);
> +	uinfo = union_get(dentry->d_union);
> +	return uinfo;
> +}
> +
> +static inline void union_release(struct union_info *uinfo)
> +{
> +	if (!uinfo)
> +		return;
> +
> +	mutex_unlock(&uinfo->u_mutex);
> +	union_put(uinfo);

Is it safe to do this - releasing the lock before doing the put?

> +}
> +
> +/*
> + * Immediately return ZERO if the lock is contended, NON-ZERO if it's acquired.
> + */
> +static inline int union_trylock(struct dentry *dentry)
> +{
> +	int locked = 1;
> +
> +	if (unlikely(dentry && dentry->d_union)) {
> +		UM_DEBUG_LOCK("\"%s\" try locking %p (count=%d)\n",
> +			      dentry->d_name.name, dentry->d_union,
> +			      atomic_read(&dentry->d_union->u_count));
> +		BUG_ON(!atomic_read(&dentry->d_union->u_count));
> +		locked = mutex_trylock(&dentry->d_union->u_mutex);
> +		UM_DEBUG_LOCK("\"%s\" trylock %p %s\n", dentry->d_name.name,
> +			      dentry->d_union,
> +			      locked ? "succeeded" : "failed");
> +	}
> +	return (locked ? 1 : 0);
> +}
> +
> +/*
> + * The following functions are locking helpers to guarantee the locking order
> + * in some situations.
> + */
> +
> +static inline void union_lock_spinlock(struct dentry *dentry, spinlock_t *lock)
> +{
> +	while (!union_trylock(dentry)) {
> +		spin_unlock(lock);
> +		cpu_relax();
> +		spin_lock(lock);
> +	}
> +}
> +
> +static inline void union_lock_readlock(struct dentry *dentry, rwlock_t *lock)
> +{
> +	while (!union_trylock(dentry)) {
> +		read_unlock(lock);
> +		cpu_relax();
> +		read_lock(lock);
> +	}
> +}
> +
> +/*
> + * This is a *I can't get no sleep* helper which is called when we try
> + * to access the struct fs_struct *fs field of a struct task_struct.
> + *
> + * Yes, this is possibly starving but we have to change root, altroot
> + * or pwd in the frequency of this while loop. Don't think that this
> + * happens really often ;)
> + *
> + * This is called while holding the rwlock_t fs->lock
> + *
> + * TODO: Unlocking side of union_lock_fs() needs 3 union_unlock()s.
> + * May be introduce union_unlock_fs().
> + *
> + * FIXME: This routine is used when the caller wants to dget one or
> + * more of fs->[root, altroot, pwd]. When the caller doesn't want to
> + * dget _all_ of these, it is strictly not necessary to get union_locks
> + * on all of these. Check.
> + */
> +static inline void union_lock_fs(struct fs_struct *fs)
> +{
> +	int locked;
> +
> +	while (fs) {
> +		locked = union_trylock(fs->root);
> +		if (!locked)
> +			goto loop1;
> +		locked = union_trylock(fs->altroot);
> +		if (!locked)
> +			goto loop2;
> +		locked = union_trylock(fs->pwd);
> +		if (!locked)
> +			goto loop3;
> +		break;
> +	loop3:
> +		union_unlock(fs->altroot);
> +	loop2:
> +		union_unlock(fs->root);
> +	loop1:
> +		read_unlock(&fs->lock);
> +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
> +		cpu_relax();
> +		read_lock(&fs->lock);
> +		continue;
> +	}
> +	BUG_ON(!fs);
> +	return;
> +}
> +
> +#define IS_UNION(dentry) ((dentry)->d_overlaid || (dentry)->d_topmost || \
> +				(dentry)->d_overlaid)
> +
> +#else /* CONFIG_UNION_MOUNT */
> +
> +#define union_lock(dentry) do { /* empty */ } while (0)
> +#define union_trylock(dentry) ({ (1); })
> +#define union_unlock(dentry) do { /* empty */ } while (0)
> +#define union_lock_spinlock(dentry, lock) do { /* empty */ } while (0)
> +#define union_lock_readlock(dentry, lock) do { /* empty */ } while (0)
> +#define union_lock_fs(fs) do { /* empty */ } while (0)
> +#define IS_UNION(dentry) ({ (0); })
> +#define union_alloc2(x) ({ BUG(); (0); })
> +#define union_get2(x) ({ BUG(); (0); })
> +#define union_release(x) do { BUG(); } while (0)
> +
> +#endif	/* CONFIG_UNION_MOUNT */
> +#endif	/* __KERNEL__ */
> +#endif	/* __LINUX_DCACHE_UNION_H */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
