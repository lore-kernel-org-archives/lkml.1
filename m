Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbXKWMNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbXKWMNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXKWMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:13:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:9669 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbXKWMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=NKC6NEaZwJ98igG8o/MuEG/Sa6zYeCxXuFbodZ6jCvO1J/nURsa7ropHEmo6+WMLLEBRTFFt0Hlcxex0pLb+nMxlyuQrkSx3kFC3xOaK6WiweqFBE/osMZIS1bkZik255C2FvayNdZcQJdY2+znn38ebtep86XyXrjLnAx11AcA=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <tristan_schmelcher@alumni.uwaterloo.ca>,
       <acme@ghostprotocols.net>
Subject: [PATCH] [NET]: Fix TX bug VLAN in VLAN
Date: Fri, 23 Nov 2007 21:12:52 +0900
Message-ID: <003f01c82dca$305acd40$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
thread-index: Acgtyiv/svcEYH8PSPugqUkXFaikYw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=8766

Is it possible? 
BUG((veth->h_vlan_proto != htons(ETH_P_8021Q)) && !(VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR))
I'm afraid, queued packet before vconfig set_flag would do that.

Thanks.
Joonwoo


[NET]: Fix TX bug VLAN in VLAN
Fix misbehavior of vlan_dev_hard_start_xmit() for recursive encapsulations.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 7a36878..3e34990 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -454,7 +454,9 @@ int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_device_stats *stats = vlan_dev_get_stats(dev);
+#ifdef VLAN_DEBUG
 	struct vlan_ethhdr *veth = (struct vlan_ethhdr *)(skb->data);
+#endif
 
 	/* Handle non-VLAN frames if they are sent to us, for example by DHCP.
 	 *
@@ -462,7 +464,7 @@ int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * OTHER THINGS LIKE FDDI/TokenRing/802.3 SNAPs...
 	 */
 
-	if (veth->h_vlan_proto != htons(ETH_P_8021Q)) {
+	if (VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR) {
 		int orig_headroom = skb_headroom(skb);
 		unsigned short veth_TCI;
 
---

