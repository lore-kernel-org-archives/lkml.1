Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498Ab0AEAf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0AEAf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435Ab0AEAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:52 -0500
Received: from kroah.org ([198.145.64.141]:34497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0AEAft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 67/97] netfilter: fix crashes in bridge netfilter caused by fragment jumps
Date: Mon,  4 Jan 2010 16:33:20 -0800
Message-Id: <1262651630-7354-67-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

commit 8fa9ff6849bb86c59cc2ea9faadf3cb2d5223497 upstream.

When fragments from bridge netfilter are passed to IPv4 or IPv6 conntrack
and a reassembly queue with the same fragment key already exists from
reassembling a similar packet received on a different device (f.i. with
multicasted fragments), the reassembled packet might continue on a different
codepath than where the head fragment originated. This can cause crashes
in bridge netfilter when a fragment received on a non-bridge device (and
thus with skb->nf_bridge == NULL) continues through the bridge netfilter
code.

Add a new reassembly identifier for packets originating from bridge
netfilter and use it to put those packets in insolated queues.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14805

Reported-and-Tested-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/ip.h                               |    1 +
 include/net/ipv6.h                             |    1 +
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   21 +++++++++++++++++----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 ++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2f47e54..69db943 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -342,6 +342,7 @@ enum ip_defrag_users
 	IP_DEFRAG_CALL_RA_CHAIN,
 	IP_DEFRAG_CONNTRACK_IN,
 	IP_DEFRAG_CONNTRACK_OUT,
+	IP_DEFRAG_CONNTRACK_BRIDGE_IN,
 	IP_DEFRAG_VS_IN,
 	IP_DEFRAG_VS_OUT,
 	IP_DEFRAG_VS_FWD
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index a496499..639bbf0 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -358,6 +358,7 @@ enum ip6_defrag_users {
 	IP6_DEFRAG_LOCAL_DELIVER,
 	IP6_DEFRAG_CONNTRACK_IN,
 	IP6_DEFRAG_CONNTRACK_OUT,
+	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
 };
 
 struct ip6_create_arg {
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index fa2d6b6..331ead3 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -14,6 +14,7 @@
 #include <net/route.h>
 #include <net/ip.h>
 
+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 
@@ -34,6 +35,20 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 	return err;
 }
 
+static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
+					      struct sk_buff *skb)
+{
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge &&
+	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
+		return IP_DEFRAG_CONNTRACK_BRIDGE_IN;
+#endif
+	if (hooknum == NF_INET_PRE_ROUTING)
+		return IP_DEFRAG_CONNTRACK_IN;
+	else
+		return IP_DEFRAG_CONNTRACK_OUT;
+}
+
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 					  struct sk_buff *skb,
 					  const struct net_device *in,
@@ -50,10 +65,8 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 #endif
 	/* Gather fragments. */
 	if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
-		if (nf_ct_ipv4_gather_frags(skb,
-					    hooknum == NF_INET_PRE_ROUTING ?
-					    IP_DEFRAG_CONNTRACK_IN :
-					    IP_DEFRAG_CONNTRACK_OUT))
+		enum ip_defrag_users user = nf_ct_defrag_user(hooknum, skb);
+		if (nf_ct_ipv4_gather_frags(skb, user))
 			return NF_STOLEN;
 	}
 	return NF_ACCEPT;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index c0a82fe..0956eba 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -20,6 +20,7 @@
 #include <net/ipv6.h>
 #include <net/inet_frag.h>
 
+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -190,6 +191,11 @@ out:
 static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 						struct sk_buff *skb)
 {
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge &&
+	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
+		return IP6_DEFRAG_CONNTRACK_BRIDGE_IN;
+#endif
 	if (hooknum == NF_INET_PRE_ROUTING)
 		return IP6_DEFRAG_CONNTRACK_IN;
 	else
-- 
1.6.6

