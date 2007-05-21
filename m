Return-Path: <linux-kernel-owner+w=401wt.eu-S1765841AbXEUTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765841AbXEUTqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbXEUT2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:14 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52595 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847AbXEUT2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:13 -0400
Message-Id: <20070521191745.506371000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, David L Stevens <dlstevens@us.ibm.com>
Subject: [patch 47/69] IPV6: Send ICMPv6 error on scope violations.
Content-Disposition: inline; filename=ipv6-send-icmpv6-error-on-scope-violations.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David L Stevens <dlstevens@us.ibm.com>

When an IPv6 router is forwarding a packet with a link-local scope source
address off-link, RFC 4007 requires it to send an ICMPv6 destination
unreachable with code 2 ("not neighbor"), but Linux doesn't. Fix below.

Signed-off-by: David L Stevens <dlstevens@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/ip6_output.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/net/ipv6/ip6_output.c
+++ linux-2.6.21.1/net/ipv6/ip6_output.c
@@ -449,10 +449,17 @@ int ip6_forward(struct sk_buff *skb)
 		 */
 		if (xrlim_allow(dst, 1*HZ))
 			ndisc_send_redirect(skb, n, target);
-	} else if (ipv6_addr_type(&hdr->saddr)&(IPV6_ADDR_MULTICAST|IPV6_ADDR_LOOPBACK
-						|IPV6_ADDR_LINKLOCAL)) {
+	} else {
+		int addrtype = ipv6_addr_type(&hdr->saddr);
+
 		/* This check is security critical. */
-		goto error;
+		if (addrtype & (IPV6_ADDR_MULTICAST|IPV6_ADDR_LOOPBACK))
+			goto error;
+		if (addrtype & IPV6_ADDR_LINKLOCAL) {
+			icmpv6_send(skb, ICMPV6_DEST_UNREACH,
+				ICMPV6_NOT_NEIGHBOUR, 0, skb->dev);
+			goto error;
+		}
 	}
 
 	if (skb->len > dst_mtu(dst)) {

-- 
