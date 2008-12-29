Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYL2LXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYL2LXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYL2LXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:23:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYL2LXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:23:41 -0500
Date: Mon, 29 Dec 2008 12:23:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH -tip] irq: check chip->ack before calling (WAS: irq:
	remove unneeded desc->chip->ack check)
Message-ID: <20081229112329.GC5065@elte.hu>
References: <4954A02B.4060606@cn.fujitsu.com> <20081226132730.GA29265@elte.hu> <4958618F.9060001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4958618F.9060001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang Chen <wangchen@cn.fujitsu.com> wrote:

> Ingo Molnar said the following on 2008-12-26 21:27:
> > * Wang Chen <wangchen@cn.fujitsu.com> wrote:
> > 
> >> desc->chip->ack is initialized to ack_bad().
> >> It will not be NULL.
> > 
> > hm, that is only true of no_irq_chip() - is it true of all irq_chip 
> > definitions on all architectures?
> > 
> 
> No, some arch's irq_chip doesn't have ack routine.
> So I was wrong.
> But this enlighten another thought that generic irq layer doesn't know
> whether irq_chip has ack routine on some architectures.
> Upon that, before calling chip->ack, should check it's not NULL.
> 
> Impact: fix theoretic NULL dereference
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>

applied to tip/irq/genirq, thanks!

(find below how the final commit message ended up looking like.)

	Ingo

------------------>
>From efdc64f0c792ea744bcc9203f35b908e66d42f41 Mon Sep 17 00:00:00 2001
From: Wang Chen <wangchen@cn.fujitsu.com>
Date: Mon, 29 Dec 2008 13:35:11 +0800
Subject: [PATCH] genirq: check chip->ack before calling

Impact: fix theoretical NULL dereference

The generic irq layer doesn't know whether irq_chip has ack routine on some
architectures or not. Upon that, before calling chip->ack, we should check
that it's not NULL.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6eb3c79..0ad02d7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -290,7 +290,8 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		desc->chip->mask_ack(irq);
 	else {
 		desc->chip->mask(irq);
-		desc->chip->ack(irq);
+		if (desc->chip->ack)
+			desc->chip->ack(irq);
 	}
 }
 
@@ -475,7 +476,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->chip->ack(irq);
+	if (desc->chip->ack)
+		desc->chip->ack(irq);
 	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/

