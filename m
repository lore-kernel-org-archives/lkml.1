Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYC2Mtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYC2Mtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYC2MtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:49:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYC2MtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:49:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SUNRPC: have soft RPC tasks return -ETIMEDOUT instead of -EIO on major connect timeout
Date: Sat, 29 Mar 2008 08:49:17 -0400
Message-Id: <1206794957-17010-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFSv4 background mounts do not currently work correctly. While we could
try to fix this in userspace, I think it's really a kernel problem...

When a soft RPC tasks experiences a major timeout during a connection
attempt, it does an rpc_exit with a return code of -EIO. For NFSv4
mounts, this makes the mount() syscall return -EIO. mount.nfs4 then
interprets that as a "permanent" error, and won't attempt a background
mount when bg is specified. Fix this by making call_timeout() do the
rpc_exit() with an error of -ETIMEDOUT.

This fixes the background mount issue, but does make other syscalls
on soft mounts return ETIMEDOUT instead of EIO in this situation.

Comments welcome.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 net/sunrpc/clnt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 8c6a7f1..b6d409e 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1162,7 +1162,7 @@ call_timeout(struct rpc_task *task)
 	if (RPC_IS_SOFT(task)) {
 		printk(KERN_NOTICE "%s: server %s not responding, timed out\n",
 				clnt->cl_protname, clnt->cl_server);
-		rpc_exit(task, -EIO);
+		rpc_exit(task, -ETIMEDOUT);
 		return;
 	}
 
-- 
1.5.3.6

