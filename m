Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZEUJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZEUJX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZEUJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:23:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50321 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZEUJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:23:15 -0400
Message-Id: <20090521092251.319505534@szeredi.hu>
References: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
Subject: [patch 4/5] union-directory: Make lookup continue in overlayed directories
Content-Disposition: inline; filename=union-directory-lookup.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This patch lets adds support for union-directory lookup to lookups from dentry
cache and real lookups. On union-directories a lookup must continue on
overlayed directories of the union. The lookup continues until the first
no-negative dentry is found. Otherwise the topmost negative dentry is
returned.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/fs/namei.c	2009-05-20 15:10:09.000000000 +0200
@@ -34,6 +34,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <asm/uaccess.h>
+#include "union.h"
 
 #define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
 
@@ -778,6 +779,49 @@ static __always_inline void follow_dotdo
 	follow_mount(&nd->path.mnt, &nd->path.dentry);
 }
 
+static int do_lookup_union(struct nameidata *nd, struct qstr *name,
+			   struct path *path)
+{
+	int err;
+	struct path save;
+
+	save = nd->path;
+	path_get(&save);
+	while (follow_union_up(&nd->path)) {
+		struct dentry *dentry;
+
+		dentry = d_hash_and_lookup(nd->path.dentry, name);
+		if (dentry && dentry->d_op && dentry->d_op->d_revalidate) {
+			dentry = do_revalidate(dentry, nd);
+			err = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
+				goto out;
+		}
+		if (!dentry) {
+			dentry = real_lookup(nd->path.dentry, name, nd);
+			err = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
+				goto out;
+		}
+		if (dentry->d_inode) {
+			dput(path->dentry);
+			path->dentry = dentry;
+			path->mnt = mntget(nd->path.mnt);
+			follow_mount(&path->mnt, &path->dentry);
+			err = 0;
+			goto out;
+		}
+		dput(dentry);
+	}
+	__follow_mount(path);
+	err = 0;
+out:
+	path_put(&nd->path);
+	nd->path = save;
+
+	return err;
+}
+
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
@@ -796,6 +840,11 @@ static int do_lookup(struct nameidata *n
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
+	if (IS_MNT_UNION(mnt) && !dentry->d_inode &&
+	    nd->path.dentry == nd->path.mnt->mnt_root) {
+		return do_lookup_union(nd, name, path);
+	}
+
 	__follow_mount(path);
 	return 0;
 

--
