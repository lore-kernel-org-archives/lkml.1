Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZG1XEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZG1XEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZG1XEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:06 -0400
Received: from kroah.org ([198.145.64.141]:43018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZG1XEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:44 2009
Message-Id: <20090728225944.343281729@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 23/37] SUNRPC: Dont disconnect if a connection is still in progress.
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=sunrpc-don-t-disconnect-if-a-connection-is-still-in-progress.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 40d2549db5f515e415894def98b49db7d4c56714 upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1560,10 +1560,9 @@ out:
  * We need to preserve the port number so the reply cache on the server can
  * find our cached RPC replies when we get around to reconnecting.
  */
-static void xs_tcp_reuse_connection(struct rpc_xprt *xprt)
+static void xs_abort_connection(struct rpc_xprt *xprt, struct sock_xprt *transport)
 {
 	int result;
-	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct sockaddr any;
 
 	dprintk("RPC:       disconnecting xprt %p to reuse port\n", xprt);
@@ -1580,6 +1579,17 @@ static void xs_tcp_reuse_connection(stru
 				result);
 }
 
+static void xs_tcp_reuse_connection(struct rpc_xprt *xprt, struct sock_xprt *transport)
+{
+	unsigned int state = transport->inet->sk_state;
+
+	if (state == TCP_CLOSE && transport->sock->state == SS_UNCONNECTED)
+		return;
+	if ((1 << state) & (TCPF_ESTABLISHED|TCPF_SYN_SENT))
+		return;
+	xs_abort_connection(xprt, transport);
+}
+
 static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
@@ -1650,7 +1660,7 @@ static void xs_tcp_connect_worker4(struc
 		}
 	} else
 		/* "close" the socket, preserving the local port */
-		xs_tcp_reuse_connection(xprt);
+		xs_tcp_reuse_connection(xprt, transport);
 
 	dprintk("RPC:       worker connecting xprt %p to address: %s\n",
 			xprt, xprt->address_strings[RPC_DISPLAY_ALL]);
@@ -1710,7 +1720,7 @@ static void xs_tcp_connect_worker6(struc
 		}
 	} else
 		/* "close" the socket, preserving the local port */
-		xs_tcp_reuse_connection(xprt);
+		xs_tcp_reuse_connection(xprt, transport);
 
 	dprintk("RPC:       worker connecting xprt %p to address: %s\n",
 			xprt, xprt->address_strings[RPC_DISPLAY_ALL]);


