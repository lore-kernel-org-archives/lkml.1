Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYACEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYACEDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYACEDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:03:05 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38975 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYACEDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:03:03 -0500
Date: Wed, 2 Jan 2008 22:02:59 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       hch@infradead.org, serue@us.ibm.com
Subject: Re: [PATCH] track number of mnts writing to superblocks
Message-ID: <20080103040258.GB14117@sergelap.austin.ibm.com>
References: <20080102215110.F3A0B1DC@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102215110.F3A0B1DC@kernel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (haveblue@us.ibm.com):
> 
> One of the benefits of the r/o bind mount patches is that they
> make it explicit when a write to a superblock might occur.
> We currently search sb->s_files when remounting rw->ro to look
> for writable files.  But, that search is not comprehensive, and
> it is racy.  This replaces that search.
> 
> The idea is to keep a bit in each mount saying whether the
> mount has any writers on it.  When the bit is set the first
> time, we also increment a counter in the superblock.  That
> sb counter is the number of mounts with that bit set and
> thus, potential writers.
> 
> The other problem is that, after we make this check for
> the number of writable mounts, we need to exclude all new
> writers on those mounts.  We do this by requring that the
> superblock mnt writer count be incremented under a
> lock_super() and also holding that lock over the remount
> operation.  Effectively, this keeps us from *adding* to
> the sb's writable mounts during a remount.
> 
> The alternative to doing this is to do a much simpler list
> of mounts for each superblock.  I could also code that up
> to see what it look like.  Shouldn't be too bad.

Ok I'm blabbing quite a bit here while trying to figure out
the patch, and maybe there are some useful hints for where more
comments would be useful.  But other than the fact that
mark_mnt_has_writer() needs to the atomic_inc() even if
cpu_writer was passed in as NULL, the patch seems good.

thanks,
-serge

> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/file_table.c       |   24 -----
>  linux-2.6.git-dave/fs/namespace.c        |  134 +++++++++++++++++++++++++------
>  linux-2.6.git-dave/fs/super.c            |   61 +++++++++++---
>  linux-2.6.git-dave/include/linux/fs.h    |    5 -
>  linux-2.6.git-dave/include/linux/mount.h |    3 
>  5 files changed, 163 insertions(+), 64 deletions(-)
> 
> diff -puN fs/file_table.c~track_sb_mnt_writers fs/file_table.c
> --- linux-2.6.git/fs/file_table.c~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> +++ linux-2.6.git-dave/fs/file_table.c	2008-01-02 10:49:11.000000000 -0800
> @@ -374,30 +374,6 @@ void file_kill(struct file *file)
>  	}
>  }
> 
> -int fs_may_remount_ro(struct super_block *sb)
> -{
> -	struct file *file;
> -
> -	/* Check that no files are currently opened for writing. */
> -	file_list_lock();
> -	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
> -		struct inode *inode = file->f_path.dentry->d_inode;
> -
> -		/* File with pending delete? */
> -		if (inode->i_nlink == 0)
> -			goto too_bad;
> -
> -		/* Writeable file? */
> -		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))

(why did this originally skip directories?)

> -			goto too_bad;
> -	}
> -	file_list_unlock();
> -	return 1; /* Tis' cool bro. */
> -too_bad:
> -	file_list_unlock();
> -	return 0;
> -}
> -
>  void __init files_init(unsigned long mempages)
>  { 
>  	int n; 
> diff -puN fs/file_table.c.orig~track_sb_mnt_writers fs/file_table.c.orig
> diff -puN fs/namespace.c~track_sb_mnt_writers fs/namespace.c
> --- linux-2.6.git/fs/namespace.c~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> +++ linux-2.6.git-dave/fs/namespace.c	2008-01-02 13:39:52.000000000 -0800
> @@ -118,7 +118,7 @@ struct mnt_writer {
>  	 * If holding multiple instances of this lock, they
>  	 * must be ordered by cpu number.
>  	 */
> -	spinlock_t lock;
> +	struct mutex lock;
>  	struct lock_class_key lock_class; /* compiles out with !lockdep */
>  	unsigned long count;
>  	struct vfsmount *mnt;
> @@ -130,7 +130,7 @@ static int __init init_mnt_writers(void)
>  	int cpu;
>  	for_each_possible_cpu(cpu) {
>  		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
> -		spin_lock_init(&writer->lock);
> +		mutex_init(&writer->lock);
>  		lockdep_set_class(&writer->lock, &writer->lock_class);
>  		writer->count = 0;
>  	}
> @@ -145,11 +145,52 @@ static void mnt_unlock_cpus(void)
> 
>  	for_each_possible_cpu(cpu) {
>  		cpu_writer = &per_cpu(mnt_writers, cpu);
> -		spin_unlock(&cpu_writer->lock);
> +		mutex_unlock(&cpu_writer->lock);
>  	}
>  }
> 
> -static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
> +static int mark_mnt_has_writer(struct vfsmount *mnt,
> +			       struct mnt_writer *cpu_writer)
> +{
> +	/*
> +	 * Ensure that if there are people racing to set
> +	 * the bit that only one of them succeeds and can
> +	 * increment the sb count.
> +	 */
> +	if (test_and_set_bit(ilog2(MNT_MAY_HAVE_WRITERS), &mnt->mnt_flags))
> +		return 0;

Comment isn't entirely clear, but you're returning 0 here because
someone else has already set the flag and incremented
sb->__s_mnt_writers so you don't have to and you're all set to go on
with writing?

> +	if (cpu_writer == NULL)
> +		return 0;
> +
> +	/*
> +	 * Our goal here is to get exclusion from a superblock
> +	 * remount operation (fs_may_remount_ro()).  This is
> +	 * effectively a slow path that we must go through the
> +	 * first time we set the bit on each mount, but never
> +	 * again unless the writer counts get coalesced.
> +	 */
> +
> +	mutex_unlock(&cpu_writer->lock);
> +	lock_super(mnt->mnt_sb);
> +
> +	atomic_inc(&mnt->mnt_sb->__s_mnt_writers);

The atomic_inc of course should be done even if cpu_writer was passed
in as NULL, you just don't need to do the locking then, and can
return 0 in that case?

> +
> +	unlock_super(mnt->mnt_sb);
> +	mutex_lock(&cpu_writer->lock);
> +	return -EAGAIN;
> +}
> +
> +static void __mark_sb_if_writable(struct vfsmount *mnt)

This function is taking the writable state from a mnt and marking it in
the sb.  So the name should be a shorter verison of something like
"commit_mnt_writable_state_to_sb"

> +{
> +	int bitnr = ilog2(MNT_MAY_HAVE_WRITERS);
> +
> +	if (atomic_read(&mnt->__mnt_writers))
> +		mark_mnt_has_writer(mnt, NULL);
> +	else if (test_and_clear_bit(bitnr, &mnt->mnt_flags))
> +		atomic_dec(&mnt->mnt_sb->__s_mnt_writers);

And after staring at this code for awhile it did make sense, but a
comment above it would help saying that

	/* If mnt has writers, mark_mnt_has_writer() will make
	   sure that is marked in the sb.  If mnt has no writers,
	   then if mnt->mnt_flags was previously set, that means
	   that mnt->mnt_sb->__s_mnt_writers reflects our having
	   writers, so we decrement it
	 */

Ok, maybe it's clearer to other people and the comment isn't needed...

> +}
> +
> +static inline void __move_cpu_mnt_count(struct mnt_writer *cpu_writer)
>  {
>  	if (!cpu_writer->mnt)
>  		return;
> @@ -164,7 +205,7 @@ static inline void use_cpu_writer_for_mo
>  {
>  	if (cpu_writer->mnt == mnt)
>  		return;
> -	__clear_mnt_count(cpu_writer);
> +	__move_cpu_mnt_count(cpu_writer);
>  	cpu_writer->mnt = mnt;
>  }
> 
> @@ -188,20 +229,31 @@ static inline void use_cpu_writer_for_mo
>   */
>  int mnt_want_write(struct vfsmount *mnt)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct mnt_writer *cpu_writer;
> 
> -	cpu_writer = &get_cpu_var(mnt_writers);
> -	spin_lock(&cpu_writer->lock);
> +	/*
> +	 * It is OK to not disable preemption here.  We
> +	 * only use the per-cpu vars to reduce cache
> +	 * effects, and not for any real exclusion.
> +	 * We use the mutexes for that.
> +	 */
> +	cpu_writer = &__get_cpu_var(mnt_writers);
> +	mutex_lock(&cpu_writer->lock);
> +again:
> +	ret = 0;
>  	if (__mnt_is_readonly(mnt)) {
>  		ret = -EROFS;
>  		goto out;
>  	}
> +	ret = mark_mnt_has_writer(mnt, cpu_writer);
> +	/* did we hit the slow path and re-do the lock? */
> +	if (ret == -EAGAIN)
> +		goto again;
>  	use_cpu_writer_for_mount(cpu_writer, mnt);
>  	cpu_writer->count++;
>  out:
> -	spin_unlock(&cpu_writer->lock);
> -	put_cpu_var(mnt_writers);
> +	mutex_unlock(&cpu_writer->lock);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(mnt_want_write);
> @@ -213,13 +265,37 @@ static void lock_and_coalesce_cpu_mnt_wr
> 
>  	for_each_possible_cpu(cpu) {
>  		cpu_writer = &per_cpu(mnt_writers, cpu);
> -		spin_lock(&cpu_writer->lock);
> -		__clear_mnt_count(cpu_writer);
> +		mutex_lock(&cpu_writer->lock);
> +		__move_cpu_mnt_count(cpu_writer);
> +		/*
> +		 * __mnt_writers may temporarily hit zero
> +		 * (and trigger MNT_MAY_HAVE_WRITERS to get
> +		 * cleared), but it will get set again if
> +		 * and when another mnt_writer[] has an
> +		 * entry for that mnt later in this loop.
> +		 * Holding the locks keeps anyone from
> +		 * seeing this.
> +		 */
> +		__mark_sb_if_writable(cpu_writer->mnt);
>  		cpu_writer->mnt = NULL;
>  	}
>  }
> 
>  /*
> + * This is just an external interface.  I want
> + * to use the long names in here, but leave the
> + * simpler names for external users.
> + */
> +void lock_mnt_writers()
> +{
> +	lock_and_coalesce_cpu_mnt_writer_counts();
> +}
> +void unlock_mnt_writers()
> +{
> +	mnt_unlock_cpus();
> +}
> +
> +/*
>   * These per-cpu write counts are not guaranteed to have
>   * matched increments and decrements on any given cpu.
>   * A file open()ed for write on one cpu and close()d on
> @@ -262,23 +338,40 @@ static void handle_write_count_underflow
>   * performing writes to it.  Must be matched with
>   * mnt_want_write() call above.
>   */
> +#define MNT_WRITERS_UNDERFLOW_LIMIT 1024
>  void mnt_drop_write(struct vfsmount *mnt)
>  {
>  	int must_check_underflow = 0;
>  	struct mnt_writer *cpu_writer;
> 
> -	cpu_writer = &get_cpu_var(mnt_writers);
> -	spin_lock(&cpu_writer->lock);
> +retry:
> +	cpu_writer = &__get_cpu_var(mnt_writers);
> +	mutex_lock(&cpu_writer->lock);
> 
>  	use_cpu_writer_for_mount(cpu_writer, mnt);
>  	if (cpu_writer->count > 0) {
>  		cpu_writer->count--;
>  	} else {
> -		must_check_underflow = 1;
> +		/*
> +		 * Without this check, it is theoretically
> +		 * possible for large number of processes
> +		 * to atomic_dec(__mnt_writers) and cause
> +		 * it to underflow.  Because we are under
> +		 * the mutex (and there are NR_CPUS
> +		 * mutexes), this limits the number of
> +		 * concurrent decrements and underflow
> +		 * level to NR_CPUS.
> +		 */
> +		if (atomic_read(&mnt->__mnt_writers) <
> +			MNT_WRITER_UNDERFLOW_LIMIT) {
> +			mutex_unlock(&cpu_writer->lock);
> +			goto retry;
> +		}
>  		atomic_dec(&mnt->__mnt_writers);
> +		must_check_underflow = 1;
>  	}
> 
> -	spin_unlock(&cpu_writer->lock);
> +	mutex_unlock(&cpu_writer->lock);
>  	/*
>  	 * Logically, we could call this each time,
>  	 * but the __mnt_writers cacheline tends to
> @@ -286,15 +379,6 @@ void mnt_drop_write(struct vfsmount *mnt
>  	 */
>  	if (must_check_underflow)
>  		handle_write_count_underflow(mnt);
> -	/*
> -	 * This could be done right after the spinlock
> -	 * is taken because the spinlock keeps us on
> -	 * the cpu, and disables preemption.  However,
> -	 * putting it here bounds the amount that
> -	 * __mnt_writers can underflow.  Without it,
> -	 * we could theoretically wrap __mnt_writers.
> -	 */
> -	put_cpu_var(mnt_writers);
>  }
>  EXPORT_SYMBOL_GPL(mnt_drop_write);
> 
> diff -puN fs/namespace.c.orig~track_sb_mnt_writers fs/namespace.c.orig
> diff -puN include/linux/fs.h~track_sb_mnt_writers include/linux/fs.h
> --- linux-2.6.git/include/linux/fs.h~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> +++ linux-2.6.git-dave/include/linux/fs.h	2008-01-02 10:49:11.000000000 -0800
> @@ -1005,6 +1005,9 @@ struct super_block {
>  #ifdef CONFIG_SECURITY
>  	void                    *s_security;
>  #endif
> +	atomic_t		__s_mnt_writers;/* how many mounts of this sb
> +						 * might have writers.  Only
> +						 * stable with lock_mnt_writers() */
>  	struct xattr_handler	**s_xattr;
> 
>  	struct list_head	s_inodes;	/* all inodes */
> @@ -1650,8 +1653,6 @@ extern const struct file_operations read
>  extern const struct file_operations write_fifo_fops;
>  extern const struct file_operations rdwr_fifo_fops;
> 
> -extern int fs_may_remount_ro(struct super_block *);
> -
>  #ifdef CONFIG_BLOCK
>  /*
>   * return READ, READA, or WRITE
> diff -puN include/linux/fs.h.orig~track_sb_mnt_writers include/linux/fs.h.orig
> diff -puN include/linux/mount.h~track_sb_mnt_writers include/linux/mount.h
> --- linux-2.6.git/include/linux/mount.h~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> +++ linux-2.6.git-dave/include/linux/mount.h	2008-01-02 10:49:11.000000000 -0800
> @@ -33,6 +33,7 @@ struct mnt_namespace;
> 
>  #define MNT_SHRINKABLE	0x100
>  #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
> +#define MNT_MAY_HAVE_WRITERS		0x400 /* did this ever have a writer? */
> 
>  #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
>  #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
> @@ -80,6 +81,8 @@ static inline struct vfsmount *mntget(st
> 
>  extern int mnt_want_write(struct vfsmount *mnt);
>  extern void mnt_drop_write(struct vfsmount *mnt);
> +extern void lock_mnt_writers(void);
> +extern void unlock_mnt_writers(void);
>  extern void mntput_no_expire(struct vfsmount *mnt);
>  extern void mnt_pin(struct vfsmount *mnt);
>  extern void mnt_unpin(struct vfsmount *mnt);
> diff -puN include/linux/mount.h.orig~track_sb_mnt_writers include/linux/mount.h.orig
> diff -puN fs/super.c~track_sb_mnt_writers fs/super.c
> --- linux-2.6.git/fs/super.c~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> +++ linux-2.6.git-dave/fs/super.c	2008-01-02 13:38:15.000000000 -0800
> @@ -574,6 +574,41 @@ static void mark_files_ro(struct super_b
>  	file_list_unlock();
>  }
> 
> +static inline int fs_may_remount_ro(struct super_block *sb)
> +{
> +	int ret = 1;
> +	lock_mnt_writers();
> +	if (atomic_read(&sb->__s_mnt_writers))
> +		ret = 0;
> +	unlock_mnt_writers();
> +	return ret;
> +}
> +
> +/*
> + * This unconditionally acquires the sb lock,
> + * even if it returns an error code, and should
> + * not be used generally.
> + *
> + * This must be done to ensure that no new
> + * writers come in on the mounts after the
> + * check is performed.
> + */
> +static int __try_to_make_sb_ro(struct super_block *sb, int force)
> +{
> +	int retval = 0;
> +
> +	if (force) {
> +		mark_files_ro(sb);
> +		lock_super(sb);
> +	} else {
> +		lock_super(sb);
> +		/* Make sure there are no mounts that have writers */
> +		if (!fs_may_remount_ro(sb))
> +			retval = -EBUSY;
> +	}
> +	return retval;
> +}
> +
>  /**
>   *	do_remount_sb - asks filesystem to change mount options.
>   *	@sb:	superblock in question
> @@ -585,7 +620,7 @@ static void mark_files_ro(struct super_b
>   */
>  int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  {
> -	int retval;
> +	int retval = 0;
>  	
>  #ifdef CONFIG_BLOCK
>  	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
> @@ -596,23 +631,23 @@ int do_remount_sb(struct super_block *sb
>  	shrink_dcache_sb(sb);
>  	fsync_super(sb);
> 
> -	/* If we are remounting RDONLY and current sb is read/write,
> -	   make sure there are no rw files opened */
> -	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
> -		if (force)
> -			mark_files_ro(sb);
> -		else if (!fs_may_remount_ro(sb))
> -			return -EBUSY;
> -	}
> -
> -	if (sb->s_op->remount_fs) {
> +	/* Are we remounting RDONLY when current sb is read/write? */
> +	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY))
> +		retval = __try_to_make_sb_ro(sb, force);
> +	else
>  		lock_super(sb);
> +
> +	if (retval)
> +		goto out;
> +	if (sb->s_op->remount_fs)
>  		retval = sb->s_op->remount_fs(sb, &flags, data);
> +out:
> +	if (retval) {
>  		unlock_super(sb);
> -		if (retval)
> -			return retval;
> +		return retval;
>  	}
>  	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
> +	unlock_super(sb);
>  	return 0;
>  }
> 
> diff -puN block/cfq-iosched.c~track_sb_mnt_writers block/cfq-iosched.c
> diff -puN fs/namei.c~track_sb_mnt_writers fs/namei.c
> diff -puN fs/buffer.c~track_sb_mnt_writers fs/buffer.c
> diff -puN kernel/Makefile~track_sb_mnt_writers kernel/Makefile
> _
