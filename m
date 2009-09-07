Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZIGJlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZIGJlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZIGJlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:41:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:49264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZIGJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:41:08 -0400
Date: Mon, 7 Sep 2009 11:41:10 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 05/33] fs: scale mntget/mntput
Message-ID: <20090907094110.GI1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.636133158@nick.local0.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904065534.636133158@nick.local0.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 04:51:46PM +1000, npiggin@suse.de wrote:
> Improve scalability of mntget/mntput by using per-cpu counters protected
> by the reader side of the brlock vfsmount_lock. mnt_mounted keeps track of
> whether the vfsmount is actually attached to the tree so we can shortcut
> expensive checks in mntput.

Ah, I have a problem with count_mnt_count here...

count_mnt_count probably needs write lock otherwise you could count
CPU0, then counter is incremented on CPU0 and decremented on CPUN, then
you count the decrement on CPUN but have missed the increment.
count_mnt_count should be a slowpath anyway I think. may_umount_tree and
do_refcount_check I think need the write lock.

I think I was mis-remembering my mnt writers count per-cpu patches here,
but that's got a much more complex scheme to avoid atomic ops in the
fastpath... potentially we could possibly use the same scheme to speed
up mntget. Or if speed is not a problem then perhaps simplify mnt_want_write
with the use of the brlock vfsmount lock...

Anyway, I'll fix this one up the simple way for now, and I need to look
closely at single-threaded performance of this patchset in some areas anyway
so I'll revisit then.

> ---
>  fs/libfs.c            |    1 
>  fs/namespace.c        |  122 +++++++++++++++++++++++++++++++++++++++++++-------
>  fs/pnode.c            |    2 
>  include/linux/mount.h |   33 ++++---------
>  4 files changed, 121 insertions(+), 37 deletions(-)
> 
> Index: linux-2.6/fs/namespace.c
> ===================================================================
> --- linux-2.6.orig/fs/namespace.c
> +++ linux-2.6/fs/namespace.c
> @@ -177,6 +177,49 @@ void mnt_release_group_id(struct vfsmoun
>  	mnt->mnt_group_id = 0;
>  }
>  
> +static inline void add_mnt_count(struct vfsmount *mnt, int n)
> +{
> +#ifdef CONFIG_SMP
> +	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) += n;
> +#else
> +	mnt->mnt_count += n;
> +#endif
> +}
> +
> +static inline void inc_mnt_count(struct vfsmount *mnt)
> +{
> +#ifdef CONFIG_SMP
> +	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id()))++;
> +#else
> +	mnt->mnt_count++;
> +#endif
> +}
> +
> +static inline void dec_mnt_count(struct vfsmount *mnt)
> +{
> +#ifdef CONFIG_SMP
> +	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id()))--;
> +#else
> +	mnt->mnt_count--;
> +#endif
> +}
> +
> +unsigned int count_mnt_count(struct vfsmount *mnt)
> +{
> +#ifdef CONFIG_SMP
> +	unsigned int count = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		count += *per_cpu_ptr(mnt->mnt_count, cpu);
> +	}
> +
> +	return count;
> +#else
> +	return mnt->mnt_count;
> +#endif
> +}
> +
>  struct vfsmount *alloc_vfsmnt(const char *name)
>  {
>  	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
> @@ -193,7 +236,13 @@ struct vfsmount *alloc_vfsmnt(const char
>  				goto out_free_id;
>  		}
>  
> -		atomic_set(&mnt->mnt_count, 1);
> +#ifdef CONFIG_SMP
> +		mnt->mnt_count = alloc_percpu(int);
> +		if (!mnt->mnt_count)
> +			goto out_free_devname;
> +#else
> +		mnt->mnt_count = 0;
> +#endif
>  		INIT_LIST_HEAD(&mnt->mnt_hash);
>  		INIT_LIST_HEAD(&mnt->mnt_child);
>  		INIT_LIST_HEAD(&mnt->mnt_mounts);
> @@ -205,14 +254,19 @@ struct vfsmount *alloc_vfsmnt(const char
>  #ifdef CONFIG_SMP
>  		mnt->mnt_writers = alloc_percpu(int);
>  		if (!mnt->mnt_writers)
> -			goto out_free_devname;
> +			goto out_free_mntcount;
>  #else
>  		mnt->mnt_writers = 0;
>  #endif
> +		preempt_disable();
> +		inc_mnt_count(mnt);
> +		preempt_enable();
>  	}
>  	return mnt;
>  
>  #ifdef CONFIG_SMP
> +out_free_mntcount:
> +	free_percpu(mnt->mnt_count);
>  out_free_devname:
>  	kfree(mnt->mnt_devname);
>  #endif
> @@ -526,9 +580,11 @@ static void detach_mnt(struct vfsmount *
>  	old_path->mnt = mnt->mnt_parent;
>  	mnt->mnt_parent = mnt;
>  	mnt->mnt_mountpoint = mnt->mnt_root;
> -	list_del_init(&mnt->mnt_child);
>  	list_del_init(&mnt->mnt_hash);
> +	list_del_init(&mnt->mnt_child);
>  	old_path->dentry->d_mounted--;
> +	WARN_ON(mnt->mnt_mounted != 1);
> +	mnt->mnt_mounted--;
>  }
>  
>  void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
> @@ -545,6 +601,8 @@ static void attach_mnt(struct vfsmount *
>  	list_add_tail(&mnt->mnt_hash, mount_hashtable +
>  			hash(path->mnt, path->dentry));
>  	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
> +	WARN_ON(mnt->mnt_mounted != 0);
> +	mnt->mnt_mounted++;
>  }
>  
>  /*
> @@ -567,6 +625,8 @@ static void commit_tree(struct vfsmount
>  	list_add_tail(&mnt->mnt_hash, mount_hashtable +
>  				hash(parent, mnt->mnt_mountpoint));
>  	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
> +	WARN_ON(mnt->mnt_mounted != 0);
> +	mnt->mnt_mounted++;
>  	touch_mnt_namespace(n);
>  }
>  
> @@ -670,50 +730,80 @@ static inline void __mntput(struct vfsmo
>  
>  void mntput_no_expire(struct vfsmount *mnt)
>  {
> -repeat:
> -	/* open-code atomic_dec_and_lock for the vfsmount lock */
> -	if (atomic_add_unless(&mnt->mnt_count, -1, 1))
> +	if (likely(mnt->mnt_mounted)) {
> +		vfsmount_read_lock();
> +		if (unlikely(!mnt->mnt_mounted)) {
> +			vfsmount_read_unlock();
> +			goto repeat;
> +		}
> +		dec_mnt_count(mnt);
> +		BUG_ON(count_mnt_count(mnt) == 0);
> +		vfsmount_read_unlock();
> +
>  		return;
> +	}
> +
> +repeat:
>  	vfsmount_write_lock();
> -	if (!atomic_dec_and_test(&mnt->mnt_count)) {
> +	BUG_ON(mnt->mnt_mounted);
> +	dec_mnt_count(mnt);
> +	if (count_mnt_count(mnt)) {
>  		vfsmount_write_unlock();
>  		return;
>  	}
> -
>  	if (likely(!mnt->mnt_pinned)) {
>  		vfsmount_write_unlock();
>  		__mntput(mnt);
>  		return;
>  	}
> -	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
> +	add_mnt_count(mnt, mnt->mnt_pinned + 1);
>  	mnt->mnt_pinned = 0;
>  	vfsmount_write_unlock();
>  	acct_auto_close_mnt(mnt);
>  	security_sb_umount_close(mnt);
>  	goto repeat;
>  }
> -
>  EXPORT_SYMBOL(mntput_no_expire);
>  
> +void mntput(struct vfsmount *mnt)
> +{
> +	if (mnt) {
> +		/* avoid cacheline pingpong */
> +		if (unlikely(mnt->mnt_expiry_mark))
> +			mnt->mnt_expiry_mark = 0;
> +		mntput_no_expire(mnt);
> +	}
> +}
> +EXPORT_SYMBOL(mntput);
> +
> +struct vfsmount *mntget(struct vfsmount *mnt)
> +{
> +	if (mnt) {
> +		preempt_disable();
> +		inc_mnt_count(mnt);
> +		preempt_enable();
> +	}
> +	return mnt;
> +}
> +EXPORT_SYMBOL(mntget);
> +
>  void mnt_pin(struct vfsmount *mnt)
>  {
>  	vfsmount_write_lock();
>  	mnt->mnt_pinned++;
>  	vfsmount_write_unlock();
>  }
> -
>  EXPORT_SYMBOL(mnt_pin);
>  
>  void mnt_unpin(struct vfsmount *mnt)
>  {
>  	vfsmount_write_lock();
>  	if (mnt->mnt_pinned) {
> -		atomic_inc(&mnt->mnt_count);
> +		inc_mnt_count(mnt);
>  		mnt->mnt_pinned--;
>  	}
>  	vfsmount_write_unlock();
>  }
> -
>  EXPORT_SYMBOL(mnt_unpin);
>  
>  static inline void mangle(struct seq_file *m, const char *s)
> @@ -996,7 +1086,7 @@ int may_umount_tree(struct vfsmount *mnt
>  
>  	vfsmount_read_lock();
>  	for (p = mnt; p; p = next_mnt(p, mnt)) {
> -		actual_refs += atomic_read(&p->mnt_count);
> +		actual_refs += count_mnt_count(p);
>  		minimum_refs += 2;
>  	}
>  	vfsmount_read_unlock();
> @@ -1076,6 +1166,8 @@ void umount_tree(struct vfsmount *mnt, i
>  		__touch_mnt_namespace(p->mnt_ns);
>  		p->mnt_ns = NULL;
>  		list_del_init(&p->mnt_child);
> +		WARN_ON(p->mnt_mounted != 1);
> +		p->mnt_mounted--;
>  		if (p->mnt_parent != p) {
>  			p->mnt_parent->mnt_ghosts++;
>  			p->mnt_mountpoint->d_mounted--;
> @@ -1107,7 +1199,7 @@ static int do_umount(struct vfsmount *mn
>  		    flags & (MNT_FORCE | MNT_DETACH))
>  			return -EINVAL;
>  
> -		if (atomic_read(&mnt->mnt_count) != 2)
> +		if (count_mnt_count(mnt) != 2)
>  			return -EBUSY;
>  
>  		if (!xchg(&mnt->mnt_expiry_mark, 1))
> Index: linux-2.6/include/linux/mount.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mount.h
> +++ linux-2.6/include/linux/mount.h
> @@ -56,20 +56,20 @@ struct vfsmount {
>  	struct mnt_namespace *mnt_ns;	/* containing namespace */
>  	int mnt_id;			/* mount identifier */
>  	int mnt_group_id;		/* peer group identifier */
> -	/*
> -	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
> -	 * to let these frequently modified fields in a separate cache line
> -	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
> -	 */
> -	atomic_t mnt_count;
>  	int mnt_expiry_mark;		/* true if marked for expiry */
>  	int mnt_pinned;
>  	int mnt_ghosts;
> +	int mnt_mounted;
>  #ifdef CONFIG_SMP
>  	int *mnt_writers;
>  #else
>  	int mnt_writers;
>  #endif
> +#ifdef CONFIG_SMP
> +	int *mnt_count;
> +#else
> +	int mnt_count;
> +#endif
>  };
>  
>  static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
> @@ -81,13 +81,6 @@ static inline int *get_mnt_writers_ptr(s
>  #endif
>  }
>  
> -static inline struct vfsmount *mntget(struct vfsmount *mnt)
> -{
> -	if (mnt)
> -		atomic_inc(&mnt->mnt_count);
> -	return mnt;
> -}
> -
>  struct file; /* forward dec */
>  
>  extern void vfsmount_read_lock(void);
> @@ -95,23 +88,21 @@ extern void vfsmount_read_unlock(void);
>  extern void vfsmount_write_lock(void);
>  extern void vfsmount_write_unlock(void);
>  
> +extern unsigned int count_mnt_count(struct vfsmount *mnt);
> +
>  extern int mnt_want_write(struct vfsmount *mnt);
>  extern int mnt_want_write_file(struct file *file);
>  extern int mnt_clone_write(struct vfsmount *mnt);
>  extern void mnt_drop_write(struct vfsmount *mnt);
> +
>  extern void mntput_no_expire(struct vfsmount *mnt);
> +extern struct vfsmount *mntget(struct vfsmount *mnt);
> +extern void mntput(struct vfsmount *mnt);
> +
>  extern void mnt_pin(struct vfsmount *mnt);
>  extern void mnt_unpin(struct vfsmount *mnt);
>  extern int __mnt_is_readonly(struct vfsmount *mnt);
>  
> -static inline void mntput(struct vfsmount *mnt)
> -{
> -	if (mnt) {
> -		mnt->mnt_expiry_mark = 0;
> -		mntput_no_expire(mnt);
> -	}
> -}
> -
>  extern struct vfsmount *do_kern_mount(const char *fstype, int flags,
>  				      const char *name, void *data);
>  
> Index: linux-2.6/fs/pnode.c
> ===================================================================
> --- linux-2.6.orig/fs/pnode.c
> +++ linux-2.6/fs/pnode.c
> @@ -279,7 +279,7 @@ out:
>   */
>  static inline int do_refcount_check(struct vfsmount *mnt, int count)
>  {
> -	int mycount = atomic_read(&mnt->mnt_count) - mnt->mnt_ghosts;
> +	int mycount = count_mnt_count(mnt) - mnt->mnt_ghosts;
>  	return (mycount > count);
>  }
>  
> Index: linux-2.6/fs/libfs.c
> ===================================================================
> --- linux-2.6.orig/fs/libfs.c
> +++ linux-2.6/fs/libfs.c
> @@ -244,6 +244,7 @@ int get_sb_pseudo(struct file_system_typ
>  	d_instantiate(dentry, root);
>  	s->s_root = dentry;
>  	s->s_flags |= MS_ACTIVE;
> +	mnt->mnt_mounted++; /* never unmounted, shortcut mntget (XXX: OK?) */
>  	simple_set_mnt(mnt, s);
>  	return 0;
>  
> 
