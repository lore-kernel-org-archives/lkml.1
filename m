Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXB0LcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXB0LcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXB0LcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:32:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030589AbXB0LcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:32:15 -0500
Date: Tue, 27 Feb 2007 12:25:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: regression: forcedeth.c hang
Message-ID: <20070227112521.GA9440@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175247.GB12392@stusta.de> <20070227083918.GC30376@elte.hu> <20070227090106.GA2749@elte.hu> <20070227093817.GA5007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227093817.GA5007@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4575]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


update: Jeff sent me 3 pending forcedeth.c fixes, and they indeed fix 
the regression. The one that fixed it is:

----------------->
The napi poll routine was missing the call to the optimized rx process 
routine. This patch adds the missing call for the optimized path.

Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>

--- orig/drivers/net/forcedeth.c	2007-02-20 03:17:21.000000000 -0500
+++ new/drivers/net/forcedeth.c	2007-02-20 03:28:31.000000000 -0500
@@ -3104,13 +3104,17 @@
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 	unsigned long flags;
+	int retcode;
 
-	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
+	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		pkts = nv_rx_process(dev, limit);
-	else
+		retcode = nv_alloc_rx(dev);
+	} else {
 		pkts = nv_rx_process_optimized(dev, limit);
+		retcode = nv_alloc_rx_optimized(dev);
+	}
 
-	if (nv_alloc_rx(dev)) {
+	if (retcode) {
 		spin_lock_irqsave(&np->lock, flags);
 		if (!np->in_shutdown)
 			mod_timer(&np->oom_kick, jiffies + OOM_REFILL);

