Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbYBHWi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbYBHWi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbYBHW1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46384 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbYBHW1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:23 -0500
Subject: [RFC][PATCH 24/30] r/o bind mounts: elevate count for xfs timestamp updates
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:19 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222719.CDC6F2B1@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the xfs m/ctime updates.

XFS has to do it's own timestamp updates due to an unfortunate VFS
design limitation, so it will have to track writers by itself aswell.

[hch: split out from the touch_atime patch as it's not related to it at all]

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_iops.c |    7 -------
 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_lrw.c  |    9 ++++++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates fs/xfs/linux-2.6/xfs_iops.c
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates	2008-02-08 13:04:58.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_iops.c	2008-02-08 13:04:58.000000000 -0800
@@ -157,13 +157,6 @@ xfs_ichgtime_fast(
 	 */
 	ASSERT((flags & XFS_ICHGTIME_ACC) == 0);
 
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (unlikely(IS_RDONLY(inode)))
-		return;
-
 	if (flags & XFS_ICHGTIME_MOD) {
 		tvp = &inode->i_mtime;
 		ip->i_d.di_mtime.t_sec = (__int32_t)tvp->tv_sec;
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates fs/xfs/linux-2.6/xfs_lrw.c
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates	2008-02-08 13:04:58.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-08 13:04:58.000000000 -0800
@@ -51,6 +51,7 @@
 #include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
+#include <linux/mount.h>
 #include <linux/writeback.h>
 
 
@@ -679,10 +680,16 @@ start:
 	if (new_size > xip->i_size)
 		xip->i_new_size = new_size;
 
-	if (likely(!(ioflags & IO_INVIS))) {
+	/*
+	 * We're not supposed to change timestamps in readonly-mounted
+	 * filesystems.  Throw it away if anyone asks us.
+	 */
+	if (likely(!(ioflags & IO_INVIS) &&
+		   !mnt_want_write(file->f_vfsmnt))) {
 		file_update_time(file);
 		xfs_ichgtime_fast(xip, inode,
 				  XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		mnt_drop_write(file->f_vfsmnt);
 	}
 
 	/*
_
