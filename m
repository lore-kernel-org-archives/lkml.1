Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXAXUVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXAXUVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXAXUUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:20:42 -0500
Received: from dsl081-065-125.sfo1.dsl.speakeasy.net ([64.81.65.125]:57417
	"EHLO lade.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXAXUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:20:40 -0500
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 15:20:40 EST
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 1/3] NFS: Fix Oops in rpc_call_sync()
Date: Wed, 24 Jan 2007 11:54:53 -0800
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net, sds@tycho.nsa.gov
Message-Id: <20070124195453.21259.74390.stgit@lade.trondhjem.org>
In-Reply-To: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
References: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Fix the Oops in http://bugzilla.linux-nfs.org/show_bug.cgi?id=138
We shouldn't be calling rpc_release_task() for tasks that are not active.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 include/linux/sunrpc/sched.h |    1 -
 net/sunrpc/clnt.c            |    8 +++-----
 net/sunrpc/sched.c           |    3 ++-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 97c7616..8b6ce60 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -250,7 +250,6 @@ void		rpc_init_task(struct rpc_task *tas
 				int flags, const struct rpc_call_ops *ops,
 				void *data);
 void		rpc_put_task(struct rpc_task *);
-void		rpc_release_task(struct rpc_task *);
 void		rpc_exit_task(struct rpc_task *);
 void		rpc_release_calldata(const struct rpc_call_ops *, void *);
 void		rpc_killall_tasks(struct rpc_clnt *);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index aba528b..16c9fbc 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -490,16 +490,14 @@ int rpc_call_sync(struct rpc_clnt *clnt,
 
 	/* Set up the call info struct and execute the task */
 	status = task->tk_status;
-	if (status != 0) {
-		rpc_release_task(task);
+	if (status != 0)
 		goto out;
-	}
 	atomic_inc(&task->tk_count);
 	status = rpc_execute(task);
 	if (status == 0)
 		status = task->tk_status;
-	rpc_put_task(task);
 out:
+	rpc_put_task(task);
 	rpc_restore_sigmask(&oldset);
 	return status;
 }
@@ -537,7 +535,7 @@ rpc_call_async(struct rpc_clnt *clnt, st
 	if (status == 0)
 		rpc_execute(task);
 	else
-		rpc_release_task(task);
+		rpc_put_task(task);
 
 	rpc_restore_sigmask(&oldset);		
 	return status;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 79bc4cd..fc083f0 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -42,6 +42,7 @@ static mempool_t	*rpc_buffer_mempool __r
 static void			__rpc_default_timer(struct rpc_task *task);
 static void			rpciod_killall(void);
 static void			rpc_async_schedule(struct work_struct *);
+static void			 rpc_release_task(struct rpc_task *task);
 
 /*
  * RPC tasks sit here while waiting for conditions to improve.
@@ -896,7 +897,7 @@ void rpc_put_task(struct rpc_task *task)
 }
 EXPORT_SYMBOL(rpc_put_task);
 
-void rpc_release_task(struct rpc_task *task)
+static void rpc_release_task(struct rpc_task *task)
 {
 #ifdef RPC_DEBUG
 	BUG_ON(task->tk_magic != RPC_TASK_MAGIC_ID);
