Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbZAaCv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbZAaCv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZAaCqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:48 -0500
Received: from kroah.org ([198.145.64.141]:54848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754747AbZAaCqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:46 -0500
Date: Fri, 30 Jan 2009 18:40:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 14/32] SUNRPC: Fix autobind on cloned rpc clients
Message-ID: <20090131024011.GO12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sunrpc-fix-autobind-on-cloned-rpc-clients.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9a4bd29fe8f6d3f015fe1c8e5450eb62cfebfcc9 upstream.

Despite the fact that cloned rpc clients won't have the cl_autobind flag
set, they may still find themselves calling rpcb_getport_async(). For this
to happen, it suffices for a _parent_ rpc_clnt to use autobinding, in which
case any clone may find itself triggering the !xprt_bound() case in
call_bind().

The correct fix for this is to walk back up the tree of cloned rpc clients,
in order to find the parent that 'owns' the transport, either because it
has clnt->cl_autobind set, or because it originally created the
transport...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/rpcb_clnt.c |   36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -469,6 +469,28 @@ static struct rpc_task *rpcb_call_async(
 	return rpc_run_task(&task_setup_data);
 }
 
+/*
+ * In the case where rpc clients have been cloned, we want to make
+ * sure that we use the program number/version etc of the actual
+ * owner of the xprt. To do so, we walk back up the tree of parents
+ * to find whoever created the transport and/or whoever has the
+ * autobind flag set.
+ */
+static struct rpc_clnt *rpcb_find_transport_owner(struct rpc_clnt *clnt)
+{
+	struct rpc_clnt *parent = clnt->cl_parent;
+
+	while (parent != clnt) {
+		if (parent->cl_xprt != clnt->cl_xprt)
+			break;
+		if (clnt->cl_autobind)
+			break;
+		clnt = parent;
+		parent = parent->cl_parent;
+	}
+	return clnt;
+}
+
 /**
  * rpcb_getport_async - obtain the port for a given RPC service on a given host
  * @task: task that is waiting for portmapper request
@@ -478,10 +500,10 @@ static struct rpc_task *rpcb_call_async(
  */
 void rpcb_getport_async(struct rpc_task *task)
 {
-	struct rpc_clnt *clnt = task->tk_client;
+	struct rpc_clnt *clnt;
 	struct rpc_procinfo *proc;
 	u32 bind_version;
-	struct rpc_xprt *xprt = task->tk_xprt;
+	struct rpc_xprt *xprt;
 	struct rpc_clnt	*rpcb_clnt;
 	static struct rpcbind_args *map;
 	struct rpc_task	*child;
@@ -490,13 +512,13 @@ void rpcb_getport_async(struct rpc_task 
 	size_t salen;
 	int status;
 
+	clnt = rpcb_find_transport_owner(task->tk_client);
+	xprt = clnt->cl_xprt;
+
 	dprintk("RPC: %5u %s(%s, %u, %u, %d)\n",
 		task->tk_pid, __func__,
 		clnt->cl_server, clnt->cl_prog, clnt->cl_vers, xprt->prot);
 
-	/* Autobind on cloned rpc clients is discouraged */
-	BUG_ON(clnt->cl_parent != clnt);
-
 	/* Put self on the wait queue to ensure we get notified if
 	 * some other task is already attempting to bind the port */
 	rpc_sleep_on(&xprt->binding, task, NULL);
@@ -578,9 +600,9 @@ void rpcb_getport_async(struct rpc_task 
 			task->tk_pid, __func__);
 		return;
 	}
-	rpc_put_task(child);
 
-	task->tk_xprt->stat.bind_count++;
+	xprt->stat.bind_count++;
+	rpc_put_task(child);
 	return;
 
 bailout_release_client:

