Return-Path: <linux-kernel-owner+w=401wt.eu-S934405AbXGZQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbXGZQe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbXGZQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbXGZQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ip6_tunnel - endianness annotations
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IE6HJ-0005CL-GL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Convert rel_info to host-endian before calling ip6_tnl_err().
The things become much more straightforward that way.
The key observation (and the reason why that code actually
worked) is that after ip6_tnl_err() we either immediately
bailed out or had rel_info set to 0 or had it set to host-endian
and guaranteed to hit
(rel_type == ICMP_DEST_UNREACH && rel_code == ICMP_FRAG_NEEDED)
case.  So inconsistent endianness didn't really lead to bugs,
but it had been subtle and prone to breakage.  New variant is
saner and obviously safe.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv6/ip6_tunnel.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index df30976..ca774d8 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -385,7 +385,7 @@ parse_tlv_tnl_enc_lim(struct sk_buff *skb, __u8 * raw)
 
 static int
 ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
-	    int *type, int *code, int *msg, __be32 *info, int offset)
+	    int *type, int *code, int *msg, __u32 *info, int offset)
 {
 	struct ipv6hdr *ipv6h = (struct ipv6hdr *) skb->data;
 	struct ip6_tnl *t;
@@ -435,7 +435,7 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 		if ((*code) == ICMPV6_HDR_FIELD)
 			teli = parse_tlv_tnl_enc_lim(skb, skb->data);
 
-		if (teli && teli == ntohl(*info) - 2) {
+		if (teli && teli == *info - 2) {
 			tel = (struct ipv6_tlv_tnl_enc_lim *) &skb->data[teli];
 			if (tel->encap_limit == 0) {
 				if (net_ratelimit())
@@ -452,7 +452,7 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 		}
 		break;
 	case ICMPV6_PKT_TOOBIG:
-		mtu = ntohl(*info) - offset;
+		mtu = *info - offset;
 		if (mtu < IPV6_MIN_MTU)
 			mtu = IPV6_MIN_MTU;
 		t->dev->mtu = mtu;
@@ -478,12 +478,12 @@ out:
 
 static int
 ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-	   int type, int code, int offset, __u32 info)
+	   int type, int code, int offset, __be32 info)
 {
 	int rel_msg = 0;
 	int rel_type = type;
 	int rel_code = code;
-	__u32 rel_info = info;
+	__u32 rel_info = ntohl(info);
 	int err;
 	struct sk_buff *skb2;
 	struct iphdr *eiph;
@@ -564,10 +564,9 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			goto out;
 
 		skb2->dst->ops->update_pmtu(skb2->dst, rel_info);
-		rel_info = htonl(rel_info);
 	}
 
-	icmp_send(skb2, rel_type, rel_code, rel_info);
+	icmp_send(skb2, rel_type, rel_code, htonl(rel_info));
 
 out:
 	kfree_skb(skb2);
@@ -576,12 +575,12 @@ out:
 
 static int
 ip6ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-	   int type, int code, int offset, __u32 info)
+	   int type, int code, int offset, __be32 info)
 {
 	int rel_msg = 0;
 	int rel_type = type;
 	int rel_code = code;
-	__u32 rel_info = info;
+	__u32 rel_info = ntohl(info);
 	int err;
 
 	err = ip6_tnl_err(skb, IPPROTO_IPV6, opt, &rel_type, &rel_code,
-- 
1.5.3.GIT


