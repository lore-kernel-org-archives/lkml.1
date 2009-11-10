Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZKJQ1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZKJQ1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbZKJQ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbZKJQ1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:27:42 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       jamie@shareable.org
Subject: [PATCH 2/2] vfs: force reval on dentry of bind mounted files for LOOKUP_OPEN
Date: Tue, 10 Nov 2009 11:27:36 -0500
Message-Id: <1257870456-31188-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of a bind mounted file, the path walking code will assume
that a cached dentry is valid and doesn't revalidate it. This is a
problem for NFSv4 in a way that's similar to LAST_BIND symlinks.

Fix this by revalidating the dentry if LOOKUP_OPEN is set and
__follow_mount returns true.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5c8ef80..b7c9747 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -839,6 +839,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	struct vfsmount *mnt = nd->path.mnt;
 	struct dentry *dentry = __d_lookup(nd->path.dentry, name);
+	int error = 0;
 
 	if (!dentry)
 		goto need_lookup;
@@ -847,8 +848,9 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
-	__follow_mount(path);
-	return 0;
+	if (__follow_mount(path))
+		error = open_reval_path(path, nd);
+	return error;
 
 need_lookup:
 	dentry = real_lookup(nd->path.dentry, name, nd);
@@ -1836,6 +1838,9 @@ do_last:
 		error = -ELOOP;
 		if (flag & O_NOFOLLOW)
 			goto exit_dput;
+		error = open_reval_path(&path, &nd);
+		if (error)
+			goto exit;
 	}
 
 	error = -ENOENT;
-- 
1.5.5.6

