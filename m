Return-Path: <linux-kernel-owner+w=401wt.eu-S1766804AbXDSPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766804AbXDSPRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766811AbXDSPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:17:32 -0400
Received: from mx2.netapp.com ([216.240.18.37]:30611 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766804AbXDSPRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:17:31 -0400
X-IronPort-AV: i="4.14,428,1170662400"; 
   d="scan'208"; a="52641396:sNHT27111112"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: chuck.lever@oracle.com
Cc: Florin Iucha <florin@iucha.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <462786C9.7090405@oracle.com>
References: <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
	 <20070417211350.ebba1493.akpm@linux-foundation.org>
	 <20070418043040.GD24044@iucha.net>
	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070418123842.GF24044@iucha.net>
	 <1176902131.6796.62.camel@heimdal.trondhjem.org>
	 <20070418134225.GG24044@iucha.net>
	 <1176905506.6796.84.camel@heimdal.trondhjem.org>
	 <20070419015232.GO24044@iucha.net>
	 <1176950713.6422.95.camel@heimdal.trondhjem.org>
	 <462786C9.7090405@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 19 Apr 2007 11:17:28 -0400
Message-Id: <1176995848.6663.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Apr 2007 15:17:35.0676 (UTC) FILETIME=[DC0A77C0:01C78295]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 11:12 -0400, Chuck Lever wrote:
> Perhaps instead of looking at the number of bytes sent, the logic in the 
> last hunk of this patch should check which queue the request is sitting on.

??? It would be a bug for the request to be sitting on _any_ queue when
it enters xprt_transmit().

Here is the patch that I'm currently testing.

Cheers
  Trond
---------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 19 Apr 2007 09:55:44 -0400
RPC: Fix the TCP resend semantics for NFSv4

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
