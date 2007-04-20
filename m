Return-Path: <linux-kernel-owner+w=401wt.eu-S1767248AbXDTUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767248AbXDTUe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767247AbXDTUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:34:17 -0400
Received: from dh166.citi.umich.edu ([141.211.133.166]:47389 "EHLO
	heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767249AbXDTUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:34:10 -0400
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 5/5] RPC: Fix the TCP resend semantics for NFSv4
Date: Fri, 20 Apr 2007 16:12:55 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Chuck Lever <chuck.lever@oracle.com>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Message-Id: <20070420201255.7897.84317.stgit@heimdal.trondhjem.org>
In-Reply-To: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
References: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Fix a regression due to the patch "NFS: disconnect before retrying NFSv4
requests over TCP"

The assumption made in xprt_transmit() that the condition
	"req->rq_bytes_sent == 0 and request is on the receive list"
should imply that we're dealing with a retransmission is false.
Firstly, it may simply happen that the socket send queue was full
at the time the request was initially sent through xprt_transmit().
Secondly, doing this for each request that was retransmitted implies
that we disconnect and reconnect for _every_ request that happened to
be retransmitted irrespective of whether or not a disconnection has
already occurred.

Fix is to move this logic into the call_status request timeout handler.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/clnt.c |    4 ++++
 net/sunrpc/xprt.c |   10 ----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6d7221f..396cdbe 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1046,6 +1046,8 @@ call_status(struct rpc_task *task)
 		rpc_delay(task, 3*HZ);
 	case -ETIMEDOUT:
 		task->tk_action = call_timeout;
+		if (task->tk_client->cl_discrtry)
+			xprt_disconnect(task->tk_xprt);
 		break;
 	case -ECONNREFUSED:
 	case -ENOTCONN:
@@ -1169,6 +1171,8 @@ call_decode(struct rpc_task *task)
 out_retry:
 	req->rq_received = req->rq_private_buf.len = 0;
 	task->tk_status = 0;
+	if (task->tk_client->cl_discrtry)
+		xprt_disconnect(task->tk_xprt);
 }
 
 /*
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index ee6ffa0..456a145 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -735,16 +735,6 @@ void xprt_transmit(struct rpc_task *task)
 			xprt_reset_majortimeo(req);
 			/* Turn off autodisconnect */
 			del_singleshot_timer_sync(&xprt->timer);
-		} else {
-			/* If all request bytes have been sent,
-			 * then we must be retransmitting this one */
-			if (!req->rq_bytes_sent) {
-				if (task->tk_client->cl_discrtry) {
-					xprt_disconnect(xprt);
-					task->tk_status = -ENOTCONN;
-					return;
-				}
-			}
 		}
 	} else if (!req->rq_bytes_sent)
 		return;
