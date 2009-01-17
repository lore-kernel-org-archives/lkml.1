Return-Path: <linux-kernel-owner+w=401wt.eu-S938065AbZAQCct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938065AbZAQCct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbZAQCaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:30:06 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146AbZAQCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:30:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=VKp8HlEq8ErkkndK/OC7WlQDPThoS9XFZXzB2GApTuqTek7f2A7wunoR4jFSs5fad
	onZ4swDlBoFGuQLp6ePbA==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 4/8] Fixing iput() called from put_super path
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:29:57 -0800
Message-ID: <20090117022957.20425.52953.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.73
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delaying iput introduces a problem when it comes to unmounting.  The problem
lies in fs-specific put_super callbacks that will issue iput()s and assume that
the iputs on their final inodes (for metadata inodes and the like) which causes
problems with deferred iput() as the super_block may go away before the inodes
are finalized.

This patch goes and marks all inodes in a super_block whenever we see that the
inodes are being invalidated with S_SYNCIPUT, which causes us to shortcircuit
the deferred iput and perform a synchronous iput.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/block_dev.c       |    2 +-
 fs/ext2/super.c      |    2 +-
 fs/gfs2/glock.c      |    2 +-
 fs/gfs2/ops_fstype.c |    2 +-
 fs/inode.c           |   19 ++++++++++++++-----
 fs/ntfs/super.c      |    2 +-
 fs/smbfs/inode.c     |    2 +-
 fs/super.c           |    4 ++--
 include/linux/fs.h   |    3 ++-
 9 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index b3c1eff..eb6517e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1400,7 +1400,7 @@ int __invalidate_device(struct block_device *bdev)
 		 * hold).
 		 */
 		shrink_dcache_sb(sb);
-		res = invalidate_inodes(sb);
+		res = invalidate_inodes(sb, 1);
 		drop_super(sb);
 	}
 	invalidate_bdev(bdev);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index da8bdea..190dfc9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1185,7 +1185,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	es = sbi->s_es;
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
-	    invalidate_inodes(sb))
+	    invalidate_inodes(sb, 0))
 		ext2_warning(sb, __func__, "busy inodes while remounting "\
 			     "xip remain in cache (no functional problem)");
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6b983ae..4d95373 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1574,7 +1574,7 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 		}
 
 		down_write(&gfs2_umount_flush_sem);
-		invalidate_inodes(sdp->sd_vfs);
+		invalidate_inodes(sdp->sd_vfs, 1);
 		up_write(&gfs2_umount_flush_sem);
 		msleep(10);
 	}
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index f91eebd..5099ca5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1205,7 +1205,7 @@ fail_locking:
 fail_lm:
 	gfs2_gl_hash_clear(sdp);
 	gfs2_lm_unmount(sdp);
-	while (invalidate_inodes(sb))
+	while (invalidate_inodes(sb, 1))
 		yield();
 fail_sys:
 	gfs2_sys_fs_del(sdp);
diff --git a/fs/inode.c b/fs/inode.c
index 56cf6e2..9aa574d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -335,7 +335,8 @@ static void dispose_list(struct list_head *head)
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct list_head *head, struct list_head *dispose)
+static int invalidate_list(struct list_head *head, struct list_head *dispose,
+			   int umount)
 {
 	struct list_head *next;
 	int busy = 0, count = 0;
@@ -358,6 +359,8 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			break;
 		inode = list_entry(tmp, struct inode, i_sb_list);
 		invalidate_inode_buffers(inode);
+		if (umount)
+			inode->i_flags |= S_SYNCIPUT;
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
 			inode->i_state |= I_FREEING;
@@ -374,12 +377,13 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 /**
  *	invalidate_inodes	- discard the inodes on a device
  *	@sb: superblock
+ *	@umount: are we unmounting?
  *
  *	Discard all of the inodes for a given superblock. If the discard
  *	fails because there are busy inodes then a non zero value is returned.
  *	If the discard is successful all the inodes have been discarded.
  */
-int invalidate_inodes(struct super_block * sb)
+int invalidate_inodes(struct super_block *sb, int umount)
 {
 	int busy;
 	LIST_HEAD(throw_away);
@@ -394,7 +398,7 @@ int invalidate_inodes(struct super_block * sb)
 
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	busy = invalidate_list(&sb->s_inodes, &throw_away, umount);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -1372,8 +1376,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-		if (!atomic_add_unless(&inode->i_count, -1, 1))
-			postpone_iput(inode);
+		if (!(inode->i_flags & S_SYNCIPUT)) {
+			if (!atomic_add_unless(&inode->i_count, -1, 1))
+				postpone_iput(inode);
+		} else {
+			real_iput(inode);
+		}
 	}
 }
 
@@ -1663,6 +1671,7 @@ static void iput_drain_per_cpu_cb(struct work_struct *dummy)
 
 void iput_drain_all(void)
 {
+	/* TODO: error checking? */
 	schedule_on_each_cpu(iput_drain_per_cpu_cb);
 }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 4a46743..04220f3 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3051,7 +3051,7 @@ iput_tmp_ino_err_out_now:
 	 * method again... FIXME: Do we need to do this twice now because of
 	 * attribute inodes? I think not, so leave as is for now... (AIA)
 	 */
-	if (invalidate_inodes(sb)) {
+	if (invalidate_inodes(sb, 1)) {
 		ntfs_error(sb, "Busy inodes left. This is most likely a NTFS "
 				"driver bug.");
 		/* Copied from fs/super.c. I just love this message. (-; */
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index fc27fbf..4def57a 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -229,7 +229,7 @@ smb_invalidate_inodes(struct smb_sb_info *server)
 {
 	VERBOSE("\n");
 	shrink_dcache_sb(SB_of(server));
-	invalidate_inodes(SB_of(server));
+	invalidate_inodes(SB_of(server), 1);
 }
 
 /*
diff --git a/fs/super.c b/fs/super.c
index 534840f..244b6f5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -306,7 +306,7 @@ void generic_shutdown_super(struct super_block *sb)
 		async_synchronize_full_special(&sb->s_async_list);
 
 		/* bad name - it should be evict_inodes() */
-		invalidate_inodes(sb);
+		invalidate_inodes(sb, 1);
 		lock_kernel();
 
 		if (sop->write_super && sb->s_dirt)
@@ -315,7 +315,7 @@ void generic_shutdown_super(struct super_block *sb)
 			sop->put_super(sb);
 
 		/* Forget any remaining inodes */
-		if (invalidate_inodes(sb)) {
+		if (invalidate_inodes(sb, 1)) {
 			printk("VFS: Busy inodes after unmount of %s. "
 			   "Self-destruct in 5 seconds.  Have a nice day...\n",
 			   sb->s_id);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 47eaa71..aa90620 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -161,6 +161,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_SYNCIPUT	1024	/* Filesystem going down, use sync iput() */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1805,7 +1806,7 @@ extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
-extern int invalidate_inodes(struct super_block *);
+extern int invalidate_inodes(struct super_block *, int umount);
 unsigned long __invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end,
 					bool be_atomic);

