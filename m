Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbXJNSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbXJNSl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763976AbXJNSlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:41:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33747 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763967AbXJNSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:41:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] inet_lro: trivial endianness annotations
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1Ih8OZ-0004Bx-7p@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:40:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/inet_lro.h |    6 +++---
 net/ipv4/inet_lro.c      |   14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/inet_lro.h b/include/linux/inet_lro.h
index e1fc1d1..bb1c877 100644
--- a/include/linux/inet_lro.h
+++ b/include/linux/inet_lro.h
@@ -52,14 +52,14 @@ struct net_lro_desc {
 	struct tcphdr *tcph;
 	struct vlan_group *vgrp;
 	__wsum  data_csum;
-	u32 tcp_rcv_tsecr;
-	u32 tcp_rcv_tsval;
+	__be32 tcp_rcv_tsecr;
+	__be32 tcp_rcv_tsval;
 	u32 tcp_ack;
 	u32 tcp_next_seq;
 	u32 skb_tot_frags_len;
 	u16 ip_tot_len;
 	u16 tcp_saw_tstamp; 		/* timestamps enabled */
-	u16 tcp_window;
+	__be16 tcp_window;
 	u16 vlan_tag;
 	int pkt_aggr_cnt;		/* counts aggregated packets */
 	int vlan_packet;
diff --git a/net/ipv4/inet_lro.c b/net/ipv4/inet_lro.c
index 4545b64..7f22474 100644
--- a/net/ipv4/inet_lro.c
+++ b/net/ipv4/inet_lro.c
@@ -77,7 +77,7 @@ static int lro_tcp_ip_check(struct iphdr *iph, struct tcphdr *tcph,
 
 	/* check tcp options (only timestamp allowed) */
 	if (tcph->doff == TCPH_LEN_W_TIMESTAMP) {
-		u32 *topt = (u32 *)(tcph + 1);
+		__be32 *topt = (__be32 *)(tcph + 1);
 
 		if (*topt != htonl((TCPOPT_NOP << 24) | (TCPOPT_NOP << 16)
 				   | (TCPOPT_TIMESTAMP << 8)
@@ -103,14 +103,14 @@ static void lro_update_tcp_ip_header(struct net_lro_desc *lro_desc)
 {
 	struct iphdr *iph = lro_desc->iph;
 	struct tcphdr *tcph = lro_desc->tcph;
-	u32 *p;
+	__be32 *p;
 	__wsum tcp_hdr_csum;
 
 	tcph->ack_seq = lro_desc->tcp_ack;
 	tcph->window = lro_desc->tcp_window;
 
 	if (lro_desc->tcp_saw_tstamp) {
-		p = (u32 *)(tcph + 1);
+		p = (__be32 *)(tcph + 1);
 		*(p+2) = lro_desc->tcp_rcv_tsecr;
 	}
 
@@ -150,7 +150,7 @@ static void lro_init_desc(struct net_lro_desc *lro_desc, struct sk_buff *skb,
 			  u16 vlan_tag, struct vlan_group *vgrp)
 {
 	int nr_frags;
-	u32 *ptr;
+	__be32 *ptr;
 	u32 tcp_data_len = TCP_PAYLOAD_LENGTH(iph, tcph);
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
@@ -166,7 +166,7 @@ static void lro_init_desc(struct net_lro_desc *lro_desc, struct sk_buff *skb,
 	lro_desc->ip_tot_len = ntohs(iph->tot_len);
 
 	if (tcph->doff == 8) {
-		ptr = (u32 *)(tcph+1);
+		ptr = (__be32 *)(tcph+1);
 		lro_desc->tcp_saw_tstamp = 1;
 		lro_desc->tcp_rcv_tsval = *(ptr+1);
 		lro_desc->tcp_rcv_tsecr = *(ptr+2);
@@ -190,7 +190,7 @@ static void lro_add_common(struct net_lro_desc *lro_desc, struct iphdr *iph,
 			   struct tcphdr *tcph, int tcp_data_len)
 {
 	struct sk_buff *parent = lro_desc->parent;
-	u32 *topt;
+	__be32 *topt;
 
 	lro_desc->pkt_aggr_cnt++;
 	lro_desc->ip_tot_len += tcp_data_len;
@@ -200,7 +200,7 @@ static void lro_add_common(struct net_lro_desc *lro_desc, struct iphdr *iph,
 
 	/* don't update tcp_rcv_tsval, would not work with PAWS */
 	if (lro_desc->tcp_saw_tstamp) {
-		topt = (u32 *) (tcph + 1);
+		topt = (__be32 *) (tcph + 1);
 		lro_desc->tcp_rcv_tsecr = *(topt + 2);
 	}
 
-- 
1.5.3.GIT


