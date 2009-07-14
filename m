Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZGNQSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZGNQSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZGNQSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:18:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZGNQSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:18:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1247561220.2473.0.camel@ht.satnam>
References: <1247561220.2473.0.camel@ht.satnam> <20090709094430.23882.46013.stgit@warthog.procyon.org.uk>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: dhowells@redhat.com, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix compilation warning
Date: Tue, 14 Jul 2009 17:17:26 +0100
Message-ID: <5554.1247588246@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Artem,

Can you try Jaswinder's patch?  I don't see the warning even without your
patch, so I can't test it.

David
---
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9bd7577..09cb5bb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -607,53 +607,56 @@ static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 
 	/* search the directory for this vnode */
 	ret = afs_do_lookup(&dir->vfs_inode, dentry, &fid, key);
-	switch (ret) {
-	case 0:
-		/* the filename maps to something */
-		if (!dentry->d_inode)
-			goto out_bad;
-		if (is_bad_inode(dentry->d_inode)) {
-			printk("kAFS: afs_d_revalidate: %s/%s has bad inode\n",
-			       parent->d_name.name, dentry->d_name.name);
+	if (ret < 0) {
+		switch (ret) {
+		case -ENOENT:
+			/* the filename is unknown */
+			_debug("%s: dirent not found", dentry->d_name.name);
+			if (dentry->d_inode)
+				goto not_found;
+			goto out_valid;
+
+		default:
+			_debug("failed to iterate dir %s: %d",
+			       parent->d_name.name, ret);
 			goto out_bad;
 		}
+	}
 
-		/* if the vnode ID has changed, then the dirent points to a
-		 * different file */
-		if (fid.vnode != vnode->fid.vnode) {
-			_debug("%s: dirent changed [%u != %u]",
-			       dentry->d_name.name, fid.vnode,
-			       vnode->fid.vnode);
-			goto not_found;
-		}
-
-		/* if the vnode ID uniqifier has changed, then the file has
-		 * been deleted and replaced, and the original vnode ID has
-		 * been reused */
-		if (fid.unique != vnode->fid.unique) {
-			_debug("%s: file deleted (uq %u -> %u I:%llu)",
-			       dentry->d_name.name, fid.unique,
-			       vnode->fid.unique,
-			       (unsigned long long)dentry->d_inode->i_version);
-			spin_lock(&vnode->lock);
-			set_bit(AFS_VNODE_DELETED, &vnode->flags);
-			spin_unlock(&vnode->lock);
-			goto not_found;
-		}
-		goto out_valid;
-
-	case -ENOENT:
-		/* the filename is unknown */
-		_debug("%s: dirent not found", dentry->d_name.name);
-		if (dentry->d_inode)
-			goto not_found;
-		goto out_valid;
-
-	default:
-		_debug("failed to iterate dir %s: %d",
-		       parent->d_name.name, ret);
+	/* the filename maps to something */
+	if (!dentry->d_inode)
 		goto out_bad;
+	if (is_bad_inode(dentry->d_inode)) {
+		printk("kAFS: afs_d_revalidate: %s/%s has bad inode\n",
+		       parent->d_name.name, dentry->d_name.name);
+		goto out_bad;
+	}
+
+	/*
+	 * if the vnode ID has changed, then the dirent points to a
+	 * different file
+	 */
+	if (fid.vnode != vnode->fid.vnode) {
+		_debug("%s: dirent changed [%u != %u]",
+		       dentry->d_name.name, fid.vnode, vnode->fid.vnode);
+		goto not_found;
+	}
+
+	/*
+	 * if the vnode ID uniqifier has changed, then the file has been
+	 * deleted and replaced, and the original vnode ID has been reused
+	 */
+	if (fid.unique != vnode->fid.unique) {
+		_debug("%s: file deleted (uq %u -> %u I:%llu)",
+		       dentry->d_name.name, fid.unique,
+		       vnode->fid.unique,
+		       (unsigned long long)dentry->d_inode->i_version);
+		spin_lock(&vnode->lock);
+		set_bit(AFS_VNODE_DELETED, &vnode->flags);
+		spin_unlock(&vnode->lock);
+		goto not_found;
 	}
+	goto out_valid;
 
 out_valid:
 	dentry->d_fsdata = dir_version;
