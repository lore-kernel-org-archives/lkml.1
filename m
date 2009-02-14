Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbZBNBMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbZBNBMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZBNBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:53 -0500
Received: from kroah.org ([198.145.64.141]:39759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761245AbZBNBBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:51 -0500
Date: Fri, 13 Feb 2009 16:59:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jesper Dangaard Brouer <hawk@comx.dk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 29/47] udp: Fix UDP short packet false positive
Message-ID: <20090214005902.GD11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="udp-fix-udp-short-packet-false-positive.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesper Dangaard Brouer <hawk@comx.dk>

[ Upstream commit 7b5e56f9d635643ad54f2f42e69ad16b80a2cff1 ]

The UDP header pointer assignment must happen after calling
pskb_may_pull().  As pskb_may_pull() can potentially alter the SKB
buffer.

This was exposted by running multicast traffic through the NIU driver,
as it won't prepull the protocol headers into the linear area on
receive.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1172,7 +1172,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 		   int proto)
 {
 	struct sock *sk;
-	struct udphdr *uh = udp_hdr(skb);
+	struct udphdr *uh;
 	unsigned short ulen;
 	struct rtable *rt = (struct rtable*)skb->dst;
 	__be32 saddr = ip_hdr(skb)->saddr;
@@ -1185,6 +1185,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 		goto drop;		/* No space for header. */
 
+	uh   = udp_hdr(skb);
 	ulen = ntohs(uh->len);
 	if (ulen > skb->len)
 		goto short_packet;

