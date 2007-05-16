Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbXEPALB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbXEPALB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXEPAKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:10:52 -0400
Received: from lazybastard.de ([212.112.238.170]:50744 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbXEPAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:10:51 -0400
Date: Wed, 16 May 2007 02:06:31 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516000630.GD1220@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070515133759.9ee434a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 13:37:59 -0700, Andrew Morton wrote:
> > +
> > +config LOGFS_FSCK
> > +	bool "Run LogFS fsck at mount time"
> > +	depends on LOGFS
> > +	help
> > +	  Run a full filesystem check on every mount.  If any errors are
> > +	  found, mounting the filesystem will fail.  This is a debug option
> > +	  for developers.
> > +
> > +	  If unsure, say N.
> > +
> 
> No dependency on MTD,

Ack.

> Can this code be tested by people who don't have MTD hardware?  We used to
> ahve a fake-mtd-on-a-blockdev thing, whcih was in a state of some
> disrepair.  Maybe it got repaired.  Or removed.  I can't immediately locate
> it...

Got removed.  Block2mtd is the new one and works with logfs.  At least
my version of it does and I pushed my patches to David - not sure if
they made it to mainline already.  Mtdram should work as well.

> It's strange and a bit regrettable that an fs would have dependency on MTD,
> really.

It is and changing this wouldn't be too hard.  All device access goes
through five functions (read, write, erase, is_bad and mark_bad).  As
soon as someone seriously cares I will add a struct logfs_device_ops and
have a second set of these functions for block devices.

On hard disks it shouldn't make too much sense.  The filesystem will
fragment like a splinter bomb and be just as popular.

> ooh, documentation.  Quick, merge it!

:)

> > +/* memtree.c */
> > +void btree_init(struct btree_head *head);
> > +void *btree_lookup(struct btree_head *head, long val);
> > +int btree_insert(struct btree_head *head, long val, void *ptr);
> > +int btree_remove(struct btree_head *head, long val);
> 
> These names are too generic.  If we later add a btree library: blam.

My plan was to move this code to lib/ sooner or later.  If you consider
it useful in its current state, I can do it immediatly.  And if someone
else merged a superior btree library I'd happily remove mine and use the
new one instead.

Opinions?

> > +/* super.c */
> > +int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> > +int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf);
> > +int mtderase(struct super_block *sb, loff_t ofs, size_t len);
> > +void logfs_crash_dump(struct super_block *sb);
> > +int all_ff(void *buf, size_t len);
> > +int logfs_statfs(struct dentry *dentry, struct kstatfs *stats);
> 
> Have you checked that all of this needs global scope?

Not within the last month.  Will recheck.

> > +
> > +/* progs/fsck.c */
> > +#ifdef CONFIG_LOGFS_FSCK
> > +int logfs_fsck(struct super_block *sb);
> > +#else
> > +#define logfs_fsck(sb) ({ 0; })
> 
> static inline int logfs_fsck(struct super_block *sb)
> {
> 	return 0;
> }
> 
> is better: nicer to look at, has typechecking.

That's what I tried first.  But the brick I carry on my neck decided to
compile and link the read logfs_fsck() unconditionally and so this
collided.

Will change the Makefile and this.

> > +static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
> > +{
> > +	return sb->s_fs_info;
> > +}
> > +
> > +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> > +{
> > +	return container_of(inode, struct logfs_inode, vfs_inode);
> > +}
> 
> Do these need to be uppercase?

No more than EXT2_SB() or EXT2_I().

Since you are the second person to ask, I sense a majority vote to
change the case.

> > +static inline pgoff_t logfs_index(u64 pos)
> > +{
> > +	return pos / LOGFS_BLOCKSIZE;
> > +}
> 
> If the compiler goofs up here we'll end up trying to do a 64/32 divide and
> it won't link on 32-bit machines.  It would be safer to do
> 
> 	return pos >> LOGFS_BLOCKSHIFT;

Will change.

> > +int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen)
> > +{
> > +	int err, ret;
> > +
> > +	ret = -EIO;
> > +	mutex_lock(&compr_mutex);
> 
> A per-superblock lock and stream would be nicer.

Yes and no.  The zlib workspaces weigh about 300k.  On any decent SMP
machine, that hardly matters and getting the scalability is nice.  For
low-end embedded, that amount of memory per filesystem can matter.

I have no clue how many people would suffer one way or another.

> > +
> > +
> > +static inline loff_t file_end(struct inode *inode)
> > +{
> > +	return (i_size_read(inode) + inode->i_sb->s_blocksize - 1)
> > +		>> inode->i_sb->s_blocksize_bits;
> > +}
> > +static void logfs_set_name(struct logfs_disk_dentry *dd, struct qstr *name)
> > +{
> 
> The code has a strange mix of two-blank-lines-between-functions and
> no-blank-lines-between-functions.  One blank line is usual.

Will change.

> > +
> > +	if (dest) {
> > +		/* symlink */
> > +		ret = logfs_inode_write(inode, dest, destlen, 0);
> > +	} else {
> > +		/* creat/mkdir/mknod */
> > +		ret = __logfs_write_inode(inode);
> > +	}
> > +	super->s_victim_ino = 0;
> > +	if (ret) {
> > +		if (!dest)
> > +			li->li_flags |= LOGFS_IF_STILLBORN;
> > +		/* FIXME: truncate symlink */
> > +		inode->i_nlink--;
> > +		iput(inode);
> > +		goto out;
> > +	}
> > +
> > +	if (inode->i_mode & S_IFDIR)
> > +		dir->i_nlink++;
> 
> You have helper functions for i_nlink++, which remember to do
> mark_inode_dirty()?

I do.  Looks like I should use them here and in at least one other
place.  Will recheck them all.

> > +static struct inode_operations logfs_symlink_iops = {
> > +	.readlink	= generic_readlink,
> > +	.follow_link	= page_follow_link_light,
> > +};
> 
> Should be const.

As should be all oder struct foo_ops.  Will do.

> > +static int logfs_permission(struct inode *inode, int mask, struct nameidata *nd)
> > +{
> > +	return generic_permission(inode, mask, NULL);
> > +}
> 
> Does this need to exist?

It does not.  Will remove.

> const
> const

Yep.

> > +
> > +	BUG_ON(PAGE_CACHE_SIZE != inode->i_sb->s_blocksize);
> 
> This check can be done once, at mount time.

Will do.

> > +	buf = kmap(page);
> > +	ret = logfs_write_buf(inode, index, buf);
> > +	kunmap(page);
> 
> kmap() is lame.  The preferred approach would be to pass the page* down to
> the lower layers and to use kmap_atomic() at the lowest possible point.

Interesting.  I'll have a look at this.

> const
> const
> const

Yep.

> > +/*
> > + * cookie is set to 1 if we hand out a cached inode, 0 otherwise.
> > + * this allows logfs_iput to do the right thing later
> > + */
> > +struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *cookie)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	struct logfs_inode *li;
> > +
> > +	if (ino == LOGFS_INO_MASTER)
> > +		return super->s_master_inode;
> > +
> > +	spin_lock(&inode_lock);
> > +	list_for_each_entry(li, &super->s_freeing_list, li_freeing_list)
> > +		if (li->vfs_inode.i_ino == ino) {
> > +			spin_unlock(&inode_lock);
> > +			*cookie = 1;
> > +			return &li->vfs_inode;
> > +		}
> > +	spin_unlock(&inode_lock);
> > +
> > +	*cookie = 0;
> > +	return __logfs_iget(sb, ino);
> > +}
> 
> A filesystem playing with inode_lock: not good.  What's going on here?
> 
> As a minimum, the reasons for this should be clearly spelled out in code
> comments, because this sticks out like a sore thumb.

There is an explanation in the top 30 lines of the file.  Should I add a
reference here?

> > +struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino)
> > +{
> > +	struct inode *inode;
> > +
> > +	inode = logfs_alloc_inode(sb);
> > +	if (!inode)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	logfs_init_inode(inode);
> > +	inode->i_mode = 0;
> > +	inode->i_ino = ino;
> > +	inode->i_sb = sb;
> > +
> > +	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
> > +	 * to be nonstatic, alas. */
> > +	{
> > +		static const struct address_space_operations empty_aops;
> > +		struct address_space * const mapping = &inode->i_data;
> > +
> > +		mapping->a_ops = &empty_aops;
> > +		mapping->host = inode;
> > +		mapping->flags = 0;
> > +		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
> > +		mapping->assoc_mapping = NULL;
> > +		mapping->backing_dev_info = &default_backing_dev_info;
> > +		inode->i_mapping = mapping;
> > +	}
> > +
> > +	return inode;
> > +}
> 
> This function would benefit from some comments.  What's it doing, and why
> is it special?  I mean, new_inode() calls alloc_inode() anyway, so you're
> unable to use new_inode().  The reader wonders why.

Inodes are stored in an inode file.  The inode file's inode (master
inode) caused me a bit of headache.  It needs to be released as the very
last, so that any regular inodes can still use it for writeback.

Doing so would gave the user an unpleasant message:
		if (invalidate_inodes(sb)) {
			printk("VFS: Busy inodes after unmount of %s. "
			   "Self-destruct in 5 seconds.  Have a nice day...\n",
			   sb->s_id);
		}

This function mainly exists to smuggle the master inode around this
check.  I didn't know any better way to deal with the problem.

Add this as comment or is there a better strategy I should persue?

> > +static struct timespec be64_to_timespec(__be64 betime)
> > +{
> > +	u64 time = be64_to_cpu(betime);
> > +	struct timespec tsp;
> > +
> > +	tsp.tv_sec = time >> 32;
> > +	tsp.tv_nsec = time & 0xffffffff;
> > +	WARN_ON(tsp.tv_nsec > 999999999);
> > +	return tsp;
> > +}
> 
> Could use ns_to_timespec(be64_to_cpu(betime)) here.

Would this help.  Looks like the function does a division and adds any
remainder to tsp.tv_sec.  But any value for tsp.tv_nsec >= NSEC_PER_SEC
is caused by either a bug or data corruption.

If the goal is to prevent illegal values, I could do something cheaper
like:
	if (tsp.tv_nsec >= NSEC_PER_SEC)
		tsp.tv_nsec = 0;

> Should use >= NSEC_PER_SEC here.

Will do.

> > +
> > +static __be64 timespec_to_be64(struct timespec tsp)
> > +{
> > +	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
> > +
> > +	WARN_ON(tsp.tv_nsec > 999999999);
> > +	return cpu_to_be64(time);
> > +}
> 
> Dittos.

Yep.

> > +	spin_lock(&super->s_ino_lock);
> > +	ino = super->s_last_ino;
> > +	super->s_last_ino++;
> > +	spin_unlock(&super->s_ino_lock);
> > +	return ino;
> > +}
> 
> Could use atomic64_add_return() here.

tag not found: atomic64_add_return

That one seems to be missing from include/asm-i386/

> > +static void logfs_init_once(void *_li, struct kmem_cache *cachep,
> > +		unsigned long flags)
> > +{
> > +	struct logfs_inode *li = _li;
> > +	int i;
> > +
> > +	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
> > +			SLAB_CTOR_CONSTRUCTOR) {
> 
> This won't compile in mainline (SLAB_CTOR_VERIFY has gone)
> 
> And it won't compile in -mm (SLAB_CTOR_CONSTRUCTOR has gone).
> 
> Just remove the test altogether.

Will do.

> const

Yep.

> > +
> > +int logfs_init_inode_cache(void)
> > +{
> > +	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
> > +			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
> > +			logfs_init_once, NULL);
> 
> Use KMEM_CACHE() helper

Neat!  Will do.

> <attention span ran out, sorry>

No worries!  Thank you a lot for what you've found.  It seems to include
some bugs.

Jörn

-- 
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus
