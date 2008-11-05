Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYKEWiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYKEWiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYKEWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:37:23 -0500
Received: from mail.queued.net ([207.210.101.209]:4985 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYKEWhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:37:17 -0500
Date: Wed, 5 Nov 2008 17:30:08 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/4] ALSA: cs5535audio: turn off PCM properly if closing the
 audio device
Message-ID: <20081105173008.738cb022@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaya Kumar <jayakumar.lkml@gmail.com>

As per <http://dev.laptop.org/ticket/1420>, we need to properly turn off
the PCM if we're closing the device in order to save power.  This also
causes the MIC led to turn off properly.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.c     |    3 ++-
 sound/pci/cs5535audio/cs5535audio.h     |    1 +
 sound/pci/cs5535audio/cs5535audio_pcm.c |   12 ++++++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 1d8b160..6c886ed 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -159,7 +159,8 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 		return err;
 
 	memset(&ac97, 0, sizeof(ac97));
-	ac97.scaps = AC97_SCAP_AUDIO|AC97_SCAP_SKIP_MODEM;
+	ac97.scaps = AC97_SCAP_AUDIO | AC97_SCAP_SKIP_MODEM
+			| AC97_SCAP_POWER_SAVE;
 	ac97.private_data = cs5535au;
 	ac97.pci = cs5535au->pci;
 
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 66bae76..57e9c65 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -78,6 +78,7 @@ struct cs5535audio_dma {
 	unsigned int buf_addr, buf_bytes;
 	unsigned int period_bytes, periods;
 	u32 saved_prd;
+	int pcm_open_flag;
 };
 
 struct cs5535audio {
diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index cdcda87..6aa0c19 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -260,6 +260,9 @@ static int snd_cs5535audio_hw_params(struct snd_pcm_substream *substream,
 	err = cs5535audio_build_dma_packets(cs5535au, dma, substream,
 					    params_periods(hw_params),
 					    params_period_bytes(hw_params));
+	if (!err)
+		dma->pcm_open_flag = 1;
+
 	return err;
 }
 
@@ -268,6 +271,15 @@ static int snd_cs5535audio_hw_free(struct snd_pcm_substream *substream)
 	struct cs5535audio *cs5535au = snd_pcm_substream_chip(substream);
 	struct cs5535audio_dma *dma = substream->runtime->private_data;
 
+	if (dma->pcm_open_flag) {
+		if (substream == cs5535au->playback_substream)
+			snd_ac97_update_power(cs5535au->ac97,
+					AC97_PCM_FRONT_DAC_RATE, 0);
+		else
+			snd_ac97_update_power(cs5535au->ac97,
+					AC97_PCM_LR_ADC_RATE, 0);
+		dma->pcm_open_flag = 0;
+	}
 	cs5535audio_clear_dma_packets(cs5535au, dma, substream);
 	return snd_pcm_lib_free_pages(substream);
 }
-- 
1.5.6.5

