Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZGUGEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZGUGEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZGUGE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:59637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZGUGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:28 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Fix possible regressions when ->get_sb fails.
Date: Tue, 21 Jul 2009 00:03:51 -0600
Message-Id: <1248156236-3005-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->get_sb can fail causing some badness. this patch fixes
   * clear sb->fs_s_info in kill_sb.
   * deactivate_locked_super() calls kill_sb (v9fs_kill_super) which closes the
     destroys the client, clunks all its fids and closes the v9fs session.
     Attempting to do it twice will cause an oops.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 b5295fd... 2f8a3f2... M	fs/9p/vfs_super.c
 fs/9p/vfs_super.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index b5295fd..2f8a3f2 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -118,7 +118,6 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 
 	P9_DPRINTK(P9_DEBUG_VFS, " \n");
 
-	st = NULL;
 	v9ses = kzalloc(sizeof(struct v9fs_session_info), GFP_KERNEL);
 	if (!v9ses)
 		return -ENOMEM;
@@ -168,10 +167,8 @@ P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
 	simple_set_mnt(mnt, sb);
 	return 0;
 
-release_sb:
-	deactivate_locked_super(sb);
-
 free_stat:
+	p9stat_free(st);
 	kfree(st);
 
 clunk_fid:
@@ -180,7 +177,12 @@ clunk_fid:
 close_session:
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
+	return retval;
 
+release_sb:
+	p9stat_free(st);
+	kfree(st);
+	deactivate_locked_super(sb);
 	return retval;
 }
 
@@ -202,6 +204,7 @@ static void v9fs_kill_super(struct super_block *s)
 
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
+	s->s_fs_info = NULL;
 	P9_DPRINTK(P9_DEBUG_VFS, "exiting kill_super\n");
 }
 
-- 
1.6.0.4

