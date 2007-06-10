Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbXFJRZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbXFJRZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXFJRY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:24:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbXFJRY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:24:59 -0400
Date: Sun, 10 Jun 2007 19:24:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Lee Revell <rlrevell@gmail.com>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Message-ID: <20070610172452.GA7560@elte.hu>
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Mark Knecht <markknecht@gmail.com> wrote:

> 23:    1739277   IO-APIC-fasteoi   ohci_hcd:usb2, eth0

> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)

ok, that's forcedeth. Does that behavior go away if you revert the 
change below, via patch -p0 -R ?

but in general, -rt will track IRQ cpu usage accurately, while mainline 
does not measure it at all when in idle. So a frequent IRQ on mainline 
might be using up similar amounts of of CPU time as well, but it's not 
reported.

	Ingo

---
 drivers/net/forcedeth.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-rt.q/drivers/net/forcedeth.c
===================================================================
--- linux-rt.q.orig/drivers/net/forcedeth.c
+++ linux-rt.q/drivers/net/forcedeth.c
@@ -800,7 +800,7 @@ struct fe_priv {
  * Maximum number of loops until we assume that a bit in the irq mask
  * is stuck. Overridable with module param.
  */
-static int max_interrupt_work = 5;
+static int max_interrupt_work = 50;
 
 /*
  * Optimization can be either throuput mode or cpu mode
@@ -812,7 +812,7 @@ enum {
 	NV_OPTIMIZATION_MODE_THROUGHPUT,
 	NV_OPTIMIZATION_MODE_CPU
 };
-static int optimization_mode = NV_OPTIMIZATION_MODE_THROUGHPUT;
+static int optimization_mode = NV_OPTIMIZATION_MODE_CPU;
 
 /*
  * Poll interval for timer irq
@@ -3108,9 +3108,17 @@ static int nv_napi_poll(struct net_devic
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
