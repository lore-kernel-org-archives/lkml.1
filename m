Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbXJLQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbXJLQOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbXJLQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760342AbXJLQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/52] CRED: Make rpcauth_bindcred() take a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:51 +0100
Message-ID: <20071012160651.15119.28265.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make rpcauth_bindcred() take a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/nfs3proc.c           |    6 +++---
 fs/nfs/nfs4proc.c           |   18 +++++++++---------
 fs/nfs/proc.c               |    4 ++--
 fs/nfs/unlink.c             |    2 +-
 include/linux/sunrpc/auth.h |    2 +-
 include/linux/sunrpc/clnt.h |    3 ++-
 net/sunrpc/auth.c           |    4 ++--
 net/sunrpc/clnt.c           |    7 ++++---
 net/sunrpc/rpcb_clnt.c      |    2 +-
 9 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index c7ca5d7..329e6a2 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -739,7 +739,7 @@ static void nfs3_proc_read_setup(struct nfs_read_data *data)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int nfs3_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -768,7 +768,7 @@ static void nfs3_proc_write_setup(struct nfs_write_data *data, int how)
 	}
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int nfs3_commit_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -789,7 +789,7 @@ static void nfs3_proc_commit_setup(struct nfs_write_data *data, int how)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9a02b61..24c5021 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -729,7 +729,7 @@ static void nfs4_open_confirm_prepare(struct rpc_task *task, void *calldata)
 		.rpc_cred = data->owner->so_cred,
 	};
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 static void nfs4_open_confirm_done(struct rpc_task *task, void *calldata)
@@ -838,7 +838,7 @@ static void nfs4_open_prepare(struct rpc_task *task, void *calldata)
 		nfs_copy_fh(&data->o_res.fh, data->o_arg.fh);
 	}
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 	return;
 out_no_action:
 	task->tk_action = NULL;
@@ -1316,7 +1316,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 		calldata->arg.open_flags = FMODE_WRITE;
 	}
 	calldata->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 static const struct rpc_call_ops nfs4_close_ops = {
@@ -2434,7 +2434,7 @@ static void nfs4_proc_read_setup(struct nfs_read_data *data)
 
 	data->timestamp   = jiffies;
 
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int nfs4_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -2478,7 +2478,7 @@ static void nfs4_proc_write_setup(struct nfs_write_data *data, int how)
 	data->timestamp   = jiffies;
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int nfs4_commit_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -2507,7 +2507,7 @@ static void nfs4_proc_commit_setup(struct nfs_write_data *data, int how)
 	data->args.bitmask = server->attr_bitmask;
 	data->res.server = server;
 
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 /*
@@ -3007,7 +3007,7 @@ static void nfs4_delegreturn_prepare(struct rpc_task *task, void *calldata)
 		.rpc_cred = data->cred,
 	};
 	nfs_fattr_init(data->res.fattr);
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
@@ -3255,7 +3255,7 @@ static void nfs4_locku_prepare(struct rpc_task *task, void *data)
 		return;
 	}
 	calldata->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 static const struct rpc_call_ops nfs4_locku_ops = {
@@ -3384,7 +3384,7 @@ static void nfs4_lock_prepare(struct rpc_task *task, void *calldata)
 		data->arg.new_lock_owner = 1;
 	}
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 out:
 	dprintk("%s: done!, ret = %d\n", __FUNCTION__, data->rpc_status);
 }
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 845cdde..d6baeb4 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -570,7 +570,7 @@ static void nfs_proc_read_setup(struct nfs_read_data *data)
 		.rpc_cred	= data->cred,
 	};
 
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static int nfs_write_done(struct rpc_task *task, struct nfs_write_data *data)
@@ -593,7 +593,7 @@ static void nfs_proc_write_setup(struct nfs_write_data *data, int how)
 	data->args.stable = NFS_FILE_SYNC;
 
 	/* Finalize the task. */
-	rpc_call_setup(&data->task, &msg, 0);
+	rpc_call_setup(&data->task, &msg, 0, current->cred);
 }
 
 static void
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index c6bcd5c..b5e2575 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -68,7 +68,7 @@ static void nfs_async_unlink_init(struct rpc_task *task, void *calldata)
 
 	nfs_begin_data_update(dir);
 	NFS_PROTO(dir)->unlink_setup(&msg, dir);
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 /**
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 63fe023..34b7166 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -131,7 +131,7 @@ struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct cred *, int
 void			rpcauth_init_cred(struct rpc_cred *, const struct cred *, struct rpc_auth *, const struct rpc_credops *);
 struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int,
 					   struct cred *);
-struct rpc_cred *	rpcauth_bindcred(struct rpc_task *);
+struct rpc_cred *	rpcauth_bindcred(struct rpc_task *, struct cred *);
 void			rpcauth_holdcred(struct rpc_task *);
 void			put_rpccred(struct rpc_cred *);
 void			rpcauth_unbindcred(struct rpc_task *);
diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index c0d9d14..ae52668 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -126,7 +126,8 @@ int		rpcb_register(u32, u32, int, unsigned short, int *);
 int		rpcb_getport_sync(struct sockaddr_in *, __u32, __u32, int);
 void		rpcb_getport_async(struct rpc_task *);
 
-void		rpc_call_setup(struct rpc_task *, struct rpc_message *, int);
+void		rpc_call_setup(struct rpc_task *, struct rpc_message *, int,
+			       struct cred *);
 
 int		rpc_call_async(struct rpc_clnt *clnt, struct rpc_message *msg,
 			       int flags, const struct rpc_call_ops *tk_ops,
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index d1cc555..7cb8d5e 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -359,7 +359,7 @@ rpcauth_init_cred(struct rpc_cred *cred, const struct cred *acred,
 EXPORT_SYMBOL(rpcauth_init_cred);
 
 struct rpc_cred *
-rpcauth_bindcred(struct rpc_task *task)
+rpcauth_bindcred(struct rpc_task *task, struct cred *acred)
 {
 	struct rpc_auth *auth = task->tk_client->cl_auth;
 	struct rpc_cred *ret;
@@ -369,7 +369,7 @@ rpcauth_bindcred(struct rpc_task *task)
 		task->tk_pid, task->tk_client->cl_auth->au_ops->au_name);
 	if (task->tk_flags & RPC_TASK_ROOTCREDS)
 		flags |= RPCAUTH_LOOKUP_ROOTCREDS;
-	ret = auth->au_ops->lookup_cred(auth, current->cred, flags);
+	ret = auth->au_ops->lookup_cred(auth, acred, flags);
 	if (!IS_ERR(ret))
 		task->tk_msg.rpc_cred = ret;
 	else
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 52429b1..a02a776 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -534,7 +534,7 @@ struct rpc_task *rpc_do_run_task(struct rpc_clnt *clnt,
 	/* Mask signals on synchronous RPC calls and RPCSEC_GSS upcalls */
 	rpc_task_sigmask(task, &oldset);
 	if (msg != NULL) {
-		rpc_call_setup(task, msg, 0);
+		rpc_call_setup(task, msg, 0, current->cred);
 		if (task->tk_status != 0) {
 			ret = ERR_PTR(task->tk_status);
 			rpc_put_task(task);
@@ -607,7 +607,8 @@ struct rpc_task *rpc_run_task(struct rpc_clnt *clnt, int flags,
 EXPORT_SYMBOL(rpc_run_task);
 
 void
-rpc_call_setup(struct rpc_task *task, struct rpc_message *msg, int flags)
+rpc_call_setup(struct rpc_task *task, struct rpc_message *msg, int flags,
+	       struct cred *acred)
 {
 	task->tk_msg   = *msg;
 	task->tk_flags |= flags;
@@ -615,7 +616,7 @@ rpc_call_setup(struct rpc_task *task, struct rpc_message *msg, int flags)
 	if (task->tk_msg.rpc_cred != NULL)
 		rpcauth_holdcred(task);
 	else
-		rpcauth_bindcred(task);
+		rpcauth_bindcred(task, acred);
 
 	if (task->tk_status == 0)
 		task->tk_action = call_start;
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index d1740db..6d167f0 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -152,7 +152,7 @@ static void rpcb_getport_prepare(struct rpc_task *task, void *calldata)
 		.rpc_resp	= &map->r_port,
 	};
 
-	rpc_call_setup(task, &msg, 0);
+	rpc_call_setup(task, &msg, 0, current->cred);
 }
 
 static void rpcb_map_release(void *data)

