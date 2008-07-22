Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYGVWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYGVWOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYGVWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59087 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbYGVWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:26 -0400
Message-Id: <20080722221322.168296561@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:03 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [patch 04/14] hpfs: dont call notify_change
Content-Disposition: inline; filename=hpfs-dont-call-notify_change.patch
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
--- linux-2.6.orig/fs/hpfs/namei.c	2008-07-23 00:10:13.000000000 +0200
+++ linux-2.6/fs/hpfs/namei.c	2008-07-23 00:10:22.000000000 +0200
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
