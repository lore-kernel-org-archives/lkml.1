Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZHZFAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZHZFAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbZHZFAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:00 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50818 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZHZFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:00 -0400
Message-ID: <4A94C151.8020900@oss.ntt.co.jp>
Date: Wed, 26 Aug 2009 14:00:01 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com
CC: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [RFC, PATCH] filesystem freeze: fix sys_umount induced perpetual
 freeze
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current locking scheme for filesystem freeze avoids races between
freeze_bdev() and do_umount() by taking the s_umount semaphore.

If freeze_bdev() wins the race the process that invoked sys_umount
will sleep until thaw_bdev releases the semaphore. Unfortunately, this
will never happen because thaw_bdev bails out early the
bd_fsfreeze_count check having failed (the count is 0).

The problem is that the block_device that ioctl_fsthaw() passes to
thaw_bdev() is not the one that we freezed because before sleeping in
deactivate_super() do_umount() released the dentry (dput()) and freed
the vfs mount (free_vfsmnt()).

This patch works around this issue by checking the freeze level in
do_umount().

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc7-orig/fs/namespace.c linux-2.6.31-rc7/fs/namespace.c
--- linux-2.6.31-rc7-orig/fs/namespace.c	2009-08-25 16:39:46.000000000 +0900
+++ linux-2.6.31-rc7/fs/namespace.c	2009-08-26 11:30:10.000000000 +0900
@@ -1033,6 +1033,8 @@ static int do_umount(struct vfsmount *mn
  	if (retval)
  		return retval;

+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+
  	/*
  	 * Allow userspace to request a mountpoint be expired rather than
  	 * unmounting unconditionally. Unmount only happens if:
