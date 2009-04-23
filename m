Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbZDWIBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbZDWIBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZDWHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:37:14 -0400
Received: from sous-sol.org ([216.99.217.87]:47516 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757749AbZDWHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:37:12 -0400
Message-Id: <20090423073106.661943296@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 095/100] gso: Fix support for linear packets
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=gso-fix-support-for-linear-packets.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

upstream commit: 2f181855a0b3c2b39314944add7b41c15647cf86

When GRO/frag_list support was added to GSO, I made an error
which broke the support for segmenting linear GSO packets (GSO
packets are normally non-linear in the payload).

These days most of these packets are constructed by the tun
driver, which prefers to allocate linear memory if possible.
This is fixed in the latest kernel, but for 2.6.29 and earlier
it is still the norm.

Therefore this bug causes failures with GSO when used with tun
in 2.6.29.

Reported-by: James Huang <jamesclhuang@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2496,7 +2496,7 @@ struct sk_buff *skb_segment(struct sk_bu
 					  skb_network_header_len(skb));
 		skb_copy_from_linear_data(skb, nskb->data, doffset);
 
-		if (pos >= offset + len)
+		if (fskb != skb_shinfo(skb)->frag_list)
 			continue;
 
 		if (!sg) {

