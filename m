Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYKFVuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYKFVuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYKFVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:49:50 -0500
Received: from mail.queued.net ([207.210.101.209]:1268 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYKFVtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:49:49 -0500
Date: Thu, 6 Nov 2008 16:49:46 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7/14] ALSA: cs5535audio: rename OLPC's analog input control
 && drop AD1888's HPF
Message-ID: <20081106164946.1269a970@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously, we had two separate controls; there's no need to have AD1888's
HPF control, so drop it if we're on an OLPC machine.  Also, as per Arjun's
request, rename OLPC's Analog Input Switch control to "DC Mode Enable".

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |   36 +++++++++++++++++------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 01ce4ae..2c148b9 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -31,8 +31,8 @@ void olpc_analog_input(struct snd_ac97 *ac97, int on)
 		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
 }
 
-static int snd_cs5535audio_ctl_info(struct snd_kcontrol *kcontrol, 
-					struct snd_ctl_elem_info *uinfo)
+static int olpc_dc_info(struct snd_kcontrol *kctl,
+		struct snd_ctl_elem_info *uinfo)
 {
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
 	uinfo->count = 1;
@@ -41,35 +41,33 @@ static int snd_cs5535audio_ctl_info(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol, 
-					struct snd_ctl_elem_value *ucontrol)
+static int olpc_dc_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 {
-	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
 	u8 val;
 
 	val = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
 	val >>= AC97_AD_HPFD_SHIFT;
-	ucontrol->value.integer.value[0] = val & 0x1;
+	v->value.integer.value[0] = val & 0x1;
 
 	return 0;
 }
 
-static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol, 
-					struct snd_ctl_elem_value *ucontrol)
+static int olpc_dc_put(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 {
-	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
+	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
 
-	olpc_analog_input(cs5535au->ac97, ucontrol->value.integer.value[0]);
+	olpc_analog_input(cs5535au->ac97, v->value.integer.value[0]);
 	return 1;
 }
 
 static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata = 
 {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Analog Input Switch",
-	.info = snd_cs5535audio_ctl_info,
-	.get = snd_cs5535audio_ctl_get,
-	.put = snd_cs5535audio_ctl_put,
+	.name = "DC Mode Enable",
+	.info = olpc_dc_info,
+	.get = olpc_dc_get,
+	.put = olpc_dc_put,
 	.private_value = 0
 };
 
@@ -86,10 +84,18 @@ void __devinit olpc_prequirks(struct snd_card *card,
 
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
+	struct snd_ctl_elem_id elem;
+
 	if (!machine_is_olpc())
 		return 0;
 
-	/* setup callback for mixer control that does analog input mode */	
+	/* drop the original AD1888 HPF control */
+	memset(&elem, 0, sizeof(elem));
+	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strncpy(elem.name, "High Pass Filter Enable", sizeof(elem.name));
+	snd_ctl_remove_id(card, &elem);
+
+	/* add the override for OLPC's HPF */
 	return snd_ctl_add(card, snd_ctl_new1(&snd_cs5535audio_controls, 
 						ac97->private_data));
 }
-- 
1.5.6.5

