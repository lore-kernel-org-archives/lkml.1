Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZKWRlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZKWRlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZKWRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:41:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZKWRlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:41:31 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: [PATCH 2/3] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
Date: Mon, 23 Nov 2009 12:41:23 -0500
Message-Id: <1258998084-26797-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of a bind mounted file, the path walking code will assume
that the cached dentry that was bind mounted is valid. This is a problem
problem for NFSv4 in a way that's similar to LAST_BIND symlinks.

Fix this by revalidating the dentry if LOOKUP_OPEN is set and
__follow_mount returns true.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2c10519..738b257 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -838,6 +838,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	struct vfsmount *mnt = nd->path.mnt;
 	struct dentry *dentry = __d_lookup(nd->path.dentry, name);
+	int error = 0;
 
 	if (!dentry)
 		goto need_lookup;
@@ -846,8 +847,9 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
-	__follow_mount(path);
-	return 0;
+	if (__follow_mount(path))
+		error = force_reval_path(path, nd);
+	return error;
 
 need_lookup:
 	dentry = real_lookup(nd->path.dentry, name, nd);
@@ -1835,6 +1837,9 @@ do_last:
 		error = -ELOOP;
 		if (flag & O_NOFOLLOW)
 			goto exit_dput;
+		error = force_reval_path(&path, &nd);
+		if (error)
+			goto exit;
 	}
 
 	error = -ENOENT;
-- 
1.5.5.6

