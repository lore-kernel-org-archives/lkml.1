Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXBLXop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXBLXop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030509AbXBLXoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:44:44 -0500
Received: from ns.suse.de ([195.135.220.2]:53310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbXBLXoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:44:44 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:44:02 +1100
Message-Id: <1070212234402.29224@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 9] knfsd: nfsd4: fix non-terminated string
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>
The server name is expected to be a null-terminated string, so we can't
pass in the raw client identifier.

What's more, the client identifier is just a binary, not necessarily
printable, blob.  Let's just use the ip address instead.  The server
name appears to exist just to help debugging by making some printk's
more informative.

Note that the string is copies into the rpc client structure, so
the pointer to the local variable does not outlive the function call.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4callback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff .prev/fs/nfsd/nfs4callback.c ./fs/nfsd/nfs4callback.c
--- .prev/fs/nfsd/nfs4callback.c	2007-02-13 09:50:26.000000000 +1100
+++ ./fs/nfsd/nfs4callback.c	2007-02-13 10:00:59.000000000 +1100
@@ -387,7 +387,6 @@ nfsd4_probe_callback(struct nfs4_client 
 		.address	= (struct sockaddr *)&addr,
 		.addrsize	= sizeof(addr),
 		.timeout	= &timeparms,
-		.servername	= clp->cl_name.data,
 		.program	= program,
 		.version	= nfs_cb_version[1]->number,
 		.authflavor	= RPC_AUTH_UNIX,	/* XXX: need AUTH_GSS... */
@@ -397,6 +396,7 @@ nfsd4_probe_callback(struct nfs4_client 
 		.rpc_proc       = &nfs4_cb_procedures[NFSPROC4_CLNT_CB_NULL],
 		.rpc_argp       = clp,
 	};
+	char clientname[16];
 	int status;
 
 	if (atomic_read(&cb->cb_set))
@@ -419,6 +419,11 @@ nfsd4_probe_callback(struct nfs4_client 
 	memset(program->stats, 0, sizeof(cb->cb_stat));
 	program->stats->program = program;
 
+	/* Just here to make some printk's more useful: */
+	snprintf(clientname, sizeof(clientname),
+		"%u.%u.%u.%u", NIPQUAD(addr.sin_addr));
+	args.servername = clientname;
+
 	/* Create RPC client */
 	cb->cb_client = rpc_create(&args);
 	if (IS_ERR(cb->cb_client)) {
