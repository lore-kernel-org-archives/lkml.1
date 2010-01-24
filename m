Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0AXLl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0AXLl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 06:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078Ab0AXLlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 06:41:21 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38808 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0AXLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 06:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=POqHdTxVlcw6M6n52G/mK7c9EUa8i4KsgMo84igBuDZbM8CP0RZpXeQM6AIblW6H3j
         GAgD73DeagP9Mn3o1wQpoLKsZJgmx0EthOWbVnrDm7NEJYfTGw3W3/iGKSj1/VpmtVbY
         L55YVJNzDiDUl2EaqmpOy6wpjdwvWjjqV1TzQ=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
Date: Sun, 24 Jan 2010 14:41:15 +0300
Message-ID: <87sk9vd92c.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Currently on rw=>ro remount we have following race
| mount /mnt -oremount,ro | write-task |
|-------------------------+------------|
|                         | open(RDWR) |
| shrink_dcache_sb(sb);   |            |
| sync_filesystem(sb);    |            |
|                         | write()    |
|                         | close()    |
| fs_may_remount_ro(sb)   |            |
| sb->s_flags = new_flags |            |
Later writeback or sync() will result in error due to MS_RDONLY flag
In case of ext4 this result in jbd2_start failure on writeback
ext4_da_writepages: jbd2_start: 1024 pages, ino 1431; err -30 
In fact all others are affected by this error but it is not visible
because the skip s_flags check on writeback. For example ext3 check
(s_flags & MS_RDONLY) only if page has no buffers during journal start.

In order to prevent the race we have to block new writers before
fs_may_remount_ro() and sync_filesystem(). Let's introduce new
sb->s_flags MS_RO_REMOUNT flag for this purpose. But suddenly we have
no available space in MS_XXX bits, let's share this bit with MS_REMOUNT.
This is possible because MS_REMOUNT used only for passing arguments
from flags to sys_mount() and never used in sb->s_flags.

##TESTCASE_BEGIN:
#! /bin/bash -x 
DEV=/dev/sdb5
FSTYPE=ext4
BINDIR=/home/dmon
MNTOPT="data=ordered"
umount /mnt
mkfs.${FSTYPE}  ${DEV} || exit 1
mount  ${DEV} /mnt -o${MNTOPT} || exit 1
${BINDIR}/fsstress -p1 -l999999999 -n9999999999 -d /mnt/test &
sleep 15
mount /mnt -oremount,ro,${MNTOPT}
sleep 1
killall -9 fsstress
sync
# after this you may get following message in dmesg
# "ext4_da_writepages: jbd2_start: 1024 pages, ino 1431; err -30"
##TESTCASE_END

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
--

--=-=-=
Content-Disposition: inline; filename=patch

diff --git a/fs/namespace.c b/fs/namespace.c
index c768f73..a216fb3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -194,7 +194,7 @@ int __mnt_is_readonly(struct vfsmount *mnt)
 {
 	if (mnt->mnt_flags & MNT_READONLY)
 		return 1;
-	if (mnt->mnt_sb->s_flags & MS_RDONLY)
+	if (mnt->mnt_sb->s_flags & (MS_RDONLY| MS_RO_REMOUNT))
 		return 1;
 	return 0;
 }
diff --git a/fs/super.c b/fs/super.c
index aff046b..756fe88 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -569,42 +569,51 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
 	int retval;
 	int remount_rw;
+	int remount_ro;
 
 	if (sb->s_frozen != SB_UNFROZEN)
 		return -EBUSY;
-
+	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
 		return -EACCES;
 #endif
-
 	if (flags & MS_RDONLY)
 		acct_auto_close(sb);
-	shrink_dcache_sb(sb);
-	sync_filesystem(sb);
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	retval = -EBUSY;
+	if (remount_ro) {
+		/* Prevent new writers before check */
+		sb->s_flags |= MS_RO_REMOUNT;
 		if (force)
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+			goto out;
+	}
+	shrink_dcache_sb(sb);
+	sync_filesystem(sb);
+
+	if (remount_ro) {
 		retval = vfs_dq_off(sb, 1);
 		if (retval < 0 && retval != -ENOSYS)
-			return -EBUSY;
+			goto out;
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		if (retval)
-			return retval;
+			goto out;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
 		vfs_dq_quota_on_remount(sb);
-	return 0;
+out:
+	if (remount_ro)
+		sb->s_flags = (sb->s_flags & ~MS_RO_REMOUNT);
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1bcb27..a613875 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -208,6 +208,9 @@ struct inodes_stat_t {
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
+#define MS_RO_REMOUNT	MS_REMOUNT /* Alter flags from rw=>ro of mounted FS.
+				      Not conflicting with MS_REMOUNT because
+				      it never stored in sb->s_flags */
 
 /*
  * Superblock flags that can be altered by MS_REMOUNT

--=-=-=--
