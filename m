Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXIXUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXIXUEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXIXUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:04:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38852 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbXIXUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:04:03 -0400
Subject: [PATCH] ext2 reservations: fix for r/o bind mounts: take-writer-count
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, mbligh@mbligh.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 24 Sep 2007 13:03:57 -0700
Message-Id: <20070924200357.1FAD17C2@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is on top of the ext2-reservations.patch in -mm.

The original r/o bind mount set didn't address the new
ext2 ioctl: EXT2_IOC_SETRSVSZ, because it doesn't exist
in mainline.  This fixes that up for -mm.  

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/ext2/ioctl.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/ext2/ioctl.c~ext2-reservations-take-writer-count fs/ext2/ioctl.c
--- lxc/fs/ext2/ioctl.c~ext2-reservations-take-writer-count	2007-09-24 11:00:18.000000000 -0700
+++ lxc-dave/fs/ext2/ioctl.c	2007-09-24 11:07:08.000000000 -0700
@@ -107,18 +107,21 @@ setflags_out:
 		}
 		return -ENOTTY;
 	case EXT2_IOC_SETRSVSZ: {
-
+		int ret;
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
 
+		ret = -EACCES;
 		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
+			goto setrsvsz_out;
 
+		ret = -EFAULT;
 		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+			goto setrsvsz_out;
 
 		if (rsv_window_size > EXT2_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT2_MAX_RESERVE_BLOCKS;
@@ -140,7 +143,9 @@ setflags_out:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+	setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/namespace.c~ext2-reservations-take-writer-count fs/namespace.c
_
