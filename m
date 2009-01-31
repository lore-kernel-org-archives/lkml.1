Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZAaCvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZAaCvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZAaCqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:47 -0500
Received: from kroah.org ([198.145.64.141]:54838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697AbZAaCqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:45 -0500
Date: Fri, 30 Jan 2009 18:40:09 -0800
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
Subject: [patch 13/32] SUNRPC: Fix a memory leak in rpcb_getport_async
Message-ID: <20090131024009.GN12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sunrpc-fix-a-memory-leak-in-rpcb_getport_async.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 96165e2b7c4e2c82a0b60c766d4a2036444c21a0 upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/rpcb_clnt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -558,7 +558,7 @@ void rpcb_getport_async(struct rpc_task 
 		status = -ENOMEM;
 		dprintk("RPC: %5u %s: no memory available\n",
 			task->tk_pid, __func__);
-		goto bailout_nofree;
+		goto bailout_release_client;
 	}
 	map->r_prog = clnt->cl_prog;
 	map->r_vers = clnt->cl_vers;
@@ -583,6 +583,8 @@ void rpcb_getport_async(struct rpc_task 
 	task->tk_xprt->stat.bind_count++;
 	return;
 
+bailout_release_client:
+	rpc_release_client(rpcb_clnt);
 bailout_nofree:
 	rpcb_wake_rpcbind_waiters(xprt, status);
 	task->tk_status = status;

