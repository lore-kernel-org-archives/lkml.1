Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563Ab0AKSht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0AKSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496Ab0AKShs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:37:48 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41853 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab0AKShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:37:48 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] ocfs2: Fix refcnt leak on ocfs2_fast_follow_link() error path
Date: Tue, 12 Jan 2010 03:37:45 +0900
Message-ID: <87eilwjxmu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If ->follow_link handler return the error, it should decrement
nd->path refcnt. But, ocfs2_fast_follow_link() doesn't decrement.

This patch fix it by using usual nd_set_link() style error handling,
instead of playing with nd->path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/ocfs2/symlink.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/symlink.c~namei-ocfs2-follow_link-fix fs/ocfs2/symlink.c
--- linux-2.6/fs/ocfs2/symlink.c~namei-ocfs2-follow_link-fix	2010-01-12 00:15:14.000000000 +0900
+++ linux-2.6-hirofumi/fs/ocfs2/symlink.c	2010-01-12 00:15:14.000000000 +0900
@@ -137,20 +137,20 @@ static void *ocfs2_fast_follow_link(stru
 	}
 
 	memcpy(link, target, len);
-	nd_set_link(nd, link);
 
 bail:
+	nd_set_link(nd, status ? ERR_PTR(status) : link);
 	brelse(bh);
 
 	mlog_exit(status);
-	return status ? ERR_PTR(status) : link;
+	return NULL;
 }
 
 static void ocfs2_fast_put_link(struct dentry *dentry, struct nameidata *nd, void *cookie)
 {
-	char *link = cookie;
-
-	kfree(link);
+	char *link = nd_get_link(nd);
+	if (!IS_ERR(link))
+		kfree(link);
 }
 
 const struct inode_operations ocfs2_symlink_inode_operations = {
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
