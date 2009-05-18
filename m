Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZERQNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZERQNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZERQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:12:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:41535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbZERQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:35 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 22/32] union-mount: stop lookup when directory has S_OPAQUE flag set
Date: Mon, 18 May 2009 18:09:18 +0200
Message-Id: <1242662968-11684-23-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Honor the S_OPAQUE flag in the union path lookup.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2bb8a22..83cc5ea 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -521,6 +521,9 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = dentry;
 		last.mnt = mntget(nd->path.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -560,7 +563,8 @@ static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
 
 		/* only directories can be part of a union stack */
 		if (!path->dentry->d_inode ||
-		    !S_ISDIR(path->dentry->d_inode->i_mode))
+		    !S_ISDIR(path->dentry->d_inode->i_mode) ||
+		    IS_OPAQUE(path->dentry->d_inode))
 			goto out;
 
 		/* Build the union stack for this part */
@@ -802,6 +806,9 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -823,7 +830,8 @@ static int real_lookup_union(struct nameidata *nd, struct qstr *name,
 
 	/* only directories can be part of a union stack */
 	if (!path->dentry->d_inode ||
-	    !S_ISDIR(path->dentry->d_inode->i_mode))
+	    !S_ISDIR(path->dentry->d_inode->i_mode) ||
+	    IS_OPAQUE(path->dentry->d_inode))
 		goto out;
 
 	/* Build the union stack for this part */
@@ -1108,7 +1116,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	int err;
 
-	if (IS_MNT_UNION(nd->path.mnt))
+	if (IS_MNT_UNION(nd->path.mnt) && !IS_OPAQUE(nd->path.dentry->d_inode))
 		goto need_union_lookup;
 
 	path->dentry = __d_lookup(nd->path.dentry, name);
@@ -1643,6 +1651,9 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
-- 
1.6.1.3

