Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYKFVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYKFVqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYKFVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:46:35 -0500
Received: from mail.queued.net ([207.210.101.209]:4017 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYKFVqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:46:34 -0500
Date: Thu, 6 Nov 2008 16:46:31 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4/14] ALSA: cs5535audio: drop ec_analog_input flag for OLPC
 stuff
Message-ID: <20081106164631.4e8c7413@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is no longer necessary, as we're no longer doing indexed i/o commands.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.h      |    3 ---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    9 +--------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 93602cf..31ecb33 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -92,9 +92,6 @@ struct cs5535audio {
 	struct snd_pcm_substream *playback_substream;
 	struct snd_pcm_substream *capture_substream;
 	struct cs5535audio_dma dmas[NUM_CS5535AUDIO_DMAS];
-#ifdef CONFIG_OLPC
-	int ec_analog_input_mode;
-#endif
 };
 
 #ifdef CONFIG_PM
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index adc10a3..16b41d4 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -38,8 +38,7 @@ static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol,
 	reg1 = snd_ac97_read(cs5535au->ac97, AC97_AD_MISC);
 	reg2 = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
 
-	if ((reg1 & AD1888_VREFOUT_EN_BIT) && (reg2 & AD1888_HPF_EN_BIT) &&
-		cs5535au->ec_analog_input_mode)
+	if ((reg1 & AD1888_VREFOUT_EN_BIT) && (reg2 & AD1888_HPF_EN_BIT))
 		ucontrol->value.integer.value[0] = 1;
 	else
 		ucontrol->value.integer.value[0] = 0;
@@ -58,10 +57,6 @@ static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol,
 	/* value is 1 if analog input is desired */
 	value = ucontrol->value.integer.value[0];
 
-	/* use ec mode as flag to determine if any change needed */
-	if (cs5535au->ec_analog_input_mode == value) 
-		return 0;
-
 	/* sets High Z on VREF Bias if 1 */
 	if (value) 
 		err = snd_ac97_update_bits(ac97, AC97_AD_MISC, 
@@ -88,8 +83,6 @@ static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol,
 	else
 		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
 
-	cs5535au->ec_analog_input_mode = value;
-
 	return 1;
 }
 
-- 
1.5.6.5

