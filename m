Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZC3Md3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZC3Md3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZC3MdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:33:18 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53956 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZC3MdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:33:17 -0400
Message-ID: <49D0BC0A.9050909@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 21:33:14 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org,
       bzolnier@gmail.com
Subject: [PATCH 6/7] xfs: propagate issue-flush error code
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>
In-Reply-To: <49D0B535.2010106@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
command execution) so its users should check for the return value.

(This issues was first spotted Bartlomiej Zolnierkiewicz)

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_buf.c linux-2.6.29/fs/xfs/linux-2.6/xfs_buf.c
--- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_buf.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/xfs/linux-2.6/xfs_buf.c	2009-03-30 14:44:34.000000000 +0900
@@ -1446,6 +1446,7 @@ xfs_free_buftarg(
  {
  	xfs_flush_buftarg(btp, 1);
  	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		/* FIXME: check return value */
  		xfs_blkdev_issue_flush(btp);
  	xfs_free_bufhash(btp);
  	iput(btp->bt_mapping->host);
diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.c linux-2.6.29/fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/xfs/linux-2.6/xfs_super.c	2009-03-30 15:16:42.000000000 +0900
@@ -721,11 +721,11 @@ xfs_mountfs_check_barriers(xfs_mount_t *
  	}
  }

-void
+int
  xfs_blkdev_issue_flush(
  	xfs_buftarg_t		*buftarg)
  {
-	blkdev_issue_flush(buftarg->bt_bdev, NULL);
+	return block_flush_device(buftarg->bt_bdev);
  }

  STATIC void
diff -urNp linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.h linux-2.6.29/fs/xfs/linux-2.6/xfs_super.h
--- linux-2.6.29-orig/fs/xfs/linux-2.6/xfs_super.h	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/xfs/linux-2.6/xfs_super.h	2009-03-30 14:46:31.000000000 +0900
@@ -89,7 +89,7 @@ struct block_device;

  extern __uint64_t xfs_max_file_offset(unsigned int);

-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
+extern int xfs_blkdev_issue_flush(struct xfs_buftarg *);

  extern const struct export_operations xfs_export_operations;
  extern struct xattr_handler *xfs_xattr_handlers[];
diff -urNp linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c linux-2.6.29/fs/xfs/xfs_vnodeops.c
--- linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/xfs/xfs_vnodeops.c	2009-03-30 15:08:21.000000000 +0900
@@ -678,20 +678,20 @@ xfs_fsync(
  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
  	}

-	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
+	if (!error && (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
  		/*
  		 * If the log write didn't issue an ordered tag we need
  		 * to flush the disk cache for the data device now.
  		 */
  		if (!log_flushed)
-			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
+			error = xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);

  		/*
  		 * If this inode is on the RT dev we need to flush that
  		 * cache as well.
  		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
+		if (!error && XFS_IS_REALTIME_INODE(ip))
+			error = xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
  	}

  	return error;
