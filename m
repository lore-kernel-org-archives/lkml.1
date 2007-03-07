Return-Path: <linux-kernel-owner+w=401wt.eu-S1422769AbXCGR4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbXCGR4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422746AbXCGRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:55:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:43538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743AbXCGROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:06 -0500
Message-Id: <20070307171222.819981192@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 020/101] Fix allocation failure handling in multicast
Content-Disposition: inline; filename=fix-allocation-failure-handling-in-multicast.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@openvz.org>

[IPV4/IPV6] multicast: Check add_grhead() return value

add_grhead() allocates memory with GFP_ATOMIC and in at least two places skb
from it passed to skb_put() without checking.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/igmp.c  |    2 ++
 net/ipv6/mcast.c |    2 ++
 2 files changed, 4 insertions(+)

--- linux-2.6.20.1.orig/net/ipv4/igmp.c
+++ linux-2.6.20.1/net/ipv4/igmp.c
@@ -455,6 +455,8 @@ static struct sk_buff *add_grec(struct s
 			skb = add_grhead(skb, pmc, type, &pgr);
 			first = 0;
 		}
+		if (!skb)
+			return NULL;
 		psrc = (__be32 *)skb_put(skb, sizeof(__be32));
 		*psrc = psf->sf_inaddr;
 		scount++; stotal++;
--- linux-2.6.20.1.orig/net/ipv6/mcast.c
+++ linux-2.6.20.1/net/ipv6/mcast.c
@@ -1582,6 +1582,8 @@ static struct sk_buff *add_grec(struct s
 			skb = add_grhead(skb, pmc, type, &pgr);
 			first = 0;
 		}
+		if (!skb)
+			return NULL;
 		psrc = (struct in6_addr *)skb_put(skb, sizeof(*psrc));
 		*psrc = psf->sf_addr;
 		scount++; stotal++;

--
