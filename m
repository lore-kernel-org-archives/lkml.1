Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYEEJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYEEJ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYEEJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38321 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbYEEJzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:25 -0400
Message-Id: <20080505095517.214430823@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:48 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [patch 07/15] hpfs: dont call notify_change
Content-Disposition: inline; filename=hpfs_notify_change_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

hpfs_unlink() calls notify_change() to truncate the file before
deleting.  Replace with explicit call to hpfs_notify_change().

This is equivalent, except that:
 - security_inode_setattr() is not called before hpfs_notify_change()
 - fsnotify_change() is not called after hpfs_notify_change()

The truncation is just an implementation detail, so both the security
check and the notification are unnecessary.

Possibly even the ctime modification is wrong?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
---
 fs/hpfs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/hpfs/namei.c
===================================================================
--- linux-2.6.orig/fs/hpfs/namei.c	2008-05-05 11:29:20.000000000 +0200
+++ linux-2.6/fs/hpfs/namei.c	2008-05-05 11:29:26.000000000 +0200
@@ -426,7 +426,8 @@ again:
 			/*printk("HPFS: truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-			err = notify_change(dentry, &newattrs);
+			newattrs.ia_ctime = current_fs_time(inode->i_sb);
+			err = hpfs_notify_change(dentry, &newattrs);
 			put_write_access(inode);
 			if (!err)
 				goto again;

--
