Return-Path: <linux-kernel-owner+w=401wt.eu-S1763830AbYGBLEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763830AbYGBLEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbYGBLDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:03:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43172 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbYGBLDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:03:42 -0400
To: Artem.Bityutskiy@nokia.com
CC: linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, ext-Adrian.Hunter@nokia.com
In-reply-to: <486B419F.7050407@nokia.com> (message from Artem Bityutskiy on
	Wed, 02 Jul 2008 11:51:43 +0300)
Subject: Re: Is VFS behavior fine?
References: <486B419F.7050407@nokia.com>
Message-Id: <E1KE07d-0007wx-M2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 13:03:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008, Artem Bityutskiy wrote:
> The result of it was that the '->delete_inode()' operation for
> the 'xxx' directory inode is not called. It is not called even
> after 'cd /'. However, if we do not do the 'touch tmp' command
> (which actually fails), '->delete_inode()' _is_ called for 'xxx'.

This certainly doesn't sound right.

<snip>

> The 'tmp' dentry is freed eventually because of unmount or
> memory pressure, but not earlier than that. So the deleted
> inodes may be kept for really long time. Is this OK?

No, deleted dentries should go away immediately, or if they are still
referenced, then they are unhashed, and go away once the reference
disappears.

In this situation however, it seems that the unhashed dentry managed
to acquire a child, which keeps it from being finally killed.  The VFS
shouldn't allow this to happen.

> I may just say that I fixed this in UBIFS by not calling
> 'd_splice_alias()' for not found dentries if the parent
> directory inode has 'n_link' = 0. However, ext[23] always
> call 'd_splice_alias()' for not found direntries (passing
> NULL as the 'inode' parameter).
> 
> Again, I am not 100% sure this is the right fix, because
> I suspect this should be "fixed" in VFS. I tried to do this
> and I have a small VFS patch, but it is probably incorrect.

The correct fix IMO is to make lookup return ENOENT on an IS_DEADDIR()
inode, before even trying to create the child dentry.

Untested patch attached.

Miklos

----
Subject: vfs: fix lookup on deleted directory

From: Miklos Szeredi <mszeredi@suse.cz>

Lookup can install a child dentry for a deleted directory.  This keeps
the directory alive even after all external references have gone away.

Fix this by returning ENOENT for all lookups on a S_DEAD directory
before creating a child dentry.

Reported-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-01 22:28:42.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-02 12:57:27.000000000 +0200
@@ -519,7 +519,14 @@ static struct dentry * real_lookup(struc
 	 */
 	result = d_lookup(parent, name);
 	if (!result) {
-		struct dentry * dentry = d_alloc(parent, name);
+		struct dentry *dentry;
+
+		/* Don't create child dentry for a dead directory. */
+		result = ERR_PTR(-ENOENT);
+		if (IS_DEADDIR(dir))
+			goto out_unlock;
+
+		dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
 		if (dentry) {
 			result = dir->i_op->lookup(dir, dentry, nd);
@@ -528,6 +535,7 @@ static struct dentry * real_lookup(struc
 			else
 				result = dentry;
 		}
+out_unlock:
 		mutex_unlock(&dir->i_mutex);
 		return result;
 	}
@@ -1317,7 +1325,14 @@ static struct dentry *__lookup_hash(stru
 
 	dentry = cached_lookup(base, name, nd);
 	if (!dentry) {
-		struct dentry *new = d_alloc(base, name);
+		struct dentry *new;
+
+		/* Don't create child dentry for a dead directory. */
+		dentry = ERR_PTR(-ENOENT);
+		if (IS_DEADDIR(inode))
+			goto out;
+
+		new = d_alloc(base, name);
 		dentry = ERR_PTR(-ENOMEM);
 		if (!new)
 			goto out;
