Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYJFXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYJFXbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYJFXXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:23:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:55385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844AbYJFXXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:23:12 -0400
Date: Mon, 6 Oct 2008 16:18:01 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/28] udp: Fix rcv socket locking
Message-ID: <20081006231801.GC20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-udp-Fix-rcv-socket-locking.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commits d97106ea52aa57e63ff40d04479016836bbb5a4e and
   93821778def10ec1e69aa3ac10adee975dad4ff3 ]

The previous patch in response to the recursive locking on IPsec
reception is broken as it tries to drop the BH socket lock while in
user context.

This patch fixes it by shrinking the section protected by the
socket lock to sock_queue_rcv_skb only.  The only reason we added
the lock is for the accounting which happens in that function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |   57 +++++++++++++++++++++++++++++++++------------------------
 net/ipv6/udp.c |    6 +++---
 2 files changed, 36 insertions(+), 27 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -956,6 +956,27 @@ int udp_disconnect(struct sock *sk, int 
 	return 0;
 }
 
+static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	int is_udplite = IS_UDPLITE(sk);
+	int rc;
+
+	if ((rc = sock_queue_rcv_skb(sk, skb)) < 0) {
+		/* Note that an ENOMEM error is charged twice */
+		if (rc == -ENOMEM)
+			UDP_INC_STATS_BH(UDP_MIB_RCVBUFERRORS,
+					 is_udplite);
+		goto drop;
+	}
+
+	return 0;
+
+drop:
+	UDP_INC_STATS_BH(UDP_MIB_INERRORS, is_udplite);
+	kfree_skb(skb);
+	return -1;
+}
+
 /* returns:
  *  -1: error
  *   0: success
@@ -1046,14 +1067,16 @@ int udp_queue_rcv_skb(struct sock * sk, 
 			goto drop;
 	}
 
-	if ((rc = sock_queue_rcv_skb(sk,skb)) < 0) {
-		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
-			UDP_INC_STATS_BH(UDP_MIB_RCVBUFERRORS, is_udplite);
-		goto drop;
-	}
+	rc = 0;
 
-	return 0;
+	bh_lock_sock(sk);
+	if (!sock_owned_by_user(sk))
+		rc = __udp_queue_rcv_skb(sk, skb);
+	else
+		sk_add_backlog(sk, skb);
+	bh_unlock_sock(sk);
+
+	return rc;
 
 drop:
 	UDP_INC_STATS_BH(UDP_MIB_INERRORS, is_udplite);
@@ -1091,15 +1114,7 @@ static int __udp4_lib_mcast_deliver(stru
 				skb1 = skb_clone(skb, GFP_ATOMIC);
 
 			if (skb1) {
-				int ret = 0;
-
-				bh_lock_sock_nested(sk);
-				if (!sock_owned_by_user(sk))
-					ret = udp_queue_rcv_skb(sk, skb1);
-				else
-					sk_add_backlog(sk, skb1);
-				bh_unlock_sock(sk);
-
+				int ret = udp_queue_rcv_skb(sk, skb1);
 				if (ret > 0)
 					/* we should probably re-process instead
 					 * of dropping packets here. */
@@ -1192,13 +1207,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 			uh->dest, inet_iif(skb), udptable);
 
 	if (sk != NULL) {
-		int ret = 0;
-		bh_lock_sock_nested(sk);
-		if (!sock_owned_by_user(sk))
-			ret = udp_queue_rcv_skb(sk, skb);
-		else
-			sk_add_backlog(sk, skb);
-		bh_unlock_sock(sk);
+		int ret = udp_queue_rcv_skb(sk, skb);
 		sock_put(sk);
 
 		/* a return value > 0 means to resubmit the input, but
@@ -1493,7 +1502,7 @@ struct proto udp_prot = {
 	.sendmsg	   = udp_sendmsg,
 	.recvmsg	   = udp_recvmsg,
 	.sendpage	   = udp_sendpage,
-	.backlog_rcv	   = udp_queue_rcv_skb,
+	.backlog_rcv	   = __udp_queue_rcv_skb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
 	.get_port	   = udp_v4_get_port,
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -373,7 +373,7 @@ static int __udp6_lib_mcast_deliver(stru
 					uh->source, saddr, dif))) {
 		struct sk_buff *buff = skb_clone(skb, GFP_ATOMIC);
 		if (buff) {
-			bh_lock_sock_nested(sk2);
+			bh_lock_sock(sk2);
 			if (!sock_owned_by_user(sk2))
 				udpv6_queue_rcv_skb(sk2, buff);
 			else
@@ -381,7 +381,7 @@ static int __udp6_lib_mcast_deliver(stru
 			bh_unlock_sock(sk2);
 		}
 	}
-	bh_lock_sock_nested(sk);
+	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
 	else
@@ -499,7 +499,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, 
 
 	/* deliver */
 
-	bh_lock_sock_nested(sk);
+	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
 	else

-- 
