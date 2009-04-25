Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZDYBiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZDYBiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbZDYBag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:30:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZDYB2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:49 -0400
Message-Id: <20090425012211.364525234@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:36 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 16/27] fs: dcache reduce dput locking
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=dcache-dput-less-dcache_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to run dput without taking locks up-front. In many cases
where we don't kill the dentry anyway, these locks are not required.

(I think... need to think about it more). Further changes ->d_delete
locking which is not all audited.

---
 fs/dcache.c |   59 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -262,7 +262,8 @@ static struct dentry *d_kill(struct dent
 
 void dput(struct dentry *dentry)
 {
-	struct dentry *parent = NULL;
+	struct dentry *parent;
+
 	if (!dentry)
 		return;
 
@@ -270,23 +271,9 @@ repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
 	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_inode_lock)) {
-drop2:
-			spin_unlock(&dentry->d_lock);
-			goto repeat;
-		}
-		parent = dentry->d_parent;
-		if (parent) {
-			BUG_ON(parent == dentry);
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&dcache_inode_lock);
-				goto drop2;
-			}
-		}
-	}
-	dentry->d_count--;
-	if (dentry->d_count) {
+	BUG_ON(!dentry->d_count);
+	if (dentry->d_count > 1) {
+		dentry->d_count--;
 		spin_unlock(&dentry->d_lock);
 		return;
 	}
@@ -295,8 +282,10 @@ drop2:
 	 * AV: ->d_delete() is _NOT_ allowed to block now.
 	 */
 	if (dentry->d_op && dentry->d_op->d_delete) {
-		if (dentry->d_op->d_delete(dentry))
-			goto unhash_it;
+		if (dentry->d_op->d_delete(dentry)) {
+			__d_drop(dentry);
+			goto kill_it;
+		}
 	}
 	/* Unreachable? Get rid of it */
  	if (d_unhashed(dentry))
@@ -305,15 +294,31 @@ drop2:
   		dentry->d_flags |= DCACHE_REFERENCED;
 		dentry_lru_add(dentry);
   	}
- 	spin_unlock(&dentry->d_lock);
-	if (parent)
-		spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_inode_lock);
-	return;
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
+  	return;
 
-unhash_it:
-	__d_drop(dentry);
 kill_it:
+	spin_unlock(&dentry->d_lock);
+	spin_lock(&dcache_inode_lock);
+relock:
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	if (parent) {
+		BUG_ON(parent == dentry);
+		if (!spin_trylock(&parent->d_lock)) {
+			spin_unlock(&dentry->d_lock);
+			goto relock;
+		}
+	}
+	dentry->d_count--;
+	if (dentry->d_count) {
+		/* This case should be fine */
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
+		spin_unlock(&dcache_inode_lock);
+		return;
+	}
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);


