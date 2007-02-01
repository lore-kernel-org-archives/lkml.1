Return-Path: <linux-kernel-owner+w=401wt.eu-S1422798AbXBALOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422798AbXBALOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422801AbXBALOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:14:40 -0500
Received: from mail.alkar.net ([195.248.191.95]:58109 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422806AbXBALNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:13:51 -0500
From: "Vladimir V. Saveliev" <vs@namesys.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: How many people are using 2.6.16?
Date: Thu, 1 Feb 2007 15:13:03 +0300
User-Agent: KMail/1.8.2
Cc: reiserfs-dev@namesys.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <45BE5948.6060403@redhat.com> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org> <20070131070237.GT3754@stusta.de>
In-Reply-To: <20070131070237.GT3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011513.04627.vs@namesys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Wednesday 31 January 2007 10:02, Adrian Bunk wrote:
> On Tue, Jan 30, 2007 at 06:36:48PM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 30 Jan 2007, Mark Lord wrote:
> > > 
> > > I believe our featherless leader said he though it was an ancient bug,
> > > exasperated by something that went into 2.6.19.
> > > 
> > > If Linus's opinion is correct (still?), then the bug exists in all
> > > kernels since somewhere back in the 2.4.xx days.
> > 
> > The issue was somewhat confused by people certainly *reporting* it for 
> > older kernels. Also, as part of the dirty bit cleanups and sanity 
> > checkingwe did actually seem to fix a long-standing CIFS corruption (and 
> > apparently reisertfs/XFS problems too).
> > 
> > But the *common* case was actually introduced with 2.6.19, and 2.6.16 
> > wouldn't be affected. 
> 
> Thanks for the clarifications.
> 
> Regarding the longstanding CIFS/reiserfs/XFS problems, it seems the 
> status is:
> 
> CIFS:
> commit cb876f451455b6187a7d69de2c112c45ec4b7f99
>   Fix up CIFS for "test_clear_page_dirty()" removal
> queued for 2.6.19.3
> applies and compiles against 2.6.16
> 
> reiserfs:
> commit de14569f94513279e3d44d9571a421e9da1759ae
>   [PATCH] resierfs: avoid tail packing if an inode was ever mmapped
> backport to 2.6.16 required
> 

Here it goes:

From: akpm@osdl.org

The patch titled
     resierfs: avoid tail packing if an inode was ever mmapped
has been added to the -mm tree.  Its filename is
     reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: resierfs: avoid tail packing if an inode was ever mmapped
From: Vladimir Saveliev <vs@namesys.com>

This patch fixes a confusion reiserfs has for a long time.

On release file operation reiserfs used to try to pack file data stored in
last incomplete page of some files into metadata blocks.  After packing the
page got cleared with clear_page_dirty.  It did not take into account that
the page may be mmaped into other process's address space.  Recent
replacement for clear_page_dirty cancel_dirty_page found the confusion with
sanity check that page has to be not mapped.

The patch fixes the confusion by making reiserfs avoid tail packing if an
inode was ever mmapped.  reiserfs_mmap and reiserfs_file_release are
serialized with mutex in reiserfs specific inode.  reiserfs_mmap locks the
mutex and sets a bit in reiserfs specific inode flags. 
reiserfs_file_release checks the bit having the mutex locked.  If bit is
set - tail packing is avoided.  This eliminates a possibility that mmapped
page gets cancel_page_dirty-ed.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <mason@suse.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

diff -puN fs/reiserfs/file.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped fs/reiserfs/file.c



diff -puN fs/reiserfs/file.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped fs/reiserfs/file.c
--- linux-2.6.16/fs/reiserfs/file.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped	2007-02-01 12:30:08.000000000 +0300
+++ linux-2.6.16-vs/fs/reiserfs/file.c	2007-02-01 12:43:07.000000000 +0300
@@ -50,6 +50,11 @@ static int reiserfs_file_release(struct 
 
 	reiserfs_write_lock(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
+ 
+ 	mutex_lock(&(REISERFS_I(inode)->i_mmap));
+ 	if (REISERFS_I(inode)->i_flags & i_ever_mapped)
+ 		REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
+ 
 	/* freeing preallocation only involves relogging blocks that
 	 * are already in the current transaction.  preallocation gets
 	 * freed at the end of each transaction, so it is impossible for
@@ -100,11 +105,24 @@ static int reiserfs_file_release(struct 
 		err = reiserfs_truncate_file(inode, 0);
 	}
       out:
+	mutex_unlock(&(REISERFS_I(inode)->i_mmap));
 	mutex_unlock(&inode->i_mutex);
 	reiserfs_write_unlock(inode->i_sb);
 	return err;
 }
 
+static int reiserfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	inode = file->f_dentry->d_inode;
+	mutex_lock(&(REISERFS_I(inode)->i_mmap));
+	REISERFS_I(inode)->i_flags |= i_ever_mapped;
+	mutex_unlock(&(REISERFS_I(inode)->i_mmap));
+
+	return generic_file_mmap(file, vma);
+}
+
 static void reiserfs_vfs_truncate_file(struct inode *inode)
 {
 	reiserfs_truncate_file(inode, 1);
@@ -1570,7 +1588,7 @@ struct file_operations reiserfs_file_ope
 	.read = generic_file_read,
 	.write = reiserfs_file_write,
 	.ioctl = reiserfs_ioctl,
-	.mmap = generic_file_mmap,
+	.mmap = reiserfs_file_mmap,
 	.release = reiserfs_file_release,
 	.fsync = reiserfs_sync_file,
 	.sendfile = generic_file_sendfile,
diff -puN fs/reiserfs/inode.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped fs/reiserfs/inode.c
--- linux-2.6.16/fs/reiserfs/inode.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped	2007-02-01 12:30:08.000000000 +0300
+++ linux-2.6.16-vs/fs/reiserfs/inode.c	2007-02-01 12:41:32.000000000 +0300
@@ -1140,6 +1140,7 @@ static void init_inode(struct inode *ino
 	REISERFS_I(inode)->i_prealloc_count = 0;
 	REISERFS_I(inode)->i_trans_id = 0;
 	REISERFS_I(inode)->i_jl = NULL;
+	mutex_init(&(REISERFS_I(inode)->i_mmap));
 	REISERFS_I(inode)->i_acl_access = NULL;
 	REISERFS_I(inode)->i_acl_default = NULL;
 	init_rwsem(&REISERFS_I(inode)->xattr_sem);
@@ -1847,6 +1848,7 @@ int reiserfs_new_inode(struct reiserfs_t
 	REISERFS_I(inode)->i_attrs =
 	    REISERFS_I(dir)->i_attrs & REISERFS_INHERIT_MASK;
 	sd_attrs_to_i_attrs(REISERFS_I(inode)->i_attrs, inode);
+	mutex_init(&(REISERFS_I(inode)->i_mmap));
 	REISERFS_I(inode)->i_acl_access = NULL;
 	REISERFS_I(inode)->i_acl_default = NULL;
 	init_rwsem(&REISERFS_I(inode)->xattr_sem);
diff -puN include/linux/reiserfs_fs_i.h~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped include/linux/reiserfs_fs_i.h
--- linux-2.6.16/include/linux/reiserfs_fs_i.h~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped	2007-02-01 12:30:08.000000000 +0300
+++ linux-2.6.16-vs/include/linux/reiserfs_fs_i.h	2007-02-01 12:35:50.000000000 +0300
@@ -25,6 +25,7 @@ typedef enum {
 	i_link_saved_truncate_mask = 0x0020,
 	i_has_xattr_dir = 0x0040,
 	i_data_log = 0x0080,
+	i_ever_mapped = 0x0100
 } reiserfs_inode_flags;
 
 struct reiserfs_inode_info {
@@ -52,6 +53,7 @@ struct reiserfs_inode_info {
 	 ** flushed */
 	unsigned long i_trans_id;
 	struct reiserfs_journal_list *i_jl;
+	struct mutex i_mmap;
 
 	struct posix_acl *i_acl_access;
 	struct posix_acl *i_acl_default;

_


