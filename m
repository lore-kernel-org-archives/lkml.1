Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZC2QmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZC2QmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZC2Qh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:52665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZC2Qhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:31 -0400
Message-Id: <20090329155750.221818272@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:52 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 13/14] fs: dcache reduce dcache_inode_lock
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-d_delete-less-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be avoided in d_delete() and d_materialise_unique()
in cases where it is not required.
---
 fs/dcache.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1722,10 +1722,14 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_inode_lock);
+again:
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (dentry->d_count == 1) {
+		if (!spin_trylock(&dcache_inode_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto again;
+		}
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
@@ -1735,7 +1739,6 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_inode_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2042,14 +2045,15 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_inode_lock);
-
 	if (!inode) {
 		actual = dentry;
 		__d_instantiate(dentry, NULL);
-		goto found_lock;
+		d_rehash(actual);
+		goto out_nolock;
 	}
 
+	spin_lock(&dcache_inode_lock);
+
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
 
@@ -2077,10 +2081,9 @@ struct dentry *d_materialise_unique(stru
 	actual = __d_instantiate_unique(dentry, inode);
 	if (!actual)
 		actual = dentry;
-	else if (unlikely(!d_unhashed(actual)))
-		goto shouldnt_be_hashed;
+	else
+		BUG_ON(!d_unhashed(actual));
 
-found_lock:
 	spin_lock(&actual->d_lock);
 found:
 	_d_rehash(actual);
@@ -2094,10 +2097,6 @@ out_nolock:
 
 	iput(inode);
 	return actual;
-
-shouldnt_be_hashed:
-	spin_unlock(&dcache_inode_lock);
-	BUG();
 }
 
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)


