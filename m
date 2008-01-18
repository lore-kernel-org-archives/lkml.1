Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYARBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYARBwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYARBwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:52:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52121 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYARBwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:52:09 -0500
Date: Fri, 18 Jan 2008 02:52:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@suse.de, vaf@cisco.com
Subject: Re: [PATCH] IPv4: Enable use of 240/4 address space
In-Reply-To: <20080118.102635.01689255.yoshfuji@linux-ipv6.org>
Message-ID: <Pine.LNX.4.64.0801180242270.14025@fbirervta.pbzchgretzou.qr>
References: <20080108011057.GA21168@cisco.com>
 <Pine.LNX.4.64.0801180023450.18447@fbirervta.pbzchgretzou.qr>
 <20080118.102635.01689255.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18 2008 10:26, YOSHIFUJI Hideaki / 吉藤英明 wrote:
>> -#define	IN_EXPERIMENTAL(a)	((((long int) (a)) & 0xf0000000) == 0xf0000000)
>> -#define	IN_BADCLASS(a)		IN_EXPERIMENTAL((a))
>
>No, please keep these macros.
>
>> @@ -264,7 +261,7 @@ static inline bool ipv4_is_local_multicast(__be32 addr)
>>  
>>  static inline bool ipv4_is_badclass(__be32 addr)
>>  {
>> -	return (addr & htonl(0xf0000000)) == htonl(0xf0000000);
>> +	return addr == 0xFFFFFFFF;
>>  }
>>  
>
>To (un)align the IN_BADCLASS macro and ipv6_is_badclass() definition,

Unalign? IPv6? "Limited" broadcast?

>you should change the name anyway, e.g., ipv6_is_limited_broadcast()
>or some something alike.

===
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 18 02:51:34 2008 +0100

    IPv4: enable use of 240/4 address space
    
    This short patch modifies the IPv4 networking to enable use of the
    240.0.0.0/4 (aka "class-E") address space as propsed in the internet
    draft draft-fuller-240space-00.txt.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/in.h b/include/linux/in.h
index 27d8a5a..4887768 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -262,9 +262,9 @@ static inline bool ipv4_is_local_multicast(__be32 addr)
 	return (addr & htonl(0xffffff00)) == htonl(0xe0000000);
 }
 
-static inline bool ipv4_is_badclass(__be32 addr)
+static inline bool ipv4_is_broadcast(__be32 addr)
 {
-	return (addr & htonl(0xf0000000)) == htonl(0xf0000000);
+	return addr == 0xFFFFFFFF;
 }
 
 static inline bool ipv4_is_zeronet(__be32 addr)
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 8b1509b..f5bd33b 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -262,7 +262,7 @@ static inline int ipv6_isatap_eui64(u8 *eui, __be32 addr)
 		  ipv4_is_private_172(addr) || ipv4_is_test_192(addr) ||
 		  ipv4_is_anycast_6to4(addr) || ipv4_is_private_192(addr) ||
 		  ipv4_is_test_198(addr) || ipv4_is_multicast(addr) ||
-		  ipv4_is_badclass(addr)) ? 0x00 : 0x02;
+		  ipv4_is_broadcast(addr)) ? 0x00 : 0x02;
 	eui[1] = 0;
 	eui[2] = 0x5E;
 	eui[3] = 0xFE;
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d18fdb1..9d6e7af 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2266,7 +2266,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 
 					while (ipv4_is_loopback(s) ||
 					       ipv4_is_multicast(s) ||
-					       ipv4_is_badclass(s) ||
+					       ipv4_is_broadcast(s) ||
 					       ipv4_is_zeronet(s) ||
 					       ipv4_is_local_multicast(s)) {
 						t = random32() % (imx - imn) + imn;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 8ddcd3f..367e097 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -176,7 +176,7 @@ static inline unsigned __inet_dev_addr_type(struct net *net,
 	unsigned ret = RTN_BROADCAST;
 	struct fib_table *local_table;
 
-	if (ipv4_is_zeronet(addr) || ipv4_is_badclass(addr))
+	if (ipv4_is_zeronet(addr) || ipv4_is_broadcast(addr))
 		return RTN_BROADCAST;
 	if (ipv4_is_multicast(addr))
 		return RTN_MULTICAST;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1e59c0d..9f0ea73 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1154,7 +1154,7 @@ void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
 		return;
 
 	if (new_gw == old_gw || !IN_DEV_RX_REDIRECTS(in_dev)
-	    || ipv4_is_multicast(new_gw) || ipv4_is_badclass(new_gw)
+	    || ipv4_is_multicast(new_gw) || ipv4_is_broadcast(new_gw)
 	    || ipv4_is_zeronet(new_gw))
 		goto reject_redirect;
 
@@ -1634,7 +1634,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (in_dev == NULL)
 		return -EINVAL;
 
-	if (ipv4_is_multicast(saddr) || ipv4_is_badclass(saddr) ||
+	if (ipv4_is_multicast(saddr) || ipv4_is_broadcast(saddr) ||
 	    ipv4_is_loopback(saddr) || skb->protocol != htons(ETH_P_IP))
 		goto e_inval;
 
@@ -1891,7 +1891,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	   by fib_lookup.
 	 */
 
-	if (ipv4_is_multicast(saddr) || ipv4_is_badclass(saddr) ||
+	if (ipv4_is_multicast(saddr) || ipv4_is_broadcast(saddr) ||
 	    ipv4_is_loopback(saddr))
 		goto martian_source;
 
@@ -1904,7 +1904,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (ipv4_is_zeronet(saddr))
 		goto martian_source;
 
-	if (ipv4_is_badclass(daddr) || ipv4_is_zeronet(daddr) ||
+	if (ipv4_is_broadcast(daddr) || ipv4_is_zeronet(daddr) ||
 	    ipv4_is_loopback(daddr))
 		goto martian_destination;
 
@@ -2125,7 +2125,7 @@ static inline int __mkroute_output(struct rtable **result,
 		res->type = RTN_BROADCAST;
 	else if (ipv4_is_multicast(fl->fl4_dst))
 		res->type = RTN_MULTICAST;
-	else if (ipv4_is_badclass(fl->fl4_dst) || ipv4_is_zeronet(fl->fl4_dst))
+	else if (ipv4_is_broadcast(fl->fl4_dst) || ipv4_is_zeronet(fl->fl4_dst))
 		return -EINVAL;
 
 	if (dev_out->flags & IFF_LOOPBACK)
@@ -2276,7 +2276,7 @@ static int ip_route_output_slow(struct rtable **rp, const struct flowi *oldflp)
 	if (oldflp->fl4_src) {
 		err = -EINVAL;
 		if (ipv4_is_multicast(oldflp->fl4_src) ||
-		    ipv4_is_badclass(oldflp->fl4_src) ||
+		    ipv4_is_broadcast(oldflp->fl4_src) ||
 		    ipv4_is_zeronet(oldflp->fl4_src))
 			goto out;
 
