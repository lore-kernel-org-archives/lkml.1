Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYBWAmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYBWAmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYBWAet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934853AbYBWAer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:47 -0500
Date: Fri, 22 Feb 2008 16:30:39 -0800
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
Subject: [patch 18/38] IPCOMP: Fetch nexthdr before ipch is destroyed
Message-ID: <20080223003039.GS7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipcomp-fetch-nexthdr-before-ipch-is-destroyed.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 2614fa59fa805cd488083c5602eb48533cdbc018

When I moved the nexthdr setting out of IPComp I accidently moved
the reading of ipch->nexthdr after the decompression.  Unfortunately
this means that we'd be reading from a stale ipch pointer which
doesn't work very well.

This patch moves the reading up so that we get the correct nexthdr
value.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipcomp.c  |    5 ++++-
 net/ipv6/ipcomp6.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -74,6 +74,7 @@ out:
 
 static int ipcomp_input(struct xfrm_state *x, struct sk_buff *skb)
 {
+	int nexthdr;
 	int err = -ENOMEM;
 	struct ip_comp_hdr *ipch;
 
@@ -84,13 +85,15 @@ static int ipcomp_input(struct xfrm_stat
 
 	/* Remove ipcomp header and decompress original payload */
 	ipch = (void *)skb->data;
+	nexthdr = ipch->nexthdr;
+
 	skb->transport_header = skb->network_header + sizeof(*ipch);
 	__skb_pull(skb, sizeof(*ipch));
 	err = ipcomp_decompress(x, skb);
 	if (err)
 		goto out;
 
-	err = ipch->nexthdr;
+	err = nexthdr;
 
 out:
 	return err;
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -64,6 +64,7 @@ static LIST_HEAD(ipcomp6_tfms_list);
 
 static int ipcomp6_input(struct xfrm_state *x, struct sk_buff *skb)
 {
+	int nexthdr;
 	int err = -ENOMEM;
 	struct ip_comp_hdr *ipch;
 	int plen, dlen;
@@ -79,6 +80,8 @@ static int ipcomp6_input(struct xfrm_sta
 
 	/* Remove ipcomp header and decompress original payload */
 	ipch = (void *)skb->data;
+	nexthdr = ipch->nexthdr;
+
 	skb->transport_header = skb->network_header + sizeof(*ipch);
 	__skb_pull(skb, sizeof(*ipch));
 
@@ -108,7 +111,7 @@ static int ipcomp6_input(struct xfrm_sta
 	skb->truesize += dlen - plen;
 	__skb_put(skb, dlen - plen);
 	skb_copy_to_linear_data(skb, scratch, dlen);
-	err = ipch->nexthdr;
+	err = nexthdr;
 
 out_put_cpu:
 	put_cpu();

-- 
