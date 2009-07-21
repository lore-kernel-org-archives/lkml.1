Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZGUGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZGUGEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZGUGEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:59637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZGUGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:30 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Fix possible memleak in v9fs_inode_from fid.
Date: Tue, 21 Jul 2009 00:03:53 -0600
Message-Id: <1248156236-3005-4-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing p9stat_free in v9fs_inode_from_fid to avoid
any possible leaks.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 81f8bbf... 5fda0a0... M	fs/9p/vfs_inode.c
 fs/9p/vfs_inode.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 81f8bbf..5fda0a0 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -338,30 +338,25 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 
 	ret = NULL;
 	st = p9_client_stat(fid);
-	if (IS_ERR(st)) {
-		err = PTR_ERR(st);
-		st = NULL;
-		goto error;
-	}
+	if (IS_ERR(st))
+		return ERR_CAST(st);
 
 	umode = p9mode2unixmode(v9ses, st->mode);
 	ret = v9fs_get_inode(sb, umode);
 	if (IS_ERR(ret)) {
 		err = PTR_ERR(ret);
-		ret = NULL;
 		goto error;
 	}
 
 	v9fs_stat2inode(st, ret, sb);
 	ret->i_ino = v9fs_qid2ino(&st->qid);
+	p9stat_free(st);
 	kfree(st);
 	return ret;
 
 error:
+	p9stat_free(st);
 	kfree(st);
-	if (ret)
-		iput(ret);
-
 	return ERR_PTR(err);
 }
 
-- 
1.6.0.4

