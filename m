Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0BDVUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:20:21 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46859 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab0BDVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B03w9Qs0tvQk4oof8RUBQsbGQcSrlaxBwTEM/K8AQpsxw5jaHInSB4kMlU33J/D/kZ
         2FzgXUexZthZ0xz9QgZKqdbESBuC2Hmi5WKGNj6ryAYUxEk9yxhPAc7K2s9Jfj9Wpyju
         1HjGKpc/W/2yiUd2kP4k5OZv4dMtK2XQo2HGI=
Message-ID: <4B6B3A0B.1020501@gmail.com>
Date: Thu, 04 Feb 2010 22:20:11 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ice1712: fix: lock samplerate when samplerate locking
 is enabled.
References: <4B69E06E.90308@gmail.com> <s5hzl3p768j.wl%tiwai@suse.de> <4B6B337B.2070904@gmail.com>
In-Reply-To: <4B6B337B.2070904@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Alaiwan wrote:
 Takashi Iwai wrote:
> At Wed, 03 Feb 2010 21:45:34 +0100,
> Sebastien Alaiwan wrote:
>> Hello,
>>
>> I found that the sampling rate locking setting of the ice1712 sound driver was
>> only half-respected : when the driver was locked to, let's say, 44100Hz, and a
>> usermode app was requesting 48000Hz playback, the request was succesful although
>> the soundcard would continue to run at 44100Hz.
>>
>> Here's a patch that will make those requests to fail.
> Thanks, the patch looks OK.  But changing runtime->hw.rate_min and
> rate_max would be cheaper.  It won't involve with kmalloc().
> In theory, snd_pcm_hw_constraint*() can fail.
>
> Could you fix in that way and give your sign-off to merge to the
> upstream?  (And don't forget to add me to Cc.)

Thank you for reviewing my patch. Here's an updated version according to your
advice. You can merge to the upstream if it's okay. Sorry for the double
mail, here's a signed-off version.

Signed-off-by: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
------
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index c7cff6f..319df17 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1180,6 +1180,11 @@ static int snd_ice1712_playback_pro_open(struct snd_pcm_substream *substream)
 	snd_pcm_set_sync(substream);
 	snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE, &hw_constraints_rates);
+	if (is_pro_rate_locked(ice))
+	{
+		runtime->hw.rate_min = PRO_RATE_DEFAULT;
+		runtime->hw.rate_max = PRO_RATE_DEFAULT;
+	}
 
 	if (ice->spdif.ops.open)
 		ice->spdif.ops.open(ice, substream);
@@ -1197,6 +1202,12 @@ static int snd_ice1712_capture_pro_open(struct snd_pcm_substream *substream)
 	snd_pcm_set_sync(substream);
 	snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE, &hw_constraints_rates);
+	if (is_pro_rate_locked(ice))
+	{
+		runtime->hw.rate_min = PRO_RATE_DEFAULT;
+		runtime->hw.rate_max = PRO_RATE_DEFAULT;
+	}
+
 	return 0;
 }
 
