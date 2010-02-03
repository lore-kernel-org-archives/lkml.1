Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0BCUpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:45:39 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62671 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab0BCUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:45:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=R1b5wkPvfOQ//0ApXUuRSCF7DBIpxyTGSjnY7DdDQIhuy/VaVup+lLjWgS690vpDbj
         m2Yd90Gd1mu6Fg7JOt05PbMHdPmMlRr777nOTCuyQNNoxgdrTxr44+fNTNK58nW5jVuX
         LSxqjv/AKtxd1iwzxDy8wxg95gxqJK4Bq4lgs=
Message-ID: <4B69E06E.90308@gmail.com>
Date: Wed, 03 Feb 2010 21:45:34 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ice1712: fix: lock samplerate when samplerate locking is
 enabled.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found that the sampling rate locking setting of the ice1712 sound driver was
only half-respected : when the driver was locked to, let's say, 44100Hz, and a
usermode app was requesting 48000Hz playback, the request was succesful although
the soundcard would continue to run at 44100Hz.

Here's a patch that will make those requests to fail.


diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index c7cff6f..4775626 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1181,6 +1181,8 @@ static int snd_ice1712_playback_pro_open(struct snd_pcm_substream *substream)
 	snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE, &hw_constraints_rates);
 
+	if (is_pro_rate_locked(ice))
+		snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_RATE, PRO_RATE_DEFAULT, PRO_RATE_DEFAULT);
 	if (ice->spdif.ops.open)
 		ice->spdif.ops.open(ice, substream);
 
@@ -1197,6 +1199,9 @@ static int snd_ice1712_capture_pro_open(struct snd_pcm_substream *substream)
 	snd_pcm_set_sync(substream);
 	snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE, &hw_constraints_rates);
+	if (is_pro_rate_locked(ice))
+		snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_RATE, PRO_RATE_DEFAULT, PRO_RATE_DEFAULT);
+
 	return 0;
 }
 
