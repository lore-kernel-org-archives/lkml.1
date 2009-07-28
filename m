Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZG1XEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZG1XEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZG1XEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:05 -0400
Received: from kroah.org ([198.145.64.141]:43014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbZG1XED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.172813639@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 22/37] SUNRPC: Ensure we set XPRT_CLOSING only after weve sent a tcp FIN...
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=sunrpc-ensure-we-set-xprt_closing-only-after-we-ve-sent-a-tcp-fin.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 670f94573104b4a25525d3fcdcd6496c678df172 upstream.

...so that we can distinguish between when we need to shutdown and when we
don't. Also remove the call to xs_tcp_shutdown() from xs_tcp_connect(),
since xprt_connect() makes the same test.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1150,7 +1150,6 @@ static void xs_tcp_state_change(struct s
 		break;
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
-		set_bit(XPRT_CLOSING, &xprt->state);
 		xprt_force_disconnect(xprt);
 	case TCP_SYN_SENT:
 		xprt->connect_cookie++;
@@ -1163,6 +1162,7 @@ static void xs_tcp_state_change(struct s
 			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
 		break;
 	case TCP_LAST_ACK:
+		set_bit(XPRT_CLOSING, &xprt->state);
 		smp_mb__before_clear_bit();
 		clear_bit(XPRT_CONNECTED, &xprt->state);
 		smp_mb__after_clear_bit();
@@ -1780,9 +1780,6 @@ static void xs_tcp_connect(struct rpc_ta
 {
 	struct rpc_xprt *xprt = task->tk_xprt;
 
-	/* Initiate graceful shutdown of the socket if not already done */
-	if (test_bit(XPRT_CONNECTED, &xprt->state))
-		xs_tcp_shutdown(xprt);
 	/* Exit if we need to wait for socket shutdown to complete */
 	if (test_bit(XPRT_CLOSING, &xprt->state))
 		return;


