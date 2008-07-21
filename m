Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYGULip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYGULip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYGULii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:38:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43332 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYGULih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:38:37 -0400
To: viro@ZenIV.linux.org.uk
CC: linux-kernel@vger.kernel.org
Subject: [patch] nfs: fix permission mask
Message-Id: <E1KKtis-00089S-MU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jul 2008 13:38:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Handle auxiliary mask bits in nfs_permission() properly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2008-07-21 09:46:07.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2008-07-21 13:09:28.000000000 +0200
@@ -1884,7 +1884,7 @@ static int nfs_do_access(struct inode *i
 		return status;
 	nfs_access_add_cache(inode, &cache);
 out:
-	if ((cache.mask & mask) == mask)
+	if ((mask & ~cache.mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
 		return 0;
 	return -EACCES;
 }
@@ -1914,7 +1914,7 @@ int nfs_permission(struct inode *inode, 
 
 	nfs_inc_stats(inode, NFSIOS_VFSACCESS);
 
-	if (mask == 0)
+	if ((mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
 		goto out;
 	/* Is this sys_access() ? */
 	if (mask & MAY_ACCESS)
