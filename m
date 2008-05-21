Return-Path: <linux-kernel-owner+w=401wt.eu-S936251AbYEURTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936251AbYEURTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765339AbYEURP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33060 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbYEURPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:54 -0400
Message-Id: <20080521171548.148636128@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:03 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [patch 05/14] hpfs: dont call permission()
Content-Disposition: inline; filename=hpfs_permission_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

hpfs_unlink() calls permission() prior to truncating the file.  HPFS
doesn't define a .permission method, so replace with explicit call to
generic_permission().

This is equivalent, except that devcgroup_inode_permission() and
security_inode_permission() are not called.

The truncation is just an implementation detail of the unlink, so
these security checks are unnecessary.

I suspect that even calling generic_permission() is unnecessary, since
we shouldn't mind if the file isn't writable.  But I leave that to the
maintainer to decide.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
---
 fs/hpfs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/hpfs/namei.c
===================================================================
--- linux-2.6.orig/fs/hpfs/namei.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/fs/hpfs/namei.c	2008-05-21 13:41:25.000000000 +0200
@@ -415,7 +415,7 @@ again:
 		d_drop(dentry);
 		spin_lock(&dentry->d_lock);
 		if (atomic_read(&dentry->d_count) > 1 ||
-		    permission(inode, MAY_WRITE, NULL) ||
+		    generic_permission(inode, MAY_WRITE, NULL) ||
 		    !S_ISREG(inode->i_mode) ||
 		    get_write_access(inode)) {
 			spin_unlock(&dentry->d_lock);

--
