Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZCFHwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZCFHwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZCFHvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:51:25 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:34196 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZCFHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:51:24 -0500
X-IronPort-AV: E=Sophos;i="4.38,313,1233550800"; 
   d="scan'208";a="83886313"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/5] ASoC: Blackfin: fix bug - kernel will crash when record and play in bf527-ezkit
Date: Fri,  6 Mar 2009 15:53:26 +0800
Message-Id: <1236326010-683-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236326010-683-1-git-send-email-cooloney@kernel.org>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

set constraint only if the value is not 0, change the configuring way for sport

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-i2s.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-i2s.c b/sound/soc/blackfin/bf5xx-i2s.c
index d1d95d2..29cd5a4 100644
--- a/sound/soc/blackfin/bf5xx-i2s.c
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -49,7 +49,7 @@ struct bf5xx_i2s_port {
 	u16 rcr1;
 	u16 tcr2;
 	u16 rcr2;
-	int counter;
+	int configured;
 };
 
 static struct bf5xx_i2s_port bf5xx_i2s;
@@ -132,16 +132,6 @@ static int bf5xx_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	return ret;
 }
 
-static int bf5xx_i2s_startup(struct snd_pcm_substream *substream,
-			     struct snd_soc_dai *dai)
-{
-	pr_debug("%s enter\n", __func__);
-
-	/*this counter is used for counting how many pcm streams are opened*/
-	bf5xx_i2s.counter++;
-	return 0;
-}
-
 static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params,
 				struct snd_soc_dai *dai)
@@ -168,7 +158,7 @@ static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
 		break;
 	}
 
-	if (bf5xx_i2s.counter == 1) {
+	if (!bf5xx_i2s.configured) {
 		/*
 		 * TX and RX are not independent,they are enabled at the
 		 * same time, even if only one side is running. So, we
@@ -195,13 +185,6 @@ static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static void bf5xx_i2s_shutdown(struct snd_pcm_substream *substream,
-			       struct snd_soc_dai *dai)
-{
-	pr_debug("%s enter\n", __func__);
-	bf5xx_i2s.counter--;
-}
-
 static int bf5xx_i2s_probe(struct platform_device *pdev,
 			   struct snd_soc_dai *dai)
 {
@@ -219,6 +202,8 @@ static int bf5xx_i2s_probe(struct platform_device *pdev,
 		return -ENODEV;
 	}
 
+	bf5xx_i2s.configured = 1;
+
 	return 0;
 }
 
@@ -305,8 +290,6 @@ struct snd_soc_dai bf5xx_i2s_dai = {
 		.rates = BF5XX_I2S_RATES,
 		.formats = BF5XX_I2S_FORMATS,},
 	.ops = {
-		.startup   = bf5xx_i2s_startup,
-		.shutdown  = bf5xx_i2s_shutdown,
 		.hw_params = bf5xx_i2s_hw_params,
 		.set_fmt = bf5xx_i2s_set_dai_fmt,
 	},
-- 
1.5.6.3
