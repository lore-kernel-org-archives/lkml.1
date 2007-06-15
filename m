Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXFOVpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXFOVpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbXFOVpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:45:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36339 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755907AbXFOVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:45:05 -0400
Date: Fri, 15 Jun 2007 23:45:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC: 2.6 patch] net/rxrpc/ar-output.c: remove dead code
Message-ID: <20070615214520.GM3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 net/rxrpc/ar-output.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- linux-2.6.22-rc4-mm2/net/rxrpc/ar-output.c.old	2007-06-15 21:38:02.000000000 +0200
+++ linux-2.6.22-rc4-mm2/net/rxrpc/ar-output.c	2007-06-15 21:38:47.000000000 +0200
@@ -530,7 +530,7 @@ static int rxrpc_send_data(struct kiocb 
 	struct sock *sk = &rx->sk;
 	long timeo;
 	bool more;
-	int ret, ioc, segment, copied;
+	int ret, ioc, segment;
 
 	_enter(",,,{%zu},%zu", msg->msg_iovlen, len);
 
@@ -552,7 +552,6 @@ static int rxrpc_send_data(struct kiocb 
 	skb = call->tx_pending;
 	call->tx_pending = NULL;
 
-	copied = 0;
 	do {
 		int copy;
 
@@ -570,11 +569,11 @@ static int rxrpc_send_data(struct kiocb 
 				       call->acks_winsz) <= 0) {
 				ret = -EAGAIN;
 				if (msg->msg_flags & MSG_DONTWAIT)
-					goto maybe_error;
+					goto out;
 				ret = rxrpc_wait_for_tx_window(rx, call,
 							       &timeo);
 				if (ret < 0)
-					goto maybe_error;
+					goto out;
 			}
 
 			max = call->conn->trans->peer->maxdata;
@@ -596,7 +595,7 @@ static int rxrpc_send_data(struct kiocb 
 			skb = sock_alloc_send_skb(
 				sk, size, msg->msg_flags & MSG_DONTWAIT, &ret);
 			if (!skb)
-				goto maybe_error;
+				goto out;
 
 			rxrpc_new_skb(skb);
 
@@ -723,11 +722,6 @@ call_aborted:
 	_leave(" = %d", ret);
 	return ret;
 
-maybe_error:
-	if (copied)
-		ret = copied;
-	goto out;
-
 efault:
 	ret = -EFAULT;
 	goto out;
