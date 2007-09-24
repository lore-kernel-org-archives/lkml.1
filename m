Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbXIXQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbXIXQly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbXIXQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:31 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58105 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbXIXQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:30 -0400
Date: Mon, 24 Sep 2007 09:22:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [43/50] Fix oops in vlan and bridging code
Message-ID: <20070924162230.GR13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oops-in-vlan-and-bridging-code.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

commit 8c7b43a2e58baa24002fa2b266d9a5007bc52a40 in mainline

I tried to preserve bridging code as it was before, but logic is quite
strange - I think we should free skb on error, since it is already
unshared and thus will just leak.

Herbert Xu states:

> +	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
> +		goto out;

If this happens it'll be a double-free on skb since we'll
return NF_DROP which makes the caller free it too.

We could return NF_STOLEN to prevent that but I'm not sure
whether that's correct netfilter semantics.  Patrick, could
you please make a call on this?

Patrick McHardy states:

NF_STOLEN should work fine here.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/8021q/vlan_dev.c      |   12 +++++++++++-
 net/bridge/br_netfilter.c |   12 +++++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -116,12 +116,22 @@ int vlan_skb_recv(struct sk_buff *skb, s
 		  struct packet_type* ptype, struct net_device *orig_dev)
 {
 	unsigned char *rawp = NULL;
-	struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
+	struct vlan_hdr *vhdr;
 	unsigned short vid;
 	struct net_device_stats *stats;
 	unsigned short vlan_TCI;
 	__be16 proto;
 
+	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
+		return -1;
+
+	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN))) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+	vhdr = (struct vlan_hdr *)(skb->data);
+
 	/* vlan_TCI = ntohs(get_unaligned(&vhdr->h_vlan_TCI)); */
 	vlan_TCI = ntohs(vhdr->h_vlan_TCI);
 
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -509,8 +509,14 @@ static unsigned int br_nf_pre_routing(un
 				      int (*okfn)(struct sk_buff *))
 {
 	struct iphdr *iph;
-	__u32 len;
 	struct sk_buff *skb = *pskb;
+	__u32 len = nf_bridge_encap_header_len(skb);
+
+	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
+		return NF_STOLEN;
+
+	if (unlikely(!pskb_may_pull(skb, len)))
+		goto out;
 
 	if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
 	    IS_PPPOE_IPV6(skb)) {
@@ -518,8 +524,6 @@ static unsigned int br_nf_pre_routing(un
 		if (!brnf_call_ip6tables)
 			return NF_ACCEPT;
 #endif
-		if ((skb = skb_share_check(*pskb, GFP_ATOMIC)) == NULL)
-			goto out;
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
 	}
@@ -532,8 +536,6 @@ static unsigned int br_nf_pre_routing(un
 	    !IS_PPPOE_IP(skb))
 		return NF_ACCEPT;
 
-	if ((skb = skb_share_check(*pskb, GFP_ATOMIC)) == NULL)
-		goto out;
 	nf_bridge_pull_encap_header_rcsum(skb);
 
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))

-- 
