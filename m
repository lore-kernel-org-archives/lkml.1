Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZHMUN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZHMUN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZHMT7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:19 -0400
Received: from kroah.org ([198.145.64.141]:41655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbZHMT7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195125.923244268@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 09/74] gro: Flush GRO packets in napi_disable_pending path
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=gro-flush-gro-packets-in-napi_disable_pending-path.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ff780cd8f2fa928b193554f593b36d1243554212 ]

When NAPI is disabled while we're in net_rx_action, we end up
calling __napi_complete without flushing GRO packets.  This is
a bug as it would cause the GRO packets to linger, of course it
also literally BUGs to catch error like this :)

This patch changes it to napi_complete, with the obligatory IRQ
reenabling.  This should be safe because we've only just disabled
IRQs and it does not materially affect the test conditions in
between.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2788,9 +2788,11 @@ static void net_rx_action(struct softirq
 		 * move the instance around on the list at-will.
 		 */
 		if (unlikely(work == weight)) {
-			if (unlikely(napi_disable_pending(n)))
-				__napi_complete(n);
-			else
+			if (unlikely(napi_disable_pending(n))) {
+				local_irq_enable();
+				napi_complete(n);
+				local_irq_disable();
+			} else
 				list_move_tail(&n->poll_list, list);
 		}
 


