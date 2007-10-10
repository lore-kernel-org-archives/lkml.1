Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXJJPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXJJPZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXJJPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:24:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:40819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbXJJPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DeFllw/s5tPRw0dViD9krydVBtNUr0GSGGMMOkB5IfCiTyXzSLGmnRAVi5MmiuVzHfD4+0S0xs5SIztoQSoEVO7gJ61QINj1UDkBdkVA9P4T5AgazXwOU6NPbB/8ZowcYSWn6RXzSrqT42NPZxIgLEno80KMPFc3PWiM4/XmTug=
Date: Thu, 11 Oct 2007 00:20:51 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Tim Shimmin <xfs-masters@oss.sgi.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] update sb->s_frozen when freezing read-only mounted device, too
Message-ID: <20071010152051.GA4059@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Tim Shimmin <xfs-masters@oss.sgi.com>,
	David Chinner <dgc@sgi.com>
References: <20070929100912.GB4121@APFDCB5C> <20071004202004.GA13316@lst.de> <961aa3350710050620q42eb6192wdacce1510cc76a4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350710050620q42eb6192wdacce1510cc76a4b@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

freeze_bdev() with read-only mounted device(*) does not change sb->s_frozen
from SB_UNFROZEN to SB_FREEZE_TRANS.

Because of this behavior, xfs_freeze can break read-only filesystem.

Because xfs_thaw does nothing for the filesystem whose sb->s_frozen is
SB_UNFROZEN. So frozen read-only XFS filesystem will never be unfrozen.
Thus we cannot do any unmount/remount operations for that filesystem.

This patch updates sb->s_frozen when freeze_bdev() is called for read-only
mounted device, too.

(*) freezing read-only filesystem is not so pointless.  Because it can
prevent from someone trying to remount read/write while freezing.

Cc: David Chinner <dgc@sgi.com>
Cc:  Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/buffer.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: 2.6-git/fs/buffer.c
===================================================================
--- 2.6-git.orig/fs/buffer.c
+++ 2.6-git/fs/buffer.c
@@ -190,21 +190,28 @@ struct super_block *freeze_bdev(struct b
 
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
-	if (sb && !(sb->s_flags & MS_RDONLY)) {
-		sb->s_frozen = SB_FREEZE_WRITE;
-		smp_wmb();
-
-		__fsync_super(sb);
+	if (!sb)
+		goto out;
 
+	if (sb->s_flags & MS_RDONLY) {
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
+		goto out;
+	}
 
-		sync_blockdev(sb->s_bdev);
+	sb->s_frozen = SB_FREEZE_WRITE;
+	smp_wmb();
 
-		if (sb->s_op->write_super_lockfs)
-			sb->s_op->write_super_lockfs(sb);
-	}
+	__fsync_super(sb);
+
+	sb->s_frozen = SB_FREEZE_TRANS;
+	smp_wmb();
 
+	sync_blockdev(sb->s_bdev);
+
+	if (sb->s_op->write_super_lockfs)
+		sb->s_op->write_super_lockfs(sb);
+out:
 	sync_blockdev(bdev);
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
