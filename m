Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYEQA0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYEQA0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYEQAZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:25:57 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57202 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYEQAZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:25:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression caused by bf726e "semaphore: fix,")
References: <20080510121020.f33c83f7.akpm@linux-foundation.org>
	<20080511073338.GA17137@elte.hu> <20080511075522.GA18214@elte.hu>
	<Pine.LNX.4.64.0805111150250.32758@titan.stealer.net>
	<20080511125731.GA28174@elte.hu>
	<alpine.LFD.1.10.0805110941540.3330@woody.linux-foundation.org>
	<20080511111210.77858eb4.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805111221070.3188@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805111243250.3188@woody.linux-foundation.org>
	<20080511235112.GA16101@elte.hu>
	<alpine.LFD.1.10.0805120155490.3514@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
Date: Sat, 17 May 2008 09:25:46 +0900
In-Reply-To: <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 16 May 2008 15:36:49 -0700 (PDT)")
Message-ID: <87abip7p4l.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 16 May 2008, Linus Torvalds wrote:
>> 
>> In fact, some of the lock_kernel() calls looked like they could even be 
>> dropped:
>> 
>>  - fat_clear_inode already gets the real spinlocks (inode_hash_lock and 
>>    cache_lru_lock), and the kernel lock looks pointless.
>
> Ok, this was also the only one that was called under the superblock lock 
> (sys_umount->deactivate_super->invalidate_inodes->clear_inode), and 
> everything else could be directly converted to use the superblock lock, so 
> here's a trial balloon patch that does exactly that: just blindly convert 
> all the "lock_kernel()" calls to "lock_super(sb)", except for the one in 
> fat_clear_inode(), which is dropped entirely.

IIRC, when I looked this lastly, almost BKLs was just tossed from VFS,
and FAT taked the needed locks anymore, but I'm not sure NFS related
stuff.  Basically, we can just drop BKLs and I tested it repeatedly.

I attached the tested patch by me (but nfs stuff is not tested, it
triggers -ESTALE easily). But, I can't say, "I'm very sure, this patch
is safe", so, I didn't submit the patch yet...

> ANOTHER NOTE! I didn't change this to use .unlocked_ioctl(), and I didn't 
> even really look at it. It still takes the BKL, but obviously doesn't help 
> any. It didn't look like it should really need it, because it seems to do 
> the right locking as-is (ie it gets the inode mutex, and it calls 
> __fat_readdir() which now does the lock_super()).

Ah, I didn't notice about this. But we should be able to just use it.

>  static inline struct fat_cache *fat_cache_alloc(struct inode *inode)
>  {
> -	return kmem_cache_alloc(fat_cache_cachep, GFP_KERNEL);
> +	return kmem_cache_alloc(fat_cache_cachep, GFP_NOFS);
>  }

Yes.

>  static struct inode *fat_alloc_inode(struct super_block *sb)
>  {
>  	struct msdos_inode_info *ei;
> -	ei = kmem_cache_alloc(fat_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(fat_inode_cachep, GFP_NOFS);
>  	if (!ei)
>  		return NULL;
>  	return &ei->vfs_inode;

Um... do we need this? I think this path is not called from memory
allocation path...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c     |    6 +++---
 fs/fat/file.c    |   10 +++++-----
 fs/fat/inode.c   |   16 ++++++++--------
 fs/msdos/namei.c |   28 ++++++++++++++--------------
 fs/vfat/namei.c  |   32 ++++++++++++++++----------------
 5 files changed, 46 insertions(+), 46 deletions(-)

diff -puN fs/fat/dir.c~fat_kill-bkl fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_kill-bkl	2008-04-23 04:40:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-04-23 04:40:10.000000000 +0900
@@ -18,7 +18,7 @@
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
 #include <linux/dirent.h>
-#include <linux/smp_lock.h>
+//#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
 #include <asm/uaccess.h>
@@ -472,7 +472,7 @@ static int __fat_readdir(struct inode *i
 	loff_t cpos;
 	int ret = 0;
 
-	lock_kernel();
+//	lock_kernel();
 
 	cpos = filp->f_pos;
 	/* Fake . and .. for the root directory. */
@@ -654,7 +654,7 @@ FillFailed:
 	if (unicode)
 		__putname(unicode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return ret;
 }
 
diff -puN fs/fat/file.c~fat_kill-bkl fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_kill-bkl	2008-04-23 04:40:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-04-23 04:40:10.000000000 +0900
@@ -11,7 +11,7 @@
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/smp_lock.h>
+//#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
@@ -244,9 +244,9 @@ void fat_truncate(struct inode *inode)
 
 	nr_clusters = (inode->i_size + (cluster_size - 1)) >> sbi->cluster_bits;
 
-	lock_kernel();
+//	lock_kernel();
 	fat_free(inode, nr_clusters);
-	unlock_kernel();
+//	unlock_kernel();
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 	fs_mark_flush(sb);
 }
@@ -305,7 +305,7 @@ int fat_setattr(struct dentry *dentry, s
 	int mask, error = 0;
 	unsigned int ia_valid;
 
-	lock_kernel();
+//	lock_kernel();
 
 	/*
 	 * Expand the file. Since inode_setattr() updates ->i_size
@@ -359,7 +359,7 @@ int fat_setattr(struct dentry *dentry, s
 		mask = sbi->options.fs_fmask;
 	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return error;
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
diff -puN fs/fat/inode.c~fat_kill-bkl fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_kill-bkl	2008-04-23 04:40:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-04-23 04:40:10.000000000 +0900
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+//#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/msdos_fs.h>
 #include <linux/pagemap.h>
@@ -442,12 +442,12 @@ static void fat_clear_inode(struct inode
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 
-	lock_kernel();
+//	lock_kernel();
 	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
 	spin_unlock(&sbi->inode_hash_lock);
-	unlock_kernel();
+//	unlock_kernel();
 }
 
 static void fat_write_super(struct super_block *sb)
@@ -567,7 +567,7 @@ retry:
 	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
 		return 0;
 
-	lock_kernel();
+//	lock_kernel();
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
 		printk(KERN_ERR "FAT: unable to read inode block "
@@ -579,7 +579,7 @@ retry:
 	if (i_pos != MSDOS_I(inode)->i_pos) {
 		spin_unlock(&sbi->inode_hash_lock);
 		brelse(bh);
-		unlock_kernel();
+//		unlock_kernel();
 		goto retry;
 	}
 
@@ -606,7 +606,7 @@ retry:
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return err;
 }
 
@@ -743,7 +743,7 @@ static struct dentry *fat_get_parent(str
 	struct inode *inode;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
 	if (err) {
@@ -762,7 +762,7 @@ static struct dentry *fat_get_parent(str
 		parent = ERR_PTR(-ENOMEM);
 	}
 out:
-	unlock_kernel();
+//	unlock_kernel();
 
 	return parent;
 }
diff -puN fs/msdos/namei.c~fat_kill-bkl fs/msdos/namei.c
--- linux-2.6/fs/msdos/namei.c~fat_kill-bkl	2008-04-23 04:40:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/msdos/namei.c	2008-04-23 04:40:10.000000000 +0900
@@ -10,7 +10,7 @@
 #include <linux/time.h>
 #include <linux/buffer_head.h>
 #include <linux/msdos_fs.h>
-#include <linux/smp_lock.h>
+//#include <linux/smp_lock.h>
 
 /* Characters that are undesirable in an MS-DOS file name */
 static unsigned char bad_chars[] = "*?<>|\"";
@@ -214,7 +214,7 @@ static struct dentry *msdos_lookup(struc
 
 	dentry->d_op = &msdos_dentry_operations;
 
-	lock_kernel();
+//	lock_kernel();
 	res = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (res == -ENOENT)
 		goto add;
@@ -232,7 +232,7 @@ add:
 	if (dentry)
 		dentry->d_op = &msdos_dentry_operations;
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	if (!res)
 		return dentry;
 	return ERR_PTR(res);
@@ -286,7 +286,7 @@ static int msdos_create(struct inode *di
 	unsigned char msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -315,7 +315,7 @@ static int msdos_create(struct inode *di
 
 	d_instantiate(dentry, inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	if (!err)
 		err = fat_flush_inodes(sb, dir, inode);
 	return err;
@@ -328,7 +328,7 @@ static int msdos_rmdir(struct inode *dir
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 	/*
 	 * Check whether the directory is not in use, then check
 	 * whether it is empty.
@@ -349,7 +349,7 @@ static int msdos_rmdir(struct inode *dir
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	if (!err)
 		err = fat_flush_inodes(inode->i_sb, dir, inode);
 
@@ -366,7 +366,7 @@ static int msdos_mkdir(struct inode *dir
 	struct timespec ts;
 	int err, is_hid, cluster;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = msdos_format_name(dentry->d_name.name, dentry->d_name.len,
 				msdos_name, &MSDOS_SB(sb)->options);
@@ -404,14 +404,14 @@ static int msdos_mkdir(struct inode *dir
 
 	d_instantiate(dentry, inode);
 
-	unlock_kernel();
+//	unlock_kernel();
 	fat_flush_inodes(sb, dir, inode);
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return err;
 }
 
@@ -422,7 +422,7 @@ static int msdos_unlink(struct inode *di
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
 	if (err)
 		goto out;
@@ -434,7 +434,7 @@ static int msdos_unlink(struct inode *di
 	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	if (!err)
 		err = fat_flush_inodes(inode->i_sb, dir, inode);
 
@@ -621,7 +621,7 @@ static int msdos_rename(struct inode *ol
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = msdos_format_name(old_dentry->d_name.name,
 				old_dentry->d_name.len, old_msdos_name,
@@ -640,7 +640,7 @@ static int msdos_rename(struct inode *ol
 	err = do_msdos_rename(old_dir, old_msdos_name, old_dentry,
 			      new_dir, new_msdos_name, new_dentry, is_hid);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	if (!err)
 		err = fat_flush_inodes(old_dir->i_sb, old_dir, new_dir);
 	return err;
diff -puN fs/vfat/namei.c~fat_kill-bkl fs/vfat/namei.c
--- linux-2.6/fs/vfat/namei.c~fat_kill-bkl	2008-04-23 04:40:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/vfat/namei.c	2008-04-23 04:40:10.000000000 +0900
@@ -21,7 +21,7 @@
 #include <linux/msdos_fs.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+//#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
 
@@ -687,7 +687,7 @@ static struct dentry *vfat_lookup(struct
 	struct dentry *alias;
 	int err, table;
 
-	lock_kernel();
+//	lock_kernel();
 	table = (MSDOS_SB(sb)->options.name_check == 's') ? 2 : 0;
 	dentry->d_op = &vfat_dentry_ops[table];
 
@@ -699,7 +699,7 @@ static struct dentry *vfat_lookup(struct
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		unlock_kernel();
+//		unlock_kernel();
 		return ERR_CAST(inode);
 	}
 	alias = d_find_alias(inode);
@@ -708,13 +708,13 @@ static struct dentry *vfat_lookup(struct
 			dput(alias);
 		else {
 			iput(inode);
-			unlock_kernel();
+//			unlock_kernel();
 			return alias;
 		}
 
 	}
 error:
-	unlock_kernel();
+//	unlock_kernel();
 	dentry->d_op = &vfat_dentry_ops[table];
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
@@ -734,7 +734,7 @@ static int vfat_create(struct inode *dir
 	struct timespec ts;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 
 	ts = CURRENT_TIME_SEC;
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
@@ -755,7 +755,7 @@ static int vfat_create(struct inode *dir
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return err;
 }
 
@@ -765,7 +765,7 @@ static int vfat_rmdir(struct inode *dir,
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = fat_dir_empty(inode);
 	if (err)
@@ -783,7 +783,7 @@ static int vfat_rmdir(struct inode *dir,
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 
 	return err;
 }
@@ -794,7 +794,7 @@ static int vfat_unlink(struct inode *dir
 	struct fat_slot_info sinfo;
 	int err;
 
-	lock_kernel();
+//	lock_kernel();
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err)
@@ -807,7 +807,7 @@ static int vfat_unlink(struct inode *dir
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 
 	return err;
 }
@@ -820,7 +820,7 @@ static int vfat_mkdir(struct inode *dir,
 	struct timespec ts;
 	int err, cluster;
 
-	lock_kernel();
+//	lock_kernel();
 
 	ts = CURRENT_TIME_SEC;
 	cluster = fat_alloc_new_dir(dir, &ts);
@@ -849,13 +849,13 @@ static int vfat_mkdir(struct inode *dir,
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
-	unlock_kernel();
+//	unlock_kernel();
 	return 0;
 
 out_free:
 	fat_free_clusters(dir, cluster);
 out:
-	unlock_kernel();
+//	unlock_kernel();
 	return err;
 }
 
@@ -873,7 +873,7 @@ static int vfat_rename(struct inode *old
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
-	lock_kernel();
+//	lock_kernel();
 	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo);
 	if (err)
 		goto out;
@@ -951,7 +951,7 @@ out:
 	brelse(sinfo.bh);
 	brelse(dotdot_bh);
 	brelse(old_sinfo.bh);
-	unlock_kernel();
+//	unlock_kernel();
 
 	return err;
 
_
