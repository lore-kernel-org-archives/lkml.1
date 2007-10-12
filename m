Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbXJLQOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbXJLQOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760392AbXJLQHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760374AbXJLQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/52] CRED: Add a credentials pointer to struct rpc_task
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:56 +0100
Message-ID: <20071012160656.15119.33776.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a credentials pointer to struct rpc_task and make use of it in the
rpc_call_prepare() operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/nfs4proc.c            |   12 ++++++------
 fs/nfs/unlink.c              |    2 +-
 include/linux/sunrpc/sched.h |    1 +
 net/sunrpc/rpcb_clnt.c       |    2 +-
 net/sunrpc/sched.c           |    4 ++++
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 24c5021..943095d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -729,7 +729,7 @@ static void nfs4_open_confirm_prepare(struct rpc_task *task, void *calldata)
 		.rpc_cred = data->owner->so_cred,
 	};
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 static void nfs4_open_confirm_done(struct rpc_task *task, void *calldata)
@@ -838,7 +838,7 @@ static void nfs4_open_prepare(struct rpc_task *task, void *calldata)
 		nfs_copy_fh(&data->o_res.fh, data->o_arg.fh);
 	}
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 	return;
 out_no_action:
 	task->tk_action = NULL;
@@ -1316,7 +1316,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 		calldata->arg.open_flags = FMODE_WRITE;
 	}
 	calldata->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 static const struct rpc_call_ops nfs4_close_ops = {
@@ -3007,7 +3007,7 @@ static void nfs4_delegreturn_prepare(struct rpc_task *task, void *calldata)
 		.rpc_cred = data->cred,
 	};
 	nfs_fattr_init(data->res.fattr);
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
@@ -3255,7 +3255,7 @@ static void nfs4_locku_prepare(struct rpc_task *task, void *data)
 		return;
 	}
 	calldata->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 static const struct rpc_call_ops nfs4_locku_ops = {
@@ -3384,7 +3384,7 @@ static void nfs4_lock_prepare(struct rpc_task *task, void *calldata)
 		data->arg.new_lock_owner = 1;
 	}
 	data->timestamp = jiffies;
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 out:
 	dprintk("%s: done!, ret = %d\n", __FUNCTION__, data->rpc_status);
 }
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index b5e2575..d4e7d09 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -68,7 +68,7 @@ static void nfs_async_unlink_init(struct rpc_task *task, void *calldata)
 
 	nfs_begin_data_update(dir);
 	NFS_PROTO(dir)->unlink_setup(&msg, dir);
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 /**
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 8ea077d..fed97e0 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -69,6 +69,7 @@ struct rpc_task {
 	void			(*tk_action)(struct rpc_task *);
 	const struct rpc_call_ops *tk_ops;
 	void *			tk_calldata;
+	struct cred *		tk_acred;
 
 	/*
 	 * tk_timer is used for async processing by the RPC scheduling
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 6d167f0..82a863c 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -152,7 +152,7 @@ static void rpcb_getport_prepare(struct rpc_task *task, void *calldata)
 		.rpc_resp	= &map->r_port,
 	};
 
-	rpc_call_setup(task, &msg, 0, current->cred);
+	rpc_call_setup(task, &msg, 0, task->tk_acred);
 }
 
 static void rpcb_map_release(void *data)
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 954d7ec..d9d4219 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -808,6 +808,8 @@ void rpc_free(void *buffer)
  */
 void rpc_init_task(struct rpc_task *task, struct rpc_clnt *clnt, int flags, const struct rpc_call_ops *tk_ops, void *calldata)
 {
+	struct cred *acred = current->cred;
+
 	memset(task, 0, sizeof(*task));
 	init_timer(&task->tk_timer);
 	task->tk_timer.data     = (unsigned long) task;
@@ -819,6 +821,7 @@ void rpc_init_task(struct rpc_task *task, struct rpc_clnt *clnt, int flags, cons
 	if (tk_ops->rpc_call_prepare != NULL)
 		task->tk_action = rpc_prepare_task;
 	task->tk_calldata = calldata;
+	task->tk_acred = get_cred(acred);
 	INIT_LIST_HEAD(&task->tk_task);
 
 	/* Initialize retry counters */
@@ -897,6 +900,7 @@ void rpc_put_task(struct rpc_task *task)
 		rpc_release_client(task->tk_client);
 		task->tk_client = NULL;
 	}
+	put_cred(task->tk_acred);
 	if (task->tk_flags & RPC_TASK_DYNAMIC)
 		call_rcu_bh(&task->u.tk_rcu, rpc_free_task);
 	rpc_release_calldata(tk_ops, calldata);

