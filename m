Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbYKFVnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbYKFVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYKFVnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:43:42 -0500
Received: from mail.queued.net ([207.210.101.209]:4005 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKFVnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:43:41 -0500
Date: Thu, 6 Nov 2008 16:43:34 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/14] ALSA: cs5535audio: OLPC analog input support
Message-ID: <20081106164334.1fb8e4f4@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaya Kumar <jayakumar.lkml@gmail.com>

This is a 2nd cut at adding support for OLPC analog input.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/Makefile           |    4 +
 sound/pci/cs5535audio/cs5535audio.c      |    6 ++
 sound/pci/cs5535audio/cs5535audio.h      |    9 +++
 sound/pci/cs5535audio/cs5535audio_olpc.c |  113 ++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 0 deletions(-)
 create mode 100644 sound/pci/cs5535audio/cs5535audio_olpc.c

diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index bb3d57e..3e41fd3 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -5,5 +5,9 @@
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
 
+ifdef CONFIG_OLPC
+snd-cs5535audio-objs += cs5535audio_olpc.o
+endif
+
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 6c886ed..cddfa54 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -171,6 +171,12 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 
 	snd_ac97_tune_hardware(cs5535au->ac97, ac97_quirks, ac97_quirk);
 
+	/* olpc_quirks is dummied out if not olpc */
+	if (( err = olpc_quirks(card, cs5535au->ac97)) < 0) {
+		snd_printk(KERN_ERR "olpc quirks failed\n");
+		return err;
+	}
+
 	return 0;
 }
 
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 1aa1e2b..c67e62f 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -92,6 +92,9 @@ struct cs5535audio {
 	struct snd_pcm_substream *playback_substream;
 	struct snd_pcm_substream *capture_substream;
 	struct cs5535audio_dma dmas[NUM_CS5535AUDIO_DMAS];
+#ifdef CONFIG_OLPC
+	int ec_analog_input_mode;
+#endif
 };
 
 #ifdef CONFIG_PM
@@ -99,6 +102,12 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state);
 int snd_cs5535audio_resume(struct pci_dev *pci);
 #endif
 
+#ifdef CONFIG_OLPC
+int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+#else
+#define olpc_quirks(arg,arg2) (0)
+#endif
+
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
 
 #endif /* __SOUND_CS5535AUDIO_H */
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
new file mode 100644
index 0000000..6d3ccb9
--- /dev/null
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -0,0 +1,113 @@
+#include <linux/olpc.h>
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/info.h>
+#include <sound/control.h>
+#include <sound/ac97_codec.h>
+#include "cs5535audio.h"
+
+/* OLPC has an additional feature on top of regular AD1888 codec
+features. This is support for an analog input mode. This is a 
+2 step process. First, to turn off the AD1888 codec bias voltage
+and high pass filter. Second, to tell the embedded controller to
+reroute from a capacitive trace to a direct trace using an analog
+switch. The *_ec()s are what talk to that controller */
+
+static int snd_cs5535audio_ctl_info(struct snd_kcontrol *kcontrol, 
+					struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 1;
+	return 0;
+}
+
+#define AD1888_VREFOUT_EN_BIT (1 << 2)
+#define AD1888_HPF_EN_BIT (1 << 12)
+static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol, 
+					struct snd_ctl_elem_value *ucontrol)
+{
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
+	u16 reg1, reg2;
+
+	/* if either AD1888 VRef Bias and High Pass Filter are enabled
+	or the EC is not in analog mode then flag as not in analog mode.
+	No EC command to read current analog state so we cache that. */
+	reg1 = snd_ac97_read(cs5535au->ac97, AC97_AD_MISC);
+	reg2 = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
+
+	if ((reg1 & AD1888_VREFOUT_EN_BIT) && (reg2 & AD1888_HPF_EN_BIT) &&
+		cs5535au->ec_analog_input_mode)
+		ucontrol->value.integer.value[0] = 1;
+	else
+		ucontrol->value.integer.value[0] = 0;
+
+	return 0;
+}
+
+static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol, 
+					struct snd_ctl_elem_value *ucontrol)
+{
+	int err;
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
+	u8 value;
+	struct snd_ac97 *ac97 = cs5535au->ac97;
+
+	/* value is 1 if analog input is desired */
+	value = ucontrol->value.integer.value[0];
+
+	/* use ec mode as flag to determine if any change needed */
+	if (cs5535au->ec_analog_input_mode == value) 
+		return 0;
+
+	/* sets High Z on VREF Bias if 1 */
+	if (value) 
+		err = snd_ac97_update_bits(ac97, AC97_AD_MISC, 
+				AD1888_VREFOUT_EN_BIT, AD1888_VREFOUT_EN_BIT);
+	else
+		err = snd_ac97_update_bits(ac97, AC97_AD_MISC, 
+				AD1888_VREFOUT_EN_BIT, 0);
+	if (err < 0)
+		snd_printk(KERN_ERR "Error updating AD_MISC %d\n", err);
+
+	/* turns off High Pass Filter if 1 */
+	if (value)
+		err = snd_ac97_update_bits(ac97, AC97_AD_TEST2, 
+				AD1888_HPF_EN_BIT, AD1888_HPF_EN_BIT);
+	else
+		err = snd_ac97_update_bits(ac97, AC97_AD_TEST2, 
+				AD1888_HPF_EN_BIT, 0);
+	if (err < 0)
+		snd_printk(KERN_ERR "Error updating AD_TEST2 %d\n", err);
+
+	if (value)
+		err = write_ec_command(0x01); /* activate MIC_AC_OFF */
+	else 
+		err = write_ec_command(0x02); /* deactivates MIC_AC_OFF */
+
+	if (err < 0)
+		snd_printk(KERN_ERR "Error talking to EC %d\n", err);
+
+	cs5535au->ec_analog_input_mode = value;
+
+	return 1;
+}
+
+static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata = 
+{
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Analog Input Switch",
+	.info = snd_cs5535audio_ctl_info,
+	.get = snd_cs5535audio_ctl_get,
+	.put = snd_cs5535audio_ctl_put,
+	.private_value = 0
+};
+
+int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
+{
+	/* setup callback for mixer control that does analog input mode */	
+	return snd_ctl_add(card, snd_ctl_new1(&snd_cs5535audio_controls, 
+						ac97->private_data));
+}
+
-- 
1.5.6.5

