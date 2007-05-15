Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbXEOOBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbXEOOBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXEOOAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:00:54 -0400
Received: from pat.uio.no ([129.240.10.15]:58923 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbXEOOAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:00:51 -0400
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070514094218.GJ4139@in.ibm.com>
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094218.GJ4139@in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 May 2007 10:00:45 -0400
Message-Id: <1179237645.6464.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.140)
X-UiO-Scanned: 6DF469F7E7F1DA7DAF7F2484DEE7D1898520DAFE
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 22 total 1748108 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:12 +0530, Bharata B Rao wrote:
> From: Jan Blunck <j.blunck@tu-harburg.de>
> Subject: Union-mount lookup
> 
> Modifies the vfs lookup routines to work with union mounted directories.
> 
> The existing lookup routines generally lookup for a pathname only in the
> topmost or given directory. The changed versions of the lookup routines
> search for the pathname in the entire union mounted stack. Also they have been
> modified to setup the union stack during lookup from dcache cache and from
> real_lookup().
> 
> Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  fs/dcache.c            |   16 +
>  fs/namei.c             |   78 +++++-
>  fs/namespace.c         |   35 ++
>  fs/union.c             |  598 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |   17 +
>  include/linux/namei.h  |    4 
>  include/linux/union.h  |   49 ++++
>  7 files changed, 786 insertions(+), 11 deletions(-)
> 
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1286,7 +1286,7 @@ struct dentry * d_lookup(struct dentry *
>  	return dentry;
>  }
>  
> -struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
> +struct dentry * __d_lookup_single(struct dentry *parent, struct qstr *name)
>  {
>  	unsigned int len = name->len;
>  	unsigned int hash = name->hash;
> @@ -1371,6 +1371,20 @@ out:
>  	return dentry;
>  }
>  
> +struct dentry * d_lookup_single(struct dentry *parent, struct qstr *name)
> +{
> +	struct dentry *dentry;
> +	unsigned long seq;
> +
> +        do {
> +                seq = read_seqbegin(&rename_lock);
> +                dentry = __d_lookup_single(parent, name);
> +                if (dentry)
> +			break;
> +	} while (read_seqretry(&rename_lock, seq));
> +	return dentry;
> +}
> +
>  /**
>   * d_validate - verify dentry provided from insecure source
>   * @dentry: The dentry alleged to be valid child of @dparent
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -374,6 +374,33 @@ void release_open_intent(struct nameidat
>  }
>  
>  static inline struct dentry *
> +do_revalidate_single(struct dentry *dentry, struct nameidata *nd)
> +{
> +	int status = dentry->d_op->d_revalidate(dentry, nd);
> +	if (unlikely(status <= 0)) {

d_revalidate() returns a 0 or 1 result, not an error.

> +		/*
> +		 * The dentry failed validation.
> +		 * If d_revalidate returned 0 attempt to invalidate
> +		 * the dentry otherwise d_revalidate is asking us
> +		 * to return a fail status.
> +		 */
> +		if (!status) {
> +			if (!d_invalidate(dentry)) {
> +				__dput_single(dentry);
> +				dentry = NULL;
> +			}
> +		} else {
> +			__dput_single(dentry);
> +			dentry = ERR_PTR(status);

See above

> +		}
> +	}
> +	return dentry;
> +}
> +
> +/*
> + * FIXME: We need a union aware revalidate here!
> + */
> +static inline struct dentry *
>  do_revalidate(struct dentry *dentry, struct nameidata *nd)
>  {
>  	int status = dentry->d_op->d_revalidate(dentry, nd);
> @@ -403,16 +430,16 @@ do_revalidate(struct dentry *dentry, str
>   */
>  static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
>  {
> -	struct dentry * dentry = __d_lookup(parent, name);
> +	struct dentry *dentry = __d_lookup_single(parent, name);
>  
>  	/* lockess __d_lookup may fail due to concurrent d_move() 
>  	 * in some unrelated directory, so try with d_lookup
>  	 */
>  	if (!dentry)
> -		dentry = d_lookup(parent, name);
> +		dentry = d_lookup_single(parent, name);
>  
>  	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
> -		dentry = do_revalidate(dentry, nd);
> +		dentry = do_revalidate_single(dentry, nd);
>  
>  	return dentry;
>  }
> @@ -465,7 +492,7 @@ ok:
>   * make sure that nobody added the entry to the dcache in the meantime..
>   * SMP-safe
>   */
> -static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
> +struct dentry * real_lookup_single(struct dentry *parent, struct qstr *name, struct nameidata *nd)
>  {
>  	struct dentry * result;
>  	struct inode *dir = parent->d_inode;
> @@ -485,7 +512,7 @@ static struct dentry * real_lookup(struc
>  	 *
>  	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
>  	 */
> -	result = d_lookup(parent, name);
> +	result = d_lookup_single(parent, name);
>  	if (!result) {
>  		struct dentry * dentry = d_alloc(parent, name);
>  		result = ERR_PTR(-ENOMEM);
> @@ -506,7 +533,7 @@ static struct dentry * real_lookup(struc
>  	 */
>  	mutex_unlock(&dir->i_mutex);
>  	if (result->d_op && result->d_op->d_revalidate) {
> -		result = do_revalidate(result, nd);
> +		result = do_revalidate_single(result, nd);
>  		if (!result)
>  			result = ERR_PTR(-ENOENT);
>  	}
> @@ -699,7 +726,7 @@ static int __follow_mount(struct path *p
>  	return res;
>  }
>  
> -static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
> +void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
>  {
>  	while (d_mountpoint(*dentry)) {
>  		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
> @@ -773,6 +800,7 @@ static __always_inline void follow_dotdo
>  		nd->mnt = parent;
>  	}
>  	follow_mount(&nd->mnt, &nd->dentry);
> +	follow_union_mount(&nd->mnt, &nd->dentry);
>  }
>  
>  /*
> @@ -784,7 +812,15 @@ static int do_lookup(struct nameidata *n
>  		     struct path *path)
>  {
>  	struct vfsmount *mnt = nd->mnt;
> -	struct dentry *dentry = __d_lookup(nd->dentry, name);
> +	struct dentry *dentry;
> +
> +	UM_DEBUG_UID("lookup \"%s\" in \"%s\" (inode=%p,dev=%s)\n",
> +		     name->name,
> +		     nd->dentry->d_name.name,
> +		     nd->dentry->d_inode,
> +		     nd->mnt->mnt_devname);

Ugh! Please don't pollute generic VFS code with this sort of private
debugging crap.

> +
> +	dentry = __d_lookup(nd->dentry, name);
>  
>  	if (!dentry)
>  		goto need_lookup;
> @@ -793,7 +829,17 @@ static int do_lookup(struct nameidata *n
>  done:
>  	path->mnt = mnt;
>  	path->dentry = dentry;
> +
> +	if (nd->dentry->d_sb != dentry->d_sb)
> +		path->mnt = find_mnt(dentry);
> +
>  	__follow_mount(path);
> +	follow_union_mount(&path->mnt, &path->dentry);
> +
> +	UM_DEBUG_UID("found \"%s\" (inode=%p,dev=%s)\n",
> +		     path->dentry->d_name.name,
> +		     path->dentry->d_inode,
> +		     path->mnt->mnt_devname);
>  	return 0;
>  
>  need_lookup:
> @@ -838,6 +884,9 @@ static fastcall int __link_path_walk(con
>  	if (nd->depth)
>  		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
>  
> +	UM_DEBUG_UID("begin walking for %s\n", name);
> +	follow_union_mount(&nd->mnt, &nd->dentry);
> +
>  	/* At this point we know we have a real path component. */
>  	for(;;) {
>  		unsigned long hash;
> @@ -931,6 +980,7 @@ static fastcall int __link_path_walk(con
>  last_with_slashes:
>  		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
>  last_component:
> +		UM_DEBUG_UID("last component %s\n", this.name);
>  		/* Clear LOOKUP_CONTINUE iff it was previously unset */
>  		nd->flags &= lookup_flags | ~LOOKUP_CONTINUE;
>  		if (lookup_flags & LOOKUP_PARENT)
> @@ -1266,7 +1316,15 @@ int __user_path_lookup_open(const char _
>  	return err;
>  }
>  
> -static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
> +/*
> + * NOTE: On union mounts it is important that the overlaid dentries are
> + * correct. Therefore we need to follow mounts. Take a look at
> + * __lookup_hash_kern_union() how it is done.
> + *
> + * Called with union already locked (before the parent inode is locked !!!)
> + */
> +struct dentry * __lookup_hash_kern_single(struct qstr *name,
> +		struct dentry *base, struct nameidata *nd)
>  {
>  	struct dentry *dentry;
>  	struct inode *inode;
> @@ -1298,6 +1356,8 @@ static inline struct dentry *__lookup_ha
>  			dput(new);
>  	}
>  out:
> +	UM_DEBUG_UID("name=\"%s\", inode=%p\n",
> +		     dentry->d_name.name, dentry->d_inode);
>  	return dentry;
>  }
>  
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -133,6 +133,41 @@ struct vfsmount *lookup_mnt(struct vfsmo
>  	return child_mnt;
>  }
>  
> +/*
> + * find_mnt - find a vfsmount struct
> + * @dentry: a dentry
> + *
> + * This searches the namespace for a given dentries
> + * vfsmount struct. This is used by union-mount.
> + */
> +struct vfsmount * find_mnt(struct dentry *dentry)
> +{
> +	struct list_head *tmp;
> +	struct vfsmount *p, *mnt = NULL;
> +
> +	down_read(&namespace_sem);
> +	spin_lock(&vfsmount_lock);
> +	if (list_empty(&current->nsproxy->mnt_ns->list)) {
> +		spin_unlock(&vfsmount_lock);
> +		up_read(&namespace_sem);
> +		return NULL;
> +	}
> +	list_for_each(tmp, &current->nsproxy->mnt_ns->list) {
> +		p = list_entry(tmp, struct vfsmount, mnt_list);
> +		if (dentry->d_sb == p->mnt_sb) {
> +			mnt = mntget(p);
> +			break;
> +		}
> +	}
> +	spin_unlock(&vfsmount_lock);
> +	up_read(&namespace_sem);
> +
> +	BUG_ON(!mnt);
> +//	UM_DEBUG_UID("found %s/%p in %s\n", dentry->d_name.name,
> +//		     dentry->d_inode, mnt->mnt_devname);

   ^^^^ Definitely remove

> +	return mnt;
> +}
> +
>  static inline int check_mnt(struct vfsmount *mnt)
>  {
>  	return mnt->mnt_ns == current->nsproxy->mnt_ns;
> --- a/fs/union.c
> +++ b/fs/union.c
> @@ -370,3 +370,601 @@ void detach_mnt_union(struct vfsmount *m
>  	 * union stack */
>  	__dput(path->dentry);
>  }
> +
> +static noinline int revalidate_union(struct dentry * dentry)
          ^^^^^^^^ this is just as bad as 'inline'. I thought we had all
agreed to leave it up to the compiler to optimise.
> +{
> +	union_check(dentry);
> +
> +	spin_lock(&dcache_lock);
> +	spin_lock(&dentry->d_lock);
> +	if (atomic_read(&dentry->d_count) < 2) {
> +		UM_DEBUG_DCACHE("dentry unused, count=%d\n",
> +			     atomic_read(&dentry->d_count));
> +		__d_drop(dentry);
> +		spin_unlock(&dentry->d_lock);
> +		spin_unlock(&dcache_lock);
> +		return 0;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +	spin_unlock(&dcache_lock);
> +
> +	return 1;
> +}
> +
> +static noinline void replace_union_info(struct dentry *dentry,
> +					struct union_info *lock)
> +{
> +	struct dentry *tmp = dentry;
> +	struct union_info *old_lock = union_get(dentry->d_union);
> +
> +	BUG_ON(!lock);
> +	BUG_ON(dentry->d_union == lock);
> +
> +	while (tmp) {
> +		spin_lock(&tmp->d_lock);
> +		union_put(tmp->d_union);
> +		tmp->d_union = union_get(lock);
> +		spin_unlock(&tmp->d_lock);
> +		tmp = tmp->d_overlaid;
> +	}
> +
> +	BUG_ON(atomic_read(&old_lock->u_count) != 1);
> +	union_put(old_lock);
> +	return;
> +}
> +
> +static void __dput_from_to(struct dentry *from, struct dentry *to,
> +			   struct union_info *lock)
> +{
> +	struct dentry *next = from;
> +	struct union_info *mylock = union_get(from->d_union);
> +
> +	while (next) {
> +		struct dentry *tmp = next;
> +		next = next->d_overlaid;
> +
> +		UM_DEBUG_UID("dput_all dentry=\"%s\", inode=\"%p\"\n",
> +			     tmp->d_name.name, tmp->d_inode);
> +
> +		if (lock) {
> +			spin_lock(&tmp->d_lock);
> +			tmp->d_topmost = NULL;
> +			tmp->d_overlaid = NULL;
> +			union_put(tmp->d_union);
> +			tmp->d_union = NULL;
> +			spin_unlock(&tmp->d_lock);
> +		}
> +
> +		__dput_single(tmp);
> +
> +		if (tmp == to)
> +			break;
> +	}
> +
> +	UM_DEBUG_LOCK("\"??\" unlocking union %p\n", lock);
> +	mutex_unlock(&mylock->u_mutex);
> +	union_put(mylock);
> +}
> +
> +/*
> + * Lookup for the @name in the dentry cache. Look through the lower layers
> + * of the parent's union stack and build a union stack for the child if
> + * necessary.
> + * TODO: This shares a considerable amount of code with __lookup_union().
> + */
> +struct dentry * __d_lookup_union(struct dentry *base, struct qstr *name)
> +{
> +	struct dentry *parent = base->d_overlaid;
> +	struct dentry *dentry = NULL;
> +	struct dentry *topmost;
> +	struct dentry *last;
> +	struct qstr this;
> +	struct union_info *lock = NULL;
> +	int err;
> +
> +	union_lock(base);
> +	topmost = __d_lookup_single(base, name);
> +	last = topmost;
> +
> +	/*
> +	 * - If dcache lookup returns a NULL dentry, return to force a real
> +	 *   lookup. Union mount version of real lookup will endup doing real or
> +	 *   dcache lookup for this in the lower layers also. OR
> +	 * - If parent is not a union mounted directory, we are done
> +	 *   with the lookup, return.
> +	 */
> +	if (!topmost || !base->d_overlaid)
> +		goto out;
> +
> +	this.name = name->name;
> +	this.len = name->len;
> +	this.hash = name->hash;
> +
> +	/*
> +	 * If dcache lookup returned a non-negative dentry from the top layer,
> +	 * continue the lookup in to the lower layers and re-build the union
> +	 * stack if necessary.
> +	 */
> +	if (topmost->d_inode)
> +		goto lookup_union;
> +
> +	/*
> +	 * dcache lookup in the top layer returned a negative dentry. Look
> +	 * through the lower layers to find the first non-negative dentry.
> +	 */
> +	while (parent) {
> +		if (parent->d_op && parent->d_op->d_hash) {
> +			err = parent->d_op->d_hash(parent, &this);
> +			if (err < 0) {
> +				__dput_single(topmost);
> +				topmost = NULL;
> +				goto out;
> +			}
> +		}
> +		dentry = __d_lookup_single(parent, &this);
> +		/*
> +		 * Force a real lookup if parts of the union stack are not in
> +		 * dcache
> +		 */
> +		if (!dentry) {
> +			__dput_single(topmost);
> +			topmost = NULL;
> +			goto out;
> +		}
> +		if (dentry->d_inode)
> +			break;
> +		__dput_single(dentry);
> +		dentry = NULL;
> +		parent = parent->d_overlaid;
> +	}
> +
> +	if (!dentry)
> +		goto out;
> +
> +	__dput_single(topmost);
> +	topmost = dentry;
> +	last = dentry;
> +lookup_union:
> +	do {
> +		struct vfsmount *mnt = find_mnt(topmost);
> +		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
> +				topmost->d_name.name, topmost->d_inode,
> +				mnt->mnt_devname);
> +		mntput(mnt);
> +	} while (0);
> +
> +	/* If this is not a directory, no need to look beyond this layer */
> +	if (!S_ISDIR(topmost->d_inode->i_mode))
> +		goto out;
> +
> +	if (!revalidate_union(topmost)) {
> +		__dput_single(topmost);
> +		topmost = NULL;
> +		goto out;
> +	}
> +
> +	spin_lock(&topmost->d_lock);
> +	if (topmost->d_union) {
> +		union_lock_spinlock(topmost, &topmost->d_lock);
> +	}
> +	spin_unlock(&topmost->d_lock);
> +
> +	parent = topmost->d_parent->d_overlaid;
> +	while (parent) {
> +		if (parent->d_op && parent->d_op->d_hash) {
> +			err = parent->d_op->d_hash(parent, &this);
> +			if (err < 0) {
> +				UM_DEBUG("failed to hash the qstr\n");
> +				goto dput_all;
> +			}
> +		}
> +		dentry = __d_lookup_single(parent, &this);
> +		if (!dentry) {
> +			/*
> +			 * No dentry for this name in this lower layer.
> +			 * CHECK: Why return like this ? Shoudn't we look
> +			 * for this name in the next lower layer ?
> +			 */
> +			__dput_single(dentry);
> +			goto dput_all;
> +		}
> +
> +		if (!dentry->d_inode) {
> +			__dput_single(dentry);
> +			parent = parent->d_overlaid;
> +			continue;
> +		}
> +		if (!S_ISDIR(dentry->d_inode->i_mode)) {
> +			__dput_single(dentry);
> +			break;
> +		}
> +		if (last->d_overlaid
> +		    && (last->d_overlaid != dentry)) {
> +			printk(KERN_ERR "%s: strange stack layout " \
> +			       "(\"%s\" overlays \"%s\")\n",
> +			       __FUNCTION__, last->d_name.name,
> +			       dentry->d_name.name);
> +			dump_stack();
> +			__dput_single(dentry);
> +			goto dput_all;
> +		}
> +		spin_lock(&topmost->d_lock);
> +		if (!topmost->d_union) {
> +			UM_DEBUG_LOCK("allocate union for \"%s\"\n",
> +				      topmost->d_name.name);
> +			topmost->d_union = union_alloc();
> +			lock = topmost->d_union;
> +		}
> +		spin_unlock(&topmost->d_lock);
> +		spin_lock(&dentry->d_lock);
> +		if (!dentry->d_union)
> +			dentry->d_union = union_get(topmost->d_union);
> +		spin_unlock(&dentry->d_lock);
> +		if (dentry->d_union != topmost->d_union) {
> +			union_lock(dentry);
> +			replace_union_info(topmost, dentry->d_union);
> +		}
> +		dentry->d_topmost = topmost;
> +		last->d_overlaid = dentry;
> +		last = dentry;
> +		parent = parent->d_overlaid;
> +	}
> +
> +	spin_lock(&topmost->d_lock);
> +	if (topmost->d_union && atomic_read(&topmost->d_union->u_count) == 1) {
> +		union_put(topmost->d_union);
> +		topmost->d_union = NULL;
> +	} else
> +		union_unlock(topmost);
> +	spin_unlock(&topmost->d_lock);
> +out:
> +	union_unlock(base);
> +	return topmost;
> +
> +dput_all:
> +	__dput_from_to(topmost, last, lock);
> +	union_unlock(base);
> +	return NULL;
> +}
> +
> +/*
> + * FIXME: export this from fs/namei.c ???
> + */
> +extern int follow_mount(struct vfsmount **, struct dentry **);
> +extern struct dentry * __lookup_hash_kern_single(struct qstr *, struct dentry *,
> +					    struct nameidata *);
> +extern struct dentry * real_lookup_single(struct dentry *, struct qstr *,
> +					  struct nameidata *);
> +
> +static inline void copy_nd(struct nameidata *old_nd, struct nameidata *new_nd)
> +{
> +	if (old_nd) {
> +		new_nd->last.name = NULL; /* handled in __link_path_walk */
> +		new_nd->last.len = 0;
> +		new_nd->last.hash = 0;
> +		new_nd->flags = old_nd->flags;
> +		new_nd->um_flags = 0;	/* ditto */
> +		new_nd->last_type = -1;	/* ditto */
> +		new_nd->depth = 0;	/* handled in do_follow_link */
> +		memcpy(&new_nd->intent, &old_nd->intent, sizeof(new_nd->intent));
> +	}
> +}
> +
> +/*
> + * This is called when a dentries parent is union-mounted and we have
> + * to lookup the overlaid dentries. The lookup starts at the parents
> + * first overlaid dentry of the given dentry. Negative dentries are
> + * ignored and not included in the overlaid list.
> + *
> + * If we reach a dentry with restricted access, we just stop the lookup
> + * because we shouldn't see through that dentry. Same thing for dentry
> + * type mismatch and whiteouts.
> + *
> + * FIXME:
> + * - handle DT_WHT
> + * - handle union stacks in use
> + * - handle union stacks mounted upon union stacks
> + * - avoid unnecessary allocations of union locks
> + */
> +static int __lookup_union(struct dentry *topmost, struct qstr *name,
> +			  struct nameidata *__nd)
> +{
> +	struct dentry *parent;
> +	struct dentry *last;
> +	struct dentry *dentry;
> +	unsigned int hash = name->hash;
> +	struct nameidata nd;
> +	int err;
> +
> +	/* we may also be called via lookup_hash with a NULLed nd argument */
> +	copy_nd(__nd, &nd);
> +
> +	spin_lock(&topmost->d_lock);
> +	if (topmost->d_union) {
> +		union_lock_spinlock(topmost, &topmost->d_lock);
> +	}
> +	spin_unlock(&topmost->d_lock);
> +
> +	parent = topmost->d_parent->d_overlaid;
> +	last = topmost;
> +
> +	while (parent) {
> +		/*
> +		 * the hash could be changed in the last
> +		 * __lookup_hash_single() so we need to reset it here
> +		 */
> +		name->hash = hash;
> +		nd.dentry = __dget(parent);
> +		nd.mnt = find_mnt(parent);
> +
> +		mutex_lock(&parent->d_inode->i_mutex);
> +		dentry = __lookup_hash_single(name, parent,
> +					      __nd ? &nd : NULL);
> +		mutex_unlock(&parent->d_inode->i_mutex);
> +		if (IS_ERR(dentry)) {
> +			err = PTR_ERR(dentry);
> +			goto out;
> +		}
> +
> +		if (!dentry->d_inode) {
> +			__dput_single(dentry);
> +			goto loop;
> +		}
> +
> +		if (!S_ISDIR(dentry->d_inode->i_mode)) {
> +			__dput_single(dentry);
> +			err = 0;
> +			goto out;
> +		}
> +
> +		/* Now we know, we found something real */
> +		follow_mount(&nd.mnt, &dentry);
> +
> +		do {
> +			struct vfsmount *mnt = find_mnt(dentry);
> +			UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
> +				     dentry->d_name.name, dentry->d_inode,
> +				     mnt->mnt_devname);
> +			mntput(mnt);
> +		} while (0);
> +
> +		if (last->d_overlaid && (last->d_overlaid != dentry)) {
> +			printk(KERN_ERR "%s: strange stack layout " \
> +			       "(\"%s\" overlays \"%s\")\n",
> +			       __FUNCTION__, last->d_name.name,
> +			       dentry->d_name.name);
> +			dump_stack();
> +			__dput_single(dentry);
> +			/* lets try to make a clean ending */
> +			last->d_overlaid = NULL;
> +			err = -EFAULT;	// FIXME: something better?
> +			goto out;
> +		}
> +
> +		spin_lock(&topmost->d_lock);
> +		if (!topmost->d_union) {
> +			UM_DEBUG_LOCK("allocate union for \"%s\"\n",
> +				      topmost->d_name.name);
> +			topmost->d_union = union_alloc();
> +		}
> +		spin_unlock(&topmost->d_lock);
> +
> +		spin_lock(&dentry->d_lock);
> +		if (!dentry->d_union)
> +			dentry->d_union = union_get(topmost->d_union);
> +		spin_unlock(&dentry->d_lock);
> +
> +		if (topmost->d_union != dentry->d_union) {
> +			union_lock(dentry);
> +			replace_union_info(topmost, dentry->d_union);
> +		}
> +
> +		dentry->d_topmost = topmost;
> +		last->d_overlaid = dentry;
> +		last = dentry;
> +	loop:
> +		__dput(nd.dentry);
> +		mntput(nd.mnt);
> +		parent = parent->d_overlaid;
> +	}
> +
> +	err = 0;
> +	union_unlock(topmost);
> +	return err;
> +out:
> +	__dput(nd.dentry);
> +	mntput(nd.mnt);
> +	union_unlock(topmost);
> +	return err;
> +}
> +
> +/*
> + * Union mount version of real_lookup().
> + * Looks through the lower layers of the union and builds a union stack
> + * if necessary (i,e., for directories)
> + * TODO: This routine is almost similar to __lookup_hash_kern_union() which
> + * uses __lookup_hash_kern_single() (instead of real_lookup_single()). Check
> + * if some code can be shared here.
> + */
> +struct dentry * real_lookup_union(struct dentry *base, struct qstr *name,
> +				  struct nameidata *__nd)
> +{
> +	struct dentry *parent;
> +	struct dentry *topmost;
> +	unsigned int hash = name->hash;
> +	struct nameidata nd;
> +	int err;
> +
> +	union_lock(base);
> +	topmost = real_lookup_single(base, name, __nd);
> +	if (IS_ERR(topmost))
> +		goto out;
> +
> +	/*
> +	 * If real_lookup returns a valid dentry from the topmost layer,
> +	 * continue the lookup into the lower layers and build a union
> +	 * stack in case of directories.
> +	 */
> +	if (topmost->d_inode) {
> +		parent = base;
> +		goto lookup_union;
> +	}
> +
> +	copy_nd(__nd, &nd);
> +
> +	/*
> +	 * real_lookup returned a negative dentry, walk through the lower
> +	 * layers looking for the given name.
> +	 */
> +	parent = base->d_overlaid;
> +	while (parent) {
> +		struct dentry * dentry;
> +
> +		name->hash = hash;
> +		nd.dentry = __dget(parent);
> +		nd.mnt = find_mnt(parent);
> +
> +		dentry = real_lookup_single(nd.dentry, name, &nd);
> +		__dput(nd.dentry);
> +		mntput(nd.mnt);
> +		if (IS_ERR(dentry))
> +			goto out;
> +
> +		/*
> +		 * If a dentry is found in a lower layer, continue to lookup
> +		 * in the lower layers and build a union stack if needed.
> +		 */
> +		if (dentry->d_inode) {
> +			__dput_single(topmost);
> +			topmost = dentry;
> +			goto lookup_union;
> +		}
> +		__dput_single(dentry);
> +		parent = parent->d_overlaid;
> +	}
> +
> +out:
> +	union_unlock(base);
> +	return topmost;
> +
> +lookup_union:
> +	/*
> +	 * If our parent doesn't have a union stack or we are not a directory,
> +	 * the lookup ends here.
> +	 */
> +	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
> +		goto out;
> +
> +	do {
> +		struct vfsmount *mnt = find_mnt(topmost);
> +		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
> +			     topmost->d_name.name, topmost->d_inode,
> +			     mnt->mnt_devname);
> +		mntput(mnt);
> +	} while (0);
> +
> +	name->hash = hash;
> +	err = __lookup_union(topmost, name, &nd);
> +	if (err) {
> +		dput(topmost);
> +		topmost = ERR_PTR(err);
> +	}
> +	goto out;
> +}
> +
> +/*
> + * Union mount version of __lookup_hash_kern().
> + * Looks through the lower layers of the union and builds a union stack
> + * if necessary (i,e., for directories)
> + */
> +struct dentry * __lookup_hash_kern_union(struct qstr *name,
> +			struct dentry *base, struct nameidata *__nd)
> +{
> +	struct dentry *topmost;
> +	struct dentry *parent;
> +	unsigned int hash = name->hash;
> +	struct nameidata nd;
> +	int err;
> +
> +	union_lock(base);
> +	topmost =  __lookup_hash_kern_single(name, base, __nd);
> +	if (IS_ERR(topmost))
> +		goto out;
> +
> +	if (topmost->d_inode) {
> +		parent = base;
> +		goto lookup_union;
> +	}
> +
> +	copy_nd(__nd, &nd);
> +
> +	parent = base->d_overlaid;
> +	while (parent) {
> +		struct dentry *dentry;
> +
> +		name->hash = hash;
> +		nd.dentry = __dget(parent);
> +		nd.mnt = find_mnt(parent);
> +
> +		mutex_lock(&parent->d_inode->i_mutex);
> +		dentry = __lookup_hash_kern_single(name, nd.dentry, &nd);
> +		mutex_unlock(&parent->d_inode->i_mutex);
> +		__dput(nd.dentry);
> +		mntput(nd.mnt);
> +		if (IS_ERR(dentry))
> +			goto out;
> +
> +		if (dentry->d_inode) {
> +			__dput_single(topmost);
> +			topmost = dentry;
> +			goto lookup_union;
> +		}
> +		__dput_single(dentry);
> +		parent = parent->d_overlaid;
> +	}
> +
> +out:
> +	union_unlock(base);
> +	return topmost;
> +
> +lookup_union:
> +	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
> +		goto out;
> +
> +	do {
> +		struct vfsmount *mnt = find_mnt(topmost);
> +		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
> +			     topmost->d_name.name, topmost->d_inode,
> +			     mnt->mnt_devname);
> +		mntput(mnt);
> +	} while (0);
> +
> +	name->hash = hash;
> +	err = __lookup_union(topmost, name, &nd);
> +	if (err) {
> +		dput(topmost);
> +		topmost = ERR_PTR(err);
> +	}
> +	goto out;
> +}
> +
> +int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
> +{
> +	int res = 0;
> +
> +	while ((*dentry)->d_topmost) {
> +		struct dentry *d_tmp = dget((*dentry)->d_topmost);
> +		struct vfsmount *m_tmp = find_mnt((*dentry)->d_topmost);
> +
> +		UM_DEBUG_UID("name=\"%s\", follow union from %s to %s\n",
> +			     (*dentry)->d_name.name, (*mnt)->mnt_devname,
> +			     m_tmp->mnt_devname);
> +		mntput(*mnt);
> +		*mnt = m_tmp;
> +		dput(*dentry);
> +		*dentry = d_tmp;
> +		res = 1;
> +	}
> +
> +	return res;
> +}
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -294,9 +294,23 @@ extern void d_move(struct dentry *, stru
>  
>  /* appendix may either be NULL or be used for transname suffixes */
>  extern struct dentry * d_lookup(struct dentry *, struct qstr *);
> -extern struct dentry * __d_lookup(struct dentry *, struct qstr *);
> +extern struct dentry * d_lookup_single(struct dentry *, struct qstr *);
> +extern struct dentry * __d_lookup_single(struct dentry *, struct qstr *);
>  extern struct dentry * d_hash_and_lookup(struct dentry *, struct qstr *);
>  
> +#ifdef CONFIG_UNION_MOUNT
> +extern struct dentry * __d_lookup_union(struct dentry *, struct qstr *);
> +#endif
> +
> +static inline struct dentry * __d_lookup(struct dentry *parent, struct qstr *name)
> +{
> +#ifdef CONFIG_UNION_MOUNT
> +       return __d_lookup_union(parent, name);
> +#else
> +       return __d_lookup_single(parent, name);
> +#endif
> +}
> +
>  /* validate "insecure" dentry pointer */
>  extern int d_validate(struct dentry *, struct dentry *);
>  
> @@ -467,6 +481,7 @@ static inline int d_mountpoint(struct de
>  extern struct vfsmount *lookup_mnt(struct vfsmount *, struct dentry *);
>  extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
>  extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
> +extern struct vfsmount *find_mnt(struct dentry *);
>  
>  extern int sysctl_vfs_cache_pressure;
>  
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -20,6 +20,7 @@ struct nameidata {
>  	struct vfsmount *mnt;
>  	struct qstr	last;
>  	unsigned int	flags;
> +	unsigned int	um_flags;
>  	int		last_type;
>  	unsigned	depth;
>  	char *saved_names[MAX_NESTED_LINKS + 1];
> @@ -40,6 +41,9 @@ struct path {
>   */
>  enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>  
> +#define LAST_UNION             0x01
> +#define LAST_LOWLEVEL          0x02
> +
>  /*
>   * The bitmask for a lookup event:
>   *  - follow links at the end
> --- a/include/linux/union.h
> +++ b/include/linux/union.h
> @@ -17,17 +17,66 @@
>  #ifdef CONFIG_UNION_MOUNT
>  
>  #include <linux/fs_struct.h>
> +#include <linux/dcache_union.h>
>  
>  /* namespace stuff used at mount time */
>  extern void attach_mnt_union(struct vfsmount *, struct nameidata *);
>  extern void detach_mnt_union(struct vfsmount *, struct path *);
>  
> +/* lookup stuff */
> +extern int follow_union_mount(struct vfsmount **, struct dentry **);
> +extern struct dentry * real_lookup_union(struct dentry *, struct qstr *,
> +					 struct nameidata *);
> +extern struct dentry * __lookup_hash_kern_union(struct qstr *, struct dentry *,
> +					   struct nameidata *);
> +
>  #else	/* CONFIG_UNION_MOUNT */
>  
>  #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
>  #define detach_mnt_union(mnt,nd) do { /* empty */ } while (0)
> +#define follow_union_mount(x,y) do { /* empty */ } while (0)
>  
>  #endif	/* CONFIG_UNION_MOUNT */
>  
> +extern struct dentry * real_lookup_single(struct dentry *, struct qstr *,
> +	struct nameidata *);
> +extern struct dentry * __lookup_hash_kern_single(struct qstr *, struct dentry *,
> +	 struct nameidata *);
> +
> +static inline struct dentry * real_lookup(struct dentry *parent, struct qstr *name, struct nameidata *nd)
> +{
> +#ifdef CONFIG_UNION_MOUNT
> +	return real_lookup_union(parent, name, nd);
> +#else
> +	return real_lookup_single(parent, name, nd);
> +#endif
> +}
> +
> +static inline struct dentry * __lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
> +{
> +#ifdef CONFIG_UNION_MOUNT
> +	return __lookup_hash_kern_union(name, base, nd);
> +#else
> +	return __lookup_hash_kern_single(name, base, nd);
> +#endif
> +}
> +
> +static inline struct dentry * __lookup_hash_single(struct qstr *name, struct dentry *base, struct nameidata *nd)
> +{
> +	struct dentry *dentry;
> +	struct inode *inode;
> +	int err;
> +
> +	inode = base->d_inode;
> +
> +	err = permission(inode, MAY_EXEC, nd);
> +	dentry = ERR_PTR(err);
> +	if (err)
> +		goto out;
> +
> +	dentry = __lookup_hash_kern_single(name, base, nd);
> +out:
> +	return dentry;
> +}
>  #endif	/* __KERNEL __ */
>  #endif	/* __LINUX_UNION_H */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

