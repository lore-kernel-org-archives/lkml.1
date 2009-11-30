Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZK3IrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZK3IrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZK3IrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:47:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50461 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZK3IrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:47:02 -0500
Date: Mon, 30 Nov 2009 03:46:29 -0500
Message-Id: <200911300846.nAU8kTgF024429@agora.fsl.cs.sunysb.edu>
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
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/41] union-mount: Introduce union_mount structure 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:18 PDT."
             <1256152779-10054-21-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-21-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> This patch adds the basic structures of VFS based union mounts. It is a new
> implementation based on some of my old ideas that influenced Bharata B Rao
> <bharata@linux.vnet.ibm.com> who came up with the proposal to let the
> union_mount struct only point to the next layer in the union stack. I rewrote
> nearly all of the central patches around lookup and the dcache interaction.
> 
> Advantages of the new implementation:
> - the new union stack is no longer tied directly to one dentry
> - the union stack enables dentries to be part of more than one union
>   (bind mounts)
> - it is unnecessary to traverse the union stack when de/referencing a dentry
> - caching of union stack information still driven by dentry cache
> 
> XXX - is_unionized() is pretty heavy-weight for non-union file systems
> on a union mount-enabled kernel.  May be simplified by assuming one or
> more of:
> 
> - Two layers only
> - One-to-one association between layers (doesn't union submounts)
> - Writable layer mounted in only one place

Yes, is_unionized() does appear to be heavy.  Is it correct to assume that
every such dentry will have gotten looked up or traversed as part of a
union?  If so, can we just set a flag in the dentry to mark it as
D_THIS_IS_PART_OF_A_UNION?  Even if you could, what happens when a union r-w
layer is removed: could there be leftover dentries marked as part of a
union, which are no longer really part of it?

> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/Kconfig             |   13 ++
>  fs/Makefile            |    1 +
>  fs/dcache.c            |    4 +
>  fs/union.c             |  332 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |    9 ++
>  include/linux/union.h  |   61 +++++++++
>  6 files changed, 420 insertions(+), 0 deletions(-)
>  create mode 100644 fs/union.c
>  create mode 100644 include/linux/union.h
[...]

> diff --git a/fs/union.c b/fs/union.c
> new file mode 100644
> index 0000000..d1950c2
> --- /dev/null
> +++ b/fs/union.c
> @@ -0,0 +1,332 @@
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

Locking rules are pretty important to detail some more here, even if it just
repeats what's in union-mounts.txt.  How/when are each of these two locks
used here?

> +void union_put(struct union_mount *um)
> +{
> +	struct path tmp = um->u_next;

Are you relying on compiler support for C structure copying in the above
assignment?  I try to avoid such confusion in general.  It seems safer (and
saves you a bit on stack space) to change the code to:

	struct path *tmp = &um->u_next;
	if (__union_put(um))
		path_put(tmp);

> +	if (__union_put(um))
> +		path_put(&tmp);
> +}

> +/*
> + * is_unionized - check if a dentry lives on a union mounted file system
> + *
> + * This tests if a dentry is living on an union mounted file system by walking
> + * the file system hierarchy.
> + */
> +int is_unionized(struct dentry *dentry, struct vfsmount *mnt)

This can be a boolean function.

> +{
> +	struct path this = { .mnt = mntget(mnt),
> +			     .dentry = dget(dentry) };
> +	struct vfsmount *tmp;
> +
> +	do {
> +		/* check if there is an union mounted on top of us */
> +		spin_lock(&vfsmount_lock);
> +		list_for_each_entry(tmp, &this.mnt->mnt_mounts, mnt_child) {
> +			if (!(tmp->mnt_flags & MNT_UNION))
> +				continue;
> +			/* Isn't this a bug? */

It's customary to prefix such comments with XXX, as it helps those who like
to grep for issues:

			/* XXX: isn't this a bug? */

> +			if (this.dentry->d_sb != tmp->mnt_mountpoint->d_sb)
> +				continue;
> +			if (is_subdir(this.dentry, tmp->mnt_mountpoint)) {
> +				spin_unlock(&vfsmount_lock);
> +				path_put(&this);
> +				return 1;
> +			}
> +		}
> +		spin_unlock(&vfsmount_lock);
> +
> +		/* check our mountpoint next */
> +		tmp = mntget(this.mnt->mnt_parent);
> +		dput(this.dentry);
> +		this.dentry = dget(this.mnt->mnt_mountpoint);
> +		mntput(this.mnt);
> +		this.mnt = tmp;
> +	} while (this.mnt != this.mnt->mnt_parent);
> +
> +	path_put(&this);
> +	return 0;
> +}
> +

> +/*
> + * follow_union_down - follow the union stack one layer down
> + *
> + * This is called to traverse the union stack from one layer to the next
> + * overlayed one. follow_union_down() is called by various lookup functions
> + * that are aware of union mounts.
> + *
> + * Returns non-zero if followed to the next layer, zero otherwise.

But, you're returning a 1 or 0 always, so why not make it a bool function?
Or do you think this function could ever return something different
(-ERRNO)?

> + */
> +int follow_union_down(struct vfsmount **mnt, struct dentry **dentry)
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
> +
> +/*
> + * follow_union_mount - follow the union stack to the topmost layer
> + *
> + * This is called to traverse the union stack to the topmost layer. This is
> + * necessary for following parent pointers in an union mount.
> + *
> + * Returns none zero if followed to the topmost layer, zero otherwise.

s/none zero/non-zero/

Either way, this function returns 0/1, and can be made boolean until such
day that it has to return something other than a 0 or 1.

> + */
> +int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
> +{
> +	struct union_mount *um;
> +	int res = 0;
> +
> +	while (IS_UNION(*dentry)) {
> +		spin_lock(&dcache_lock);
> +		spin_lock(&union_lock);
> +		um = union_rlookup(*dentry, *mnt);
> +		if (um)
> +			path_get(&um->u_this);
> +		spin_unlock(&union_lock);
> +		spin_unlock(&dcache_lock);
> +
> +		/*
> +		 * Q: Aaargh, how do I validate the topmost dentry pointer?
> +		 * A: Eeeeasy! We took the dcache_lock and union_lock. Since
> +		 *    this protects from any dput'ng going on, we know that the
> +		 *    dentry is valid since the union is unhashed under
> +		 *    dcache_lock too.
> +		 */
> +		if (!um)
> +			break;
> +		dput(*dentry);
> +		*dentry = um->u_this.dentry;
> +		mntput(*mnt);
> +		*mnt = um->u_this.mnt;
> +		res = 1;
> +	}
> +
> +	return res;
> +}
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 7648b49..4d48c20 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -101,6 +101,15 @@ struct dentry {
>  	struct dentry *d_parent;	/* parent directory */
>  	struct qstr d_name;
>  
> +#ifdef CONFIG_UNION_MOUNT
> +	/*
> +	 * The following fields are used by the VFS based union mount
> +	 * implementation. Both are protected by union_lock!
> +	 */
> +	struct list_head d_unions;	/* list of union_mount's */
> +	unsigned int d_unionized;	/* unions referencing this dentry */

So what exactly is d_unionized?  A reference counter?  And integer index
into something?  Or just a flag to say whether this dentry is in a union or
not?  Whatever the meaning of this field is, I don't think the comment next
to it properly explains what it does.

In general, I like to see some more detail explaining the use of these two
fields in your modified struct dentry.  Header files are a great place to
demystify the meaning and use of new fields/structures, without forcing
everyone to read the *.c files to understand how things work.  Besides, if
you're going to modify something as critical as STRUCT DENTRY, then I think
that some more explanation and justification is due.

> +#endif
> +
>  	struct list_head d_lru;		/* LRU list */
>  	/*
>  	 * d_child and d_rcu can share memory
> diff --git a/include/linux/union.h b/include/linux/union.h
> new file mode 100644
> index 0000000..0c85312
> --- /dev/null
> +++ b/include/linux/union.h
> @@ -0,0 +1,61 @@
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
> + * The new union mount structure.
> + */
> +struct union_mount {
> +	atomic_t u_count;		/* reference count */
> +	struct mutex u_mutex;
> +	struct list_head u_unions;	/* list head for d_unions */
> +	struct hlist_node u_hash;	/* list head for searching */
> +	struct hlist_node u_rhash;	/* list head for reverse searching */
> +
> +	struct path u_this;		/* this is me */
> +	struct path u_next;		/* this is what I overlay */
> +};

I have two major complaints about struct union_mount:

1. In your documentaiton you refer to the "upper" and "lower" layers.  In
   this structure, and all over this patch, you're referring to them as
   "this" and "next", respectively.  I don't care which pair of terms you
   use, but please pick one pair of terms and use them consistently
   throughout your ENTIRE code base and documentation.  Personally, after
   trying all sorts of terms myself over the years, I found that "upper" and
   "lower" made the most sense, better than "this" and "next".  To me, every
   function which takes a paramater, that parameter *is* the "this" of that
   function.  For example, dput() takes a dentry, and that dentry could be
   easily defined as "struct dentry *this" to mean that dput() operates on
   that specific dentry.  Now, I realize that someone could confuse "upper"
   to mean "the layer above this one", so I'll accept if you decide to go
   with this/next instead; but whatever you do, please be consistent.

2. The field prefixes of u_XXX are confusing at first glance.  When I see
   u_XXX in C code, my immediate reaction is "oh, this must be a typedef to
   some unsigned type like u_int".  I strongly suggest you rename all field
   prefixes to um_XXX, as it is more traditionally done (taking the
   "initials" of each word in the struct name).

> +
> +#define IS_UNION(dentry)	(!list_empty(&(dentry)->d_unions) || \
> +				 (dentry)->d_unionized)
> +#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
> +
> +extern int is_unionized(struct dentry *, struct vfsmount *);
> +extern int append_to_union(struct vfsmount *, struct dentry *,
> +			   struct vfsmount *, struct dentry *);
> +extern int follow_union_down(struct vfsmount **, struct dentry **);
> +extern int follow_union_mount(struct vfsmount **, struct dentry **);
> +
> +#else /* CONFIG_UNION_MOUNT */
> +
> +#define IS_UNION(x)			(0)
> +#define IS_MNT_UNION(x)			(0)
> +#define is_unionized(x, y)		(0)
> +#define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
> +#define follow_union_down(x, y)		({ (0); })
> +#define follow_union_mount(x, y)	({ (0); })
> +
> +#endif	/* CONFIG_UNION_MOUNT */
> +#endif	/* __KERNEL__ */
> +#endif	/* __LINUX_UNION_H */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
