Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbXJQUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbXJQUam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJQUab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:30:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:37553 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbXJQUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f3Vkob8EDOy8K0KGAulcmky/ku0SqFKHLy0UjuesB0bhFKgGOA+3mGIRZbcou0zUOGKXbIV/dIgLUmLSPW+A8ShB5dLigvpYpBO1gqUh9I5DIm5xHMP4XkdB8CsfiAlHBj1mRQiBTs16cem5WpQqHL7daEkvuIkGFBDbkk/jrFE=
Message-ID: <8b67d60710171330n55b9b575k949f3d239b380165@mail.gmail.com>
Date: Wed, 17 Oct 2007 21:30:28 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: alsa-devel@alsa-project.org
Subject: [PATCH] ALSA - protect Dreamcast PCM driver (AICA) from G2 bus effects
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The G2 bus on the SEGA Dreamcast connects both the maple peripheral
bus and the AICA sound memory. DMA requests on one can cause the other
to timeout on memory operations.

This patch prevents maple interrupts from causing hiccoughs in the
AICA sound (maple bus code will land in 2.6.24).

There are other cleanups for this (AICA) code - but this is in effect
a regression fix rather than a cleanup.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 7397865..407981d 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -106,11 +106,14 @@ static void spu_write_wait(void)
 static void spu_memset(u32 toi, u32 what, int length)
 {
 	int i;
+	unsigned long flags;
 	snd_assert(length % 4 == 0, return);
 	for (i = 0; i < length; i++) {
 		if (!(i % 8))
 			spu_write_wait();
+		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
+		local_irq_restore(flags);
 		toi++;
 	}
 }
@@ -118,6 +121,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 /* spu_memload - write to SPU address space */
 static void spu_memload(u32 toi, void *from, int length)
 {
+	unsigned long flags;
 	u32 *froml = from;
 	u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
 	int i;
@@ -128,7 +132,9 @@ static void spu_memload(u32 toi, void *from, int length)
 		if (!(i % 8))
 			spu_write_wait();
 		val = *froml;
+		local_irq_save(flags);
 		writel(val, to);
+		local_irq_restore(flags);
 		froml++;
 		to++;
 	}
@@ -138,28 +144,36 @@ static void spu_memload(u32 toi, void *from, int length)
 static void spu_disable(void)
 {
 	int i;
+	unsigned long flags;
 	u32 regval;
 	spu_write_wait();
 	regval = readl(ARM_RESET_REGISTER);
 	regval |= 1;
 	spu_write_wait();
+	local_irq_save(flags);
 	writel(regval, ARM_RESET_REGISTER);
+	local_irq_restore(flags);
 	for (i = 0; i < 64; i++) {
 		spu_write_wait();
 		regval = readl(SPU_REGISTER_BASE + (i * 0x80));
 		regval = (regval & ~0x4000) | 0x8000;
 		spu_write_wait();
+		local_irq_save(flags);
 		writel(regval, SPU_REGISTER_BASE + (i * 0x80));
+		local_irq_restore(flags);
 	}
 }

 /* spu_enable - set spu registers to enable sound output */
 static void spu_enable(void)
 {
+	unsigned long flags;
 	u32 regval = readl(ARM_RESET_REGISTER);
 	regval &= ~1;
 	spu_write_wait();
+	local_irq_save(flags);
 	writel(regval, ARM_RESET_REGISTER);
+	local_irq_restore(flags);
 }

 /*
@@ -168,25 +182,34 @@ static void spu_enable(void)
 */
 static void spu_reset(void)
 {
+	unsigned long flags;
 	spu_disable();
 	spu_memset(0, 0, 0x200000 / 4);
 	/* Put ARM7 in endless loop */
+	local_irq_save(flags);
 	ctrl_outl(0xea000002, SPU_MEMORY_BASE);
+	local_irq_restore(flags);
 	spu_enable();
 }

 /* aica_chn_start - write to spu to start playback */
 static void aica_chn_start(void)
 {
+	unsigned long flags;
 	spu_write_wait();
+	local_irq_save(flags);
 	writel(AICA_CMD_KICK | AICA_CMD_START, (u32 *) AICA_CONTROL_POINT);
+	local_irq_restore(flags);
 }

 /* aica_chn_halt - write to spu to halt playback */
 static void aica_chn_halt(void)
 {
+	unsigned long flags;
 	spu_write_wait();
+	local_irq_save(flags);
 	writel(AICA_CMD_KICK | AICA_CMD_STOP, (u32 *) AICA_CONTROL_POINT);
+	local_irq_restore(flags);
 }

 /* ALSA code below */
@@ -213,12 +236,13 @@ static int aica_dma_transfer(int channels, int
buffer_size,
 	int q, err, period_offset;
 	struct snd_card_aica *dreamcastcard;
 	struct snd_pcm_runtime *runtime;
-	err = 0;
+	unsigned long flags;
 	dreamcastcard = substream->pcm->private_data;
 	period_offset = dreamcastcard->clicks;
 	period_offset %= (AICA_PERIOD_NUMBER / channels);
 	runtime = substream->runtime;
 	for (q = 0; q < channels; q++) {
+		local_irq_save(flags);
 		err = dma_xfer(AICA_DMA_CHANNEL,
 			       (unsigned long) (runtime->dma_area +
 						(AICA_BUFFER_SIZE * q) /
@@ -228,9 +252,12 @@ static int aica_dma_transfer(int channels, int buffer_size,
 			       AICA_CHANNEL0_OFFSET + q * CHANNEL_OFFSET +
 			       AICA_PERIOD_SIZE * period_offset,
 			       buffer_size / channels, AICA_DMA_MODE);
-		if (unlikely(err < 0))
+		if (unlikely(err < 0)) {
+			local_irq_restore(flags);
 			break;
+		}
 		dma_wait_for_completion(AICA_DMA_CHANNEL);
+		local_irq_restore(flags);
 	}
 	return err;
 }
