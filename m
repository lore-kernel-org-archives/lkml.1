Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYDUXe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYDUXe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYDUXeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:34:21 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33580 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYDUXeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:34:20 -0400
Date: Mon, 21 Apr 2008 19:34:19 -0400
From: Jeff Garzik <jeff@garzik.org>
To: perex@perex.cz
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] ALSA: Fix synchronize_irq() bugs, redundancies
Message-ID: <20080421233419.GA4923@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() calls synchronize_irq() for you, so there is no need for
drivers to manually do the same thing (again).  Thus, calls where
sync-irq immediately precedes free-irq can be simplified.

However, during this audit several bugs were noticed, where free-irq is
preceded by a "irq >= 0" check... but the sync-irq call is not covered
by the same check.

So, where sync-irq could not be eliminated completely, the missing check
was added.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/media/video/cx88/cx88-alsa.c       |    4 +---
 drivers/media/video/saa7134/saa7134-alsa.c |    4 +---
 sound/pci/ad1889.c                         |    2 --
 sound/pci/ali5451/ali5451.c                |    4 +---
 sound/pci/atiixp.c                         |    2 +-
 sound/pci/atiixp_modem.c                   |    2 +-
 sound/pci/au88x0/au88x0.c                  |    2 --
 sound/pci/azt3328.c                        |    3 ++-
 sound/pci/cmipci.c                         |    2 --
 sound/pci/ens1370.c                        |    3 ++-
 sound/pci/es1938.c                         |    5 +----
 sound/pci/es1968.c                         |    3 ++-
 sound/pci/hda/hda_intel.c                  |    5 +----
 sound/pci/ice1712/ice1712.c                |    5 ++---
 sound/pci/ice1712/ice1724.c                |    4 +---
 sound/pci/intel8x0.c                       |    3 +--
 sound/pci/intel8x0m.c                      |    3 ++-
 sound/pci/maestro3.c                       |    4 +---
 sound/pci/oxygen/oxygen_lib.c              |    4 +---
 sound/pci/sis7019.c                        |    1 -
 sound/pci/via82xx.c                        |    2 +-
 sound/pci/via82xx_modem.c                  |    2 +-
 22 files changed, 23 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 316b106..03feb5b 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -690,10 +690,8 @@ MODULE_DEVICE_TABLE(pci, cx88_audio_pci_tbl);
 static int snd_cx88_free(snd_cx88_card_t *chip)
 {
 
-	if (chip->irq >= 0){
-		synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	}
 
 	cx88_core_put(chip->core,chip->pci);
 
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 047add8..ec6bdb9 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -954,10 +954,8 @@ static void snd_saa7134_free(struct snd_card * card)
 	if (chip->dev->dmasound.priv_data == NULL)
 		return;
 
-	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
 		free_irq(chip->irq, &chip->dev->dmasound);
-	}
 
 	chip->dev->dmasound.priv_data = NULL;
 
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index a66d515..8d65ef6 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -854,8 +854,6 @@ snd_ad1889_free(struct snd_ad1889 *chip)
 
 	spin_unlock_irq(&chip->lock);
 
-	synchronize_irq(chip->irq);
-	
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 6a905ed..01d133c 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2047,10 +2047,8 @@ static int snd_ali_free(struct snd_ali * codec)
 {
 	if (codec->hw_initialized)
 		snd_ali_disable_address_interrupt(codec);
-	if (codec->irq >= 0) {
-		synchronize_irq(codec->irq);
+	if (codec->irq >= 0)
 		free_irq(codec->irq, codec);
-	}
 	if (codec->port)
 		pci_release_regions(codec->pci);
 	pci_disable_device(codec->pci);
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 4594186..457228f 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1553,7 +1553,7 @@ static int snd_atiixp_free(struct atiixp *chip)
 	if (chip->irq < 0)
 		goto __hw_end;
 	snd_atiixp_chip_stop(chip);
-	synchronize_irq(chip->irq);
+
       __hw_end:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index a67a869..d457a32 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1197,7 +1197,7 @@ static int snd_atiixp_free(struct atiixp_modem *chip)
 	if (chip->irq < 0)
 		goto __hw_end;
 	snd_atiixp_chip_stop(chip);
-	synchronize_irq(chip->irq);
+
       __hw_end:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 26819e2..68368e4 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -126,7 +126,6 @@ static int snd_vortex_dev_free(struct snd_device *device)
 	vortex_gameport_unregister(vortex);
 	vortex_core_shutdown(vortex);
 	// Take down PCI interface.
-	synchronize_irq(vortex->irq);
 	free_irq(vortex->irq, vortex);
 	iounmap(vortex->mmio);
 	pci_release_regions(vortex->pci_dev);
@@ -220,7 +219,6 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 	return 0;
 
       alloc_out:
-	synchronize_irq(chip->irq);
 	free_irq(chip->irq, chip);
       irq_out:
 	vortex_core_shutdown(chip);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 4e71a55..c28fbaa 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -1514,7 +1514,8 @@ snd_azf3328_free(struct snd_azf3328 *chip)
 	/* well, at least we know how to disable the timer IRQ */
 	snd_azf3328_codec_outb(chip, IDX_IO_TIMER_VALUE + 3, 0x00);
 
-        synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
+        	synchronize_irq(chip->irq);
 __end_hw:
 	snd_azf3328_free_joystick(chip);
         if (chip->irq >= 0)
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 135f308..342dab3 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2932,8 +2932,6 @@ static int snd_cmipci_free(struct cmipci *cm)
 		/* reset mixer */
 		snd_cmipci_mixer_write(cm, 0, 0);
 
-		synchronize_irq(cm->irq);
-
 		free_irq(cm->irq, cm);
 	}
 
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 72d85a5..09652f3 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -1910,7 +1910,8 @@ static int snd_ensoniq_free(struct ensoniq *ensoniq)
 	outl(0, ES_REG(ensoniq, CONTROL));	/* switch everything off */
 	outl(0, ES_REG(ensoniq, SERIAL));	/* clear serial interface */
 #endif
-	synchronize_irq(ensoniq->irq);
+	if (ensoniq->irq >= 0)
+		synchronize_irq(ensoniq->irq);
 	pci_set_power_state(ensoniq->pci, 3);
       __hw_end:
 #ifdef CHIP1370
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 1a314fa..84fac1f 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1488,7 +1488,6 @@ static int es1938_suspend(struct pci_dev *pci, pm_message_t state)
 
 	outb(0x00, SLIO_REG(chip, IRQCONTROL)); /* disable irqs */
 	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
 		free_irq(chip->irq, chip);
 		chip->irq = -1;
 	}
@@ -1578,10 +1577,8 @@ static int snd_es1938_free(struct es1938 *chip)
 
 	snd_es1938_free_gameport(chip);
 
-	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	}
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 7d911a1..3e294b6 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2456,7 +2456,8 @@ static inline void snd_es1968_free_gameport(struct es1968 *chip) { }
 static int snd_es1968_free(struct es1968 *chip)
 {
 	if (chip->io_port) {
-		synchronize_irq(chip->irq);
+		if (chip->irq >= 0)
+			synchronize_irq(chip->irq);
 		outw(1, chip->io_port + 0x04); /* clear WP interrupts */
 		outw(0, chip->io_port + ESM_PORT_HOST_IRQ); /* disable IRQ */
 	}
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 4be36c8..ddf6e9c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1593,7 +1593,6 @@ static int azx_suspend(struct pci_dev *pci, pm_message_t state)
 		snd_hda_suspend(chip->bus, state);
 	azx_stop_chip(chip);
 	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
 		free_irq(chip->irq, chip);
 		chip->irq = -1;
 	}
@@ -1648,10 +1647,8 @@ static int azx_free(struct azx *chip)
 		azx_stop_chip(chip);
 	}
 
-	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
 		free_irq(chip->irq, (void*)chip);
-	}
 	if (chip->msi)
 		pci_disable_msi(chip->pci);
 	if (chip->remap_addr)
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index df292af..fb13248 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2482,10 +2482,9 @@ static int snd_ice1712_free(struct snd_ice1712 *ice)
 	outb(0xff, ICEREG(ice, IRQMASK));
 	/* --- */
       __hw_end:
-	if (ice->irq >= 0) {
-		synchronize_irq(ice->irq);
+	if (ice->irq >= 0)
 		free_irq(ice->irq, ice);
-	}
+
 	if (ice->port)
 		pci_release_regions(ice->pci);
 	snd_ice1712_akm4xxx_free(ice);
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index f533850..50bb140 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2169,10 +2169,8 @@ static int snd_vt1724_free(struct snd_ice1712 *ice)
 	outb(0xff, ICEREG1724(ice, IRQMASK));
 	/* --- */
       __hw_end:
-	if (ice->irq >= 0) {
-		synchronize_irq(ice->irq);
+	if (ice->irq >= 0)
 		free_irq(ice->irq, ice);
-	}
 	pci_release_regions(ice->pci);
 	snd_ice1712_akm4xxx_free(ice);
 	pci_disable_device(ice->pci);
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index c52abd0..3e19504 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2446,7 +2446,7 @@ static int snd_intel8x0_free(struct intel8x0 *chip)
 		pci_write_config_dword(chip->pci, 0x4c, val);
 	}
 	/* --- */
-	synchronize_irq(chip->irq);
+
       __hw_end:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -2495,7 +2495,6 @@ static int intel8x0_suspend(struct pci_dev *pci, pm_message_t state)
 		chip->sdm_saved = igetbyte(chip, ICHREG(SDM));
 
 	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
 		free_irq(chip->irq, chip);
 		chip->irq = -1;
 	}
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index cadda8d..15db810 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -986,7 +986,8 @@ static int snd_intel8x0_free(struct intel8x0m *chip)
 	for (i = 0; i < chip->bdbars_count; i++)
 		iputbyte(chip, ICH_REG_OFF_CR + chip->ichd[i].reg_offset, ICH_RESETREGS);
 	/* --- */
-	synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
+		synchronize_irq(chip->irq);
       __hw_end:
 	if (chip->bdbars.area)
 		snd_dma_free_pages(&chip->bdbars);
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 04fa0a6..9aa8f05 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2542,10 +2542,8 @@ static int snd_m3_free(struct snd_m3 *chip)
 	vfree(chip->suspend_mem);
 #endif
 
-	if (chip->irq >= 0) {
-		synchronize_irq(chip->irq);
+	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	}
 
 	if (chip->iobase)
 		pci_release_regions(chip->pci);
diff --git a/sound/pci/oxygen/oxygen_lib.c b/sound/pci/oxygen/oxygen_lib.c
index 78c2115..15b517e 100644
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -388,10 +388,8 @@ static void oxygen_card_free(struct snd_card *card)
 	oxygen_write16(chip, OXYGEN_DMA_STATUS, 0);
 	oxygen_write16(chip, OXYGEN_INTERRUPT_MASK, 0);
 	spin_unlock_irq(&chip->reg_lock);
-	if (chip->irq >= 0) {
+	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-		synchronize_irq(chip->irq);
-	}
 	flush_scheduled_work();
 	chip->model->cleanup(chip);
 	mutex_destroy(&chip->mutex);
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index dcd7cd0..d888293 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1194,7 +1194,6 @@ static int sis_suspend(struct pci_dev *pci, pm_message_t state)
 	/* snd_pcm_suspend_all() stopped all channels, so we're quiescent.
 	 */
 	if (sis->irq >= 0) {
-		synchronize_irq(sis->irq);
 		free_irq(sis->irq, sis);
 		sis->irq = -1;
 	}
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index a756be6..b585cc3 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2236,7 +2236,7 @@ static int snd_via82xx_free(struct via82xx *chip)
 	/* disable interrupts */
 	for (i = 0; i < chip->num_devs; i++)
 		snd_via82xx_channel_reset(chip, &chip->devs[i]);
-	synchronize_irq(chip->irq);
+
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
  __end_hw:
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index f5df1c7..31f64ee 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1075,7 +1075,7 @@ static int snd_via82xx_free(struct via82xx_modem *chip)
 	/* disable interrupts */
 	for (i = 0; i < chip->num_devs; i++)
 		snd_via82xx_channel_reset(chip, &chip->devs[i]);
-	synchronize_irq(chip->irq);
+
       __end_hw:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
