Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbXH0U3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbXH0U3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762133AbXH0UXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43397 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762076AbXH0UXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:23:13 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 11/15] knfsd: fix callback rpc cred
Date: Mon, 27 Aug 2007 16:22:52 -0400
Message-Id: <11882461773657-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <11882461773221-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
 <1188246177195-git-send-email-bfields@fieldses.org>
 <11882461773396-git-send-email-bfields@fieldses.org>
 <1188246177259-git-send-email-bfields@fieldses.org>
 <1188246177192-git-send-email-bfields@fieldses.org>
 <11882461773221-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@fieldses.org>

It doesn't make sense to make the callback with credentials that the
client made the setclientid with.  Instead the spec requires that the
callback occur with the credentials the client authenticated *to*.
It probably doesn't matter what we use for auth_unix, and some more
infrastructure will be needed for auth_gss, so let's just remove the
cred lookup for now.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4callback.c |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index c17a520..c1cb7e0 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -344,28 +344,6 @@ static struct rpc_version *	nfs_cb_version[] = {
 	&nfs_cb_version4,
 };
 
-/*
- * Use the SETCLIENTID credential
- */
-static struct rpc_cred *
-nfsd4_lookupcred(struct nfs4_client *clp, int taskflags)
-{
-        struct auth_cred acred;
-	struct rpc_clnt *clnt = clp->cl_callback.cb_client;
-	struct rpc_cred *ret;
-
-        get_group_info(clp->cl_cred.cr_group_info);
-        acred.uid = clp->cl_cred.cr_uid;
-        acred.gid = clp->cl_cred.cr_gid;
-        acred.group_info = clp->cl_cred.cr_group_info;
-
-        dprintk("NFSD:     looking up %s cred\n",
-                clnt->cl_auth->au_ops->au_name);
-        ret = rpcauth_lookup_credcache(clnt->cl_auth, &acred, taskflags);
-        put_group_info(clp->cl_cred.cr_group_info);
-        return ret;
-}
-
 /* Reference counting, callback cleanup, etc., all look racy as heck.
  * And why is cb_set an atomic? */
 
@@ -379,18 +357,13 @@ static int do_probe_callback(void *data)
 	};
 	int status;
 
-	msg.rpc_cred = nfsd4_lookupcred(clp, 0);
-	if (IS_ERR(msg.rpc_cred))
-		goto out;
 	status = rpc_call_sync(cb->cb_client, &msg, RPC_TASK_SOFT);
-	put_rpccred(msg.rpc_cred);
 
 	if (status) {
 		rpc_shutdown_client(cb->cb_client);
 		cb->cb_client = NULL;
 	} else
 		atomic_set(&cb->cb_set, 1);
-out:
 	put_nfs4_client(clp);
 	return 0;
 }
@@ -488,10 +461,6 @@ nfsd4_cb_recall(struct nfs4_delegation *dp)
 	if ((!atomic_read(&clp->cl_callback.cb_set)) || !clnt)
 		return;
 
-	msg.rpc_cred = nfsd4_lookupcred(clp, 0);
-	if (IS_ERR(msg.rpc_cred))
-		goto out;
-
 	cbr->cbr_trunc = 0; /* XXX need to implement truncate optimization */
 	cbr->cbr_dp = dp;
 
@@ -512,8 +481,6 @@ nfsd4_cb_recall(struct nfs4_delegation *dp)
 		status = rpc_call_sync(clnt, &msg, RPC_TASK_SOFT);
 	}
 out_put_cred:
-	put_rpccred(msg.rpc_cred);
-out:
 	if (status == -EIO)
 		atomic_set(&clp->cl_callback.cb_set, 0);
 	/* Success or failure, now we're either waiting for lease expiration
-- 
1.5.3.rc5.19.g0734d

