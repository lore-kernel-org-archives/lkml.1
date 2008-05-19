Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYESQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYESQiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYESQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:37:54 -0400
Received: from mail.aknet.ru ([78.158.192.26]:59064 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYESQhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:37:53 -0400
Message-ID: <4831ACCB.70302@aknet.ru>
Date: Mon, 19 May 2008 20:37:31 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] snd-pcsp: use HRTIMER_CB_SOFTIRQ
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------060802000806010403000900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060802000806010403000900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Change HRTIMER_CB_IRQSAFE to HRTIMER_CB_SOFTIRQ,
as suggested by Thomas Gleixner.
That solves the lock dependancy reported in
Bug #10701.
That also allows to call hrtimer_start()
directly, tasklet "stupid hack" removed.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------060802000806010403000900
Content-Type: text/x-patch;
 name="pcsp_lk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_lk.diff"

diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 54a1f90..1899cf0 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -96,7 +96,7 @@ static int __devinit snd_card_pcsp_probe(int devnum, struct device *dev)
 		return -EINVAL;
 
 	hrtimer_init(&pcsp_chip.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	pcsp_chip.timer.cb_mode = HRTIMER_CB_IRQSAFE;
+	pcsp_chip.timer.cb_mode = HRTIMER_CB_SOFTIRQ;
 	pcsp_chip.timer.function = pcsp_do_timer;
 
 	card = snd_card_new(index, id, THIS_MODULE, 0);
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index ac6238e..c30820d 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <sound/pcm.h>
-#include <linux/interrupt.h>
 #include <asm/io.h>
 #include "pcsp.h"
 
@@ -18,34 +17,8 @@ module_param(nforce_wa, bool, 0444);
 MODULE_PARM_DESC(nforce_wa, "Apply NForce chipset workaround "
 		"(expect bad sound)");
 
-static void pcsp_start_timer(unsigned long dummy)
-{
-	hrtimer_start(&pcsp_chip.timer, ktime_set(0, 0), HRTIMER_MODE_REL);
-}
-
-/*
- * We need the hrtimer_start as a tasklet to avoid
- * the nasty locking problem. :(
- * The problem:
- * - The timer handler is called with the cpu_base->lock
- *   already held by hrtimer code.
- * - snd_pcm_period_elapsed() takes the
- *   substream->self_group.lock.
- * So far so good.
- * But the snd_pcsp_trigger() is called with the
- * substream->self_group.lock held, and it calls
- * hrtimer_start(), which takes the cpu_base->lock.
- * You see the problem. We have the code pathes
- * which take two locks in a reverse order. This
- * can deadlock and the lock validator complains.
- * The only solution I could find was to move the
- * hrtimer_start() into a tasklet. -stsp
- */
-static DECLARE_TASKLET(pcsp_start_timer_tasklet, pcsp_start_timer, 0);
-
 enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 {
-	unsigned long flags;
 	unsigned char timer_cnt, val;
 	int periods_elapsed;
 	u64 ns;
@@ -64,9 +37,7 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 		return HRTIMER_RESTART;
 	}
 
-	/* hrtimer calls us from both hardirq and softirq contexts,
-	 * so irqsave :( */
-	spin_lock_irqsave(&chip->substream_lock, flags);
+	spin_lock_irq(&chip->substream_lock);
 	/* Takashi Iwai says regarding this extra lock:
 
 	If the irq handler handles some data on the DMA buffer, it should
@@ -132,7 +105,7 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 		chip->period_ptr %= buffer_bytes;
 	}
 
-	spin_unlock_irqrestore(&chip->substream_lock, flags);
+	spin_unlock_irq(&chip->substream_lock);
 
 	if (!atomic_read(&chip->timer_active))
 		return HRTIMER_NORESTART;
@@ -146,7 +119,7 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 exit_nr_unlock2:
 	snd_pcm_stream_unlock(substream);
 exit_nr_unlock1:
-	spin_unlock_irqrestore(&chip->substream_lock, flags);
+	spin_unlock_irq(&chip->substream_lock);
 	return HRTIMER_NORESTART;
 }
 
@@ -167,7 +140,7 @@ static void pcsp_start_playing(struct snd_pcsp *chip)
 	atomic_set(&chip->timer_active, 1);
 	chip->thalf = 0;
 
-	tasklet_schedule(&pcsp_start_timer_tasklet);
+	hrtimer_start(&pcsp_chip.timer, ktime_set(0, 0), HRTIMER_MODE_REL);
 }
 
 static void pcsp_stop_playing(struct snd_pcsp *chip)

--------------060802000806010403000900--
