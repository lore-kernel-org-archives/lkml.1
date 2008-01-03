Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYACTiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYACTiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYACTiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:38:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44351 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYACTiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:38:12 -0500
Subject: Re: [PATCH] track number of mnts writing to superblocks
From: Dave Hansen <haveblue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       hch@infradead.org
In-Reply-To: <20080103040258.GB14117@sergelap.austin.ibm.com>
References: <20080102215110.F3A0B1DC@kernel>
	 <20080103040258.GB14117@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 11:37:49 -0800
Message-Id: <1199389069.13731.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-02 at 22:02 -0600, Serge E. Hallyn wrote:
> Ok I'm blabbing quite a bit here while trying to figure out
> the patch, and maybe there are some useful hints for where more
> comments would be useful.  But other than the fact that
> mark_mnt_has_writer() needs to the atomic_inc() even if
> cpu_writer was passed in as NULL, the patch seems good.

Yeah, I screwed that up.  Should be fixed now.

> > Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> > ---
> > 
> >  linux-2.6.git-dave/fs/file_table.c       |   24 -----
> >  linux-2.6.git-dave/fs/namespace.c        |  134 +++++++++++++++++++++++++------
> >  linux-2.6.git-dave/fs/super.c            |   61 +++++++++++---
> >  linux-2.6.git-dave/include/linux/fs.h    |    5 -
> >  linux-2.6.git-dave/include/linux/mount.h |    3 
> >  5 files changed, 163 insertions(+), 64 deletions(-)
> > 
> > diff -puN fs/file_table.c~track_sb_mnt_writers fs/file_table.c
> > --- linux-2.6.git/fs/file_table.c~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> > +++ linux-2.6.git-dave/fs/file_table.c	2008-01-02 10:49:11.000000000 -0800
> > @@ -374,30 +374,6 @@ void file_kill(struct file *file)
> >  	}
> >  }
> > 
> > -int fs_may_remount_ro(struct super_block *sb)
> > -{
> > -	struct file *file;
> > -
> > -	/* Check that no files are currently opened for writing. */
> > -	file_list_lock();
> > -	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
> > -		struct inode *inode = file->f_path.dentry->d_inode;
> > -
> > -		/* File with pending delete? */
> > -		if (inode->i_nlink == 0)
> > -			goto too_bad;
> > -
> > -		/* Writeable file? */
> > -		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
> 
> (why did this originally skip directories?)

I think it's more to skip device files and named pipes than directories.
I don't even know what happens offhand if you try a plain write() to an
open directory.

> > diff -puN fs/file_table.c.orig~track_sb_mnt_writers fs/file_table.c.orig
> > diff -puN fs/namespace.c~track_sb_mnt_writers fs/namespace.c
> > --- linux-2.6.git/fs/namespace.c~track_sb_mnt_writers	2008-01-02 10:49:11.000000000 -0800
> > +++ linux-2.6.git-dave/fs/namespace.c	2008-01-02 13:39:52.000000000 -0800
> > @@ -118,7 +118,7 @@ struct mnt_writer {
> >  	 * If holding multiple instances of this lock, they
> >  	 * must be ordered by cpu number.
> >  	 */
> > -	spinlock_t lock;
> > +	struct mutex lock;
> >  	struct lock_class_key lock_class; /* compiles out with !lockdep */
> >  	unsigned long count;
> >  	struct vfsmount *mnt;
> > @@ -130,7 +130,7 @@ static int __init init_mnt_writers(void)
> >  	int cpu;
> >  	for_each_possible_cpu(cpu) {
> >  		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
> > -		spin_lock_init(&writer->lock);
> > +		mutex_init(&writer->lock);
> >  		lockdep_set_class(&writer->lock, &writer->lock_class);
> >  		writer->count = 0;
> >  	}
> > @@ -145,11 +145,52 @@ static void mnt_unlock_cpus(void)
> > 
> >  	for_each_possible_cpu(cpu) {
> >  		cpu_writer = &per_cpu(mnt_writers, cpu);
> > -		spin_unlock(&cpu_writer->lock);
> > +		mutex_unlock(&cpu_writer->lock);
> >  	}
> >  }
> > 
> > -static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
> > +static int mark_mnt_has_writer(struct vfsmount *mnt,
> > +			       struct mnt_writer *cpu_writer)
> > +{
> > +	/*
> > +	 * Ensure that if there are people racing to set
> > +	 * the bit that only one of them succeeds and can
> > +	 * increment the sb count.
> > +	 */
> > +	if (test_and_set_bit(ilog2(MNT_MAY_HAVE_WRITERS), &mnt->mnt_flags))
> > +		return 0;
> 
> Comment isn't entirely clear, but you're returning 0 here because
> someone else has already set the flag and incremented
> sb->__s_mnt_writers so you don't have to and you're all set to go on
> with writing?

Yeah.  This function is all about making sure that the sb is marked
properly because the mnt is writable.  If it's already marked, then
we're good to go.

> > +	if (cpu_writer == NULL)
> > +		return 0;
> > +
> > +	/*
> > +	 * Our goal here is to get exclusion from a superblock
> > +	 * remount operation (fs_may_remount_ro()).  This is
> > +	 * effectively a slow path that we must go through the
> > +	 * first time we set the bit on each mount, but never
> > +	 * again unless the writer counts get coalesced.
> > +	 */
> > +
> > +	mutex_unlock(&cpu_writer->lock);
> > +	lock_super(mnt->mnt_sb);
> > +
> > +	atomic_inc(&mnt->mnt_sb->__s_mnt_writers);
> 
> The atomic_inc of course should be done even if cpu_writer was passed
> in as NULL, you just don't need to do the locking then, and can
> return 0 in that case?

Yep.  I'll fix that.

> > +
> > +	unlock_super(mnt->mnt_sb);
> > +	mutex_lock(&cpu_writer->lock);
> > +	return -EAGAIN;
> > +}
> > +
> > +static void __mark_sb_if_writable(struct vfsmount *mnt)
> 
> This function is taking the writable state from a mnt and marking it in
> the sb.  So the name should be a shorter verison of something like
> "commit_mnt_writable_state_to_sb"

Here's what I have now:

static void __sync_mnt_writable_to_sb(struct vfsmount *mnt)

> > +{
> > +	int bitnr = ilog2(MNT_MAY_HAVE_WRITERS);
> > +
> > +	if (atomic_read(&mnt->__mnt_writers))
> > +		mark_mnt_has_writer(mnt, NULL);
> > +	else if (test_and_clear_bit(bitnr, &mnt->mnt_flags))
> > +		atomic_dec(&mnt->mnt_sb->__s_mnt_writers);
> 
> And after staring at this code for awhile it did make sense, but a
> comment above it would help saying that
> 
> 	/* If mnt has writers, mark_mnt_has_writer() will make
> 	   sure that is marked in the sb.  If mnt has no writers,
> 	   then if mnt->mnt_flags was previously set, that means
> 	   that mnt->mnt_sb->__s_mnt_writers reflects our having
> 	   writers, so we decrement it
> 	 */
> 
> Ok, maybe it's clearer to other people and the comment isn't needed...

You couldn't figure it out at first glance, and I tend to think that
most people will have the same experience.  I'll see if I can add a
better comment.

I'll send out an updated patch in a bit along with a simpler alternative
patch.

-- Dave

