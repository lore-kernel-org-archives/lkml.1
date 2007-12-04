Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbXLDV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbXLDV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXLDV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:26:13 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:24204 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbXLDV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PgKw/llz2RjQYzHePoFyh5bIpQfqzIO4GvHOTwAxYnYFLt/kNzm1Kz9OCZ1b0CgSPXfulgziR4BvUqTgyl2aaT6AdQkd51zWPCxaAYAvF2rNuRUKsRS2tB14sCdrRdXoG1ZEz3gCWQJANsveG5OQ39RfY8m9Upvz71qWA2HKgjw=
Date: Tue, 4 Dec 2007 16:25:43 -0500
From: Liam Howlett <howlett@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.de, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: NFS Killable tasks request comments on patch
Message-ID: <20071204212543.GA6907@solidsnake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liam R. Howlett <howlett@gmail.com>

This patch builds on willy's TASK_INTERRUPTABLE and my own
TASK_KILLABLE patches that are currently in the mm branch.
( see http://lkml.org/lkml/2007/10/18/423 and
http://lkml.org/lkml/2007/11/28/127 )

This patch removes the rpc sigmask code and changes the
out_of_line_wait_on_bit and wait_on_bit calls in the sched.c file to
use TASK_KILLABLE.  The result of this patch is the ability to kill
commands issued to a dead NFS mount by the normal ctrl+c method.  I am
looking for help getting this to work with commands that use the stat
(and friends) system calls.  These system calls seem to use spinlocks
and are not killable-friendly due to the atomic operations involved.
Does anyone have any thoughts on the patch so far or the remaining
issues I am facing?

Please CC me on any responses.

Thanks,
Liam R. Howlett

---
 fs/nfs/direct.c          |    8 --------
 fs/nfs/inode.c           |    4 ----
 fs/nfs/nfs3proc.c        |    3 ---
 fs/nfs/nfs4proc.c        |    9 ---------
 fs/nfs/pagelist.c        |    4 ----
 fs/nfs/read.c            |    5 -----
 fs/nfs/write.c           |    5 -----
 include/linux/nfs_fs.h   |    2 --
 net/sunrpc/clnt.c        |   41 -----------------------------------------
 net/sunrpc/sched.c       |    4 ++--
 net/sunrpc/sunrpc_syms.c |    2 --
 11 files changed, 2 insertions(+), 85 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index afcab00..30eefa1 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -358,9 +358,7 @@ static ssize_t nfs_direct_read_schedule(struct nfs_direct_req *dreq, unsigned lo
 static ssize_t nfs_direct_read(struct kiocb *iocb, unsigned long user_addr, size_t count, loff_t pos)
 {
 	ssize_t result = 0;
-	sigset_t oldset;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	struct rpc_clnt *clnt = NFS_CLIENT(inode);
 	struct nfs_direct_req *dreq;
 
 	dreq = nfs_direct_req_alloc();
@@ -373,11 +371,9 @@ static ssize_t nfs_direct_read(struct kiocb *iocb, unsigned long user_addr, size
 		dreq->iocb = iocb;
 
 	nfs_add_stats(inode, NFSIOS_DIRECTREADBYTES, count);
-	rpc_clnt_sigmask(clnt, &oldset);
 	result = nfs_direct_read_schedule(dreq, user_addr, count, pos);
 	if (!result)
 		result = nfs_direct_wait(dreq);
-	rpc_clnt_sigunmask(clnt, &oldset);
 	nfs_direct_req_release(dreq);
 
 	return result;
@@ -700,9 +696,7 @@ static ssize_t nfs_direct_write_schedule(struct nfs_direct_req *dreq, unsigned l
 static ssize_t nfs_direct_write(struct kiocb *iocb, unsigned long user_addr, size_t count, loff_t pos)
 {
 	ssize_t result = 0;
-	sigset_t oldset;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	struct rpc_clnt *clnt = NFS_CLIENT(inode);
 	struct nfs_direct_req *dreq;
 	size_t wsize = NFS_SERVER(inode)->wsize;
 	int sync = 0;
@@ -722,11 +716,9 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, unsigned long user_addr, siz
 
 	nfs_add_stats(inode, NFSIOS_DIRECTWRITTENBYTES, count);
 
-	rpc_clnt_sigmask(clnt, &oldset);
 	result = nfs_direct_write_schedule(dreq, user_addr, count, pos, sync);
 	if (!result)
 		result = nfs_direct_wait(dreq);
-	rpc_clnt_sigunmask(clnt, &oldset);
 	nfs_direct_req_release(dreq);
 
 	return result;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index db5d96d..7fbf610 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -433,15 +433,11 @@ static int nfs_wait_schedule(void *word)
  */
 static int nfs_wait_on_inode(struct inode *inode)
 {
-	struct rpc_clnt	*clnt = NFS_CLIENT(inode);
 	struct nfs_inode *nfsi = NFS_I(inode);
-	sigset_t oldmask;
 	int error;
 
-	rpc_clnt_sigmask(clnt, &oldmask);
 	error = wait_on_bit_lock(&nfsi->flags, NFS_INO_REVALIDATING,
 					nfs_wait_schedule, TASK_INTERRUPTIBLE);
-	rpc_clnt_sigunmask(clnt, &oldmask);
 
 	return error;
 }
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 4cdc236..cf98de9 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -27,9 +27,7 @@
 static int
 nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 {
-	sigset_t oldset;
 	int res;
-	rpc_clnt_sigmask(clnt, &oldset);
 	do {
 		res = rpc_call_sync(clnt, msg, flags);
 		if (res != -EJUKEBOX)
@@ -37,7 +35,6 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 		schedule_timeout_interruptible(NFS_JUKEBOX_RETRY_TIME);
 		res = -ERESTARTSYS;
 	} while (!signalled());
-	rpc_clnt_sigunmask(clnt, &oldset);
 	return res;
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f03d9d5..c7d3955 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -316,12 +316,9 @@ static void nfs4_opendata_put(struct nfs4_opendata *p)
 
 static int nfs4_wait_for_completion_rpc_task(struct rpc_task *task)
 {
-	sigset_t oldset;
 	int ret;
 
-	rpc_clnt_sigmask(task->tk_client, &oldset);
 	ret = rpc_wait_for_completion_task(task);
-	rpc_clnt_sigunmask(task->tk_client, &oldset);
 	return ret;
 }
 
@@ -2816,18 +2813,15 @@ static int nfs4_wait_bit_interruptible(void *word)
 
 static int nfs4_wait_clnt_recover(struct rpc_clnt *clnt, struct nfs_client *clp)
 {
-	sigset_t oldset;
 	int res;
 
 	might_sleep();
 
 	rwsem_acquire(&clp->cl_sem.dep_map, 0, 0, _RET_IP_);
 
-	rpc_clnt_sigmask(clnt, &oldset);
 	res = wait_on_bit(&clp->cl_state, NFS4CLNT_STATE_RECOVER,
 			nfs4_wait_bit_interruptible,
 			TASK_INTERRUPTIBLE);
-	rpc_clnt_sigunmask(clnt, &oldset);
 
 	rwsem_release(&clp->cl_sem.dep_map, 1, _RET_IP_);
 	return res;
@@ -2835,7 +2829,6 @@ static int nfs4_wait_clnt_recover(struct rpc_clnt *clnt, struct nfs_client *clp)
 
 static int nfs4_delay(struct rpc_clnt *clnt, long *timeout)
 {
-	sigset_t oldset;
 	int res = 0;
 
 	might_sleep();
@@ -2844,14 +2837,12 @@ static int nfs4_delay(struct rpc_clnt *clnt, long *timeout)
 		*timeout = NFS4_POLL_RETRY_MIN;
 	if (*timeout > NFS4_POLL_RETRY_MAX)
 		*timeout = NFS4_POLL_RETRY_MAX;
-	rpc_clnt_sigmask(clnt, &oldset);
 	if (clnt->cl_intr) {
 		schedule_timeout_interruptible(*timeout);
 		if (signalled())
 			res = -ERESTARTSYS;
 	} else
 		schedule_timeout_uninterruptible(*timeout);
-	rpc_clnt_sigunmask(clnt, &oldset);
 	*timeout <<= 1;
 	return res;
 }
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 345bb9b..e72c007 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -196,8 +196,6 @@ static int nfs_wait_bit_interruptible(void *word)
 int
 nfs_wait_on_request(struct nfs_page *req)
 {
-	struct rpc_clnt *clnt = NFS_CLIENT(req->wb_context->path.dentry->d_inode);
-	sigset_t oldmask;
 	int ret = 0;
 
 	if (!test_bit(PG_BUSY, &req->wb_flags))
@@ -206,10 +204,8 @@ nfs_wait_on_request(struct nfs_page *req)
 	 * Note: the call to rpc_clnt_sigmask() suffices to ensure that we
 	 *	 are not interrupted if intr flag is not set
 	 */
-	rpc_clnt_sigmask(clnt, &oldmask);
 	ret = out_of_line_wait_on_bit(&req->wb_flags, PG_BUSY,
 			nfs_wait_bit_interruptible, TASK_INTERRUPTIBLE);
-	rpc_clnt_sigunmask(clnt, &oldmask);
 out:
 	return ret;
 }
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 4587a86..3dcaa6a 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -212,12 +212,7 @@ nfs_async_read_error(struct list_head *head)
  */
 static void nfs_execute_read(struct nfs_read_data *data)
 {
-	struct rpc_clnt *clnt = NFS_CLIENT(data->inode);
-	sigset_t oldset;
-
-	rpc_clnt_sigmask(clnt, &oldset);
 	rpc_execute(&data->task);
-	rpc_clnt_sigunmask(clnt, &oldset);
 }
 
 /*
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 89527a4..8dca8c5 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -816,12 +816,7 @@ static void nfs_write_rpcsetup(struct nfs_page *req,
 
 static void nfs_execute_write(struct nfs_write_data *data)
 {
-	struct rpc_clnt *clnt = NFS_CLIENT(data->inode);
-	sigset_t oldset;
-
-	rpc_clnt_sigmask(clnt, &oldset);
 	rpc_execute(&data->task);
-	rpc_clnt_sigunmask(clnt, &oldset);
 }
 
 /*
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index e82a6eb..b87f428 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -520,9 +520,7 @@ extern void * nfs_root_data(void);
 	int __retval = 0;						\
 	if (clnt->cl_intr) {						\
 		sigset_t oldmask;					\
-		rpc_clnt_sigmask(clnt, &oldmask);			\
 		__retval = wait_event_interruptible(wq, condition);	\
-		rpc_clnt_sigunmask(clnt, &oldmask);			\
 	} else								\
 		wait_event(wq, condition);				\
 	__retval;							\
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 76be83e..b7aca2e 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -480,44 +480,6 @@ static const struct rpc_call_ops rpc_default_ops = {
 	.rpc_call_done = rpc_default_callback,
 };
 
-/*
- *	Export the signal mask handling for synchronous code that
- *	sleeps on RPC calls
- */
-#define RPC_INTR_SIGNALS (sigmask(SIGHUP) | sigmask(SIGINT) | sigmask(SIGQUIT) | sigmask(SIGTERM))
-
-static void rpc_save_sigmask(sigset_t *oldset, int intr)
-{
-	unsigned long	sigallow = sigmask(SIGKILL);
-	sigset_t sigmask;
-
-	/* Block all signals except those listed in sigallow */
-	if (intr)
-		sigallow |= RPC_INTR_SIGNALS;
-	siginitsetinv(&sigmask, sigallow);
-	sigprocmask(SIG_BLOCK, &sigmask, oldset);
-}
-
-static inline void rpc_task_sigmask(struct rpc_task *task, sigset_t *oldset)
-{
-	rpc_save_sigmask(oldset, !RPC_TASK_UNINTERRUPTIBLE(task));
-}
-
-static inline void rpc_restore_sigmask(sigset_t *oldset)
-{
-	sigprocmask(SIG_SETMASK, oldset, NULL);
-}
-
-void rpc_clnt_sigmask(struct rpc_clnt *clnt, sigset_t *oldset)
-{
-	rpc_save_sigmask(oldset, clnt->cl_intr);
-}
-
-void rpc_clnt_sigunmask(struct rpc_clnt *clnt, sigset_t *oldset)
-{
-	rpc_restore_sigmask(oldset);
-}
-
 static
 struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 		struct rpc_message *msg,
@@ -526,7 +488,6 @@ struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 		void *data)
 {
 	struct rpc_task *task, *ret;
-	sigset_t oldset;
 
 	task = rpc_new_task(clnt, flags, ops, data);
 	if (task == NULL) {
@@ -535,7 +496,6 @@ struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 	}
 
 	/* Mask signals on synchronous RPC calls and RPCSEC_GSS upcalls */
-	rpc_task_sigmask(task, &oldset);
 	if (msg != NULL) {
 		rpc_call_setup(task, msg, 0);
 		if (task->tk_status != 0) {
@@ -548,7 +508,6 @@ struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 	rpc_execute(task);
 	ret = task;
 out:
-	rpc_restore_sigmask(&oldset);
 	return ret;
 }
 
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index c98873f..f67dba7 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -301,7 +301,7 @@ int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(void *))
 	if (action == NULL)
 		action = rpc_wait_bit_interruptible;
 	return wait_on_bit(&task->tk_runstate, RPC_TASK_ACTIVE,
-			action, TASK_INTERRUPTIBLE);
+			action, TASK_KILLABLE);
 }
 EXPORT_SYMBOL(__rpc_wait_for_completion_task);
 
@@ -693,7 +693,7 @@ static void __rpc_execute(struct rpc_task *task)
 		/* Note: Caller should be using rpc_clnt_sigmask() */
 		status = out_of_line_wait_on_bit(&task->tk_runstate,
 				RPC_TASK_QUEUED, rpc_wait_bit_interruptible,
-				TASK_INTERRUPTIBLE);
+				TASK_KILLABLE);
 		if (status == -ERESTARTSYS) {
 			/*
 			 * When a sync task receives a signal, it exits with
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index 33d89e8..1fd3aa8 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -38,8 +38,6 @@ EXPORT_SYMBOL(rpc_killall_tasks);
 EXPORT_SYMBOL(rpc_call_sync);
 EXPORT_SYMBOL(rpc_call_async);
 EXPORT_SYMBOL(rpc_call_setup);
-EXPORT_SYMBOL(rpc_clnt_sigmask);
-EXPORT_SYMBOL(rpc_clnt_sigunmask);
 EXPORT_SYMBOL(rpc_delay);
 EXPORT_SYMBOL(rpc_restart_call);
 EXPORT_SYMBOL(rpc_setbufsize);
-- 
1.5.2.5

