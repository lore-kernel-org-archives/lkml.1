Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYEWPtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYEWPtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbYEWPtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:49:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34368 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbYEWPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:49:35 -0400
To: miklos@szeredi.hu
CC: zippel@linux-m68k.org, hch@infradead.org, miklos@szeredi.hu,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 23 May 2008 17:31:39 +0200)
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org> <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain> <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu>
Message-Id: <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 17:49:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Yes.  Roman, if you care about details about the files as directories
> > > look in the reiser4 threads as it did something quite similar.
> > 
> > I was afraid this would come up. :)
> > I only need something much simpler, I don't need to create/move/unlink 
> > anything, I only need a lookup+open.
> 
> Doesn't matter.  As long as filesystem has hard links and allows
> lookup on these, userspace can screw up the kernel.  Badly.

And so I strongly suggest this patch as well.  Apparently this feature
is not even used by anybody, otherwise somebody would have noticed
when Trond's fix broke execute permission checking on regular files...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/hfsplus/inode.c |   44 --------------------------------------------
 1 file changed, 44 deletions(-)

Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2008-05-22 18:27:02.000000000 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2008-05-23 17:42:49.000000000 +0200
@@ -142,49 +142,6 @@ struct dentry_operations hfsplus_dentry_
 	.d_compare    = hfsplus_compare_dentry,
 };
 
-static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dentry,
-					  struct nameidata *nd)
-{
-	struct hfs_find_data fd;
-	struct super_block *sb = dir->i_sb;
-	struct inode *inode = NULL;
-	int err;
-
-	if (HFSPLUS_IS_RSRC(dir) || strcmp(dentry->d_name.name, "rsrc"))
-		goto out;
-
-	inode = HFSPLUS_I(dir).rsrc_inode;
-	if (inode)
-		goto out;
-
-	inode = new_inode(sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	inode->i_ino = dir->i_ino;
-	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
-	HFSPLUS_I(inode).flags = HFSPLUS_FLG_RSRC;
-
-	hfs_find_init(HFSPLUS_SB(sb).cat_tree, &fd);
-	err = hfsplus_find_cat(sb, dir->i_ino, &fd);
-	if (!err)
-		err = hfsplus_cat_read_inode(inode, &fd);
-	hfs_find_exit(&fd);
-	if (err) {
-		iput(inode);
-		return ERR_PTR(err);
-	}
-	HFSPLUS_I(inode).rsrc_inode = dir;
-	HFSPLUS_I(dir).rsrc_inode = inode;
-	igrab(dir);
-	hlist_add_head(&inode->i_hash, &HFSPLUS_SB(sb).rsrc_inodes);
-	mark_inode_dirty(inode);
-out:
-	d_add(dentry, inode);
-	return NULL;
-}
-
 static void hfsplus_get_perms(struct inode *inode, struct hfsplus_perm *perms, int dir)
 {
 	struct super_block *sb = inode->i_sb;
@@ -269,7 +226,6 @@ static int hfsplus_file_release(struct i
 }
 
 static const struct inode_operations hfsplus_file_inode_operations = {
-	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
