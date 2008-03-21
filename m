Return-Path: <linux-kernel-owner+w=401wt.eu-S1762568AbYCUXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762568AbYCUXqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYCUXpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:33 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60169 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbYCUXpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:23 -0400
Message-Id: <20080321224338.262703483@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:01 -0700
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
       "Denis V. Lunev" <den@openvz.org>, David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/76] IPV6: dst_entry leak in ip4ip6_err.
Content-Disposition: inline; filename=ipv6-dst_entry-leak-in-ip4ip6_err.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Denis V. Lunev <den@openvz.org>

Upstream commit: 9937ded8e44de8865cba1509d24eea9d350cebf0

The result of the ip_route_output is not assigned to skb. This means that
- it is leaked
- possible OOPS below dereferrencing skb->dst
- no ICMP message for this case

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/ip6_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -550,6 +550,7 @@ ip4ip6_err(struct sk_buff *skb, struct i
 			ip_rt_put(rt);
 			goto out;
 		}
+		skb2->dst = (struct dst_entry *)rt;
 	} else {
 		ip_rt_put(rt);
 		if (ip_route_input(skb2, eiph->daddr, eiph->saddr, eiph->tos,

-- 
