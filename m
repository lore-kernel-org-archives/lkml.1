Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZG0Qyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZG0Qyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZG0Qyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:54:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:57263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZG0Qye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:54:34 -0400
Date: Mon, 27 Jul 2009 18:54:30 +0200
From: Jan Kara <jack@suse.cz>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090727165430.GD8332@duck.suse.cz>
References: <1248466429.3567.82.camel@localhost> <20090724224813.GK27755@shareable.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20090724224813.GK27755@shareable.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 24-07-09 23:48:14, Jamie Lokier wrote:
> > - subtree notification.
> > 	Currently to only watch /home and all of it's descendants one must
> > either register a directed watch on every directory or use a global
> > listener.  The global listener with ignored_mask is not as bad as it
> > sounds in my testing, but decent subtree registration and notification
> > would be a big win in a lot of people's mind.
> 
> I believe we've talked about one suggestion for how to do this, on
> lwn.net.  I'll repeat it here.
> 
> Efficient recursive notifications method:
> 
>    - You register for event on a directory with a RECURSIVE flag "give
>      me events for this directory and all paths below it".
> 
>    - That listener gets events for any access of the appropriate type
>      whose path is via that directory, *using the specific run-time
>      path used for the access*.
> 
>    - That _doesn't_ mean hard-link files need to know all their parent
>      directories, which would be silly and impossible.  The event path
>      is just the one used at run-time for access, by the application
>      attempting to open/write/whatever.
> 
>    - If a listener needs to track all accesses to a particular
>      hard-linked file, it's the responsibility of the listener to
>      ensure it listens to enough directories to cover every path to
>      that file - or listen to the file directly.  It knows from
>      i_nlink and the mount map when it has enough directories.
> 
>    - Notifying just the access path may seem counterintuitive, but in
>      fact it's what inotify and dnotify do already, and it does
>      actually work.  Often a listener is maintaining a cache or index
>      of some kind, in which case it will already have sufficient
>      knowledge about where the hard-linked files are (or know that it
>      needs an initial indexing), and whether it has covered enough
>      parent directories to see all accesses to them.
> 
>    - In practice it means each access traverses the path, following
>      parent directories until reaching a mount point, broadcasting
>      events on each one where there's a recursive listener.  That's
>      not as inefficient as it looks, because paths don't usually have
>      a large number of components.
> 
>    - I'm not sure exactly how fast/slow it is, though, and it may a
>      few thoughtfully cached flags in each dentry to elide traversals.
>      I won't discuss the details here, for fear of complicating the
>      discussion too much.  They might well mesh with the 'access
>      decision cache' flags you mentioned.
> 
>    - It is necessary that link(2) create an attribute-change event
>      (for i_nlink!) on the source path of the link.  dnotify/inotify
>      don't do that now (unless they changed recently), but they should
>      to make this work.
  About two years ago, I had a similar idea for a lightweight persistent
recursive modification. I even have a proof-of-concept patch against 2.6.23
(attached to get an idea) which works nicely. I've aimed at things like
efficient backup or desktop indexing which are interested in processing
lots of changes in a batch once in a longer period of time...  Actually I
believe this kind of use is quite different from the kind of use fanotify
aims at and maybe different approaches even make sence here... My approach
is only able to give the information "something in the subtree has changed"
via an inode flag in the directory inode and the application has to track
down what exactly it was (by recursively looking on the flags of the
subdirectories and stating regular files). The benefit is it's rather
scalable I believe.
  Generally the trouble with this approach is that one has to handle
hardlinks, bind mounts and filesystems which don't support persistent
storage of your attributes. It's all doable but tricky, and I'm still
trying to get all the details right in a shared library wrapping up the
kernel feature (well, one of the problems also is I get to this for only a
few days a year :().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext3-2.6.23-1-i_flags_atomicity.diff"

Implement atomic updates of EXT3_I(inode)->i_flags. So far the i_flags access
was guarded mostly by i_mutex but this is quite heavy-weight. We now use
inode->i_lock to protect i_flags reading and updates in ext3. This patch
introduces a bogus warning that jflag and oldflags may be uninitialized -
anyone knows how to cleanly get rid of it?

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/dir.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/dir.c
--- linux-2.6.23/fs/ext3/dir.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/dir.c	2007-11-05 14:04:56.000000000 +0100
@@ -108,10 +108,10 @@ static int ext3_readdir(struct file * fi
 	sb = inode->i_sb;
 
 #ifdef CONFIG_EXT3_INDEX
-	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
-				    EXT3_FEATURE_COMPAT_DIR_INDEX) &&
-	    ((EXT3_I(inode)->i_flags & EXT3_INDEX_FL) ||
-	     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
+	if (is_dx(inode) ||
+	    (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, \
+					EXT3_FEATURE_COMPAT_DIR_INDEX) &&
+	     (inode->i_size >> sb->s_blocksize_bits) == 1)) {
 		err = ext3_dx_readdir(filp, dirent, filldir);
 		if (err != ERR_BAD_DX_DIR) {
 			ret = err;
@@ -121,7 +121,9 @@ static int ext3_readdir(struct file * fi
 		 * We don't set the inode dirty flag since it's not
 		 * critical that it get flushed back to the disk.
 		 */
+		spin_lock(&inode->i_lock);
 		EXT3_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
+		spin_unlock(&inode->i_lock);
 	}
 #endif
 	stored = 0;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/ialloc.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c
--- linux-2.6.23/fs/ext3/ialloc.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c	2007-11-05 14:14:50.000000000 +0100
@@ -278,7 +278,7 @@ static int find_group_orlov(struct super
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if ((parent == sb->s_root->d_inode) ||
-	    (EXT3_I(parent)->i_flags & EXT3_TOPDIR_FL)) {
+	    ext3_test_inode_flags(parent, EXT3_TOPDIR_FL)) {
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
@@ -566,7 +566,11 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
+	/* Guard reading of directory's i_flags, created inode is safe as
+	 * noone has a reference to it yet */
+	spin_lock(&dir->i_lock);
 	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+	spin_unlock(&dir->i_lock);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
 	/* dirsync only applies to directories */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/inode.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c
--- linux-2.6.23/fs/ext3/inode.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c	2007-11-05 14:24:39.000000000 +0100
@@ -2557,8 +2557,10 @@ int ext3_get_inode_loc(struct inode *ino
 
 void ext3_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT3_I(inode)->i_flags;
+	unsigned int flags;
 
+	spin_lock(&inode->i_lock);
+	flags = EXT3_I(inode)->i_flags;
 	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 	if (flags & EXT3_SYNC_FL)
 		inode->i_flags |= S_SYNC;
@@ -2570,13 +2572,16 @@ void ext3_set_inode_flags(struct inode *
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT3_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	spin_unlock(&inode->i_lock);
 }
 
 /* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
 void ext3_get_inode_flags(struct ext3_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
+	unsigned int flags;
 
+	spin_lock(&ei->vfs_inode.i_lock);
+	flags = ei->vfs_inode.i_flags;
 	ei->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
 			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
 	if (flags & S_SYNC)
@@ -2589,6 +2594,7 @@ void ext3_get_inode_flags(struct ext3_in
 		ei->i_flags |= EXT3_NOATIME_FL;
 	if (flags & S_DIRSYNC)
 		ei->i_flags |= EXT3_DIRSYNC_FL;
+	spin_unlock(&ei->vfs_inode.i_lock);
 }
 
 void ext3_read_inode(struct inode * inode)
@@ -2781,7 +2787,9 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
+	spin_lock(&inode->i_lock);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
+	spin_unlock(&inode->i_lock);
 #ifdef EXT3_FRAGMENTS
 	raw_inode->i_faddr = cpu_to_le32(ei->i_faddr);
 	raw_inode->i_frag = ei->i_frag_no;
@@ -3209,10 +3217,12 @@ int ext3_change_inode_journal_flag(struc
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
+	spin_lock(&inode->i_lock);
 	if (val)
 		EXT3_I(inode)->i_flags |= EXT3_JOURNAL_DATA_FL;
 	else
 		EXT3_I(inode)->i_flags &= ~EXT3_JOURNAL_DATA_FL;
+	spin_unlock(&inode->i_lock);
 	ext3_set_aops(inode);
 
 	journal_unlock_updates(journal);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/ioctl.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/ioctl.c
--- linux-2.6.23/fs/ext3/ioctl.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/ioctl.c	2007-11-05 14:32:12.000000000 +0100
@@ -29,7 +29,9 @@ int ext3_ioctl (struct inode * inode, st
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
 		ext3_get_inode_flags(ei);
+		spin_lock(&inode->i_lock);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
+		spin_unlock(&inode->i_lock);
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
@@ -51,10 +53,19 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		oldflags = ei->i_flags;
+		handle = ext3_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			mutex_unlock(&inode->i_mutex);
+			return PTR_ERR(handle);
+		}
+		if (IS_SYNC(inode))
+			handle->h_sync = 1;
+		err = ext3_reserve_inode_write(handle, inode, &iloc);
+		if (err)
+			goto flags_err;
 
-		/* The JOURNAL_DATA flag is modifiable only by root */
-		jflag = flags & EXT3_JOURNAL_DATA_FL;
+		spin_lock(&inode->i_lock);
+		oldflags = ei->i_flags;
 
 		/*
 		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
@@ -64,8 +75,9 @@ int ext3_ioctl (struct inode * inode, st
 		 */
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
-				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				spin_unlock(&inode->i_lock);
+				err = -EPERM;
+				goto flags_err;
 			}
 		}
 
@@ -73,28 +85,19 @@ int ext3_ioctl (struct inode * inode, st
 		 * The JOURNAL_DATA flag can only be changed by
 		 * the relevant capability.
 		 */
+		jflag = flags & EXT3_JOURNAL_DATA_FL;
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
-				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				spin_unlock(&inode->i_lock);
+				err = -EPERM;
+				goto flags_err;
 			}
 		}
 
-
-		handle = ext3_journal_start(inode, 1);
-		if (IS_ERR(handle)) {
-			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
-		}
-		if (IS_SYNC(inode))
-			handle->h_sync = 1;
-		err = ext3_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto flags_err;
-
 		flags = flags & EXT3_FL_USER_MODIFIABLE;
 		flags |= oldflags & ~EXT3_FL_USER_MODIFIABLE;
 		ei->i_flags = flags;
+		spin_unlock(&inode->i_lock);
 
 		ext3_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/include/linux/ext3_fs.h linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h
--- linux-2.6.23/include/linux/ext3_fs.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h	2007-11-05 14:31:44.000000000 +0100
@@ -514,6 +514,17 @@ static inline int ext3_valid_inum(struct
 		(ino >= EXT3_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count));
 }
+
+static inline unsigned int ext3_test_inode_flags(struct inode *inode, u32 flags)
+{
+	unsigned int ret;
+
+	spin_lock(&inode->i_lock);
+	ret = EXT3_I(inode)->i_flags & flags;
+	spin_unlock(&inode->i_lock);
+	return ret;
+}
+
 #else
 /* Assume that user mode programs are passing in an ext3fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
@@ -666,9 +677,18 @@ struct ext3_dir_entry_2 {
  */
 
 #ifdef CONFIG_EXT3_INDEX
-  #define is_dx(dir) (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
-					      EXT3_FEATURE_COMPAT_DIR_INDEX) && \
-		      (EXT3_I(dir)->i_flags & EXT3_INDEX_FL))
+static inline int is_dx(struct inode *dir)
+{
+	int ret = 0;
+
+	if (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
+	      EXT3_FEATURE_COMPAT_DIR_INDEX)) {
+		spin_lock(&dir->i_lock);
+		ret = EXT3_I(dir)->i_flags & EXT3_INDEX_FL;
+		spin_unlock(&dir->i_lock);
+	}
+	return ret;
+}
 #define EXT3_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT3_LINK_MAX)
 #define EXT3_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
 #else
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/include/linux/ext3_fs_i.h linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_i.h
--- linux-2.6.23/include/linux/ext3_fs_i.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_i.h	2007-11-05 14:26:43.000000000 +0100
@@ -69,7 +69,7 @@ struct ext3_block_alloc_info {
  */
 struct ext3_inode_info {
 	__le32	i_data[15];	/* unconverted */
-	__u32	i_flags;
+	__u32	i_flags;	/* Guarded by inode->i_lock */
 #ifdef EXT3_FRAGMENTS
 	__u32	i_faddr;
 	__u8	i_frag_no;

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext3-2.6.23-2-make_frags_unused.diff"

Make space reserved for fragments as unused as they were never implemented.
Remove also related initializations.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c linux-2.6.23-2-make_flags_unused/fs/ext3/ialloc.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c	2007-11-05 14:14:50.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/ialloc.c	2007-11-05 14:37:33.000000000 +0100
@@ -576,11 +576,6 @@ got:
 	/* dirsync only applies to directories */
 	if (!S_ISDIR(mode))
 		ei->i_flags &= ~EXT3_DIRSYNC_FL;
-#ifdef EXT3_FRAGMENTS
-	ei->i_faddr = 0;
-	ei->i_frag_no = 0;
-	ei->i_frag_size = 0;
-#endif
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c linux-2.6.23-2-make_flags_unused/fs/ext3/inode.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c	2007-11-05 14:24:39.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/inode.c	2007-11-05 14:38:05.000000000 +0100
@@ -2651,11 +2651,6 @@ void ext3_read_inode(struct inode * inod
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
-#ifdef EXT3_FRAGMENTS
-	ei->i_faddr = le32_to_cpu(raw_inode->i_faddr);
-	ei->i_frag_no = raw_inode->i_frag;
-	ei->i_frag_size = raw_inode->i_fsize;
-#endif
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
@@ -2790,11 +2785,6 @@ static int ext3_do_update_inode(handle_t
 	spin_lock(&inode->i_lock);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
 	spin_unlock(&inode->i_lock);
-#ifdef EXT3_FRAGMENTS
-	raw_inode->i_faddr = cpu_to_le32(ei->i_faddr);
-	raw_inode->i_frag = ei->i_frag_no;
-	raw_inode->i_fsize = ei->i_frag_size;
-#endif
 	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/super.c linux-2.6.23-2-make_flags_unused/fs/ext3/super.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/super.c	2007-11-05 15:04:19.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/super.c	2007-11-05 15:01:37.000000000 +0100
@@ -1584,17 +1584,7 @@ static int ext3_fill_super (struct super
 			goto failed_mount;
 		}
 	}
-	sbi->s_frag_size = EXT3_MIN_FRAG_SIZE <<
-				   le32_to_cpu(es->s_log_frag_size);
-	if (blocksize != sbi->s_frag_size) {
-		printk(KERN_ERR
-		       "EXT3-fs: fragsize %lu != blocksize %u (unsupported)\n",
-		       sbi->s_frag_size, blocksize);
-		goto failed_mount;
-	}
-	sbi->s_frags_per_block = 1;
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
-	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 	if (EXT3_INODE_SIZE(sb) == 0)
 		goto cantfind_ext3;
@@ -1618,12 +1608,6 @@ static int ext3_fill_super (struct super
 			sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
-	if (sbi->s_frags_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT3-fs: #fragments per group too big: %lu\n",
-			sbi->s_frags_per_group);
-		goto failed_mount;
-	}
 	if (sbi->s_inodes_per_group > blocksize * 8) {
 		printk (KERN_ERR
 			"EXT3-fs: #inodes per group too big: %lu\n",
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs.h
--- linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h	2007-11-05 14:31:44.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs.h	2007-11-05 14:37:33.000000000 +0100
@@ -291,27 +291,24 @@ struct ext3_inode {
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
-	__le32	i_faddr;	/* Fragment address */
+	__le32	i_obsolete_faddr;	/* Unused */
 	union {
 		struct {
-			__u8	l_i_frag;	/* Fragment number */
-			__u8	l_i_fsize;	/* Fragment size */
+			__u16	l_i_obsolete_frag;	/* Unused */
 			__u16	i_pad1;
 			__le16	l_i_uid_high;	/* these 2 fields    */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
 		} linux2;
 		struct {
-			__u8	h_i_frag;	/* Fragment number */
-			__u8	h_i_fsize;	/* Fragment size */
+			__u16	h_i_obsolete_frag;	/* Unused */
 			__u16	h_i_mode_high;
 			__u16	h_i_uid_high;
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
 		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
+			__u16	m_i_obsolete_frag;	/* Unused */
 			__u16	m_pad1;
 			__u32	m_i_reserved2[2];
 		} masix2;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_sb.h linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs_sb.h
--- linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_sb.h	2007-10-11 12:01:28.000000000 +0200
+++ linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs_sb.h	2007-11-05 14:50:55.000000000 +0100
@@ -28,10 +28,7 @@
  * third extended-fs super-block data in memory
  */
 struct ext3_sb_info {
-	unsigned long s_frag_size;	/* Size of a fragment in bytes */
-	unsigned long s_frags_per_block;/* Number of fragments per block */
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
-	unsigned long s_frags_per_group;/* Number of fragments in a group */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
 	unsigned long s_inodes_per_group;/* Number of inodes in a group */
 	unsigned long s_itb_per_group;	/* Number of inode table blocks per group */

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext3-2.6.23-3-recursive_mtime.diff"

Implement recursive mtime (rtime) feature for ext3. The feature works as
follows: In each directory we keep a flag EXT3_RTIME_FL (modifiable by a user)
whether rtime should be updated. In case a directory or a file in it is
modified and when the flag is set, directory's rtime is updated, the flag is
cleared, and we move to the parent. If the flag is set there, we clear it,
update rtime and continue upwards upto the root of the filesystem. In case a
regular file or symlink is modified, we pick arbitrary of its parents (actually
the one that happens to be at the head of i_dentry list) and start the rtime
update algorith there.

As the flag is always cleared after updating rtime and we don't climb up the
tree if the flag is cleared, we have constant amortized complexity of rtime
updates. That's for theoretical time consumption ;) Practically, there's no
measurable performance impact for a test case like: touch every file in a
kernel tree where every directory has RTIME flag set.

Intended use case is that application which wants to watch any modification in
a subtree scans the subtree and sets flags for all inodes there. Next time, it
just needs to recurse in directories having rtime newer than the start of the
previous scan. There it can handle modifications and set the flag again. It is
up to application to watch out for hardlinked files. It can e.g.  build their
list and check their mtime separately (when a hardlink to a file is created its
inode is modified and rtimes properly updated and thus any application has an
effective way of finding new hardlinked files).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ialloc.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ialloc.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ialloc.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ialloc.c	2007-11-05 16:58:53.000000000 +0100
@@ -569,7 +569,7 @@ got:
 	/* Guard reading of directory's i_flags, created inode is safe as
 	 * noone has a reference to it yet */
 	spin_lock(&dir->i_lock);
-	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+ 	ei->i_flags = EXT3_I(dir)->i_flags & ~(EXT3_INDEX_FL | EXT3_RTIME_FL);
 	spin_unlock(&dir->i_lock);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
@@ -579,6 +579,7 @@ got:
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
+	ei->i_rtime = inode->i_mtime.tv_sec;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/inode.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/inode.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/inode.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/inode.c	2007-11-06 16:13:50.000000000 +0100
@@ -1232,6 +1232,8 @@ static int ext3_ordered_commit_write(str
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -1255,6 +1257,8 @@ static int ext3_writeback_commit_write(s
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -1288,6 +1292,8 @@ static int ext3_journalled_commit_write(
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -2386,6 +2392,10 @@ out_stop:
 		ext3_orphan_del(handle, inode);
 
 	ext3_journal_stop(handle);
+	/* We update time only for linked inodes. Unlinked ones already
+	 * notified parent during unlink... */
+	if (inode->i_nlink)
+		ext3_update_rtimes(inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
@@ -2628,6 +2638,8 @@ void ext3_read_inode(struct inode * inod
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
+	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, EXT3_FEATURE_COMPAT_RTIME))
+		ei->i_rtime = le32_to_cpu(raw_inode->i_rtime);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2780,6 +2792,8 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, EXT3_FEATURE_COMPAT_RTIME))
+		raw_inode->i_rtime = cpu_to_le32(ei->i_rtime);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	spin_lock(&inode->i_lock);
@@ -2978,6 +2992,8 @@ int ext3_setattr(struct dentry *dentry, 
 
 	if (!rc && (ia_valid & ATTR_MODE))
 		rc = ext3_acl_chmod(inode);
+	if (!rc)
+		ext3_update_rtimes(inode);
 
 err_out:
 	ext3_std_error(inode->i_sb, error);
@@ -3129,6 +3145,7 @@ void ext3_dirty_inode(struct inode *inod
 	handle_t *current_handle = ext3_journal_current_handle();
 	handle_t *handle;
 
+	/* Reserve 2 blocks for inode and superblock */
 	handle = ext3_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ioctl.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ioctl.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ioctl.c	2007-11-05 15:42:03.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ioctl.c	2007-11-05 16:58:53.000000000 +0100
@@ -23,10 +23,20 @@ int ext3_ioctl (struct inode * inode, st
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	unsigned int rtime;
 
 	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case EXT3_IOC_GETRTIME:
+		if (!test_opt(inode->i_sb, RTIME))
+			return -ENOTSUPP;
+		if (!S_ISDIR(inode->i_mode))
+			return -ENOTDIR;
+		spin_lock(&inode->i_lock);
+		rtime = ei->i_rtime;
+		spin_unlock(&inode->i_lock);
+		return put_user(rtime, (unsigned int __user *) arg);
 	case EXT3_IOC_GETFLAGS:
 		ext3_get_inode_flags(ei);
 		spin_lock(&inode->i_lock);
@@ -49,8 +59,10 @@ int ext3_ioctl (struct inode * inode, st
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		if (!S_ISDIR(inode->i_mode))
+		if (!S_ISDIR(inode->i_mode)) {
 			flags &= ~EXT3_DIRSYNC_FL;
+			flags &= ~EXT3_RTIME_FL;
+		}
 
 		mutex_lock(&inode->i_mutex);
 		handle = ext3_journal_start(inode, 1);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/namei.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/namei.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/namei.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/namei.c	2007-11-05 16:58:53.000000000 +0100
@@ -65,6 +65,59 @@ static struct buffer_head *ext3_append(h
 	return bh;
 }
 
+/* We don't want to get new handle for every inode updated. Thus we batch
+ * updates of this many inodes into one transaction */
+#define RTIME_UPDATES_PER_TRANS 16
+
+/* Walk up the directory tree and modify rtimes.
+ * We journal i_rtime updates into a separate transaction - we don't guarantee
+ * consistency between other inode times and rtime. Only consistency between
+ * i_flags and i_rtime. */
+int __ext3_update_rtimes(struct inode *inode)
+{
+	struct dentry *dentry = list_entry(inode->i_dentry.next, struct dentry,
+					d_alias);
+	handle_t *handle;
+	int updates = 0;
+	int err = 0;
+
+	/* We should not have any transaction started - noone knows how many
+	 * inode updates will be needed */
+	WARN_ON(ext3_journal_current_handle() != NULL);
+	if (!S_ISDIR(inode->i_mode)) {
+		dentry = dentry->d_parent;
+		inode = dentry->d_inode;
+	}
+	while (ext3_test_inode_flags(inode, EXT3_RTIME_FL)) {
+		if (!updates) {
+			/* For inode updates + superblock */
+			handle = ext3_journal_start(inode, RTIME_UPDATES_PER_TRANS + 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
+			updates = RTIME_UPDATES_PER_TRANS;
+		}
+
+		spin_lock(&inode->i_lock);
+		EXT3_I(inode)->i_rtime = get_seconds();
+		EXT3_I(inode)->i_flags &= ~EXT3_RTIME_FL;
+		spin_unlock(&inode->i_lock);
+		ext3_mark_inode_dirty(handle, inode);
+		if (!--updates) {
+			err = ext3_journal_stop(handle);
+			if (err)
+				return err;
+		}
+		
+		if (dentry == inode->i_sb->s_root)
+			break;
+		dentry = dentry->d_parent;
+		inode = dentry->d_inode;
+	}
+	if (updates)
+		err = ext3_journal_stop(handle);
+	return err;
+}
+
 #ifndef assert
 #define assert(test) J_ASSERT(test)
 #endif
@@ -1738,6 +1791,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1773,6 +1828,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1847,6 +1904,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2123,6 +2182,8 @@ static int ext3_rmdir (struct inode * di
 
 end_rmdir:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2177,6 +2238,8 @@ static int ext3_unlink(struct inode * di
 
 end_unlink:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2234,6 +2297,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2270,6 +2335,10 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err) {
+		ext3_update_rtimes(dir);
+		ext3_update_rtimes(inode);
+	}
 	return err;
 }
 
@@ -2429,6 +2498,10 @@ end_rename:
 	brelse (old_bh);
 	brelse (new_bh);
 	ext3_journal_stop(handle);
+	if (!retval) {
+		ext3_update_rtimes(old_dir);
+		ext3_update_rtimes(new_dir);
+	}
 	return retval;
 }
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/super.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/super.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/super.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/super.c	2007-11-05 16:58:53.000000000 +0100
@@ -684,7 +684,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_rtime
 };
 
 static match_table_t tokens = {
@@ -734,6 +734,7 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
+	{Opt_rtime, "rtime"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1066,6 +1067,14 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_rtime:
+			if (!EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_RTIME)) {
+				printk("EXT3-fs: rtime option available only "
+					"if superblock has RTIME feature.\n");
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, RTIME);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs.h linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs.h
--- linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs.h	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs.h	2007-11-06 16:34:43.000000000 +0100
@@ -177,10 +177,11 @@ struct ext3_group_desc
 #define EXT3_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define EXT3_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define EXT3_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define EXT3_RTIME_FL			0x00100000 /* Update recursive mtime (directories only) */
 #define EXT3_RESERVED_FL		0x80000000 /* reserved for ext3 lib */
 
-#define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-#define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
+#define EXT3_FL_USER_VISIBLE		0x0013DFFF /* User visible flags */
+#define EXT3_FL_USER_MODIFIABLE		0x001380FF /* User modifiable flags */
 
 /*
  * Inode dynamic state flags
@@ -229,6 +230,7 @@ struct ext3_new_group_data {
 #endif
 #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT3_IOC_GETRTIME		_IOR('f', 9, unsigned int)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -291,7 +293,7 @@ struct ext3_inode {
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
-	__le32	i_obsolete_faddr;	/* Unused */
+	__le32	i_rtime;	/* Recursive Modification Time - directories only */
 	union {
 		struct {
 			__u16	l_i_obsolete_frag;	/* Unused */
@@ -381,6 +383,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_RTIME		0x400000 /* Update rtime */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -580,6 +583,7 @@ static inline unsigned int ext3_test_ino
 #define EXT3_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT3_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT3_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT3_FEATURE_COMPAT_RTIME		0x0080
 
 #define EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT3_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -854,6 +858,13 @@ extern int ext3_orphan_add(handle_t *, s
 extern int ext3_orphan_del(handle_t *, struct inode *);
 extern int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
+extern int __ext3_update_rtimes(struct inode *inode);
+static inline int ext3_update_rtimes(struct inode *inode)
+{
+	if (test_opt(inode->i_sb, RTIME))
+		return __ext3_update_rtimes(inode);
+	return 0;
+}
 
 /* resize.c */
 extern int ext3_group_add(struct super_block *sb,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs_i.h linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs_i.h
--- linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs_i.h	2007-11-05 15:42:03.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs_i.h	2007-11-05 16:58:53.000000000 +0100
@@ -78,6 +78,7 @@ struct ext3_inode_info {
 	ext3_fsblk_t	i_file_acl;
 	__u32	i_dir_acl;
 	__u32	i_dtime;
+	__u32	i_rtime;
 
 	/*
 	 * i_block_group is the number of the block group which contains

--opJtzjQTFsWo+cga--
