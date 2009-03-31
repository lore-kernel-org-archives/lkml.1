Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbZCaXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbZCaXUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758657AbZCaXUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:14 -0400
Received: from sous-sol.org ([216.99.217.87]:33096 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756929AbZCaXUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:11 -0400
Message-Id: <20090331231351.257583814@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:50 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       David S Miller <davem@davemloft.net>
Subject: [patch 05/45] GRO: Disable GRO on legacy netif_rx path
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=gro-disable-gro-on-legacy-netif_rx-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8f1ead2d1a626ed0c85b3d2c2046a49081d5933f ]

When I fixed the GRO crash in the legacy receive path I used
napi_complete to replace __napi_complete.  Unfortunately they're
not the same when NETPOLL is enabled, which may result in us
not calling __napi_complete at all.

What's more, we really do need to keep the __napi_complete call
within the IRQ-off section since in theory an IRQ can occur in
between and fill up the backlog to the maximum, causing us to
lock up.

Since we can't seem to find a fix that works properly right now,
this patch reverts all the GRO support from the netif_rx path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/core/dev.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2588,18 +2588,15 @@ static int process_backlog(struct napi_s
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
+			__napi_complete(napi);
 			local_irq_enable();
-			napi_complete(napi);
-			goto out;
+			break;
 		}
 		local_irq_enable();
 
-		napi_gro_receive(napi, skb);
+		netif_receive_skb(skb);
 	} while (++work < quota && jiffies == start_time);
 
-	napi_gro_flush(napi);
-
-out:
 	return work;
 }
 

