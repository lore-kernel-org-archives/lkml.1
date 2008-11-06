Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYKFVtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYKFVtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYKFVtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:49:42 -0500
Received: from mail.queued.net ([207.210.101.209]:1263 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYKFVtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:49:41 -0500
Date: Thu, 6 Nov 2008 16:49:38 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6/14] ALSA: cs5535audio: create function for setting OLPC's
 Analog Input mode
Message-ID: <20081106164938.1a44332b@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clean this stuff up a bit..

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.h      |    2 +
 sound/pci/cs5535audio/cs5535audio_olpc.c |   54 +++++++++++++----------------
 2 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 31ecb33..22737fc 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -103,6 +103,7 @@ int snd_cs5535audio_resume(struct pci_dev *pci);
 void __devinit olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97);
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+void olpc_analog_input(struct snd_ac97 *ac97, int on);
 #else
 static inline void olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97) { }
@@ -110,6 +111,7 @@ static inline int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
 	return 0;
 }
+static inline void olpc_analog_input(struct snd_ac97 *ac97, int on) { }
 #endif
 
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index ccefd55..01ce4ae 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -7,12 +7,29 @@
 #include <asm/olpc.h>
 #include "cs5535audio.h"
 
-/* OLPC has an additional feature on top of regular AD1888 codec
-features. This is support for an analog input mode. This is a 
-2 step process. First, to turn off the AD1888 codec bias voltage
-and high pass filter. Second, to tell the embedded controller to
-reroute from a capacitive trace to a direct trace using an analog
-switch. The *_ec()s are what talk to that controller */
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
 
 static int snd_cs5535audio_ctl_info(struct snd_kcontrol *kcontrol, 
 					struct snd_ctl_elem_info *uinfo)
@@ -24,8 +41,6 @@ static int snd_cs5535audio_ctl_info(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-#define AD1888_VREFOUT_EN_BIT (1 << 2)
-#define AD1888_HPF_EN_BIT (1 << 12)
 static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol, 
 					struct snd_ctl_elem_value *ucontrol)
 {
@@ -42,30 +57,9 @@ static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol,
 static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol, 
 					struct snd_ctl_elem_value *ucontrol)
 {
-	int err;
 	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
-	u8 value;
-	struct snd_ac97 *ac97 = cs5535au->ac97;
-
-	/* value is 1 if analog input is desired */
-	value = ucontrol->value.integer.value[0];
-
-	/* turns off High Pass Filter if 1 */
-	if (value)
-		err = snd_ac97_update_bits(ac97, AC97_AD_TEST2, 
-				AD1888_HPF_EN_BIT, AD1888_HPF_EN_BIT);
-	else
-		err = snd_ac97_update_bits(ac97, AC97_AD_TEST2, 
-				AD1888_HPF_EN_BIT, 0);
-	if (err < 0)
-		snd_printk(KERN_ERR "Error updating AD_TEST2 %d\n", err);
-
-	/* B2 and newer writes directly to a GPIO pin */
-	if (value)
-		geode_gpio_set(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
-	else
-		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
 
+	olpc_analog_input(cs5535au->ac97, ucontrol->value.integer.value[0]);
 	return 1;
 }
 
-- 
1.5.6.5

