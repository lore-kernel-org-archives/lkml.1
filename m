Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXJWXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXJWXqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXJWXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:46:34 -0400
Received: from 70-56-216-30.albq.qwest.net ([70.56.216.30]:59718 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbXJWXqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:46:33 -0400
Date: Tue, 23 Oct 2007 17:46:32 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: fix memory leak in v9fs_get_sb
Message-ID: <20071023234632.GA10391@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak in v9fs_get_sb.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 77250c234636881976ebd567f9edc7c36711bd4a
tree 35d683472542706a3b78eb51bc29b92f690c314a
parent 01e7ae8c13bb06a2ce622ebace33bb7e28ef596c
author Latchesar Ionkov <lucho@ionkov.net> 1193169149 -0600
committer Latchesar Ionkov <lucho@ionkov.net> 1193169149 -0600

 fs/9p/vfs_super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index bb0cef9..678c02f 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -119,6 +119,7 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 
 	P9_DPRINTK(P9_DEBUG_VFS, " \n");
 
+	st = NULL;
 	v9ses = kzalloc(sizeof(struct v9fs_session_info), GFP_KERNEL);
 	if (!v9ses)
 		return -ENOMEM;
@@ -164,10 +165,12 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
 	v9fs_stat2inode(st, root->d_inode, sb);
 	v9fs_fid_add(root, fid);
+	kfree(st);
 
 	return simple_set_mnt(mnt, sb);
 
 error:
+	kfree(st);
 	if (fid)
 		p9_client_clunk(fid);
 
