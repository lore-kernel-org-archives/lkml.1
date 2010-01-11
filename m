Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465Ab0AKSfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0AKSfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257Ab0AKSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:35:17 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41845 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0AKSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:35:16 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] vfs: Fix refcnt leak with __do_follow_link() in do_filp_open()
References: <87vdf8jxug.fsf@devron.myhome.or.jp>
Date: Tue, 12 Jan 2010 03:35:13 +0900
In-Reply-To: <87vdf8jxug.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 12 Jan 2010 03:33:11 +0900")
Message-ID: <87r5pwjxr2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed refcnt leak in do_filp_open() by recent change. Could you
review this one?


__do_follow_link() handles "nd->path and path" refcnt by special way.
If path->mnt == nd->path.mnt (i.e. those is sharing the refcnt), it
gets refcnt of path->mnt, to make simple error path of it.

So, we can't call __do_follow_link() twice without special care,
because it will get refcnt of path->mnt twice. (i.e. current
do_filp_open() is leaking path->mnt if first __do_follow_link()
returned -ESTALE and path->mnt != nd->path.mnt)

This moves the special refcnt handling from __do_follow_link() as
path_unshare_refcnt(). Then call it once for that do_filp_open() path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~namei-do_filp_open-fix fs/namei.c
--- linux-2.6/fs/namei.c~namei-do_filp_open-fix	2010-01-12 00:15:08.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2010-01-12 00:15:08.000000000 +0900
@@ -548,6 +548,18 @@ static inline void path_to_nameidata(str
 	nd->path.dentry = path->dentry;
 }
 
+/* NOTE: this is intended as special operation for __do_follow_link() */
+static inline void path_unshare_refcnt(struct path *path, struct nameidata *nd)
+{
+	if (path->mnt == nd->path.mnt)
+		mntget(path->mnt);
+}
+
+/*
+ * The caller should take special care about path and nd->path
+ * reference count. (e.g. to make simple error path, call
+ * path_unshare_refcnt() before this, etc.)
+ */
 static __always_inline int __do_follow_link(struct path *path, struct nameidata *nd)
 {
 	int error;
@@ -559,9 +571,8 @@ static __always_inline int __do_follow_l
 
 	if (path->mnt != nd->path.mnt) {
 		path_to_nameidata(path, nd);
-		dget(dentry);
+		path_get(path);
 	}
-	mntget(path->mnt);
 	cookie = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(cookie);
 	if (!IS_ERR(cookie)) {
@@ -602,6 +613,7 @@ static inline int do_follow_link(struct 
 	current->link_count++;
 	current->total_link_count++;
 	nd->depth++;
+	path_unshare_refcnt(path, nd);
 	err = __do_follow_link(path, nd);
 	path_put(path);
 	current->link_count--;
@@ -1856,6 +1868,7 @@ do_link:
 		goto exit_dput;
 	save = nd.path;
 	path_get(&save);
+	path_unshare_refcnt(&path, &nd);
 	error = __do_follow_link(&path, &nd);
 	if (error == -ESTALE) {
 		/* nd.path had been dropped */
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
