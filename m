Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZERQKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZERQKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZERQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:41553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 26/32] union-mount: call do_whiteout() on unlink and rmdir
Date: Mon, 18 May 2009 18:09:22 +0200
Message-Id: <1242662968-11684-27-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call do_whiteout() when removing files and directories.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 78eb973..4d68597 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2825,6 +2825,10 @@ static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
 	if (err)
 		goto out;
 
+	err = -ENOENT;
+	if (!dentry->d_inode)
+		goto out;
+
 	err = -ENOTEMPTY;
 	if (isdir && !directory_is_empty(path->dentry, path->mnt))
 		goto out;
@@ -2939,6 +2943,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (error)
 		goto exit2;
+	if (is_unionized(nd.path.dentry, nd.path.mnt)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit3;
+	}
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
@@ -3027,6 +3035,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		inode = path.dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		if (is_unionized(nd.path.dentry, nd.path.mnt)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit2;
+		}
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-- 
1.6.1.3

