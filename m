Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0CCRda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:33:30 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46202 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0CCRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:33:28 -0500
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jblunck@suse.de, vaurora@redhat.com
In-reply-to: <1267567889-4637-2-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 2 Mar 2010 14:11:24 -0800)
Subject: Re: [PATCH 1/6] union-mount: Introduce union_mount structure and basic operations
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com>
Message-Id: <E1NmsRk-0003tE-BO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 03 Mar 2010 18:33:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Mar 2010, Valerie Aurora wrote:
> From: Jan Blunck <jblunck@suse.de>
> 
> This patch adds the basic structures and operations of VFS-based union
> mounts (but not the ability to mount or lookup unioned file systems).
> Each directory in a unioned file system has an associated union stack
> created when the directory is first looked up.  The union stack is a
> structure kept in a hash table indexed by mount and dentry of the
> directory; thus, specific paths are unioned, not dentries alone.  The
> union stack keeps a pointer to the upper path and the lower path and
> can be looked up by either path.
> 
> This particular version of union mounts is based on ideas by Jan
> Blunck, Bharata Rao, and many others.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/Kconfig             |   13 ++
>  fs/Makefile            |    1 +
>  fs/dcache.c            |    4 +
>  fs/union.c             |  290 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |   20 ++++
>  include/linux/mount.h  |    3 +
>  include/linux/union.h  |   54 +++++++++
>  7 files changed, 385 insertions(+), 0 deletions(-)
>  create mode 100644 fs/union.c
>  create mode 100644 include/linux/union.h
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 64d44ef..303186b 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -59,6 +59,19 @@ source "fs/notify/Kconfig"
>  
>  source "fs/quota/Kconfig"
>  
> +config UNION_MOUNT
> +       bool "Writable overlays (union mounts) (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL
> +       help
> +         Writable overlays allow you to mount a transparent writable
> +	 layer over a read-only file system, for example, an ext3
> +	 partition on a hard drive over a CD-ROM root file system
> +	 image.
> +
> +	 See <file:Documentation/filesystems/union-mounts.txt> for details.
> +
> +	 If unsure, say N.
> +
>  source "fs/autofs/Kconfig"
>  source "fs/autofs4/Kconfig"
>  source "fs/fuse/Kconfig"
> diff --git a/fs/Makefile b/fs/Makefile
> index af6d047..4ed672e 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
>  obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
>  
>  obj-y				+= quota/
> +obj-$(CONFIG_UNION_MOUNT)	+= union.o
>  
>  obj-$(CONFIG_PROC_FS)		+= proc/
>  obj-y				+= partitions/
> diff --git a/fs/dcache.c b/fs/dcache.c
> index d14c304..0c2dd32 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -960,6 +960,10 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
>  	INIT_LIST_HEAD(&dentry->d_lru);
>  	INIT_LIST_HEAD(&dentry->d_subdirs);
>  	INIT_LIST_HEAD(&dentry->d_alias);
> +#ifdef CONFIG_UNION_MOUNT
> +	INIT_LIST_HEAD(&dentry->d_unions);
> +	dentry->d_unionized = 0;
> +#endif
>  
>  	if (parent) {
>  		dentry->d_parent = dget(parent);
> diff --git a/fs/union.c b/fs/union.c
> new file mode 100644
> index 0000000..2e005d9
> --- /dev/null
> +++ b/fs/union.c
> @@ -0,0 +1,290 @@
> +/*
> + * VFS based union mount for Linux
> + *
> + * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
> + * Copyright (C) 2007-2009 Novell Inc.
> + *
> + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/bootmem.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/hash.h>
> +#include <linux/fs.h>
> +#include <linux/mount.h>
> +#include <linux/fs_struct.h>
> +#include <linux/union.h>
> +
> +/*
> + * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
> + * should try to make this good - I've just made it work.
> + */
> +static unsigned int union_hash_mask __read_mostly;
> +static unsigned int union_hash_shift __read_mostly;
> +static struct hlist_head *union_hashtable __read_mostly;
> +static unsigned int union_rhash_mask __read_mostly;
> +static unsigned int union_rhash_shift __read_mostly;
> +static struct hlist_head *union_rhashtable __read_mostly;
> +
> +/*
> + * Locking Rules:
> + * - dcache_lock (for union_rlookup() only)
> + * - union_lock
> + */
> +DEFINE_SPINLOCK(union_lock);
> +
> +static struct kmem_cache *union_cache __read_mostly;
> +
> +static unsigned long hash(struct dentry *dentry, struct vfsmount *mnt)
> +{
> +	unsigned long tmp;
> +
> +	tmp = ((unsigned long)mnt * (unsigned long)dentry) ^
> +		(GOLDEN_RATIO_PRIME + (unsigned long)mnt) / L1_CACHE_BYTES;
> +	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> union_hash_shift);
> +	return tmp & union_hash_mask;
> +}
> +
> +static __initdata unsigned long union_hash_entries;
> +
> +static int __init set_union_hash_entries(char *str)
> +{
> +	if (!str)
> +		return 0;
> +	union_hash_entries = simple_strtoul(str, &str, 0);
> +	return 1;
> +}
> +
> +__setup("union_hash_entries=", set_union_hash_entries);
> +
> +static int __init init_union(void)
> +{
> +	int loop;
> +
> +	union_cache = KMEM_CACHE(union_mount, SLAB_PANIC | SLAB_MEM_SPREAD);
> +	union_hashtable = alloc_large_system_hash("Union-cache",
> +						  sizeof(struct hlist_head),
> +						  union_hash_entries,
> +						  14,
> +						  0,
> +						  &union_hash_shift,
> +						  &union_hash_mask,
> +						  0);
> +
> +	for (loop = 0; loop < (1 << union_hash_shift); loop++)
> +		INIT_HLIST_HEAD(&union_hashtable[loop]);
> +
> +
> +	union_rhashtable = alloc_large_system_hash("rUnion-cache",
> +						  sizeof(struct hlist_head),
> +						  union_hash_entries,
> +						  14,
> +						  0,
> +						  &union_rhash_shift,
> +						  &union_rhash_mask,
> +						  0);
> +
> +	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
> +		INIT_HLIST_HEAD(&union_rhashtable[loop]);
> +
> +	return 0;
> +}
> +
> +fs_initcall(init_union);
> +
> +struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
> +				struct dentry *next, struct vfsmount *next_mnt)


Why doesn't union_alloc, append_to_union, union_lookup,
union_down_one, etc use "struct path *" arg instead of separate
vfsmount and dentry pointers?


> +{
> +	struct union_mount *um;
> +
> +	BUG_ON(!S_ISDIR(this->d_inode->i_mode));
> +	BUG_ON(!S_ISDIR(next->d_inode->i_mode));
> +
> +	um = kmem_cache_alloc(union_cache, GFP_ATOMIC);
> +	if (!um)
> +		return NULL;
> +
> +	atomic_set(&um->u_count, 1);

Why is u_count not a "struct kref"?


> +	INIT_LIST_HEAD(&um->u_unions);
> +	INIT_HLIST_NODE(&um->u_hash);
> +	INIT_HLIST_NODE(&um->u_rhash);
> +
> +	um->u_this.mnt = this_mnt;
> +	um->u_this.dentry = this;
> +	um->u_next.mnt = mntget(next_mnt);
> +	um->u_next.dentry = dget(next);
> +
> +	return um;
> +}
> +
> +struct union_mount *union_get(struct union_mount *um)
> +{
> +	BUG_ON(!atomic_read(&um->u_count));
> +	atomic_inc(&um->u_count);
> +	return um;
> +}
> +
> +static int __union_put(struct union_mount *um)
> +{
> +	if (!atomic_dec_and_test(&um->u_count))
> +		return 0;
> +
> +	BUG_ON(!hlist_unhashed(&um->u_hash));
> +	BUG_ON(!hlist_unhashed(&um->u_rhash));
> +
> +	kmem_cache_free(union_cache, um);
> +	return 1;
> +}
> +
> +void union_put(struct union_mount *um)
> +{
> +	struct path tmp = um->u_next;
> +
> +	if (__union_put(um))
> +		path_put(&tmp);
> +}
> +
> +static void __union_hash(struct union_mount *um)
> +{
> +	hlist_add_head(&um->u_hash, union_hashtable +
> +		       hash(um->u_this.dentry, um->u_this.mnt));
> +	hlist_add_head(&um->u_rhash, union_rhashtable +
> +		       hash(um->u_next.dentry, um->u_next.mnt));
> +}
> +
> +static void __union_unhash(struct union_mount *um)
> +{
> +	hlist_del_init(&um->u_hash);
> +	hlist_del_init(&um->u_rhash);
> +}
> +
> +struct union_mount *union_lookup(struct dentry *dentry, struct vfsmount *mnt)
> +{
> +	struct hlist_head *head = union_hashtable + hash(dentry, mnt);
> +	struct hlist_node *node;
> +	struct union_mount *um;
> +
> +	hlist_for_each_entry(um, node, head, u_hash) {
> +		if ((um->u_this.dentry == dentry) &&
> +		    (um->u_this.mnt == mnt))
> +			return um;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct union_mount *union_rlookup(struct dentry *dentry, struct vfsmount *mnt)
> +{
> +	struct hlist_head *head = union_rhashtable + hash(dentry, mnt);
> +	struct hlist_node *node;
> +	struct union_mount *um;
> +
> +	hlist_for_each_entry(um, node, head, u_rhash) {
> +		if ((um->u_next.dentry == dentry) &&
> +		    (um->u_next.mnt == mnt))
> +			return um;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * append_to_union - add a path to the bottom of the union stack
> + *
> + * Allocate and attach a union cache entry linking the new, upper
> + * mnt/dentry to the "covered" matching lower mnt/dentry.  It's okay
> + * if the union cache entry already exists.
> + */
> +
> +int append_to_union(struct vfsmount *upper_mnt, struct dentry *upper_dentry,
> +		    struct vfsmount *lower_mnt, struct dentry *lower_dentry)
> +{
> +	struct union_mount *new, *um;
> +
> +	BUG_ON(!S_ISDIR(upper_dentry->d_inode->i_mode));
> +	BUG_ON(!S_ISDIR(lower_dentry->d_inode->i_mode));
> +
> +	/* Common case is that it's already been created, do a lookup first */
> +
> +	spin_lock(&union_lock);
> +	um = union_lookup(upper_dentry, upper_mnt);
> +	if (um) {
> +		BUG_ON((um->u_next.dentry != lower_dentry) ||
> +		       (um->u_next.mnt != lower_mnt));
> +		spin_unlock(&union_lock);
> +		return 0;
> +	}
> +	spin_unlock(&union_lock);
> +
> +	new = union_alloc(upper_dentry, upper_mnt, lower_dentry, lower_mnt);
> +	if (!new)
> +		return -ENOMEM;
> +
> +	spin_lock(&union_lock);
> +	um = union_lookup(upper_dentry, upper_mnt);
> +	if (um) {
> +		/* Someone added it while we were allocating, no problem */
> +		BUG_ON((um->u_next.dentry != lower_dentry) ||
> +		       (um->u_next.mnt != lower_mnt));
> +		spin_unlock(&union_lock);
> +		union_put(new);
> +		return 0;
> +	}
> +	__union_hash(new);
> +	spin_unlock(&union_lock);
> +	return 0;
> +}
> +
> +/*
> + * WARNING! Confusing terminology alert.
> + *
> + * Note that the directions "up" and "down" in union mounts are the
> + * opposite of "up" and "down" in normal VFS operation terminology.
> + * "up" in the rest of the VFS means "towards the root of the mount
> + * tree."  If you mount B on top of A, following B "up" will get you
> + * A.  In union mounts, "up" means "towards the most recently mounted
> + * layer of the union stack."  If you union mount B on top of A,
> + * following A "up" will get you to B.  Another way to put it is that
> + * "up" in the VFS means going from this mount towards the direction
> + * of its mnt->mnt_parent pointer, but "up" in union mounts means
> + * going in the opposite direction (until you run out of union
> + * layers).
> + */

So if this is confusing, why not use a different terminology for union
layers?  Like "next" and "prev" like it is already used in the
structures.

> +
> +/*
> + * union_down_one - get the next lower directory in the union stack
> + *
> + * This is called to traverse the union stack from the given layer to
> + * the next lower layer. union_down_one() is called by various
> + * lookup functions that are aware of union mounts.
> + *
> + * Returns non-zero if followed to the next lower layer, zero otherwise.
> + *
> + * See note on up/down terminology above.
> + */
> +int union_down_one(struct vfsmount **mnt, struct dentry **dentry)
> +{
> +	struct union_mount *um;
> +
> +	if (!IS_MNT_UNION(*mnt))
> +		return 0;
> +
> +	spin_lock(&union_lock);
> +	um = union_lookup(*dentry, *mnt);
> +	spin_unlock(&union_lock);
> +	if (um) {
> +		path_get(&um->u_next);
> +		dput(*dentry);
> +		*dentry = um->u_next.dentry;
> +		mntput(*mnt);
> +		*mnt = um->u_next.mnt;
> +		return 1;
> +	}
> +	return 0;
> +}
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index e035c51..d6c1da2 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -101,6 +101,26 @@ struct dentry {
>  	struct dentry *d_parent;	/* parent directory */
>  	struct qstr d_name;
>  
> +#ifdef CONFIG_UNION_MOUNT
> +	/*
> +	 * Stacks of union mount structures are connected to dentries
> +	 * through the d_unions field.  If this list is not empty,
> +	 * then this dentry is part of a unioned directory stack.
> +	 * Protected by union_lock.
> +	 */
> +	struct list_head d_unions;	/* list of union_mount's */
> +	/*
> +	 * If d_unionized is set, then this dentry is referenced by
> +	 * the u_next field of a union mount structure - that is, it
> +	 * is a dentry for a lower layer of a union.  d_unionized is
> +	 * NOT set in the dentry for the topmost layer of a union.
> +	 *
> +	 * d_unionized would be better renamed to d_union_lower or
> +	 * d_union_ref.
> +	 */
> +	unsigned int d_unionized;	/* unions referencing this dentry */
> +#endif
> +
>  	struct list_head d_lru;		/* LRU list */
>  	/*
>  	 * d_child and d_rcu can share memory
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index d42be54..85bb75d 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -64,6 +64,9 @@ struct vfsmount {
>  	struct list_head mnt_slave_list;/* list of slave mounts */
>  	struct list_head mnt_slave;	/* slave list entry */
>  	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
> +#ifdef CONFIG_UNION_MOUNT
> +	struct list_head mnt_unions;	/* list of union_mount structures */
> +#endif
>  	struct mnt_namespace *mnt_ns;	/* containing namespace */
>  	int mnt_id;			/* mount identifier */
>  	int mnt_group_id;		/* peer group identifier */
> diff --git a/include/linux/union.h b/include/linux/union.h
> new file mode 100644
> index 0000000..71dc35a
> --- /dev/null
> +++ b/include/linux/union.h
> @@ -0,0 +1,54 @@
> +/*
> + * VFS based union mount for Linux
> + *
> + * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
> + * Copyright (C) 2007 Novell Inc.
> + *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#ifndef __LINUX_UNION_H
> +#define __LINUX_UNION_H
> +#ifdef __KERNEL__
> +
> +#include <linux/list.h>
> +#include <asm/atomic.h>
> +
> +struct dentry;
> +struct vfsmount;
> +
> +#ifdef CONFIG_UNION_MOUNT
> +
> +/*
> + * The union mount structure.
> + */
> +struct union_mount {
> +	atomic_t u_count;		/* reference count */
> +	struct list_head u_unions;	/* list head for d_unions */
> +	struct list_head u_list;	/* list head for mnt_unions */
> +	struct hlist_node u_hash;	/* list head for searching */
> +	struct hlist_node u_rhash;	/* list head for reverse searching */
> +
> +	struct path u_this;		/* this is me */
> +	struct path u_next;		/* this is what I overlay */
> +};
> +
> +#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
> +
> +extern int append_to_union(struct vfsmount *, struct dentry *,
> +			   struct vfsmount *, struct dentry *);
> +extern int union_down_one(struct vfsmount **, struct dentry **);
> +
> +#else /* CONFIG_UNION_MOUNT */
> +
> +#define IS_MNT_UNION(x)			(0)
> +#define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
> +#define union_down_one(x, y)		({ (0); })
> +
> +#endif	/* CONFIG_UNION_MOUNT */
> +#endif	/* __KERNEL__ */
> +#endif	/* __LINUX_UNION_H */
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
