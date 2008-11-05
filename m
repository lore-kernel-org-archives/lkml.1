Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYKEWm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYKEWm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYKEWmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:42:18 -0500
Received: from mail.queued.net ([207.210.101.209]:4841 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbYKEWmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:42:17 -0500
Date: Wed, 5 Nov 2008 17:31:13 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/4] ALSA: cs5535audio: OLPC Analog Input and MIC Bias
 support
Message-ID: <20081105173113.06e93db3@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds support for the special cs5535audio features that OLPC XO-1s have.
They support switching between analog and DC recording, and the MIC requires
toggling V_REFOUT (which this patch renames to MIC Bias) to operate.  There's
also an EAPD tweak which is necessary for B3 and newer machines.

All of this is enabled by CONFIG_OLPC (and CONFIG_SND_CS5535AUDIO, obviously).

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/Makefile           |    1 +
 sound/pci/cs5535audio/cs5535audio.c      |    9 ++
 sound/pci/cs5535audio/cs5535audio.h      |   35 ++++++
 sound/pci/cs5535audio/cs5535audio_olpc.c |  173 ++++++++++++++++++++++++++++++
 sound/pci/cs5535audio/cs5535audio_pcm.c  |    3 +
 5 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 sound/pci/cs5535audio/cs5535audio_olpc.c

diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index bb3d57e..ccc6422 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -4,6 +4,7 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
+snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 6c886ed..826e6de 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -164,6 +164,9 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 	ac97.private_data = cs5535au;
 	ac97.pci = cs5535au->pci;
 
+	/* set any OLPC-specific scaps */
+	olpc_prequirks(card, &ac97);
+
 	if ((err = snd_ac97_mixer(pbus, &ac97, &cs5535au->ac97)) < 0) {
 		snd_printk(KERN_ERR "mixer failed\n");
 		return err;
@@ -171,6 +174,12 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 
 	snd_ac97_tune_hardware(cs5535au->ac97, ac97_quirks, ac97_quirk);
 
+	err = olpc_quirks(card, cs5535au->ac97);
+	if (err < 0) {
+		snd_printk(KERN_ERR "olpc quirks failed\n");
+		return err;
+	}
+
 	return 0;
 }
 
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 1aa1e2b..7777037 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -99,6 +99,41 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state);
 int snd_cs5535audio_resume(struct pci_dev *pci);
 #endif
 
+#ifdef CONFIG_OLPC
+void __devinit olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97);
+int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+void olpc_analog_input(struct snd_ac97 *ac97, int on);
+void olpc_mic_bias(struct snd_ac97 *ac97, int on);
+
+static inline void olpc_capture_open(struct snd_ac97 *ac97)
+{
+	/* default to Analog Input off */
+	olpc_analog_input(ac97, 0);
+	/* enable MIC Bias for recording */
+	olpc_mic_bias(ac97, 1);
+}
+
+static inline void olpc_capture_close(struct snd_ac97 *ac97)
+{
+	/* disable Analog Input */
+	olpc_analog_input(ac97, 0);
+	/* disable the MIC Bias (so the recording LED turns off) */
+	olpc_mic_bias(ac97, 0);
+}
+#else
+static inline void olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97) { }
+static inline int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
+{
+	return 0;
+}
+static inline void olpc_analog_input(struct snd_ac97 *ac97, int on) { }
+static inline void olpc_mic_bias(struct snd_ac97 *ac97, int on) { }
+static inline void olpc_capture_open(struct snd_ac97 *ac97) { }
+static inline void olpc_capture_close(struct snd_ac97 *ac97) { }
+#endif
+
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
 
 #endif /* __SOUND_CS5535AUDIO_H */
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
new file mode 100644
index 0000000..164f6bd
--- /dev/null
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -0,0 +1,173 @@
+/*
+ * OLPC XO-1 additional sound features
+ *
+ * Copyright © 2006  Jaya Kumar <jayakumar.lkml@gmail.com>
+ * Copyright © 2007-2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <sound/core.h>
+#include <sound/info.h>
+#include <sound/control.h>
+#include <sound/ac97_codec.h>
+
+#include <asm/olpc.h>
+#include "cs5535audio.h"
+
+/*
+ * OLPC has an additional feature on top of the regular AD1888 codec features.
+ * It has an Analog Input mode that is switched into (after disabling the
+ * High Pass Filter) via GPIO.  It is supported on B2 and later models.
+ */
+void olpc_analog_input(struct snd_ac97 *ac97, int on)
+{
+	int err;
+
+	/* update the High Pass Filter (via AC97_AD_TEST2) */
+	err = snd_ac97_update_bits(ac97, AC97_AD_TEST2,
+			1 << AC97_AD_HPFD_SHIFT, on << AC97_AD_HPFD_SHIFT);
+	if (err < 0) {
+		snd_printk(KERN_ERR "setting High Pass Filter - %d\n", err);
+		return;
+	}
+
+	/* set Analog Input through GPIO */
+	if (on)
+		geode_gpio_set(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
+	else
+		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
+}
+
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
+static int olpc_dc_info(struct snd_kcontrol *kctl,
+		struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 1;
+	return 0;
+}
+
+static int olpc_dc_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
+{
+	v->value.integer.value[0] = geode_gpio_isset(OLPC_GPIO_MIC_AC,
+			GPIO_OUTPUT_VAL);
+	return 0;
+}
+
+static int olpc_dc_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
+{
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
+
+	olpc_analog_input(cs5535au->ac97, v->value.integer.value[0]);
+	return 1;
+}
+
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
+{
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "DC Mode Enable",
+	.info = olpc_dc_info,
+	.get = olpc_dc_get,
+	.put = olpc_dc_put,
+	.private_value = 0,
+},
+{
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "MIC Bias Enable",
+	.info = olpc_mic_info,
+	.get = olpc_mic_get,
+	.put = olpc_mic_put,
+	.private_value = 0,
+},
+};
+
+void __devinit olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97)
+{
+	if (!machine_is_olpc())
+		return;
+
+	/* invert EAPD if on an OLPC B3 or higher */
+	if (olpc_board_at_least(olpc_board_pre(0xb3)))
+		ac97->scaps |= AC97_SCAP_INV_EAPD;
+}
+
+int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
+{
+	struct snd_ctl_elem_id elem;
+	int i, err;
+
+	if (!machine_is_olpc())
+		return 0;
+
+	/* drop the original AD1888 HPF control */
+	memset(&elem, 0, sizeof(elem));
+	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strncpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
+	snd_ctl_remove_id(card, &elem);
+
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
+	/* turn off the mic by default */
+	olpc_mic_bias(ac97, 0);
+	return 0;
+}
diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index 6aa0c19..0f48a87 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -363,11 +363,14 @@ static int snd_cs5535audio_capture_open(struct snd_pcm_substream *substream)
 	if ((err = snd_pcm_hw_constraint_integer(runtime,
 					 SNDRV_PCM_HW_PARAM_PERIODS)) < 0)
 		return err;
+	olpc_capture_open(cs5535au->ac97);
 	return 0;
 }
 
 static int snd_cs5535audio_capture_close(struct snd_pcm_substream *substream)
 {
+	struct cs5535audio *cs5535au = snd_pcm_substream_chip(substream);
+	olpc_capture_close(cs5535au->ac97);
 	return 0;
 }
 
-- 
1.5.6.5

