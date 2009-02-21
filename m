Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZBUDMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZBUDMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZBUDMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:12:25 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43607 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431AbZBUDMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:12:24 -0500
Date: Fri, 20 Feb 2009 22:12:15 -0500
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Jeremy Katz <katzj@redhat.com>, cjb@laptop.org,
       jayakumar.alsa@gmail.com, Jordan Crouse <jordan@cosmicpenguin.net>,
       linux-geode@lists.infradead.org, perex@perex.cz
Subject: [PATCH 2/2] ALSA: cs5535audio: free OLPC quirks from reliance on
 MGEODE_LX cpu optimization
Message-ID: <20090220221215.2d04d0c5@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously, OLPC support for the mic extensions was only enabled in the
ALSA driver if CONFIG_OLPC and CONFIG_MGEODE_LX were both set.  This was
because the old geode GPIO code was written in a manner that assumed
CONFIG_MGEODE_LX.  With the new cs553x-gpio driver, this is no longer the
case; as such, we can drop the requirement on CONFIG_MGEODE_LX and instead
include a requirement on GPIOLIB.

We use the generic GPIO API rather than the cs553x-specific API.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/include/asm/olpc.h              |    2 +-
 sound/pci/cs5535audio/Makefile           |    2 +-
 sound/pci/cs5535audio/cs5535audio.c      |    1 +
 sound/pci/cs5535audio/cs5535audio.h      |    4 +++-
 sound/pci/cs5535audio/cs5535audio_olpc.c |   26 +++++++++++++++++++-------
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 834a302..3a57385 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -120,7 +120,7 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 
 /* GPIO assignments */
 
-#define OLPC_GPIO_MIC_AC	geode_gpio(1)
+#define OLPC_GPIO_MIC_AC	1
 #define OLPC_GPIO_DCON_IRQ	geode_gpio(7)
 #define OLPC_GPIO_THRM_ALRM	geode_gpio(10)
 #define OLPC_GPIO_SMB_CLK	geode_gpio(14)
diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index fda7a94..9b5c689 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -4,7 +4,7 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
-ifdef CONFIG_MGEODE_LX
+ifdef CONFIG_GENERIC_GPIO
 snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
 endif
 
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 826e6de..f199bc2 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -389,6 +389,7 @@ probefail_out:
 
 static void __devexit snd_cs5535audio_remove(struct pci_dev *pci)
 {
+	olpc_quirks_cleanup();
 	snd_card_free(pci_get_drvdata(pci));
 	pci_set_drvdata(pci, NULL);
 }
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 7a298ac..51966d7 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -99,10 +99,11 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state);
 int snd_cs5535audio_resume(struct pci_dev *pci);
 #endif
 
-#if defined(CONFIG_OLPC) && defined(CONFIG_MGEODE_LX)
+#ifdef CONFIG_OLPC
 void __devinit olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97);
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+void __devexit olpc_quirks_cleanup(void);
 void olpc_analog_input(struct snd_ac97 *ac97, int on);
 void olpc_mic_bias(struct snd_ac97 *ac97, int on);
 
@@ -128,6 +129,7 @@ static inline int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
 	return 0;
 }
+static inline void olpc_quirks_cleanup(void) { }
 static inline void olpc_analog_input(struct snd_ac97 *ac97, int on) { }
 static inline void olpc_mic_bias(struct snd_ac97 *ac97, int on) { }
 static inline void olpc_capture_open(struct snd_ac97 *ac97) { }
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 5c68143..50da49b 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -13,10 +13,13 @@
 #include <sound/info.h>
 #include <sound/control.h>
 #include <sound/ac97_codec.h>
+#include <linux/gpio.h>
 
 #include <asm/olpc.h>
 #include "cs5535audio.h"
 
+#define DRV_NAME "cs5535audio-olpc"
+
 /*
  * OLPC has an additional feature on top of the regular AD1888 codec features.
  * It has an Analog Input mode that is switched into (after disabling the
@@ -38,10 +41,7 @@ void olpc_analog_input(struct snd_ac97 *ac97, int on)
 	}
 
 	/* set Analog Input through GPIO */
-	if (on)
-		geode_gpio_set(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
-	else
-		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
+	gpio_set_value(OLPC_GPIO_MIC_AC, on);
 }
 
 /*
@@ -73,8 +73,7 @@ static int olpc_dc_info(struct snd_kcontrol *kctl,
 
 static int olpc_dc_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 {
-	v->value.integer.value[0] = geode_gpio_isset(OLPC_GPIO_MIC_AC,
-			GPIO_OUTPUT_VAL);
+	v->value.integer.value[0] = gpio_get_value(OLPC_GPIO_MIC_AC);
 	return 0;
 }
 
@@ -153,6 +152,12 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	if (!machine_is_olpc())
 		return 0;
 
+	if (gpio_request(OLPC_GPIO_MIC_AC, DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME ": unable to allocate MIC GPIO\n");
+		return -EIO;
+	}
+	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
@@ -169,11 +174,18 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	for (i = 0; i < ARRAY_SIZE(olpc_cs5535audio_ctls); i++) {
 		err = snd_ctl_add(card, snd_ctl_new1(&olpc_cs5535audio_ctls[i],
 				ac97->private_data));
-		if (err < 0)
+		if (err < 0) {
+			gpio_free(OLPC_GPIO_MIC_AC);
 			return err;
+		}
 	}
 
 	/* turn off the mic by default */
 	olpc_mic_bias(ac97, 0);
 	return 0;
 }
+
+void __devexit olpc_quirks_cleanup(void)
+{
+	gpio_free(OLPC_GPIO_MIC_AC);
+}
-- 
1.5.6.5

