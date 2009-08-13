Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZHMT7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZHMT7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZHMT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:20 -0400
Received: from kroah.org ([198.145.64.141]:41664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZHMT7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.188943619@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/74] net: Move rx skb_orphan call to where needed
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=net-move-rx-skb_orphan-call-to-where-needed.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 329c44e3948473916bccd253a37ac2a66dad9862 ]

In order to get the tun driver to account packets, we need to be
able to receive packets with destructors set.  To be on the safe
side, I added an skb_orphan call for all protocols by default since
some of them (IP in particular) cannot handle receiving packets
destructors properly.

Now it seems that at least one protocol (CAN) expects to be able
to pass skb->sk through the rx path without getting clobbered.

So this patch attempts to fix this properly by moving the skb_orphan
call to where it's actually needed.  In particular, I've added it
to skb_set_owner_[rw] which is what most users of skb->destructor
call.

This is actually an improvement for tun too since it means that
we only give back the amount charged to the socket when the skb
is passed to another socket that will also be charged accordingly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Oliver Hartkopp <olver@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/sctp/sctp.h      |    1 +
 include/net/sock.h           |    2 ++
 net/ax25/ax25_in.c           |    3 +--
 net/core/dev.c               |    2 --
 net/irda/af_irda.c           |    3 ---
 net/irda/ircomm/ircomm_lmp.c |    1 +
 6 files changed, 5 insertions(+), 7 deletions(-)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -448,6 +448,7 @@ static inline void sctp_skb_set_owner_r(
 {
 	struct sctp_ulpevent *event = sctp_skb2event(skb);
 
+	skb_orphan(skb);
 	skb->sk = sk;
 	skb->destructor = sctp_sock_rfree;
 	atomic_add(event->rmem_len, &sk->sk_rmem_alloc);
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1231,6 +1231,8 @@ static inline void skb_set_owner_w(struc
 
 static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 {
+	skb_orphan(skb);
+	skb_orphan(skb);
 	skb->sk = sk;
 	skb->destructor = sock_rfree;
 	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -437,8 +437,7 @@ free:
 int ax25_kiss_rcv(struct sk_buff *skb, struct net_device *dev,
 		  struct packet_type *ptype, struct net_device *orig_dev)
 {
-	skb->sk = NULL;		/* Initially we don't know who it's for */
-	skb->destructor = NULL;	/* Who initializes this, dammit?! */
+	skb_orphan(skb);
 
 	if (!net_eq(dev_net(dev), &init_net)) {
 		kfree_skb(skb);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2284,8 +2284,6 @@ ncls:
 	if (!skb)
 		goto out;
 
-	skb_orphan(skb);
-
 	type = skb->protocol;
 	list_for_each_entry_rcu(ptype,
 			&ptype_base[ntohs(type) & PTYPE_HASH_MASK], list) {
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -913,9 +913,6 @@ static int irda_accept(struct socket *so
 	/* Clean up the original one to keep it in listen state */
 	irttp_listen(self->tsap);
 
-	/* Wow ! What is that ? Jean II */
-	skb->sk = NULL;
-	skb->destructor = NULL;
 	kfree_skb(skb);
 	sk->sk_ack_backlog--;
 
--- a/net/irda/ircomm/ircomm_lmp.c
+++ b/net/irda/ircomm/ircomm_lmp.c
@@ -196,6 +196,7 @@ static int ircomm_lmp_data_request(struc
 	/* Don't forget to refcount it - see ircomm_tty_do_softint() */
 	skb_get(skb);
 
+	skb_orphan(skb);
 	skb->destructor = ircomm_lmp_flow_control;
 
 	if ((self->pkt_count++ > 7) && (self->flow_status == FLOW_START)) {


