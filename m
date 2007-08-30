Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbXH3D2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbXH3D2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXH3D1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:27:53 -0400
Received: from mail.queued.net ([207.210.101.209]:1790 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbXH3D1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:27:52 -0400
Date: Wed, 29 Aug 2007 23:29:54 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 2/5] ALSA: cs5535audio: fix PRD register save/restore power
 management race
Message-Id: <20070829232954.3499e8a5.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In the suspend path, we currently save the PRD registers and then disable DMA.
This is racy; the sound hardware might update the PRD register as it finishes
processing some DMA pages between when we've saved the PRD registers and
when DMA actually gets disabled.  Furthermore, we actively check whether or
not DMA is enabled before saving PRD registers; there's no reason to do that,
as the PRD registers should not update when we twiddle the ACC_BM[x]_CMD
register(s).  Worst case, we save the PRD registers twice; even powering
down the ACC shouldn't mess with the PRD registers (according to the 5536
data sheet, section 5.3.7.4, power-down procedure).  This patch reworks
all that to first disable DMA, and then save PRD registers.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 sound/pci/cs5535audio/cs5535audio.h     |    1 -
 sound/pci/cs5535audio/cs5535audio_pcm.c |    2 --
 sound/pci/cs5535audio/cs5535audio_pm.c  |   14 +++++++-------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 4fd1f31..c7a2044 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -106,7 +106,6 @@ struct cs5535audio_dma {
 	struct snd_pcm_substream *substream;
 	unsigned int buf_addr, buf_bytes;
 	unsigned int period_bytes, periods;
-	int suspended;
 	u32 saved_prd;
 };
 
diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index e61f972..fe21a1c 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -300,14 +300,12 @@ static int snd_cs5535audio_trigger(struct snd_pcm_substream *substream, int cmd)
 		break;
 	case SNDRV_PCM_TRIGGER_RESUME:
 		dma->ops->enable_dma(cs5535au);
-		dma->suspended = 0;
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		dma->ops->disable_dma(cs5535au);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		dma->ops->disable_dma(cs5535au);
-		dma->suspended = 1;
 		break;
 	default:
 		snd_printk(KERN_ERR "unhandled trigger\n");
diff --git a/sound/pci/cs5535audio/cs5535audio_pm.c b/sound/pci/cs5535audio/cs5535audio_pm.c
index 3e4d198..9a4e84a 100644
--- a/sound/pci/cs5535audio/cs5535audio_pm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pm.c
@@ -64,13 +64,13 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state)
 	int i;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	snd_pcm_suspend_all(cs5535au->pcm);
+	snd_ac97_suspend(cs5535au->ac97);
 	for (i = 0; i < NUM_CS5535AUDIO_DMAS; i++) {
 		struct cs5535audio_dma *dma = &cs5535au->dmas[i];
-		if (dma && dma->substream && !dma->suspended) 
+		if (dma && dma->substream)
 			dma->saved_prd = dma->ops->read_prd(cs5535au);
 	}
-	snd_pcm_suspend_all(cs5535au->pcm);
-	snd_ac97_suspend(cs5535au->ac97);
 	/* save important regs, then disable aclink in hw */
 	snd_cs5535audio_stop_hardware(cs5535au);
 
@@ -112,17 +112,17 @@ int snd_cs5535audio_resume(struct pci_dev *pci)
 	if (!timeout)
 		snd_printk(KERN_ERR "Failure getting AC Link ready\n");
 
-	/* we depend on ac97 to perform the codec power up */
-	snd_ac97_resume(cs5535au->ac97);
 	/* set up rate regs, dma. actual initiation is done in trig */
 	for (i = 0; i < NUM_CS5535AUDIO_DMAS; i++) {
 		struct cs5535audio_dma *dma = &cs5535au->dmas[i];
-		if (dma && dma->substream && dma->suspended) {
+		if (dma && dma->substream) {
 			dma->substream->ops->prepare(dma->substream);
 			dma->ops->setup_prd(cs5535au, dma->saved_prd);
 		}
 	}
-		
+
+	/* we depend on ac97 to perform the codec power up */
+	snd_ac97_resume(cs5535au->ac97);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	return 0;
