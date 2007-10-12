Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbXJLQQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbXJLQQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXJLQHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760459AbXJLQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/52] CRED: Pass credentials into rpc_init_task()
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:01 +0100
Message-ID: <20071012160701.15119.64841.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials into rpc_init_task().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/lockd/clntlock.c            |    2 
 fs/lockd/clntproc.c            |   34 ++-
 fs/lockd/host.c                |    6 
 fs/lockd/mon.c                 |   21 +-
 fs/lockd/svc.c                 |    2 
 fs/lockd/svc4proc.c            |    6 
 fs/lockd/svclock.c             |   13 +
 fs/lockd/svcproc.c             |    7 -
 fs/nfs/callback.c              |    2 
 fs/nfs/callback.h              |    2 
 fs/nfs/client.c                |  103 +++++---
 fs/nfs/delegation.c            |   24 +-
 fs/nfs/delegation.h            |   10 +
 fs/nfs/dir.c                   |  111 ++++++---
 fs/nfs/direct.c                |   29 +-
 fs/nfs/file.c                  |   14 +
 fs/nfs/getroot.c               |   22 +-
 fs/nfs/inode.c                 |   45 +++-
 fs/nfs/internal.h              |   24 +-
 fs/nfs/mount_clnt.c            |    7 -
 fs/nfs/namespace.c             |    5 
 fs/nfs/nfs3acl.c               |   43 ++-
 fs/nfs/nfs3proc.c              |  130 ++++++----
 fs/nfs/nfs4_fs.h               |   30 ++
 fs/nfs/nfs4namespace.c         |    7 -
 fs/nfs/nfs4proc.c              |  496 ++++++++++++++++++++++++----------------
 fs/nfs/nfs4renewd.c            |    2 
 fs/nfs/nfs4state.c             |   16 +
 fs/nfs/proc.c                  |   99 ++++----
 fs/nfs/read.c                  |    7 -
 fs/nfs/super.c                 |   41 ++-
 fs/nfs/symlink.c               |   24 ++
 fs/nfs/unlink.c                |   18 +
 fs/nfs/write.c                 |   17 +
 include/linux/lockd/bind.h     |    5 
 include/linux/lockd/lockd.h    |    5 
 include/linux/lockd/sm_inter.h |    4 
 include/linux/nfs_fs.h         |   38 ++-
 include/linux/nfs_xdr.h        |   54 +++-
 include/linux/sunrpc/clnt.h    |   10 -
 include/linux/sunrpc/sched.h   |   13 +
 net/sunrpc/auth_gss/auth_gss.c |    2 
 net/sunrpc/clnt.c              |   50 +++-
 net/sunrpc/rpcb_clnt.c         |   14 +
 net/sunrpc/sched.c             |   22 +-
 net/sunrpc/svc.c               |    5 
 46 files changed, 980 insertions(+), 661 deletions(-)

diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index d070b18..653a83e 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -174,7 +174,7 @@ reclaimer(void *ptr)
 	/* This one ensures that our parent doesn't terminate while the
 	 * reclaim is in progress */
 	lock_kernel();
-	lockd_up(0); /* note: this cannot fail as lockd is already running */
+	lockd_up(0, &init_cred); /* note: this cannot fail as lockd is already running */
 
 	dprintk("lockd: reclaiming locks for host %s\n", host->h_name);
 
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index a10343b..fde8f25 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -28,7 +28,8 @@ static int	nlmclnt_lock(struct nlm_rqst *, struct file_lock *);
 static int	nlmclnt_unlock(struct nlm_rqst *, struct file_lock *);
 static int	nlm_stat_to_errno(__be32 stat);
 static void	nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host);
-static int	nlmclnt_cancel(struct nlm_host *, int , struct file_lock *);
+static int	nlmclnt_cancel(struct nlm_host *, int , struct file_lock *,
+			       struct cred *);
 
 static const struct rpc_call_ops nlmclnt_unlock_ops;
 static const struct rpc_call_ops nlmclnt_cancel_ops;
@@ -149,7 +150,8 @@ static void nlmclnt_release_lockargs(struct nlm_rqst *req)
  * This is the main entry point for the NLM client.
  */
 int
-nlmclnt_proc(struct inode *inode, int cmd, struct file_lock *fl)
+nlmclnt_proc(struct inode *inode, int cmd, struct file_lock *fl,
+	     struct cred *acred)
 {
 	struct rpc_clnt		*client = NFS_CLIENT(inode);
 	struct sockaddr_in	addr;
@@ -173,7 +175,7 @@ nlmclnt_proc(struct inode *inode, int cmd, struct file_lock *fl)
 	if (host == NULL)
 		return -ENOLCK;
 
-	call = nlm_alloc_call(host);
+	call = nlm_alloc_call(host, acred);
 	if (call == NULL)
 		return -ENOMEM;
 
@@ -227,7 +229,7 @@ EXPORT_SYMBOL(nlmclnt_proc);
  * Note: the caller must hold a reference to host. In case of failure,
  * this reference will be released.
  */
-struct nlm_rqst *nlm_alloc_call(struct nlm_host *host)
+struct nlm_rqst *nlm_alloc_call(struct nlm_host *host, struct cred *acred)
 {
 	struct nlm_rqst	*call;
 
@@ -237,6 +239,7 @@ struct nlm_rqst *nlm_alloc_call(struct nlm_host *host)
 			locks_init_lock(&call->a_args.lock.fl);
 			locks_init_lock(&call->a_res.lock.fl);
 			call->a_host = host;
+			call->a_acred = get_cred(acred);
 			return call;
 		}
 		if (signalled())
@@ -252,10 +255,11 @@ void nlm_release_call(struct nlm_rqst *call)
 {
 	nlm_release_host(call->a_host);
 	nlmclnt_release_lockargs(call);
+	put_cred(call->a_acred);
 	kfree(call);
 }
 
-static void nlmclnt_rpc_release(void *data)
+static void nlmclnt_rpc_release(struct cred *acred, void *data)
 {
 	return nlm_release_call(data);
 }
@@ -300,12 +304,12 @@ nlmclnt_call(struct nlm_rqst *req, u32 proc)
 			goto in_grace_period;
 
 		/* If we have no RPC client yet, create one. */
-		if ((clnt = nlm_bind_host(host)) == NULL)
+		if ((clnt = nlm_bind_host(host, req->a_acred)) == NULL)
 			return -ENOLCK;
 		msg.rpc_proc = &clnt->cl_procinfo[proc];
 
 		/* Perform the RPC call. If an error occurs, try again */
-		if ((status = rpc_call_sync(clnt, &msg, 0)) < 0) {
+		if ((status = rpc_call_sync(clnt, &msg, 0, req->a_acred)) < 0) {
 			dprintk("lockd: rpc_call returned error %d\n", -status);
 			switch (status) {
 			case -EPROTONOSUPPORT:
@@ -365,15 +369,16 @@ static int __nlm_async_call(struct nlm_rqst *req, u32 proc, struct rpc_message *
 			(int)proc, host->h_name);
 
 	/* If we have no RPC client yet, create one. */
-	clnt = nlm_bind_host(host);
+	clnt = nlm_bind_host(host, req->a_acred);
 	if (clnt == NULL)
 		goto out_err;
 	msg->rpc_proc = &clnt->cl_procinfo[proc];
 
         /* bootstrap and kick off the async RPC call */
-        return rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req);
+        return rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req,
+			      req->a_acred);
 out_err:
-	tk_ops->rpc_release(req);
+	tk_ops->rpc_release(req->a_acred, req);
 	return -ENOLCK;
 }
 
@@ -499,7 +504,7 @@ nlmclnt_lock(struct nlm_rqst *req, struct file_lock *fl)
 	unsigned char fl_flags = fl->fl_flags;
 	int status = -ENOLCK;
 
-	if (nsm_monitor(host) < 0) {
+	if (nsm_monitor(host, req->a_acred) < 0) {
 		printk(KERN_NOTICE "lockd: failed to monitor %s\n",
 					host->h_name);
 		goto out;
@@ -553,7 +558,7 @@ out_unblock:
 	nlmclnt_finish_block(block);
 	/* Cancel the blocked request if it is still pending */
 	if (resp->status == nlm_lck_blocked)
-		nlmclnt_cancel(host, req->a_args.block, fl);
+		nlmclnt_cancel(host, req->a_args.block, fl, req->a_acred);
 out:
 	nlm_release_call(req);
 	fl->fl_flags = fl_flags;
@@ -681,7 +686,8 @@ static const struct rpc_call_ops nlmclnt_unlock_ops = {
  * We always use an async RPC call for this in order not to hang a
  * process that has been Ctrl-C'ed.
  */
-static int nlmclnt_cancel(struct nlm_host *host, int block, struct file_lock *fl)
+static int nlmclnt_cancel(struct nlm_host *host, int block,
+			  struct file_lock *fl, struct cred *acred)
 {
 	struct nlm_rqst	*req;
 	unsigned long	flags;
@@ -695,7 +701,7 @@ static int nlmclnt_cancel(struct nlm_host *host, int block, struct file_lock *fl
 	recalc_sigpending();
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 
-	req = nlm_alloc_call(nlm_get_host(host));
+	req = nlm_alloc_call(nlm_get_host(host), acred);
 	if (!req)
 		return -ENOMEM;
 	req->a_flags = RPC_TASK_ASYNC;
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 572601e..15071a2 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -163,7 +163,7 @@ nlm_destroy_host(struct nlm_host *host)
 	/*
 	 * Release NSM handle and unmonitor host.
 	 */
-	nsm_unmonitor(host);
+	nsm_unmonitor(host, current->cred);
 
 	clnt = host->h_rpcclnt;
 	if (clnt != NULL)
@@ -203,7 +203,7 @@ nlmsvc_lookup_host(struct svc_rqst *rqstp,
  * Create the NLM RPC client for an NLM peer
  */
 struct rpc_clnt *
-nlm_bind_host(struct nlm_host *host)
+nlm_bind_host(struct nlm_host *host, struct cred *acred)
 {
 	struct rpc_clnt	*clnt;
 
@@ -246,7 +246,7 @@ nlm_bind_host(struct nlm_host *host)
 					   RPC_CLNT_CREATE_AUTOBIND),
 		};
 
-		clnt = rpc_create(&args);
+		clnt = rpc_create(&args, acred);
 		if (!IS_ERR(clnt))
 			host->h_rpcclnt = clnt;
 		else {
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 3353ed8..f2ca99f 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -17,7 +17,7 @@
 
 #define NLMDBG_FACILITY		NLMDBG_MONITOR
 
-static struct rpc_clnt *	nsm_create(void);
+static struct rpc_clnt *	nsm_create(struct cred *);
 
 static struct rpc_program	nsm_program;
 
@@ -30,7 +30,8 @@ int				nsm_local_state;
  * Common procedure for SM_MON/SM_UNMON calls
  */
 static int
-nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res)
+nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res,
+	      struct cred *acred)
 {
 	struct rpc_clnt	*clnt;
 	int		status;
@@ -40,7 +41,7 @@ nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res)
 		.rpc_resp	= res,
 	};
 
-	clnt = nsm_create();
+	clnt = nsm_create(acred);
 	if (IS_ERR(clnt)) {
 		status = PTR_ERR(clnt);
 		goto out;
@@ -55,7 +56,7 @@ nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res)
 	memset(res, 0, sizeof(*res));
 
 	msg.rpc_proc = &clnt->cl_procinfo[proc];
-	status = rpc_call_sync(clnt, &msg, 0);
+	status = rpc_call_sync(clnt, &msg, 0, acred);
 	if (status < 0)
 		printk(KERN_DEBUG "nsm_mon_unmon: rpc failed, status=%d\n",
 			status);
@@ -70,7 +71,7 @@ nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res)
  * Set up monitoring of a remote host
  */
 int
-nsm_monitor(struct nlm_host *host)
+nsm_monitor(struct nlm_host *host, struct cred *acred)
 {
 	struct nsm_handle *nsm = host->h_nsmhandle;
 	struct nsm_res	res;
@@ -82,7 +83,7 @@ nsm_monitor(struct nlm_host *host)
 	if (nsm->sm_monitored)
 		return 0;
 
-	status = nsm_mon_unmon(nsm, SM_MON, &res);
+	status = nsm_mon_unmon(nsm, SM_MON, &res, acred);
 
 	if (status < 0 || res.status != 0)
 		printk(KERN_NOTICE "lockd: cannot monitor %s\n", host->h_name);
@@ -95,7 +96,7 @@ nsm_monitor(struct nlm_host *host)
  * Cease to monitor remote host
  */
 int
-nsm_unmonitor(struct nlm_host *host)
+nsm_unmonitor(struct nlm_host *host, struct cred *acred)
 {
 	struct nsm_handle *nsm = host->h_nsmhandle;
 	struct nsm_res	res;
@@ -109,7 +110,7 @@ nsm_unmonitor(struct nlm_host *host)
 	 && nsm->sm_monitored && !nsm->sm_sticky) {
 		dprintk("lockd: nsm_unmonitor(%s)\n", host->h_name);
 
-		status = nsm_mon_unmon(nsm, SM_UNMON, &res);
+		status = nsm_mon_unmon(nsm, SM_UNMON, &res, acred);
 		if (status < 0)
 			printk(KERN_NOTICE "lockd: cannot unmonitor %s\n",
 					host->h_name);
@@ -124,7 +125,7 @@ nsm_unmonitor(struct nlm_host *host)
  * Create NSM client for the local host
  */
 static struct rpc_clnt *
-nsm_create(void)
+nsm_create(struct cred *acred)
 {
 	struct sockaddr_in	sin = {
 		.sin_family	= AF_INET,
@@ -141,7 +142,7 @@ nsm_create(void)
 		.authflavor	= RPC_AUTH_NULL,
 	};
 
-	return rpc_create(&args);
+	return rpc_create(&args, acred);
 }
 
 /*
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 82e2192..d4fd193 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -264,7 +264,7 @@ static int make_socks(struct svc_serv *serv, int proto)
  * Bring up the lockd process if it's not already up.
  */
 int
-lockd_up(int proto) /* Maybe add a 'family' option when IPv6 is supported ?? */
+lockd_up(int proto, struct cred *acred) /* Maybe add a 'family' option when IPv6 is supported ?? */
 {
 	struct svc_serv *	serv;
 	int			error = 0;
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index bf27b6c..16efd5a 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -39,7 +39,7 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain host handle */
 	if (!(host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len))
-	 || (argp->monitor && nsm_monitor(host) < 0))
+	 || (argp->monitor && nsm_monitor(host, current->cred) < 0))
 		goto no_locks;
 	*hostp = host;
 
@@ -242,7 +242,7 @@ static void nlm4svc_callback_exit(struct rpc_task *task, void *data)
 			-task->tk_status);
 }
 
-static void nlm4svc_callback_release(void *data)
+static void nlm4svc_callback_release(struct cred *acred, void *data)
 {
 	nlm_release_call(data);
 }
@@ -270,7 +270,7 @@ static __be32 nlm4svc_callback(struct svc_rqst *rqstp, u32 proc, struct nlm_args
 	if (host == NULL)
 		return rpc_system_err;
 
-	call = nlm_alloc_call(host);
+	call = nlm_alloc_call(host, current->cred);
 	if (call == NULL)
 		return rpc_system_err;
 
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index d120ec3..50d89ea 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -174,12 +174,12 @@ found:
 static struct nlm_block *
 nlmsvc_create_block(struct svc_rqst *rqstp, struct nlm_host *host,
 		    struct nlm_file *file, struct nlm_lock *lock,
-		    struct nlm_cookie *cookie)
+		    struct nlm_cookie *cookie, struct cred *acred)
 {
 	struct nlm_block	*block;
 	struct nlm_rqst		*call = NULL;
 
-	call = nlm_alloc_call(host);
+	call = nlm_alloc_call(host, acred);
 	if (call == NULL)
 		return NULL;
 
@@ -360,6 +360,7 @@ __be32
 nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 			struct nlm_lock *lock, int wait, struct nlm_cookie *cookie)
 {
+	struct cred		*acred = current->cred;
 	struct nlm_block	*block = NULL;
 	struct nlm_host		*host;
 	int			error;
@@ -386,7 +387,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	block = nlmsvc_lookup_block(file, lock);
 	if (block == NULL) {
 		block = nlmsvc_create_block(rqstp, nlm_get_host(host), file,
-				lock, cookie);
+				lock, cookie, acred);
 		ret = nlm_lck_denied_nolocks;
 		if (block == NULL)
 			goto out;
@@ -463,6 +464,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 		struct nlm_lock *lock, struct nlm_lock *conflock,
 		struct nlm_cookie *cookie)
 {
+	struct cred		*acred = current->cred;
 	struct nlm_block 	*block = NULL;
 	int			error;
 	__be32			ret;
@@ -489,7 +491,8 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 			kfree(conf);
 			return nlm_lck_denied_nolocks;
 		}
-		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
+		block = nlmsvc_create_block(rqstp, host, file, lock, cookie,
+					    acred);
 		if (block == NULL) {
 			kfree(conf);
 			return nlm_granted;
@@ -796,7 +799,7 @@ static void nlmsvc_grant_callback(struct rpc_task *task, void *data)
 	svc_wake_up(block->b_daemon);
 }
 
-static void nlmsvc_grant_release(void *data)
+static void nlmsvc_grant_release(struct cred *acred, void *data)
 {
 	struct nlm_rqst		*call = data;
 
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 9cd5c8b..f3265ed 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -68,7 +68,7 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain host handle */
 	if (!(host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len))
-	 || (argp->monitor && nsm_monitor(host) < 0))
+	 || (argp->monitor && nsm_monitor(host, current->cred) < 0))
 		goto no_locks;
 	*hostp = host;
 
@@ -272,7 +272,7 @@ static void nlmsvc_callback_exit(struct rpc_task *task, void *data)
 			-task->tk_status);
 }
 
-static void nlmsvc_callback_release(void *data)
+static void nlmsvc_callback_release(struct cred *acred, void *data)
 {
 	nlm_release_call(data);
 }
@@ -290,6 +290,7 @@ static const struct rpc_call_ops nlmsvc_callback_ops = {
 static __be32 nlmsvc_callback(struct svc_rqst *rqstp, u32 proc, struct nlm_args *argp,
 		__be32 (*func)(struct svc_rqst *, struct nlm_args *, struct nlm_res  *))
 {
+	struct cred *acred = current->cred;
 	struct nlm_host	*host;
 	struct nlm_rqst	*call;
 	__be32 stat;
@@ -300,7 +301,7 @@ static __be32 nlmsvc_callback(struct svc_rqst *rqstp, u32 proc, struct nlm_args
 	if (host == NULL)
 		return rpc_system_err;
 
-	call = nlm_alloc_call(host);
+	call = nlm_alloc_call(host, acred);
 	if (call == NULL)
 		return rpc_system_err;
 
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index a796be5..bca7d28 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -107,7 +107,7 @@ static void nfs_callback_svc(struct svc_rqst *rqstp)
 /*
  * Bring up the server process if it is not already up.
  */
-int nfs_callback_up(void)
+int nfs_callback_up(struct cred *acred)
 {
 	struct svc_serv *serv;
 	int ret = 0;
diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index c2bb14e..8425611 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -63,7 +63,7 @@ extern __be32 nfs4_callback_getattr(struct cb_getattrargs *args, struct cb_getat
 extern __be32 nfs4_callback_recall(struct cb_recallargs *args, void *dummy);
 
 #ifdef CONFIG_NFS_V4
-extern int nfs_callback_up(void);
+extern int nfs_callback_up(struct cred *acred);
 extern void nfs_callback_down(void);
 #else
 #define nfs_callback_up()	(0)
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index a204484..61a1b20 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -99,7 +99,8 @@ struct rpc_program		nfsacl_program = {
  */
 static struct nfs_client *nfs_alloc_client(const char *hostname,
 					   const struct sockaddr_in *addr,
-					   int nfsversion)
+					   int nfsversion,
+					   struct cred *acred)
 {
 	struct nfs_client *clp;
 
@@ -107,7 +108,7 @@ static struct nfs_client *nfs_alloc_client(const char *hostname,
 		goto error_0;
 
 	if (nfsversion == 4) {
-		if (nfs_callback_up() < 0)
+		if (nfs_callback_up(acred) < 0)
 			goto error_2;
 		__set_bit(NFS_CS_CALLBACK, &clp->cl_res_state);
 	}
@@ -257,7 +258,8 @@ struct nfs_client *nfs_find_client(const struct sockaddr_in *addr, int nfsversio
  */
 static struct nfs_client *nfs_get_client(const char *hostname,
 					 const struct sockaddr_in *addr,
-					 int nfsversion)
+					 int nfsversion,
+					 struct cred *acred)
 {
 	struct nfs_client *clp, *new = NULL;
 	int error;
@@ -278,7 +280,7 @@ static struct nfs_client *nfs_get_client(const char *hostname,
 
 		spin_unlock(&nfs_client_lock);
 
-		new = nfs_alloc_client(hostname, addr, nfsversion);
+		new = nfs_alloc_client(hostname, addr, nfsversion, acred);
 	} while (new);
 
 	return ERR_PTR(-ENOMEM);
@@ -368,7 +370,8 @@ static int nfs_create_rpc_client(struct nfs_client *clp, int proto,
 						unsigned int timeo,
 						unsigned int retrans,
 						rpc_authflavor_t flavor,
-						int flags)
+						int flags,
+						struct cred *acred)
 {
 	struct rpc_timeout	timeparms;
 	struct rpc_clnt		*clnt = NULL;
@@ -391,7 +394,7 @@ static int nfs_create_rpc_client(struct nfs_client *clp, int proto,
 	clp->retrans_timeo = timeparms.to_initval;
 	clp->retrans_count = timeparms.to_retries;
 
-	clnt = rpc_create(&args);
+	clnt = rpc_create(&args, acred);
 	if (IS_ERR(clnt)) {
 		dprintk("%s: cannot create RPC client. Error = %ld\n",
 				__FUNCTION__, PTR_ERR(clnt));
@@ -417,7 +420,7 @@ static void nfs_destroy_server(struct nfs_server *server)
 /*
  * Version 2 or 3 lockd setup
  */
-static int nfs_start_lockd(struct nfs_server *server)
+static int nfs_start_lockd(struct nfs_server *server, struct cred *acred)
 {
 	int error = 0;
 
@@ -426,7 +429,7 @@ static int nfs_start_lockd(struct nfs_server *server)
 	if (server->flags & NFS_MOUNT_NONLM)
 		goto out;
 	error = lockd_up((server->flags & NFS_MOUNT_TCP) ?
-			IPPROTO_TCP : IPPROTO_UDP);
+			IPPROTO_TCP : IPPROTO_UDP, acred);
 	if (error < 0)
 		server->flags |= NFS_MOUNT_NONLM;
 	else
@@ -439,14 +442,16 @@ out:
  * Initialise an NFSv3 ACL client connection
  */
 #ifdef CONFIG_NFS_V3_ACL
-static void nfs_init_server_aclclient(struct nfs_server *server)
+static void nfs_init_server_aclclient(struct nfs_server *server,
+				      struct cred *acred)
 {
 	if (server->nfs_client->cl_nfsversion != 3)
 		goto out_noacl;
 	if (server->flags & NFS_MOUNT_NOACL)
 		goto out_noacl;
 
-	server->client_acl = rpc_bind_new_program(server->client, &nfsacl_program, 3);
+	server->client_acl = rpc_bind_new_program(server->client,
+						  &nfsacl_program, 3, acred);
 	if (IS_ERR(server->client_acl))
 		goto out_noacl;
 
@@ -501,7 +506,9 @@ static int nfs_init_server_rpcclient(struct nfs_server *server, rpc_authflavor_t
 /*
  * Initialise an NFS2 or NFS3 client
  */
-static int nfs_init_client(struct nfs_client *clp, const struct nfs_mount_data *data)
+static int nfs_init_client(struct nfs_client *clp,
+			   const struct nfs_mount_data *data,
+			   struct cred *acred)
 {
 	int proto = (data->flags & NFS_MOUNT_TCP) ? IPPROTO_TCP : IPPROTO_UDP;
 	int error;
@@ -523,7 +530,7 @@ static int nfs_init_client(struct nfs_client *clp, const struct nfs_mount_data *
 	 * - RFC 2623, sec 2.3.2
 	 */
 	error = nfs_create_rpc_client(clp, proto, data->timeo, data->retrans,
-					RPC_AUTH_UNIX, 0);
+					RPC_AUTH_UNIX, 0, acred);
 	if (error < 0)
 		goto error;
 	nfs_mark_client_ready(clp, NFS_CS_READY);
@@ -538,7 +545,9 @@ error:
 /*
  * Create a version 2 or 3 client
  */
-static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_data *data)
+static int nfs_init_server(struct nfs_server *server,
+			   const struct nfs_mount_data *data,
+			   struct cred *acred)
 {
 	struct nfs_client *clp;
 	int error, nfsvers = 2;
@@ -551,13 +560,13 @@ static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_dat
 #endif
 
 	/* Allocate or find a client reference we can use */
-	clp = nfs_get_client(data->hostname, &data->addr, nfsvers);
+	clp = nfs_get_client(data->hostname, &data->addr, nfsvers, acred);
 	if (IS_ERR(clp)) {
 		dprintk("<-- nfs_init_server() = error %ld\n", PTR_ERR(clp));
 		return PTR_ERR(clp);
 	}
 
-	error = nfs_init_client(clp, data);
+	error = nfs_init_client(clp, data, acred);
 	if (error < 0)
 		goto error;
 
@@ -577,7 +586,7 @@ static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_dat
 	server->acdirmax = data->acdirmax * HZ;
 
 	/* Start lockd here, before we might error out */
-	error = nfs_start_lockd(server);
+	error = nfs_start_lockd(server, acred);
 	if (error < 0)
 		goto error;
 
@@ -587,7 +596,7 @@ static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_dat
 
 	server->namelen  = data->namlen;
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
-	nfs_init_server_aclclient(server);
+	nfs_init_server_aclclient(server, acred);
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;
 
@@ -651,7 +660,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server, struct nfs_fsinfo *
 /*
  * Probe filesystem information, including the FSID on v2/v3
  */
-static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs_fattr *fattr)
+static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh,
+			    struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct nfs_fsinfo fsinfo;
 	struct nfs_client *clp = server->nfs_client;
@@ -660,14 +670,14 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 	dprintk("--> nfs_probe_fsinfo()\n");
 
 	if (clp->rpc_ops->set_capabilities != NULL) {
-		error = clp->rpc_ops->set_capabilities(server, mntfh);
+		error = clp->rpc_ops->set_capabilities(server, mntfh, acred);
 		if (error < 0)
 			goto out_error;
 	}
 
 	fsinfo.fattr = fattr;
 	nfs_fattr_init(fattr);
-	error = clp->rpc_ops->fsinfo(server, mntfh, &fsinfo);
+	error = clp->rpc_ops->fsinfo(server, mntfh, &fsinfo, acred);
 	if (error < 0)
 		goto out_error;
 
@@ -680,7 +690,8 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 		pathinfo.fattr = fattr;
 		nfs_fattr_init(fattr);
 
-		if (clp->rpc_ops->pathconf(server, mntfh, &pathinfo) >= 0)
+		if (clp->rpc_ops->pathconf(server, mntfh, &pathinfo,
+					   acred) >= 0)
 			server->namelen = pathinfo.max_namelen;
 	}
 
@@ -761,7 +772,7 @@ void nfs_free_server(struct nfs_server *server)
  * - keyed on server and FSID
  */
 struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
-				     struct nfs_fh *mntfh)
+				     struct nfs_fh *mntfh, struct cred *acred)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr;
@@ -772,7 +783,7 @@ struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
 		return ERR_PTR(-ENOMEM);
 
 	/* Get a client representation */
-	error = nfs_init_server(server, data);
+	error = nfs_init_server(server, data, acred);
 	if (error < 0)
 		goto error;
 
@@ -781,7 +792,7 @@ struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, acred);
 	if (error < 0)
 		goto error;
 	if (server->nfs_client->rpc_ops->version == 3) {
@@ -795,7 +806,8 @@ struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
 	}
 
 	if (!(fattr.valid & NFS_ATTR_FATTR)) {
-		error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
+		error = server->nfs_client->rpc_ops->getattr(server, mntfh,
+							     &fattr, acred);
 		if (error < 0) {
 			dprintk("nfs_create_server: getattr error = %d\n", -error);
 			goto error;
@@ -831,7 +843,8 @@ error:
 static int nfs4_init_client(struct nfs_client *clp,
 		int proto, int timeo, int retrans,
 		const char *ip_addr,
-		rpc_authflavor_t authflavour)
+		rpc_authflavor_t authflavour,
+		struct cred *acred)
 {
 	int error;
 
@@ -845,7 +858,7 @@ static int nfs4_init_client(struct nfs_client *clp,
 	clp->rpc_ops = &nfs_v4_clientops;
 
 	error = nfs_create_rpc_client(clp, proto, timeo, retrans, authflavour,
-					RPC_CLNT_CREATE_DISCRTRY);
+					RPC_CLNT_CREATE_DISCRTRY, acred);
 	if (error < 0)
 		goto error;
 	memcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
@@ -874,7 +887,8 @@ static int nfs4_set_client(struct nfs_server *server,
 		const char *hostname, const struct sockaddr_in *addr,
 		const char *ip_addr,
 		rpc_authflavor_t authflavour,
-		int proto, int timeo, int retrans)
+		int proto, int timeo, int retrans,
+		struct cred *acred)
 {
 	struct nfs_client *clp;
 	int error;
@@ -882,12 +896,13 @@ static int nfs4_set_client(struct nfs_server *server,
 	dprintk("--> nfs4_set_client()\n");
 
 	/* Allocate or find a client reference we can use */
-	clp = nfs_get_client(hostname, addr, 4);
+	clp = nfs_get_client(hostname, addr, 4, acred);
 	if (IS_ERR(clp)) {
 		error = PTR_ERR(clp);
 		goto error;
 	}
-	error = nfs4_init_client(clp, proto, timeo, retrans, ip_addr, authflavour);
+	error = nfs4_init_client(clp, proto, timeo, retrans, ip_addr,
+				 authflavour, acred);
 	if (error < 0)
 		goto error_put;
 
@@ -943,7 +958,8 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 				      const char *mntpath,
 				      const char *ip_addr,
 				      rpc_authflavor_t authflavour,
-				      struct nfs_fh *mntfh)
+				      struct nfs_fh *mntfh,
+				      struct cred *acred)
 {
 	struct nfs_fattr fattr;
 	struct nfs_server *server;
@@ -957,7 +973,7 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 
 	/* Get a client record */
 	error = nfs4_set_client(server, hostname, addr, ip_addr, authflavour,
-			data->proto, data->timeo, data->retrans);
+			data->proto, data->timeo, data->retrans, acred);
 	if (error < 0)
 		goto error;
 
@@ -971,7 +987,7 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID */
-	error = nfs4_path_walk(server, mntfh, mntpath);
+	error = nfs4_path_walk(server, mntfh, mntpath, acred);
 	if (error < 0)
 		goto error;
 
@@ -980,7 +996,7 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 		(unsigned long long) server->fsid.minor);
 	dprintk("Mount FH: %d\n", mntfh->size);
 
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, acred);
 	if (error < 0)
 		goto error;
 
@@ -1010,7 +1026,8 @@ error:
  * Create an NFS4 referral server record
  */
 struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
-					       struct nfs_fh *mntfh)
+					       struct nfs_fh *mntfh,
+					       struct cred *acred)
 {
 	struct nfs_client *parent_client;
 	struct nfs_server *server, *parent_server;
@@ -1033,7 +1050,8 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 			data->authflavor,
 			parent_server->client->cl_xprt->prot,
 			parent_client->retrans_timeo,
-			parent_client->retrans_count);
+			parent_client->retrans_count,
+			acred);
 	if (error < 0)
 		goto error;
 
@@ -1050,12 +1068,12 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID and filehandle */
-	error = nfs4_path_walk(server, mntfh, data->mnt_path);
+	error = nfs4_path_walk(server, mntfh, data->mnt_path, acred);
 	if (error < 0)
 		goto error;
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, acred);
 	if (error < 0)
 		goto error;
 
@@ -1089,7 +1107,8 @@ error:
  */
 struct nfs_server *nfs_clone_server(struct nfs_server *source,
 				    struct nfs_fh *fh,
-				    struct nfs_fattr *fattr)
+				    struct nfs_fattr *fattr,
+				    struct cred *acred)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr_fsinfo;
@@ -1114,10 +1133,10 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 	if (error < 0)
 		goto out_free_server;
 	if (!IS_ERR(source->client_acl))
-		nfs_init_server_aclclient(server);
+		nfs_init_server_aclclient(server, acred);
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo);
+	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo, acred);
 	if (error < 0)
 		goto out_free_server;
 
@@ -1128,7 +1147,7 @@ struct nfs_server *nfs_clone_server(struct nfs_server *source,
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);
 
-	error = nfs_start_lockd(server);
+	error = nfs_start_lockd(server, acred);
 	if (error < 0)
 		goto out_free_server;
 
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index c55a761..3686cc0 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -29,6 +29,7 @@ static void nfs_free_delegation_callback(struct rcu_head *head)
 {
 	struct nfs_delegation *delegation = container_of(head, struct nfs_delegation, rcu);
 
+	put_cred(delegation->acred);
 	nfs_do_free_delegation(delegation);
 }
 
@@ -106,7 +107,8 @@ again:
 /*
  * Set up a delegation on an inode
  */
-void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res)
+void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred,
+				  struct nfs_openres *res, struct cred *acred)
 {
 	struct nfs_delegation *delegation = NFS_I(inode)->delegation;
 
@@ -118,6 +120,8 @@ void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred, st
 	delegation->maxsize = res->maxsize;
 	put_rpccred(cred);
 	delegation->cred = get_rpccred(cred);
+	put_cred(delegation->acred);
+	delegation->acred = get_cred(acred);
 	delegation->flags &= ~NFS_DELEGATION_NEED_RECLAIM;
 	NFS_I(inode)->delegation_state = delegation->type;
 	smp_wmb();
@@ -126,7 +130,8 @@ void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred, st
 /*
  * Set up a delegation on an inode
  */
-int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res)
+int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred,
+			     struct nfs_openres *res, struct cred *acred)
 {
 	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
 	struct nfs_inode *nfsi = NFS_I(inode);
@@ -142,6 +147,7 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
 	delegation->maxsize = res->maxsize;
 	delegation->change_attr = nfsi->change_attr;
 	delegation->cred = get_rpccred(cred);
+	delegation->acred = get_cred(acred);
 	delegation->inode = inode;
 
 	spin_lock(&clp->cl_lock);
@@ -170,11 +176,14 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
 	return status;
 }
 
-static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *delegation)
+static int nfs_do_return_delegation(struct inode *inode,
+				    struct nfs_delegation *delegation,
+				    struct cred *acred)
 {
 	int res = 0;
 
-	res = nfs4_proc_delegreturn(inode, delegation->cred, &delegation->stateid);
+	res = nfs4_proc_delegreturn(inode, delegation->cred,
+				    &delegation->stateid, acred);
 	nfs_free_delegation(delegation);
 	return res;
 }
@@ -190,7 +199,8 @@ static void nfs_msync_inode(struct inode *inode)
 /*
  * Basic procedure for returning a delegation to the server
  */
-static int __nfs_inode_return_delegation(struct inode *inode, struct nfs_delegation *delegation)
+static int __nfs_inode_return_delegation(struct inode *inode,
+					 struct nfs_delegation *delegation)
 {
 	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
 	struct nfs_inode *nfsi = NFS_I(inode);
@@ -204,7 +214,7 @@ static int __nfs_inode_return_delegation(struct inode *inode, struct nfs_delegat
 	up_read(&clp->cl_sem);
 	nfs_msync_inode(inode);
 
-	return nfs_do_return_delegation(inode, delegation);
+	return nfs_do_return_delegation(inode, delegation, delegation->acred);
 }
 
 static struct nfs_delegation *nfs_detach_delegation_locked(struct nfs_inode *nfsi, const nfs4_stateid *stateid)
@@ -383,7 +393,7 @@ static int recall_thread(void *data)
 	nfs_msync_inode(inode);
 
 	if (delegation != NULL)
-		nfs_do_return_delegation(inode, delegation);
+		nfs_do_return_delegation(inode, delegation, &init_cred);
 	iput(inode);
 	module_put_and_exit(0);
 }
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index 5874ce7..6319594 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -15,6 +15,7 @@
 struct nfs_delegation {
 	struct list_head super_list;
 	struct rpc_cred *cred;
+	struct cred *acred;
 	struct inode *inode;
 	nfs4_stateid stateid;
 	int type;
@@ -25,8 +26,10 @@ struct nfs_delegation {
 	struct rcu_head rcu;
 };
 
-int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res);
-void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res);
+int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred,
+			     struct nfs_openres *res, struct cred *acred);
+void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred,
+				  struct nfs_openres *res, struct cred *acred);
 int nfs_inode_return_delegation(struct inode *inode);
 int nfs_async_inode_return_delegation(struct inode *inode, const nfs4_stateid *stateid);
 
@@ -39,7 +42,8 @@ void nfs_delegation_mark_reclaim(struct nfs_client *clp);
 void nfs_delegation_reap_unclaimed(struct nfs_client *clp);
 
 /* NFSv4 delegation-related procedures */
-int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, const nfs4_stateid *stateid);
+int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred,
+			  const nfs4_stateid *stateid, struct cred *acred);
 int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state *state, const nfs4_stateid *stateid);
 int nfs4_lock_delegation_recall(struct nfs4_state *state, struct file_lock *fl);
 int nfs4_copy_delegation_stateid(nfs4_stateid *dst, struct inode *inode);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 53b9e24..35a63cf 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -175,6 +175,7 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page *page)
 {
 	struct file	*file = desc->file;
 	struct inode	*inode = file->f_path.dentry->d_inode;
+	struct cred	*acred = file->f_cred;
 	struct rpc_cred	*cred = nfs_file_cred(file);
 	unsigned long	timestamp;
 	int		error;
@@ -186,7 +187,8 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page *page)
  again:
 	timestamp = jiffies;
 	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, desc->entry->cookie, page,
-					  NFS_SERVER(inode)->dtsize, desc->plus);
+					  NFS_SERVER(inode)->dtsize, desc->plus,
+					  acred);
 	if (error < 0) {
 		/* We requested READDIRPLUS, but the server doesn't grok it */
 		if (error == -ENOTSUPP && desc->plus) {
@@ -472,6 +474,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
 {
 	struct file	*file = desc->file;
 	struct inode	*inode = file->f_path.dentry->d_inode;
+	struct cred	*acred = file->f_cred;
 	struct rpc_cred	*cred = nfs_file_cred(file);
 	struct page	*page = NULL;
 	int		status;
@@ -489,7 +492,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
 	desc->error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, *desc->dir_cookie,
 						page,
 						NFS_SERVER(inode)->dtsize,
-						desc->plus);
+						desc->plus, acred);
 	spin_lock(&inode->i_lock);
 	NFS_I(inode)->cache_validity |= NFS_INO_INVALID_ATIME;
 	spin_unlock(&inode->i_lock);
@@ -527,6 +530,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
  */
 static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
+	struct cred	*acred = filp->f_cred;
 	struct dentry	*dentry = filp->f_path.dentry;
 	struct inode	*inode = dentry->d_inode;
 	nfs_readdir_descriptor_t my_desc,
@@ -543,7 +547,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 	lock_kernel();
 
-	res = nfs_revalidate_mapping_nolock(inode, filp->f_mapping);
+	res = nfs_revalidate_mapping_nolock(inode, filp->f_mapping, acred);
 	if (res < 0) {
 		unlock_kernel();
 		return res;
@@ -703,7 +707,8 @@ static inline unsigned int nfs_lookup_check_intent(struct nameidata *nd, unsigne
  *
  */
 static inline
-int nfs_lookup_verify_inode(struct inode *inode, struct nameidata *nd)
+int nfs_lookup_verify_inode(struct inode *inode, struct nameidata *nd,
+			    struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 
@@ -718,9 +723,9 @@ int nfs_lookup_verify_inode(struct inode *inode, struct nameidata *nd)
 				 S_ISDIR(inode->i_mode)))
 			goto out_force;
 	}
-	return nfs_revalidate_inode(server, inode);
+	return nfs_revalidate_inode(server, inode, acred);
 out_force:
-	return __nfs_revalidate_inode(server, inode);
+	return __nfs_revalidate_inode(server, inode, acred);
 }
 
 /*
@@ -753,6 +758,7 @@ int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
  */
 static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct inode *dir;
 	struct inode *inode;
 	struct dentry *parent;
@@ -768,7 +774,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 	inode = dentry->d_inode;
 
 	/* Revalidate parent directory attribute cache */
-	if (nfs_revalidate_inode(NFS_SERVER(dir), dir) < 0)
+	if (nfs_revalidate_inode(NFS_SERVER(dir), dir, acred) < 0)
 		goto out_zap_parent;
 
 	if (!inode) {
@@ -786,7 +792,7 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 
 	/* Force a full look up iff the parent directory has changed */
 	if (nfs_check_verifier(dir, dentry)) {
-		if (nfs_lookup_verify_inode(inode, nd))
+		if (nfs_lookup_verify_inode(inode, nd, acred))
 			goto out_zap_parent;
 		goto out_valid;
 	}
@@ -795,7 +801,8 @@ static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
 		goto out_bad;
 
 	verifier = nfs_save_change_attribute(dir);
-	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
+	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr,
+				       acred);
 	if (error)
 		goto out_bad;
 	if (nfs_compare_fh(NFS_FH(inode), &fhandle))
@@ -869,7 +876,7 @@ static void nfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		lock_kernel();
 		drop_nlink(inode);
-		nfs_complete_unlink(dentry, inode);
+		nfs_complete_unlink(dentry, inode, &init_cred);
 		unlock_kernel();
 	}
 	/* When creating a negative dentry, we want to renew d_time */
@@ -897,18 +904,20 @@ int nfs_is_exclusive_create(struct inode *dir, struct nameidata *nd)
 	return (nd->intent.open.flags & O_EXCL) != 0;
 }
 
-static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fattr)
+static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fattr,
+				 struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 
 	if (!nfs_fsid_equal(&server->fsid, &fattr->fsid))
 		/* Revalidate fsid using the parent directory */
-		return __nfs_revalidate_inode(server, dir);
+		return __nfs_revalidate_inode(server, dir, acred);
 	return 0;
 }
 
 static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct dentry *res;
 	struct inode *inode = NULL;
 	int error;
@@ -938,14 +947,15 @@ static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, stru
 		goto out_unlock;
 	}
 
-	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr);
+	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, &fhandle, &fattr,
+				       acred);
 	if (error == -ENOENT)
 		goto no_entry;
 	if (error < 0) {
 		res = ERR_PTR(error);
 		goto out_unlock;
 	}
-	error = nfs_reval_fsid(dir, &fattr);
+	error = nfs_reval_fsid(dir, &fattr, acred);
 	if (error < 0) {
 		res = ERR_PTR(error);
 		goto out_unlock;
@@ -1004,6 +1014,7 @@ static int is_atomic_open(struct inode *dir, struct nameidata *nd)
 
 static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct dentry *res = NULL;
 	int error;
 
@@ -1029,7 +1040,7 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 	/* Open the file on the server */
 	lock_kernel();
 	/* Revalidate parent directory attribute cache */
-	error = nfs_revalidate_inode(NFS_SERVER(dir), dir);
+	error = nfs_revalidate_inode(NFS_SERVER(dir), dir, acred);
 	if (error < 0) {
 		res = ERR_PTR(error);
 		unlock_kernel();
@@ -1038,10 +1049,10 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 
 	if (nd->intent.open.flags & O_CREAT) {
 		nfs_begin_data_update(dir);
-		res = nfs4_atomic_open(dir, dentry, nd);
+		res = nfs4_atomic_open(dir, dentry, nd, acred);
 		nfs_end_data_update(dir);
 	} else
-		res = nfs4_atomic_open(dir, dentry, nd);
+		res = nfs4_atomic_open(dir, dentry, nd, acred);
 	unlock_kernel();
 	if (IS_ERR(res)) {
 		error = PTR_ERR(res);
@@ -1073,6 +1084,7 @@ no_open:
 
 static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct dentry *parent = NULL;
 	struct inode *inode = dentry->d_inode;
 	struct inode *dir;
@@ -1105,7 +1117,7 @@ static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
 	 */
 	lock_kernel();
 	verifier = nfs_save_change_attribute(dir);
-	ret = nfs4_open_revalidate(dir, dentry, openflags, nd);
+	ret = nfs4_open_revalidate(dir, dentry, openflags, nd, acred);
 	if (!ret)
 		nfs_refresh_verifier(dentry, verifier);
 	unlock_kernel();
@@ -1196,7 +1208,7 @@ out_renew:
  * Code common to create, mkdir, and mknod.
  */
 int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
-				struct nfs_fattr *fattr)
+				struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct inode *inode;
 	int error = -EACCES;
@@ -1206,13 +1218,15 @@ int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
 		return 0;
 	if (fhandle->size == 0) {
 		struct inode *dir = dentry->d_parent->d_inode;
-		error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, fhandle, fattr);
+		error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, fhandle,
+					       fattr, acred);
 		if (error)
 			return error;
 	}
 	if (!(fattr->valid & NFS_ATTR_FATTR)) {
 		struct nfs_server *server = NFS_SB(dentry->d_sb);
-		error = server->nfs_client->rpc_ops->getattr(server, fhandle, fattr);
+		error = server->nfs_client->rpc_ops->getattr(server, fhandle,
+							     fattr, acred);
 		if (error < 0)
 			return error;
 	}
@@ -1235,6 +1249,7 @@ int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
 static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct iattr attr;
 	int error;
 	int open_flags = 0;
@@ -1250,7 +1265,8 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, nd);
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, nd,
+				       acred);
 	nfs_end_data_update(dir);
 	if (error != 0)
 		goto out_err;
@@ -1270,6 +1286,7 @@ out_err:
 static int
 nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 {
+	struct cred *acred = current->cred;
 	struct iattr attr;
 	int status;
 
@@ -1284,7 +1301,7 @@ nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
-	status = NFS_PROTO(dir)->mknod(dir, dentry, &attr, rdev);
+	status = NFS_PROTO(dir)->mknod(dir, dentry, &attr, rdev, acred);
 	nfs_end_data_update(dir);
 	if (status != 0)
 		goto out_err;
@@ -1303,6 +1320,7 @@ out_err:
  */
 static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
+	struct cred *acred = current->cred;
 	struct iattr attr;
 	int error;
 
@@ -1314,7 +1332,7 @@ static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
-	error = NFS_PROTO(dir)->mkdir(dir, dentry, &attr);
+	error = NFS_PROTO(dir)->mkdir(dir, dentry, &attr, acred);
 	nfs_end_data_update(dir);
 	if (error != 0)
 		goto out_err;
@@ -1330,6 +1348,7 @@ out_err:
 
 static int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *acred = current->cred;
 	int error;
 
 	dfprintk(VFS, "NFS: rmdir(%s/%ld), %s\n",
@@ -1337,7 +1356,7 @@ static int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
-	error = NFS_PROTO(dir)->rmdir(dir, &dentry->d_name);
+	error = NFS_PROTO(dir)->rmdir(dir, &dentry->d_name, acred);
 	/* Ensure the VFS deletes this inode */
 	if (error == 0 && dentry->d_inode != NULL)
 		clear_nlink(dentry->d_inode);
@@ -1347,7 +1366,8 @@ static int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 	return error;
 }
 
-static int nfs_sillyrename(struct inode *dir, struct dentry *dentry)
+static int nfs_sillyrename(struct inode *dir, struct dentry *dentry,
+			   struct cred *acred)
 {
 	static unsigned int sillycounter;
 	const int      i_inosize  = sizeof(dir->i_ino)*2;
@@ -1402,18 +1422,18 @@ static int nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 	if (dentry->d_inode) {
 		nfs_begin_data_update(dentry->d_inode);
 		error = NFS_PROTO(dir)->rename(dir, &dentry->d_name,
-				dir, &qsilly);
+				dir, &qsilly, acred);
 		nfs_mark_for_revalidate(dentry->d_inode);
 		nfs_end_data_update(dentry->d_inode);
 	} else
 		error = NFS_PROTO(dir)->rename(dir, &dentry->d_name,
-				dir, &qsilly);
+				dir, &qsilly, acred);
 	nfs_end_data_update(dir);
 	if (!error) {
 		nfs_renew_times(dentry);
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 		d_move(dentry, sdentry);
-		error = nfs_async_unlink(dir, dentry);
+		error = nfs_async_unlink(dir, dentry, acred);
  		/* If we return 0 we don't unlink */
 	}
 	dput(sdentry);
@@ -1428,7 +1448,7 @@ out:
  * We invalidate the attribute cache and free the inode prior to the operation
  * to avoid possible races if the server reuses the inode.
  */
-static int nfs_safe_remove(struct dentry *dentry)
+static int nfs_safe_remove(struct dentry *dentry, struct cred *acred)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct inode *inode = dentry->d_inode;
@@ -1447,14 +1467,14 @@ static int nfs_safe_remove(struct dentry *dentry)
 	if (inode != NULL) {
 		nfs_inode_return_delegation(inode);
 		nfs_begin_data_update(inode);
-		error = NFS_PROTO(dir)->remove(dir, &dentry->d_name);
+		error = NFS_PROTO(dir)->remove(dir, &dentry->d_name, acred);
 		/* The VFS may want to delete this inode */
 		if (error == 0)
 			drop_nlink(inode);
 		nfs_mark_for_revalidate(inode);
 		nfs_end_data_update(inode);
 	} else
-		error = NFS_PROTO(dir)->remove(dir, &dentry->d_name);
+		error = NFS_PROTO(dir)->remove(dir, &dentry->d_name, acred);
 	nfs_end_data_update(dir);
 out:
 	return error;
@@ -1467,6 +1487,7 @@ out:
  */
 static int nfs_unlink(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *acred = current->cred;
 	int error;
 	int need_rehash = 0;
 
@@ -1481,7 +1502,7 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dcache_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
-		error = nfs_sillyrename(dir, dentry);
+		error = nfs_sillyrename(dir, dentry, acred);
 		unlock_kernel();
 		return error;
 	}
@@ -1491,7 +1512,7 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
-	error = nfs_safe_remove(dentry);
+	error = nfs_safe_remove(dentry, acred);
 	if (!error) {
 		nfs_renew_times(dentry);
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
@@ -1518,6 +1539,7 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
  */
 static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
+	struct cred *acred = current->cred;
 	struct pagevec lru_pvec;
 	struct page *page;
 	char *kaddr;
@@ -1549,7 +1571,8 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 	kunmap_atomic(kaddr, KM_USER0);
 
 	nfs_begin_data_update(dir);
-	error = NFS_PROTO(dir)->symlink(dir, dentry, page, pathlen, &attr);
+	error = NFS_PROTO(dir)->symlink(dir, dentry, page, pathlen, &attr,
+					acred);
 	nfs_end_data_update(dir);
 	if (error != 0) {
 		dfprintk(VFS, "NFS: symlink(%s/%ld, %s, %s) error %d\n",
@@ -1582,6 +1605,7 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 static int 
 nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
@@ -1592,7 +1616,7 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 	lock_kernel();
 	nfs_begin_data_update(dir);
 	nfs_begin_data_update(inode);
-	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
+	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name, acred);
 	if (error == 0) {
 		atomic_inc(&inode->i_count);
 		d_instantiate(dentry, inode);
@@ -1630,6 +1654,7 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 static int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		      struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct cred *acred = current->cred;
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct dentry *dentry = NULL, *rehash = NULL;
@@ -1673,7 +1698,7 @@ static int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out;
 
 		/* silly-rename the existing target ... */
-		err = nfs_sillyrename(new_dir, new_dentry);
+		err = nfs_sillyrename(new_dir, new_dentry, acred);
 		if (!err) {
 			new_dentry = rehash = dentry;
 			new_inode = NULL;
@@ -1705,7 +1730,8 @@ go_ahead:
 	nfs_begin_data_update(new_dir);
 	nfs_begin_data_update(old_inode);
 	error = NFS_PROTO(old_dir)->rename(old_dir, &old_dentry->d_name,
-					   new_dir, &new_dentry->d_name);
+					   new_dir, &new_dentry->d_name,
+					   acred);
 	nfs_mark_for_revalidate(old_inode);
 	nfs_end_data_update(old_inode);
 	nfs_end_data_update(new_dir);
@@ -1934,7 +1960,8 @@ void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set)
 	}
 }
 
-static int nfs_do_access(struct inode *inode, struct rpc_cred *cred, int mask)
+static int nfs_do_access(struct inode *inode, struct rpc_cred *cred, int mask,
+			 struct cred *acred)
 {
 	struct nfs_access_entry cache;
 	int status;
@@ -1947,7 +1974,7 @@ static int nfs_do_access(struct inode *inode, struct rpc_cred *cred, int mask)
 	cache.mask = MAY_EXEC | MAY_WRITE | MAY_READ;
 	cache.cred = cred;
 	cache.jiffies = jiffies;
-	status = NFS_PROTO(inode)->access(inode, &cache);
+	status = NFS_PROTO(inode)->access(inode, &cache, acred);
 	if (status != 0)
 		return status;
 	nfs_access_add_cache(inode, &cache);
@@ -1998,7 +2025,7 @@ force_lookup:
 
 	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0, acred);
 	if (!IS_ERR(cred)) {
-		res = nfs_do_access(inode, cred, mask);
+		res = nfs_do_access(inode, cred, mask, acred);
 		put_rpccred(cred);
 	} else
 		res = PTR_ERR(cred);
@@ -2008,7 +2035,7 @@ out:
 		inode->i_sb->s_id, inode->i_ino, mask, res);
 	return res;
 out_notsup:
-	res = nfs_revalidate_inode(NFS_SERVER(inode), inode);
+	res = nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 	if (res == 0)
 		res = generic_permission(inode, mask, NULL);
 	unlock_kernel();
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index fcf4d38..6c9491b 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -291,14 +291,14 @@ static ssize_t nfs_direct_read_schedule(struct nfs_direct_req *dreq, unsigned lo
 					data->npages, 1, 0, data->pagevec, NULL);
 		up_read(&current->mm->mmap_sem);
 		if (result < 0) {
-			nfs_readdata_release(data);
+			nfs_readdata_release(ctx->acred, data);
 			break;
 		}
 		if ((unsigned)result < data->npages) {
 			bytes = result * PAGE_SIZE;
 			if (bytes <= pgbase) {
 				nfs_direct_release_pages(data->pagevec, result);
-				nfs_readdata_release(data);
+				nfs_readdata_release(ctx->acred, data);
 				break;
 			}
 			bytes -= pgbase;
@@ -321,8 +321,8 @@ static ssize_t nfs_direct_read_schedule(struct nfs_direct_req *dreq, unsigned lo
 		data->res.count = bytes;
 
 		rpc_init_task(&data->task, NFS_CLIENT(inode), RPC_TASK_ASYNC,
-				&nfs_read_direct_ops, data);
-		NFS_PROTO(inode)->read_setup(data);
+			      &nfs_read_direct_ops, data, ctx->acred);
+		NFS_PROTO(inode)->read_setup(data, ctx->acred);
 
 		data->task.tk_cookie = (unsigned long) inode;
 
@@ -389,7 +389,7 @@ static void nfs_direct_free_writedata(struct nfs_direct_req *dreq)
 		struct nfs_write_data *data = list_entry(dreq->rewrite_list.next, struct nfs_write_data, pages);
 		list_del(&data->pages);
 		nfs_direct_release_pages(data->pagevec, data->npages);
-		nfs_writedata_release(data);
+		nfs_writedata_release(dreq->ctx->acred, data);
 	}
 }
 
@@ -420,8 +420,9 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 		 * since the original request was sent.
 		 */
 		rpc_init_task(&data->task, NFS_CLIENT(inode), RPC_TASK_ASYNC,
-				&nfs_write_direct_ops, data);
-		NFS_PROTO(inode)->write_setup(data, FLUSH_STABLE);
+				&nfs_write_direct_ops, data, dreq->ctx->acred);
+		NFS_PROTO(inode)->write_setup(data, FLUSH_STABLE,
+					      dreq->ctx->acred);
 
 		data->task.tk_priority = RPC_PRIORITY_NORMAL;
 		data->task.tk_cookie = (unsigned long) inode;
@@ -484,8 +485,8 @@ static void nfs_direct_commit_schedule(struct nfs_direct_req *dreq)
 	data->res.verf = &data->verf;
 
 	rpc_init_task(&data->task, NFS_CLIENT(dreq->inode), RPC_TASK_ASYNC,
-				&nfs_commit_direct_ops, data);
-	NFS_PROTO(data->inode)->commit_setup(data, 0);
+				&nfs_commit_direct_ops, data, dreq->ctx->acred);
+	NFS_PROTO(data->inode)->commit_setup(data, 0, dreq->ctx->acred);
 
 	data->task.tk_priority = RPC_PRIORITY_NORMAL;
 	data->task.tk_cookie = (unsigned long)data->inode;
@@ -582,7 +583,7 @@ out_unlock:
  * NB: Return the value of the first error return code.  Subsequent
  *     errors after the first one are ignored.
  */
-static void nfs_direct_write_release(void *calldata)
+static void nfs_direct_write_release(struct cred *acred, void *calldata)
 {
 	struct nfs_write_data *data = calldata;
 	struct nfs_direct_req *dreq = (struct nfs_direct_req *) data->req;
@@ -631,14 +632,14 @@ static ssize_t nfs_direct_write_schedule(struct nfs_direct_req *dreq, unsigned l
 					data->npages, 0, 0, data->pagevec, NULL);
 		up_read(&current->mm->mmap_sem);
 		if (result < 0) {
-			nfs_writedata_release(data);
+			nfs_writedata_release(ctx->acred, data);
 			break;
 		}
 		if ((unsigned)result < data->npages) {
 			bytes = result * PAGE_SIZE;
 			if (bytes <= pgbase) {
 				nfs_direct_release_pages(data->pagevec, result);
-				nfs_writedata_release(data);
+				nfs_writedata_release(ctx->acred, data);
 				break;
 			}
 			bytes -= pgbase;
@@ -663,8 +664,8 @@ static ssize_t nfs_direct_write_schedule(struct nfs_direct_req *dreq, unsigned l
 		data->res.verf = &data->verf;
 
 		rpc_init_task(&data->task, NFS_CLIENT(inode), RPC_TASK_ASYNC,
-				&nfs_write_direct_ops, data);
-		NFS_PROTO(inode)->write_setup(data, sync);
+				&nfs_write_direct_ops, data, ctx->acred);
+		NFS_PROTO(inode)->write_setup(data, sync, ctx->acred);
 
 		data->task.tk_priority = RPC_PRIORITY_NORMAL;
 		data->task.tk_cookie = (unsigned long) inode;
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 579cf8a..72f0850 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -158,7 +158,7 @@ static int nfs_revalidate_file_size(struct inode *inode, struct file *filp)
 	if (!(nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE) && !nfs_attribute_timeout(inode))
 		return 0;
 force_reval:
-	return __nfs_revalidate_inode(server, inode);
+	return __nfs_revalidate_inode(server, inode, filp->f_cred);
 }
 
 static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
@@ -196,7 +196,8 @@ nfs_file_flush(struct file *file, fl_owner_t id)
 		status = ctx->error;
 		ctx->error = 0;
 		if (!status)
-			nfs_revalidate_inode(NFS_SERVER(inode), inode);
+			nfs_revalidate_inode(NFS_SERVER(inode), inode,
+					     ctx->acred);
 	}
 	unlock_kernel();
 	return status;
@@ -208,6 +209,7 @@ nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 	struct inode * inode = dentry->d_inode;
+	struct cred *acred = iocb->ki_filp->f_cred;
 	ssize_t result;
 	size_t count = iov_length(iov, nr_segs);
 
@@ -220,7 +222,7 @@ nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		(unsigned long) count, (unsigned long) pos);
 
-	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
+	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping, acred);
 	nfs_add_stats(inode, NFSIOS_NORMALREADBYTES, count);
 	if (!result)
 		result = generic_file_aio_read(iocb, iov, nr_segs, pos);
@@ -234,13 +236,14 @@ nfs_file_splice_read(struct file *filp, loff_t *ppos,
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
+	struct cred *acred = filp->f_cred;
 	ssize_t res;
 
 	dfprintk(VFS, "nfs: splice_read(%s/%s, %lu@%Lu)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
 		(unsigned long) count, (unsigned long long) *ppos);
 
-	res = nfs_revalidate_mapping(inode, filp->f_mapping);
+	res = nfs_revalidate_mapping(inode, filp->f_mapping, acred);
 	if (!res)
 		res = generic_file_splice_read(filp, ppos, pipe, count, flags);
 	return res;
@@ -251,12 +254,13 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
+	struct cred *acred = file->f_cred;
 	int	status;
 
 	dfprintk(VFS, "nfs: mmap(%s/%s)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	status = nfs_revalidate_mapping(inode, file->f_mapping);
+	status = nfs_revalidate_mapping(inode, file->f_mapping, acred);
 	if (!status)
 		status = generic_file_mmap(file, vma);
 	return status;
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 93d1479..17a0ac8 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -45,7 +45,8 @@
 /*
  * get an NFS2/NFS3 root dentry from the root filehandle
  */
-struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
+struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh,
+			    struct cred *acred)
 {
 	struct nfs_server *server = NFS_SB(sb);
 	struct nfs_fsinfo fsinfo;
@@ -84,7 +85,8 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	/* get the actual root for this mount */
 	fsinfo.fattr = &fattr;
 
-	error = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo);
+	error = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo,
+						     acred);
 	if (error < 0) {
 		dprintk("nfs_get_root: getattr error = %d\n", -error);
 		return ERR_PTR(error);
@@ -126,7 +128,8 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
  */
 int nfs4_path_walk(struct nfs_server *server,
 		   struct nfs_fh *mntfh,
-		   const char *path)
+		   const char *path,
+		   struct cred *acred)
 {
 	struct nfs_fsinfo fsinfo;
 	struct nfs_fattr fattr;
@@ -144,7 +147,8 @@ int nfs4_path_walk(struct nfs_server *server,
 		path++;
 
 	/* Start by getting the root filehandle from the server */
-	ret = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo);
+	ret = server->nfs_client->rpc_ops->getroot(server, mntfh, &fsinfo,
+						   acred);
 	if (ret < 0) {
 		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
 		return ret;
@@ -201,7 +205,7 @@ eat_dot_dir:
 	dprintk("LookupFH: %*.*s [%s]\n", name.len, name.len, name.name, path);
 
 	ret = server->nfs_client->rpc_ops->lookupfh(server, &lastfh, &name,
-						    mntfh, &fattr);
+						    mntfh, &fattr, acred);
 	if (ret < 0) {
 		dprintk("nfs4_get_root: getroot error = %d\n", -ret);
 		return ret;
@@ -231,7 +235,8 @@ path_walk_complete:
 /*
  * get an NFS4 root dentry from the root filehandle
  */
-struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
+struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh,
+			     struct cred *acred)
 {
 	struct nfs_server *server = NFS_SB(sb);
 	struct nfs_fattr fattr;
@@ -269,7 +274,7 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	}
 
 	/* get the info about the server and filesystem */
-	error = nfs4_server_capabilities(server, mntfh);
+	error = nfs4_server_capabilities(server, mntfh, acred);
 	if (error < 0) {
 		dprintk("nfs_get_root: getcaps error = %d\n",
 			-error);
@@ -277,7 +282,8 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	}
 
 	/* get the actual root for this mount */
-	error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
+	error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr,
+						     acred);
 	if (error < 0) {
 		dprintk("nfs_get_root: getattr error = %d\n", -error);
 		return ERR_PTR(error);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 0dd2ac3..300560f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -321,6 +321,7 @@ out_no_inode:
 int
 nfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct nfs_fattr fattr;
 	int error;
@@ -349,7 +350,7 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
 	 */
 	if ((attr->ia_valid & (ATTR_MODE|ATTR_UID|ATTR_GID)) != 0)
 		nfs_inode_return_delegation(inode);
-	error = NFS_PROTO(inode)->setattr(dentry, &fattr, attr);
+	error = NFS_PROTO(inode)->setattr(dentry, &fattr, attr, acred);
 	if (error == 0)
 		nfs_refresh_inode(inode, &fattr);
 	nfs_end_data_update(inode);
@@ -425,6 +426,7 @@ static void nfs_wake_up_inode(struct inode *inode)
 
 int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err;
@@ -447,15 +449,18 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 		need_atime = 0;
 
 	if (need_atime)
-		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 	else
-		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		err = nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 	if (!err)
 		generic_fillattr(inode, stat);
 	return err;
 }
 
-static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt, struct dentry *dentry, struct rpc_cred *cred)
+static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt,
+						       struct dentry *dentry,
+						       struct rpc_cred *cred,
+						       struct cred *acred)
 {
 	struct nfs_open_context *ctx;
 
@@ -463,6 +468,7 @@ static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt, str
 	if (ctx != NULL) {
 		ctx->path.dentry = dget(dentry);
 		ctx->path.mnt = mntget(mnt);
+		ctx->acred = get_cred(acred);
 		ctx->cred = get_rpccred(cred);
 		ctx->state = NULL;
 		ctx->lockowner = current->files;
@@ -489,9 +495,10 @@ void put_nfs_open_context(struct nfs_open_context *ctx)
 	list_del(&ctx->list);
 	spin_unlock(&inode->i_lock);
 	if (ctx->state != NULL)
-		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
+		nfs4_close_state(&ctx->path, ctx->state, ctx->mode, ctx->acred);
 	if (ctx->cred != NULL)
 		put_rpccred(ctx->cred);
+	put_cred(ctx->acred);
 	dput(ctx->path.dentry);
 	mntput(ctx->path.mnt);
 	kfree(ctx);
@@ -558,7 +565,8 @@ int nfs_open(struct inode *inode, struct file *filp)
 	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0, filp->f_cred);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	ctx = alloc_nfs_open_context(filp->f_path.mnt, filp->f_path.dentry, cred);
+	ctx = alloc_nfs_open_context(filp->f_path.mnt, filp->f_path.dentry, cred,
+				     filp->f_cred);
 	put_rpccred(cred);
 	if (ctx == NULL)
 		return -ENOMEM;
@@ -579,7 +587,8 @@ int nfs_release(struct inode *inode, struct file *filp)
  * the cached attributes have to be refreshed.
  */
 int
-__nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
+__nfs_revalidate_inode(struct nfs_server *server, struct inode *inode,
+		       struct cred *acred)
 {
 	int		 status = -ESTALE;
 	struct nfs_fattr fattr;
@@ -609,7 +618,8 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 		}
 	}
 
-	status = NFS_PROTO(inode)->getattr(server, NFS_FH(inode), &fattr);
+	status = NFS_PROTO(inode)->getattr(server, NFS_FH(inode), &fattr,
+					   acred);
 	if (status != 0) {
 		dfprintk(PAGECACHE, "nfs_revalidate_inode: (%s/%Ld) getattr failed, error=%d\n",
 			 inode->i_sb->s_id,
@@ -661,15 +671,17 @@ int nfs_attribute_timeout(struct inode *inode)
  * nfs_revalidate_inode - Revalidate the inode attributes
  * @server - pointer to nfs_server struct
  * @inode - pointer to inode struct
+ * @acred - the credentials to use
  *
  * Updates inode attribute information by retrieving the data from the server.
  */
-int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
+int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode,
+			 struct cred *acred)
 {
 	if (!(NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATTR)
 			&& !nfs_attribute_timeout(inode))
 		return NFS_STALE(inode) ? -ESTALE : 0;
-	return __nfs_revalidate_inode(server, inode);
+	return __nfs_revalidate_inode(server, inode, acred);
 }
 
 static int nfs_invalidate_mapping_nolock(struct inode *inode, struct address_space *mapping)
@@ -713,15 +725,18 @@ static int nfs_invalidate_mapping(struct inode *inode, struct address_space *map
  * nfs_revalidate_mapping_nolock - Revalidate the pagecache
  * @inode - pointer to host inode
  * @mapping - pointer to mapping
+ * @acred - the credentials to use
  */
-int nfs_revalidate_mapping_nolock(struct inode *inode, struct address_space *mapping)
+int nfs_revalidate_mapping_nolock(struct inode *inode,
+				  struct address_space *mapping,
+				  struct cred *acred)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int ret = 0;
 
 	if ((nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
 			|| nfs_attribute_timeout(inode) || NFS_STALE(inode)) {
-		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 		if (ret < 0)
 			goto out;
 	}
@@ -735,18 +750,20 @@ out:
  * nfs_revalidate_mapping - Revalidate the pagecache
  * @inode - pointer to host inode
  * @mapping - pointer to mapping
+ * @acred - the credentials to use
  *
  * This version of the function will take the inode->i_mutex and attempt to
  * flush out all dirty data if it needs to invalidate the page cache.
  */
-int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
+int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping,
+			   struct cred *acred)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int ret = 0;
 
 	if ((nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
 			|| nfs_attribute_timeout(inode) || NFS_STALE(inode)) {
-		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 76cf55d..777f1ac 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -33,20 +33,23 @@ extern struct rpc_program nfs_program;
 extern void nfs_put_client(struct nfs_client *);
 extern struct nfs_client *nfs_find_client(const struct sockaddr_in *, int);
 extern struct nfs_server *nfs_create_server(const struct nfs_mount_data *,
-					    struct nfs_fh *);
+					    struct nfs_fh *, struct cred *);
 extern struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *,
 					     const char *,
 					     const struct sockaddr_in *,
 					     const char *,
 					     const char *,
 					     rpc_authflavor_t,
-					     struct nfs_fh *);
+					     struct nfs_fh *,
+					     struct cred *);
 extern struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *,
-						      struct nfs_fh *);
+						      struct nfs_fh *,
+						      struct cred *);
 extern void nfs_free_server(struct nfs_server *server);
 extern struct nfs_server *nfs_clone_server(struct nfs_server *,
 					   struct nfs_fh *,
-					   struct nfs_fattr *);
+					   struct nfs_fattr *,
+					   struct cred *);
 #ifdef CONFIG_PROC_FS
 extern int __init nfs_fs_proc_init(void);
 extern void nfs_fs_proc_exit(void);
@@ -62,7 +65,9 @@ static inline void nfs_fs_proc_exit(void)
 
 /* nfs4namespace.c */
 #ifdef CONFIG_NFS_V4
-extern struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent, struct dentry *dentry);
+extern struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent,
+					struct dentry *dentry,
+					struct cred *acred);
 #else
 static inline
 struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent, struct dentry *dentry)
@@ -140,13 +145,16 @@ extern char *nfs_path(const char *base,
 		      char *buffer, ssize_t buflen);
 
 /* getroot.c */
-extern struct dentry *nfs_get_root(struct super_block *, struct nfs_fh *);
+extern struct dentry *nfs_get_root(struct super_block *, struct nfs_fh *,
+				   struct cred *);
 #ifdef CONFIG_NFS_V4
-extern struct dentry *nfs4_get_root(struct super_block *, struct nfs_fh *);
+extern struct dentry *nfs4_get_root(struct super_block *, struct nfs_fh *,
+				    struct cred *);
 
 extern int nfs4_path_walk(struct nfs_server *server,
 			  struct nfs_fh *mntfh,
-			  const char *path);
+			  const char *path,
+			  struct cred *acred);
 #endif
 
 /*
diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 8afd9f7..50da910 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -35,11 +35,12 @@ struct mnt_fhstatus {
  * @version: mount version to use for this request
  * @protocol: transport protocol to use for thie request
  * @fh: pointer to location to place returned file handle
+ * @cred: the credentials to use
  *
  * Uses default timeout parameters specified by underlying transport.
  */
 int nfs_mount(struct sockaddr *addr, size_t len, char *hostname, char *path,
-	      int version, int protocol, struct nfs_fh *fh)
+	      int version, int protocol, struct nfs_fh *fh, struct cred *acred)
 {
 	struct mnt_fhstatus	result = {
 		.fh		= fh
@@ -64,7 +65,7 @@ int nfs_mount(struct sockaddr *addr, size_t len, char *hostname, char *path,
 	dprintk("NFS: sending MNT request for %s:%s\n",
 		(hostname ? hostname : "server"), path);
 
-	mnt_clnt = rpc_create(&args);
+	mnt_clnt = rpc_create(&args, acred);
 	if (IS_ERR(mnt_clnt))
 		goto out_clnt_err;
 
@@ -73,7 +74,7 @@ int nfs_mount(struct sockaddr *addr, size_t len, char *hostname, char *path,
 	else
 		msg.rpc_proc = &mnt_clnt->cl_procinfo[MNTPROC_MNT];
 
-	status = rpc_call_sync(mnt_clnt, &msg, 0);
+	status = rpc_call_sync(mnt_clnt, &msg, 0, acred);
 	rpc_shutdown_client(mnt_clnt);
 
 	if (status < 0)
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index acfc56f..b8d3576 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -96,6 +96,7 @@ Elong:
  */
 static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct vfsmount *mnt;
 	struct nfs_server *server = NFS_SERVER(dentry->d_inode);
 	struct dentry *parent;
@@ -114,13 +115,13 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	parent = dget_parent(nd->dentry);
 	err = server->nfs_client->rpc_ops->lookup(parent->d_inode,
 						  &nd->dentry->d_name,
-						  &fh, &fattr);
+						  &fh, &fattr, acred);
 	dput(parent);
 	if (err != 0)
 		goto out_err;
 
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL)
-		mnt = nfs_do_refmount(nd->mnt, nd->dentry);
+		mnt = nfs_do_refmount(nd->mnt, nd->dentry, acred);
 	else
 		mnt = nfs_do_submount(nd->mnt, nd->dentry, &fh, &fattr);
 	err = PTR_ERR(mnt);
diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 7322da4..0fefed1 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -9,6 +9,7 @@
 
 ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int pos=0, len=0;
@@ -21,7 +22,7 @@ ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			len += sizeof(s);				\
 		} while(0)
 
-	acl = nfs3_proc_getacl(inode, ACL_TYPE_ACCESS);
+	acl = nfs3_proc_getacl(inode, ACL_TYPE_ACCESS, acred);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (acl) {
@@ -30,7 +31,7 @@ ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	}
 
 	if (S_ISDIR(inode->i_mode)) {
-		acl = nfs3_proc_getacl(inode, ACL_TYPE_DEFAULT);
+		acl = nfs3_proc_getacl(inode, ACL_TYPE_DEFAULT, acred);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 		if (acl) {
@@ -49,6 +50,7 @@ ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
 ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
 		void *buffer, size_t size)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int type, error = 0;
@@ -60,7 +62,7 @@ ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
 	else
 		return -EOPNOTSUPP;
 
-	acl = nfs3_proc_getacl(inode, type);
+	acl = nfs3_proc_getacl(inode, type, acred);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	else if (acl) {
@@ -78,6 +80,7 @@ ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
 int nfs3_setxattr(struct dentry *dentry, const char *name,
 	     const void *value, size_t size, int flags)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
 	int type, error;
@@ -92,7 +95,7 @@ int nfs3_setxattr(struct dentry *dentry, const char *name,
 	acl = posix_acl_from_xattr(value, size);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
-	error = nfs3_proc_setacl(inode, type, acl);
+	error = nfs3_proc_setacl(inode, type, acl, acred);
 	posix_acl_release(acl);
 
 	return error;
@@ -100,6 +103,7 @@ int nfs3_setxattr(struct dentry *dentry, const char *name,
 
 int nfs3_removexattr(struct dentry *dentry, const char *name)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int type;
 
@@ -110,7 +114,7 @@ int nfs3_removexattr(struct dentry *dentry, const char *name)
 	else
 		return -EOPNOTSUPP;
 
-	return nfs3_proc_setacl(inode, type, NULL);
+	return nfs3_proc_setacl(inode, type, NULL, acred);
 }
 
 static void __nfs3_forget_cached_acls(struct nfs_inode *nfsi)
@@ -179,7 +183,8 @@ static void nfs3_cache_acls(struct inode *inode, struct posix_acl *acl,
 	spin_unlock(&inode->i_lock);
 }
 
-struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
+struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type,
+				   struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs_fattr fattr;
@@ -202,7 +207,7 @@ struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
 	if (!nfs_server_capable(inode, NFS_CAP_ACLS))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	status = nfs_revalidate_inode(server, inode);
+	status = nfs_revalidate_inode(server, inode, acred);
 	if (status < 0)
 		return ERR_PTR(status);
 	acl = nfs3_get_cached_acl(inode, type);
@@ -225,7 +230,7 @@ struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type)
 
 	dprintk("NFS call getacl\n");
 	msg.rpc_proc = &server->client_acl->cl_procinfo[ACLPROC3_GETACL];
-	status = rpc_call_sync(server->client_acl, &msg, 0);
+	status = rpc_call_sync(server->client_acl, &msg, 0, acred);
 	dprintk("NFS reply getacl: %d\n", status);
 
 	/* pages may have been allocated at the xdr layer. */
@@ -283,7 +288,7 @@ getout:
 }
 
 static int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
-		  struct posix_acl *dfacl)
+		  struct posix_acl *dfacl, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs_fattr fattr;
@@ -319,7 +324,7 @@ static int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
 	dprintk("NFS call setacl\n");
 	nfs_begin_data_update(inode);
 	msg.rpc_proc = &server->client_acl->cl_procinfo[ACLPROC3_SETACL];
-	status = rpc_call_sync(server->client_acl, &msg, 0);
+	status = rpc_call_sync(server->client_acl, &msg, 0, acred);
 	spin_lock(&inode->i_lock);
 	NFS_I(inode)->cache_validity |= NFS_INO_INVALID_ACCESS;
 	spin_unlock(&inode->i_lock);
@@ -347,7 +352,8 @@ out:
 	return status;
 }
 
-int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
+int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl,
+		     struct cred *acred)
 {
 	struct posix_acl *alloc = NULL, *dfacl = NULL;
 	int status;
@@ -356,7 +362,7 @@ int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
 		switch(type) {
 			case ACL_TYPE_ACCESS:
 				alloc = dfacl = nfs3_proc_getacl(inode,
-						ACL_TYPE_DEFAULT);
+						ACL_TYPE_DEFAULT, acred);
 				if (IS_ERR(alloc))
 					goto fail;
 				break;
@@ -364,7 +370,7 @@ int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
 			case ACL_TYPE_DEFAULT:
 				dfacl = acl;
 				alloc = acl = nfs3_proc_getacl(inode,
-						ACL_TYPE_ACCESS);
+						ACL_TYPE_ACCESS, acred);
 				if (IS_ERR(alloc))
 					goto fail;
 				break;
@@ -380,7 +386,7 @@ int nfs3_proc_setacl(struct inode *inode, int type, struct posix_acl *acl)
 		if (IS_ERR(alloc))
 			goto fail;
 	}
-	status = nfs3_proc_setacls(inode, acl, dfacl);
+	status = nfs3_proc_setacls(inode, acl, dfacl, acred);
 	posix_acl_release(alloc);
 	return status;
 
@@ -389,12 +395,12 @@ fail:
 }
 
 int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
-		mode_t mode)
+		mode_t mode, struct cred *acred)
 {
 	struct posix_acl *dfacl, *acl;
 	int error = 0;
 
-	dfacl = nfs3_proc_getacl(dir, ACL_TYPE_DEFAULT);
+	dfacl = nfs3_proc_getacl(dir, ACL_TYPE_DEFAULT, acred);
 	if (IS_ERR(dfacl)) {
 		error = PTR_ERR(dfacl);
 		return (error == -EOPNOTSUPP) ? 0 : error;
@@ -408,8 +414,9 @@ int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
 	error = posix_acl_create_masq(acl, &mode);
 	if (error < 0)
 		goto out_release_acl;
-	error = nfs3_proc_setacls(inode, acl, S_ISDIR(inode->i_mode) ?
-						      dfacl : NULL);
+	error = nfs3_proc_setacls(inode, acl,
+				  S_ISDIR(inode->i_mode) ? dfacl : NULL,
+				  acred);
 out_release_acl:
 	posix_acl_release(acl);
 out_release_dfacl:
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 329e6a2..4d66cfd 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -25,13 +25,14 @@
 
 /* A wrapper to handle the EJUKEBOX error message */
 static int
-nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
+nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags,
+		 struct cred *acred)
 {
 	sigset_t oldset;
 	int res;
 	rpc_clnt_sigmask(clnt, &oldset);
 	do {
-		res = rpc_call_sync(clnt, msg, flags);
+		res = rpc_call_sync(clnt, msg, flags, acred);
 		if (res != -EJUKEBOX)
 			break;
 		schedule_timeout_interruptible(NFS_JUKEBOX_RETRY_TIME);
@@ -41,7 +42,8 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 	return res;
 }
 
-#define rpc_call_sync(clnt, msg, flags)	nfs3_rpc_wrapper(clnt, msg, flags)
+#define rpc_call_sync(clnt, msg, flags, acred) \
+	nfs3_rpc_wrapper(clnt, msg, flags, acred)
 
 static int
 nfs3_async_handle_jukebox(struct rpc_task *task, struct inode *inode)
@@ -57,7 +59,7 @@ nfs3_async_handle_jukebox(struct rpc_task *task, struct inode *inode)
 
 static int
 do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
-		 struct nfs_fsinfo *info)
+		 struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_FSINFO],
@@ -68,12 +70,12 @@ do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
 
 	dprintk("%s: call  fsinfo\n", __FUNCTION__);
 	nfs_fattr_init(info->fattr);
-	status = rpc_call_sync(client, &msg, 0);
+	status = rpc_call_sync(client, &msg, 0, acred);
 	dprintk("%s: reply fsinfo: %d\n", __FUNCTION__, status);
 	if (!(info->fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_resp = info->fattr;
-		status = rpc_call_sync(client, &msg, 0);
+		status = rpc_call_sync(client, &msg, 0, acred);
 		dprintk("%s: reply getattr: %d\n", __FUNCTION__, status);
 	}
 	return status;
@@ -84,13 +86,14 @@ do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
  */
 static int
 nfs3_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
-		   struct nfs_fsinfo *info)
+		   struct nfs_fsinfo *info, struct cred *acred)
 {
 	int	status;
 
-	status = do_proc_get_root(server->client, fhandle, info);
+	status = do_proc_get_root(server->client, fhandle, info, acred);
 	if (status && server->nfs_client->cl_rpcclient != server->client)
-		status = do_proc_get_root(server->nfs_client->cl_rpcclient, fhandle, info);
+		status = do_proc_get_root(server->nfs_client->cl_rpcclient,
+					  fhandle, info, acred);
 	return status;
 }
 
@@ -99,7 +102,7 @@ nfs3_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
  */
 static int
 nfs3_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_fattr *fattr)
+		struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_GETATTR],
@@ -110,14 +113,14 @@ nfs3_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  getattr\n");
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply getattr: %d\n", status);
 	return status;
 }
 
 static int
 nfs3_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
-			struct iattr *sattr)
+			struct iattr *sattr, struct cred *acred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct nfs3_sattrargs	arg = {
@@ -133,7 +136,7 @@ nfs3_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 	dprintk("NFS call  setattr\n");
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (status == 0)
 		nfs_setattr_update_inode(inode, sattr);
 	dprintk("NFS reply setattr: %d\n", status);
@@ -142,7 +145,8 @@ nfs3_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 static int
 nfs3_proc_lookup(struct inode *dir, struct qstr *name,
-		 struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+		 struct nfs_fh *fhandle, struct nfs_fattr *fattr,
+		 struct cred *acred)
 {
 	struct nfs_fattr	dir_attr;
 	struct nfs3_diropargs	arg = {
@@ -165,12 +169,12 @@ nfs3_proc_lookup(struct inode *dir, struct qstr *name,
 	dprintk("NFS call  lookup %s\n", name->name);
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (status >= 0 && !(fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_argp = fhandle;
 		msg.rpc_resp = fattr;
-		status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+		status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	}
 	dprintk("NFS reply lookup: %d\n", status);
 	if (status >= 0)
@@ -178,7 +182,8 @@ nfs3_proc_lookup(struct inode *dir, struct qstr *name,
 	return status;
 }
 
-static int nfs3_proc_access(struct inode *inode, struct nfs_access_entry *entry)
+static int nfs3_proc_access(struct inode *inode, struct nfs_access_entry *entry,
+			    struct cred *acred)
 {
 	struct nfs_fattr	fattr;
 	struct nfs3_accessargs	arg = {
@@ -212,7 +217,7 @@ static int nfs3_proc_access(struct inode *inode, struct nfs_access_entry *entry)
 			arg.access |= NFS3_ACCESS_EXECUTE;
 	}
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	nfs_refresh_inode(inode, &fattr);
 	if (status == 0) {
 		entry->mask = 0;
@@ -228,7 +233,7 @@ static int nfs3_proc_access(struct inode *inode, struct nfs_access_entry *entry)
 }
 
 static int nfs3_proc_readlink(struct inode *inode, struct page *page,
-		unsigned int pgbase, unsigned int pglen)
+		unsigned int pgbase, unsigned int pglen, struct cred *acred)
 {
 	struct nfs_fattr	fattr;
 	struct nfs3_readlinkargs args = {
@@ -246,7 +251,7 @@ static int nfs3_proc_readlink(struct inode *inode, struct page *page,
 
 	dprintk("NFS call  readlink\n");
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	nfs_refresh_inode(inode, &fattr);
 	dprintk("NFS reply readlink: %d\n", status);
 	return status;
@@ -258,7 +263,7 @@ static int nfs3_proc_readlink(struct inode *inode, struct page *page,
  */
 static int
 nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		 int flags, struct nameidata *nd)
+		 int flags, struct nameidata *nd, struct cred *acred)
 {
 	struct nfs_fh		fhandle;
 	struct nfs_fattr	fattr;
@@ -295,7 +300,7 @@ nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 again:
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_refresh_inode(dir, &dir_attr);
 
 	/* If the server doesn't support the exclusive creation semantics,
@@ -317,7 +322,7 @@ again:
 	}
 
 	if (status == 0)
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	if (status != 0)
 		goto out;
 
@@ -334,20 +339,20 @@ again:
 		/* Note: we could use a guarded setattr here, but I'm
 		 * not sure this buys us anything (and I'd have
 		 * to revamp the NFSv3 XDR code) */
-		status = nfs3_proc_setattr(dentry, &fattr, sattr);
+		status = nfs3_proc_setattr(dentry, &fattr, sattr, acred);
 		nfs_post_op_update_inode(dentry->d_inode, &fattr);
 		dprintk("NFS reply setattr (post-create): %d\n", status);
 	}
 	if (status != 0)
 		goto out;
-	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
+	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode, acred);
 out:
 	dprintk("NFS reply create: %d\n", status);
 	return status;
 }
 
 static int
-nfs3_proc_remove(struct inode *dir, struct qstr *name)
+nfs3_proc_remove(struct inode *dir, struct qstr *name, struct cred *acred)
 {
 	struct nfs_removeargs arg = {
 		.fh = NFS_FH(dir),
@@ -364,7 +369,7 @@ nfs3_proc_remove(struct inode *dir, struct qstr *name)
 
 	dprintk("NFS call  remove %s\n", name->name);
 	nfs_fattr_init(&res.dir_attr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &res.dir_attr);
 	dprintk("NFS reply remove: %d\n", status);
 	return status;
@@ -389,7 +394,8 @@ nfs3_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 
 static int
 nfs3_proc_rename(struct inode *old_dir, struct qstr *old_name,
-		 struct inode *new_dir, struct qstr *new_name)
+		 struct inode *new_dir, struct qstr *new_name,
+		 struct cred *acred)
 {
 	struct nfs_fattr	old_dir_attr, new_dir_attr;
 	struct nfs3_renameargs	arg = {
@@ -414,7 +420,7 @@ nfs3_proc_rename(struct inode *old_dir, struct qstr *old_name,
 	dprintk("NFS call  rename %s -> %s\n", old_name->name, new_name->name);
 	nfs_fattr_init(&old_dir_attr);
 	nfs_fattr_init(&new_dir_attr);
-	status = rpc_call_sync(NFS_CLIENT(old_dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(old_dir), &msg, 0, acred);
 	nfs_post_op_update_inode(old_dir, &old_dir_attr);
 	nfs_post_op_update_inode(new_dir, &new_dir_attr);
 	dprintk("NFS reply rename: %d\n", status);
@@ -422,7 +428,8 @@ nfs3_proc_rename(struct inode *old_dir, struct qstr *old_name,
 }
 
 static int
-nfs3_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
+nfs3_proc_link(struct inode *inode, struct inode *dir, struct qstr *name,
+	       struct cred *acred)
 {
 	struct nfs_fattr	dir_attr, fattr;
 	struct nfs3_linkargs	arg = {
@@ -445,7 +452,7 @@ nfs3_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
 	dprintk("NFS call  link %s\n", name->name);
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &dir_attr);
 	nfs_post_op_update_inode(inode, &fattr);
 	dprintk("NFS reply link: %d\n", status);
@@ -454,7 +461,7 @@ nfs3_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
 
 static int
 nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
-		  unsigned int len, struct iattr *sattr)
+		  unsigned int len, struct iattr *sattr, struct cred *acred)
 {
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr, dir_attr;
@@ -485,18 +492,18 @@ nfs3_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &dir_attr);
 	if (status != 0)
 		goto out;
-	status = nfs_instantiate(dentry, &fhandle, &fattr);
+	status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 out:
 	dprintk("NFS reply symlink: %d\n", status);
 	return status;
 }
 
 static int
-nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
+nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr, struct cred *acred)
 {
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr, dir_attr;
@@ -525,21 +532,21 @@ nfs3_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
 
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &dir_attr);
 	if (status != 0)
 		goto out;
-	status = nfs_instantiate(dentry, &fhandle, &fattr);
+	status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	if (status != 0)
 		goto out;
-	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
+	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode, acred);
 out:
 	dprintk("NFS reply mkdir: %d\n", status);
 	return status;
 }
 
 static int
-nfs3_proc_rmdir(struct inode *dir, struct qstr *name)
+nfs3_proc_rmdir(struct inode *dir, struct qstr *name, struct cred *acred)
 {
 	struct nfs_fattr	dir_attr;
 	struct nfs3_diropargs	arg = {
@@ -556,7 +563,7 @@ nfs3_proc_rmdir(struct inode *dir, struct qstr *name)
 
 	dprintk("NFS call  rmdir %s\n", name->name);
 	nfs_fattr_init(&dir_attr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &dir_attr);
 	dprintk("NFS reply rmdir: %d\n", status);
 	return status;
@@ -573,7 +580,8 @@ nfs3_proc_rmdir(struct inode *dir, struct qstr *name)
  */
 static int
 nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-		  u64 cookie, struct page *page, unsigned int count, int plus)
+		  u64 cookie, struct page *page, unsigned int count, int plus,
+		  struct cred *acred)
 {
 	struct inode		*dir = dentry->d_inode;
 	struct nfs_fattr	dir_attr;
@@ -606,7 +614,7 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 			plus? "plus" : "", (unsigned int) cookie);
 
 	nfs_fattr_init(&dir_attr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_refresh_inode(dir, &dir_attr);
 	dprintk("NFS reply readdir: %d\n", status);
 	return status;
@@ -614,7 +622,7 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 
 static int
 nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		dev_t rdev)
+		dev_t rdev, struct cred *acred)
 {
 	struct nfs_fh fh;
 	struct nfs_fattr fattr, dir_attr;
@@ -653,14 +661,14 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 
 	nfs_fattr_init(&dir_attr);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_post_op_update_inode(dir, &dir_attr);
 	if (status != 0)
 		goto out;
-	status = nfs_instantiate(dentry, &fh, &fattr);
+	status = nfs_instantiate(dentry, &fh, &fattr, acred);
 	if (status != 0)
 		goto out;
-	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode);
+	status = nfs3_proc_set_default_acl(dir, dentry->d_inode, mode, acred);
 out:
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
@@ -668,7 +676,7 @@ out:
 
 static int
 nfs3_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
-		 struct nfs_fsstat *stat)
+		 struct nfs_fsstat *stat, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_FSSTAT],
@@ -679,14 +687,14 @@ nfs3_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  fsstat\n");
 	nfs_fattr_init(stat->fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply statfs: %d\n", status);
 	return status;
 }
 
 static int
 nfs3_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
-		 struct nfs_fsinfo *info)
+		 struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_FSINFO],
@@ -697,14 +705,15 @@ nfs3_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  fsinfo\n");
 	nfs_fattr_init(info->fattr);
-	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0);
+	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0,
+			       acred);
 	dprintk("NFS reply fsinfo: %d\n", status);
 	return status;
 }
 
 static int
 nfs3_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle,
-		   struct nfs_pathconf *info)
+		   struct nfs_pathconf *info, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_PATHCONF],
@@ -715,7 +724,7 @@ nfs3_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  pathconf\n");
 	nfs_fattr_init(info->fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply pathconf: %d\n", status);
 	return status;
 }
@@ -730,7 +739,7 @@ static int nfs3_read_done(struct rpc_task *task, struct nfs_read_data *data)
 	return 0;
 }
 
-static void nfs3_proc_read_setup(struct nfs_read_data *data)
+static void nfs3_proc_read_setup(struct nfs_read_data *data, struct cred *acred)
 {
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_READ],
@@ -739,7 +748,7 @@ static void nfs3_proc_read_setup(struct nfs_read_data *data)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int nfs3_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -751,7 +760,8 @@ static int nfs3_write_done(struct rpc_task *task, struct nfs_write_data *data)
 	return 0;
 }
 
-static void nfs3_proc_write_setup(struct nfs_write_data *data, int how)
+static void nfs3_proc_write_setup(struct nfs_write_data *data, int how,
+				  struct cred *acred)
 {
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_WRITE],
@@ -768,7 +778,7 @@ static void nfs3_proc_write_setup(struct nfs_write_data *data, int how)
 	}
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int nfs3_commit_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -780,7 +790,8 @@ static int nfs3_commit_done(struct rpc_task *task, struct nfs_write_data *data)
 	return 0;
 }
 
-static void nfs3_proc_commit_setup(struct nfs_write_data *data, int how)
+static void nfs3_proc_commit_setup(struct nfs_write_data *data, int how,
+				   struct cred *acred)
 {
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs3_procedures[NFS3PROC_COMMIT],
@@ -789,13 +800,14 @@ static void nfs3_proc_commit_setup(struct nfs_write_data *data, int how)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int
 nfs3_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
-	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
+	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl,
+			    filp->f_cred);
 }
 
 const struct nfs_rpc_ops nfs_v3_clientops = {
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index d2802b1..007329e 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -174,16 +174,25 @@ extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
 
 /* nfs4proc.c */
 extern int nfs4_map_errors(int err);
-extern int nfs4_proc_setclientid(struct nfs_client *, u32, unsigned short, struct rpc_cred *);
-extern int nfs4_proc_setclientid_confirm(struct nfs_client *, struct rpc_cred *);
-extern int nfs4_proc_async_renew(struct nfs_client *, struct rpc_cred *);
-extern int nfs4_proc_renew(struct nfs_client *, struct rpc_cred *);
-extern int nfs4_do_close(struct path *path, struct nfs4_state *state);
-extern struct dentry *nfs4_atomic_open(struct inode *, struct dentry *, struct nameidata *);
-extern int nfs4_open_revalidate(struct inode *, struct dentry *, int, struct nameidata *);
-extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle);
+extern int nfs4_proc_setclientid(struct nfs_client *, u32, unsigned short,
+				 struct rpc_cred *, struct cred *);
+extern int nfs4_proc_setclientid_confirm(struct nfs_client *, struct rpc_cred *,
+					 struct cred *);
+extern int nfs4_proc_async_renew(struct nfs_client *, struct rpc_cred *,
+				 struct cred *);
+extern int nfs4_proc_renew(struct nfs_client *, struct rpc_cred *,
+			   struct cred *);
+extern int nfs4_do_close(struct path *path, struct nfs4_state *state,
+			 struct cred *acred);
+extern struct dentry *nfs4_atomic_open(struct inode *, struct dentry *,
+				       struct nameidata *, struct cred *);
+extern int nfs4_open_revalidate(struct inode *, struct dentry *, int,
+				struct nameidata *, struct cred *);
+extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle,
+				    struct cred *acred);
 extern int nfs4_proc_fs_locations(struct inode *dir, const struct qstr *name,
-		struct nfs4_fs_locations *fs_locations, struct page *page);
+		struct nfs4_fs_locations *fs_locations, struct page *page,
+		struct cred *acred);
 
 extern struct nfs4_state_recovery_ops nfs4_reboot_recovery_ops;
 extern struct nfs4_state_recovery_ops nfs4_network_partition_recovery_ops;
@@ -208,7 +217,8 @@ extern void nfs4_put_state_owner(struct nfs4_state_owner *);
 extern void nfs4_drop_state_owner(struct nfs4_state_owner *);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
-extern void nfs4_close_state(struct path *, struct nfs4_state *, mode_t);
+extern void nfs4_close_state(struct path *, struct nfs4_state *, mode_t,
+			     struct cred *);
 extern void nfs4_state_set_mode_locked(struct nfs4_state *, mode_t);
 extern void nfs4_schedule_state_recovery(struct nfs_client *);
 extern void nfs4_put_lock_state(struct nfs4_lock_state *lsp);
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index dd5fef2..1d2f2f2 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -212,9 +212,11 @@ out:
  * nfs_do_refmount - handle crossing a referral on server
  * @dentry - dentry of referral
  * @nd - nameidata info
+ * @acred - the credentials to use
  *
  */
-struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent, struct dentry *dentry)
+struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent,
+				 struct dentry *dentry, struct cred *acred)
 {
 	struct vfsmount *mnt = ERR_PTR(-ENOMEM);
 	struct dentry *parent;
@@ -240,7 +242,8 @@ struct vfsmount *nfs_do_refmount(const struct vfsmount *mnt_parent, struct dentr
 	dprintk("%s: getting locations for %s/%s\n",
 		__FUNCTION__, parent->d_name.name, dentry->d_name.name);
 
-	err = nfs4_proc_fs_locations(parent->d_inode, &dentry->d_name, fs_locations, page);
+	err = nfs4_proc_fs_locations(parent->d_inode, &dentry->d_name,
+				     fs_locations, page, acred);
 	dput(parent);
 	if (err != 0 ||
 	    fs_locations->nlocations <= 0 ||
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 943095d..83c9b66 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -59,15 +59,22 @@
 #define NFS4_POLL_RETRY_MAX	(15*HZ)
 
 struct nfs4_opendata;
-static int _nfs4_proc_open(struct nfs4_opendata *data);
-static int nfs4_do_fsinfo(struct nfs_server *, struct nfs_fh *, struct nfs_fsinfo *);
+static int _nfs4_proc_open(struct nfs4_opendata *data, struct cred *acred);
+static int nfs4_do_fsinfo(struct nfs_server *, struct nfs_fh *,
+			  struct nfs_fsinfo *, struct cred *);
 static int nfs4_async_handle_error(struct rpc_task *, const struct nfs_server *);
-static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry);
+static int _nfs4_proc_access(struct inode *inode,
+			     struct nfs_access_entry *entry,
+			     struct cred *acred);
 static int nfs4_handle_exception(const struct nfs_server *server, int errorcode, struct nfs4_exception *exception);
 static int nfs4_wait_clnt_recover(struct rpc_clnt *clnt, struct nfs_client *clp);
-static int _nfs4_do_access(struct inode *inode, struct rpc_cred *cred, int openflags);
-static int _nfs4_proc_lookup(struct inode *dir, const struct qstr *name, struct nfs_fh *fhandle, struct nfs_fattr *fattr);
-static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fattr *fattr);
+static int _nfs4_do_access(struct inode *inode, struct rpc_cred *cred,
+			   int openflags, struct cred *acred);
+static int _nfs4_proc_lookup(struct inode *dir, const struct qstr *name,
+			     struct nfs_fh *fhandle, struct nfs_fattr *fattr,
+			     struct cred *acred);
+static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
+			      struct nfs_fattr *fattr, struct cred *acred);
 
 /* Prevent leaks of NFSv4 errors into userland */
 int nfs4_map_errors(int err)
@@ -424,7 +431,8 @@ static void nfs4_return_incompatible_delegation(struct inode *inode, mode_t open
 	nfs_inode_return_delegation(inode);
 }
 
-static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
+static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata,
+					       struct cred *acred)
 {
 	struct nfs4_state *state = opendata->state;
 	struct nfs_inode *nfsi = NFS_I(state->inode);
@@ -454,7 +462,8 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 		memcpy(stateid.data, delegation->stateid.data, sizeof(stateid.data));
 		rcu_read_unlock();
 		lock_kernel();
-		ret = _nfs4_do_access(state->inode, state->owner->so_cred, open_mode);
+		ret = _nfs4_do_access(state->inode, state->owner->so_cred,
+				      open_mode, acred);
 		unlock_kernel();
 		if (ret != 0)
 			goto out;
@@ -479,7 +488,8 @@ out_return_state:
 	return state;
 }
 
-static struct nfs4_state *nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data)
+static struct nfs4_state *nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data,
+						      struct cred *acred)
 {
 	struct inode *inode;
 	struct nfs4_state *state = NULL;
@@ -488,7 +498,7 @@ static struct nfs4_state *nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data
 	int ret;
 
 	if (!data->rpc_done) {
-		state = nfs4_try_open_cached(data);
+		state = nfs4_try_open_cached(data, acred);
 		goto out;
 	}
 
@@ -514,11 +524,11 @@ static struct nfs4_state *nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data
 		if (!(delegation_flags & NFS_DELEGATION_NEED_RECLAIM))
 			nfs_inode_set_delegation(state->inode,
 					data->owner->so_cred,
-					&data->o_res);
+					&data->o_res, acred);
 		else
 			nfs_inode_reclaim_delegation(state->inode,
 					data->owner->so_cred,
-					&data->o_res);
+					&data->o_res, acred);
 	}
 	rcu_read_lock();
 	delegation = rcu_dereference(NFS_I(inode)->delegation);
@@ -564,7 +574,9 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 	return opendata;
 }
 
-static int nfs4_open_recover_helper(struct nfs4_opendata *opendata, mode_t openflags, struct nfs4_state **res)
+static int nfs4_open_recover_helper(struct nfs4_opendata *opendata,
+				    mode_t openflags, struct nfs4_state **res,
+				    struct cred *acred)
 {
 	struct nfs4_state *newstate;
 	int ret;
@@ -573,18 +585,19 @@ static int nfs4_open_recover_helper(struct nfs4_opendata *opendata, mode_t openf
 	memset(&opendata->o_res, 0, sizeof(opendata->o_res));
 	memset(&opendata->c_res, 0, sizeof(opendata->c_res));
 	nfs4_init_opendata_res(opendata);
-	ret = _nfs4_proc_open(opendata);
+	ret = _nfs4_proc_open(opendata, acred);
 	if (ret != 0)
 		return ret; 
-	newstate = nfs4_opendata_to_nfs4_state(opendata);
+	newstate = nfs4_opendata_to_nfs4_state(opendata, acred);
 	if (IS_ERR(newstate))
 		return PTR_ERR(newstate);
-	nfs4_close_state(&opendata->path, newstate, openflags);
+	nfs4_close_state(&opendata->path, newstate, openflags, acred);
 	*res = newstate;
 	return 0;
 }
 
-static int nfs4_open_recover(struct nfs4_opendata *opendata, struct nfs4_state *state)
+static int nfs4_open_recover(struct nfs4_opendata *opendata,
+			     struct nfs4_state *state, struct cred *acred)
 {
 	struct nfs4_state *newstate;
 	int ret;
@@ -593,21 +606,24 @@ static int nfs4_open_recover(struct nfs4_opendata *opendata, struct nfs4_state *
 	clear_bit(NFS_DELEGATED_STATE, &state->flags);
 	smp_rmb();
 	if (state->n_rdwr != 0) {
-		ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE, &newstate);
+		ret = nfs4_open_recover_helper(opendata, FMODE_READ|FMODE_WRITE,
+					       &newstate, acred);
 		if (ret != 0)
 			return ret;
 		if (newstate != state)
 			return -ESTALE;
 	}
 	if (state->n_wronly != 0) {
-		ret = nfs4_open_recover_helper(opendata, FMODE_WRITE, &newstate);
+		ret = nfs4_open_recover_helper(opendata, FMODE_WRITE, &newstate,
+					       acred);
 		if (ret != 0)
 			return ret;
 		if (newstate != state)
 			return -ESTALE;
 	}
 	if (state->n_rdonly != 0) {
-		ret = nfs4_open_recover_helper(opendata, FMODE_READ, &newstate);
+		ret = nfs4_open_recover_helper(opendata, FMODE_READ, &newstate,
+					       acred);
 		if (ret != 0)
 			return ret;
 		if (newstate != state)
@@ -631,7 +647,8 @@ static int nfs4_open_recover(struct nfs4_opendata *opendata, struct nfs4_state *
  * OPEN_RECLAIM:
  * 	reclaim state on the server after a reboot.
  */
-static int _nfs4_do_open_reclaim(struct nfs_open_context *ctx, struct nfs4_state *state)
+static int _nfs4_do_open_reclaim(struct nfs_open_context *ctx,
+				 struct nfs4_state *state, struct cred *acred)
 {
 	struct nfs_delegation *delegation;
 	struct nfs4_opendata *opendata;
@@ -649,18 +666,19 @@ static int _nfs4_do_open_reclaim(struct nfs_open_context *ctx, struct nfs4_state
 		delegation_type = delegation->type;
 	rcu_read_unlock();
 	opendata->o_arg.u.delegation_type = delegation_type;
-	status = nfs4_open_recover(opendata, state);
+	status = nfs4_open_recover(opendata, state, acred);
 	nfs4_opendata_put(opendata);
 	return status;
 }
 
-static int nfs4_do_open_reclaim(struct nfs_open_context *ctx, struct nfs4_state *state)
+static int nfs4_do_open_reclaim(struct nfs_open_context *ctx,
+				struct nfs4_state *state, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs4_exception exception = { };
 	int err;
 	do {
-		err = _nfs4_do_open_reclaim(ctx, state);
+		err = _nfs4_do_open_reclaim(ctx, state, acred);
 		if (err != -NFS4ERR_DELAY)
 			break;
 		nfs4_handle_exception(server, err, &exception);
@@ -668,7 +686,8 @@ static int nfs4_do_open_reclaim(struct nfs_open_context *ctx, struct nfs4_state
 	return err;
 }
 
-static int nfs4_open_reclaim(struct nfs4_state_owner *sp, struct nfs4_state *state)
+static int nfs4_open_reclaim(struct nfs4_state_owner *sp,
+			     struct nfs4_state *state)
 {
 	struct nfs_open_context *ctx;
 	int ret;
@@ -676,7 +695,7 @@ static int nfs4_open_reclaim(struct nfs4_state_owner *sp, struct nfs4_state *sta
 	ctx = nfs4_state_find_open_context(state);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
-	ret = nfs4_do_open_reclaim(ctx, state);
+	ret = nfs4_do_open_reclaim(ctx, state, ctx->acred);
 	put_nfs_open_context(ctx);
 	return ret;
 }
@@ -692,7 +711,7 @@ static int _nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs
 	opendata->o_arg.claim = NFS4_OPEN_CLAIM_DELEGATE_CUR;
 	memcpy(opendata->o_arg.u.delegation.data, stateid->data,
 			sizeof(opendata->o_arg.u.delegation.data));
-	ret = nfs4_open_recover(opendata, state);
+	ret = nfs4_open_recover(opendata, state, ctx->acred);
 	nfs4_opendata_put(opendata);
 	return ret;
 }
@@ -749,7 +768,7 @@ static void nfs4_open_confirm_done(struct rpc_task *task, void *calldata)
 	nfs_increment_open_seqid(data->rpc_status, data->c_arg.seqid);
 }
 
-static void nfs4_open_confirm_release(void *calldata)
+static void nfs4_open_confirm_release(struct cred *acred, void *calldata)
 {
 	struct nfs4_opendata *data = calldata;
 	struct nfs4_state *state = NULL;
@@ -761,9 +780,10 @@ static void nfs4_open_confirm_release(void *calldata)
 	if (!data->rpc_done)
 		goto out_free;
 	nfs_confirm_seqid(&data->owner->so_seqid, 0);
-	state = nfs4_opendata_to_nfs4_state(data);
+	state = nfs4_opendata_to_nfs4_state(data, acred);
 	if (!IS_ERR(state))
-		nfs4_close_state(&data->path, state, data->o_arg.open_flags);
+		nfs4_close_state(&data->path, state, data->o_arg.open_flags,
+				 acred);
 out_free:
 	nfs4_opendata_put(data);
 }
@@ -777,7 +797,8 @@ static const struct rpc_call_ops nfs4_open_confirm_ops = {
 /*
  * Note: On error, nfs4_proc_open_confirm will free the struct nfs4_opendata
  */
-static int _nfs4_proc_open_confirm(struct nfs4_opendata *data)
+static int _nfs4_proc_open_confirm(struct nfs4_opendata *data,
+				   struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(data->dir->d_inode);
 	struct rpc_task *task;
@@ -786,7 +807,8 @@ static int _nfs4_proc_open_confirm(struct nfs4_opendata *data)
 	kref_get(&data->kref);
 	data->rpc_done = 0;
 	data->rpc_status = 0;
-	task = rpc_run_task(server->client, RPC_TASK_ASYNC, &nfs4_open_confirm_ops, data);
+	task = rpc_run_task(server->client, RPC_TASK_ASYNC,
+			    &nfs4_open_confirm_ops, data, acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	status = nfs4_wait_for_completion_rpc_task(task);
@@ -873,7 +895,7 @@ static void nfs4_open_done(struct rpc_task *task, void *calldata)
 	data->rpc_done = 1;
 }
 
-static void nfs4_open_release(void *calldata)
+static void nfs4_open_release(struct cred *acred, void *calldata)
 {
 	struct nfs4_opendata *data = calldata;
 	struct nfs4_state *state = NULL;
@@ -888,9 +910,10 @@ static void nfs4_open_release(void *calldata)
 	if (data->o_res.rflags & NFS4_OPEN_RESULT_CONFIRM)
 		goto out_free;
 	nfs_confirm_seqid(&data->owner->so_seqid, 0);
-	state = nfs4_opendata_to_nfs4_state(data);
+	state = nfs4_opendata_to_nfs4_state(data, acred);
 	if (!IS_ERR(state))
-		nfs4_close_state(&data->path, state, data->o_arg.open_flags);
+		nfs4_close_state(&data->path, state, data->o_arg.open_flags,
+				 acred);
 out_free:
 	nfs4_opendata_put(data);
 }
@@ -904,7 +927,7 @@ static const struct rpc_call_ops nfs4_open_ops = {
 /*
  * Note: On error, nfs4_proc_open will free the struct nfs4_opendata
  */
-static int _nfs4_proc_open(struct nfs4_opendata *data)
+static int _nfs4_proc_open(struct nfs4_opendata *data, struct cred *acred)
 {
 	struct inode *dir = data->dir->d_inode;
 	struct nfs_server *server = NFS_SERVER(dir);
@@ -917,7 +940,8 @@ static int _nfs4_proc_open(struct nfs4_opendata *data)
 	data->rpc_done = 0;
 	data->rpc_status = 0;
 	data->cancelled = 0;
-	task = rpc_run_task(server->client, RPC_TASK_ASYNC, &nfs4_open_ops, data);
+	task = rpc_run_task(server->client, RPC_TASK_ASYNC, &nfs4_open_ops,
+			    data, acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	status = nfs4_wait_for_completion_rpc_task(task);
@@ -931,7 +955,8 @@ static int _nfs4_proc_open(struct nfs4_opendata *data)
 		return status;
 
 	if (o_res->fh.size == 0)
-		_nfs4_proc_lookup(dir, o_arg->name, &o_res->fh, o_res->f_attr);
+		_nfs4_proc_lookup(dir, o_arg->name, &o_res->fh, o_res->f_attr,
+				  acred);
 
 	if (o_arg->open_flags & O_CREAT) {
 		update_changeattr(dir, &o_res->cinfo);
@@ -939,16 +964,17 @@ static int _nfs4_proc_open(struct nfs4_opendata *data)
 	} else
 		nfs_refresh_inode(dir, o_res->dir_attr);
 	if(o_res->rflags & NFS4_OPEN_RESULT_CONFIRM) {
-		status = _nfs4_proc_open_confirm(data);
+		status = _nfs4_proc_open_confirm(data, acred);
 		if (status != 0)
 			return status;
 	}
 	if (!(o_res->f_attr->valid & NFS_ATTR_FATTR))
-		_nfs4_proc_getattr(server, &o_res->fh, o_res->f_attr);
+		_nfs4_proc_getattr(server, &o_res->fh, o_res->f_attr, acred);
 	return 0;
 }
 
-static int _nfs4_do_access(struct inode *inode, struct rpc_cred *cred, int openflags)
+static int _nfs4_do_access(struct inode *inode, struct rpc_cred *cred,
+			   int openflags, struct cred *acred)
 {
 	struct nfs_access_entry cache;
 	int mask = 0;
@@ -968,7 +994,7 @@ static int _nfs4_do_access(struct inode *inode, struct rpc_cred *cred, int openf
 	cache.mask = MAY_EXEC | MAY_WRITE | MAY_READ;
 	cache.cred = cred;
 	cache.jiffies = jiffies;
-	status = _nfs4_proc_access(inode, &cache);
+	status = _nfs4_proc_access(inode, &cache, acred);
 	if (status != 0)
 		return status;
 	nfs_access_add_cache(inode, &cache);
@@ -1007,7 +1033,7 @@ static int _nfs4_open_expired(struct nfs_open_context *ctx, struct nfs4_state *s
 	opendata = nfs4_open_recoverdata_alloc(ctx, state);
 	if (IS_ERR(opendata))
 		return PTR_ERR(opendata);
-	ret = nfs4_open_recover(opendata, state);
+	ret = nfs4_open_recover(opendata, state, ctx->acred);
 	if (ret == -ESTALE) {
 		/* Invalidate the state owner so we don't ever use it again */
 		nfs4_drop_state_owner(state->owner);
@@ -1063,7 +1089,9 @@ static inline void nfs4_exclusive_attrset(struct nfs4_opendata *opendata, struct
 /*
  * Returns a referenced nfs4_state
  */
-static int _nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct rpc_cred *cred, struct nfs4_state **res)
+static int _nfs4_do_open(struct inode *dir, struct path *path, int flags,
+			 struct iattr *sattr, struct rpc_cred *cred,
+			 struct nfs4_state **res, struct cred *acred)
 {
 	struct nfs4_state_owner  *sp;
 	struct nfs4_state     *state = NULL;
@@ -1092,14 +1120,14 @@ static int _nfs4_do_open(struct inode *dir, struct path *path, int flags, struct
 	if (path->dentry->d_inode != NULL)
 		opendata->state = nfs4_get_open_state(path->dentry->d_inode, sp);
 
-	status = _nfs4_proc_open(opendata);
+	status = _nfs4_proc_open(opendata, acred);
 	if (status != 0)
 		goto err_opendata_put;
 
 	if (opendata->o_arg.open_flags & O_EXCL)
 		nfs4_exclusive_attrset(opendata, sattr);
 
-	state = nfs4_opendata_to_nfs4_state(opendata);
+	state = nfs4_opendata_to_nfs4_state(opendata, acred);
 	status = PTR_ERR(state);
 	if (IS_ERR(state))
 		goto err_opendata_put;
@@ -1120,14 +1148,18 @@ out_err:
 }
 
 
-static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path, int flags, struct iattr *sattr, struct rpc_cred *cred)
+static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path,
+				       int flags, struct iattr *sattr,
+				       struct rpc_cred *cred,
+				       struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	struct nfs4_state *res;
 	int status;
 
 	do {
-		status = _nfs4_do_open(dir, path, flags, sattr, cred, &res);
+		status = _nfs4_do_open(dir, path, flags, sattr, cred, &res,
+				       acred);
 		if (status == 0)
 			break;
 		/* NOTE: BAD_SEQID means the server and client disagree about the
@@ -1170,7 +1202,8 @@ static struct nfs4_state *nfs4_do_open(struct inode *dir, struct path *path, int
 }
 
 static int _nfs4_do_setattr(struct inode *inode, struct nfs_fattr *fattr,
-                struct iattr *sattr, struct nfs4_state *state)
+                struct iattr *sattr, struct nfs4_state *state,
+		struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
         struct nfs_setattrargs  arg = {
@@ -1201,21 +1234,23 @@ static int _nfs4_do_setattr(struct inode *inode, struct nfs_fattr *fattr,
 	} else
 		memcpy(&arg.stateid, &zero_stateid, sizeof(arg.stateid));
 
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	if (status == 0 && state != NULL)
 		renew_lease(server, timestamp);
 	return status;
 }
 
 static int nfs4_do_setattr(struct inode *inode, struct nfs_fattr *fattr,
-                struct iattr *sattr, struct nfs4_state *state)
+                struct iattr *sattr, struct nfs4_state *state,
+		struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_do_setattr(inode, fattr, sattr, state),
+				_nfs4_do_setattr(inode, fattr, sattr, state,
+						 acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1231,7 +1266,7 @@ struct nfs4_closedata {
 	unsigned long timestamp;
 };
 
-static void nfs4_free_closedata(void *data)
+static void nfs4_free_closedata(struct cred *acred, void *data)
 {
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state_owner *sp = calldata->state->owner;
@@ -1336,7 +1371,8 @@ static const struct rpc_call_ops nfs4_close_ops = {
  *
  * NOTE: Caller must be holding the sp->so_owner semaphore!
  */
-int nfs4_do_close(struct path *path, struct nfs4_state *state)
+int nfs4_do_close(struct path *path, struct nfs4_state *state,
+		  struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs4_closedata *calldata;
@@ -1361,7 +1397,8 @@ int nfs4_do_close(struct path *path, struct nfs4_state *state)
 	calldata->path.mnt = mntget(path->mnt);
 	calldata->path.dentry = dget(path->dentry);
 
-	task = rpc_run_task(server->client, RPC_TASK_ASYNC, &nfs4_close_ops, calldata);
+	task = rpc_run_task(server->client, RPC_TASK_ASYNC, &nfs4_close_ops,
+			    calldata, acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	rpc_put_task(task);
@@ -1374,7 +1411,8 @@ out:
 	return status;
 }
 
-static int nfs4_intent_set_file(struct nameidata *nd, struct path *path, struct nfs4_state *state)
+static int nfs4_intent_set_file(struct nameidata *nd, struct path *path,
+				struct nfs4_state *state, struct cred *acred)
 {
 	struct file *filp;
 	int ret;
@@ -1383,7 +1421,7 @@ static int nfs4_intent_set_file(struct nameidata *nd, struct path *path, struct
 	if (nd->intent.open.flags & FMODE_EXEC) {
 		ret = _nfs4_do_access(state->inode,
 				state->owner->so_cred,
-				nd->intent.open.flags);
+				      nd->intent.open.flags, acred);
 		if (ret < 0)
 			goto out_close;
 	}
@@ -1396,14 +1434,14 @@ static int nfs4_intent_set_file(struct nameidata *nd, struct path *path, struct
 	}
 	ret = PTR_ERR(filp);
 out_close:
-	nfs4_close_state(path, state, nd->intent.open.flags);
+	nfs4_close_state(path, state, nd->intent.open.flags, acred);
 	return ret;
 }
 
 struct dentry *
-nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd,
+		 struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1426,7 +1464,8 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(cred))
 		return (struct dentry *)cred;
-	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
+	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred,
+			     acred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT)
@@ -1436,14 +1475,14 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	res = d_add_unique(dentry, igrab(state->inode));
 	if (res != NULL)
 		path.dentry = res;
-	nfs4_intent_set_file(nd, &path, state);
+	nfs4_intent_set_file(nd, &path, state, acred);
 	return res;
 }
 
 int
-nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
+nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags,
+		     struct nameidata *nd, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1454,7 +1493,7 @@ nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, st
 	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	state = nfs4_do_open(dir, &path, openflags, NULL, cred);
+	state = nfs4_do_open(dir, &path, openflags, NULL, cred, acred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		switch (PTR_ERR(state)) {
@@ -1470,17 +1509,18 @@ nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, st
 		}
 	}
 	if (state->inode == dentry->d_inode) {
-		nfs4_intent_set_file(nd, &path, state);
+		nfs4_intent_set_file(nd, &path, state, acred);
 		return 1;
 	}
-	nfs4_close_state(&path, state, openflags);
+	nfs4_close_state(&path, state, openflags, acred);
 out_drop:
 	d_drop(dentry);
 	return 0;
 }
 
 
-static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
+static int _nfs4_server_capabilities(struct nfs_server *server,
+				     struct nfs_fh *fhandle, struct cred *acred)
 {
 	struct nfs4_server_caps_res res = {};
 	struct rpc_message msg = {
@@ -1490,7 +1530,7 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 	};
 	int status;
 
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	if (status == 0) {
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL)
@@ -1504,20 +1544,22 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 	return status;
 }
 
-int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
+int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle,
+			     struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_server_capabilities(server, fhandle),
+				_nfs4_server_capabilities(server, fhandle,
+							  acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_fsinfo *info)
+		struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct nfs4_lookup_root_arg args = {
 		.bitmask = nfs4_fattr_bitmap,
@@ -1533,17 +1575,17 @@ static int _nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
 		.rpc_resp = &res,
 	};
 	nfs_fattr_init(info->fattr);
-	return rpc_call_sync(server->client, &msg, 0);
+	return rpc_call_sync(server->client, &msg, 0, acred);
 }
 
 static int nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_fsinfo *info)
+		struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_lookup_root(server, fhandle, info),
+				_nfs4_lookup_root(server, fhandle, info, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1553,15 +1595,15 @@ static int nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
  * get the file handle for the "/" directory on the server
  */
 static int nfs4_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
-			      struct nfs_fsinfo *info)
+			      struct nfs_fsinfo *info, struct cred *acred)
 {
 	int status;
 
-	status = nfs4_lookup_root(server, fhandle, info);
+	status = nfs4_lookup_root(server, fhandle, info, acred);
 	if (status == 0)
-		status = nfs4_server_capabilities(server, fhandle);
+		status = nfs4_server_capabilities(server, fhandle, acred);
 	if (status == 0)
-		status = nfs4_do_fsinfo(server, fhandle, info);
+		status = nfs4_do_fsinfo(server, fhandle, info, acred);
 	return nfs4_map_errors(status);
 }
 
@@ -1570,7 +1612,9 @@ static int nfs4_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
  * Note that we'll actually follow the referral later when
  * we detect fsid mismatch in inode revalidation
  */
-static int nfs4_get_referral(struct inode *dir, const struct qstr *name, struct nfs_fattr *fattr, struct nfs_fh *fhandle)
+static int nfs4_get_referral(struct inode *dir, const struct qstr *name,
+			     struct nfs_fattr *fattr, struct nfs_fh *fhandle,
+			     struct cred *acred)
 {
 	int status = -ENOMEM;
 	struct page *page = NULL;
@@ -1583,7 +1627,7 @@ static int nfs4_get_referral(struct inode *dir, const struct qstr *name, struct
 	if (locations == NULL)
 		goto out;
 
-	status = nfs4_proc_fs_locations(dir, name, locations, page);
+	status = nfs4_proc_fs_locations(dir, name, locations, page, acred);
 	if (status != 0)
 		goto out;
 	/* Make sure server returned a different fsid for the referral */
@@ -1606,7 +1650,8 @@ out:
 	return status;
 }
 
-static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
+			      struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct nfs4_getattr_arg args = {
 		.fh = fhandle,
@@ -1623,16 +1668,18 @@ static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
 	};
 	
 	nfs_fattr_init(fattr);
-	return rpc_call_sync(server->client, &msg, 0);
+	return rpc_call_sync(server->client, &msg, 0, acred);
 }
 
-static int nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+static int nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
+			     struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_proc_getattr(server, fhandle, fattr),
+				_nfs4_proc_getattr(server, fhandle, fattr,
+						   acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1657,9 +1704,8 @@ static int nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
  */
 static int
 nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
-		  struct iattr *sattr)
+		  struct iattr *sattr, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct rpc_cred *cred;
 	struct inode *inode = dentry->d_inode;
 	struct nfs_open_context *ctx;
@@ -1677,7 +1723,7 @@ nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 	if (ctx != NULL)
 		state = ctx->state;
 
-	status = nfs4_do_setattr(inode, fattr, sattr, state);
+	status = nfs4_do_setattr(inode, fattr, sattr, state, acred);
 	if (status == 0)
 		nfs_setattr_update_inode(inode, sattr);
 	if (ctx != NULL)
@@ -1688,7 +1734,7 @@ nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 static int _nfs4_proc_lookupfh(struct nfs_server *server, const struct nfs_fh *dirfh,
 		const struct qstr *name, struct nfs_fh *fhandle,
-		struct nfs_fattr *fattr)
+		struct nfs_fattr *fattr, struct cred *acred)
 {
 	int		       status;
 	struct nfs4_lookup_arg args = {
@@ -1710,19 +1756,20 @@ static int _nfs4_proc_lookupfh(struct nfs_server *server, const struct nfs_fh *d
 	nfs_fattr_init(fattr);
 
 	dprintk("NFS call  lookupfh %s\n", name->name);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply lookupfh: %d\n", status);
 	return status;
 }
 
 static int nfs4_proc_lookupfh(struct nfs_server *server, struct nfs_fh *dirfh,
 			      struct qstr *name, struct nfs_fh *fhandle,
-			      struct nfs_fattr *fattr)
+			      struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
-		err = _nfs4_proc_lookupfh(server, dirfh, name, fhandle, fattr);
+		err = _nfs4_proc_lookupfh(server, dirfh, name, fhandle, fattr,
+					  acred);
 		/* FIXME: !!!! */
 		if (err == -NFS4ERR_MOVED) {
 			err = -EREMOTE;
@@ -1734,31 +1781,37 @@ static int nfs4_proc_lookupfh(struct nfs_server *server, struct nfs_fh *dirfh,
 }
 
 static int _nfs4_proc_lookup(struct inode *dir, const struct qstr *name,
-		struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+		struct nfs_fh *fhandle, struct nfs_fattr *fattr,
+		struct cred *acred)
 {
 	int status;
 	
 	dprintk("NFS call  lookup %s\n", name->name);
-	status = _nfs4_proc_lookupfh(NFS_SERVER(dir), NFS_FH(dir), name, fhandle, fattr);
+	status = _nfs4_proc_lookupfh(NFS_SERVER(dir), NFS_FH(dir), name,
+				     fhandle, fattr, acred);
 	if (status == -NFS4ERR_MOVED)
-		status = nfs4_get_referral(dir, name, fattr, fhandle);
+		status = nfs4_get_referral(dir, name, fattr, fhandle, acred);
 	dprintk("NFS reply lookup: %d\n", status);
 	return status;
 }
 
-static int nfs4_proc_lookup(struct inode *dir, struct qstr *name, struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+static int nfs4_proc_lookup(struct inode *dir, struct qstr *name,
+			    struct nfs_fh *fhandle, struct nfs_fattr *fattr,
+			    struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_lookup(dir, name, fhandle, fattr),
+				_nfs4_proc_lookup(dir, name, fhandle, fattr,
+						  acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
-static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry)
+static int _nfs4_proc_access(struct inode *inode,
+			     struct nfs_access_entry *entry, struct cred *acred)
 {
 	struct nfs4_accessargs args = {
 		.fh = NFS_FH(inode),
@@ -1789,7 +1842,7 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 		if (mode & MAY_EXEC)
 			args.access |= NFS4_ACCESS_EXECUTE;
 	}
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (!status) {
 		entry->mask = 0;
 		if (res.access & NFS4_ACCESS_READ)
@@ -1802,13 +1855,14 @@ static int _nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry
 	return status;
 }
 
-static int nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry)
+static int nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry,
+			    struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(inode),
-				_nfs4_proc_access(inode, entry),
+				_nfs4_proc_access(inode, entry, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1839,7 +1893,7 @@ static int nfs4_proc_access(struct inode *inode, struct nfs_access_entry *entry)
  * minor, but I decided to leave them for a subsequent patch.
  */
 static int _nfs4_proc_readlink(struct inode *inode, struct page *page,
-		unsigned int pgbase, unsigned int pglen)
+		unsigned int pgbase, unsigned int pglen, struct cred *acred)
 {
 	struct nfs4_readlink args = {
 		.fh       = NFS_FH(inode),
@@ -1853,17 +1907,17 @@ static int _nfs4_proc_readlink(struct inode *inode, struct page *page,
 		.rpc_resp = NULL,
 	};
 
-	return rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	return rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 }
 
 static int nfs4_proc_readlink(struct inode *inode, struct page *page,
-		unsigned int pgbase, unsigned int pglen)
+		unsigned int pgbase, unsigned int pglen, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(inode),
-				_nfs4_proc_readlink(inode, page, pgbase, pglen),
+				_nfs4_proc_readlink(inode, page, pgbase, pglen, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1886,9 +1940,8 @@ static int nfs4_proc_readlink(struct inode *inode, struct page *page,
 
 static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-                 int flags, struct nameidata *nd)
+                 int flags, struct nameidata *nd, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1902,7 +1955,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		status = PTR_ERR(cred);
 		goto out;
 	}
-	state = nfs4_do_open(dir, &path, flags, sattr, cred);
+	state = nfs4_do_open(dir, &path, flags, sattr, cred, acred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		status = PTR_ERR(state);
@@ -1911,20 +1964,22 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	d_instantiate(dentry, igrab(state->inode));
 	if (flags & O_EXCL) {
 		struct nfs_fattr fattr;
-		status = nfs4_do_setattr(state->inode, &fattr, sattr, state);
+		status = nfs4_do_setattr(state->inode, &fattr, sattr, state,
+					 acred);
 		if (status == 0)
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
-		status = nfs4_intent_set_file(nd, &path, state);
+		status = nfs4_intent_set_file(nd, &path, state, acred);
 	else
-		nfs4_close_state(&path, state, flags);
+		nfs4_close_state(&path, state, flags, acred);
 out:
 	return status;
 }
 
-static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
+static int _nfs4_proc_remove(struct inode *dir, struct qstr *name,
+			     struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_removeargs args = {
@@ -1944,7 +1999,7 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
 	int			status;
 
 	nfs_fattr_init(&res.dir_attr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	if (status == 0) {
 		update_changeattr(dir, &res.cinfo);
 		nfs_post_op_update_inode(dir, &res.dir_attr);
@@ -1952,13 +2007,14 @@ static int _nfs4_proc_remove(struct inode *dir, struct qstr *name)
 	return status;
 }
 
-static int nfs4_proc_remove(struct inode *dir, struct qstr *name)
+static int nfs4_proc_remove(struct inode *dir, struct qstr *name,
+			    struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_remove(dir, name),
+				_nfs4_proc_remove(dir, name, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -1987,7 +2043,8 @@ static int nfs4_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 }
 
 static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
-		struct inode *new_dir, struct qstr *new_name)
+		struct inode *new_dir, struct qstr *new_name,
+		struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(old_dir);
 	struct nfs4_rename_arg arg = {
@@ -2012,7 +2069,7 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 	
 	nfs_fattr_init(res.old_fattr);
 	nfs_fattr_init(res.new_fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 
 	if (!status) {
 		update_changeattr(old_dir, &res.old_cinfo);
@@ -2024,20 +2081,22 @@ static int _nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
 }
 
 static int nfs4_proc_rename(struct inode *old_dir, struct qstr *old_name,
-		struct inode *new_dir, struct qstr *new_name)
+		struct inode *new_dir, struct qstr *new_name,
+		struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(old_dir),
 				_nfs4_proc_rename(old_dir, old_name,
-					new_dir, new_name),
+					new_dir, new_name, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
-static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
+static int _nfs4_proc_link(struct inode *inode, struct inode *dir,
+			   struct qstr *name, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_link_arg arg = {
@@ -2061,7 +2120,7 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 
 	nfs_fattr_init(res.fattr);
 	nfs_fattr_init(res.dir_attr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	if (!status) {
 		update_changeattr(dir, &res.cinfo);
 		nfs_post_op_update_inode(dir, res.dir_attr);
@@ -2071,20 +2130,22 @@ static int _nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *
 	return status;
 }
 
-static int nfs4_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
+static int nfs4_proc_link(struct inode *inode, struct inode *dir,
+			  struct qstr *name, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(inode),
-				_nfs4_proc_link(inode, dir, name),
+				_nfs4_proc_link(inode, dir, name, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
-		struct page *page, unsigned int len, struct iattr *sattr)
+		struct page *page, unsigned int len, struct iattr *sattr,
+		struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_fh fhandle;
@@ -2118,31 +2179,32 @@ static int _nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	nfs_fattr_init(&fattr);
 	nfs_fattr_init(&dir_fattr);
 	
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (!status) {
 		update_changeattr(dir, &res.dir_cinfo);
 		nfs_post_op_update_inode(dir, res.dir_fattr);
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	}
 	return status;
 }
 
 static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
-		struct page *page, unsigned int len, struct iattr *sattr)
+		struct page *page, unsigned int len, struct iattr *sattr,
+		struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
 				_nfs4_proc_symlink(dir, dentry, page,
-							len, sattr),
+							len, sattr, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr)
+		struct iattr *sattr, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_fh fhandle;
@@ -2171,30 +2233,31 @@ static int _nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	nfs_fattr_init(&fattr);
 	nfs_fattr_init(&dir_fattr);
 	
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (!status) {
 		update_changeattr(dir, &res.dir_cinfo);
 		nfs_post_op_update_inode(dir, res.dir_fattr);
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	}
 	return status;
 }
 
 static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr)
+		struct iattr *sattr, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_mkdir(dir, dentry, sattr),
+				_nfs4_proc_mkdir(dir, dentry, sattr, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-                  u64 cookie, struct page *page, unsigned int count, int plus)
+                  u64 cookie, struct page *page, unsigned int count, int plus,
+		  struct cred *acred)
 {
 	struct inode		*dir = dentry->d_inode;
 	struct nfs4_readdir_arg args = {
@@ -2219,7 +2282,7 @@ static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 			(unsigned long long)cookie);
 	nfs4_setup_readdir(cookie, NFS_COOKIEVERF(dir), dentry, &args);
 	res.pgbase = args.pgbase;
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (status == 0)
 		memcpy(NFS_COOKIEVERF(dir), res.verifier.data, NFS4_VERIFIER_SIZE);
 	dprintk("%s: returns %d\n", __FUNCTION__, status);
@@ -2227,21 +2290,22 @@ static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 }
 
 static int nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-                  u64 cookie, struct page *page, unsigned int count, int plus)
+                  u64 cookie, struct page *page, unsigned int count, int plus,
+		  struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dentry->d_inode),
 				_nfs4_proc_readdir(dentry, cred, cookie,
-					page, count, plus),
+					page, count, plus, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr, dev_t rdev)
+		struct iattr *sattr, dev_t rdev, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 	struct nfs_fh fh;
@@ -2287,30 +2351,31 @@ static int _nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 	else
 		arg.ftype = NF4SOCK;
 	
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (status == 0) {
 		update_changeattr(dir, &res.dir_cinfo);
 		nfs_post_op_update_inode(dir, res.dir_fattr);
-		status = nfs_instantiate(dentry, &fh, &fattr);
+		status = nfs_instantiate(dentry, &fh, &fattr, acred);
 	}
 	return status;
 }
 
 static int nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
-		struct iattr *sattr, dev_t rdev)
+		struct iattr *sattr, dev_t rdev, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dir),
-				_nfs4_proc_mknod(dir, dentry, sattr, rdev),
+				_nfs4_proc_mknod(dir, dentry, sattr, rdev,
+						 acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
-		 struct nfs_fsstat *fsstat)
+		 struct nfs_fsstat *fsstat, struct cred *acred)
 {
 	struct nfs4_statfs_arg args = {
 		.fh = fhandle,
@@ -2323,23 +2388,25 @@ static int _nfs4_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
 	};
 
 	nfs_fattr_init(fsstat->fattr);
-	return rpc_call_sync(server->client, &msg, 0);
+	return rpc_call_sync(server->client, &msg, 0, acred);
 }
 
-static int nfs4_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fsstat *fsstat)
+static int nfs4_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
+			    struct nfs_fsstat *fsstat, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_proc_statfs(server, fhandle, fsstat),
+				_nfs4_proc_statfs(server, fhandle, fsstat,
+						  acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
 static int _nfs4_do_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_fsinfo *fsinfo)
+		struct nfs_fsinfo *fsinfo, struct cred *acred)
 {
 	struct nfs4_fsinfo_arg args = {
 		.fh = fhandle,
@@ -2351,30 +2418,32 @@ static int _nfs4_do_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
 		.rpc_resp = fsinfo,
 	};
 
-	return rpc_call_sync(server->client, &msg, 0);
+	return rpc_call_sync(server->client, &msg, 0, acred);
 }
 
-static int nfs4_do_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fsinfo *fsinfo)
+static int nfs4_do_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
+			  struct nfs_fsinfo *fsinfo, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_do_fsinfo(server, fhandle, fsinfo),
+				_nfs4_do_fsinfo(server, fhandle, fsinfo, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
 }
 
-static int nfs4_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fsinfo *fsinfo)
+static int nfs4_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
+			    struct nfs_fsinfo *fsinfo, struct cred *acred)
 {
 	nfs_fattr_init(fsinfo->fattr);
-	return nfs4_do_fsinfo(server, fhandle, fsinfo);
+	return nfs4_do_fsinfo(server, fhandle, fsinfo, acred);
 }
 
 static int _nfs4_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_pathconf *pathconf)
+		struct nfs_pathconf *pathconf, struct cred *acred)
 {
 	struct nfs4_pathconf_arg args = {
 		.fh = fhandle,
@@ -2393,18 +2462,19 @@ static int _nfs4_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle
 	}
 
 	nfs_fattr_init(pathconf->fattr);
-	return rpc_call_sync(server->client, &msg, 0);
+	return rpc_call_sync(server->client, &msg, 0, acred);
 }
 
 static int nfs4_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_pathconf *pathconf)
+		struct nfs_pathconf *pathconf, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 
 	do {
 		err = nfs4_handle_exception(server,
-				_nfs4_proc_pathconf(server, fhandle, pathconf),
+				_nfs4_proc_pathconf(server, fhandle, pathconf,
+						    acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -2423,7 +2493,7 @@ static int nfs4_read_done(struct rpc_task *task, struct nfs_read_data *data)
 	return 0;
 }
 
-static void nfs4_proc_read_setup(struct nfs_read_data *data)
+static void nfs4_proc_read_setup(struct nfs_read_data *data, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ],
@@ -2434,7 +2504,7 @@ static void nfs4_proc_read_setup(struct nfs_read_data *data)
 
 	data->timestamp   = jiffies;
 
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int nfs4_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -2452,7 +2522,8 @@ static int nfs4_write_done(struct rpc_task *task, struct nfs_write_data *data)
 	return 0;
 }
 
-static void nfs4_proc_write_setup(struct nfs_write_data *data, int how)
+static void nfs4_proc_write_setup(struct nfs_write_data *data, int how,
+				  struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_WRITE],
@@ -2478,7 +2549,7 @@ static void nfs4_proc_write_setup(struct nfs_write_data *data, int how)
 	data->timestamp   = jiffies;
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int nfs4_commit_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -2494,7 +2565,8 @@ static int nfs4_commit_done(struct rpc_task *task, struct nfs_write_data *data)
 	return 0;
 }
 
-static void nfs4_proc_commit_setup(struct nfs_write_data *data, int how)
+static void nfs4_proc_commit_setup(struct nfs_write_data *data, int how,
+				   struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_COMMIT],
@@ -2507,7 +2579,7 @@ static void nfs4_proc_commit_setup(struct nfs_write_data *data, int how)
 	data->args.bitmask = server->attr_bitmask;
 	data->res.server = server;
 
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 /*
@@ -2538,7 +2610,8 @@ static const struct rpc_call_ops nfs4_renew_ops = {
 	.rpc_call_done = nfs4_renew_done,
 };
 
-int nfs4_proc_async_renew(struct nfs_client *clp, struct rpc_cred *cred)
+int nfs4_proc_async_renew(struct nfs_client *clp, struct rpc_cred *cred,
+			  struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs4_procedures[NFSPROC4_CLNT_RENEW],
@@ -2547,10 +2620,11 @@ int nfs4_proc_async_renew(struct nfs_client *clp, struct rpc_cred *cred)
 	};
 
 	return rpc_call_async(clp->cl_rpcclient, &msg, RPC_TASK_SOFT,
-			&nfs4_renew_ops, (void *)jiffies);
+			&nfs4_renew_ops, (void *)jiffies, acred);
 }
 
-int nfs4_proc_renew(struct nfs_client *clp, struct rpc_cred *cred)
+int nfs4_proc_renew(struct nfs_client *clp, struct rpc_cred *cred,
+		    struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs4_procedures[NFSPROC4_CLNT_RENEW],
@@ -2560,7 +2634,7 @@ int nfs4_proc_renew(struct nfs_client *clp, struct rpc_cred *cred)
 	unsigned long now = jiffies;
 	int status;
 
-	status = rpc_call_sync(clp->cl_rpcclient, &msg, 0);
+	status = rpc_call_sync(clp->cl_rpcclient, &msg, 0, acred);
 	if (status < 0)
 		return status;
 	spin_lock(&clp->cl_lock);
@@ -2663,7 +2737,8 @@ out:
 	nfs4_set_cached_acl(inode, acl);
 }
 
-static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t buflen)
+static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf,
+				       size_t buflen, struct cred *acred)
 {
 	struct page *pages[NFS4ACL_MAXPAGES];
 	struct nfs_getaclargs args = {
@@ -2695,7 +2770,7 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 		resp_buf = buf;
 		buf_to_pages(buf, buflen, args.acl_pages, &args.acl_pgbase);
 	}
-	ret = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	ret = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (ret)
 		goto out_free;
 	if (resp_len > args.acl_len)
@@ -2716,12 +2791,13 @@ out_free:
 	return ret;
 }
 
-static ssize_t nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t buflen)
+static ssize_t nfs4_get_acl_uncached(struct inode *inode, void *buf,
+				     size_t buflen, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	ssize_t ret;
 	do {
-		ret = __nfs4_get_acl_uncached(inode, buf, buflen);
+		ret = __nfs4_get_acl_uncached(inode, buf, buflen, acred);
 		if (ret >= 0)
 			break;
 		ret = nfs4_handle_exception(NFS_SERVER(inode), ret, &exception);
@@ -2729,23 +2805,25 @@ static ssize_t nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bufl
 	return ret;
 }
 
-static ssize_t nfs4_proc_get_acl(struct inode *inode, void *buf, size_t buflen)
+static ssize_t nfs4_proc_get_acl(struct inode *inode, void *buf, size_t buflen,
+				 struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	int ret;
 
 	if (!nfs4_server_supports_acls(server))
 		return -EOPNOTSUPP;
-	ret = nfs_revalidate_inode(server, inode);
+	ret = nfs_revalidate_inode(server, inode, acred);
 	if (ret < 0)
 		return ret;
 	ret = nfs4_read_cached_acl(inode, buf, buflen);
 	if (ret != -ENOENT)
 		return ret;
-	return nfs4_get_acl_uncached(inode, buf, buflen);
+	return nfs4_get_acl_uncached(inode, buf, buflen, acred);
 }
 
-static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen)
+static int __nfs4_proc_set_acl(struct inode *inode, const void *buf,
+			       size_t buflen, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct page *pages[NFS4ACL_MAXPAGES];
@@ -2765,18 +2843,19 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 		return -EOPNOTSUPP;
 	nfs_inode_return_delegation(inode);
 	buf_to_pages(buf, buflen, arg.acl_pages, &arg.acl_pgbase);
-	ret = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	ret = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	nfs_zap_caches(inode);
 	return ret;
 }
 
-static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen)
+static int nfs4_proc_set_acl(struct inode *inode, const void *buf,
+			     size_t buflen, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(inode),
-				__nfs4_proc_set_acl(inode, buf, buflen),
+				__nfs4_proc_set_acl(inode, buf, buflen, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -2897,7 +2976,9 @@ static int nfs4_handle_exception(const struct nfs_server *server, int errorcode,
 	return nfs4_map_errors(ret);
 }
 
-int nfs4_proc_setclientid(struct nfs_client *clp, u32 program, unsigned short port, struct rpc_cred *cred)
+int nfs4_proc_setclientid(struct nfs_client *clp, u32 program,
+			  unsigned short port, struct rpc_cred *cred,
+			  struct cred *acred)
 {
 	nfs4_verifier sc_verifier;
 	struct nfs4_setclientid setclientid = {
@@ -2930,7 +3011,7 @@ int nfs4_proc_setclientid(struct nfs_client *clp, u32 program, unsigned short po
 				sizeof(setclientid.sc_uaddr), "%s.%d.%d",
 				clp->cl_ipaddr, port >> 8, port & 255);
 
-		status = rpc_call_sync(clp->cl_rpcclient, &msg, 0);
+		status = rpc_call_sync(clp->cl_rpcclient, &msg, 0, acred);
 		if (status != -NFS4ERR_CLID_INUSE)
 			break;
 		if (signalled())
@@ -2944,7 +3025,9 @@ int nfs4_proc_setclientid(struct nfs_client *clp, u32 program, unsigned short po
 	return status;
 }
 
-static int _nfs4_proc_setclientid_confirm(struct nfs_client *clp, struct rpc_cred *cred)
+static int _nfs4_proc_setclientid_confirm(struct nfs_client *clp,
+					  struct rpc_cred *cred,
+					  struct cred *acred)
 {
 	struct nfs_fsinfo fsinfo;
 	struct rpc_message msg = {
@@ -2957,7 +3040,7 @@ static int _nfs4_proc_setclientid_confirm(struct nfs_client *clp, struct rpc_cre
 	int status;
 
 	now = jiffies;
-	status = rpc_call_sync(clp->cl_rpcclient, &msg, 0);
+	status = rpc_call_sync(clp->cl_rpcclient, &msg, 0, acred);
 	if (status == 0) {
 		spin_lock(&clp->cl_lock);
 		clp->cl_lease_time = fsinfo.lease_time * HZ;
@@ -2968,12 +3051,13 @@ static int _nfs4_proc_setclientid_confirm(struct nfs_client *clp, struct rpc_cre
 	return status;
 }
 
-int nfs4_proc_setclientid_confirm(struct nfs_client *clp, struct rpc_cred *cred)
+int nfs4_proc_setclientid_confirm(struct nfs_client *clp, struct rpc_cred *cred,
+				  struct cred *acred)
 {
 	long timeout;
 	int err;
 	do {
-		err = _nfs4_proc_setclientid_confirm(clp, cred);
+		err = _nfs4_proc_setclientid_confirm(clp, cred, acred);
 		switch (err) {
 			case 0:
 				return err;
@@ -3018,7 +3102,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		renew_lease(data->res.server, data->timestamp);
 }
 
-static void nfs4_delegreturn_release(void *calldata)
+static void nfs4_delegreturn_release(struct cred *acred, void *calldata)
 {
 	struct nfs4_delegreturndata *data = calldata;
 
@@ -3032,7 +3116,9 @@ static const struct rpc_call_ops nfs4_delegreturn_ops = {
 	.rpc_release = nfs4_delegreturn_release,
 };
 
-static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, const nfs4_stateid *stateid)
+static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred,
+				  const nfs4_stateid *stateid,
+				  struct cred *acred)
 {
 	struct nfs4_delegreturndata *data;
 	struct nfs_server *server = NFS_SERVER(inode);
@@ -3053,7 +3139,8 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
 
-	task = rpc_run_task(NFS_CLIENT(inode), RPC_TASK_ASYNC, &nfs4_delegreturn_ops, data);
+	task = rpc_run_task(NFS_CLIENT(inode), RPC_TASK_ASYNC,
+			    &nfs4_delegreturn_ops, data, acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	status = nfs4_wait_for_completion_rpc_task(task);
@@ -3066,13 +3153,14 @@ static int _nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, co
 	return status;
 }
 
-int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred, const nfs4_stateid *stateid)
+int nfs4_proc_delegreturn(struct inode *inode, struct rpc_cred *cred,
+			  const nfs4_stateid *stateid, struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_exception exception = { };
 	int err;
 	do {
-		err = _nfs4_proc_delegreturn(inode, cred, stateid);
+		err = _nfs4_proc_delegreturn(inode, cred, stateid, acred);
 		switch (err) {
 			case -NFS4ERR_STALE_STATEID:
 			case -NFS4ERR_EXPIRED:
@@ -3100,7 +3188,8 @@ nfs4_set_lock_task_retry(unsigned long timeout)
 	return timeout;
 }
 
-static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock *request)
+static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd,
+			    struct file_lock *request, struct cred *acred)
 {
 	struct inode *inode = state->inode;
 	struct nfs_server *server = NFS_SERVER(inode);
@@ -3128,7 +3217,7 @@ static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock
 		goto out;
 	lsp = request->fl_u.nfs4_fl.owner;
 	arg.lock_owner.id = lsp->ls_id.id;
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	switch (status) {
 		case 0:
 			request->fl_type = F_UNLCK;
@@ -3142,14 +3231,15 @@ out:
 	return status;
 }
 
-static int nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock *request)
+static int nfs4_proc_getlk(struct nfs4_state *state, int cmd,
+			   struct file_lock *request, struct cred *acred)
 {
 	struct nfs4_exception exception = { };
 	int err;
 
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(state->inode),
-				_nfs4_proc_getlk(state, cmd, request),
+				_nfs4_proc_getlk(state, cmd, request, acred),
 				&exception);
 	} while (exception.retry);
 	return err;
@@ -3205,7 +3295,7 @@ static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
 	return p;
 }
 
-static void nfs4_locku_release_calldata(void *data)
+static void nfs4_locku_release_calldata(struct cred *acred, void *data)
 {
 	struct nfs4_unlockdata *calldata = data;
 	nfs_free_seqid(calldata->arg.seqid);
@@ -3282,7 +3372,8 @@ static struct rpc_task *nfs4_do_unlck(struct file_lock *fl,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	return rpc_run_task(NFS_CLIENT(lsp->ls_state->inode), RPC_TASK_ASYNC, &nfs4_locku_ops, data);
+	return rpc_run_task(NFS_CLIENT(lsp->ls_state->inode), RPC_TASK_ASYNC,
+			    &nfs4_locku_ops, data, ctx->acred);
 }
 
 static int nfs4_proc_unlck(struct nfs4_state *state, int cmd, struct file_lock *request)
@@ -3416,7 +3507,7 @@ out:
 	dprintk("%s: done, ret = %d!\n", __FUNCTION__, data->rpc_status);
 }
 
-static void nfs4_lock_release(void *calldata)
+static void nfs4_lock_release(struct cred *acred, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 
@@ -3460,7 +3551,7 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
 	if (reclaim != 0)
 		data->arg.reclaim = 1;
 	task = rpc_run_task(NFS_CLIENT(state->inode), RPC_TASK_ASYNC,
-			&nfs4_lock_ops, data);
+			&nfs4_lock_ops, data, fl->fl_file->f_cred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	ret = nfs4_wait_for_completion_rpc_task(task);
@@ -3584,7 +3675,7 @@ nfs4_proc_lock(struct file *filp, int cmd, struct file_lock *request)
 		return -EINVAL;
 
 	if (IS_GETLK(cmd))
-		return nfs4_proc_getlk(state, F_GETLK, request);
+		return nfs4_proc_getlk(state, F_GETLK, request, filp->f_cred);
 
 	if (!(IS_SETLK(cmd) || IS_SETLKW(cmd)))
 		return -EINVAL;
@@ -3628,6 +3719,7 @@ out:
 int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
 		size_t buflen, int flags)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 
 	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
@@ -3637,7 +3729,7 @@ int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
 	    (!S_ISDIR(inode->i_mode) || inode->i_mode & S_ISVTX))
 		return -EPERM;
 
-	return nfs4_proc_set_acl(inode, buf, buflen);
+	return nfs4_proc_set_acl(inode, buf, buflen, acred);
 }
 
 /* The getxattr man page suggests returning -ENODATA for unknown attributes,
@@ -3647,12 +3739,13 @@ int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
 ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
 		size_t buflen)
 {
+	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 
 	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
 		return -EOPNOTSUPP;
 
-	return nfs4_proc_get_acl(inode, buf, buflen);
+	return nfs4_proc_get_acl(inode, buf, buflen, acred);
 }
 
 ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
@@ -3669,7 +3762,8 @@ ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
 }
 
 int nfs4_proc_fs_locations(struct inode *dir, const struct qstr *name,
-		struct nfs4_fs_locations *fs_locations, struct page *page)
+		struct nfs4_fs_locations *fs_locations, struct page *page,
+		struct cred *acred)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 	u32 bitmask[2] = {
@@ -3693,7 +3787,7 @@ int nfs4_proc_fs_locations(struct inode *dir, const struct qstr *name,
 	nfs_fattr_init(&fs_locations->fattr);
 	fs_locations->server = server;
 	fs_locations->nlocations = 0;
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("%s: returned status = %d\n", __FUNCTION__, status);
 	return status;
 }
diff --git a/fs/nfs/nfs4renewd.c b/fs/nfs/nfs4renewd.c
index 3ea352d..9d648c8 100644
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -86,7 +86,7 @@ nfs4_renew_state(struct work_struct *work)
 		}
 		spin_unlock(&clp->cl_lock);
 		/* Queue an asynchronous RENEW. */
-		nfs4_proc_async_renew(clp, cred);
+		nfs4_proc_async_renew(clp, cred, &init_cred);
 		put_rpccred(cred);
 		timeout = (2 * lease) / 3;
 		spin_lock(&clp->cl_lock);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 3e4adf8..8ffdc68 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -60,12 +60,13 @@ const nfs4_stateid zero_stateid;
 
 static LIST_HEAD(nfs4_clientid_list);
 
-static int nfs4_init_client(struct nfs_client *clp, struct rpc_cred *cred)
+static int nfs4_init_client(struct nfs_client *clp, struct rpc_cred *cred,
+			    struct cred *acred)
 {
 	int status = nfs4_proc_setclientid(clp, NFS4_CALLBACK,
-			nfs_callback_tcpport, cred);
+			nfs_callback_tcpport, cred, acred);
 	if (status == 0)
-		status = nfs4_proc_setclientid_confirm(clp, cred);
+		status = nfs4_proc_setclientid_confirm(clp, cred, acred);
 	if (status == 0)
 		nfs4_schedule_state_renewal(clp);
 	return status;
@@ -425,7 +426,8 @@ void nfs4_put_open_state(struct nfs4_state *state)
 /*
  * Close the current file.
  */
-void nfs4_close_state(struct path *path, struct nfs4_state *state, mode_t mode)
+void nfs4_close_state(struct path *path, struct nfs4_state *state, mode_t mode,
+		      struct cred *acred)
 {
 	struct nfs4_state_owner *owner = state->owner;
 	int call_close = 0;
@@ -466,7 +468,7 @@ void nfs4_close_state(struct path *path, struct nfs4_state *state, mode_t mode)
 		nfs4_put_open_state(state);
 		nfs4_put_state_owner(owner);
 	} else
-		nfs4_do_close(path, state);
+		nfs4_do_close(path, state, acred);
 }
 
 /*
@@ -905,7 +907,7 @@ restart_loop:
 	cred = nfs4_get_renew_cred(clp);
 	if (cred != NULL) {
 		/* Yes there are: try to renew the old lease */
-		status = nfs4_proc_renew(clp, cred);
+		status = nfs4_proc_renew(clp, cred, &init_cred);
 		switch (status) {
 			case 0:
 			case -NFS4ERR_CB_PATH_DOWN:
@@ -924,7 +926,7 @@ restart_loop:
 	nfs4_state_mark_reclaim(clp);
 	status = -ENOENT;
 	if (cred != NULL) {
-		status = nfs4_init_client(clp, cred);
+		status = nfs4_init_client(clp, cred, &init_cred);
 		put_rpccred(cred);
 	}
 	if (status)
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index d6baeb4..aeb7e38 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -52,7 +52,7 @@
  */
 static int
 nfs_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
-		  struct nfs_fsinfo *info)
+		  struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct nfs_fattr *fattr = info->fattr;
 	struct nfs2_fsstat fsinfo;
@@ -65,14 +65,16 @@ nfs_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("%s: call getattr\n", __FUNCTION__);
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0);
+	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0,
+			       acred);
 	dprintk("%s: reply getattr: %d\n", __FUNCTION__, status);
 	if (status)
 		return status;
 	dprintk("%s: call statfs\n", __FUNCTION__);
 	msg.rpc_proc = &nfs_procedures[NFSPROC_STATFS];
 	msg.rpc_resp = &fsinfo;
-	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0);
+	status = rpc_call_sync(server->nfs_client->cl_rpcclient, &msg, 0,
+			       acred);
 	dprintk("%s: reply statfs: %d\n", __FUNCTION__, status);
 	if (status)
 		return status;
@@ -93,7 +95,7 @@ nfs_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
  */
 static int
 nfs_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
-		struct nfs_fattr *fattr)
+		struct nfs_fattr *fattr, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs_procedures[NFSPROC_GETATTR],
@@ -104,14 +106,14 @@ nfs_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  getattr\n");
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply getattr: %d\n", status);
 	return status;
 }
 
 static int
 nfs_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
-		 struct iattr *sattr)
+		 struct iattr *sattr, struct cred *acred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct nfs_sattrargs	arg = { 
@@ -130,7 +132,7 @@ nfs_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 	dprintk("NFS call  setattr\n");
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (status == 0)
 		nfs_setattr_update_inode(inode, sattr);
 	dprintk("NFS reply setattr: %d\n", status);
@@ -139,7 +141,8 @@ nfs_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 static int
 nfs_proc_lookup(struct inode *dir, struct qstr *name,
-		struct nfs_fh *fhandle, struct nfs_fattr *fattr)
+		struct nfs_fh *fhandle, struct nfs_fattr *fattr,
+		struct cred *acred)
 {
 	struct nfs_diropargs	arg = {
 		.fh		= NFS_FH(dir),
@@ -159,13 +162,13 @@ nfs_proc_lookup(struct inode *dir, struct qstr *name,
 
 	dprintk("NFS call  lookup %s\n", name->name);
 	nfs_fattr_init(fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	dprintk("NFS reply lookup: %d\n", status);
 	return status;
 }
 
 static int nfs_proc_readlink(struct inode *inode, struct page *page,
-		unsigned int pgbase, unsigned int pglen)
+		unsigned int pgbase, unsigned int pglen, struct cred *acred)
 {
 	struct nfs_readlinkargs	args = {
 		.fh		= NFS_FH(inode),
@@ -180,14 +183,14 @@ static int nfs_proc_readlink(struct inode *inode, struct page *page,
 	int			status;
 
 	dprintk("NFS call  readlink\n");
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	dprintk("NFS reply readlink: %d\n", status);
 	return status;
 }
 
 static int
 nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		int flags, struct nameidata *nd)
+		int flags, struct nameidata *nd, struct cred *acred)
 {
 	struct nfs_fh		fhandle;
 	struct nfs_fattr	fattr;
@@ -210,9 +213,9 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 
 	nfs_fattr_init(&fattr);
 	dprintk("NFS call  create %s\n", dentry->d_name.name);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	if (status == 0)
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	dprintk("NFS reply create: %d\n", status);
 	return status;
 }
@@ -222,7 +225,7 @@ nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
  */
 static int
 nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-	       dev_t rdev)
+	       dev_t rdev, struct cred *acred)
 {
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
@@ -255,22 +258,22 @@ nfs_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	}
 
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(dir);
 
 	if (status == -EINVAL && S_ISFIFO(mode)) {
 		sattr->ia_mode = mode;
 		nfs_fattr_init(&fattr);
-		status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+		status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	}
 	if (status == 0)
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	dprintk("NFS reply mknod: %d\n", status);
 	return status;
 }
   
 static int
-nfs_proc_remove(struct inode *dir, struct qstr *name)
+nfs_proc_remove(struct inode *dir, struct qstr *name, struct cred *acred)
 {
 	struct nfs_removeargs arg = {
 		.fh = NFS_FH(dir),
@@ -284,7 +287,7 @@ nfs_proc_remove(struct inode *dir, struct qstr *name)
 	int			status;
 
 	dprintk("NFS call  remove %s\n", name->name);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(dir);
 
 	dprintk("NFS reply remove: %d\n", status);
@@ -305,7 +308,8 @@ static int nfs_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 
 static int
 nfs_proc_rename(struct inode *old_dir, struct qstr *old_name,
-		struct inode *new_dir, struct qstr *new_name)
+		struct inode *new_dir, struct qstr *new_name,
+		struct cred *acred)
 {
 	struct nfs_renameargs	arg = {
 		.fromfh		= NFS_FH(old_dir),
@@ -322,7 +326,7 @@ nfs_proc_rename(struct inode *old_dir, struct qstr *old_name,
 	int			status;
 
 	dprintk("NFS call  rename %s -> %s\n", old_name->name, new_name->name);
-	status = rpc_call_sync(NFS_CLIENT(old_dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(old_dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(old_dir);
 	nfs_mark_for_revalidate(new_dir);
 	dprintk("NFS reply rename: %d\n", status);
@@ -330,7 +334,8 @@ nfs_proc_rename(struct inode *old_dir, struct qstr *old_name,
 }
 
 static int
-nfs_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
+nfs_proc_link(struct inode *inode, struct inode *dir, struct qstr *name,
+	      struct cred *acred)
 {
 	struct nfs_linkargs	arg = {
 		.fromfh		= NFS_FH(inode),
@@ -345,7 +350,7 @@ nfs_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
 	int			status;
 
 	dprintk("NFS call  link %s\n", name->name);
-	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	nfs_mark_for_revalidate(inode);
 	nfs_mark_for_revalidate(dir);
 	dprintk("NFS reply link: %d\n", status);
@@ -354,7 +359,7 @@ nfs_proc_link(struct inode *inode, struct inode *dir, struct qstr *name)
 
 static int
 nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
-		 unsigned int len, struct iattr *sattr)
+		 unsigned int len, struct iattr *sattr, struct cred *acred)
 {
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
@@ -377,7 +382,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 
 	dprintk("NFS call  symlink %s\n", dentry->d_name.name);
 
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(dir);
 
 	/*
@@ -388,7 +393,7 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 	if (status == 0) {
 		nfs_fattr_init(&fattr);
 		fhandle.size = 0;
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	}
 
 	dprintk("NFS reply symlink: %d\n", status);
@@ -396,7 +401,8 @@ nfs_proc_symlink(struct inode *dir, struct dentry *dentry, struct page *page,
 }
 
 static int
-nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
+nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
+	       struct cred *acred)
 {
 	struct nfs_fh fhandle;
 	struct nfs_fattr fattr;
@@ -419,16 +425,16 @@ nfs_proc_mkdir(struct inode *dir, struct dentry *dentry, struct iattr *sattr)
 
 	dprintk("NFS call  mkdir %s\n", dentry->d_name.name);
 	nfs_fattr_init(&fattr);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(dir);
 	if (status == 0)
-		status = nfs_instantiate(dentry, &fhandle, &fattr);
+		status = nfs_instantiate(dentry, &fhandle, &fattr, acred);
 	dprintk("NFS reply mkdir: %d\n", status);
 	return status;
 }
 
 static int
-nfs_proc_rmdir(struct inode *dir, struct qstr *name)
+nfs_proc_rmdir(struct inode *dir, struct qstr *name, struct cred *acred)
 {
 	struct nfs_diropargs	arg = {
 		.fh		= NFS_FH(dir),
@@ -442,7 +448,7 @@ nfs_proc_rmdir(struct inode *dir, struct qstr *name)
 	int			status;
 
 	dprintk("NFS call  rmdir %s\n", name->name);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 	nfs_mark_for_revalidate(dir);
 	dprintk("NFS reply rmdir: %d\n", status);
 	return status;
@@ -457,7 +463,8 @@ nfs_proc_rmdir(struct inode *dir, struct qstr *name)
  */
 static int
 nfs_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-		 u64 cookie, struct page *page, unsigned int count, int plus)
+		 u64 cookie, struct page *page, unsigned int count, int plus,
+		 struct cred *acred)
 {
 	struct inode		*dir = dentry->d_inode;
 	struct nfs_readdirargs	arg = {
@@ -474,7 +481,7 @@ nfs_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 	int			status;
 
 	dprintk("NFS call  readdir %d\n", (unsigned int)cookie);
-	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0, acred);
 
 	dprintk("NFS reply readdir: %d\n", status);
 	return status;
@@ -482,7 +489,7 @@ nfs_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 
 static int
 nfs_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
-			struct nfs_fsstat *stat)
+			struct nfs_fsstat *stat, struct cred *acred)
 {
 	struct nfs2_fsstat fsinfo;
 	struct rpc_message msg = {
@@ -494,7 +501,7 @@ nfs_proc_statfs(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  statfs\n");
 	nfs_fattr_init(stat->fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply statfs: %d\n", status);
 	if (status)
 		goto out;
@@ -510,7 +517,7 @@ out:
 
 static int
 nfs_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
-			struct nfs_fsinfo *info)
+			struct nfs_fsinfo *info, struct cred *acred)
 {
 	struct nfs2_fsstat fsinfo;
 	struct rpc_message msg = {
@@ -522,7 +529,7 @@ nfs_proc_fsinfo(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	dprintk("NFS call  fsinfo\n");
 	nfs_fattr_init(info->fattr);
-	status = rpc_call_sync(server->client, &msg, 0);
+	status = rpc_call_sync(server->client, &msg, 0, acred);
 	dprintk("NFS reply fsinfo: %d\n", status);
 	if (status)
 		goto out;
@@ -541,7 +548,7 @@ out:
 
 static int
 nfs_proc_pathconf(struct nfs_server *server, struct nfs_fh *fhandle,
-		  struct nfs_pathconf *info)
+		  struct nfs_pathconf *info, struct cred *acred)
 {
 	info->max_link = 0;
 	info->max_namelen = NFS2_MAXNAMLEN;
@@ -561,7 +568,7 @@ static int nfs_read_done(struct rpc_task *task, struct nfs_read_data *data)
 	return 0;
 }
 
-static void nfs_proc_read_setup(struct nfs_read_data *data)
+static void nfs_proc_read_setup(struct nfs_read_data *data, struct cred *acred)
 {
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs_procedures[NFSPROC_READ],
@@ -570,7 +577,7 @@ static void nfs_proc_read_setup(struct nfs_read_data *data)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static int nfs_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -580,7 +587,8 @@ static int nfs_write_done(struct rpc_task *task, struct nfs_write_data *data)
 	return 0;
 }
 
-static void nfs_proc_write_setup(struct nfs_write_data *data, int how)
+static void nfs_proc_write_setup(struct nfs_write_data *data, int how,
+				 struct cred *acred)
 {
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs_procedures[NFSPROC_WRITE],
@@ -593,11 +601,11 @@ static void nfs_proc_write_setup(struct nfs_write_data *data, int how)
 	data->args.stable = NFS_FILE_SYNC;
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0, current->cred);
+	rpc_call_setup(&data->task, &msg, 0, acred);
 }
 
 static void
-nfs_proc_commit_setup(struct nfs_write_data *data, int how)
+nfs_proc_commit_setup(struct nfs_write_data *data, int how, struct cred *acred)
 {
 	BUG();
 }
@@ -605,7 +613,8 @@ nfs_proc_commit_setup(struct nfs_write_data *data, int how)
 static int
 nfs_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
-	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
+	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl,
+			    filp->f_cred);
 }
 
 
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 19e0563..8cde60c 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -71,7 +71,7 @@ static void nfs_readdata_free(struct nfs_read_data *rdata)
 	call_rcu_bh(&rdata->task.u.tk_rcu, nfs_readdata_rcu_free);
 }
 
-void nfs_readdata_release(void *data)
+void nfs_readdata_release(struct cred *acred, void *data)
 {
         nfs_readdata_free(data);
 }
@@ -181,8 +181,9 @@ static void nfs_read_rpcsetup(struct nfs_page *req, struct nfs_read_data *data,
 
 	/* Set up the initial task struct. */
 	flags = RPC_TASK_ASYNC | (IS_SWAPFILE(inode)? NFS_RPC_SWAPFLAGS : 0);
-	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, call_ops, data);
-	NFS_PROTO(inode)->read_setup(data);
+	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, call_ops, data,
+		      req->wb_context->acred);
+	NFS_PROTO(inode)->read_setup(data, req->wb_context->acred);
 
 	data->task.tk_cookie = (unsigned long)inode;
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b878528..0988df4 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -355,6 +355,7 @@ void __exit unregister_nfs_fs(void)
  */
 static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
+	struct cred *acred = current->cred;
 	struct nfs_server *server = NFS_SB(dentry->d_sb);
 	unsigned char blockbits;
 	unsigned long blockres;
@@ -367,7 +368,7 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	lock_kernel();
 
-	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
+	error = server->nfs_client->rpc_ops->statfs(server, fh, &res, acred);
 	if (error < 0)
 		goto out_err;
 	buf->f_type = NFS_SUPER_MAGIC;
@@ -1008,7 +1009,7 @@ out_unknown:
  * corresponding to the provided path.
  */
 static int nfs_try_mount(struct nfs_parsed_mount_data *args,
-			 struct nfs_fh *root_fh)
+			 struct nfs_fh *root_fh, struct cred *acred)
 {
 	struct sockaddr_in sin;
 	int status;
@@ -1048,7 +1049,8 @@ static int nfs_try_mount(struct nfs_parsed_mount_data *args,
 			   args->nfs_server.export_path,
 			   args->mount_server.version,
 			   args->mount_server.protocol,
-			   root_fh);
+			   root_fh,
+			   acred);
 	if (status < 0)
 		goto out_err;
 
@@ -1081,7 +1083,8 @@ out_err:
  */
 static int nfs_validate_mount_data(struct nfs_mount_data **options,
 				   struct nfs_fh *mntfh,
-				   const char *dev_name)
+				   const char *dev_name,
+				   struct cred *acred)
 {
 	struct nfs_mount_data *data = *options;
 
@@ -1164,7 +1167,7 @@ static int nfs_validate_mount_data(struct nfs_mount_data **options,
 			return -ENAMETOOLONG;
 		args.nfs_server.export_path = c;
 
-		status = nfs_try_mount(&args, mntfh);
+		status = nfs_try_mount(&args, mntfh, acred);
 		if (status)
 			return status;
 
@@ -1376,6 +1379,7 @@ static int nfs_compare_super(struct super_block *sb, void *data)
 static int nfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
+	struct cred *acred = current->cred;
 	struct nfs_server *server = NULL;
 	struct super_block *s;
 	struct nfs_fh mntfh;
@@ -1388,12 +1392,12 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	int error;
 
 	/* Validate the mount data */
-	error = nfs_validate_mount_data(&data, &mntfh, dev_name);
+	error = nfs_validate_mount_data(&data, &mntfh, dev_name, acred);
 	if (error < 0)
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(data, &mntfh);
+	server = nfs_create_server(data, &mntfh, acred);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1420,7 +1424,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 		nfs_fill_super(s, data);
 	}
 
-	mntroot = nfs_get_root(s, &mntfh);
+	mntroot = nfs_get_root(s, &mntfh, acred);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
@@ -1464,6 +1468,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 			   const char *dev_name, void *raw_data,
 			   struct vfsmount *mnt)
 {
+	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1477,7 +1482,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	dprintk("--> nfs_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, acred);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1504,7 +1509,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 		nfs_clone_super(s, data->sb);
 	}
 
-	mntroot = nfs_get_root(s, data->fh);
+	mntroot = nfs_get_root(s, data->fh, acred);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
@@ -1729,6 +1734,7 @@ out_no_client_address:
 static int nfs4_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
+	struct cred *acred = current->cred;
 	struct nfs4_mount_data *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1751,7 +1757,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 
 	/* Get a volume representation */
 	server = nfs4_create_server(data, hostname, &addr, mntpath, ip_addr,
-				    authflavour, &mntfh);
+				    authflavour, &mntfh, acred);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1778,7 +1784,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 		nfs4_fill_super(s);
 	}
 
-	mntroot = nfs4_get_root(s, &mntfh);
+	mntroot = nfs4_get_root(s, &mntfh, acred);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
@@ -1823,6 +1829,7 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 			    const char *dev_name, void *raw_data,
 			    struct vfsmount *mnt)
 {
+	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1836,7 +1843,8 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	dprintk("--> nfs4_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr,
+				  acred);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1863,7 +1871,7 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 		nfs4_clone_super(s, data->sb);
 	}
 
-	mntroot = nfs4_get_root(s, data->fh);
+	mntroot = nfs4_get_root(s, data->fh, acred);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
@@ -1896,6 +1904,7 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 				const char *dev_name, void *raw_data,
 				struct vfsmount *mnt)
 {
+	struct cred *acred = current->cred;
 	struct nfs_clone_mount *data = raw_data;
 	struct super_block *s;
 	struct nfs_server *server;
@@ -1910,7 +1919,7 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs4_create_referral_server(data, &mntfh);
+	server = nfs4_create_referral_server(data, &mntfh, acred);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1937,7 +1946,7 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 		nfs4_fill_super(s);
 	}
 
-	mntroot = nfs4_get_root(s, &mntfh);
+	mntroot = nfs4_get_root(s, &mntfh, acred);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index 83e865a..cd1df31 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -24,15 +24,23 @@
 #include <linux/string.h>
 #include <linux/namei.h>
 
+struct nfs_symlink_filler_data {
+	struct inode	*inode;
+	struct cred	*acred;
+};
+
 /* Symlink caching in the page cache is even more simplistic
  * and straight-forward than readdir caching.
  */
 
-static int nfs_symlink_filler(struct inode *inode, struct page *page)
+static int nfs_symlink_filler(void *_data, struct page *page)
 {
+	struct nfs_symlink_filler_data *data = _data;
+	struct inode *inode = data->inode;
+	struct cred *acred = data->acred;
 	int error;
 
-	error = NFS_PROTO(inode)->readlink(inode, page, 0, PAGE_SIZE);
+	error = NFS_PROTO(inode)->readlink(inode, page, 0, PAGE_SIZE, acred);
 	if (error < 0)
 		goto error;
 	SetPageUptodate(page);
@@ -48,14 +56,20 @@ error:
 static void *nfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
+	struct cred *acred = current->cred;
 	struct page *page;
 	void *err;
 
-	err = ERR_PTR(nfs_revalidate_mapping_nolock(inode, inode->i_mapping));
+	struct nfs_symlink_filler_data data = {
+		.inode = inode,
+		.acred = acred,
+	};
+
+	err = ERR_PTR(nfs_revalidate_mapping_nolock(inode, inode->i_mapping,
+						    acred));
 	if (err)
 		goto read_failed;
-	page = read_cache_page(&inode->i_data, 0,
-				(filler_t *)nfs_symlink_filler, inode);
+	page = read_cache_page(&inode->i_data, 0, nfs_symlink_filler, &data);
 	if (IS_ERR(page)) {
 		err = page;
 		goto read_failed;
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index d4e7d09..0d1700b 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -95,7 +95,7 @@ static void nfs_async_unlink_done(struct rpc_task *task, void *calldata)
  * We need to call nfs_put_unlinkdata as a 'tk_release' task since the
  * rpc_task would be freed too.
  */
-static void nfs_async_unlink_release(void *calldata)
+static void nfs_async_unlink_release(struct cred *acred, void *calldata)
 {
 	struct nfs_unlinkdata	*data = calldata;
 	nfs_free_unlinkdata(data);
@@ -107,7 +107,8 @@ static const struct rpc_call_ops nfs_unlink_ops = {
 	.rpc_release = nfs_async_unlink_release,
 };
 
-static int nfs_call_unlink(struct dentry *dentry, struct nfs_unlinkdata *data)
+static int nfs_call_unlink(struct dentry *dentry, struct nfs_unlinkdata *data,
+			   struct cred *acred)
 {
 	struct rpc_task *task;
 	struct dentry *parent;
@@ -128,7 +129,8 @@ static int nfs_call_unlink(struct dentry *dentry, struct nfs_unlinkdata *data)
 	data->args.fh = NFS_FH(dir);
 	nfs_fattr_init(&data->res.dir_attr);
 
-	task = rpc_run_task(NFS_CLIENT(dir), RPC_TASK_ASYNC, &nfs_unlink_ops, data);
+	task = rpc_run_task(NFS_CLIENT(dir), RPC_TASK_ASYNC, &nfs_unlink_ops,
+			    data, acred);
 	if (!IS_ERR(task))
 		rpc_put_task(task);
 	return 1;
@@ -142,9 +144,8 @@ out_free:
  * @dentry: dentry to unlink
  */
 int
-nfs_async_unlink(struct inode *dir, struct dentry *dentry)
+nfs_async_unlink(struct inode *dir, struct dentry *dentry, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct nfs_unlinkdata *data;
 	int status = -ENOMEM;
 
@@ -179,13 +180,15 @@ out:
  * nfs_complete_unlink - Initialize completion of the sillydelete
  * @dentry: dentry to delete
  * @inode: inode
+ * @acred: the credentials to use
  *
  * Since we're most likely to be called by dentry_iput(), we
  * only use the dentry to find the sillydelete. We then copy the name
  * into the qstr.
  */
 void
-nfs_complete_unlink(struct dentry *dentry, struct inode *inode)
+nfs_complete_unlink(struct dentry *dentry, struct inode *inode,
+		    struct cred *acred)
 {
 	struct nfs_unlinkdata	*data = NULL;
 
@@ -196,6 +199,7 @@ nfs_complete_unlink(struct dentry *dentry, struct inode *inode)
 	}
 	spin_unlock(&dentry->d_lock);
 
-	if (data != NULL && (NFS_STALE(inode) || !nfs_call_unlink(dentry, data)))
+	if (data != NULL &&
+	    (NFS_STALE(inode) || !nfs_call_unlink(dentry, data, acred)))
 		nfs_free_unlinkdata(data);
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0d7a77c..42f5b5d 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -105,7 +105,7 @@ static void nfs_writedata_free(struct nfs_write_data *wdata)
 	call_rcu_bh(&wdata->task.u.tk_rcu, nfs_writedata_rcu_free);
 }
 
-void nfs_writedata_release(void *wdata)
+void nfs_writedata_release(struct cred *acred, void *wdata)
 {
 	nfs_writedata_free(wdata);
 }
@@ -806,8 +806,9 @@ static void nfs_write_rpcsetup(struct nfs_page *req,
 
 	/* Set up the initial task struct.  */
 	flags = (how & FLUSH_SYNC) ? 0 : RPC_TASK_ASYNC;
-	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, call_ops, data);
-	NFS_PROTO(inode)->write_setup(data, how);
+	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, call_ops, data,
+		      req->wb_context->acred);
+	NFS_PROTO(inode)->write_setup(data, how, req->wb_context->acred);
 
 	data->task.tk_priority = flush_task_priority(how);
 	data->task.tk_cookie = (unsigned long)inode;
@@ -837,6 +838,7 @@ static void nfs_execute_write(struct nfs_write_data *data)
  */
 static int nfs_flush_multi(struct inode *inode, struct list_head *head, unsigned int npages, size_t count, int how)
 {
+	struct cred *acred = &writeback_cred;
 	struct nfs_page *req = nfs_list_entry(head->next);
 	struct page *page = req->wb_page;
 	struct nfs_write_data *data;
@@ -884,7 +886,7 @@ out_bad:
 	while (!list_empty(&list)) {
 		data = list_entry(list.next, struct nfs_write_data, pages);
 		list_del(&data->pages);
-		nfs_writedata_release(data);
+		nfs_writedata_release(acred, data);
 	}
 	nfs_redirty_request(req);
 	nfs_end_page_writeback(req->wb_page);
@@ -1141,7 +1143,7 @@ int nfs_writeback_done(struct rpc_task *task, struct nfs_write_data *data)
 
 
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
-void nfs_commit_release(void *wdata)
+void nfs_commit_release(struct cred *acred, void *wdata)
 {
 	nfs_commit_free(wdata);
 }
@@ -1178,8 +1180,9 @@ static void nfs_commit_rpcsetup(struct list_head *head,
 
 	/* Set up the initial task struct.  */
 	flags = (how & FLUSH_SYNC) ? 0 : RPC_TASK_ASYNC;
-	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, &nfs_commit_ops, data);
-	NFS_PROTO(inode)->commit_setup(data, how);
+	rpc_init_task(&data->task, NFS_CLIENT(inode), flags, &nfs_commit_ops,
+		      data, first->wb_context->acred);
+	NFS_PROTO(inode)->commit_setup(data, how, first->wb_context->acred);
 
 	data->task.tk_priority = flush_task_priority(how);
 	data->task.tk_cookie = (unsigned long)inode;
diff --git a/include/linux/lockd/bind.h b/include/linux/lockd/bind.h
index 6f1637c..aacb15c 100644
--- a/include/linux/lockd/bind.h
+++ b/include/linux/lockd/bind.h
@@ -35,8 +35,9 @@ extern struct nlmsvc_binding *	nlmsvc_ops;
 /*
  * Functions exported by the lockd module
  */
-extern int	nlmclnt_proc(struct inode *, int, struct file_lock *);
-extern int	lockd_up(int proto);
+extern int	nlmclnt_proc(struct inode *, int, struct file_lock *,
+			     struct cred *);
+extern int	lockd_up(int proto, struct cred *acred);
 extern void	lockd_down(void);
 
 unsigned long get_nfs_grace_period(void);
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index e2d1ce3..fc5b04e 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -96,6 +96,7 @@ struct nlm_rqst {
 	struct nlm_args		a_args;		/* arguments */
 	struct nlm_res		a_res;		/* result */
 	struct nlm_block *	a_block;
+	struct cred *		a_acred;	/* credentials to use */
 	unsigned int		a_retries;	/* Retry count */
 	u8			a_owner[NLMCLNT_OHSIZE];
 };
@@ -158,7 +159,7 @@ extern int			nsm_use_hostnames;
 /*
  * Lockd client functions
  */
-struct nlm_rqst * nlm_alloc_call(struct nlm_host *host);
+struct nlm_rqst * nlm_alloc_call(struct nlm_host *host, struct cred *acred);
 void		  nlm_release_call(struct nlm_rqst *);
 int		  nlm_async_call(struct nlm_rqst *, u32, const struct rpc_call_ops *);
 int		  nlm_async_reply(struct nlm_rqst *, u32, const struct rpc_call_ops *);
@@ -175,7 +176,7 @@ void		  nlmclnt_next_cookie(struct nlm_cookie *);
  */
 struct nlm_host * nlmclnt_lookup_host(const struct sockaddr_in *, int, int, const char *, int);
 struct nlm_host * nlmsvc_lookup_host(struct svc_rqst *, const char *, int);
-struct rpc_clnt * nlm_bind_host(struct nlm_host *);
+struct rpc_clnt * nlm_bind_host(struct nlm_host *, struct cred *);
 void		  nlm_rebind_host(struct nlm_host *);
 struct nlm_host * nlm_get_host(struct nlm_host *);
 void		  nlm_release_host(struct nlm_host *);
diff --git a/include/linux/lockd/sm_inter.h b/include/linux/lockd/sm_inter.h
index 22a6458..a7dc1c6 100644
--- a/include/linux/lockd/sm_inter.h
+++ b/include/linux/lockd/sm_inter.h
@@ -40,8 +40,8 @@ struct nsm_res {
 	u32		state;
 };
 
-int		nsm_monitor(struct nlm_host *);
-int		nsm_unmonitor(struct nlm_host *);
+int		nsm_monitor(struct nlm_host *, struct cred *);
+int		nsm_unmonitor(struct nlm_host *, struct cred *);
 extern int	nsm_local_state;
 
 #endif /* LINUX_LOCKD_SM_INTER_H */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 7250eea..f7ab86c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -73,6 +73,7 @@ struct nfs4_state;
 struct nfs_open_context {
 	atomic_t count;
 	struct path path;
+	struct cred *acred;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
 	fl_owner_t lockowner;
@@ -295,10 +296,16 @@ extern void nfs_access_zap_cache(struct inode *inode);
 extern int nfs_open(struct inode *, struct file *);
 extern int nfs_release(struct inode *, struct file *);
 extern int nfs_attribute_timeout(struct inode *inode);
-extern int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode);
-extern int __nfs_revalidate_inode(struct nfs_server *, struct inode *);
-extern int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping);
-extern int nfs_revalidate_mapping_nolock(struct inode *inode, struct address_space *mapping);
+extern int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode,
+				struct cred *acred);
+extern int __nfs_revalidate_inode(struct nfs_server *, struct inode *,
+				  struct cred *);
+extern int nfs_revalidate_mapping(struct inode *inode,
+				  struct address_space *mapping,
+				  struct cred *acred);
+extern int nfs_revalidate_mapping_nolock(struct inode *inode,
+					 struct address_space *mapping,
+					 struct cred *acred);
 extern int nfs_setattr(struct dentry *, struct iattr *);
 extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr);
 extern void nfs_begin_attr_update(struct inode *);
@@ -377,7 +384,8 @@ extern const struct inode_operations nfs3_dir_inode_operations;
 extern const struct file_operations nfs_dir_operations;
 extern struct dentry_operations nfs_dentry_operations;
 
-extern int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fh, struct nfs_fattr *fattr);
+extern int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fh,
+			   struct nfs_fattr *fattr, struct cred *acred);
 
 /*
  * linux/fs/nfs/symlink.c
@@ -407,8 +415,9 @@ extern void nfs_release_automount_timer(void);
 /*
  * linux/fs/nfs/unlink.c
  */
-extern int  nfs_async_unlink(struct inode *dir, struct dentry *dentry);
-extern void nfs_complete_unlink(struct dentry *dentry, struct inode *);
+extern int  nfs_async_unlink(struct inode *dir, struct dentry *dentry,
+			     struct cred *);
+extern void nfs_complete_unlink(struct dentry *, struct inode *, struct cred *);
 
 /*
  * linux/fs/nfs/write.c
@@ -419,7 +428,7 @@ extern int  nfs_writepages(struct address_space *, struct writeback_control *);
 extern int  nfs_flush_incompatible(struct file *file, struct page *page);
 extern int  nfs_updatepage(struct file *, struct page *, unsigned int, unsigned int);
 extern int nfs_writeback_done(struct rpc_task *, struct nfs_write_data *);
-extern void nfs_writedata_release(void *);
+extern void nfs_writedata_release(struct cred *, void *);
 extern int nfs_set_page_dirty(struct page *);
 
 /*
@@ -436,7 +445,7 @@ extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_write_data *nfs_commit_alloc(void);
 extern void nfs_commit_free(struct nfs_write_data *wdata);
-extern void nfs_commit_release(void *wdata);
+extern void nfs_commit_release(struct cred *acred, void *wdata);
 #else
 static inline int
 nfs_commit_inode(struct inode *inode, int how)
@@ -463,7 +472,7 @@ extern int  nfs_readpage(struct file *, struct page *);
 extern int  nfs_readpages(struct file *, struct address_space *,
 		struct list_head *, unsigned);
 extern int  nfs_readpage_result(struct rpc_task *, struct nfs_read_data *);
-extern void nfs_readdata_release(void *data);
+extern void nfs_readdata_release(struct cred *acred, void *data);
 
 /*
  * Allocate nfs_read_data structures
@@ -474,11 +483,12 @@ extern struct nfs_read_data *nfs_readdata_alloc(unsigned int npages);
  * linux/fs/nfs3proc.c
  */
 #ifdef CONFIG_NFS_V3_ACL
-extern struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type);
+extern struct posix_acl *nfs3_proc_getacl(struct inode *inode, int type,
+					  struct cred *acred);
 extern int nfs3_proc_setacl(struct inode *inode, int type,
-			    struct posix_acl *acl);
+			    struct posix_acl *acl, struct cred *acred);
 extern int nfs3_proc_set_default_acl(struct inode *dir, struct inode *inode,
-		mode_t mode);
+		mode_t mode, struct cred *acred);
 extern void nfs3_forget_cached_acls(struct inode *inode);
 #else
 static inline int nfs3_proc_set_default_acl(struct inode *dir,
@@ -497,7 +507,7 @@ static inline void nfs3_forget_cached_acls(struct inode *inode)
  * linux/fs/mount_clnt.c
  */
 extern int  nfs_mount(struct sockaddr *, size_t, char *, char *,
-		      int, int, struct nfs_fh *);
+		      int, int, struct nfs_fh *, struct cred *);
 
 /*
  * inline functions
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index cf74a4d..e82a5db 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -775,48 +775,56 @@ struct nfs_rpc_ops {
 	const struct inode_operations *file_inode_ops;
 
 	int	(*getroot) (struct nfs_server *, struct nfs_fh *,
-			    struct nfs_fsinfo *);
+			    struct nfs_fsinfo *, struct cred *);
 	int	(*lookupfh)(struct nfs_server *, struct nfs_fh *,
 			    struct qstr *, struct nfs_fh *,
-			    struct nfs_fattr *);
+			    struct nfs_fattr *, struct cred *);
 	int	(*getattr) (struct nfs_server *, struct nfs_fh *,
-			    struct nfs_fattr *);
+			    struct nfs_fattr *, struct cred *);
 	int	(*setattr) (struct dentry *, struct nfs_fattr *,
-			    struct iattr *);
+			    struct iattr *, struct cred *);
 	int	(*lookup)  (struct inode *, struct qstr *,
-			    struct nfs_fh *, struct nfs_fattr *);
-	int	(*access)  (struct inode *, struct nfs_access_entry *);
+			    struct nfs_fh *, struct nfs_fattr *, struct cred *);
+	int	(*access)  (struct inode *, struct nfs_access_entry *,
+			    struct cred *);
 	int	(*readlink)(struct inode *, struct page *, unsigned int,
-			    unsigned int);
+			    unsigned int, struct cred *);
 	int	(*create)  (struct inode *, struct dentry *,
-			    struct iattr *, int, struct nameidata *);
-	int	(*remove)  (struct inode *, struct qstr *);
+			    struct iattr *, int, struct nameidata *,
+			    struct cred *);
+	int	(*remove)  (struct inode *, struct qstr *, struct cred *);
 	void	(*unlink_setup)  (struct rpc_message *, struct inode *dir);
 	int	(*unlink_done) (struct rpc_task *, struct inode *);
 	int	(*rename)  (struct inode *, struct qstr *,
-			    struct inode *, struct qstr *);
-	int	(*link)    (struct inode *, struct inode *, struct qstr *);
+			    struct inode *, struct qstr *, struct cred *);
+	int	(*link)    (struct inode *, struct inode *, struct qstr *,
+			    struct cred *);
 	int	(*symlink) (struct inode *, struct dentry *, struct page *,
-			    unsigned int, struct iattr *);
-	int	(*mkdir)   (struct inode *, struct dentry *, struct iattr *);
-	int	(*rmdir)   (struct inode *, struct qstr *);
+			    unsigned int, struct iattr *, struct cred *);
+	int	(*mkdir)   (struct inode *, struct dentry *, struct iattr *,
+			    struct cred *);
+	int	(*rmdir)   (struct inode *, struct qstr *, struct cred *);
 	int	(*readdir) (struct dentry *, struct rpc_cred *,
-			    u64, struct page *, unsigned int, int);
+			    u64, struct page *, unsigned int, int,
+			    struct cred *);
 	int	(*mknod)   (struct inode *, struct dentry *, struct iattr *,
-			    dev_t);
+			    dev_t, struct cred *);
 	int	(*statfs)  (struct nfs_server *, struct nfs_fh *,
-			    struct nfs_fsstat *);
+			    struct nfs_fsstat *, struct cred *);
 	int	(*fsinfo)  (struct nfs_server *, struct nfs_fh *,
-			    struct nfs_fsinfo *);
+			    struct nfs_fsinfo *, struct cred *);
 	int	(*pathconf) (struct nfs_server *, struct nfs_fh *,
-			     struct nfs_pathconf *);
-	int	(*set_capabilities)(struct nfs_server *, struct nfs_fh *);
+			     struct nfs_pathconf *, struct cred *);
+	int	(*set_capabilities)(struct nfs_server *, struct nfs_fh *,
+				    struct cred *);
 	__be32 *(*decode_dirent)(__be32 *, struct nfs_entry *, int plus);
-	void	(*read_setup)   (struct nfs_read_data *);
+	void	(*read_setup)   (struct nfs_read_data *, struct cred *);
 	int	(*read_done)  (struct rpc_task *, struct nfs_read_data *);
-	void	(*write_setup)  (struct nfs_write_data *, int how);
+	void	(*write_setup)  (struct nfs_write_data *, int how,
+				 struct cred *);
 	int	(*write_done)  (struct rpc_task *, struct nfs_write_data *);
-	void	(*commit_setup) (struct nfs_write_data *, int how);
+	void	(*commit_setup) (struct nfs_write_data *, int how,
+				 struct cred *);
 	int	(*commit_done) (struct rpc_task *, struct nfs_write_data *);
 	int	(*file_open)   (struct inode *, struct file *);
 	int	(*file_release) (struct inode *, struct file *);
diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index ae52668..3b68540 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -115,9 +115,9 @@ struct rpc_create_args {
 #define RPC_CLNT_CREATE_NOPING		(1UL << 4)
 #define RPC_CLNT_CREATE_DISCRTRY	(1UL << 5)
 
-struct rpc_clnt *rpc_create(struct rpc_create_args *args);
+struct rpc_clnt *rpc_create(struct rpc_create_args *args, struct cred *acred);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
-				struct rpc_program *, int);
+				struct rpc_program *, int, struct cred *);
 struct rpc_clnt *rpc_clone_client(struct rpc_clnt *);
 void		rpc_shutdown_client(struct rpc_clnt *);
 void		rpc_release_client(struct rpc_clnt *);
@@ -131,11 +131,11 @@ void		rpc_call_setup(struct rpc_task *, struct rpc_message *, int,
 
 int		rpc_call_async(struct rpc_clnt *clnt, struct rpc_message *msg,
 			       int flags, const struct rpc_call_ops *tk_ops,
-			       void *calldata);
+			       void *calldata, struct cred *acred);
 int		rpc_call_sync(struct rpc_clnt *clnt, struct rpc_message *msg,
-			      int flags);
+			      int flags, struct cred *acred);
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
-			       int flags);
+			       int flags, struct cred *acred);
 void		rpc_restart_call(struct rpc_task *);
 void		rpc_clnt_sigmask(struct rpc_clnt *clnt, sigset_t *oldset);
 void		rpc_clnt_sigunmask(struct rpc_clnt *clnt, sigset_t *oldset);
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index fed97e0..a7764bb 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -115,7 +115,7 @@ typedef void			(*rpc_action)(struct rpc_task *);
 struct rpc_call_ops {
 	void (*rpc_call_prepare)(struct rpc_task *, void *);
 	void (*rpc_call_done)(struct rpc_task *, void *);
-	void (*rpc_release)(void *);
+	void (*rpc_release)(struct cred *, void *);
 };
 
 
@@ -238,15 +238,18 @@ struct rpc_wait_queue {
  * Function prototypes
  */
 struct rpc_task *rpc_new_task(struct rpc_clnt *, int flags,
-				const struct rpc_call_ops *ops, void *data);
+				const struct rpc_call_ops *ops, void *data,
+				struct cred *acred);
 struct rpc_task *rpc_run_task(struct rpc_clnt *clnt, int flags,
-				const struct rpc_call_ops *ops, void *data);
+				const struct rpc_call_ops *ops, void *data,
+			        struct cred *acred);
 void		rpc_init_task(struct rpc_task *task, struct rpc_clnt *clnt,
 				int flags, const struct rpc_call_ops *ops,
-				void *data);
+				void *data, struct cred *cred);
 void		rpc_put_task(struct rpc_task *);
 void		rpc_exit_task(struct rpc_task *);
-void		rpc_release_calldata(const struct rpc_call_ops *, void *);
+void		rpc_release_calldata(const struct rpc_call_ops *, void *,
+				     struct cred *);
 void		rpc_killall_tasks(struct rpc_clnt *);
 void		rpc_execute(struct rpc_task *);
 void		rpc_init_priority_wait_queue(struct rpc_wait_queue *, const char *);
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index bad2698..26c1913 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -720,7 +720,7 @@ gss_destroying_context(struct rpc_cred *cred)
 	 * by the RPC call or by the put_rpccred() below */
 	get_rpccred(cred);
 
-	task = rpc_call_null(gss_auth->client, cred, RPC_TASK_ASYNC);
+	task = rpc_call_null(gss_auth->client, cred, RPC_TASK_ASYNC, &init_cred);
 	if (!IS_ERR(task))
 		rpc_put_task(task);
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a02a776..952e2eb 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -72,7 +72,7 @@ static void	call_connect_status(struct rpc_task *task);
 static __be32 *	call_header(struct rpc_task *task);
 static __be32 *	call_verify(struct rpc_task *task);
 
-static int	rpc_ping(struct rpc_clnt *clnt, int flags);
+static int	rpc_ping(struct rpc_clnt *clnt, int flags, struct cred *acred);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
 {
@@ -223,6 +223,7 @@ out_no_rpciod:
 /*
  * rpc_create - create an RPC client and transport with one call
  * @args: rpc_clnt create argument structure
+ * @acred: the credentials to use
  *
  * Creates and initializes an RPC transport and an RPC client.
  *
@@ -230,7 +231,7 @@ out_no_rpciod:
  * it supports this program and version.  RPC_CLNT_CREATE_NOPING disables
  * this behavior so asynchronous tasks can also use rpc_create.
  */
-struct rpc_clnt *rpc_create(struct rpc_create_args *args)
+struct rpc_clnt *rpc_create(struct rpc_create_args *args, struct cred *acred)
 {
 	struct rpc_xprt *xprt;
 	struct rpc_clnt *clnt;
@@ -278,7 +279,7 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
 		return clnt;
 
 	if (!(args->flags & RPC_CLNT_CREATE_NOPING)) {
-		int err = rpc_ping(clnt, RPC_TASK_SOFT|RPC_TASK_NOINTR);
+		int err = rpc_ping(clnt, RPC_TASK_SOFT|RPC_TASK_NOINTR, acred);
 		if (err != 0) {
 			rpc_shutdown_client(clnt);
 			return ERR_PTR(err);
@@ -432,6 +433,7 @@ rpc_release_client(struct rpc_clnt *clnt)
  * @old - old rpc_client
  * @program - rpc program to set
  * @vers - rpc program version
+ * @acred - the credentials to use
  *
  * Clones the rpc client and sets up a new RPC program. This is mainly
  * of use for enabling different RPC programs to share the same transport.
@@ -439,7 +441,8 @@ rpc_release_client(struct rpc_clnt *clnt)
  */
 struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 				      struct rpc_program *program,
-				      int vers)
+				      int vers,
+				      struct cred *acred)
 {
 	struct rpc_clnt *clnt;
 	struct rpc_version *version;
@@ -456,7 +459,7 @@ struct rpc_clnt *rpc_bind_new_program(struct rpc_clnt *old,
 	clnt->cl_prog     = program->number;
 	clnt->cl_vers     = version->number;
 	clnt->cl_stats    = program->stats;
-	err = rpc_ping(clnt, RPC_TASK_SOFT|RPC_TASK_NOINTR);
+	err = rpc_ping(clnt, RPC_TASK_SOFT|RPC_TASK_NOINTR, acred);
 	if (err != 0) {
 		rpc_shutdown_client(clnt);
 		clnt = ERR_PTR(err);
@@ -520,21 +523,22 @@ struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 		struct rpc_message *msg,
 		int flags,
 		const struct rpc_call_ops *ops,
-		void *data)
+		void *data,
+		struct cred *acred)
 {
 	struct rpc_task *task, *ret;
 	sigset_t oldset;
 
-	task = rpc_new_task(clnt, flags, ops, data);
+	task = rpc_new_task(clnt, flags, ops, data, acred);
 	if (task == NULL) {
-		rpc_release_calldata(ops, data);
+		rpc_release_calldata(ops, data, acred);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	/* Mask signals on synchronous RPC calls and RPCSEC_GSS upcalls */
 	rpc_task_sigmask(task, &oldset);
 	if (msg != NULL) {
-		rpc_call_setup(task, msg, 0, current->cred);
+		rpc_call_setup(task, msg, 0, acred);
 		if (task->tk_status != 0) {
 			ret = ERR_PTR(task->tk_status);
 			rpc_put_task(task);
@@ -554,15 +558,17 @@ out:
  * @clnt: pointer to RPC client
  * @msg: RPC call parameters
  * @flags: RPC call flags
+ * @acred: the credentials to use
  */
-int rpc_call_sync(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
+int rpc_call_sync(struct rpc_clnt *clnt, struct rpc_message *msg, int flags,
+		  struct cred *acred)
 {
 	struct rpc_task	*task;
 	int status;
 
 	BUG_ON(flags & RPC_TASK_ASYNC);
 
-	task = rpc_do_run_task(clnt, msg, flags, &rpc_default_ops, NULL);
+	task = rpc_do_run_task(clnt, msg, flags, &rpc_default_ops, NULL, acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	status = task->tk_status;
@@ -577,14 +583,17 @@ int rpc_call_sync(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
  * @flags: RPC call flags
  * @ops: RPC call ops
  * @data: user call data
+ * @acred: the credentials to use
  */
 int
 rpc_call_async(struct rpc_clnt *clnt, struct rpc_message *msg, int flags,
-	       const struct rpc_call_ops *tk_ops, void *data)
+	       const struct rpc_call_ops *tk_ops, void *data,
+	       struct cred *acred)
 {
 	struct rpc_task	*task;
 
-	task = rpc_do_run_task(clnt, msg, flags|RPC_TASK_ASYNC, tk_ops, data);
+	task = rpc_do_run_task(clnt, msg, flags|RPC_TASK_ASYNC, tk_ops, data,
+			       acred);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	rpc_put_task(task);
@@ -597,12 +606,13 @@ rpc_call_async(struct rpc_clnt *clnt, struct rpc_message *msg, int flags,
  * @flags: RPC flags
  * @ops: RPC call ops
  * @data: user call data
+ * @acred: the credentials to use
  */
 struct rpc_task *rpc_run_task(struct rpc_clnt *clnt, int flags,
 					const struct rpc_call_ops *tk_ops,
-					void *data)
+					void *data, struct cred *acred)
 {
-	return rpc_do_run_task(clnt, NULL, flags, tk_ops, data);
+	return rpc_do_run_task(clnt, NULL, flags, tk_ops, data, acred);
 }
 EXPORT_SYMBOL(rpc_run_task);
 
@@ -1485,25 +1495,27 @@ static struct rpc_procinfo rpcproc_null = {
 	.p_decode = rpcproc_decode_null,
 };
 
-static int rpc_ping(struct rpc_clnt *clnt, int flags)
+static int rpc_ping(struct rpc_clnt *clnt, int flags, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc = &rpcproc_null,
 	};
 	int err;
 	msg.rpc_cred = authnull_ops.lookup_cred(NULL, NULL, 0);
-	err = rpc_call_sync(clnt, &msg, flags);
+	err = rpc_call_sync(clnt, &msg, flags, acred);
 	put_rpccred(msg.rpc_cred);
 	return err;
 }
 
-struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred, int flags)
+struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
+			       int flags, struct cred *acred)
 {
 	struct rpc_message msg = {
 		.rpc_proc = &rpcproc_null,
 		.rpc_cred = cred,
 	};
-	return rpc_do_run_task(clnt, &msg, flags, &rpc_default_ops, NULL);
+	return rpc_do_run_task(clnt, &msg, flags, &rpc_default_ops, NULL,
+			       acred);
 }
 EXPORT_SYMBOL(rpc_call_null);
 
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 82a863c..0a2404e 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -155,7 +155,7 @@ static void rpcb_getport_prepare(struct rpc_task *task, void *calldata)
 	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
-static void rpcb_map_release(void *data)
+static void rpcb_map_release(struct cred *acred, void *data)
 {
 	struct rpcbind_args *map = data;
 
@@ -193,7 +193,7 @@ static struct rpc_clnt *rpcb_create(char *hostname, struct sockaddr *srvaddr,
 	((struct sockaddr_in *)srvaddr)->sin_port = htons(RPCBIND_PORT);
 	if (!privileged)
 		args.flags |= RPC_CLNT_CREATE_NONPRIVPORT;
-	return rpc_create(&args);
+	return rpc_create(&args, &init_cred);
 }
 
 /**
@@ -238,7 +238,7 @@ int rpcb_register(u32 prog, u32 vers, int prot, unsigned short port, int *okay)
 	if (IS_ERR(rpcb_clnt))
 		return PTR_ERR(rpcb_clnt);
 
-	error = rpc_call_sync(rpcb_clnt, &msg, 0);
+	error = rpc_call_sync(rpcb_clnt, &msg, 0, &init_cred);
 
 	rpc_shutdown_client(rpcb_clnt);
 	if (error < 0)
@@ -287,7 +287,7 @@ int rpcb_getport_sync(struct sockaddr_in *sin, __u32 prog,
 	if (IS_ERR(rpcb_clnt))
 		return PTR_ERR(rpcb_clnt);
 
-	status = rpc_call_sync(rpcb_clnt, &msg, 0);
+	status = rpc_call_sync(rpcb_clnt, &msg, 0, &init_cred);
 	rpc_shutdown_client(rpcb_clnt);
 
 	if (status >= 0) {
@@ -374,7 +374,8 @@ void rpcb_getport_async(struct rpc_task *task)
 	map->r_owner = RPCB_OWNER_STRING;	/* ignored for GETADDR */
 
 	rpc_peeraddr(clnt, (void *)&addr, sizeof(addr));
-	rpcb_clnt = rpcb_create(clnt->cl_server, &addr, xprt->prot, bind_version, 0);
+	rpcb_clnt = rpcb_create(clnt->cl_server, &addr, xprt->prot,
+				bind_version, 0);
 	if (IS_ERR(rpcb_clnt)) {
 		status = PTR_ERR(rpcb_clnt);
 		dprintk("RPC: %5u %s: rpcb_create failed, error %ld\n",
@@ -382,7 +383,8 @@ void rpcb_getport_async(struct rpc_task *task)
 		goto bailout;
 	}
 
-	child = rpc_run_task(rpcb_clnt, RPC_TASK_ASYNC, &rpcb_getport_ops, map);
+	child = rpc_run_task(rpcb_clnt, RPC_TASK_ASYNC, &rpcb_getport_ops, map,
+			     &init_cred);
 	rpc_release_client(rpcb_clnt);
 	if (IS_ERR(child)) {
 		status = -EIO;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index d9d4219..510ac24 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -616,11 +616,12 @@ void rpc_exit_task(struct rpc_task *task)
 }
 EXPORT_SYMBOL(rpc_exit_task);
 
-void rpc_release_calldata(const struct rpc_call_ops *ops, void *calldata)
+void rpc_release_calldata(const struct rpc_call_ops *ops, void *calldata,
+			  struct cred *acred)
 {
 	if (ops->rpc_release != NULL) {
 		lock_kernel();
-		ops->rpc_release(calldata);
+		ops->rpc_release(acred, calldata);
 		unlock_kernel();
 	}
 }
@@ -806,10 +807,10 @@ void rpc_free(void *buffer)
 /*
  * Creation and deletion of RPC task structures
  */
-void rpc_init_task(struct rpc_task *task, struct rpc_clnt *clnt, int flags, const struct rpc_call_ops *tk_ops, void *calldata)
+void rpc_init_task(struct rpc_task *task, struct rpc_clnt *clnt, int flags,
+		   const struct rpc_call_ops *tk_ops, void *calldata,
+		   struct cred *acred)
 {
-	struct cred *acred = current->cred;
-
 	memset(task, 0, sizeof(*task));
 	init_timer(&task->tk_timer);
 	task->tk_timer.data     = (unsigned long) task;
@@ -867,7 +868,9 @@ static void rpc_free_task(struct rcu_head *rcu)
 /*
  * Create a new task for the specified client.
  */
-struct rpc_task *rpc_new_task(struct rpc_clnt *clnt, int flags, const struct rpc_call_ops *tk_ops, void *calldata)
+struct rpc_task *rpc_new_task(struct rpc_clnt *clnt, int flags,
+			      const struct rpc_call_ops *tk_ops, void *calldata,
+			      struct cred *acred)
 {
 	struct rpc_task	*task;
 
@@ -875,7 +878,7 @@ struct rpc_task *rpc_new_task(struct rpc_clnt *clnt, int flags, const struct rpc
 	if (!task)
 		goto out;
 
-	rpc_init_task(task, clnt, flags, tk_ops, calldata);
+	rpc_init_task(task, clnt, flags, tk_ops, calldata, acred);
 
 	dprintk("RPC:       allocated task %p\n", task);
 	task->tk_flags |= RPC_TASK_DYNAMIC;
@@ -887,6 +890,7 @@ out:
 void rpc_put_task(struct rpc_task *task)
 {
 	const struct rpc_call_ops *tk_ops = task->tk_ops;
+	struct cred *acred = task->tk_acred;
 	void *calldata = task->tk_calldata;
 
 	if (!atomic_dec_and_test(&task->tk_count))
@@ -900,10 +904,10 @@ void rpc_put_task(struct rpc_task *task)
 		rpc_release_client(task->tk_client);
 		task->tk_client = NULL;
 	}
-	put_cred(task->tk_acred);
 	if (task->tk_flags & RPC_TASK_DYNAMIC)
 		call_rcu_bh(&task->u.tk_rcu, rpc_free_task);
-	rpc_release_calldata(tk_ops, calldata);
+	rpc_release_calldata(tk_ops, calldata, acred);
+	put_cred(acred);
 }
 EXPORT_SYMBOL(rpc_put_task);
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 55ea6df..b84573c 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -435,7 +435,7 @@ svc_create(struct svc_program *prog, unsigned int bufsize,
 
 struct svc_serv *
 svc_create_pooled(struct svc_program *prog, unsigned int bufsize,
-		void (*shutdown)(struct svc_serv *serv),
+		  void (*shutdown)(struct svc_serv *serv),
 		  svc_thread_fn func, int sig, struct module *mod)
 {
 	struct svc_serv *serv;
@@ -757,7 +757,8 @@ svc_register(struct svc_serv *serv, int proto, unsigned short port)
 			if (progp->pg_vers[i]->vs_hidden)
 				continue;
 
-			error = rpcb_register(progp->pg_prog, i, proto, port, &dummy);
+			error = rpcb_register(progp->pg_prog, i, proto, port,
+					      &dummy);
 			if (error < 0)
 				break;
 			if (port && !dummy) {

