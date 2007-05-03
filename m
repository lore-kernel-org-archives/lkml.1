Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXECJxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXECJxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031072AbXECJxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:53:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031017AbXECJxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:53:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] [NETLINK]: Fix use after free in netlink_recvmsg
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net, dhowells@redhat.com
Date: Thu, 03 May 2007 10:53:15 +0100
Message-ID: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the user passes in MSG_TRUNC the skb is used after getting freed.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/netlink/af_netlink.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 42d2fb9..7419f70 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1245,16 +1245,14 @@ static int netlink_recvmsg(struct kiocb *kiocb, struct socket *sock,
 		siocb->scm = &scm;
 	}
 	siocb->scm->creds = *NETLINK_CREDS(skb);
+	if (flags & MSG_TRUNC)
+		copied = skb->len;
 	skb_free_datagram(sk, skb);
 
 	if (nlk->cb && atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2)
 		netlink_dump(sk);
 
 	scm_recv(sock, msg, siocb->scm, flags);
-
-	if (flags & MSG_TRUNC)
-		copied = skb->len;
-
 out:
 	netlink_rcv_wake(sk);
 	return err ? : copied;

