Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbXJFS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbXJFS2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760871AbXJFS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:28:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbXJFS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:28:36 -0400
Message-Id: <20071006182343.694115455@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:10 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 8/9] compat_ioctl: call disk->fops->compat_ioctl without BKL
Content-Disposition: inline; filename=compat-block-ioctl-unlocked.diff
X-Provags-ID: V01U2FsdGVkX18fLOfSJU/arQp6AUmm+oQG2ACUZNh21OTvzIv
 EHvBzUNAoUbJyvmc/3wY0BoYu8C0LcRcwPY0PXhsArLcvJn0Us
 Guof6yQFUYCX2iLSizC1g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, all compat_ioctl operations are called without the BKL, the
block device operations are an exception to this rule.

Make this work the same as the other handlers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
It would be good to find out whether it has been using the BKL
on purpose or by accident, before this patch gets applied.


Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -804,10 +804,10 @@ long compat_blkdev_ioctl(struct file *fi
 
 	lock_kernel();
 	ret = compat_blkdev_locked_ioctl(inode, file, bdev, cmd, arg);
-	/* FIXME: why do we assume -> compat_ioctl needs the BKL? */
+	unlock_kernel();
+
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(file, cmd, arg);
-	unlock_kernel();
 
 	if (ret != -ENOIOCTLCMD)
 		return ret;

-- 

