Return-Path: <linux-kernel-owner+w=401wt.eu-S934438AbZLPBxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbZLPBxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZLPBxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:53:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:26845 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbZLPBxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=GCqHG6+fdo7zH3BeHBS6rW/pqDfeNsEgM1hdr+SX14dMy3n2USJ368ylXup7pZRVnW
         XlMoxSnJLhUf/FFX/s//YwaPysf7MtZWS0S89zWqMbXyIjQfqw8BsQo7MQcyyanuc/SL
         72zDZkaeoHggLJii00gbT6FG23cv7AWE8sM7A=
Subject: [PATCH] Fix disable of SPDIF on STAC9766 codec
To: joe@perches.com, alsa-devel@alsa-project.org,
       broonie@opensource.wolfsonmicro.com, clemens@ladisch.de,
       linux-kernel@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Tue, 15 Dec 2009 20:53:44 -0500
Message-ID: <20091216015344.21806.5403.stgit@terra>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change code so that switching to playing music through the analog output disables SPDIF
out instead of disabling it when stream ends.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---
 sound/soc/codecs/stac9766.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/stac9766.c b/sound/soc/codecs/stac9766.c
index bbc72c2..81b8c9d 100644
--- a/sound/soc/codecs/stac9766.c
+++ b/sound/soc/codecs/stac9766.c
@@ -191,6 +191,7 @@ static int ac97_analog_prepare(struct snd_pcm_substream *substream,
 	vra = stac9766_ac97_read(codec, AC97_EXTENDED_STATUS);
 
 	vra |= 0x1; /* enable variable rate audio */
+	vra &= ~0x4; /* disable SPDIF output */
 
 	stac9766_ac97_write(codec, AC97_EXTENDED_STATUS, vra);
 
@@ -221,22 +222,6 @@ static int ac97_digital_prepare(struct snd_pcm_substream *substream,
 	return stac9766_ac97_write(codec, reg, runtime->rate);
 }
 
-static int ac97_digital_trigger(struct snd_pcm_substream *substream,
-				int cmd, struct snd_soc_dai *dai)
-{
-	struct snd_soc_codec *codec = dai->codec;
-	unsigned short vra;
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_STOP:
-		vra = stac9766_ac97_read(codec, AC97_EXTENDED_STATUS);
-		vra &= !0x04;
-		stac9766_ac97_write(codec, AC97_EXTENDED_STATUS, vra);
-		break;
-	}
-	return 0;
-}
-
 static int stac9766_set_bias_level(struct snd_soc_codec *codec,
 				   enum snd_soc_bias_level level)
 {
@@ -315,7 +300,6 @@ static struct snd_soc_dai_ops stac9766_dai_ops_analog = {
 
 static struct snd_soc_dai_ops stac9766_dai_ops_digital = {
 	.prepare = ac97_digital_prepare,
-	.trigger = ac97_digital_trigger,
 };
 
 struct snd_soc_dai stac9766_dai[] = {

