Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYERWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYERWCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYERWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:02:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:56694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYERWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pIeQhacRFlstdH177j1jFFtQgEobjLiOzxqoeIpmaiXCJtYWwmxZfeBl8eA3fzkLgukJ357KzWTbub317HchNEj0Qt4yNO85urOaZVawlsF/tPuSf1gkk5GlZ3MAMha6leDaZ9RS1BRC9wcuJkaodmP+S/F8nHjUbd9bOaXkdUE=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] vfs: open_exec cleanup
Date: Mon, 19 May 2008 00:01:49 +0200
Message-Id: <1211148109-16149-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

open_exec is needlessly indented, calls ERR_PTR with 0 argument
(which is not valid errno) and jumps into middle of function
just to return value.
So clean it up a bit.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/exec.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index aeaa979..ca8b512 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -656,34 +656,34 @@ struct file *open_exec(const char *name)
 	struct nameidata nd;
 	int err;
 	struct file *file;
+	struct inode *inode;
 
 	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd, FMODE_READ|FMODE_EXEC);
-	file = ERR_PTR(err);
-
-	if (!err) {
-		struct inode *inode = nd.path.dentry->d_inode;
-		file = ERR_PTR(-EACCES);
-		if (S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
-			file = ERR_PTR(err);
-			if (!err) {
-				file = nameidata_to_filp(&nd,
-							O_RDONLY|O_LARGEFILE);
-				if (!IS_ERR(file)) {
-					err = deny_write_access(file);
-					if (err) {
-						fput(file);
-						file = ERR_PTR(err);
-					}
+	if (err)
+		return ERR_PTR(err);
+
+	inode = nd.path.dentry->d_inode;
+	file = ERR_PTR(-EACCES);
+	if (S_ISREG(inode->i_mode)) {
+		int err = vfs_permission(&nd, MAY_EXEC);
+		if (!err) {
+			file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
+			if (!IS_ERR(file)) {
+				err = deny_write_access(file);
+				if (err) {
+					fput(file);
+					file = ERR_PTR(err);
 				}
-out:
-				return file;
 			}
+			goto out;
 		}
-		release_open_intent(&nd);
-		path_put(&nd.path);
+		else
+			file = ERR_PTR(err);
 	}
-	goto out;
+	release_open_intent(&nd);
+	path_put(&nd.path);
+out:
+	return file;
 }
 
 EXPORT_SYMBOL(open_exec);
-- 
1.5.4.5

