Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0BSRNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:13:15 -0500
Received: from kroah.org ([198.145.64.141]:57509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0BSRAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:33 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:40 2010
Message-Id: <20100219163240.173542201@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [34/93] NFSv4: Ensure that the NFSv4 locking can recover from stateid errors
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2bee72a6aa1e6d0a4f5da56217f0d0bbbdd0d9a3 upstream.

In most cases, we just want to mark the lock_stateid sequence id as being
uninitialised.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4proc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3978,6 +3978,22 @@ static const struct rpc_call_ops nfs4_lo
 	.rpc_release = nfs4_lock_release,
 };
 
+static void nfs4_handle_setlk_error(struct nfs_server *server, struct nfs4_lock_state *lsp, int new_lock_owner, int error)
+{
+	struct nfs_client *clp = server->nfs_client;
+	struct nfs4_state *state = lsp->ls_state;
+
+	switch (error) {
+	case -NFS4ERR_ADMIN_REVOKED:
+	case -NFS4ERR_BAD_STATEID:
+	case -NFS4ERR_EXPIRED:
+		if (new_lock_owner != 0 ||
+		   (lsp->ls_flags & NFS_LOCK_INITIALIZED) != 0)
+			nfs4_state_mark_reclaim_nograce(clp, state);
+		lsp->ls_seqid.flags &= ~NFS_SEQID_CONFIRMED;
+	};
+}
+
 static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *fl, int reclaim)
 {
 	struct nfs4_lockdata *data;
@@ -4013,6 +4029,9 @@ static int _nfs4_do_setlk(struct nfs4_st
 	ret = nfs4_wait_for_completion_rpc_task(task);
 	if (ret == 0) {
 		ret = data->rpc_status;
+		if (ret)
+			nfs4_handle_setlk_error(data->server, data->lsp,
+					data->arg.new_lock_owner, ret);
 	} else
 		data->cancelled = 1;
 	rpc_put_task(task);


