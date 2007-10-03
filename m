Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbXJCPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbXJCPuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXJCPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:50:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47433 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXJCPuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:50:40 -0400
Subject: [PATCH] net: fix race in process_backlog
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Dike <jdike@addtoit.com>, David Miller <davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 17:44:53 +0200
Message-Id: <1191426293.5599.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: net: fix race in process_backlog

The recent NAPI rework (4fa57c9ea9f36f9ca852f3a88ca5d2f1aebbc960)
introduced a race between netif_rx() and process_backlog() which
resulted in softirq processing to drop dead.

netif_rx()		process_backlog()

			irq_disable();
			skb = __skb_dequeue();
			irq_enable();

irq_disable();
__skb_queue_tail();
napi_schedule();
irq_enable();

			if (!skb)
			  napi_complete();  <-- oops!

we cleared the napi bit, even though there is data to process.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/net/core/dev.c
===================================================================
--- linux-2.6.orig/net/core/dev.c
+++ linux-2.6/net/core/dev.c
@@ -2095,11 +2095,11 @@ static int process_backlog(struct napi_s
 
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
-		local_irq_enable();
 		if (!skb) {
-			napi_complete(napi);
+			__napi_complete(napi);
 			break;
 		}
+		local_irq_enable();
 
 		dev = skb->dev;
 


