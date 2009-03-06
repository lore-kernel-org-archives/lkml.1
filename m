Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZCFHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZCFHvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCFHvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:51:24 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:5018 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZCFHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:51:23 -0500
X-IronPort-AV: E=Sophos;i="4.38,313,1233550800"; 
   d="scan'208";a="83886312"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/5] ASoC: ssm2602 codec: fix bug - kernel will crash when record and play in bf527-ezkit
Date: Fri,  6 Mar 2009 15:53:27 +0800
Message-Id: <1236326010-683-3-git-send-email-cooloney@kernel.org>
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
 sound/soc/codecs/ssm2602.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index cac3736..3fdba6a 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -49,8 +49,8 @@ struct snd_soc_codec_device soc_codec_dev_ssm2602;
 /* codec private data */
 struct ssm2602_priv {
 	unsigned int sysclk;
-	struct snd_pcm_substream *master_substream;
-	struct snd_pcm_substream *slave_substream;
+	unsigned int master_rate;
+	unsigned int master_sample_bits;
 };
 
 /*
@@ -339,31 +339,30 @@ static int ssm2602_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_codec *codec = socdev->codec;
 	struct ssm2602_priv *ssm2602 = codec->private_data;
 	struct i2c_client *i2c = codec->control_data;
-	struct snd_pcm_runtime *master_runtime;
 
 	/* The DAI has shared clocks so if we already have a playback or
 	 * capture going then constrain this substream to match it.
 	 * TODO: the ssm2602 allows pairs of non-matching PB/REC rates
 	 */
-	if (ssm2602->master_substream) {
-		master_runtime = ssm2602->master_substream->runtime;
+	if (ssm2602->master_rate) {
 		dev_dbg(&i2c->dev, "Constraining to %d bits at %dHz\n",
-			master_runtime->sample_bits,
-			master_runtime->rate);
+			ssm2602->master_sample_bits,
+			ssm2602->master_rate);
 
 		snd_pcm_hw_constraint_minmax(substream->runtime,
 					     SNDRV_PCM_HW_PARAM_RATE,
-					     master_runtime->rate,
-					     master_runtime->rate);
-
+ 					     ssm2602->master_rate,
+ 					     ssm2602->master_rate);
+ 	} else
+ 		ssm2602->master_rate = substream->runtime->rate;
+  
+ 	if (ssm2602->master_sample_bits) {
 		snd_pcm_hw_constraint_minmax(substream->runtime,
 					     SNDRV_PCM_HW_PARAM_SAMPLE_BITS,
-					     master_runtime->sample_bits,
-					     master_runtime->sample_bits);
-
-		ssm2602->slave_substream = substream;
+ 					     ssm2602->master_sample_bits,
+ 					     ssm2602->master_sample_bits);
 	} else
-		ssm2602->master_substream = substream;
+ 		ssm2602->master_sample_bits = substream->runtime->sample_bits;
 
 	return 0;
 }
-- 
1.5.6.3
