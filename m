Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYL2Ffa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYL2Ffa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYL2FfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:35:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYL2FfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:35:21 -0500
Message-ID: <4958618F.9060001@cn.fujitsu.com>
Date: Mon, 29 Dec 2008 13:35:11 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de
Subject: [PATCH -tip] irq: check chip->ack before calling (WAS: irq: remove
 unneeded desc->chip->ack check)
References: <4954A02B.4060606@cn.fujitsu.com> <20081226132730.GA29265@elte.hu>
In-Reply-To: <20081226132730.GA29265@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar said the following on 2008-12-26 21:27:
> * Wang Chen <wangchen@cn.fujitsu.com> wrote:
> 
>> desc->chip->ack is initialized to ack_bad().
>> It will not be NULL.
> 
> hm, that is only true of no_irq_chip() - is it true of all irq_chip 
> definitions on all architectures?
> 

No, some arch's irq_chip doesn't have ack routine.
So I was wrong.
But this enlighten another thought that generic irq layer doesn't know
whether irq_chip has ack routine on some architectures.
Upon that, before calling chip->ack, should check it's not NULL.

Impact: fix theoretic NULL dereference

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f63c706..9a7fbb8 100644
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
