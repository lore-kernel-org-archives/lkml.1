Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbYKRIRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbYKRIRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYKRIQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:16:59 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:5659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:57 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691571"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/8] ASoC: AD1980 codec: add multi-channel function support
Date: Tue, 18 Nov 2008 16:18:16 +0800
Message-Id: <1226996302-10234-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

We added multi-channel function to this codec driver and Blackfin ASoC driver as well.
It was tested on Blackfin hardware.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/codecs/ad1980.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index 1397b8e..410fed9 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -85,6 +85,9 @@ SOC_DOUBLE("Line HP Swap Switch", AC97_AD_MISC, 10, 5, 1, 0),
 SOC_DOUBLE("Surround Playback Volume", AC97_SURROUND_MASTER, 8, 0, 31, 1),
 SOC_DOUBLE("Surround Playback Switch", AC97_SURROUND_MASTER, 15, 7, 1, 1),
 
+SOC_DOUBLE("Center/LFE Playback Volume", AC97_CENTER_LFE_MASTER, 8, 0, 31, 1),
+SOC_DOUBLE("Center/LFE Playback Switch", AC97_CENTER_LFE_MASTER, 15, 7, 1, 1),
+
 SOC_ENUM("Capture Source", ad1980_cap_src),
 
 SOC_SINGLE("Mic Boost Switch", AC97_MIC, 6, 1, 0),
@@ -145,7 +148,7 @@ struct snd_soc_dai ad1980_dai = {
 	.playback = {
 		.stream_name = "Playback",
 		.channels_min = 2,
-		.channels_max = 2,
+		.channels_max = 6,
 		.rates = SNDRV_PCM_RATE_48000,
 		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
 	.capture = {
@@ -192,6 +195,7 @@ static int ad1980_soc_probe(struct platform_device *pdev)
 	struct snd_soc_codec *codec;
 	int ret = 0;
 	u16 vendor_id2;
+	u16 ext_status;
 
 	printk(KERN_INFO "AD1980 SoC Audio Codec\n");
 
@@ -253,9 +257,16 @@ static int ad1980_soc_probe(struct platform_device *pdev)
 				"supported\n");
 	}
 
-	ac97_write(codec, AC97_MASTER, 0x0000); /* unmute line out volume */
-	ac97_write(codec, AC97_PCM, 0x0000);	/* unmute PCM out volume */
-	ac97_write(codec, AC97_REC_GAIN, 0x0000);/* unmute record volume */
+	/* unmute captures and playbacks volume */
+	ac97_write(codec, AC97_MASTER, 0x0000);
+	ac97_write(codec, AC97_PCM, 0x0000);
+	ac97_write(codec, AC97_REC_GAIN, 0x0000);
+	ac97_write(codec, AC97_CENTER_LFE_MASTER, 0x0000);
+	ac97_write(codec, AC97_SURROUND_MASTER, 0x0000);
+
+	/*power on LFE/CENTER/Surround DACs*/
+	ext_status = ac97_read(codec, AC97_EXTENDED_STATUS);
+	ac97_write(codec, AC97_EXTENDED_STATUS, ext_status&~0x3800);
 
 	ad1980_add_controls(codec);
 	ret = snd_soc_register_card(socdev);
-- 
1.5.6.3
