Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYCJOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYCJOmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYCJOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:42:37 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:49618 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYCJOmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:42:36 -0400
Date: Mon, 10 Mar 2008 23:43:06 +0900 (JST)
Message-Id: <20080310.234306.15242180.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [PATCH] at73c213: Fix DMA size at the end of DMA buffer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt handler always provide runtime->period_size data, but it
should provide additional residual data when the pointer back to zero.

This patch fixes periodic click noise when runtime->buffer_size was
not multiple of runtime->period_size.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch depends on a patch titled "at73c213: Monaural support".

diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 7c077c6..d614a8c 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -355,6 +355,7 @@ static irqreturn_t snd_at73c213_interrupt(int irq, void *dev_id)
 	u32 status;
 	int offset;
 	int block_size;
+	int size;
 	int next_period;
 	int retval = IRQ_NONE;
 
@@ -372,11 +373,14 @@ static irqreturn_t snd_at73c213_interrupt(int irq, void *dev_id)
 			next_period = 0;
 
 		offset = block_size * next_period;
+		size = runtime->period_size * runtime->channels;
+		if (next_period == runtime->periods - 1)
+			size += (runtime->buffer_size % runtime->period_size)
+				* runtime->channels;
 
 		ssc_writel(chip->ssc->regs, PDC_TNPR,
 				(long)runtime->dma_addr + offset);
-		ssc_writel(chip->ssc->regs, PDC_TNCR,
-				runtime->period_size * runtime->channels);
+		ssc_writel(chip->ssc->regs, PDC_TNCR, size);
 		retval = IRQ_HANDLED;
 	}
 
