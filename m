Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYGBTag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYGBTag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYGBTa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:30:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53390 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYGBTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:30:26 -0400
To: viro@ZenIV.linux.org.uk
CC: akpm@linux-foundation.org, hch@infradead.org, Artem.Bityutskiy@nokia.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch] vfs: fix lookup on deleted directory
Message-Id: <E1KE81v-0000d8-Kp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 21:30:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Lookup can install a child dentry for a deleted directory.  This keeps
the directory dentry alive, and the inode pinned in the cache and on
disk, even after all external references have gone away.

This isn't a big problem normally, since memory pressure or umount
will clear out the directory dentry and its children, releasing the
inode.  But for UBIFS this causes problems because its orphan area can
overflow.

Fix this by returning ENOENT for all lookups on a S_DEAD directory
before creating a child dentry.

Thanks to Zoltan Sogor for noticing this while testing UBIFS, and
Artem for the excellent analysis of the problem and testing.

Reported-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-02 17:25:55.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-02 17:25:57.000000000 +0200
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
