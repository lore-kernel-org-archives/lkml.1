Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYHOKzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYHOKzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYHOKzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:55:13 -0400
Received: from s200aog17.obsmtp.com ([207.126.144.131]:57503 "EHLO
	s200aog17.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYHOKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:55:11 -0400
X-Greylist: delayed 1237 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 06:55:11 EDT
Message-Id: <200808151034.CKM57557@mail1.bri.st.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
From: Daniel THOMPSON <daniel.thompson@st.com>
Date: Fri, 15 Aug 2008 10:53:38 +0100
Subject: [PATCH] sound: Fix esoteric double free in the dummy sound driver.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy driver uses runtime->private_free but still frees
its pcm structures on error paths.

This is esoteric because the error paths in question are
unreachable. Thus the bug is only a problem when someone
copies this code into other drivers.

Signed-off-by: Daniel R Thompson <daniel.thompson@st.com>
---
 sound/drivers/dummy.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 4e4c69e..90fc1ce 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -354,6 +354,7 @@ static int snd_card_dummy_playback_open(struct snd_pcm_substream *substream)
 	if ((dpcm = new_pcm_stream(substream)) == NULL)
 		return -ENOMEM;
 	runtime->private_data = dpcm;
+	/* makes the infrastructure responsible for freeing dpcm */
 	runtime->private_free = snd_card_dummy_runtime_free;
 	runtime->hw = snd_card_dummy_playback;
 	if (substream->pcm->device & 1) {
@@ -362,10 +363,8 @@ static int snd_card_dummy_playback_open(struct snd_pcm_substream *substream)
 	}
 	if (substream->pcm->device & 2)
 		runtime->hw.info &= ~(SNDRV_PCM_INFO_MMAP|SNDRV_PCM_INFO_MMAP_VALID);
-	if ((err = add_playback_constraints(runtime)) < 0) {
-		kfree(dpcm);
+	if ((err = add_playback_constraints(runtime)) < 0)
 		return err;
-	}
 
 	return 0;
 }
@@ -379,6 +378,7 @@ static int snd_card_dummy_capture_open(struct snd_pcm_substream *substream)
 	if ((dpcm = new_pcm_stream(substream)) == NULL)
 		return -ENOMEM;
 	runtime->private_data = dpcm;
+	/* makes the infrastructure responsible for freeing dpcm */
 	runtime->private_free = snd_card_dummy_runtime_free;
 	runtime->hw = snd_card_dummy_capture;
 	if (substream->pcm->device == 1) {
@@ -387,10 +387,8 @@ static int snd_card_dummy_capture_open(struct snd_pcm_substream *substream)
 	}
 	if (substream->pcm->device & 2)
 		runtime->hw.info &= ~(SNDRV_PCM_INFO_MMAP|SNDRV_PCM_INFO_MMAP_VALID);
-	if ((err = add_capture_constraints(runtime)) < 0) {
-		kfree(dpcm);
+	if ((err = add_capture_constraints(runtime)) < 0)
 		return err;
-	}
 
 	return 0;
 }
-- 
1.5.5.1

