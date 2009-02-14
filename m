Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbZBNBiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbZBNBiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762116AbZBNBQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:35 -0500
Received: from kroah.org ([198.145.64.141]:50441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762771AbZBNBQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:25 -0500
Date: Fri, 13 Feb 2009 17:13:13 -0800
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
Subject: [patch 27/48] udp: Fix UDP short packet false positive
Message-ID: <20090214011313.GB17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="udp-fix-udp-short-packet-false-positive.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1155,7 +1155,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 		   int proto)
 {
 	struct sock *sk;
-	struct udphdr *uh = udp_hdr(skb);
+	struct udphdr *uh;
 	unsigned short ulen;
 	struct rtable *rt = (struct rtable*)skb->dst;
 	__be32 saddr = ip_hdr(skb)->saddr;
@@ -1168,6 +1168,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 		goto drop;		/* No space for header. */
 
+	uh   = udp_hdr(skb);
 	ulen = ntohs(uh->len);
 	if (ulen > skb->len)
 		goto short_packet;

