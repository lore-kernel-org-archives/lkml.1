Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbYDPQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbYDPQWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762580AbYDPQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:22:07 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:55142 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762138AbYDPQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:22:05 -0400
Message-ID: <48062751.8040309@tiscali.nl>
Date: Wed, 16 Apr 2008 18:20:33 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: perex@perex.cz
CC: alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] sound/drivers/dummy.c: fix negative snd_pcm_format_width()
 check
References: <480558CA.7090800@tiscali.nl>
In-Reply-To: <480558CA.7090800@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bps is unsigned, a negative snd_pcm_format_width() return value is not noticed
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index a240eae..1c88977 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -230,13 +230,14 @@ static int snd_card_dummy_pcm_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_dummy_pcm *dpcm = runtime->private_data;
-	unsigned int bps;
+	int bps;
+
+	bps = snd_pcm_format_width(runtime->format) * runtime->rate *
+		runtime->channels / 8;
 
-	bps = runtime->rate * runtime->channels;
-	bps *= snd_pcm_format_width(runtime->format);
-	bps /= 8;
 	if (bps <= 0)
 		return -EINVAL;
+
 	dpcm->pcm_bps = bps;
 	dpcm->pcm_jiffie = bps / HZ;
 	dpcm->pcm_size = snd_pcm_lib_buffer_bytes(substream);
