Return-Path: <linux-kernel-owner+w=401wt.eu-S936266AbYEURSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936266AbYEURSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbYEURP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33064 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbYEURP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:56 -0400
Message-Id: <20080521171549.964767446@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:04 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 06/14] hfsplus: remove hfsplus_permission()
Content-Disposition: inline; filename=hfsplus_permission_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

I'm not sure what this function is trying to achieve, but it's not
succeeding: the condition for which it is returning zero is exactly
the same as checked by permission(), which results in -EACCES.

So in the end this is equivalent to the default action.

A similar check is in hfs_permission() but that does actually do
something, though I'm doubtful if it's the right thing.  But we should
probably leave that alone, lest we break something unexpectedly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfsplus/inode.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2008-05-21 13:41:26.000000000 +0200
@@ -238,18 +238,6 @@ static void hfsplus_set_perms(struct ino
 	perms->dev = cpu_to_be32(HFSPLUS_I(inode).dev);
 }
 
-static int hfsplus_permission(struct inode *inode, int mask, struct nameidata *nd)
-{
-	/* MAY_EXEC is also used for lookup, if no x bit is set allow lookup,
-	 * open_exec has the same test, so it's still not executable, if a x bit
-	 * is set fall back to standard permission check.
-	 */
-	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC && !(inode->i_mode & 0111))
-		return 0;
-	return generic_permission(inode, mask, NULL);
-}
-
-
 static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
 	if (HFSPLUS_IS_RSRC(inode))
@@ -283,7 +271,6 @@ static int hfsplus_file_release(struct i
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
-	.permission	= hfsplus_permission,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
 	.listxattr	= hfsplus_listxattr,

--
