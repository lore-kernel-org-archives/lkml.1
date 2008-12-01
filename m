Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYLAASw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYLAASw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYLAASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:18:43 -0500
Received: from mx2.netapp.com ([216.240.18.37]:56643 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbYLAASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:18:42 -0500
X-IronPort-AV: E=Sophos;i="4.33,691,1220252400"; 
   d="scan'208";a="93037842"
Subject: Re: [PATCH 1/3] SUNRPC: Ensure the server closes sockets in a
 timely fashion
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228090631.7112.11.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Sun, 30 Nov 2008 19:18:39 -0500
Message-Id: <1228090719.7112.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 01 Dec 2008 00:18:41.0706 (UTC) FILETIME=[5D6FC0A0:01C9534A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to ensure that connected sockets close down the connection when we
set XPT_CLOSE, so that we don't keep it hanging while cleaning up all the
stuff that is keeping a reference to the socket.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/svcsock.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)


diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 95293f5..a1b048d 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -59,6 +59,7 @@ static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
 static void		svc_sock_detach(struct svc_xprt *);
+static void		svc_tcp_sock_detach(struct svc_xprt *);
 static void		svc_sock_free(struct svc_xprt *);
 
 static struct svc_xprt *svc_create_socket(struct svc_serv *, int,
@@ -1017,7 +1018,7 @@ static struct svc_xprt_ops svc_tcp_ops = {
 	.xpo_recvfrom = svc_tcp_recvfrom,
 	.xpo_sendto = svc_tcp_sendto,
 	.xpo_release_rqst = svc_release_skb,
-	.xpo_detach = svc_sock_detach,
+	.xpo_detach = svc_tcp_sock_detach,
 	.xpo_free = svc_sock_free,
 	.xpo_prep_reply_hdr = svc_tcp_prep_reply_hdr,
 	.xpo_has_wspace = svc_tcp_has_wspace,
@@ -1282,6 +1283,24 @@ static void svc_sock_detach(struct svc_xprt *xprt)
 	sk->sk_state_change = svsk->sk_ostate;
 	sk->sk_data_ready = svsk->sk_odata;
 	sk->sk_write_space = svsk->sk_owspace;
+
+	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
+		wake_up_interruptible(sk->sk_sleep);
+}
+
+/*
+ * Disconnect the socket, and reset the callbacks
+ */
+static void svc_tcp_sock_detach(struct svc_xprt *xprt)
+{
+	struct svc_sock *svsk = container_of(xprt, struct svc_sock, sk_xprt);
+
+	dprintk("svc: svc_tcp_sock_detach(%p)\n", svsk);
+
+	svc_sock_detach(xprt);
+
+	if (!test_bit(XPT_LISTENER, &xprt->xpt_flags))
+		kernel_sock_shutdown(svsk->sk_sock, SHUT_RDWR);
 }
 
 /*

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
