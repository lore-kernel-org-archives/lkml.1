Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZIQMmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZIQMmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZIQMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:42:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56454 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZIQMma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:42:30 -0400
Date: Thu, 17 Sep 2009 14:42:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no
Subject: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090917124233.GJ23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This can cause a hang on NFS umount, since the bdi gets pruned before we
flush any pending dirty IO. Peter, can you check whether it fixes your
issue?

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index de93569..f1cc058 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2190,8 +2190,8 @@ static void nfs_kill_super(struct super_block *s)
 {
 	struct nfs_server *server = NFS_SB(s);
 
-	bdi_unregister(&server->backing_dev_info);
 	kill_anon_super(s);
+	bdi_unregister(&server->backing_dev_info);
 	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }

-- 
Jens Axboe

