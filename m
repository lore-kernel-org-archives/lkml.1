Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509Ab0AKSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0AKSgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240Ab0AKSgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:36:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41847 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0AKSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:36:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] ecryptfs: Fix refcnt leak on ecryptfs_follow_link() error path
Date: Tue, 12 Jan 2010 03:36:14 +0900
Message-ID: <87my0kjxpd.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If ->follow_link handler return the error, it should decrement
nd->path refcnt. But, ecryptfs_follow_link() doesn't decrement.

This patch fix it by using usual nd_set_link() style error handling,
instead of playing with nd->path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/ecryptfs/inode.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/inode.c~namei-ecryptfs-follow_link-fix fs/ecryptfs/inode.c
--- linux-2.6/fs/ecryptfs/inode.c~namei-ecryptfs-follow_link-fix	2010-01-12 00:15:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/ecryptfs/inode.c	2010-01-12 00:15:10.000000000 +0900
@@ -715,7 +715,7 @@ static void *ecryptfs_follow_link(struct
 	/* Released in ecryptfs_put_link(); only release here on error */
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf) {
-		rc = -ENOMEM;
+		buf = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 	old_fs = get_fs();
@@ -723,23 +723,22 @@ static void *ecryptfs_follow_link(struct
 	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
 	set_fs(old_fs);
 	if (rc < 0)
-		goto out_free;
+		buf = ERR_PTR(rc);
 	else
 		buf[rc] = '\0';
-	rc = 0;
-	nd_set_link(nd, buf);
-	goto out;
-out_free:
-	kfree(buf);
 out:
-	return ERR_PTR(rc);
+	nd_set_link(nd, buf);
+	return NULL;
 }
 
 static void
 ecryptfs_put_link(struct dentry *dentry, struct nameidata *nd, void *ptr)
 {
-	/* Free the char* */
-	kfree(nd_get_link(nd));
+	char *buf = nd_get_link(nd);
+	if (!IS_ERR(buf)) {
+		/* Free the char* */
+		kfree(buf);
+	}
 }
 
 /**
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
