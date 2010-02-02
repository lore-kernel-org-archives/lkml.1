Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0BBJ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0BBJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:56:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Fix refcnt leak on gfs2_follow_link() error path
Date: Tue,  2 Feb 2010 09:47:22 +0000
Message-Id: <1265104045-15957-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265104045-15957-1-git-send-email-swhiteho@redhat.com>
References: <1265104045-15957-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

If ->follow_link handler return the error, it should decrement
nd->path refcnt.

This patch fix it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/ops_inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 78f73ca..84350e1 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1088,7 +1088,8 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 		error = vfs_follow_link(nd, buf);
 		if (buf != array)
 			kfree(buf);
-	}
+	} else
+		path_put(&nd->path);
 
 	return ERR_PTR(error);
 }
-- 
1.6.2.5

