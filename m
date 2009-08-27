Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZH0OGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZH0OGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZH0OGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:06:08 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34388 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZH0OGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:06:06 -0400
Message-ID: <4A9692CF.80508@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 23:06:07 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] Do not allow umounting of frozen filesystems
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp>
In-Reply-To: <4A965BD1.205@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of making umount users wait until the filesystem is
unfreezed return EBUSY, which is very convenient in HA
configurations.

This could have been implemented at a lower level but it would
require considerable plumbing in functions such as release_mounts
which do not return errors.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc7-orig/fs/namespace.c linux-2.6.31-rc7/fs/namespace.c
--- linux-2.6.31-rc7-orig/fs/namespace.c	2009-08-27 19:34:35.000000000 +0900
+++ linux-2.6.31-rc7/fs/namespace.c	2009-08-27 22:45:14.000000000 +0900
@@ -1086,6 +1086,14 @@ static int do_umount(struct vfsmount *mn
  		return retval;
  	}

+	if (sb->s_bdev != NULL) {
+		mutex_lock(&sb->s_bdev->bd_fsfreeze_mutex);
+		if (sb->s_frozen != SB_UNFROZEN) {
+			mutex_unlock(&sb->s_bdev->bd_fsfreeze_mutex);
+			return -EBUSY;
+		}
+	}
+
  	down_write(&namespace_sem);
  	spin_lock(&vfsmount_lock);
  	event++;
@@ -1104,6 +1112,10 @@ static int do_umount(struct vfsmount *mn
  		security_sb_umount_busy(mnt);
  	up_write(&namespace_sem);
  	release_mounts(&umount_list);
+
+	if (sb->s_bdev != NULL)
+		mutex_unlock(&sb->s_bdev->bd_fsfreeze_mutex);
+
  	return retval;
  }

