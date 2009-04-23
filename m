Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZDWTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZDWTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbZDWTMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:3560 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbZDWTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Nx4GhXmYb2NRjqG5+cMapX+/vYOV/yhlDSaEAIaSGXY1TdLTJXOMGU0hEASOQGaWa8
         easiRnPiE05JSEpEnrn6e8Q5Bs3o1MhBowU6shcvyBIBImSomarNiF38ZzcgpC85agNB
         tQgbfFomkncWfwrFxPAE5Okx6cKDZh2Hqh1vs=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 4/5 -tip] nfs: umount_begin BKL pushdown
Date: Thu, 23 Apr 2009 21:12:04 +0200
Message-Id: <1240513925-5603-5-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240513925-5603-4-git-send-email-abogani@texware.it>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
 <1240513925-5603-2-git-send-email-abogani@texware.it>
 <1240513925-5603-3-git-send-email-abogani@texware.it>
 <1240513925-5603-4-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/nfs/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6717200..1679a16 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -683,9 +683,12 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
  */
 static void nfs_umount_begin(struct super_block *sb)
 {
-	struct nfs_server *server = NFS_SB(sb);
+	struct nfs_server *server;
 	struct rpc_clnt *rpc;
 
+	lock_kernel();
+
+	server = NFS_SB(sb);
 	/* -EIO all pending I/O */
 	rpc = server->client_acl;
 	if (!IS_ERR(rpc))
@@ -693,6 +696,8 @@ static void nfs_umount_begin(struct super_block *sb)
 	rpc = server->client;
 	if (!IS_ERR(rpc))
 		rpc_killall_tasks(rpc);
+
+	unlock_kernel();
 }
 
 /*
-- 
1.6.0.4

