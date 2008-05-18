Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYERWEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYERWEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYERWEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:04:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:58301 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYERWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v0nD4VmcoujEnY/lRkDKX0ZNq+/vbc4OqUTdNn2Rgw829OEUYiKwwI8UQDiv+FLAvSgkQyF5ytVyKx622r25Fa1/BI4+Xsnpwk4VTCShjDvLmFqTQ279/31xZGXmLZ1/IkoqkGV5Bxyd13Y2VVjEg8Lu0vDV7ijA2oFPlq/qAmc=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] vfs: fix ERR_PTR abuse in generic_readlink
Date: Mon, 19 May 2008 00:03:57 +0200
Message-Id: <1211148237-16207-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_readlink calls ERR_PTR for negative and positive values
(vfs_readlink returns length of "link"), but it should not
(not an errno) and does not need to.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 32fd965..959523d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2853,16 +2853,17 @@ int generic_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 {
 	struct nameidata nd;
 	void *cookie;
+	int res;
 
 	nd.depth = 0;
 	cookie = dentry->d_inode->i_op->follow_link(dentry, &nd);
-	if (!IS_ERR(cookie)) {
-		int res = vfs_readlink(dentry, buffer, buflen, nd_get_link(&nd));
-		if (dentry->d_inode->i_op->put_link)
-			dentry->d_inode->i_op->put_link(dentry, &nd, cookie);
-		cookie = ERR_PTR(res);
-	}
-	return PTR_ERR(cookie);
+	if (IS_ERR(cookie))
+		return PTR_ERR(cookie);
+
+	res = vfs_readlink(dentry, buffer, buflen, nd_get_link(&nd));
+	if (dentry->d_inode->i_op->put_link)
+		dentry->d_inode->i_op->put_link(dentry, &nd, cookie);
+	return res;
 }
 
 int vfs_follow_link(struct nameidata *nd, const char *link)
-- 
1.5.4.5

