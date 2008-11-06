Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYKFVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYKFVxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYKFVxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:08 -0500
Received: from mail.queued.net ([207.210.101.209]:2007 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYKFVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:07 -0500
Date: Thu, 6 Nov 2008 16:53:03 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 10/14] ALSA: cs5535audio: rename V_REFOUT control to MIC
 Bias
Message-ID: <20081106165303.073670cb@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This drops the AD1888 V_REFOUT control, and replaces it with a MIC Bias
Enable control.  It also moves the MIC bias enabling into a separate
function.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.h      |   16 +++++++
 sound/pci/cs5535audio/cs5535audio_olpc.c |   73 ++++++++++++++++++++++++++++--
 sound/pci/cs5535audio/cs5535audio_pcm.c  |   17 +------
 3 files changed, 87 insertions(+), 19 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 22737fc..63190cd 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -104,6 +104,19 @@ void __devinit olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97);
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
 void olpc_analog_input(struct snd_ac97 *ac97, int on);
+void olpc_mic_bias(struct snd_ac97 *ac97, int on);
+
+static inline void olpc_capture_open(struct snd_ac97 *ac97)
+{
+	/* enable MIC Bias for recording */
+	olpc_mic_bias(ac97, 1);
+}
+
+static inline void olpc_capture_close(struct snd_ac97 *ac97)
+{
+	/* disable the MIC Bias (so the recording LED turns off) */
+	olpc_mic_bias(ac97, 0);
+}
 #else
 static inline void olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97) { }
@@ -112,6 +125,9 @@ static inline int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	return 0;
 }
 static inline void olpc_analog_input(struct snd_ac97 *ac97, int on) { }
+static inline void olpc_mic_bias(struct snd_ac97 *ac97, int on) { }
+static inline void olpc_capture_open(struct snd_ac97 *ac97) { }
+static inline void olpc_capture_close(struct snd_ac97 *ac97) { }
 #endif
 
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index f59af91..73811e0 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -31,6 +31,20 @@ void olpc_analog_input(struct snd_ac97 *ac97, int on)
 		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
 }
 
+/*
+ * OLPC XO-1's V_REFOUT is a mic bias enable.
+ */
+void olpc_mic_bias(struct snd_ac97 *ac97, int on)
+{
+	int err;
+
+	on = on ? 0 : 1;
+	err = snd_ac97_update_bits(ac97, AC97_AD_MISC,
+			1 << AC97_AD_VREFD_SHIFT, on << AC97_AD_VREFD_SHIFT);
+	if (err < 0)
+		snd_printk(KERN_ERR "setting MIC Bias - %d\n", err);
+}
+
 static int olpc_dc_info(struct snd_kcontrol *kctl,
 		struct snd_ctl_elem_info *uinfo)
 {
@@ -56,7 +70,36 @@ static int olpc_dc_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 	return 1;
 }
 
-static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata = 
+static int olpc_mic_info(struct snd_kcontrol *kctl,
+		struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 1;
+	return 0;
+}
+
+static int olpc_mic_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
+{
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
+	struct snd_ac97 *ac97 = cs5535au->ac97;
+	int i;
+
+	i = (snd_ac97_read(ac97, AC97_AD_MISC) >> AC97_AD_VREFD_SHIFT) & 0x1;
+	v->value.integer.value[0] = i ? 0 : 1;
+	return 0;
+}
+
+static int olpc_mic_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
+{
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
+
+	olpc_mic_bias(cs5535au->ac97, v->value.integer.value[0]);
+	return 1;
+}
+
+static struct snd_kcontrol_new olpc_cs5535audio_ctls[] __devinitdata = {
 {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "DC Mode Enable",
@@ -64,6 +107,15 @@ static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata =
 	.get = olpc_dc_get,
 	.put = olpc_dc_put,
 	.private_value = 0
+},
+{
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "MIC Bias Enable",
+	.info = olpc_mic_info,
+	.get = olpc_mic_get,
+	.put = olpc_mic_put,
+	.private_value = 0,
+},
 };
 
 void __devinit olpc_prequirks(struct snd_card *card,
@@ -80,6 +132,7 @@ void __devinit olpc_prequirks(struct snd_card *card,
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
 	struct snd_ctl_elem_id elem;
+	int i, err;
 
 	if (!machine_is_olpc())
 		return 0;
@@ -90,8 +143,20 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	strncpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
 	snd_ctl_remove_id(card, &elem);
 
-	/* add the override for OLPC's HPF */
-	return snd_ctl_add(card, snd_ctl_new1(&snd_cs5535audio_controls, 
-						ac97->private_data));
+	/* drop the original V_REFOUT control */
+	memset(&elem, 0, sizeof(elem));
+	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strncpy(elem.name, "V_REFOUT Enable", sizeof(elem.name));
+	snd_ctl_remove_id(card, &elem);
+
+	/* add the OLPC-specific controls */
+	for (i = 0; i < ARRAY_SIZE(olpc_cs5535audio_ctls); i++) {
+		err = snd_ctl_add(card, snd_ctl_new1(&olpc_cs5535audio_ctls[i],
+				ac97->private_data));
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
 }
 
diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index fa2a6b1..0f48a87 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -363,27 +363,14 @@ static int snd_cs5535audio_capture_open(struct snd_pcm_substream *substream)
 	if ((err = snd_pcm_hw_constraint_integer(runtime,
 					 SNDRV_PCM_HW_PARAM_PERIODS)) < 0)
 		return err;
-
-#ifdef CONFIG_OLPC
-	/* Enable the V_ref bias only while recording. */
-	err = snd_ac97_update_bits(cs5535au->ac97, AC97_AD_MISC,
-			1 << AC97_AD_VREFD_SHIFT, 0);
-	if (err < 0)
-		snd_printk(KERN_ERR "Error updating AD_MISC %d\n", err);
-#endif
+	olpc_capture_open(cs5535au->ac97);
 	return 0;
 }
 
 static int snd_cs5535audio_capture_close(struct snd_pcm_substream *substream)
 {
-	int err;
 	struct cs5535audio *cs5535au = snd_pcm_substream_chip(substream);
-
-#ifdef CONFIG_OLPC
-	/* Disable V_ref bias. */
-	err = snd_ac97_update_bits(cs5535au->ac97, AC97_AD_MISC,
-			1 << AC97_AD_VREFD_SHIFT, 1 << AC97_AD_VREFD_SHIFT);
-#endif
+	olpc_capture_close(cs5535au->ac97);
 	return 0;
 }
 
-- 
1.5.6.5

