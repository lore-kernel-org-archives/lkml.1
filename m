Return-Path: <linux-kernel-owner+w=401wt.eu-S2992896AbXEBIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992896AbXEBIOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992899AbXEBIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:14:05 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35634 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992896AbXEBIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:14:01 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com
Subject: [PATCH] Build break on ppc64 for 2.6.21-rc7-mm2
Date: Wed, 2 May 2007 13:43:55 +0530
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021343.55030.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

 When compiling 2.6.21-rc7-mm2, I encountered this error.
 =================================================
  CC [M]  drivers/net/e1000/e1000_ethtool.o
  CC [M]  drivers/net/e1000/e1000_main.o
  LD [M]  drivers/net/e1000/e1000.o
  LD      drivers/net/ehea/built-in.o
  CC [M]  drivers/net/ehea/ehea_main.o
drivers/net/ehea/ehea_main.c: In function ehea_hash_skb:
drivers/net/ehea/ehea_main.c:1806: error: struct sk_buff has no member named 
nh
drivers/net/ehea/ehea_main.c:1807: error: struct sk_buff has no member named 
nh
drivers/net/ehea/ehea_main.c:1807: error: struct sk_buff has no member named 
nh
drivers/net/ehea/ehea_main.c:1809: error: struct sk_buff has no member named 
nh
make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1
make[2]: *** [drivers/net/ehea] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
=================================================

Since code is not compatible with struct sk_buff change, we have this error. 
Below patch should fix this problem. Please let me know your comments on 
this.

Signed-off-by: Srinivasa Ds <srinivasa@in.ibm.com>
---
 drivers/net/ehea/ehea_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc7/drivers/net/ehea/ehea_main.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/net/ehea/ehea_main.c
+++ linux-2.6.21-rc7/drivers/net/ehea/ehea_main.c
@@ -1803,10 +1803,10 @@ static inline int ehea_hash_skb(struct s
 	u32 tmp;
 
 	if ((skb->protocol == htons(ETH_P_IP)) &&
-	    (skb->nh.iph->protocol == IPPROTO_TCP)) {
-		tcp = (struct tcphdr*)(skb->nh.raw + (skb->nh.iph->ihl * 4));
+	    (ip_hdr(skb)->protocol == IPPROTO_TCP)) {
+		tcp = (struct tcphdr*)(skb_network_header(skb) + (ip_hdr(skb)->ihl * 4));
 		tmp = (tcp->source + (tcp->dest << 16)) % 31;
-		tmp += skb->nh.iph->daddr % 31;
+		tmp += ip_hdr(skb)->daddr % 31;
 		return tmp % num_qps;
 	}
 	else


