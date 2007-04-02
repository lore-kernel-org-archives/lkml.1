Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXDBL44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXDBL44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbXDBL44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:56:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975AbXDBL4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:56:55 -0400
Date: Mon, 2 Apr 2007 13:56:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] forcedeth: improve NAPI logic
Message-ID: <20070402115650.GA1703@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326083146.GA11666@elte.hu> <20070326083920.GA14648@elte.hu> <20070326085856.GA18067@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326085856.GA18067@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] forcedeth.c: improve NAPI handler

another forcedeth.c thing: i noticed that its NAPI handler does not do 
tx-ring processing. The patch below implements this - tested on 
DESC_VER_2 hardware, with CONFIG_FORCEDETH_NAPI=y.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/drivers/net/forcedeth.c
===================================================================
--- linux.orig/drivers/net/forcedeth.c
+++ linux/drivers/net/forcedeth.c
@@ -3118,9 +3118,17 @@ static int nv_napi_poll(struct net_devic
 	int retcode;
 
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done(dev);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process(dev, limit);
 		retcode = nv_alloc_rx(dev);
 	} else {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done_optimized(dev, np->tx_ring_size);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process_optimized(dev, limit);
 		retcode = nv_alloc_rx_optimized(dev);
 	}
