Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYICRll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYICRll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYICRlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:41:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbYICRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:41:05 -0400
Date: Wed, 3 Sep 2008 10:26:15 -0700
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
Subject: [patch 25/42] udp: Drop socket lock for encapsulated packets
Message-ID: <20080903172615.GZ7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-udp-Drop-socket-lock-for-encapsulated-packets.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit d97106ea52aa57e63ff40d04479016836bbb5a4e ]

The socket lock is there to protect the normal UDP receive path.
Encapsulation UDP sockets don't need that protection.  In fact
the locking is deadly for them as they may contain another UDP
packet within, possibly with the same addresses.

Also the nested bit was copied from TCP.  TCP needs it because
of accept(2) spawning sockets.  This simply doesn't apply to UDP
so I've removed it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |    6 ++++--
 net/ipv6/udp.c |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -988,7 +988,9 @@ int udp_queue_rcv_skb(struct sock * sk, 
 		    up->encap_rcv != NULL) {
 			int ret;
 
+			bh_unlock_sock(sk);
 			ret = (*up->encap_rcv)(sk, skb);
+			bh_lock_sock(sk);
 			if (ret <= 0) {
 				UDP_INC_STATS_BH(UDP_MIB_INDATAGRAMS,
 						 is_udplite);
@@ -1087,7 +1089,7 @@ static int __udp4_lib_mcast_deliver(stru
 			if (skb1) {
 				int ret = 0;
 
-				bh_lock_sock_nested(sk);
+				bh_lock_sock(sk);
 				if (!sock_owned_by_user(sk))
 					ret = udp_queue_rcv_skb(sk, skb1);
 				else
@@ -1187,7 +1189,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 
 	if (sk != NULL) {
 		int ret = 0;
-		bh_lock_sock_nested(sk);
+		bh_lock_sock(sk);
 		if (!sock_owned_by_user(sk))
 			ret = udp_queue_rcv_skb(sk, skb);
 		else
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -376,7 +376,7 @@ static int __udp6_lib_mcast_deliver(stru
 					uh->source, saddr, dif))) {
 		struct sk_buff *buff = skb_clone(skb, GFP_ATOMIC);
 		if (buff) {
-			bh_lock_sock_nested(sk2);
+			bh_lock_sock(sk2);
 			if (!sock_owned_by_user(sk2))
 				udpv6_queue_rcv_skb(sk2, buff);
 			else
@@ -384,7 +384,7 @@ static int __udp6_lib_mcast_deliver(stru
 			bh_unlock_sock(sk2);
 		}
 	}
-	bh_lock_sock_nested(sk);
+	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
 	else
@@ -502,7 +502,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, 
 
 	/* deliver */
 
-	bh_lock_sock_nested(sk);
+	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk))
 		udpv6_queue_rcv_skb(sk, skb);
 	else

-- 
