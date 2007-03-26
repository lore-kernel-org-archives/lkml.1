Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXCZI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXCZI7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbXCZI7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:59:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666AbXCZI7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:59:17 -0400
Date: Mon, 26 Mar 2007 10:58:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] forcedeth: work around NULL skb dereference crash
Message-ID: <20070326085856.GA18067@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326083146.GA11666@elte.hu> <20070326083920.GA14648@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326083920.GA14648@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > my first quick guess was to extend np->priv locking to the whole of 
> > nv_start_xmit/nv_start_xmit_optimized - while that appeared to make 
> > the crash a bit less likely, it did not prevent it. So there must be 
> > some other, more fundamental problem be left as well. At first 
> > glance the SMP locking looks OK, so maybe the ring indices are 
> > messed up somehow and we got into a 'ring head bites the tail' 
> > scenario?
> 
> to be specific, the patch below is what i tried - but it didnt 
> completely fix the crash.

the patch below works the crash around. It does not seem to be a 'tx 
ring head bits the tail' scenario:

 get_tx: 55, put_tx: 57
 get_tx: 80, put_tx: 86
 get_tx: 88, put_tx: 97
 get_tx: 97, put_tx: 109
 get_tx: 97, put_tx: 109
 get_tx: 111, put_tx: 117
 get_tx: 117, put_tx: 125
 get_tx: 127, put_tx: 137
 get_tx: 137, put_tx: 147
 get_tx: 147, put_tx: 149

	Ingo

------------>
From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] forcedeth: work around NULL skb dereference crash

work around a NULL skb dereference crash that occurs during high load.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/forcedeth.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/drivers/net/forcedeth.c
===================================================================
--- linux.orig/drivers/net/forcedeth.c
+++ linux/drivers/net/forcedeth.c
@@ -1902,6 +1902,11 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
@@ -1917,6 +1922,11 @@ static void nv_tx_done(struct net_device
 						np->stats.tx_carrier_errors++;
 					np->stats.tx_errors++;
 				} else {
+					if (!np->get_tx_ctx->skb) {
+						printk("get_tx: %ld, put_tx: %ld\n", np->get_tx_ctx - np->first_tx_ctx, np->put_tx_ctx - np->first_tx_ctx);
+						WARN_ON(1);
+						break;
+					}
 					np->stats.tx_packets++;
 					np->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
