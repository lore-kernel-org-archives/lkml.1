Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbZLKFa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbZLKFa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLKFaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:30:18 -0500
Received: from kroah.org ([198.145.64.141]:53630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbZLKFaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:09 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:58 2009
Message-Id: <20091211052558.272572522@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [33/34] ext4: Fix insufficient checks in EXT4_IOC_MOVE_EXT
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0029-ext4-Fix-insufficient-checks-in-EXT4_IOC_MOVE_EXT.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 4a58579b9e4e2a35d57e6c9c8483e52f6f1b7fd6)

This patch fixes three problems in the handling of the
EXT4_IOC_MOVE_EXT ioctl:

1. In current EXT4_IOC_MOVE_EXT, there are read access mode checks for
original and donor files, but they allow the illegal write access to
donor file, since donor file is overwritten by original file data.  To
fix this problem, change access mode checks of original (r->r/w) and
donor (r->w) files.

2.  Disallow the use of donor files that have a setuid or setgid bits.

3.  Call mnt_want_write() and mnt_drop_write() before and after
ext4_move_extents() calling to get write access to a mount.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ioctl.c       |   30 ++++++++++++++++++------------
 fs/ext4/move_extent.c |    7 +++++++
 2 files changed, 25 insertions(+), 12 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -221,32 +221,38 @@ setversion_out:
 		struct file *donor_filp;
 		int err;
 
+		if (!(filp->f_mode & FMODE_READ) ||
+		    !(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+
 		if (copy_from_user(&me,
 			(struct move_extent __user *)arg, sizeof(me)))
 			return -EFAULT;
+		me.moved_len = 0;
 
 		donor_filp = fget(me.donor_fd);
 		if (!donor_filp)
 			return -EBADF;
 
-		if (!capable(CAP_DAC_OVERRIDE)) {
-			if ((current->real_cred->fsuid != inode->i_uid) ||
-				!(inode->i_mode & S_IRUSR) ||
-				!(donor_filp->f_dentry->d_inode->i_mode &
-				S_IRUSR)) {
-				fput(donor_filp);
-				return -EACCES;
-			}
+		if (!(donor_filp->f_mode & FMODE_WRITE)) {
+			err = -EBADF;
+			goto mext_out;
 		}
 
-		me.moved_len = 0;
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			goto mext_out;
+
 		err = ext4_move_extents(filp, donor_filp, me.orig_start,
 					me.donor_start, me.len, &me.moved_len);
-		fput(donor_filp);
+		mnt_drop_write(filp->f_path.mnt);
+		if (me.moved_len > 0)
+			file_remove_suid(donor_filp);
 
 		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
-			return -EFAULT;
-
+			err = -EFAULT;
+mext_out:
+		fput(donor_filp);
 		return err;
 	}
 
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -957,6 +957,13 @@ mext_check_arguments(struct inode *orig_
 		return -EINVAL;
 	}
 
+	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
+		ext4_debug("ext4 move extent: suid or sgid is set"
+			   " to donor file [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
 	/* Ext4 move extent does not support swapfile */
 	if (IS_SWAPFILE(orig_inode) || IS_SWAPFILE(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should "


