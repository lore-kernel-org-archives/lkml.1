Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZAFBNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZAFBNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZAFBNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:13:22 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50142 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbZAFBNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:13:20 -0500
Message-Id: <20090106011314.961946803@us.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 17:13:16 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
Content-Disposition: inline; filename=reenable-uts-ns-for-most-rpc-clients.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can often specify the UTS namespace to use when starting an RPC client.
However sometimes no UTS namespace is available (specifically during system
shutdown as the last NFS mount in a container is unmounted) so fall
back to the initial UTS namespace.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-nfs@vger.kernel.org
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.osdl.org>

---
 net/sunrpc/clnt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.28/net/sunrpc/clnt.c
===================================================================
--- linux-2.6.28.orig/net/sunrpc/clnt.c
+++ linux-2.6.28/net/sunrpc/clnt.c
@@ -128,6 +128,7 @@ static struct rpc_clnt * rpc_new_client(
 	struct rpc_version	*version;
 	struct rpc_clnt		*clnt = NULL;
 	struct rpc_auth		*auth;
+	struct new_utsname	*uts_ns = init_utsname();
 	int err;
 	size_t len;
 
@@ -213,10 +214,12 @@ static struct rpc_clnt * rpc_new_client(
 	}
 
 	/* save the nodename */
-	clnt->cl_nodelen = strlen(init_utsname()->nodename);
+	if (current->nsproxy != NULL)
+		uts_ns = utsname();
+	clnt->cl_nodelen = strlen(uts_ns->nodename);
 	if (clnt->cl_nodelen > UNX_MAXNODENAME)
 		clnt->cl_nodelen = UNX_MAXNODENAME;
-	memcpy(clnt->cl_nodename, init_utsname()->nodename, clnt->cl_nodelen);
+	memcpy(clnt->cl_nodename, uts_ns->nodename, clnt->cl_nodelen);
 	rpc_register_client(clnt);
 	return clnt;
 

-- 
