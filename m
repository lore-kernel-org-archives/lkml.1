Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbXEYIZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbXEYIZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXEYIZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:25:42 -0400
Received: from hydra.ck.polsl.pl ([157.158.1.11]:52244 "EHLO hydra.ck.polsl.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbXEYIZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:25:40 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 04:25:40 EDT
Date: Fri, 25 May 2007 10:17:50 +0200
From: Adam Osuchowski <adwol@zonk.pl>
To: bridge@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] Dropping fragmented IP packets within VLAN frames on bridge
Message-ID: <20070525081750.5ba4a411@zonk.pl>
Reply-To: Adam Osuchowski <adwol@zonk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a problem with fragmented IP packet sent within 802.1Q tagged
ethernet frame through bridge. Problem exists when conntrack is enabled
(i.e. nf_conntrack_ipv4 module is loaded). Then, such packets are not
fragmented again (after prior reassembling on bridge device) during
passing it to bridge enslaved NIC. It cause MTU exceeding and as a result
dropping packet.

Problem exists from kernel version 2.6.17 to 2.6.21.3 inclusive.

Below, there is a patch to fix it.

Regards.


--- linux-2.6.21.3.orig/net/bridge/br_netfilter.c	2007-05-25 09:56:15.000000000 +0200
+++ linux-2.6.21.3/net/bridge/br_netfilter.c	2007-05-25 10:11:42.000000000 +0200
@@ -731,7 +731,7 @@
 
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP) &&
+	if ((skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
 	    skb->len > skb->dev->mtu &&
 	    !skb_is_gso(skb))
 		return ip_fragment(skb, br_dev_queue_push_xmit);
