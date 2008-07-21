Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYGULmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYGULmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYGULlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:41:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43337 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGULlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:41:51 -0400
To: viro@ZenIV.linux.org.uk
CC: sage@newdream.net, zach.brown@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
Message-Id: <E1KKtlz-0008B9-BM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jul 2008 13:41:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

vfs_rename_dir() doesn't properly account for filesystems with
FS_RENAME_DOES_D_MOVE.  If new_dentry has a target inode attached, it
unhashes the new_dentry prior to the rename() iop and rehashes it
after, but doesn't account for the possibility that rename() may have
swapped {old,new}_dentry.  For FS_RENAME_DOES_D_MOVE filesystems, it
rehashes new_dentry (now the old renamed-from name, which d_move()
expected to go away), such that a subsequent lookup will find it.

This was caught by the recently posted POSIX fstest suite, rename/10.t 
test 62 (and others) on ceph.

Fix by not rehashing the new dentry.  Rehashing would only make sense
if the rename failed (which should happen extremely rarely), but we
cannot handle that case correctly 100% of the time anyway, so...

Reported-by: Sage Weil <sage@newdream.net>
CC: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-21 09:46:07.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-21 11:56:01.000000000 +0200
@@ -2574,8 +2574,6 @@ static int vfs_rename_dir(struct inode *
 		if (!error)
 			target->i_flags |= S_DEAD;
 		mutex_unlock(&target->i_mutex);
-		if (d_unhashed(new_dentry))
-			d_rehash(new_dentry);
 		dput(new_dentry);
 	}
 	if (!error)
