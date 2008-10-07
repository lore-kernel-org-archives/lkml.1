Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYJGBBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYJGBBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbYJGAqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:05 -0400
Received: from ns.suse.de ([195.135.220.2]:47176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbYJGAqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:03 -0400
Date: Mon, 6 Oct 2008 17:40:05 -0700
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
Subject: [patch 59/71] udp: Fix rcv socket locking
Message-ID: <20081007004005.GH3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0009-udp-Fix-rcv-socket-locking.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 93821778def10ec1e69aa3ac10adee975dad4ff3 ]

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
 net/ipv4/udp.c |   59 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -950,6 +950,27 @@ int udp_disconnect(struct sock *sk, int 
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
@@ -988,9 +1009,7 @@ int udp_queue_rcv_skb(struct sock * sk, 
 		    up->encap_rcv != NULL) {
 			int ret;
 
-			bh_unlock_sock(sk);
 			ret = (*up->encap_rcv)(sk, skb);
-			bh_lock_sock(sk);
 			if (ret <= 0) {
 				UDP_INC_STATS_BH(UDP_MIB_INDATAGRAMS,
 						 is_udplite);
@@ -1042,14 +1061,16 @@ int udp_queue_rcv_skb(struct sock * sk, 
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
@@ -1087,15 +1108,7 @@ static int __udp4_lib_mcast_deliver(stru
 				skb1 = skb_clone(skb, GFP_ATOMIC);
 
 			if (skb1) {
-				int ret = 0;
-
-				bh_lock_sock(sk);
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
@@ -1188,13 +1201,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 			uh->dest, inet_iif(skb), udptable);
 
 	if (sk != NULL) {
-		int ret = 0;
-		bh_lock_sock(sk);
-		if (!sock_owned_by_user(sk))
-			ret = udp_queue_rcv_skb(sk, skb);
-		else
-			sk_add_backlog(sk, skb);
-		bh_unlock_sock(sk);
+		int ret = udp_queue_rcv_skb(sk, skb);
 		sock_put(sk);
 
 		/* a return value > 0 means to resubmit the input, but
@@ -1487,7 +1494,7 @@ struct proto udp_prot = {
 	.sendmsg	   = udp_sendmsg,
 	.recvmsg	   = udp_recvmsg,
 	.sendpage	   = udp_sendpage,
-	.backlog_rcv	   = udp_queue_rcv_skb,
+	.backlog_rcv	   = __udp_queue_rcv_skb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
 	.get_port	   = udp_v4_get_port,

-- 
