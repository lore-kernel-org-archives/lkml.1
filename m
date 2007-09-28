Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXI1UnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXI1UnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXI1Umx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:42:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:56606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXI1Umw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:42:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: jblunck@suse.de
Subject: [patch] Combine path_put and path_put_conditional
Date: Fri, 28 Sep 2007 22:43:50 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       tiwai@suse.de
References: <20070927141200.820970144@X40.localnet>
In-Reply-To: <20070927141200.820970144@X40.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709282243.51243.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another cleanup on top of Jan's set. Comments?


The name path_put_conditional (formerly, dput_path) is a little unclear.
Replace (path_put_conditional + path_put) with path_walk_put_both,
"put a pair of paths after a path_walk" (see the kerneldoc).

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -582,11 +582,22 @@ fail:
 	return PTR_ERR(link);
 }
 
-static void path_put_conditional(struct path *path, struct nameidata *nd)
-{
-	dput(path->dentry);
-	if (path->mnt != nd->path.mnt)
-		mntput(path->mnt);
+/**
+ * path_walk_put_both - put a pair of paths after a path_walk
+ * @path1:	first path to put
+ * @path2:	second path to put
+ *
+ * When walking a path we keep the same vfsmnt reference while on the same
+ * filesystem, and grab a reference to the new vfsmnt when crossing mount
+ * points. Put both @path1 and @path2 under this assumption.
+ */
+static void path_walk_put_both(struct path *path1, struct path *path2)
+{
+	dput(path1->dentry);
+	dput(path2->dentry);
+	mntput(path1->mnt);
+	if (path1->mnt != path2->mnt)
+		mntput(path2->mnt);
 }
 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
@@ -654,8 +665,7 @@ static inline int do_follow_link(struct 
 	nd->depth--;
 	return err;
 loop:
-	path_put_conditional(path, nd);
-	path_put(&nd->path);
+	path_walk_put_both(path, &nd->path);
 	return err;
 }
 
@@ -996,8 +1006,8 @@ return_reval:
 return_base:
 		return 0;
 out_dput:
-		path_put_conditional(&next, nd);
-		break;
+		path_walk_put_both(&next, &nd->path);
+		goto return_err;
 	}
 	path_put(&nd->path);
 return_err:
@@ -1777,11 +1787,15 @@ ok:
 	return 0;
 
 exit_dput:
-	path_put_conditional(&path, nd);
+	path_walk_put_both(&path, &nd->path);
+	goto exit_intent;
+
 exit:
+	path_put(&nd->path);
+
+exit_intent:
 	if (!IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
-	path_put(&nd->path);
 	return error;
 
 do_link:
