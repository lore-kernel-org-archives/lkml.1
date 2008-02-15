Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbYBOWuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbYBOWuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbYBOWiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60709 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765604AbYBOWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:57 -0500
Subject: [PATCH 24/30] r/o bind mounts: elevate count for xfs timestamp updates
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:53 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223753.042AF601@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the xfs m/ctime updates.

XFS has to do it's own timestamp updates due to an unfortunate VFS
design limitation, so it will have to track writers by itself aswell.

[hch: split out from the touch_atime patch as it's not related to it at all]

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_iops.c |    7 -------
 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_lrw.c  |    9 ++++++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates fs/xfs/linux-2.6/xfs_iops.c
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates	2008-02-15 13:25:56.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_iops.c	2008-02-15 13:25:56.000000000 -0800
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
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-elevate-writer-count-for-xfs-timestamp-updates	2008-02-15 13:25:56.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-15 13:25:56.000000000 -0800
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
