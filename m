Return-Path: <linux-kernel-owner+w=401wt.eu-S1422931AbXCGR2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931AbXCGR2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422887AbXCGRRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:50 -0500
Received: from ns1.suse.de ([195.135.220.2]:44301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422894AbXCGRRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:39 -0500
Message-Id: <20070307171601.477163034@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, kas@fi.muni.cz,
       Trond.Myklebust@netapp.com, Andrew Morton <akpm@osdl.org>
Subject: [patch 080/101] NLM: Fix double free in __nlm_async_call
Content-Disposition: inline; filename=nlm-fix-double-free-in-__nlm_async_call.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Trond Myklebust <Trond.Myklebust@netapp.com>

rpc_call_async() will always call rpc_release_calldata(), so it is an
error for __nlm_async_call() to do so as well.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=7923

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/lockd/clntproc.c |    9 +++------
 fs/lockd/svclock.c  |    4 +---
 2 files changed, 4 insertions(+), 9 deletions(-)

--- linux-2.6.20.1.orig/fs/lockd/clntproc.c
+++ linux-2.6.20.1/fs/lockd/clntproc.c
@@ -361,7 +361,6 @@ static int __nlm_async_call(struct nlm_r
 {
 	struct nlm_host	*host = req->a_host;
 	struct rpc_clnt	*clnt;
-	int status = -ENOLCK;
 
 	dprintk("lockd: call procedure %d on %s (async)\n",
 			(int)proc, host->h_name);
@@ -373,12 +372,10 @@ static int __nlm_async_call(struct nlm_r
 	msg->rpc_proc = &clnt->cl_procinfo[proc];
 
         /* bootstrap and kick off the async RPC call */
-        status = rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req);
-	if (status == 0)
-		return 0;
+        return rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req);
 out_err:
-	nlm_release_call(req);
-	return status;
+	tk_ops->rpc_release(req);
+	return -ENOLCK;
 }
 
 int nlm_async_call(struct nlm_rqst *req, u32 proc, const struct rpc_call_ops *tk_ops)
--- linux-2.6.20.1.orig/fs/lockd/svclock.c
+++ linux-2.6.20.1/fs/lockd/svclock.c
@@ -593,9 +593,7 @@ callback:
 
 	/* Call the client */
 	kref_get(&block->b_count);
-	if (nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG,
-						&nlmsvc_grant_ops) < 0)
-		nlmsvc_release_block(block);
+	nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG, &nlmsvc_grant_ops);
 }
 
 /*

--
