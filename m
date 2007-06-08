Return-Path: <linux-kernel-owner+w=401wt.eu-S967964AbXFHH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967964AbXFHH3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965858AbXFHHS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57587 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965609AbXFHHSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:55 -0400
Message-Id: <20070608071550.638055000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 19/32] ICMP: Fix icmp_errors_use_inbound_ifaddr sysctl
Content-Disposition: inline; filename=icmp-fix-icmp_errors_use_inbound_ifaddr-sysctl.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

Currently when icmp_errors_use_inbound_ifaddr is set and an ICMP error is
sent after the packet passed through ip_output(), an address from the
outgoing interface is chosen as ICMP source address since skb->dev doesn't
point to the incoming interface anymore.

Fix this by doing an interface lookup on rt->dst.iif and using that device.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/icmp.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.20.13.orig/net/ipv4/icmp.c
+++ linux-2.6.20.13/net/ipv4/icmp.c
@@ -513,9 +513,15 @@ void icmp_send(struct sk_buff *skb_in, i
 
 	saddr = iph->daddr;
 	if (!(rt->rt_flags & RTCF_LOCAL)) {
-		if (sysctl_icmp_errors_use_inbound_ifaddr)
-			saddr = inet_select_addr(skb_in->dev, 0, RT_SCOPE_LINK);
-		else
+		struct net_device *dev = NULL;
+
+		if (rt->fl.iif && sysctl_icmp_errors_use_inbound_ifaddr)
+			dev = dev_get_by_index(rt->fl.iif);
+
+		if (dev) {
+			saddr = inet_select_addr(dev, 0, RT_SCOPE_LINK);
+			dev_put(dev);
+		} else
 			saddr = 0;
 	}
 

-- 
