Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYJOOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYJOOIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYJOOE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45116 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbYJOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:49 -0400
Subject: [PATCH 3/6] vfs: add __d_instantiate() helper
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:10 +0900
Message-ID: <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
In-Reply-To: <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds __d_instantiate() for users which is already taking
dcache_lock, and replace with it.

The part of d_add_ci() isn't equivalent. But it should be needed
fsnotify_d_instantiate() actually, because the path is to add the
inode to negative dentry.  fsnotify_d_instantiate() should be called
after change from negative to positive.

__d_instantiate_unique() and d_materialise_unique() does opencoded
optimized version. From history, it seems a intent, so just add comment.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/dcache.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN fs/dcache.c~dcache-cleanup-3 fs/dcache.c
--- linux-2.6/fs/dcache.c~dcache-cleanup-3	2008-09-30 05:24:37.000000000 +0900
+++ linux-2.6-hirofumi/fs/dcache.c	2008-09-30 05:24:37.000000000 +0900
@@ -981,6 +981,15 @@ struct dentry *d_alloc_name(struct dentr
 	return d_alloc(parent, &q);
 }
 
+/* the caller must hold dcache_lock */
+static void __d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	if (inode)
+		list_add(&dentry->d_alias, &inode->i_dentry);
+	dentry->d_inode = inode;
+	fsnotify_d_instantiate(dentry, inode);
+}
+
 /**
  * d_instantiate - fill in inode information for a dentry
  * @entry: dentry to complete
@@ -1000,10 +1009,7 @@ void d_instantiate(struct dentry *entry,
 {
 	BUG_ON(!list_empty(&entry->d_alias));
 	spin_lock(&dcache_lock);
-	if (inode)
-		list_add(&entry->d_alias, &inode->i_dentry);
-	entry->d_inode = inode;
-	fsnotify_d_instantiate(entry, inode);
+	__d_instantiate(entry, inode);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
@@ -1033,6 +1039,7 @@ static struct dentry *__d_instantiate_un
 	unsigned int hash = entry->d_name.hash;
 
 	if (!inode) {
+		/* __d_instantiate() by hand */
 		entry->d_inode = NULL;
 		return NULL;
 	}
@@ -1052,9 +1059,7 @@ static struct dentry *__d_instantiate_un
 		return alias;
 	}
 
-	list_add(&entry->d_alias, &inode->i_dentry);
-	entry->d_inode = inode;
-	fsnotify_d_instantiate(entry, inode);
+	__d_instantiate(entry, inode);
 	return NULL;
 }
 
@@ -1211,10 +1216,8 @@ struct dentry *d_splice_alias(struct ino
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* d_instantiate takes dcache_lock, so we do it by hand */
-			list_add(&dentry->d_alias, &inode->i_dentry);
-			dentry->d_inode = inode;
-			fsnotify_d_instantiate(dentry, inode);
+			/* already taking dcache_lock, so d_add() by hand */
+			__d_instantiate(dentry, inode);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
@@ -1297,8 +1300,7 @@ struct dentry *d_add_ci(struct dentry *d
 		 * d_instantiate() by hand because it takes dcache_lock which
 		 * we already hold.
 		 */
-		list_add(&found->d_alias, &inode->i_dentry);
-		found->d_inode = inode;
+		__d_instantiate(found, inode);
 		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
@@ -1827,6 +1829,7 @@ struct dentry *d_materialise_unique(stru
 
 	if (!inode) {
 		actual = dentry;
+		/* __d_instantiate() by hand */
 		dentry->d_inode = NULL;
 		goto found_lock;
 	}
_
