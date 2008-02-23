Return-Path: <linux-kernel-owner+w=401wt.eu-S937161AbYBWAm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937161AbYBWAm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765171AbYBWAfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:55545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765413AbYBWAfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:00 -0500
Date: Fri, 22 Feb 2008 16:30:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/38] INET: Prevent out-of-sync truesize on ip_fragment
	slow path
Message-ID: <20080223003045.GU7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inet-prevent-out-of-sync-truesize-on-ip_fragment-slow-path.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 29ffe1a5c52dae13b6efead97aab9b058f38fce4

When ip_fragment has to hit the slow path the value of skb->truesize
may go out of sync because we would have updated it without changing
the packet length.  This violates the constraints on truesize.

This patch postpones the update of skb->truesize to prevent this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_output.c  |    4 +++-
 net/ipv6/ip6_output.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -462,6 +462,7 @@ int ip_fragment(struct sk_buff *skb, int
 	if (skb_shinfo(skb)->frag_list) {
 		struct sk_buff *frag;
 		int first_len = skb_pagelen(skb);
+		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -485,7 +486,7 @@ int ip_fragment(struct sk_buff *skb, int
 				sock_hold(skb->sk);
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				skb->truesize -= frag->truesize;
+				truesizes += frag->truesize;
 			}
 		}
 
@@ -496,6 +497,7 @@ int ip_fragment(struct sk_buff *skb, int
 		frag = skb_shinfo(skb)->frag_list;
 		skb_shinfo(skb)->frag_list = NULL;
 		skb->data_len = first_len - skb_headlen(skb);
+		skb->truesize -= truesizes;
 		skb->len = first_len;
 		iph->tot_len = htons(first_len);
 		iph->frag_off = htons(IP_MF);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -609,6 +609,7 @@ static int ip6_fragment(struct sk_buff *
 
 	if (skb_shinfo(skb)->frag_list) {
 		int first_len = skb_pagelen(skb);
+		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -631,7 +632,7 @@ static int ip6_fragment(struct sk_buff *
 				sock_hold(skb->sk);
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				skb->truesize -= frag->truesize;
+				truesizes += frag->truesize;
 			}
 		}
 
@@ -662,6 +663,7 @@ static int ip6_fragment(struct sk_buff *
 
 		first_len = skb_pagelen(skb);
 		skb->data_len = first_len - skb_headlen(skb);
+		skb->truesize -= truesizes;
 		skb->len = first_len;
 		ipv6_hdr(skb)->payload_len = htons(first_len -
 						   sizeof(struct ipv6hdr));

-- 
