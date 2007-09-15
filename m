Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXIOTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXIOTjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXIOTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:39:24 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:13610 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXIOTjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CTv5OKqwXBBjD7qlFrFOW2nFlFWTbatrPfTglZ1oJaz96Khf2wPgUozm9M4+wWwHxjzWU4CTwlkVV2vgliRuBReo6y9lxiQYq9FmAe2UJlsBJ8mCT34JTqzoYCO/ygVTr2zrcpZl9m9Ax0U9WTxD8yXq0wAnTO8M3IFK9KIj+Hc=
Message-ID: <8b67d60709151239w2f983e74t9a36eb0c566e09cc@mail.gmail.com>
Date: Sat, 15 Sep 2007 20:39:21 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, alsa-devel-request@alsa-project.org,
       linuxsh-dev@lists.sourceforge.net
Subject: [PATCH] Dreamcast AICA sound driver G2 bus handling
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch handles instability on the Dreamcast G2 bus while PIO or
DMA is underway on the System -> AICA channel.

Without the suspension of interrupts when PIO or DMA is underway the
G2 bus is prone to timeouts leading to seemingly random crashes. This
is particularly visible in cases such as maple bus (see
http://lkml.org/lkml/2007/9/15/181) hotplugging but the patch is good
for all conditions.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 7397865..54aed1d 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -35,6 +35,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/maple.h>
 #include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/control.h>
@@ -43,7 +44,8 @@
 #include <sound/info.h>
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <asm/dreamcast/sysasic.h>
+#include <asm/mach/sysasic.h>
+#include <asm/mach/maple.h>
 #include "aica.h"

 MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
@@ -106,11 +108,14 @@ static void spu_write_wait(void)
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
@@ -118,6 +123,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 /* spu_memload - write to SPU address space */
 static void spu_memload(u32 toi, void *from, int length)
 {
+	unsigned long flags;
 	u32 *froml = from;
 	u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
 	int i;
@@ -128,7 +134,9 @@ static void spu_memload(u32 toi, void *from, int length)
 		if (!(i % 8))
 			spu_write_wait();
 		val = *froml;
+		local_irq_save(flags);
 		writel(val, to);
+		local_irq_restore(flags);
 		froml++;
 		to++;
 	}
@@ -138,28 +146,36 @@ static void spu_memload(u32 toi, void *from, int length)
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
@@ -178,15 +194,21 @@ static void spu_reset(void)
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
@@ -211,6 +233,7 @@ static int aica_dma_transfer(int channels, int buffer_size,
 			     struct snd_pcm_substream *substream)
 {
 	int q, err, period_offset;
+	unsigned long flags;
 	struct snd_card_aica *dreamcastcard;
 	struct snd_pcm_runtime *runtime;
 	err = 0;
@@ -218,6 +241,7 @@ static int aica_dma_transfer(int channels, int buffer_size,
 	period_offset = dreamcastcard->clicks;
 	period_offset %= (AICA_PERIOD_NUMBER / channels);
 	runtime = substream->runtime;
+	local_irq_save(flags);	
 	for (q = 0; q < channels; q++) {
 		err = dma_xfer(AICA_DMA_CHANNEL,
 			       (unsigned long) (runtime->dma_area +
@@ -232,6 +256,7 @@ static int aica_dma_transfer(int channels, int buffer_size,
 			break;
 		dma_wait_for_completion(AICA_DMA_CHANNEL);
 	}
+	local_irq_restore(flags);
 	return err;
 }

@@ -277,18 +302,21 @@ static void aica_period_elapsed(unsigned long timer_var)
 {
 	/*timer function - so cannot sleep */
 	int play_period;
+	unsigned long flags;
 	struct snd_pcm_runtime *runtime;
 	struct snd_pcm_substream *substream;
 	struct snd_card_aica *dreamcastcard;
 	substream = (struct snd_pcm_substream *) timer_var;
 	runtime = substream->runtime;
 	dreamcastcard = substream->pcm->private_data;
-	/* Have we played out an additional period? */
+	local_irq_save(flags);
+	/* now check if additional period has been played */
 	play_period =
 	    frames_to_bytes(runtime,
 			    readl
 			    (AICA_CONTROL_CHANNEL_SAMPLE_NUMBER)) /
 	    AICA_PERIOD_SIZE;
+	local_irq_restore(flags);
 	if (play_period == dreamcastcard->current_period) {
 		/* reschedule the timer */
 		mod_timer(&(dreamcastcard->timer), jiffies + 1);
@@ -433,7 +461,7 @@ static int __init snd_aicapcmchip(struct snd_card_aica
 	err =
 	    snd_pcm_new(dreamcastcard->card, "AICA PCM", pcm_index, 1, 0,
 			&pcm);
-	if (unlikely(err < 0))
+	if (err < 0)
 		return err;
 	pcm->private_data = dreamcastcard;
 	strcpy(pcm->name, "AICA PCM");
@@ -493,7 +521,7 @@ static int aica_pcmvolume_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard = kcontrol->private_data;
-	if (unlikely(!dreamcastcard->channel))
+	if (!dreamcastcard->channel)
 		return -ETXTBSY;	/* we've not yet been set up */
 	ucontrol->value.integer.value[0] = dreamcastcard->channel->vol;
 	return 0;
@@ -504,10 +532,10 @@ static int aica_pcmvolume_put(struct
snd_kcontrol *kcontrol,
 {
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard = kcontrol->private_data;
-	if (unlikely(!dreamcastcard->channel))
+	if (!dreamcastcard->channel)
 		return -ETXTBSY;
-	if (unlikely(dreamcastcard->channel->vol ==
-		     ucontrol->value.integer.value[0]))
+	if (dreamcastcard->channel->vol ==
+		     ucontrol->value.integer.value[0])
 		return 0;
 	dreamcastcard->channel->vol = ucontrol->value.integer.value[0];
 	dreamcastcard->master_volume = ucontrol->value.integer.value[0];
@@ -537,15 +565,18 @@ static struct snd_kcontrol_new
snd_aica_pcmvolume_control __devinitdata = {
 static int load_aica_firmware(void)
 {
 	int err;
+	unsigned long flags;
 	const struct firmware *fw_entry;
 	spu_reset();
 	err = request_firmware(&fw_entry, "aica_firmware.bin", &pd->dev);
-	if (unlikely(err))
+	if (err)
 		return err;
 	/* write firware into memory */
+	local_irq_save(flags);
 	spu_disable();
 	spu_memload(0, fw_entry->data, fw_entry->size);
 	spu_enable();
+	local_irq_restore(flags);
 	release_firmware(fw_entry);
 	return err;
 }
@@ -557,12 +588,12 @@ static int __devinit
add_aicamixer_controls(struct snd_card_aica
 	err = snd_ctl_add
 	    (dreamcastcard->card,
 	     snd_ctl_new1(&snd_aica_pcmvolume_control, dreamcastcard));
-	if (unlikely(err < 0))
+	if (err < 0)
 		return err;
 	err = snd_ctl_add
 	    (dreamcastcard->card,
 	     snd_ctl_new1(&snd_aica_pcmswitch_control, dreamcastcard));
-	if (unlikely(err < 0))
+	if (err < 0)
 		return err;
 	return 0;
 }
@@ -571,7 +602,7 @@ static int snd_aica_remove(struct platform_device *devptr)
 {
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard = platform_get_drvdata(devptr);
-	if (unlikely(!dreamcastcard))
+	if (!dreamcastcard)
 		return -ENODEV;
 	snd_card_free(dreamcastcard->card);
 	kfree(dreamcastcard);
@@ -584,11 +615,11 @@ static int __init snd_aica_probe(struct
platform_device *devptr)
 	int err;
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard = kmalloc(sizeof(struct snd_card_aica), GFP_KERNEL);
-	if (unlikely(!dreamcastcard))
+	if (!dreamcastcard)
 		return -ENOMEM;
 	dreamcastcard->card =
 	    snd_card_new(index, SND_AICA_DRIVER, THIS_MODULE, 0);
-	if (unlikely(!dreamcastcard->card)) {
+	if (!dreamcastcard->card) {
 		kfree(dreamcastcard);
 		return -ENODEV;
 	}
@@ -600,27 +631,28 @@ static int __init snd_aica_probe(struct
platform_device *devptr)
 	INIT_WORK(&(dreamcastcard->spu_dma_work), run_spu_dma);
 	/* Load the PCM 'chip' */
 	err = snd_aicapcmchip(dreamcastcard, 0);
-	if (unlikely(err < 0))
+	if (err < 0)
 		goto freedreamcast;
 	snd_card_set_dev(dreamcastcard->card, &devptr->dev);
 	dreamcastcard->timer.data = 0;
 	dreamcastcard->channel = NULL;
 	/* Add basic controls */
 	err = add_aicamixer_controls(dreamcastcard);
-	if (unlikely(err < 0))
+	if (err < 0)
 		goto freedreamcast;
 	/* Register the card with ALSA subsystem */
 	err = snd_card_register(dreamcastcard->card);
-	if (unlikely(err < 0))
+	if (err < 0)
 		goto freedreamcast;
 	platform_set_drvdata(devptr, dreamcastcard);
 	aica_queue = create_workqueue(CARD_NAME);
-	if (unlikely(!aica_queue))
+	if (!aica_queue)
 		goto freedreamcast;
 	snd_printk
 	    ("ALSA Driver for Yamaha AICA Super Intelligent Sound Processor\n");
 	return 0;
-      freedreamcast:
+
+freedreamcast:
 	snd_card_free(dreamcastcard->card);
 	kfree(dreamcastcard);
 	return err;
@@ -637,11 +669,11 @@ static int __init aica_init(void)
 {
 	int err;
 	err = platform_driver_register(&snd_aica_driver);
-	if (unlikely(err < 0))
+	if (err < 0)
 		return err;
 	pd = platform_device_register_simple(SND_AICA_DRIVER, -1,
 					     aica_memory_space, 2);
-	if (unlikely(IS_ERR(pd))) {
+	if (IS_ERR(pd)) {
 		platform_driver_unregister(&snd_aica_driver);
 		return PTR_ERR(pd);
 	}
@@ -653,7 +685,7 @@ static void __exit aica_exit(void)
 {
 	/* Destroy the aica kernel thread            *
 	 * being extra cautious to check if it exists*/
-	if (likely(aica_queue))
+	if (aica_queue)
 		destroy_workqueue(aica_queue);
 	platform_device_unregister(pd);
 	platform_driver_unregister(&snd_aica_driver);
