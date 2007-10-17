Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbXJQKT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbXJQKT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXJQKTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:19:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbXJQKTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:19:19 -0400
Date: Wed, 17 Oct 2007 12:18:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: [patch] forcedeth: fix the NAPI poll function, take #2
Message-ID: <20071017101823.GA4573@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <47152B32.9020905@pobox.com> <20071017072551.GD18044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017072551.GD18044@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll send upstream today unless people scream...

albeit you forgot to merge half of my patch :-/ The (tested) patch below 
fixes that.

	Ingo

---------------->
Subject: forcedeth: fix rx-work condition in nv_rx_process_optimized() too
From: Ingo Molnar <mingo@elte.hu>

the merge of my previous fix to forcedeth.c lots an important hunk.

this patch fixes that.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/forcedeth.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/net/forcedeth.c
===================================================================
--- linux.orig/drivers/net/forcedeth.c
+++ linux/drivers/net/forcedeth.c
@@ -2408,13 +2408,13 @@ static int nv_rx_process_optimized(struc
 	struct fe_priv *np = netdev_priv(dev);
 	u32 flags;
 	u32 vlanflags = 0;
-	u32 rx_processed_cnt = 0;
+	int rx_work = 0;
 	struct sk_buff *skb;
 	int len;
 
 	while((np->get_rx.ex != np->put_rx.ex) &&
 	      !((flags = le32_to_cpu(np->get_rx.ex->flaglen)) & NV_RX2_AVAIL) &&
-	      (rx_processed_cnt++ < limit)) {
+	      (rx_work < limit)) {
 
 		dprintk(KERN_DEBUG "%s: nv_rx_process_optimized: flags 0x%x.\n",
 					dev->name, flags);
@@ -2517,9 +2517,11 @@ next_pkt:
 			np->get_rx.ex = np->first_rx.ex;
 		if (unlikely(np->get_rx_ctx++ == np->last_rx_ctx))
 			np->get_rx_ctx = np->first_rx_ctx;
+
+		rx_work++;
 	}
 
-	return rx_processed_cnt;
+	return rx_work;
 }
 
 static void set_bufsize(struct net_device *dev)
