Return-Path: <linux-kernel-owner+w=401wt.eu-S1946292AbXBCCne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946292AbXBCCne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946283AbXBCCnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:17 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53523 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946281AbXBCCnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:06 -0500
Message-Id: <20070203024716.734895000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:36:01 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 57/59] SUNRPC: Give cloned RPC clients their own rpc_pipefs directory
Content-Disposition: inline; filename=sunrpc-give-cloned-rpc-clients-their-own-rpc_pipefs-directory.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

This patch fixes a regression in 2.6.19 in which the use of multiple
krb5 mounts against the same NFS server may result in an Oops on
unmount. The Oops is due to the fact that multiple NFS krb5 clients may
end up inadvertently sharing the same rpc_pipefs upcall pipe. The first
client to 'umount' will unlink that shared pipe, causing an Oops.

The solution is to give each client their own upcall pipe. This fix has
been in mainline since 2.6.20-rc1.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[chrisw: backport to 2.6.19.2]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/sunrpc/clnt.h |    1 +
 net/sunrpc/clnt.c           |   26 +++++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

--- linux-2.6.19.2.orig/include/linux/sunrpc/clnt.h
+++ linux-2.6.19.2/include/linux/sunrpc/clnt.h
@@ -53,6 +53,7 @@ struct rpc_clnt {
 	struct dentry *		cl_dentry;	/* inode */
 	struct rpc_clnt *	cl_parent;	/* Points to parent of clones */
 	struct rpc_rtt		cl_rtt_default;
+	struct rpc_program *	cl_program;
 	char			cl_inline_name[32];
 };
 
--- linux-2.6.19.2.orig/net/sunrpc/clnt.c
+++ linux-2.6.19.2/net/sunrpc/clnt.c
@@ -141,6 +141,7 @@ static struct rpc_clnt * rpc_new_client(
 	clnt->cl_vers     = version->number;
 	clnt->cl_stats    = program->stats;
 	clnt->cl_metrics  = rpc_alloc_iostats(clnt);
+	clnt->cl_program  = program;
 
 	if (!xprt_bound(clnt->cl_xprt))
 		clnt->cl_autobind = 1;
@@ -252,6 +253,7 @@ struct rpc_clnt *
 rpc_clone_client(struct rpc_clnt *clnt)
 {
 	struct rpc_clnt *new;
+	int err = -ENOMEM;
 
 	new = kmalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
@@ -259,6 +261,10 @@ rpc_clone_client(struct rpc_clnt *clnt)
 	memcpy(new, clnt, sizeof(*new));
 	atomic_set(&new->cl_count, 1);
 	atomic_set(&new->cl_users, 0);
+	new->cl_metrics = rpc_alloc_iostats(clnt);
+	err = rpc_setup_pipedir(new, clnt->cl_program->pipe_dir_name);
+	if (err != 0)
+		goto out_no_path;
 	new->cl_parent = clnt;
 	atomic_inc(&clnt->cl_count);
 	new->cl_xprt = xprt_get(clnt->cl_xprt);
@@ -266,16 +272,16 @@ rpc_clone_client(struct rpc_clnt *clnt)
 	new->cl_autobind = 0;
 	new->cl_oneshot = 0;
 	new->cl_dead = 0;
-	if (!IS_ERR(new->cl_dentry))
-		dget(new->cl_dentry);
 	rpc_init_rtt(&new->cl_rtt_default, clnt->cl_xprt->timeout.to_initval);
 	if (new->cl_auth)
 		atomic_inc(&new->cl_auth->au_count);
-	new->cl_metrics = rpc_alloc_iostats(clnt);
 	return new;
+out_no_path:
+	rpc_free_iostats(new->cl_metrics);
+	kfree(new);
 out_no_clnt:
-	printk(KERN_INFO "RPC: out of memory in %s\n", __FUNCTION__);
-	return ERR_PTR(-ENOMEM);
+	dprintk("RPC: %s returned error %d\n", __FUNCTION__, err);
+	return ERR_PTR(err);
 }
 
 /*
@@ -328,16 +334,14 @@ rpc_destroy_client(struct rpc_clnt *clnt
 		rpcauth_destroy(clnt->cl_auth);
 		clnt->cl_auth = NULL;
 	}
-	if (clnt->cl_parent != clnt) {
-		if (!IS_ERR(clnt->cl_dentry))
-			dput(clnt->cl_dentry);
-		rpc_destroy_client(clnt->cl_parent);
-		goto out_free;
-	}
 	if (!IS_ERR(clnt->cl_dentry)) {
 		rpc_rmdir(clnt->cl_dentry);
 		rpc_put_mount();
 	}
+	if (clnt->cl_parent != clnt) {
+		rpc_destroy_client(clnt->cl_parent);
+		goto out_free;
+	}
 	if (clnt->cl_server != clnt->cl_inline_name)
 		kfree(clnt->cl_server);
 out_free:

--
