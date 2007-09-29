Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbXI2KMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbXI2KMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXI2KMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:12:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:28132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXI2KME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=OL1EkPZ/ECU4KsA0NptE5jRaoZIJ6vzf/kyNx5LjCnC6uF/v5NH7/bFVHtL+ZzEkNrgnDdd6nHRqBJKKJmvhx4SUFJkLvwihbHIbZwwBBdbKBk9FtlqoeISAxenVi1t1x1jSGorXsOzLzj0wjTmAkB5uruopy3/98Dg/TvPgMhI=
Date: Sat, 29 Sep 2007 19:09:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, Tim Shimmin <xfs-masters@oss.sgi.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update sb->s_frozen when freezing read-only mounted device, too
Message-ID: <20070929100912.GB4121@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Tim Shimmin <xfs-masters@oss.sgi.com>,
	Christoph Hellwig <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

freeze_bdev() with the device which is mounted as read only
does not change sb->s_frozen from SB_UNFROZEN to SB_FREEZE_TRANS.

Because of this behavior, xfs_freeze can break read-only XFS filesystem.

Because xfs_thaw does nothing for the filesystem whose sb->s_frozen is
SB_UNFROZEN. So freezed readonly XFS filesystem will never be unfreezed.
Then we cannot do any unmount/remount operations for that filesystem.

This patch updates sb->s_frozen when freeze_bdev() is called for read-only
mounted device, too.

Cc:  Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/buffer.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: 2.6-git/fs/buffer.c
===================================================================
--- 2.6-git.orig/fs/buffer.c
+++ 2.6-git/fs/buffer.c
@@ -190,19 +190,22 @@ struct super_block *freeze_bdev(struct b
 
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
-	if (sb && !(sb->s_flags & MS_RDONLY)) {
+	if (sb) {
 		sb->s_frozen = SB_FREEZE_WRITE;
 		smp_wmb();
 
-		__fsync_super(sb);
+		if (!(sb->s_flags & MS_RDONLY))
+			__fsync_super(sb);
 
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
 
-		sync_blockdev(sb->s_bdev);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->write_super_lockfs)
-			sb->s_op->write_super_lockfs(sb);
+			if (sb->s_op->write_super_lockfs)
+				sb->s_op->write_super_lockfs(sb);
+		}
 	}
 
 	sync_blockdev(bdev);
