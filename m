Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbXGaIvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbXGaIvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXGaIvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:51:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXGaIva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:51:30 -0400
Date: Tue, 31 Jul 2007 10:51:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Matt Barber <brbrofsvl@gmail.com>
Subject: Re: [Fwd: [PlanetCCRMA] atl1 driver; sleeping function]
Message-ID: <20070731085122.GC14758@elte.hu>
References: <1185852942.32478.3.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185852942.32478.3.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> Hi Ingo, I'm forwading this report from a Planet CCRMA user, this is 
> happening to him with 2.6.21.6-rt21...

thanks!

> BUG: sleeping function called from invalid context IRQ-219(2243) at
> kernel/rtmutex.c:613
> in_atomic():0 [00000000], irqs_disabled():1
>  [<c0405f88>] dump_trace+0x64/0x105
>  [<c0406041>] show_trace_log_lvl+0x18/0x2c
>  [<c040664e>] show_trace+0xf/0x11
>  [<c04066cf>] dump_stack+0x12/0x14
>  [<c060511d>] __rt_spin_lock+0x21/0x3d
>  [<f8a20e0c>] atl1_xmit_frame+0x66f/0x6c6 [atl1]
>  [<c05a3d96>] dev_hard_start_xmit+0x1c6/0x225
>  [<c05b29bd>] __qdisc_run+0xb7/0x1cf

could you try the patch below, does it fix the problem? The atl1 driver 
uses raw irq flags in combination with a spinlock that is a sleeping 
lock on -rt. (this is valid code on upstream, fortunately the -rt fix is 
also a cleanup and a small code reduction enhancement on upstream, so 
there's no problem pushing such fixes upstream.)

	Ingo

--------------------------->
Subject: [patch] drivers/net/atl1/atl1_main.c: use spin_trylock_irqsave()
From: Ingo Molnar <mingo@elte.hu>

use the simpler spin_trylock_irqsave() API to get the adapter lock.

[ this is also a fix for -rt where adapter->lock is a sleeping lock. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/atl1/atl1_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-rt-rebase.q/drivers/net/atl1/atl1_main.c
===================================================================
--- linux-rt-rebase.q.orig/drivers/net/atl1/atl1_main.c
+++ linux-rt-rebase.q/drivers/net/atl1/atl1_main.c
@@ -1704,10 +1704,8 @@ static int atl1_xmit_frame(struct sk_buf
 		}
 	}
 
-	local_irq_save(flags);
-	if (!spin_trylock(&adapter->lock)) {
+	if (!spin_trylock_irqsave(&adapter->lock, flags)) {
 		/* Can't get lock - tell upper layer to requeue */
-		local_irq_restore(flags);
 		dev_printk(KERN_DEBUG, &adapter->pdev->dev, "tx locked\n");
 		return NETDEV_TX_LOCKED;
 	}
