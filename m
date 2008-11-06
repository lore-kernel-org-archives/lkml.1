Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYKFVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYKFVvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYKFVuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:50:14 -0500
Received: from mail.queued.net ([207.210.101.209]:1278 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbYKFVuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:50:12 -0500
Date: Thu, 6 Nov 2008 16:50:09 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 9/14] ALSA: cs5535audio: enable OLPC's V_REFOUT bias when
 recording
Message-ID: <20081106165009.25e722f2@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

The OLPC has a privacy light hooked up in series with the microphone's
V_Ref bias.  We want to activate the bias while we are capturing audio.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_pcm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index 6aa0c19..fa2a6b1 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -363,11 +363,27 @@ static int snd_cs5535audio_capture_open(struct snd_pcm_substream *substream)
 	if ((err = snd_pcm_hw_constraint_integer(runtime,
 					 SNDRV_PCM_HW_PARAM_PERIODS)) < 0)
 		return err;
+
+#ifdef CONFIG_OLPC
+	/* Enable the V_ref bias only while recording. */
+	err = snd_ac97_update_bits(cs5535au->ac97, AC97_AD_MISC,
+			1 << AC97_AD_VREFD_SHIFT, 0);
+	if (err < 0)
+		snd_printk(KERN_ERR "Error updating AD_MISC %d\n", err);
+#endif
 	return 0;
 }
 
 static int snd_cs5535audio_capture_close(struct snd_pcm_substream *substream)
 {
+	int err;
+	struct cs5535audio *cs5535au = snd_pcm_substream_chip(substream);
+
+#ifdef CONFIG_OLPC
+	/* Disable V_ref bias. */
+	err = snd_ac97_update_bits(cs5535au->ac97, AC97_AD_MISC,
+			1 << AC97_AD_VREFD_SHIFT, 1 << AC97_AD_VREFD_SHIFT);
+#endif
 	return 0;
 }
 
-- 
1.5.6.5

