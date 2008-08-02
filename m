Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYHBMdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYHBMdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 08:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYHBMdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 08:33:36 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:59259 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYHBMdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 08:33:36 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2008 08:33:35 EDT
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 14:10:27 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Trond Myklebust <Trond.Myklebust@netapp.com>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] NFS: Ensure we call nfs_sb_deactive() after releasing
 the directory inode
Reply-To: oliver.pntr@gmail.com
Message-ID: <ec5c3df63eafa2691665b95e989d7c3c@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 744d18dbfae07482ea461701b0aaec3a75ec9224 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sun, 27 Jul 2008 18:03:19 -0400
Subject: [PATCH] NFS: Ensure we call nfs_sb_deactive() after releasing the
directory inode

[ Upstream commit 744d18dbfae07482ea461701b0aaec3a75ec9224 ]

In order to avoid the "Busy inodes after unmount" error message, we need to
ensure that nfs_async_unlink_release() releases the super block after the
call to nfs_free_unlinkdata().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 3adf8b2..f089e58 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -95,10 +95,11 @@ static void nfs_async_unlink_done(struct rpc_task
*task, void *calldata)
 static void nfs_async_unlink_release(void *calldata)
 {
 	struct nfs_unlinkdata	*data = calldata;
+	struct super_block *sb = data->dir->i_sb;
 
 	nfs_dec_sillycount(data->dir);
-	nfs_sb_deactive(NFS_SERVER(data->dir));
 	nfs_free_unlinkdata(data);
+	nfs_sb_deactive(NFS_SB(sb));
 }
 
 static const struct rpc_call_ops nfs_unlink_ops = {


