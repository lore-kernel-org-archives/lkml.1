Return-Path: <linux-kernel-owner+w=401wt.eu-S2993175AbXDSISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993175AbXDSISX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993181AbXDSIEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:04:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45802 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993183AbXDSIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:04:09 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Neil Brown <neilb@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH] nfsv4 delegation: Convert to kthread API
Date: Thu, 19 Apr 2007 01:59:00 -0600
Message-Id: <1176969635120-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

To start the nfsv4-delegreturn thread this patch uses
kthread_run instead of a combination of kernel_thread
and daemonize.

In addition allow_signal(SIGKILL) is removed from
the expire delegations thread.

Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/nfs/delegation.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 841c99a..7b9b88c 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -232,7 +232,6 @@ int nfs_do_expire_all_delegations(void *ptr)
 	struct nfs_delegation *delegation;
 	struct inode *inode;
 
-	allow_signal(SIGKILL);
 restart:
 	spin_lock(&clp->cl_lock);
 	if (test_bit(NFS4CLNT_STATE_RECOVER, &clp->cl_state) != 0)
@@ -310,8 +309,6 @@ static int recall_thread(void *data)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_delegation *delegation;
 
-	daemonize("nfsv4-delegreturn");
-
 	nfs_msync_inode(inode);
 	down_read(&clp->cl_sem);
 	down_write(&nfsi->rwsem);
@@ -350,18 +347,18 @@ int nfs_async_inode_return_delegation(struct inode *inode, const nfs4_stateid *s
 		.inode = inode,
 		.stateid = stateid,
 	};
-	int status;
+	struct task_struct *task;
 
 	init_completion(&data.started);
 	__module_get(THIS_MODULE);
-	status = kernel_thread(recall_thread, &data, CLONE_KERNEL);
-	if (status < 0)
+	task = kthread_run(recall_thread, &data, "nfsv4-delegreturn");
+	if (IS_ERR(task))
 		goto out_module_put;
 	wait_for_completion(&data.started);
 	return data.result;
 out_module_put:
 	module_put(THIS_MODULE);
-	return status;
+	return PTR_ERR(task);
 }
 
 /*
-- 
1.5.0.g53756

