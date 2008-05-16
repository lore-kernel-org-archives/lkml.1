Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYEPWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYEPWh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYEPWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:37:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbYEPWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:37:47 -0400
Date: Fri, 16 May 2008 15:36:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression caused
 by bf726e "semaphore: fix,")
In-Reply-To: <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
References: <20080510121020.f33c83f7.akpm@linux-foundation.org> <20080511073338.GA17137@elte.hu> <20080511075522.GA18214@elte.hu> <Pine.LNX.4.64.0805111150250.32758@titan.stealer.net> <20080511125731.GA28174@elte.hu> <alpine.LFD.1.10.0805110941540.3330@woody.linux-foundation.org>
 <20080511111210.77858eb4.akpm@linux-foundation.org> <alpine.LFD.1.10.0805111221070.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805111243250.3188@woody.linux-foundation.org> <20080511235112.GA16101@elte.hu> <alpine.LFD.1.10.0805120155490.3514@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org> <alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org> <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Linus Torvalds wrote:
> 
> In fact, some of the lock_kernel() calls looked like they could even be 
> dropped:
> 
>  - fat_clear_inode already gets the real spinlocks (inode_hash_lock and 
>    cache_lru_lock), and the kernel lock looks pointless.

Ok, this was also the only one that was called under the superblock lock 
(sys_umount->deactivate_super->invalidate_inodes->clear_inode), and 
everything else could be directly converted to use the superblock lock, so 
here's a trial balloon patch that does exactly that: just blindly convert 
all the "lock_kernel()" calls to "lock_super(sb)", except for the one in 
fat_clear_inode(), which is dropped entirely.

NOTE! There's no way in hell I'll actually commit this, but I did test it 
a bit with a vfat filesystem. I did *not* test extensively, but I did 
various "generate a directory tree, read it, write it, an remove it", so 
the basics do work. But I didn't test an old 8+3 plaim MSDOS filesystem, 
nor did I run any real filesystem stress test, but I do think this is at 
least an interesting starting point, and it's at least not "totally 
obviously broken".

Linux-kernel added to Cc list in case some random person is interested in 
looking at FAT/VFAT/MSDOS lock_kernel removal. 

ANOTHER NOTE! I didn't change this to use .unlocked_ioctl(), and I didn't 
even really look at it. It still takes the BKL, but obviously doesn't help 
any. It didn't look like it should really need it, because it seems to do 
the right locking as-is (ie it gets the inode mutex, and it calls 
__fat_readdir() which now does the lock_super()).

So afaik, those things should just be changed to ".unlocked_ioctl" 
instead, but that also drops the inode as an argument, so then you need to 
also add that "struct inode *inode = filp->f_dentry->d_inode" thing. And 
I'm hoping that other people are interested and will look at this more 
anyway!

		Linus

---
 fs/fat/cache.c   |    2 +-
 fs/fat/dir.c     |    4 ++--
 fs/fat/file.c    |   12 +++++++-----
 fs/fat/inode.c   |   26 ++++++++++++++++----------
 fs/msdos/namei.c |   35 +++++++++++++++++++----------------
 fs/vfat/namei.c  |   35 +++++++++++++++++++----------------
 6 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index fda2547..3a9ecac 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -61,7 +61,7 @@ void fat_cache_destroy(void)
 
 static inline struct fat_cache *fat_cache_alloc(struct inode *inode)
 {
-	return kmem_cache_alloc(fat_cache_cachep, GFP_KERNEL);
+	return kmem_cache_alloc(fat_cache_cachep, GFP_NOFS);
 }
 
 static inline void fat_cache_free(struct fat_cache *cache)
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 486725e..34541d0 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -472,7 +472,7 @@ static int __fat_readdir(struct inode *inode, struct file *filp, void *dirent,
 	loff_t cpos;
 	int ret = 0;
 
-	lock_kernel();
+	lock_super(sb);
 
 	cpos = filp->f_pos;
 	/* Fake . and .. for the root directory. */
@@ -654,7 +654,7 @@ FillFailed:
 	if (unicode)
 		__putname(unicode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return ret;
 }
 
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 27cc116..7059928 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -229,7 +229,8 @@ static int fat_free(struct inode *inode, int skip)
 
 void fat_truncate(struct inode *inode)
 {
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	const unsigned int cluster_size = sbi->cluster_size;
 	int nr_clusters;
 
@@ -242,9 +243,9 @@ void fat_truncate(struct inode *inode)
 
 	nr_clusters = (inode->i_size + (cluster_size - 1)) >> sbi->cluster_bits;
 
-	lock_kernel();
+	lock_super(sb);
 	fat_free(inode, nr_clusters);
-	unlock_kernel();
+	unlock_super(sb);
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 }
 
@@ -297,12 +298,13 @@ static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
 
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
+	struct super_block *sb = dentry->d_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
 	int mask, error = 0;
 	unsigned int ia_valid;
 
-	lock_kernel();
+	lock_super(sb);
 
 	/*
 	 * Expand the file. Since inode_setattr() updates ->i_size
@@ -356,7 +358,7 @@ int fat_setattr(struct dentry *dentry, struct iattr *attr)
 		mask = sbi->options.fs_fmask;
 	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return error;
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 4e0a3dd..46a4508 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -440,14 +440,13 @@ static void fat_delete_inode(struct inode *inode)
 
 static void fat_clear_inode(struct inode *inode)
 {
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	lock_kernel();
 	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
 	spin_unlock(&sbi->inode_hash_lock);
-	unlock_kernel();
 }
 
 static void fat_write_super(struct super_block *sb)
@@ -485,7 +484,7 @@ static struct kmem_cache *fat_inode_cachep;
 static struct inode *fat_alloc_inode(struct super_block *sb)
 {
 	struct msdos_inode_info *ei;
-	ei = kmem_cache_alloc(fat_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(fat_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
@@ -567,7 +566,7 @@ retry:
 	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
 		return 0;
 
-	lock_kernel();
+	lock_super(sb);
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
 		printk(KERN_ERR "FAT: unable to read inode block "
@@ -579,7 +578,7 @@ retry:
 	if (i_pos != MSDOS_I(inode)->i_pos) {
 		spin_unlock(&sbi->inode_hash_lock);
 		brelse(bh);
-		unlock_kernel();
+		unlock_super(sb);
 		goto retry;
 	}
 
@@ -606,7 +605,7 @@ retry:
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return err;
 }
 
@@ -736,6 +735,7 @@ fat_encode_fh(struct dentry *de, __u32 *fh, int *lenp, int connectable)
 
 static struct dentry *fat_get_parent(struct dentry *child)
 {
+	struct super_block *sb = child->d_sb;
 	struct buffer_head *bh;
 	struct msdos_dir_entry *de;
 	loff_t i_pos;
@@ -743,14 +743,14 @@ static struct dentry *fat_get_parent(struct dentry *child)
 	struct inode *inode;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
 	if (err) {
 		parent = ERR_PTR(err);
 		goto out;
 	}
-	inode = fat_build_inode(child->d_sb, de, i_pos);
+	inode = fat_build_inode(sb, de, i_pos);
 	brelse(bh);
 	if (IS_ERR(inode)) {
 		parent = ERR_CAST(inode);
@@ -762,7 +762,7 @@ static struct dentry *fat_get_parent(struct dentry *child)
 		parent = ERR_PTR(-ENOMEM);
 	}
 out:
-	unlock_kernel();
+	unlock_super(sb);
 
 	return parent;
 }
@@ -1172,6 +1172,12 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	long error;
 	char buf[50];
 
+	/*
+	 * GFP_KERNEL is ok here, because while we do hold the
+	 * supeblock lock, memory pressure can't call back into
+	 * the filesystem, since we're only just about to mount
+	 * it and have no inodes etc active!
+	 */
 	sbi = kzalloc(sizeof(struct msdos_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
diff --git a/fs/msdos/namei.c b/fs/msdos/namei.c
index 05ff4f1..1f7f295 100644
--- a/fs/msdos/namei.c
+++ b/fs/msdos/namei.c
@@ -214,7 +214,7 @@ static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
 
 	dentry->d_op = &msdos_dentry_operations;
 
-	lock_kernel();
+	lock_super(sb);
 	res = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (res == -ENOENT)
 		goto add;
@@ -232,7 +232,7 @@ add:
 	if (dentry)
 		dentry->d_op = &msdos_dentry_operations;
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	if (!res)
 		return dentry;
 	return ERR_PTR(res);
@@ -286,7 +286,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, int mode,
 	unsigned char msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -315,7 +315,7 @@ static int msdos_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	d_instantiate(dentry, inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 	return err;
@@ -324,11 +324,12 @@ out:
 /***** Remove a directory */
 static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct super_block *sb = dir->i_sb;
 	struct inode *inode = dentry->d_inode;
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 	/*
 	 * Check whether the directory is not in use, then check
 	 * whether it is empty.
@@ -349,9 +350,9 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	if (!err)
-		err = fat_flush_inodes(inode->i_sb, dir, inode);
+		err = fat_flush_inodes(sb, dir, inode);
 
 	return err;
 }
@@ -366,7 +367,7 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct timespec ts;
 	int err, is_hid, cluster;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -404,14 +405,14 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	d_instantiate(dentry, inode);
 
-	unlock_kernel();
+	unlock_super(sb);
 	fat_flush_inodes(sb, dir, inode);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return err;
 }
 
@@ -419,10 +420,11 @@ out:
 static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
+	struct super_block *sb= inode->i_sb;
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (err)
 		goto out;
@@ -434,9 +436,9 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	if (!err)
-		err = fat_flush_inodes(inode->i_sb, dir, inode);
+		err = fat_flush_inodes(sb, dir, inode);
 
 	return err;
 }
@@ -618,10 +620,11 @@ error_inode:
 static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct super_block *sb = old_dir->i_sb;
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = msdos_format_name(old_dentry->d_name.name,
 				old_dentry->d_name.len, old_msdos_name,
@@ -640,9 +643,9 @@ static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
 	err = do_msdos_rename(old_dir, old_msdos_name, old_dentry,
 			      new_dir, new_msdos_name, new_dentry, is_hid);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	if (!err)
-		err = fat_flush_inodes(old_dir->i_sb, old_dir, new_dir);
+		err = fat_flush_inodes(sb, old_dir, new_dir);
 	return err;
 }
 
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index a352272..b546ba6 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -645,7 +645,7 @@ static int vfat_add_entry(struct inode *dir, struct qstr *qname, int is_dir,
 	if (len == 0)
 		return -ENOENT;
 
-	slots = kmalloc(sizeof(*slots) * MSDOS_SLOTS, GFP_KERNEL);
+	slots = kmalloc(sizeof(*slots) * MSDOS_SLOTS, GFP_NOFS);
 	if (slots == NULL)
 		return -ENOMEM;
 
@@ -687,7 +687,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *alias;
 	int err, table;
 
-	lock_kernel();
+	lock_super(sb);
 	table = (MSDOS_SB(sb)->options.name_check == 's') ? 2 : 0;
 	dentry->d_op = &vfat_dentry_ops[table];
 
@@ -699,7 +699,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		unlock_kernel();
+		unlock_super(sb);
 		return ERR_CAST(inode);
 	}
 	alias = d_find_alias(inode);
@@ -708,13 +708,13 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 			dput(alias);
 		else {
 			iput(inode);
-			unlock_kernel();
+			unlock_super(sb);
 			return alias;
 		}
 
 	}
 error:
-	unlock_kernel();
+	unlock_super(sb);
 	dentry->d_op = &vfat_dentry_ops[table];
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
@@ -734,7 +734,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
 	struct timespec ts;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 
 	ts = CURRENT_TIME_SEC;
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
@@ -755,17 +755,18 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return err;
 }
 
 static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = fat_dir_empty(inode);
 	if (err)
@@ -783,7 +784,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 
 	return err;
 }
@@ -791,10 +792,11 @@ out:
 static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+	lock_super(sb);
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err)
@@ -807,7 +809,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 
 	return err;
 }
@@ -820,7 +822,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct timespec ts;
 	int err, cluster;
 
-	lock_kernel();
+	lock_super(sb);
 
 	ts = CURRENT_TIME_SEC;
 	cluster = fat_alloc_new_dir(dir, &ts);
@@ -849,13 +851,13 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
-	unlock_kernel();
+	unlock_super(sb);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_kernel();
+	unlock_super(sb);
 	return err;
 }
 
@@ -869,11 +871,12 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct timespec ts;
 	loff_t dotdot_i_pos, new_i_pos;
 	int err, is_dir, update_dotdot, corrupt = 0;
+	struct super_block *sb = old_dir->i_sb;
 
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
-	lock_kernel();
+	lock_super(sb);
 	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo);
 	if (err)
 		goto out;
@@ -951,7 +954,7 @@ out:
 	brelse(sinfo.bh);
 	brelse(dotdot_bh);
 	brelse(old_sinfo.bh);
-	unlock_kernel();
+	unlock_super(sb);
 
 	return err;
 
