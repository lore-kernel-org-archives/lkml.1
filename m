Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0BDUwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:52:18 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45638 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0BDUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ECFFCHYJIrx9NuIk7tgWofYS4JNkugUCGQ3F+jXTGPkvTT4sUuOoM4fewRf2AYu3ca
         bMAI54HdjS0ATlq7UQlcuVIwUJr/UUKbuZ2jIhVDNF3taKniflfDPv5/Vm+nalg6eYQo
         6JypUeIMWHyMAmNBtRJXdNzc2TeASQFgpnMKQ=
Message-ID: <4B6B337B.2070904@gmail.com>
Date: Thu, 04 Feb 2010 21:52:11 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ice1712: fix: lock samplerate when samplerate locking
 is enabled.
References: <4B69E06E.90308@gmail.com> <s5hzl3p768j.wl%tiwai@suse.de>
In-Reply-To: <s5hzl3p768j.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
> 
> Thanks, the patch looks OK.  But changing runtime->hw.rate_min and
> rate_max would be cheaper.  It won't involve with kmalloc().
> In theory, snd_pcm_hw_constraint*() can fail.
> 
> Could you fix in that way and give your sign-off to merge to the
> upstream?  (And don't forget to add me to Cc.)

Thank you for reviewing my patch. Here's an updated version according to your
advice. You can merge to the upstream if it's okay.

Sebastien Alaiwan

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
 
