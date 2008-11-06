Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYKFVrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYKFVrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYKFVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:47:10 -0500
Received: from mail.queued.net ([207.210.101.209]:1261 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYKFVrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:47:09 -0500
Date: Thu, 6 Nov 2008 16:47:05 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5/14] ALSA: cs5535audio: decouple HPF from V_REFOUT in OLPC
 code
Message-ID: <20081106164705.754a3044@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We shouldn't be touching V_REFOUT when we toggle HPF/analog input, so just
drop that code.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 16b41d4..ccefd55 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -30,18 +30,11 @@ static int snd_cs5535audio_ctl_get(struct snd_kcontrol *kcontrol,
 					struct snd_ctl_elem_value *ucontrol)
 {
 	struct cs5535audio *cs5535au = snd_kcontrol_chip(kcontrol);
-	u16 reg1, reg2;
+	u8 val;
 
-	/* if either AD1888 VRef Bias and High Pass Filter are enabled
-	or the EC is not in analog mode then flag as not in analog mode.
-	No EC command to read current analog state so we cache that. */
-	reg1 = snd_ac97_read(cs5535au->ac97, AC97_AD_MISC);
-	reg2 = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
-
-	if ((reg1 & AD1888_VREFOUT_EN_BIT) && (reg2 & AD1888_HPF_EN_BIT))
-		ucontrol->value.integer.value[0] = 1;
-	else
-		ucontrol->value.integer.value[0] = 0;
+	val = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
+	val >>= AC97_AD_HPFD_SHIFT;
+	ucontrol->value.integer.value[0] = val & 0x1;
 
 	return 0;
 }
@@ -57,16 +50,6 @@ static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol,
 	/* value is 1 if analog input is desired */
 	value = ucontrol->value.integer.value[0];
 
-	/* sets High Z on VREF Bias if 1 */
-	if (value) 
-		err = snd_ac97_update_bits(ac97, AC97_AD_MISC, 
-				AD1888_VREFOUT_EN_BIT, AD1888_VREFOUT_EN_BIT);
-	else
-		err = snd_ac97_update_bits(ac97, AC97_AD_MISC, 
-				AD1888_VREFOUT_EN_BIT, 0);
-	if (err < 0)
-		snd_printk(KERN_ERR "Error updating AD_MISC %d\n", err);
-
 	/* turns off High Pass Filter if 1 */
 	if (value)
 		err = snd_ac97_update_bits(ac97, AC97_AD_TEST2, 
-- 
1.5.6.5

