Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZHBQY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZHBQY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZHBQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:24:26 -0400
Received: from r9dm33.net.upc.cz ([78.102.116.33]:36252 "EHLO
	bimbo.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbZHBQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:24:26 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 12:24:25 EDT
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Lennart Poettering <mzjro@0pointer.net>, stable@kernel.org,
       alsa-devel@alsa-project.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] Tell user that stream to be rewound is suspended
Date: Sun,  2 Aug 2009 18:14:44 +0200
Message-Id: <1249229684-8292-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return STRPIPE instead of EBADF when userspace attempts to rewind
of forward a stream that was suspended in meanwhile, so that it
can be recovered by snd_pcm_recover().

This was causing Pulseaudio to unload the ALSA sink module under a race
condition when it attempted to rewind the stream right after resume from
suspend, before writing to the stream which would cause it to revive the
stream otherwise. Tested to work with Pulseaudio patched to attempt to
snd_pcm_recover() upon receiving an error from snd_pcm_rewind().

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 sound/core/pcm_native.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index ac2150e..d89c816 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2208,6 +2208,9 @@ static snd_pcm_sframes_t snd_pcm_playback_rewind(struct snd_pcm_substream *subst
 	case SNDRV_PCM_STATE_XRUN:
 		ret = -EPIPE;
 		goto __end;
+	case SNDRV_PCM_STATE_SUSPENDED:
+		ret = -ESTRPIPE;
+		goto __end;
 	default:
 		ret = -EBADFD;
 		goto __end;
@@ -2253,6 +2256,9 @@ static snd_pcm_sframes_t snd_pcm_capture_rewind(struct snd_pcm_substream *substr
 	case SNDRV_PCM_STATE_XRUN:
 		ret = -EPIPE;
 		goto __end;
+	case SNDRV_PCM_STATE_SUSPENDED:
+		ret = -ESTRPIPE;
+		goto __end;
 	default:
 		ret = -EBADFD;
 		goto __end;
@@ -2299,6 +2305,9 @@ static snd_pcm_sframes_t snd_pcm_playback_forward(struct snd_pcm_substream *subs
 	case SNDRV_PCM_STATE_XRUN:
 		ret = -EPIPE;
 		goto __end;
+	case SNDRV_PCM_STATE_SUSPENDED:
+		ret = -ESTRPIPE;
+		goto __end;
 	default:
 		ret = -EBADFD;
 		goto __end;
@@ -2345,6 +2354,9 @@ static snd_pcm_sframes_t snd_pcm_capture_forward(struct snd_pcm_substream *subst
 	case SNDRV_PCM_STATE_XRUN:
 		ret = -EPIPE;
 		goto __end;
+	case SNDRV_PCM_STATE_SUSPENDED:
+		ret = -ESTRPIPE;
+		goto __end;
 	default:
 		ret = -EBADFD;
 		goto __end;
-- 
1.6.2.5

