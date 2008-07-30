Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYG3K0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYG3K0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYG3K0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:26:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52337 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3K0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:26:36 -0400
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, sage@newdream.net, zach.brown@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch resend] vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
Message-Id: <E1KO8sx-0004VF-Tu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 12:26:23 +0200
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

The bug was introduced by: commit 349457ccf2592c14bdf13b6706170ae2e94931b1
"[PATCH] Allow file systems to manually d_move() inside of ->rename()"

Fix by not rehashing the new dentry.  Rehashing used to be needed by
d_move() but isn't anymore.

Reported-by: Sage Weil <sage@newdream.net>
CC: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-29 21:28:55.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-29 21:36:50.000000000 +0200
@@ -2542,8 +2542,6 @@ static int vfs_rename_dir(struct inode *
 		if (!error)
 			target->i_flags |= S_DEAD;
 		mutex_unlock(&target->i_mutex);
-		if (d_unhashed(new_dentry))
-			d_rehash(new_dentry);
 		dput(new_dentry);
 	}
 	if (!error)
