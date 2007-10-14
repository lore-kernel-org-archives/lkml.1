Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXJNSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXJNSlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763987AbXJNSlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:41:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33751 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763983AbXJNSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:41:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix endianness bug in inet_lro
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1Ih8Oj-0004CN-7z@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:41:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


all uses of and almost all assignments to lro_desc->tcp_ack assume that it's
net-endian; one converts net-endian to host-endian and sticks it in
lro_desc->tcp_ack.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/inet_lro.h |    2 +-
 net/ipv4/inet_lro.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/inet_lro.h b/include/linux/inet_lro.h
index bb1c877..1246d46 100644
--- a/include/linux/inet_lro.h
+++ b/include/linux/inet_lro.h
@@ -54,7 +54,7 @@ struct net_lro_desc {
 	__wsum  data_csum;
 	__be32 tcp_rcv_tsecr;
 	__be32 tcp_rcv_tsval;
-	u32 tcp_ack;
+	__be32 tcp_ack;
 	u32 tcp_next_seq;
 	u32 skb_tot_frags_len;
 	u16 ip_tot_len;
diff --git a/net/ipv4/inet_lro.c b/net/ipv4/inet_lro.c
index 7f22474..ac3b1d3 100644
--- a/net/ipv4/inet_lro.c
+++ b/net/ipv4/inet_lro.c
@@ -159,7 +159,7 @@ static void lro_init_desc(struct net_lro_desc *lro_desc, struct sk_buff *skb,
 	lro_desc->iph = iph;
 	lro_desc->tcph = tcph;
 	lro_desc->tcp_next_seq = ntohl(tcph->seq) + tcp_data_len;
-	lro_desc->tcp_ack = ntohl(tcph->ack_seq);
+	lro_desc->tcp_ack = tcph->ack_seq;
 	lro_desc->tcp_window = tcph->window;
 
 	lro_desc->pkt_aggr_cnt = 1;
-- 
1.5.3.GIT


