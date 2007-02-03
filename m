Return-Path: <linux-kernel-owner+w=401wt.eu-S1946295AbXBCCpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946295AbXBCCpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946285AbXBCCpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:45:01 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36755 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946280AbXBCCow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:44:52 -0500
Message-Id: <20070203024640.155006000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:57 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Jarek Poplawski <jarkao2@o2.pl>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 53/59] TCP: rare bad TCP checksum with 2.6.19
Content-Disposition: inline; filename=tcp-rare-bad-tcp-checksum-with-2.6.19.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Jarek Poplawski <jarkao2@o2.pl>

The patch "Replace CHECKSUM_HW by CHECKSUM_PARTIAL/CHECKSUM_COMPLETE"
changed to unconditional copying of ip_summed field from collapsed
skb. This patch reverts this change.

The majority of substantial work including heavy testing
and diagnosing by: Michael Tokarev <mjt@tls.msk.ru>
Possible reasons pointed by: Herbert Xu and Patrick McHardy.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.19.2.orig/net/ipv4/tcp_output.c
+++ linux-2.6.19.2/net/ipv4/tcp_output.c
@@ -1590,7 +1590,8 @@ static void tcp_retrans_try_collapse(str
 
 		memcpy(skb_put(skb, next_skb_size), next_skb->data, next_skb_size);
 
-		skb->ip_summed = next_skb->ip_summed;
+		if (next_skb->ip_summed == CHECKSUM_PARTIAL)
+			skb->ip_summed = CHECKSUM_PARTIAL;
 
 		if (skb->ip_summed != CHECKSUM_PARTIAL)
 			skb->csum = csum_block_add(skb->csum, next_skb->csum, skb_size);

--
