Return-Path: <linux-kernel-owner+w=401wt.eu-S1770746AbYHDVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1770746AbYHDVlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1770627AbYHDVlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:41:12 -0400
Received: from ns.suse.de ([195.135.220.2]:55190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1770604AbYHDVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:41:09 -0400
Date: Mon, 4 Aug 2008 14:30:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [patch 20/25] ALSA: hda - Fix DMA position inaccuracy
Message-ID: <20080804213040.GT8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-dma-position-inaccuracy.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9ad593f6d326e7a4664e3856520f6c042f82a37f upstream

Many HD-audio controllers seem inaccurate about the IRQ timing of
PCM period updates.  This has caused problems on audio quality; e.g.
JACK doesn't work with two periods.

This patch fixes the problem by checking the current DMA position
at IRQ handler and delays the period-update via a workq if it's
inaccurate.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |  124 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 106 insertions(+), 18 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -285,6 +285,7 @@ struct azx_dev {
 	u32 *posbuf;		/* position buffer pointer */
 
 	unsigned int bufsize;	/* size of the play buffer in bytes */
+	unsigned int period_bytes; /* size of the period in bytes */
 	unsigned int frags;	/* number for period in the play buffer */
 	unsigned int fifo_size;	/* FIFO size */
 
@@ -301,11 +302,10 @@ struct azx_dev {
 					 */
 	unsigned char stream_tag;	/* assigned stream */
 	unsigned char index;		/* stream index */
-	/* for sanity check of position buffer */
-	unsigned int period_intr;
 
 	unsigned int opened :1;
 	unsigned int running :1;
+	unsigned int irq_pending: 1;
 };
 
 /* CORB/RIRB */
@@ -369,6 +369,9 @@ struct azx {
 
 	/* for debugging */
 	unsigned int last_cmd;	/* last issued command (to sync) */
+
+	/* for pending irqs */
+	struct work_struct irq_pending_work;
 };
 
 /* driver types */
@@ -908,6 +911,8 @@ static void azx_init_pci(struct azx *chi
 }
 
 
+static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev);
+
 /*
  * interrupt handler
  */
@@ -930,11 +935,18 @@ static irqreturn_t azx_interrupt(int irq
 		azx_dev = &chip->azx_dev[i];
 		if (status & azx_dev->sd_int_sta_mask) {
 			azx_sd_writeb(azx_dev, SD_STS, SD_INT_MASK);
-			if (azx_dev->substream && azx_dev->running) {
-				azx_dev->period_intr++;
+			if (!azx_dev->substream || !azx_dev->running)
+				continue;
+			/* check whether this IRQ is really acceptable */
+			if (azx_position_ok(chip, azx_dev)) {
+				azx_dev->irq_pending = 0;
 				spin_unlock(&chip->reg_lock);
 				snd_pcm_period_elapsed(azx_dev->substream);
 				spin_lock(&chip->reg_lock);
+			} else {
+				/* bogus IRQ, process it later */
+				azx_dev->irq_pending = 1;
+				schedule_work(&chip->irq_pending_work);
 			}
 		}
 	}
@@ -973,6 +985,7 @@ static int azx_setup_periods(struct snd_
 	azx_sd_writel(azx_dev, SD_BDLPU, 0);
 
 	period_bytes = snd_pcm_lib_period_bytes(substream);
+	azx_dev->period_bytes = period_bytes;
 	periods = azx_dev->bufsize / period_bytes;
 
 	/* program the initial BDL entries */
@@ -1421,27 +1434,16 @@ static int azx_pcm_trigger(struct snd_pc
 	return 0;
 }
 
-static snd_pcm_uframes_t azx_pcm_pointer(struct snd_pcm_substream *substream)
+static unsigned int azx_get_position(struct azx *chip,
+				     struct azx_dev *azx_dev)
 {
-	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
-	struct azx *chip = apcm->chip;
-	struct azx_dev *azx_dev = get_azx_dev(substream);
 	unsigned int pos;
 
 	if (chip->position_fix == POS_FIX_POSBUF ||
 	    chip->position_fix == POS_FIX_AUTO) {
 		/* use the position buffer */
 		pos = le32_to_cpu(*azx_dev->posbuf);
-		if (chip->position_fix == POS_FIX_AUTO &&
-		    azx_dev->period_intr == 1 && !pos) {
-			printk(KERN_WARNING
-			       "hda-intel: Invalid position buffer, "
-			       "using LPIB read method instead.\n");
-			chip->position_fix = POS_FIX_NONE;
-			goto read_lpib;
-		}
 	} else {
-	read_lpib:
 		/* read LPIB */
 		pos = azx_sd_readl(azx_dev, SD_LPIB);
 		if (chip->position_fix == POS_FIX_FIFO)
@@ -1449,7 +1451,90 @@ static snd_pcm_uframes_t azx_pcm_pointer
 	}
 	if (pos >= azx_dev->bufsize)
 		pos = 0;
-	return bytes_to_frames(substream->runtime, pos);
+	return pos;
+}
+
+static snd_pcm_uframes_t azx_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct azx_pcm *apcm = snd_pcm_substream_chip(substream);
+	struct azx *chip = apcm->chip;
+	struct azx_dev *azx_dev = get_azx_dev(substream);
+	return bytes_to_frames(substream->runtime,
+			       azx_get_position(chip, azx_dev));
+}
+
+/*
+ * Check whether the current DMA position is acceptable for updating
+ * periods.  Returns non-zero if it's OK.
+ *
+ * Many HD-audio controllers appear pretty inaccurate about
+ * the update-IRQ timing.  The IRQ is issued before actually the
+ * data is processed.  So, we need to process it afterwords in a
+ * workqueue.
+ */
+static int azx_position_ok(struct azx *chip, struct azx_dev *azx_dev)
+{
+	unsigned int pos;
+
+	pos = azx_get_position(chip, azx_dev);
+	if (chip->position_fix == POS_FIX_AUTO) {
+		if (!pos) {
+			printk(KERN_WARNING
+			       "hda-intel: Invalid position buffer, "
+			       "using LPIB read method instead.\n");
+			chip->position_fix = POS_FIX_NONE;
+			pos = azx_get_position(chip, azx_dev);
+		} else
+			chip->position_fix = POS_FIX_POSBUF;
+	}
+
+	if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
+		return 0; /* NG - it's below the period boundary */
+	return 1; /* OK, it's fine */
+}
+
+/*
+ * The work for pending PCM period updates.
+ */
+static void azx_irq_pending_work(struct work_struct *work)
+{
+	struct azx *chip = container_of(work, struct azx, irq_pending_work);
+	int i, pending;
+
+	for (;;) {
+		pending = 0;
+		spin_lock_irq(&chip->reg_lock);
+		for (i = 0; i < chip->num_streams; i++) {
+			struct azx_dev *azx_dev = &chip->azx_dev[i];
+			if (!azx_dev->irq_pending ||
+			    !azx_dev->substream ||
+			    !azx_dev->running)
+				continue;
+			if (azx_position_ok(chip, azx_dev)) {
+				azx_dev->irq_pending = 0;
+				spin_unlock(&chip->reg_lock);
+				snd_pcm_period_elapsed(azx_dev->substream);
+				spin_lock(&chip->reg_lock);
+			} else
+				pending++;
+		}
+		spin_unlock_irq(&chip->reg_lock);
+		if (!pending)
+			return;
+		cond_resched();
+	}
+}
+
+/* clear irq_pending flags and assure no on-going workq */
+static void azx_clear_irq_pending(struct azx *chip)
+{
+	int i;
+
+	spin_lock_irq(&chip->reg_lock);
+	for (i = 0; i < chip->num_streams; i++)
+		chip->azx_dev[i].irq_pending = 0;
+	spin_unlock_irq(&chip->reg_lock);
+	flush_scheduled_work();
 }
 
 static struct snd_pcm_ops azx_pcm_ops = {
@@ -1676,6 +1761,7 @@ static int azx_suspend(struct pci_dev *p
 	int i;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	azx_clear_irq_pending(chip);
 	for (i = 0; i < AZX_MAX_PCMS; i++)
 		snd_pcm_suspend_all(chip->pcm[i]);
 	if (chip->initialized)
@@ -1732,6 +1818,7 @@ static int azx_free(struct azx *chip)
 	int i;
 
 	if (chip->initialized) {
+		azx_clear_irq_pending(chip);
 		for (i = 0; i < chip->num_streams; i++)
 			azx_stream_stop(chip, &chip->azx_dev[i]);
 		azx_stop_chip(chip);
@@ -1857,6 +1944,7 @@ static int __devinit azx_create(struct s
 	chip->irq = -1;
 	chip->driver_type = driver_type;
 	chip->msi = enable_msi;
+	INIT_WORK(&chip->irq_pending_work, azx_irq_pending_work);
 
 	chip->position_fix = check_position_fix(chip, position_fix[dev]);
 	check_probe_mask(chip, dev);

-- 
