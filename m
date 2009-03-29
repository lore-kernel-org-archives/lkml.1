Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZC2RbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZC2RbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZC2RaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:30:18 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56273 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZC2RaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kbp29FvDX3pdL46pCj07QjlviG7J+CLjDSbZEeLNulmimbm7ajo+KAKHmwWDn4ySqp
         FA1pXP4wIDhAETHGnJv3nE30IMRug+zevLIroNkEVS+iQ7dYSN5Yjcq1x4Tm0iEgB+sF
         vzUQgSMumvuKh1iDUOHTwHO+GnY8fd80aV8I8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: xfs-masters@oss.sgi.com
Subject: [PATCH] xfs: fix blkdev_issue_flush() failure handling
Date: Sun, 29 Mar 2009 19:31:03 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291931.03775.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
command execution) so its users should check for the return value.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/xfs/linux-2.6/xfs_buf.c   |    1 +
 fs/xfs/linux-2.6/xfs_super.c |    4 ++--
 fs/xfs/linux-2.6/xfs_super.h |    2 +-
 fs/xfs/xfs_vnodeops.c        |   19 +++++++++++++++----
 4 files changed, 19 insertions(+), 7 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1446,6 +1446,7 @@ xfs_free_buftarg(
 {
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		/* FIXME: check return value */
 		xfs_blkdev_issue_flush(btp);
 	xfs_free_bufhash(btp);
 	iput(btp->bt_mapping->host);
Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -721,11 +721,11 @@ xfs_mountfs_check_barriers(xfs_mount_t *
 	}
 }
 
-void
+int
 xfs_blkdev_issue_flush(
 	xfs_buftarg_t		*buftarg)
 {
-	blkdev_issue_flush(buftarg->bt_bdev, NULL);
+	return blkdev_issue_flush(buftarg->bt_bdev, NULL);
 }
 
 STATIC void
Index: b/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.h
+++ b/fs/xfs/linux-2.6/xfs_super.h
@@ -89,7 +89,7 @@ struct block_device;
 
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
+extern int xfs_blkdev_issue_flush(struct xfs_buftarg *);
 
 extern const struct export_operations xfs_export_operations;
 extern struct xattr_handler *xfs_xattr_handlers[];
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -597,6 +597,7 @@ xfs_fsync(
 	xfs_trans_t	*tp;
 	int		error;
 	int		log_flushed = 0, changed = 1;
+	int		tmp_ret;
 
 	xfs_itrace_entry(ip);
 
@@ -679,19 +680,29 @@ xfs_fsync(
 	}
 
 	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
+		xfs_buftarg_t *btp;
+
 		/*
 		 * If the log write didn't issue an ordered tag we need
 		 * to flush the disk cache for the data device now.
 		 */
-		if (!log_flushed)
-			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
+		if (!log_flushed) {
+			btp = ip->i_mount->m_ddev_targp;
+			tmp_ret = xfs_blkdev_issue_flush(btp);
+			if (error == 0 && tmp_ret < 0 && tmp_ret != -EOPNOTSUPP)
+				error = tmp_ret;
+		}
 
 		/*
 		 * If this inode is on the RT dev we need to flush that
 		 * cache as well.
 		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			btp = ip->i_mount->m_rtdev_targp;
+			tmp_ret = xfs_blkdev_issue_flush(btp);
+			if (error == 0 && tmp_ret < 0 && tmp_ret != -EOPNOTSUPP)
+				error = tmp_ret;
+		}
 	}
 
 	return error;
