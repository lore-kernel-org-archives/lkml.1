Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZJSMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZJSMmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZJSMmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:42:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54120 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZJSMme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:42:34 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: sameo@linux.intel.com, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 3/4] ASoC: TWL4030: Only update the needed bits in *set_dai_sysclk
Date: Mon, 19 Oct 2009 15:42:19 +0300
Message-Id: <1255956140-4829-4-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 19 Oct 2009 12:42:25.0572 (UTC) FILETIME=[9C58D640:01CA50B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not rewrite the whole register, but only update the needed
bits in set_dai_sysclk functions.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/twl4030.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 4df7c6c..559e9b2 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -1785,19 +1785,21 @@ static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = codec->private_data;
-	u8 infreq;
+	u8 apll_ctrl;
 
+	apll_ctrl = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
+	apll_ctrl &= ~TWL4030_APLL_INFREQ;
 	switch (freq) {
 	case 19200000:
-		infreq = TWL4030_APLL_INFREQ_19200KHZ;
+		apll_ctrl |= TWL4030_APLL_INFREQ_19200KHZ;
 		twl4030->sysclk = 19200;
 		break;
 	case 26000000:
-		infreq = TWL4030_APLL_INFREQ_26000KHZ;
+		apll_ctrl |= TWL4030_APLL_INFREQ_26000KHZ;
 		twl4030->sysclk = 26000;
 		break;
 	case 38400000:
-		infreq = TWL4030_APLL_INFREQ_38400KHZ;
+		apll_ctrl |= TWL4030_APLL_INFREQ_38400KHZ;
 		twl4030->sysclk = 38400;
 		break;
 	default:
@@ -1806,8 +1808,7 @@ static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
-	infreq |= TWL4030_APLL_EN;
-	twl4030_write(codec, TWL4030_REG_APLL_CTL, infreq);
+	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
 
 	return 0;
 }
@@ -1989,11 +1990,13 @@ static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		int clk_id, unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u8 infreq;
+	u8 apll_ctrl;
 
+	apll_ctrl = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
+	apll_ctrl &= ~TWL4030_APLL_INFREQ;
 	switch (freq) {
 	case 26000000:
-		infreq = TWL4030_APLL_INFREQ_26000KHZ;
+		apll_ctrl |= TWL4030_APLL_INFREQ_26000KHZ;
 		break;
 	default:
 		printk(KERN_ERR "TWL4030 voice set sysclk: unknown rate %d\n",
@@ -2001,8 +2004,7 @@ static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
-	infreq |= TWL4030_APLL_EN;
-	twl4030_write(codec, TWL4030_REG_APLL_CTL, infreq);
+	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
 
 	return 0;
 }
-- 
1.6.5.1

