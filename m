Return-Path: <linux-kernel-owner+w=401wt.eu-S1946287AbXBCCqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946287AbXBCCqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946296AbXBCCoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:44:17 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53582 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946287AbXBCCoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:44:03 -0500
Message-Id: <20070203024623.954108000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:55 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: [patch 51/59] AF_PACKET: Fix BPF handling.
Content-Disposition: inline; filename=af_packet-fix-bpf-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: David S. Miller <davem@sunset.davemloft.net>

This fixes a bug introduced by:

commit fda9ef5d679b07c9d9097aaf6ef7f069d794a8f9
Author: Dmitry Mishin <dim@openvz.org>
Date:   Thu Aug 31 15:28:39 2006 -0700

    [NET]: Fix sk->sk_filter field access

sk_run_filter() returns either 0 or an unsigned 32-bit
length which says how much of the packet to retain.
If that 32-bit unsigned integer is larger than the packet,
this is fine we just leave the packet unchanged.

The above commit caused all filter return values which
were negative when interpreted as a signed integer to
indicate a packet drop, which is wrong.

Based upon a report and initial patch by Raivis Bucis.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/packet/af_packet.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- linux-2.6.19.2.orig/net/packet/af_packet.c
+++ linux-2.6.19.2/net/packet/af_packet.c
@@ -427,24 +427,18 @@ out_unlock:
 }
 #endif
 
-static inline int run_filter(struct sk_buff *skb, struct sock *sk,
-							unsigned *snaplen)
+static inline unsigned int run_filter(struct sk_buff *skb, struct sock *sk,
+				      unsigned int res)
 {
 	struct sk_filter *filter;
-	int err = 0;
 
 	rcu_read_lock_bh();
 	filter = rcu_dereference(sk->sk_filter);
-	if (filter != NULL) {
-		err = sk_run_filter(skb, filter->insns, filter->len);
-		if (!err)
-			err = -EPERM;
-		else if (*snaplen > err)
-			*snaplen = err;
-	}
+	if (filter != NULL)
+		res = sk_run_filter(skb, filter->insns, filter->len);
 	rcu_read_unlock_bh();
 
-	return err;
+	return res;
 }
 
 /*
@@ -466,7 +460,7 @@ static int packet_rcv(struct sk_buff *sk
 	struct packet_sock *po;
 	u8 * skb_head = skb->data;
 	int skb_len = skb->len;
-	unsigned snaplen;
+	unsigned int snaplen, res;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		goto drop;
@@ -494,8 +488,11 @@ static int packet_rcv(struct sk_buff *sk
 
 	snaplen = skb->len;
 
-	if (run_filter(skb, sk, &snaplen) < 0)
+	res = run_filter(skb, sk, snaplen);
+	if (!res)
 		goto drop_n_restore;
+	if (snaplen > res)
+		snaplen = res;
 
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
 	    (unsigned)sk->sk_rcvbuf)
@@ -567,7 +564,7 @@ static int tpacket_rcv(struct sk_buff *s
 	struct tpacket_hdr *h;
 	u8 * skb_head = skb->data;
 	int skb_len = skb->len;
-	unsigned snaplen;
+	unsigned int snaplen, res;
 	unsigned long status = TP_STATUS_LOSING|TP_STATUS_USER;
 	unsigned short macoff, netoff;
 	struct sk_buff *copy_skb = NULL;
@@ -591,8 +588,11 @@ static int tpacket_rcv(struct sk_buff *s
 
 	snaplen = skb->len;
 
-	if (run_filter(skb, sk, &snaplen) < 0)
+	res = run_filter(skb, sk, snaplen);
+	if (!res)
 		goto drop_n_restore;
+	if (snaplen > res)
+		snaplen = res;
 
 	if (sk->sk_type == SOCK_DGRAM) {
 		macoff = netoff = TPACKET_ALIGN(TPACKET_HDRLEN) + 16;

--
