Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYLKTUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYLKTUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbYLKTSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:10 -0500
Received: from kroah.org ([198.145.64.141]:55855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756531AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:42 -0800
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
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/83] udp: multicast packets need to check namespace
Message-ID: <20081211191342.GF5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-udp-multicast-packets-need-to-check-namespace.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit 920a46115ca3fa88990276d98520abab85495b2d ]

Current UDP multicast delivery is not namespace aware.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |   12 +++++++-----
 net/ipv6/udp.c |    8 ++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -302,7 +302,7 @@ static struct sock *__udp4_lib_lookup(st
 	return result;
 }
 
-static inline struct sock *udp_v4_mcast_next(struct sock *sk,
+static inline struct sock *udp_v4_mcast_next(struct net *net, struct sock *sk,
 					     __be16 loc_port, __be32 loc_addr,
 					     __be16 rmt_port, __be32 rmt_addr,
 					     int dif)
@@ -314,7 +314,8 @@ static inline struct sock *udp_v4_mcast_
 	sk_for_each_from(s, node) {
 		struct inet_sock *inet = inet_sk(s);
 
-		if (s->sk_hash != hnum					||
+		if (!net_eq(sock_net(s), net)				||
+		    s->sk_hash != hnum					||
 		    (inet->daddr && inet->daddr != rmt_addr)		||
 		    (inet->dport != rmt_port && inet->dport)		||
 		    (inet->rcv_saddr && inet->rcv_saddr != loc_addr)	||
@@ -1097,15 +1098,16 @@ static int __udp4_lib_mcast_deliver(stru
 	read_lock(&udp_hash_lock);
 	sk = sk_head(&udptable[udp_hashfn(net, ntohs(uh->dest))]);
 	dif = skb->dev->ifindex;
-	sk = udp_v4_mcast_next(sk, uh->dest, daddr, uh->source, saddr, dif);
+	sk = udp_v4_mcast_next(net, sk, uh->dest, daddr, uh->source, saddr, dif);
 	if (sk) {
 		struct sock *sknext = NULL;
 
 		do {
 			struct sk_buff *skb1 = skb;
 
-			sknext = udp_v4_mcast_next(sk_next(sk), uh->dest, daddr,
-						   uh->source, saddr, dif);
+			sknext = udp_v4_mcast_next(net, sk_next(sk), uh->dest,
+						   daddr, uh->source, saddr,
+						   dif);
 			if (sknext)
 				skb1 = skb_clone(skb, GFP_ATOMIC);
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -313,7 +313,7 @@ drop:
 	return -1;
 }
 
-static struct sock *udp_v6_mcast_next(struct sock *sk,
+static struct sock *udp_v6_mcast_next(struct net *net, struct sock *sk,
 				      __be16 loc_port, struct in6_addr *loc_addr,
 				      __be16 rmt_port, struct in6_addr *rmt_addr,
 				      int dif)
@@ -325,7 +325,7 @@ static struct sock *udp_v6_mcast_next(st
 	sk_for_each_from(s, node) {
 		struct inet_sock *inet = inet_sk(s);
 
-		if (sock_net(s) != sock_net(sk))
+		if (!net_eq(sock_net(s), net))
 			continue;
 
 		if (s->sk_hash == num && s->sk_family == PF_INET6) {
@@ -368,14 +368,14 @@ static int __udp6_lib_mcast_deliver(stru
 	read_lock(&udp_hash_lock);
 	sk = sk_head(&udptable[udp_hashfn(net, ntohs(uh->dest))]);
 	dif = inet6_iif(skb);
-	sk = udp_v6_mcast_next(sk, uh->dest, daddr, uh->source, saddr, dif);
+	sk = udp_v6_mcast_next(net, sk, uh->dest, daddr, uh->source, saddr, dif);
 	if (!sk) {
 		kfree_skb(skb);
 		goto out;
 	}
 
 	sk2 = sk;
-	while ((sk2 = udp_v6_mcast_next(sk_next(sk2), uh->dest, daddr,
+	while ((sk2 = udp_v6_mcast_next(net, sk_next(sk2), uh->dest, daddr,
 					uh->source, saddr, dif))) {
 		struct sk_buff *buff = skb_clone(skb, GFP_ATOMIC);
 		if (buff) {

